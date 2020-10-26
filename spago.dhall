{ name = "these"
, dependencies = [ "console", "effect", "gen", "psci-support", "tuples", "arrays", "lists", "quickcheck", "quickcheck-laws" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
