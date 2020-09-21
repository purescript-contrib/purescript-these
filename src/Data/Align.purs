module Align where

import Prelude

import Data.Array as A
import Data.Foldable (class Foldable)
import Data.Lazy (force)
import Data.List as List
import Data.List.Lazy as LazyList
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.These (These(..), these)

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

aligned :: forall a b f. Align f => f a -> f b -> f (These a b)
aligned = align identity

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

class (Foldable f, Functor f) <= Crosswalk f where
  crosswalk :: forall t a b. Alignable t => (a -> t b) -> f a -> t (f b)

instance crosswalkThese :: Crosswalk (These a) where
  crosswalk f = case _ of
    This _   -> nil
    That x   -> That <$> f x
    Both a x -> Both a <$> f x

instance crosswalkArray :: Crosswalk Array where
  crosswalk f xs = case A.uncons xs of
    Nothing             -> nil
    Just { head, tail } -> align cons (f head) (crosswalk f tail)
    where
      cons = these pure identity A.cons

instance crosswalkList :: Crosswalk List.List where
  crosswalk f = case _ of
    List.Nil       -> nil
    List.Cons x xs -> align cons (f x) (crosswalk f xs)
    where
      cons = these pure identity List.Cons

-- TODO: Does the `force` defeat the purpose of having an instance for lazy lists?
instance crosswalkLazyList :: Crosswalk LazyList.List where
  crosswalk f l = force $ go <$> unwrap l
    where
      go = case _ of
        LazyList.Nil       -> nil
        LazyList.Cons x xs -> align cons (f x) (crosswalk f xs)
      cons = these pure identity LazyList.cons

instance crosswalkMaybe :: Crosswalk Maybe where
  crosswalk f = case _ of
    Nothing -> nil
    Just a  -> Just <$> f a

