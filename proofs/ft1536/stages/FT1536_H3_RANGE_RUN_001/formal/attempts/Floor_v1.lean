import Std
set_option maxRecDepth 8192
set_option maxHeartbeats 3000000
namespace H3Range
def p2 (n : Nat) : Int := (2^n : Nat)
def signed (s : Bool) (m : Int) : Int := if s then -m else m
def mant (f : Nat) : Int := 4503599627370496+(f:Int)
-- Exact dyadic floor for exponent<=1053 (including IEEE subnormal inputs).
def mathFloor (s : Bool) (e f : Nat) : Int :=
  if e=0 then signed s f / p2 1074 else signed s (mant f) / p2 (1075-e)
-- Reduction of pinned fpr_floor: xi=(2^52+f)*2^10, sign, cc,
-- arithmetic right shift with cc&63, then overwrite when cc>=64.
def floorParts (s : Bool) (e f : Nat) : Int :=
  if 1085-e≥64 then (if s then -1 else 0)
  else signed s (1024*mant f) / p2 (1085-e)
def NotNegZero (s : Bool) (e f : Nat) : Prop := ¬(s=true ∧ e=0 ∧ f=0)

theorem p2_mono (a b : Nat) (h : a≤b) : p2 a≤p2 b := by
  exact Int.ofNat_le.mpr (Nat.pow_le_pow_right (by decide : 0<2) h)
theorem mant_bounds (f : Nat) (h : f<4503599627370496) : 0<mant f ∧ mant f<9007199254740992 := by unfold mant;omega
theorem p2_shift (n : Nat) : p2 (10+n)=1024*p2 n := by
  unfold p2
  rw [Nat.pow_add,Int.natCast_mul]
  rfl

theorem normal_floor_refinement (s : Bool) (e f : Nat) (he0 : 1≤e) (he : e≤1053) (hf : f<4503599627370496) :
    floorParts s e f=mathFloor s e f := by
  have hm:=mant_bounds f hf
  unfold floorParts mathFloor
  rw [ite_eq_right (show ¬e=0 by omega)]
  by_cases hsmall : 1085-e≥64
  · rw [ite_eq_left hsmall]
    have hp:=p2_mono 54 (1075-e) (by omega)
    have hnum : p2 54=18014398509481984 := by decide
    rw [hnum] at hp
    cases s
    · exact (Int.ediv_eq_zero_of_lt (by change 0≤mant f;omega) (by change mant f<p2 (1075-e);omega)).symm
    · exact (Int.ediv_eq_neg_one_of_neg_of_le (by change -mant f<0;omega) (by change -(-mant f)≤p2 (1075-e);omega)).symm
  · rw [ite_eq_right hsmall]
    have hshift : 1085-e=10+(1075-e) := by omega
    rw [hshift,p2_shift]
    cases s <;> simp only [signed,Bool.false_eq_true,↓reduceIte,Int.mul_neg,←Int.neg_mul]
    · exact Int.mul_ediv_mul_of_pos _ _ (show (0:Int)<1024 by decide)
    · rw [←Int.mul_neg]
      exact Int.mul_ediv_mul_of_pos _ _ (show (0:Int)<1024 by decide)

theorem subnormal_floor_refinement (s : Bool) (f : Nat) (hf : f<4503599627370496)
    (hz : NotNegZero s 0 f) : floorParts s 0 f=mathFloor s 0 f := by
  have hp:=p2_mono 53 1074 (by decide)
  have hnum : p2 53=9007199254740992 := by decide
  rw [hnum] at hp
  cases s
  · change 0=(f:Int)/p2 1074
    exact (Int.ediv_eq_zero_of_lt (by omega) (by omega)).symm
  · have hf0 : 0<f := by unfold NotNegZero at hz;omega
    change -1= -(f:Int)/p2 1074
    exact (Int.ediv_eq_neg_one_of_neg_of_le (by omega) (by omega)).symm

theorem floor_refinement (s : Bool) (e f : Nat) (he : e≤1053) (hf : f<4503599627370496)
    (hz : NotNegZero s e f) : floorParts s e f=mathFloor s e f := by
  by_cases he0 : e=0
  · subst e;exact subnormal_floor_refinement s f hf hz
  · exact normal_floor_refinement s e f (by omega) he hf

theorem negative_zero_exception : floorParts true 0 0= -1 ∧ mathFloor true 0 0=0 := by decide
theorem signed_zero_guard : (0x8000000000000000:Nat)/4503599627370496%2048=0 := by decide
theorem integer_safety (s z : Int) (hs : -2147483283≤s ∧ s≤2147483281) (hz : -365≤z ∧ z≤366) :
    -2147483648≤s ∧ s≤2147483647 ∧ -2147483648≤s+z ∧ s+z≤2147483647 := by omega
theorem conditional_H3_local (sg : Bool) (e f : Nat) (z : Int) (he : e≤1053) (hf : f<4503599627370496)
    (hzero : NotNegZero sg e f) (hmu : -2147483283≤mathFloor sg e f ∧ mathFloor sg e f≤2147483281)
    (hz : -365≤z ∧ z≤366) :
    floorParts sg e f=mathFloor sg e f ∧ -2147483648≤floorParts sg e f+z ∧ floorParts sg e f+z≤2147483647 := by
  rw [floor_refinement sg e f he hf hzero]
  exact ⟨rfl,(integer_safety _ z hmu hz).2.2⟩

#check @floor_refinement
#check @conditional_H3_local
#print axioms normal_floor_refinement
#print axioms subnormal_floor_refinement
#print axioms floor_refinement
#print axioms negative_zero_exception
#print axioms integer_safety
#print axioms conditional_H3_local
end H3Range
