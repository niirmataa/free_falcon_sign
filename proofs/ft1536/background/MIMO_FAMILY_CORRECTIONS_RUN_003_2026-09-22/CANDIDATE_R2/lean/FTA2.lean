/-!
# FTFamily.A2 — kwadratowa forma A2 nad Int (kernel Lean 4)

Źródłowa definicja (Extra/c/falcon-enc.c, ternary branch `falcon_is_short`):

    Q(z1,z2) = sum_i (z_i^2 + z_i z_{i+N/2} + z_{i+N/2}^2)   dla z = z1, z2

tzn. forma A2(x,y) = x^2 + x*y + y^2 po parach o offsecie N/2. Moduł sprawdza
jądrowo rdzeń algebraiczny użyty w manuskrypcie:

1. `two_a2_eq`       : 2*A2(x,y) = x^2 + y^2 + (x+y)^2  (tożsamość A2 z M0),
2. `a2_lower`        : x^2 + y^2 <= 2*A2(x,y),
3. `two_a2_le_three` : 2*A2(x,y) <= 3*(x^2 + y^2), równość dla x = y.

Wnioski wektorowe (1/2)||a||^2 <= Q_A2(a) <= (3/2)||a||^2 oraz transport
przez zanurzenia są w tekście i w Sage. Log kompilacji jest czysty; nie użyto
sorry/admit/native_decide.
-/

namespace FTFamily

/-- 0 <= a*a dla całkowitych. -/
theorem int_sq_nonneg (a : Int) : 0 ≤ a * a := by
  rcases Int.le_total 0 a with h | h
  · exact Int.mul_nonneg h h
  · have h2 : 0 ≤ -a := Int.neg_nonneg_of_nonpos h
    have h3 := Int.mul_nonneg h2 h2
    rwa [Int.neg_mul_neg] at h3

/-- Rozkład 3*a na sumę trzech składników. -/
theorem three_mul (a : Int) : 3 * a = a + a + a := by
  show (2 + 1) * a = _
  rw [Int.add_mul, Int.two_mul, Int.one_mul]

/-- Tożsamość A2 z kontraktu M0: 2*A2(x,y) = x^2 + y^2 + (x+y)^2. -/
theorem two_a2_eq (x y : Int) :
    2 * (x * x + x * y + y * y) = x * x + y * y + (x + y) * (x + y) := by
  rw [Int.two_mul, Int.mul_add]
  simp only [Int.add_mul, Int.mul_comm y x]
  ac_rfl

/-- Postać rozmieszczona 2*A2 wygodna dla nierówności górnej. -/
theorem two_a2_mix (x y : Int) :
    2 * (x * x + x * y + y * y)
      = (x * x + y * y) + (x * x + y * y) + (x * y + y * x) := by
  rw [Int.two_mul]
  simp only [Int.mul_comm y x]
  ac_rfl

/-- (x-y)^2 = x^2 + y^2 - (xy + yx). -/
theorem sq_sub_expansion (x y : Int) :
    (x - y) * (x - y) = x * x + y * y - (x * y + y * x) := by
  rw [Int.sub_eq_add_neg, Int.sub_eq_add_neg]
  simp only [Int.add_mul, Int.mul_add, Int.mul_neg, Int.neg_mul, Int.neg_neg,
    Int.neg_add, Int.mul_comm y x]
  ac_rfl

/-- 2xy <= x^2 + y^2 (przypadek graniczny x = -y dla A2). -/
theorem cross_le (x y : Int) : x * y + y * x ≤ x * x + y * y := by
  have h : 0 ≤ x * x + y * y - (x * y + y * x) := by
    rw [← sq_sub_expansion]
    exact int_sq_nonneg (x - y)
  exact Int.sub_nonneg.mp h

/-- Dolna nierównowość równoważności: x^2+y^2 <= 2*A2(x,y). -/
theorem a2_lower (x y : Int) : x * x + y * y ≤ 2 * (x * x + x * y + y * y) := by
  rw [two_a2_eq]
  exact Int.le_add_of_nonneg_right (int_sq_nonneg (x + y))

/-- Górna nierównowość równoważności: 2*A2(x,y) <= 3*(x^2+y^2). -/
theorem two_a2_le_three (x y : Int) :
    2 * (x * x + x * y + y * y) ≤ 3 * (x * x + y * y) := by
  have hx : x * y + y * x ≤ x * x + y * y := cross_le x y
  rw [two_a2_mix, three_mul]
  calc (x * x + y * y) + (x * x + y * y) + (x * y + y * x)
      = x * x + y * y + ((x * x + y * y) + (x * y + y * x)) := by ac_rfl
    _ ≤ x * x + y * y + ((x * x + y * y) + (x * x + y * y)) :=
        Int.add_le_add_left (Int.add_le_add_left hx (x * x + y * y)) (x * x + y * y)
    _ = (x * x + y * y) + (x * x + y * y) + (x * x + y * y) := by ac_rfl

/-- Przypadek równości górnej dla x = y. -/
theorem a2_upper_eq (x : Int) :
    2 * (x * x + x * x + x * x) = 3 * (x * x + x * x) := by
  rw [three_mul]
  simp only [Int.two_mul]
  ac_rfl

end FTFamily
