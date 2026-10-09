/-
Bolas.lean - Order from chaos: 3 locks zero
Toy proof: 1 drifts, 2 flips, 3 locks
-/
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Nat.Factorial.Basic

noncomputable section

def phi : ℝ := (1 + Real.sqrt 5) / 2
def pi_golden : ℝ := 4 / Real.sqrt phi
def pi_euler : ℝ := Real.pi

def V_euler (n : ℕ) (R : ℝ) : ℝ := Real.pi ^ (n/2) / Nat.factorial (n/2) * R ^ n
def V_golden (n : ℕ) (R : ℝ) : ℝ := pi_golden ^ (n/2) / Nat.factorial (n/2) * R ^ n

-- Core: volume ratio = (π'/π)^k
theorem volume_drift (k : ℕ) (R : ℝ) (hR : R > 0) :
    V_golden (2*k) R / V_euler (2*k) R = (pi_golden / pi_euler) ^ k := by
  unfold V_golden V_euler pi_euler
  have hdiv : (2 * k) / 2 = k := Nat.mul_div_cancel_left k (by norm_num : 0 < 2)
  simp only [hdiv]
  have hfact : (Nat.factorial k : ℝ) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k)
  have hpi_pow : (Real.pi : ℝ) ^ k ≠ 0 :=
    pow_ne_zero _ Real.pi_ne_zero
  -- non-zero denominators for field_simp
  have h1 : (↑(Nat.factorial k) : ℝ) ≠ 0 := hfact
  field_simp
  ring

-- 3-mass Bolas minimum: R_cm = 0 locks
structure Bolas where
  m : Fin 3 → ℝ
  pos : Fin 3 → ℝ × ℝ × ℝ

def R_cm (b : Bolas) : ℝ × ℝ × ℝ :=
  let Mx := (b.m 0 * (b.pos 0).1 + b.m 1 * (b.pos 1).1 + b.m 2 * (b.pos 2).1)
  let My := (b.m 0 * (b.pos 0).2.1 + b.m 1 * (b.pos 1).2.1 + b.m 2 * (b.pos 2).2.1)
  let Mz := (b.m 0 * (b.pos 0).2.2 + b.m 1 * (b.pos 1).2.2 + b.m 2 * (b.pos 2).2.2)
  let M := b.m 0 + b.m 1 + b.m 2
  (Mx / M, My / M, Mz / M)

-- 120° locked configuration: cos0+cos120+cos240=0, sin sum=0
-- using algebraic coords: (R,0), (-R/2, R√3/2), (-R/2, -R√3/2)
def equilateralBolas (R m : ℝ) : Bolas where
  m := fun _ => m
  pos := fun i =>
    match i with
    | 0 => (R, (0, 0))
    | 1 => (-R/2, (R * Real.sqrt 3 / 2, 0))
    | 2 => (-R/2, (-R * Real.sqrt 3 / 2, 0))

theorem three_locks_zero (R m : ℝ) (hm : m ≠ 0) :
    R_cm (equilateralBolas R m) = (0,0,0) := by
  unfold R_cm equilateralBolas
  simp only
  have hM : m + m + m ≠ 0 := by
    have h3m : (3 : ℝ) * m ≠ 0 := mul_ne_zero (by norm_num) hm
    have hsum : m + m + m = 3 * m := by ring
    rw [hsum]
    exact h3m
  have hMx : m * R + m * (-R / 2) + m * (-R / 2) = 0 := by ring
  have hMy : m * 0 + m * (R * Real.sqrt 3 / 2) + m * (-R * Real.sqrt 3 / 2) = 0 := by ring
  have hMz : m * 0 + m * 0 + m * 0 = 0 := by ring
  rw [hMx, hMy, hMz]
  simp only [Prod.mk.injEq]
  constructor
  · field_simp [hM]
  · constructor <;> field_simp [hM]

end
