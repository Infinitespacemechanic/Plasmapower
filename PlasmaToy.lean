-- PlasmaToy.lean - Toy: 3 coils at 120° hold fire
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
  unfold B_at_center three_coil_toy
  simp only [List.foldl]
  have h_s0 : Real.sin 0 = 0 := Real.sin_zero
  have h_c0 : Real.cos 0 = 1 := Real.cos_zero
  have h_2pi_div3_eq : (2 * Real.pi / 3 : ℝ) = Real.pi - Real.pi / 3 := by ring
  have h_4pi_div3_eq : (4 * Real.pi / 3 : ℝ) = Real.pi + Real.pi / 3 := by ring
  have h_s120 : Real.sin (2 * Real.pi / 3) = Real.sin (Real.pi / 3) := by
    rw [h_2pi_div3_eq, Real.sin_pi_sub]
  have h_c120 : Real.cos (2 * Real.pi / 3) = -Real.cos (Real.pi / 3) := by
    rw [h_2pi_div3_eq, Real.cos_pi_sub]
  have h_s240 : Real.sin (4 * Real.pi / 3) = -Real.sin (Real.pi / 3) := by
    rw [h_4pi_div3_eq]
    have : Real.pi + Real.pi / 3 = Real.pi / 3 + Real.pi := by ring
    rw [this, Real.sin_add_pi]
  have h_c240 : Real.cos (4 * Real.pi / 3) = -Real.cos (Real.pi / 3) := by
    rw [h_4pi_div3_eq]
    have : Real.pi + Real.pi / 3 = Real.pi / 3 + Real.pi := by ring
    rw [this, Real.cos_add_pi]
  rw [h_s0, h_s120, h_s240, h_c0, h_c120, h_c240]
  have h_cos_pi_div3 : Real.cos (Real.pi / 3) = 1/2 := Real.cos_pi_div_three
  rw [h_cos_pi_div3]
  simp only [one_mul, mul_one, zero_add, add_zero, neg_mul, neg_neg]
  -- now (0 + sin - sin, -1 + 1/2 + 1/2, 0) = (0,0,0)
  ring_nf

end
