module Test.QuickCheck.Laws.Control.Alignable where

import Prelude

import Data.Align (class Alignable, align, nil)
import Data.These (These(..))
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (quickCheck')
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Laws (A, B)
import Type.Proxy (Proxy)

-- | Instances are required to satisfy the following laws:
-- |
-- | - Left Identity: `align identity nil x == fmap That x`
-- | - Right Identity: `align identity x nil ≡ fmap This x`
checkAlignable
  :: forall f
   . Alignable f
  => Arbitrary (f A)
  => Arbitrary (f B)
  => Eq (f (These A B))
  => Proxy f
  -> Effect Unit
checkAlignable _ = do

  log "Checking 'Left Identity' law for Alignable"
  quickCheck' 1000 leftIdentity
  log "Checking 'Right Identity' law for Alignable"
  quickCheck' 1000 rightIdentity

  where

  leftIdentity :: f B -> Boolean
  leftIdentity fb = align identity (nil :: f A) fb == map That fb

  rightIdentity :: f A -> Boolean
  rightIdentity fa = align identity fa (nil :: f B) == map This fa
