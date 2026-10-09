import Std

-- Plasmapower: 1 drifts, 2 flips, 3 locks
-- Same chassis |Δ| ≤ 3, three fates
-- Lean 4.10.0, no axioms, no sorry

def stepDrift : Nat → Nat
| n => n + 1

def stepFlip : Nat → Nat
| n => if n % 2 == 0 then n + 1 else n - 1

def stepLock : Nat → Nat
| n => if n % 3 == 0 then n else n + (3 - n % 3)

-- Orbits
def orbitDrift : Nat → Nat → Nat
| _, 0 => 0
| n, Nat.succ k => stepDrift (orbitDrift n k)

def orbitFlip : Nat → Nat → Nat
| n, 0 => n
| n, Nat.succ k => stepFlip (orbitFlip n k)

def orbitLock : Nat → Nat → Nat
| n, 0 => n
| n, Nat.succ k => stepLock (orbitLock n k)

-- Theorems

-- Drift: orbitDrift doubles = k, unbounded
theorem orbitDrift_eq (n k : Nat) : orbitDrift n k = k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    simp [orbitDrift, stepDrift, ih]

theorem orbitDrift_unbounded : ∀ (B : Nat), ∃ k, orbitDrift 0 k > B := by
  intro B
  refine ⟨B + 1, ?_⟩
  rw [orbitDrift_eq]
  exact Nat.lt_succ_self B

-- Flip: involutive, period 2, bounded by 1 from start
theorem stepFlip_involutive (n : Nat) : stepFlip (stepFlip n) = n := by
  unfold stepFlip
  by_cases h : n % 2 = 0
  · -- n even => n+1 odd => (n+1)-1 = n
    have h1 : (n + 1) % 2 = 1 := by
      have : n % 2 = 0 → (n + 1) % 2 = 1 := by
        intro he
        have : n = 2 * (n / 2) := by
          have := Nat.div_add_mod n 2
          simp [he] at this ⊢
          omega
        omega
      exact this h
    simp [h, h1]
  · -- n odd => n-1 even => (n-1)+1 = n
    have h1 : n % 2 = 1 := by
      have mod_lt : n % 2 < 2 := Nat.mod_lt n (by omega)
      omega
    have h2 : (n - 1) % 2 = 0 := by
      omega
    simp [h, h2]
    omega

theorem orbitFlip_period_two (n k : Nat) : orbitFlip n (k + 2) = orbitFlip n k := by
  simp [orbitFlip, stepFlip_involutive]

theorem flip_bound (n : Nat) : (stepFlip n ≤ n + 1) ∧ (n ≤ stepFlip n + 1) := by
  unfold stepFlip
  by_cases h : n % 2 = 0 <;> simp [h] <;> omega

theorem orbitFlip_bounded (n k : Nat) : orbitFlip n k ≤ n + 1 ∧ orbitFlip n k + 1 ≥ n := by
  have horbit : orbitFlip n k = n ∨ orbitFlip n k = stepFlip n := by
    induction k with
    | zero => exact Or.inl rfl
    | succ k ih =>
      simp only [orbitFlip]
      rcases ih with h | h
      · rw [h]
        exact Or.inr rfl
      · rw [h]
        exact Or.inl (stepFlip_involutive n)
  rcases horbit with h | h
  · rw [h]
    constructor <;> omega
  · rw [h]
    exact flip_bound n

-- Lock: lands on multiple of 3, idempotent
theorem stepLock_mod_zero (n : Nat) : (stepLock n) % 3 = 0 := by
  unfold stepLock
  by_cases h : n % 3 = 0
  · simp [h]
  · simp [h]
    have hmod : n % 3 < 3 := Nat.mod_lt n (by omega)
    have : n % 3 = 1 ∨ n % 3 = 2 := by omega
    rcases this with h1 | h1 <;> simp [h1] <;> omega

theorem stepLock_idempotent (n : Nat) : stepLock (stepLock n) = stepLock n := by
  by_cases hn : n % 3 = 0
  · simp [stepLock, hn]
  · have hm := stepLock_mod_zero n
    simp [stepLock, hn] at hm
    simp [stepLock, hn, hm]

theorem orbitLock_stable (n k : Nat) (hk : k ≥ 1) : orbitLock n k = stepLock n := by
  cases k with
  | zero => omega
  | succ k =>
    induction k with
    | zero => rfl
    | succ k ih =>
      change stepLock (orbitLock n (Nat.succ k)) = stepLock n
      rw [ih (by omega), stepLock_idempotent]

-- Bound checks: |Δ| ≤ 3
theorem drift_bound (n : Nat) : stepDrift n ≤ n + 3 := by
  change n + 1 ≤ n + 3
  omega

theorem lock_bound (n : Nat) : stepLock n ≤ n + 3 := by
  unfold stepLock
  by_cases h : n % 3 = 0
  · simp [h]
    omega
  · simp [h]
    have : n % 3 = 1 ∨ n % 3 = 2 := by
      have hmod : n % 3 < 3 := Nat.mod_lt n (by omega)
      omega
    omega
