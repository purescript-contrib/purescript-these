module Test.QuickCheck.Laws.Control.Align where

import Prelude

import Data.Align (class Align, align)
import Data.Bifunctor (bimap)
import Data.These (These(..), assoc, swap)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (quickCheck')
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Laws (A, B, C, D)
import Type.Proxy (Proxy)

-- | Instances are required to satisfy the following laws:
-- |
-- | - Idempotency: `join (align identity) == map (join These)`
-- | - Commutativity `align identity x y == swap <$> align identity y x`
-- | - Associativity `align identity x (align identity y z) == assoc <$> align identity (align identity x y) z`
-- | - Functoriality `align identity (f <$> x) (g <$> y) ≡ bimap f g <$> align identity x y`
checkAlign
  :: forall f
   . Align f
  => Arbitrary (f A)
  => Arbitrary (f B)
  => Arbitrary (f C)
  => Eq (f (These A A))
  => Eq (f (These A B))
  => Eq (f (These C D))
  => Eq (f (These A (These B C)))
  => Proxy f
  -> Effect Unit
checkAlign _ = do

  log "Checking 'Idempotency' law for Align"
  quickCheck' 1000 idempotency

  log "Checking 'Commutativity' law for Align"
  quickCheck' 1000 commutativity

  log "Checking 'Associativity' law for Align"
  quickCheck' 1000 associativity

  log "Checking 'Functoriality' law for Align"
  quickCheck' 1000 functoriality

  where

  idempotency :: f A -> Boolean
  idempotency fa = join (align identity) fa == map (join Both) fa

  commutativity :: f A -> f B -> Boolean
  commutativity fa fb = align identity fa fb == (swap <$> align identity fb fa)

  associativity :: f A -> f B -> f C -> Boolean
  associativity fa fb fc =
    align identity fa (align identity fb fc) ==
      (assoc <$> align identity (align identity fa fb) fc)

  functoriality :: f A -> f B -> (A -> C) -> (B -> D) -> Boolean
  functoriality a b f g =
    align identity (f <$> a) (g <$> b) ==
      (bimap f g <$> align identity a b)
