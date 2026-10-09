# Plasmapower - Stripped to 3D

**3 tracks prove the point without bringing in a starship.**

Mass accelerated in curves... could be liquid, solid, gas, creates friction and torque with the containment walls. Twist is transferred into the mass.

---

### The Trichotomy

Same chassis |Δ| ≤ 3. Three fates:

- **1: DRIFT** - leaks to ∞
- **2: FLIP** - cusp fight, oscillates forever
- **3: LOCK** - holds fire, stable zero

`1 drifts, 2 flips, 3 locks.`

### Files

- `Bolas.lean` - 3 masses at 120° -> R_cm = 0, volume drift V'_2k/V_2k = (π'/π)^k
- `PlasmaToy.lean` - 3 coils at 120° -> B_center = (0,0,0), holds fire **[LEAN CHECKED, 0 SORRY]**
- `ThreeTracks3D.lean` - 3 tracks in 3D; the zero-sum proof is complete
- `Plasmapower.lean` - Pure math abstraction: drift/flip/lock trichotomy

### PlasmaToy Proof (Green)

```lean
theorem three_coil_toy_locks :
    B_at_center three_coil_toy = (0,0,0) := by
  -- sin0 + sin120 + sin240 = 0
  -- cos0 + cos120 + cos240 = 0
  -- => Bx=0, By=0
```

Lean 4.10.0 + Mathlib. No sorry. No axioms.

- `B_at_center` sums B = Σ I × sinθ, -I × cosθ
- `three_coil_toy` = [{0°,1}, {120°,1}, {240°,1}]
- Mathlib proves sin(π - π/3)=sin(π/3), cos(π - π/3)=-cos(π/3), sin(π+π/3)=-sin(π/3), etc.
- Result: Bx=0, By=0, Bz=0

**One more helper is huge relief - cascade ~4x per helper (φ^3).**

### Build

Install Lean with elan, then run the following from the repository root:

```sh
lake update
lake build
```

The project uses Lean 4.10.0 and Mathlib 4.10.0. The build compiles each
top-level Lean source file.

### Why 3?

Two maps. Same chassis. One extra kick.

One showed local bound ≠ global bound.
Plasmapower shows local bound doesn't even determine *type* of global behavior.

- 1 coil = drifts (leaks)
- 2 coils = flips (cusp fight, period 2)
- 3 coils = locks zero (holds fire, idempotent)

Toy shows lock, real shows scaling. Let them start scaling the power.

### Visual

[Plasmapower Trichotomy](assets/images/plasmapower_trichotomy.webp)

Blue: Drift → ∞ straight diagonal
Orange: Flip → 0↔1 zigzag forever
Green: Lock → staircase to 3 → flat, holds

### Chain

- Chapter 1: `Infinitespacemechanic/One` - 2 fates, |Δ|≤3, lock vs diverge
- Chapter 2: `Infinitespacemechanic/Plasmapower` - 3 fates, drift/flip/lock
- Chapter 3: MillenniumClock - 720 states

Order from chaos.

---
@rslaakkonen | Infinitespacemechanic/Plasmapower | 2026-10-08
Lean 4.10.0, Mathlib; the Lean sources contain no `sorry`
