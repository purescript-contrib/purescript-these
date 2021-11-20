module Data.Align where

import Prelude

import Data.Array as A
import Data.Foldable (class Foldable)
import Data.List as List
import Data.List.Lazy as LazyList
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.These (These(..), these)

-- | The `Align` type class represents an operation similar to `Apply` with
-- | slightly different semantics. For example:
-- |
-- | ```purescript
-- | > align identity (Just 1) Nothing :: These Int Int
-- | This 1
-- | ```
-- |
-- | Instances are required to satisfy the following laws:
-- |
-- | - Idempotency: `join (align identity) == map (join These)`
-- | - Commutativity `align identity x y == swap <$> align identity y x`
-- | - Associativity `align identity x (align identity y z) == assoc <$> align identity (align identity x y) z`
-- | - Functoriality `align identity (f <$> x) (g <$> y) ≡ bimap f g <$> align identity x y`
class (Functor f) <= Align f where
  align :: forall a b c. (These a b -> c) -> f a -> f b -> f c

instance alignArray :: Align Array where
  align f xs [] = f <<< This <$> xs
  align f [] ys = f <<< That <$> ys
  align f xs ys = A.zipWith f' xs ys <> align f xs' ys'
    where
    f' x y = f (Both x y)
    xs' = A.drop (A.length ys) xs
    ys' = A.drop (A.length xs) ys

instance alignList :: Align List.List where
  align f xs List.Nil = f <<< This <$> xs
  align f List.Nil ys = f <<< That <$> ys
  align f (List.Cons x xs) (List.Cons y ys) = f (Both x y) `List.Cons` align f xs ys

instance alignLazyList :: Align LazyList.List where
  align f xs ys = LazyList.List $ go <$> unwrap xs <*> unwrap ys
    where
    go LazyList.Nil LazyList.Nil = LazyList.Nil
    go (LazyList.Cons x xs') LazyList.Nil = f (This x) `LazyList.Cons` align f xs' mempty
    go LazyList.Nil (LazyList.Cons y ys') = f (That y) `LazyList.Cons` align f mempty ys'
    go (LazyList.Cons x xs') (LazyList.Cons y ys') = f (Both x y) `LazyList.Cons` align f xs' ys'

instance alignMaybe :: Align Maybe where
  align f ma Nothing = f <<< This <$> ma
  align f Nothing mb = f <<< That <$> mb
  align f (Just a) (Just b) = Just $ f (Both a b)

-- | Convenience combinator for `align identity`.
aligned :: forall a b f. Align f => f a -> f b -> f (These a b)
aligned = align identity

-- | `Alignable` adds an identity value for the `align` operation.
-- |
-- | Instances are required to satisfy the following laws:
-- |
-- | - Left Identity: `align identity nil x == fmap That x`
-- | - Right Identity: `align identity x nil ≡ fmap This x`
class (Align f) <= Alignable f where
  nil :: forall a. f a

instance alignableArray :: Alignable Array where
  nil = mempty

instance alignableList :: Alignable List.List where
  nil = mempty

instance alignableLazyList :: Alignable LazyList.List where
  nil = mempty

instance alignableMaybe :: Alignable Maybe where
  nil = Nothing

-- | `Crosswalk` is similar to `Traversable`, but uses the `Align`/`Alignable`
-- | semantics instead of `Apply`/`Applicative` for combining values.
-- |
-- | For example:
-- | ```purescript
-- | > traverse Int.fromString ["1", "2", "3"]
-- | Just [1, 2, 3]
-- | > crosswalk Int.fromString ["1", "2", "3"]
-- | Just [1, 2, 3]
-- |
-- | > traverse Int.fromString ["a", "b", "c"]
-- | Nothing
-- | > crosswalk Int.fromString ["a", "b", "c"]
-- | Nothing
-- |
-- | > traverse Int.fromString ["1", "b", "3"]
-- | Nothing
-- | > crosswalk Int.fromString ["1", "b", "3"]
-- | Just [1, 3]
-- |
-- | > traverse Int.fromString []
-- | Just []
-- | > crosswalk Int.fromString []
-- | Nothing
-- | ```
-- |
-- | Instances are required to satisfy the following laws:
-- |
-- | - Annihilation: `crosswalk (const nil) == const nil`
class (Foldable f, Functor f) <= Crosswalk f where
  crosswalk :: forall t a b. Alignable t => (a -> t b) -> f a -> t (f b)

instance crosswalkThese :: Crosswalk (These a) where
  crosswalk f = case _ of
    This _ -> nil
    That x -> That <$> f x
    Both a x -> Both a <$> f x

instance crosswalkArray :: Crosswalk Array where
  crosswalk f xs = case A.uncons xs of
    Nothing -> nil
    Just { head, tail } -> align cons (f head) (crosswalk f tail)
    where
    cons = these pure identity A.cons

instance crosswalkList :: Crosswalk List.List where
  crosswalk f = case _ of
    List.Nil -> nil
    List.Cons x xs -> align cons (f x) (crosswalk f xs)
    where
    cons = these pure identity List.Cons

instance crosswalkLazyList :: Crosswalk LazyList.List where
  crosswalk f l =
    case LazyList.step l of
      LazyList.Nil -> nil
      LazyList.Cons x xs -> align cons (f x) (crosswalk f xs)
    where
    cons = these pure identity LazyList.cons

instance crosswalkMaybe :: Crosswalk Maybe where
  crosswalk f = case _ of
    Nothing -> nil
    Just a -> Just <$> f a

