module Data.These where

import Prelude

import Control.Extend (class Extend)

import Data.Bifunctor (class Bifunctor)
import Data.Bitraversable (class Bitraversable, class Bifoldable, bitraverse)
import Data.Functor.Invariant (class Invariant, imapF)
import Data.Generic (class Generic)
import Data.Maybe (Maybe(..))
import Data.Traversable (class Traversable, class Foldable, foldMap, foldl, foldr)
import Data.Tuple (Tuple(..))

data These a b
  = This a
  | That b
  | Both a b

derive instance eqThese :: (Eq a, Eq b) => Eq (These a b)
derive instance ordThese :: (Ord a, Ord b) => Ord (These a b)
derive instance genericThese :: (Generic a, Generic b) => Generic (These a b)

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

instance invariantThese :: Invariant (These a) where
  imap = imapF

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
  bifoldr f g z = these (_ `f` z) (_ `g` z) (\x y -> x `f` (y `g` z))
  bifoldl f g z = these (z `f` _) (z `g` _) (\x y -> (z `f` x) `g` y)
  bifoldMap f g = these f g (\x y -> f x <> g y)

instance bitraversableThese :: Bitraversable These where
  bitraverse f _ (This a) = This <$> f a
  bitraverse _ g (That x) = That <$> g x
  bitraverse f g (Both a x) = Both <$> f a <*> g x
  bisequence = bitraverse id id

instance applyThese :: Semigroup a => Apply (These a) where
  apply (This a) _ = This a
  apply (That _) (This b) = This b
  apply (That f) (That x) = That (f x)
  apply (That f) (Both b x) = Both b (f x)
  apply (Both a _) (This b) = This (a <> b)
  apply (Both a f) (That x) = Both a (f x)
  apply (Both a f) (Both b x) = Both (a <> b) (f x)

instance applicativeThese :: Semigroup a => Applicative (These a) where
  pure = That

instance bindThese :: Semigroup a => Bind (These a) where
  bind (This a) _ = This a
  bind (That x) k = k x
  bind (Both a x) k =
    case k x of
      This b -> This (a <> b)
      That y -> Both a y
      Both b y -> Both (a <> b) y

instance monadThese :: Semigroup a => Monad (These a)

instance extendEither :: Extend (These a) where
  extend _ (This a) = This a
  extend f x = map (const (f x)) x

instance showThese :: (Show a, Show b) => Show (These a b) where
  show (This x) = "(This " <> show x <> ")"
  show (That y) = "(That " <> show y <> ")"
  show (Both x y) = "(Both " <> show x <> " " <> show y <> ")"

these :: forall a b c. (a -> c) -> (b -> c) -> (a -> b -> c) -> These a b -> c
these l _ _ (This a) = l a
these _ r _ (That x) = r x
these _ _ lr (Both a x) = lr a x

thisOrBoth :: forall a b. a -> Maybe b -> These a b
thisOrBoth a Nothing = This a
thisOrBoth a (Just b) = Both a b

thatOrBoth :: forall a b. b -> Maybe a -> These a b
thatOrBoth b Nothing = That b
thatOrBoth b (Just a) = Both a b

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
