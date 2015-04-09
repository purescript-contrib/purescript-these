module Data.These where

import Data.Bifoldable
import Data.Bifunctor
import Data.Bitraversable
import Data.Foldable
import Data.Maybe
import Data.Monoid
import Data.Traversable
import Data.Tuple

data These a b = This a
               | That b
               | Both a b

instance semigroupThese :: (Semigroup a, Semigroup b) => Semigroup (These a b) where
  (<>) (This a) (This b) = This (a <> b)
  (<>) (This a) (That y) = Both a y
  (<>) (This a) (Both b y) = Both (a <> b) y
  (<>) (That x) (This b) = Both b x
  (<>) (That x) (That y) = That (x <> y)
  (<>) (That x) (Both b y) = Both b (x <> y)
  (<>) (Both a x) (This b) = Both (a <> b) x
  (<>) (Both a x) (That y) = Both a (x <> y)
  (<>) (Both a x) (Both b y) = Both (a <> b) (x <> y)

instance functorThese :: Functor (These a) where
  (<$>) f (Both a b) = Both a (f b)
  (<$>) f (That a) = That (f a)
  (<$>) _ (This a) = This a

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
  (<*>) (This a) _ = This a
  (<*>) (That _) (This b) = This b
  (<*>) (That f) (That x) = That (f x)
  (<*>) (That f) (Both b x) = Both b (f x)
  (<*>) (Both a _) (This b) = This (a <> b)
  (<*>) (Both a f) (That x) = Both a (f x)
  (<*>) (Both a f) (Both b x) = Both (a <> b) (f x)

instance applicativeThese :: (Semigroup a) => Applicative (These a) where
  pure = That

instance bindThese :: (Semigroup a) => Bind (These a) where
  (>>=) (This a) _ = This a
  (>>=) (That x) k = k x
  (>>=) (Both a x) k = case k x of
                         This b -> This (a <> b)
                         That y -> Both a y
                         Both b y -> Both (a <> b) y

instance monadThese :: (Semigroup a) => Monad (These a)

these :: forall a b c. (a -> c) -> (b -> c) -> (a -> b -> c) -> These a b -> c
these l _ _ (This a) = l a
these _ r _ (That x) = r x
these _ _ lr (Both a x) = lr a x

fromThese :: forall a b. a -> b -> These a b -> Tuple a b
fromThese _ x (This a)   = Tuple a x
fromThese a _ (That x)   = Tuple a x
fromThese _ _ (Both a x) = Tuple a x

theseLeft :: forall a b. These a b -> Maybe a
theseLeft (Both x _) = Just x
theseLeft (This x)   = Just x
theseLeft _          = Nothing

theseRight :: forall a b. These a b -> Maybe b
theseRight (Both _ x) = Just x
theseRight (That x)   = Just x
theseRight _          = Nothing
