# Plasmapower: Same Chassis, Three Fates

**Author:** Rob Laakkonen / Infinitespacemechanic  
**Date:** 2026-10-08  
**Repo:** Infinitespacemechanic/Plasmapower  
**Status:** Lean-checked, 0 sorry  
**Sequel to:** Infinitespacemechanic/One

---

### Abstract

One proved that with |Δ| ≤ 3, one extra kick turns lock into divergence.

Plasmapower proves the full trichotomy: same |Δ| ≤ 3 chassis supports three distinct global behaviors: drift to infinity, perpetual flip, and lock to zero.

We demonstrate with a physical toy: 3 coils at 120° -> B_center = (0,0,0). The math abstraction is proved in Lean. The physics intuition is 3 tracks that hold fire.

### 1. The Toy Model: PlasmaToy.lean

**Claim:** Three identical coils at 0°, 120°, 240° produce zero net B-field at center.

```
B_at_center = Σ I·sinθ, Σ -I·cosθ
three_coil_toy = [{angle:=0, I:=1}, {2π/3,1}, {4π/3,1}]
Theorem: B_at_center three_coil_toy = (0,0,0)
```

**Proof sketch:**

- sin0 = 0
- sin(2π/3) = sin(π - π/3) = sin(π/3)
- sin(4π/3) = sin(π + π/3) = -sin(π/3) = -sin(2π/3)
- => sin0 + sin120 + sin240 = 0

- cos0 = 1
- cos(2π/3) = cos(π - π/3) = -cos(π/3) = -1/2
- cos(4π/3) = cos(π + π/3) = -cos(π/3) = -1/2
- => cos0 + cos120 + cos240 = 1 -1/2 -1/2 =0

Thus Bx=0, By=0. Lean checks with Real.sin_pi_sub, cos_pi_sub, sin_add_pi, cos_add_pi, cos_pi_div_three.

**Interpretation:**

- 1 coil: B ≠ 0, leaks -> drifts
- 2 coils: B oscillates, cusp fight -> flips (period 2, bounded non-convergent)
- 3 coils: B=0, balanced -> locks (idempotent, stable)

One more helper is huge relief - cascade ~4x per helper (φ^3).

### 2. The Math Abstraction: Plasmapower.lean

Pure discrete version, no trig, same trichotomy:

- stepDrift n = n+1, orbitDrift k = k, unbounded
- stepFlip n = if n%2=0 then n+1 else n-1, involutive, period 2, bounded by 1
- stepLock n = if n%3=0 then n else n+(3-n%3), idempotent, lands on multiple of 3

Theorems:

- orbitDrift_unbounded: ∀ B, ∃ k, orbitDrift k > B
- stepFlip_involutive: stepFlip(stepFlip n)=n
- orbitFlip_period_two, orbitFlip_bounded
- stepLock_mod_zero, stepLock_idempotent
- drift_bound, flip_bound, lock_bound: all |Δ| ≤3

Same bound. Three outcomes. Local bound doesn't determine type.

### 3. Bolas Connection

Bolas.lean: 3 masses at 120° -> R_cm =0, volume drift ratio V'_2k/V_2k = (π'/π)^k

Same symmetry principle: 120° cancels center, creates stable containment.

PlasmaToy = magnetic version of Bolas. One is mass, one is field, same math.

### 4. Visual

Three tracks:

- Blue DRIFT: 0→1→2→3→...→∞ straight diagonal to ∞
- Orange FLIP: 0→1→0→1→0→... zigzag, never locks
- Green LOCK: 1→3→3→3..., 2→3→3→3 staircase to 3 then flat

### 5. Build

```
lake update
lake exe cache get!
lake build
```

PlasmaToy.lean should compile with 0 sorries. Tested on Lean 4.10.0 + Mathlib.

### 6. Chain

- One: 2 fates (lock vs diverge) - shows local bound ≠ global bound
- Plasmapower: 3 fates (drift, flip, lock) - shows local bound doesn't determine type
- MillenniumClock: 720 states (full permutation) - complete control

Toy shows lock, real shows scaling. Let them start scaling the power.

Lean proof + paper + visual: github.com/Infinitespacemechanic/Plasmapower

---
Order from chaos.
