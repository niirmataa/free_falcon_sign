import Std
set_option maxRecDepth 4096
set_option maxHeartbeats 10000000

namespace FT1536
def InInt16 (x : Int) : Prop := -32768 ≤ x ∧ x ≤ 32767
def rhoZ (x : Int) : Int := x % 18433
def shifted (x : Int) : Int := x + 36866
def u16 (x : Int) : Int := x % 65536
-- This models the C remainder only for a nonnegative dividend.
def cPositiveRem (t : Int) : Int := t - (t / 18433) * 18433
def rhoWord (x : Int) : Int := u16 (cPositiveRem (shifted x))
def oldIota (x : Int) : Int := (if x < 0 then x + 18433 else x) % 65536

theorem intermediate_ranges (x : Int) (hx : InInt16 x) :
    -2147483648 ≤ x ∧ x ≤ 2147483647 ∧
    4098 ≤ shifted x ∧ shifted x ≤ 69633 ∧
    0 ≤ shifted x / 18433 ∧ shifted x / 18433 ≤ 3 := by
  unfold InInt16 at hx
  unfold shifted
  omega

theorem positive_remainder (t : Int) (_ht : 0 ≤ t) :
    cPositiveRem t = t % 18433 ∧ 0 ≤ cPositiveRem t ∧ cPositiveRem t < 18433 := by
  unfold cPositiveRem
  omega

theorem rho_contract (x : Int) (hx : InInt16 x) :
    rhoWord x = rhoZ x ∧ 0 ≤ rhoWord x ∧ rhoWord x < 18433 ∧
    (rhoWord x - x) % 18433 = 0 := by
  have hr := intermediate_ranges x hx
  unfold rhoWord rhoZ u16 cPositiveRem shifted at *
  omega

theorem result_cast_exact (x : Int) (hx : InInt16 x) :
    0 ≤ cPositiveRem (shifted x) ∧ cPositiveRem (shifted x) ≤ 65535 ∧
    u16 (cPositiveRem (shifted x)) = cPositiveRem (shifted x) := by
  have hr := intermediate_ranges x hx
  have hp := positive_remainder (shifted x) (by omega)
  unfold u16
  omega

theorem canonical_unique (x y : Int) (hy0 : 0 ≤ y) (hyq : y < 18433)
    (hc : (y-x) % 18433 = 0) : y = rhoZ x := by
  unfold rhoZ
  omega

theorem old_piecewise (x : Int) (hx : InInt16 x) :
    oldIota x = if x < -18433 then x + 83969 else if x < 0 then x + 18433 else x := by
  unfold InInt16 at hx
  by_cases hn : x < 0
  · by_cases hl : x < -18433
    · simp only [oldIota, ite_eq_left hn, ite_eq_left hl]
      omega
    · simp only [oldIota, ite_eq_left hn, ite_eq_right hl]
      omega
  · have hl : ¬ x < -18433 := by omega
    simp only [oldIota, ite_eq_right hn, ite_eq_right hl]
    omega

theorem old_congruence_domain (x : Int) (hx : InInt16 x) :
    ((oldIota x - x) % 18433 = 0) ↔ -18433 ≤ x := by
  rw [old_piecewise x hx]
  split <;> (try split) <;> omega

theorem old_canonical_domain (x : Int) (hx : InInt16 x) :
    (0 ≤ oldIota x ∧ oldIota x < 18433) ↔ (-18433 ≤ x ∧ x < 18433) := by
  rw [old_piecewise x hx]
  unfold InInt16 at hx
  split <;> (try split) <;> omega

theorem agree_on_old_canonical (x : Int) (hx : InInt16 x)
    (h : 0 ≤ oldIota x ∧ oldIota x < 18433) : rhoWord x = oldIota x := by
  have hd := (old_canonical_domain x hx).mp h
  have hc := (old_congruence_domain x hx).mpr hd.1
  have hu := canonical_unique x (oldIota x) h.1 h.2 hc
  exact (rho_contract x hx).1.trans hu.symm

def normalize (s : Fin 1536 → Int) : (Fin 1536 → Int) × (Fin 1536 → Int) :=
  ((fun i => rhoWord (s i)), s)

theorem vector_contract (s : Fin 1536 → Int) (hs : ∀ i, InInt16 (s i)) :
    (normalize s).2 = s ∧
    ∀ i, (normalize s).1 i = rhoZ (s i) ∧
      0 ≤ (normalize s).1 i ∧ (normalize s).1 i < 18433 ∧
      ((normalize s).1 i - s i) % 18433 = 0 := by
  constructor
  · rfl
  · intro i
    exact rho_contract (s i) (hs i)

theorem loop_progress (u : Nat) (hu : u < 1536) :
    1536 - (u+1) < 1536-u ∧ u+1 ≤ 1536 ∧ u+1 < 2^64 := by omega

def center (x : Int) : Int := (x + 9216) % 18433 - 9216
theorem center_antisymmetric (x : Int) : center (-x) = -center x := by
  unfold center
  omega

#print axioms intermediate_ranges
#print axioms positive_remainder
#print axioms rho_contract
#print axioms result_cast_exact
#print axioms canonical_unique
#print axioms old_piecewise
#print axioms old_congruence_domain
#print axioms old_canonical_domain
#print axioms agree_on_old_canonical
#print axioms vector_contract
#print axioms loop_progress
#print axioms center_antisymmetric
end FT1536
