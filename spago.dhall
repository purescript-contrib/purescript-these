{ name = "these"
, dependencies = [ "console", "effect", "gen", "psci-support", "tuples" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
