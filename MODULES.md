# Module Documentation

## Module Data.These

#### `These`

``` purescript
data These a b
  = This a
  | That b
  | Both a b
```


#### `semigroupThese`

``` purescript
instance semigroupThese :: (Semigroup a, Semigroup b) => Semigroup (These a b)
```


#### `functorThese`

``` purescript
instance functorThese :: Functor (These a)
```


#### `foldableThese`

``` purescript
instance foldableThese :: Foldable (These a)
```


#### `traversableThese`

``` purescript
instance traversableThese :: Traversable (These a)
```


#### `bifunctorThese`

``` purescript
instance bifunctorThese :: Bifunctor These
```


#### `bifoldableThese`

``` purescript
instance bifoldableThese :: Bifoldable These
```


#### `bitraversableThese`

``` purescript
instance bitraversableThese :: Bitraversable These
```


#### `applyThese`

``` purescript
instance applyThese :: (Semigroup a) => Apply (These a)
```


#### `applicativeThese`

``` purescript
instance applicativeThese :: (Semigroup a) => Applicative (These a)
```


#### `bindThese`

``` purescript
instance bindThese :: (Semigroup a) => Bind (These a)
```


#### `monadThese`

``` purescript
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




