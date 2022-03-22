{ name = "these"
, dependencies =
  [ "arrays"
  , "bifunctors"
  , "console"
  , "control"
  , "effect"
  , "foldable-traversable"
  , "gen"
  , "invariant"
  , "lists"
  , "maybe"
  , "newtype"
  , "prelude"
  , "quickcheck"
  , "quickcheck-laws"
  , "tailrec"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
