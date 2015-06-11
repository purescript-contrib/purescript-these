-- | This module defines a type constructor `These`, which is similar to `Either`,
-- | but with an additional constructor for the case when values of `Both` types
-- | are present.

module Data.These where

import Data.Bifoldable
import Data.Bifunctor
import Data.Bitraversable
import Data.Foldable
import Data.Maybe
import Data.Monoid
import Data.Traversable
import Data.Tuple

import Prelude
  ( ($)
  , (<$>)
  , (<*>)
  , (<<<)
  , (<>)
  , Applicative
  , Apply
  , Bind
  , Functor
  , Monad
  , Semigroup
  , pure
  , id )

-- | A data type isomorphic to `α ∨ β ∨ (α ∧ β)`.
-- |
-- | A value of type `These a b` can consist of:
-- |
-- | - Only a value of type `a`.
-- | - Only a value of type `b`.
-- | - Values of both types.
data These a b = This a
               | That b
               | Both a b

instance semigroupThese :: (Semigroup a, Semigroup b) => Semigroup (These a b) where
  append (This a) (This b) = This (a <> b)
  append (This a) (That y) = Both a y
  append (This a) (Both b y) = Both (a <> b) y
  append (That x) (This b) = Both b x
  append (That x) (That y) = That (x <> y)
  append (That x) (Both b y) = Both b (x <> y)
  append (Both a x) (This b) = Both (a <> b) x
  append (Both a x) (That y) = Both a (x <> y)
  append (Both a x) (Both b y) = Both (a <> b) (x <> y)

instance functorThese :: Functor (These a) where
  map f (Both a b) = Both a (f b)
  map f (That a) = That (f a)
  map _ (This a) = This a

instance foldableThese :: Foldable (These a) where
  foldr f z = foldr f z <<< theseRight
  foldl f z = foldl f z <<< theseRight
  foldMap f = foldMap f <<< theseRight

instance traversableThese :: Traversable (These a) where
  traverse _ (This a) = pure $ This a
  traverse f (That x) = That <$> f x
  traverse f (Both a x) = Both a <$> f x
  sequence (This a) = pure $ This a
  sequence (That x) = That <$> x
  sequence (Both a x) = Both a <$> x

instance bifunctorThese :: Bifunctor These where
  bimap f _ (This a) = This (f a)
  bimap _ g (That x) = That (g x)
  bimap f g (Both a x) = Both (f a) (g x)

instance bifoldableThese :: Bifoldable These where
  bifoldr f g z = these (`f` z) (`g` z) (\x y -> x `f` (y `g` z))
  bifoldl f g z = these (z `f`) (z `g`) (\x y -> (z `f` x) `g` y)
  bifoldMap f g = these f g (\x y -> f x <> g y)

instance bitraversableThese :: Bitraversable These where
  bitraverse f _ (This a) = This <$> f a
  bitraverse _ g (That x) = That <$> g x
  bitraverse f g (Both a x) = Both <$> f a <*> g x
  bisequence = bitraverse id id

instance applyThese :: (Semigroup a) => Apply (These a) where
  apply (This a) _ = This a
  apply (That _) (This b) = This b
  apply (That f) (That x) = That (f x)
  apply (That f) (Both b x) = Both b (f x)
  apply (Both a _) (This b) = This (a <> b)
  apply (Both a f) (That x) = Both a (f x)
  apply (Both a f) (Both b x) = Both (a <> b) (f x)

instance applicativeThese :: (Semigroup a) => Applicative (These a) where
  pure = That

instance bindThese :: (Semigroup a) => Bind (These a) where
  bind (This a) _ = This a
  bind (That x) k = k x
  bind (Both a x) k = case k x of
                         This b -> This (a <> b)
                         That y -> Both a y
                         Both b y -> Both (a <> b) y

instance monadThese :: (Semigroup a) => Monad (These a)

-- | Unpack a value of type `These a b` by applying the appropriate function to
-- | the contained values.
these :: forall a b c. (a -> c) -> (b -> c) -> (a -> b -> c) -> These a b -> c
these l _ _ (This a) = l a
these _ r _ (That x) = r x
these _ _ lr (Both a x) = lr a x

-- | Create a value of type `These a b` which always contains a value of type `a`.
thisOrBoth :: forall a b. a -> Maybe b -> These a b
thisOrBoth a Nothing = This a
thisOrBoth a (Just b) = Both a b

-- | Create a value of type `These a b` which always contains a value of type `b`.
thatOrBoth :: forall a b. b -> Maybe a -> These a b
thatOrBoth b Nothing = That b
thatOrBoth b (Just a) = Both a b

-- | Unpack a value of type `These a b`, using default values when the value on one
-- | side is missing.
fromThese :: forall a b. a -> b -> These a b -> Tuple a b
fromThese _ x (This a)   = Tuple a x
fromThese a _ (That x)   = Tuple a x
fromThese _ _ (Both a x) = Tuple a x

-- | Try to extract the left value from a value of type `These a b`.
theseLeft :: forall a b. These a b -> Maybe a
theseLeft (Both x _) = Just x
theseLeft (This x)   = Just x
theseLeft _          = Nothing

-- | Try to extract the right value from a value of type `These a b`.
theseRight :: forall a b. These a b -> Maybe b
theseRight (Both _ x) = Just x
theseRight (That x)   = Just x
theseRight _          = Nothing
