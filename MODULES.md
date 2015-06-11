## Module Data.These

This module defines a type constructor `These`, which is similar to `Either`,
but with an additional constructor for the case when values of `Both` types
are present.

#### `These`

``` purescript
data These a b
  = This a
  | That b
  | Both a b
```

A data type isomorphic to `α ∨ β ∨ (α ∧ β)`.

A value of type `These a b` can consist of:

- Only a value of type `a`.
- Only a value of type `b`.
- Values of both types.

##### Instances
``` purescript
instance semigroupThese :: (Semigroup a, Semigroup b) => Semigroup (These a b)
instance functorThese :: Functor (These a)
instance foldableThese :: Foldable (These a)
instance traversableThese :: Traversable (These a)
instance bifunctorThese :: Bifunctor These
instance bifoldableThese :: Bifoldable These
instance bitraversableThese :: Bitraversable These
instance applyThese :: (Semigroup a) => Apply (These a)
instance applicativeThese :: (Semigroup a) => Applicative (These a)
instance bindThese :: (Semigroup a) => Bind (These a)
instance monadThese :: (Semigroup a) => Monad (These a)
```

#### `these`

``` purescript
these :: forall a b c. (a -> c) -> (b -> c) -> (a -> b -> c) -> These a b -> c
```

Unpack a value of type `These a b` by applying the appropriate function to
the contained values.

#### `thisOrBoth`

``` purescript
thisOrBoth :: forall a b. a -> Maybe b -> These a b
```

Create a value of type `These a b` which always contains a value of type `a`.

#### `thatOrBoth`

``` purescript
thatOrBoth :: forall a b. b -> Maybe a -> These a b
```

Create a value of type `These a b` which always contains a value of type `b`.

#### `fromThese`

``` purescript
fromThese :: forall a b. a -> b -> These a b -> Tuple a b
```

Unpack a value of type `These a b`, using default values when the value on one
side is missing.

#### `theseLeft`

``` purescript
theseLeft :: forall a b. These a b -> Maybe a
```

Try to extract the left value from a value of type `These a b`.

#### `theseRight`

``` purescript
theseRight :: forall a b. These a b -> Maybe b
```

Try to extract the right value from a value of type `These a b`.


