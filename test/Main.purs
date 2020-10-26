module Test.Main where

import Prelude

import Data.Align (class Crosswalk)
import Data.List (List)
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Laws (A)
import Test.QuickCheck.Laws.Control.Align (checkAlign)
import Test.QuickCheck.Laws.Control.Alignable (checkAlignable)
import Test.QuickCheck.Laws.Control.Crosswalk (checkCrosswalk)
import Type.Proxy (Proxy2(..))

runCrosswalkChecksFor
    :: forall f
    .  Crosswalk f
    => Arbitrary (f A)
    => Eq (f A)
    => Proxy2 f
    -> String
    -> Effect Unit
runCrosswalkChecksFor p name = do
  log $ "Check Crosswalk instance for " <> name <> "/Array"
  checkCrosswalk p (Proxy2 :: _ Array)
  log $ "Check Crosswalk instance for " <> name <> "/Maybe"
  checkCrosswalk p (Proxy2 :: _ Maybe)
  log $ "Check Crosswalk instance for " <> name <> "/List"
  checkCrosswalk p (Proxy2 :: _ List)

main :: Effect Unit
main = do
  log "Checking Align instance for Array"
  checkAlign (Proxy2 :: _ Array)
  log "Checking Align instance for List"
  checkAlign (Proxy2 :: _ List)
  log "Checking Align instance for Maybe"
  checkAlign (Proxy2 :: _ Maybe)

  log "Check Alignable instance for Array"
  checkAlignable (Proxy2 :: _ Array)
  log "Checking Alignable instance for List"
  checkAlignable (Proxy2 :: _ List)
  log "Checking Alignable instance for Maybe"
  checkAlignable (Proxy2 :: _ Maybe)

  runCrosswalkChecksFor (Proxy2 :: _ Array) "Array"
  runCrosswalkChecksFor (Proxy2 :: _ Maybe) "Maybe"
  runCrosswalkChecksFor (Proxy2 :: _ List)  "List"
