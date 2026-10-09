# Plasmapower: 1 Drifts, 2 Flips, 3 Locks

**Author:** Rob Laakkonen / Infinitespacemechanic  
**Date:** 2026-10-08  
**Repo:** Infinitespacemechanic/Plasmapower  
**Sequel to:** Infinitespacemechanic/One  
**Tool:** Lean 4.10.0

---

### Abstract

One showed that one extra kick turns lock into divergence.

Plasmapower shows that on the same chassis with |Δ| ≤ 3, there are three distinct fates: drift to infinity, flip forever, lock forever.

Same bound. Three outcomes.

### 1. The Chassis

All three maps satisfy |step(n) - n| ≤ 3.

### 2. The Three Maps

#### 1 — Drift
```lean
def stepDrift n := n + 1
```
Trace: 0 → 1 → 2 → 3 → ... → ∞  
Fate: Unbounded, monotonic

#### 2 — Flip
```lean
def stepFlip n := if n % 2 = 0 then n + 1 else n - 1
```
Trace: 0 → 1 → 0 → 1 → 0 → ...  
Fate: Bounded, period 2, never locks. Involutive: stepFlip(stepFlip n) = n

#### 3 — Lock
```lean
def stepLock n := if n % 3 = 0 then n else n + (3 - n % 3)
```
Trace: 1 → 3 → 3 → 3 ..., 2 → 3 → 3 ...  
Fate: Bounded, idempotent. Lands on multiple of 3 and stays.

### 3. Theorems

- `orbitDrift_unbounded`: ∀ B, ∃ k, orbitDrift k > B
- `stepFlip_involutive`: stepFlip(stepFlip n) = n, period 2
- `orbitFlip_bounded`: orbit stays within [n-1, n+1]
- `stepLock_mod_zero`: (stepLock n) % 3 = 0
- `stepLock_idempotent`: stepLock(stepLock n) = stepLock n
- `drift_bound, flip_bound, lock_bound`: All satisfy |Δ| ≤ 3

### 4. Why It Matters

One proved local bound ≠ global bound.

Plasmapower proves local bound doesn't even determine the *type* of global behavior. Same local rule can drift, flip, or lock.

This is the trichotomy that powers the next layers:

- One: 2 fates (lock vs diverge)
- Plasmapower: 3 fates (drift, flip, lock)
- MillenniumClock: 720 states (full permutation)

### 5. Build

The repository includes a Lake configuration and `lean-toolchain` for Lean
4.10.0 with Mathlib 4.10.0. From the repository root, run `lake update` and
`lake build` to compile the Lean sources.

File: `Plasmapower.lean` — no axioms, no sorry.

### 6. Visual

Three tracks:
- Blue: Drift — diagonal to ∞
- Orange: Flip — zigzag 0↔1 forever
- Green: Lock — staircase to multiple of 3 then flat

Same chassis. Three destinies.

Lean proof + paper: github.com/Infinitespacemechanic/Plasmapower
