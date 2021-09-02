{ name = "these"
, dependencies =
  [ "arrays"
  , "bifunctors"
  , "control"
  , "foldable-traversable"
  , "gen"
  , "invariant"
  , "lists"
  , "maybe"
  , "newtype"
  , "prelude"
  , "psci-support"
  , "tailrec"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
