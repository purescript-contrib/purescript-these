{ name = "these"
, dependencies = [ "console", "effect", "gen", "psci-support", "tuples", "arrays", "lists" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
