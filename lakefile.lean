import Lake
open Lake DSL

package «plasmapower» where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.19.0"

@[default_target]
lean_lib «Plasmapower» where
  roots := #[`Bolas, `PlasmaToy, `ThreeTracks3D]
