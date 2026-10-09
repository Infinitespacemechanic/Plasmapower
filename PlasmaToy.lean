/-
PlasmaToy.lean - Toy: 3 coils at 120° hold fire
Stripped 3D proof: 3 tracks -> B_center = (0,0,0)
-/
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

noncomputable section

def phi : ℝ := (1 + Real.sqrt 5) / 2
def pi_golden : ℝ := 4 / Real.sqrt phi

structure Coil where
  angle : ℝ
  I : ℝ

def B_at_center (coils : List Coil) : ℝ × ℝ × ℝ :=
  let Bx := coils.foldl (fun acc c => acc + c.I * Real.sin c.angle) 0
  let By := coils.foldl (fun acc c => acc + (-c.I * Real.cos c.angle)) 0
  (Bx, By, 0)

def three_coil_toy : List Coil :=
  [{ angle := 0, I := 1 },
   { angle := 2*Real.pi/3, I := 1 },
   { angle := 4*Real.pi/3, I := 1 }]

theorem three_coil_toy_locks :
    B_at_center three_coil_toy = (0,0,0) := by
  have h₂ : 2 * Real.pi / 3 = Real.pi - Real.pi / 3 := by ring
  have h₄ : 4 * Real.pi / 3 = Real.pi + Real.pi / 3 := by ring
  have h₄' : Real.pi + Real.pi / 3 = Real.pi / 3 + Real.pi := by ring
  simp only [B_at_center, three_coil_toy, List.foldl_cons, List.foldl_nil,
    Real.sin_zero, Real.cos_zero]
  rw [h₂, h₄, h₄']
  simp [Real.sin_pi_sub, Real.cos_pi_sub, Real.sin_add_pi, Real.cos_add_pi]
  norm_num

-- 1 coil = drifts (leaks)
-- 2 coils = flips (cusp fight)
-- 3 coils = locks zero (holds fire)

end
