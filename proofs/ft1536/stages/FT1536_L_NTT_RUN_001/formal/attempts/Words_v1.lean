import Std
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000

namespace FT1536NTT
def Canon (x : Int) : Prop := 0 ≤ x ∧ x < 18433
def u32 (x : Int) : Int := x % 4294967296
def low16 (x : Int) : Int := x % 65536
-- q & -(d >> 31) is q exactly when the high bit of unsigned d is 1.
def fixQ (x : Int) : Int :=
  u32 (u32 x + if u32 x / 2147483648 = 1 then 18433 else 0)
def addWord (x y : Int) : Int := fixQ (x+y-18433)
def subWord (x y : Int) : Int := fixQ (x-y)
def halfWord (x : Int) : Int := (x + if x % 2 = 1 then 18433 else 0) / 2
def montLow (z : Int) : Int := low16 (u32 (z*18431))
def montShift (z : Int) : Int := u32 (z + u32 (montLow z*18433)) / 65536
def montZ (z : Int) : Int := fixQ (montShift z - 18433)

theorem constants :
    (18433:Nat)*18431+1 = 65536*5184 ∧
    (65536:Nat)%18433 = 10237 ∧
    ((65536:Nat)^2)%18433 = 4564 ∧
    (18432:Nat)^2 = 339738624 ∧
    (65535:Nat)*18433 = 1208006655 ∧
    339738624+1208006655 = 1547745279 := by decide

theorem fix_contract (x : Int) (hlo : -18433 ≤ x) (hhi : x < 18433) :
    fixQ x = x % 18433 ∧ Canon (fixQ x) := by
  unfold fixQ Canon
  split <;> unfold u32 at * <;> omega

theorem add_contract (x y : Int) (hx : Canon x) (hy : Canon y) :
    addWord x y = (x+y)%18433 ∧ Canon (addWord x y) := by
  have h := fix_contract (x+y-18433) (by unfold Canon at *; omega) (by unfold Canon at *; omega)
  unfold addWord
  constructor
  · rw [h.1]
    omega
  · exact h.2

theorem sub_contract (x y : Int) (hx : Canon x) (hy : Canon y) :
    subWord x y = (x-y)%18433 ∧ Canon (subWord x y) := by
  exact fix_contract (x-y) (by unfold Canon at *; omega) (by unfold Canon at *; omega)

theorem half_contract (x : Int) (hx : Canon x) :
    Canon (halfWord x) ∧ (2*halfWord x-x)%18433=0 := by
  unfold Canon halfWord at *
  split <;> omega

theorem low_bits_preserved (z : Int) : montLow z = (z*18431)%65536 := by
  unfold montLow low16 u32
  omega

theorem mont_ranges (z : Int) (hz0 : 0 ≤ z) (hz1 : z ≤ 339738624) :
    0 ≤ montLow z ∧ montLow z ≤ 65535 ∧
    0 ≤ montLow z*18433 ∧ montLow z*18433 ≤ 1208006655 ∧
    0 ≤ z+montLow z*18433 ∧ z+montLow z*18433 ≤ 1547745279 ∧
    0 ≤ montShift z ∧ montShift z ≤ 23616 := by
  unfold montShift montLow low16 u32
  omega

theorem mont_divisibility (z : Int) : (z+montLow z*18433)%65536=0 := by
  rw [low_bits_preserved]
  omega

theorem mont_contract_z (z : Int) (hz0 : 0 ≤ z) (hz1 : z ≤ 339738624) :
    Canon (montZ z) ∧ montZ z = (z*5184)%18433 ∧
    (65536*montZ z-z)%18433=0 := by
  have ranges := mont_ranges z hz0 hz1
  have divisible := mont_divisibility z
  have fixed := fix_contract (montShift z-18433) (by omega) (by omega)
  have sum_exact : 65536*montShift z = z+montLow z*18433 := by
    unfold montShift u32
    omega
  unfold montZ
  constructor
  · exact fixed.2
  · rw [fixed.1]
    omega

theorem product_range (x y : Nat) (hx : x < 18433) (hy : y < 18433) :
    x*y ≤ 339738624 := by
  have h := Nat.mul_le_mul (show x ≤ 18432 by omega) (show y ≤ 18432 by omega)
  omega

theorem mq_montymul_contract (x y : Nat) (hx : x < 18433) (hy : y < 18433) :
    Canon (montZ (Int.ofNat (x*y))) ∧
    montZ (Int.ofNat (x*y)) = (Int.ofNat (x*y)*5184)%18433 ∧
    (65536*montZ (Int.ofNat (x*y))-Int.ofNat (x*y))%18433=0 := by
  have h := product_range x y hx hy
  exact mont_contract_z (Int.ofNat (x*y)) (by omega) (by omega)

theorem mq_montysqr_contract (x : Nat) (hx : x < 18433) :
    Canon (montZ (Int.ofNat (x*x))) ∧
    montZ (Int.ofNat (x*x)) = (Int.ofNat (x*x)*5184)%18433 ∧
    (65536*montZ (Int.ofNat (x*x))-Int.ofNat (x*x))%18433=0 := by
  exact mq_montymul_contract x x hx hx

-- Complete primality witness: no divisor 2..135; 136^2 > q.
theorem small_divisors : ∀ d : Fin 136, 2 ≤ d.val → 18433 % d.val ≠ 0 := by decide

theorem prime_factorization (a b : Nat) (h : a*b = 18433) : a=1 ∨ b=1 := by
  by_cases ha : a < 136
  · by_cases ha1 : a=1
    · exact Or.inl ha1
    · have ha2 : 2 ≤ a := by
        by_cases hz : a=0
        · subst a; simp at h
        · omega
      have hn := small_divisors ⟨a,ha⟩ ha2
      have hd : 18433 % a = 0 := by rw [←h]; simp
      exact False.elim (hn hd)
  · by_cases hb : b < 136
    · by_cases hb1 : b=1
      · exact Or.inr hb1
      · have hb2 : 2 ≤ b := by
          by_cases hz : b=0
          · subst b; simp at h
          · omega
        have hn := small_divisors ⟨b,hb⟩ hb2
        have hd : 18433 % b = 0 := by rw [←h]; simp
        exact False.elim (hn hd)
    · have hl := Nat.mul_le_mul (show 136 ≤ a by omega) (show 136 ≤ b by omega)
      omega

#print axioms constants
#print axioms fix_contract
#print axioms add_contract
#print axioms sub_contract
#print axioms half_contract
#print axioms low_bits_preserved
#print axioms mont_ranges
#print axioms mont_divisibility
#print axioms mont_contract_z
#print axioms product_range
#print axioms mq_montymul_contract
#print axioms mq_montysqr_contract
#print axioms small_divisors
#print axioms prime_factorization
end FT1536NTT
