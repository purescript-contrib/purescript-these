module Test.QuickCheck.Laws.Control.Crosswalk where

import Prelude

import Data.Align (class Alignable, class Crosswalk, crosswalk, nil)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (quickCheck')
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Laws (A)
import Type.Proxy (Proxy)

-- | Instances are required to satisfy the following laws:
-- |
-- | - Annihilation: `crosswalk (const nil) == const nil`
checkCrosswalk
  :: forall f t
   . Crosswalk f
  => Alignable t
  => Arbitrary (f A)
  => Eq (t (f A))
  => Proxy f
  -> Proxy t
  -> Effect Unit
checkCrosswalk _ _ = do

  log "Checking 'Annihilation' law for Crosswalk"
  quickCheck' 1000 annihilation

  where

  annihilation :: f A -> Boolean
  annihilation fa = crosswalk (const (nil :: t A)) fa == nil
