module Data.These.Gen where

import Prelude

import Control.Monad.Gen (class MonadGen, filtered)
import Control.Monad.Gen.Common (genMaybe)
import Control.Monad.Rec.Class (class MonadRec)
import Data.These (These, maybeThese)

genThese ∷ forall m a b. MonadGen m => MonadRec m => m a -> m b -> m (These a b)
genThese ga gb = filtered (maybeThese <$> genMaybe ga <*> genMaybe gb)
