## Module Data.These

#### `These`

``` purescript
data These a b
  = This a
  | That b
  | Both a b
```

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

#### `thisOrBoth`

``` purescript
thisOrBoth :: forall a b. a -> Maybe b -> These a b
```

#### `thatOrBoth`

``` purescript
thatOrBoth :: forall a b. b -> Maybe a -> These a b
```

#### `fromThese`

``` purescript
fromThese :: forall a b. a -> b -> These a b -> Tuple a b
```

#### `theseLeft`

``` purescript
theseLeft :: forall a b. These a b -> Maybe a
```

#### `theseRight`

``` purescript
theseRight :: forall a b. These a b -> Maybe b
```


