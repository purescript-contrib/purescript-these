# Module Documentation

## Module Data.These

#### `These`

``` purescript
data These a b
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




