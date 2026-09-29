import Floor
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
set_option exponentiation.threshold 4096
namespace ZeroScalar
open H3Range (p2 signed mant)
abbrev Word := Fin 18446744073709551616
def ex (x : Word) : Nat := x.val/4503599627370496%2048
def frac (x : Word) : Nat := x.val%4503599627370496
def sg (x : Word) : Bool := decide (9223372036854775808≤x.val)
def D : Int := p2 1074
-- Independent exact dyadic interpretation val(x)=valueNum(x)/D. It uses
-- the full finite exponent range, not the old low-exponent mathFloor.
def magNum (x : Word) : Int :=
  if ex x=0 then (frac x : Int) else mant (frac x)*p2 (ex x-1)
def valueNum (x : Word) : Int := signed (sg x) (magNum x)
def NumericCenter (x : Word) : Prop :=
  ex x<2047 ∧ -2147483283*D≤valueNum x ∧ valueNum x<2147483282*D
def floorVal (x : Word) : Int := valueNum x/D
def eps0 (x : Word) : Int := if x.val=9223372036854775808 then 1 else 0

theorem p2_pos (n : Nat) : 0<p2 n := by
  exact Int.ofNat_lt.mpr (Nat.two_pow_pos n)
theorem D_pos : 0<D := p2_pos 1074
theorem p2_add (a b : Nat) : p2 (a+b)=p2 a*p2 b := by
  unfold p2
  rw [Nat.pow_add,Int.natCast_mul]
theorem frac_bound (x : Word) : frac x<4503599627370496 := Nat.mod_lt _ (by decide)

theorem exponent_from_value (x : Word) (hx : NumericCenter x) : ex x≤1053 := by
  by_cases h : ex x≤1053
  · exact h
  apply False.elim
  have he : 1054≤ex x := by omega
  have hp:=H3Range.p2_mono 1053 (ex x-1) (by omega)
  have hf : 4503599627370496≤mant (frac x) := by unfold mant;omega
  have lower:=Int.mul_le_mul hf hp (show 0≤p2 1053 from Int.le_of_lt (p2_pos 1053)) (show 0≤mant (frac x) by omega)
  have hconst : (4503599627370496:Int)*p2 1053=2147483648*D := by decide
  rw [hconst] at lower
  have hm : magNum x=mant (frac x)*p2 (ex x-1) := by simp only [magNum,ite_eq_right (show ex x≠0 by omega)]
  have hd:=D_pos
  obtain ⟨hfinite,hlo,hhi⟩:=hx
  unfold valueNum signed at hlo hhi
  rw [hm] at hlo hhi
  cases hs : sg x <;> simp only [hs,Bool.false_eq_true,↓reduceIte] at hlo hhi <;> omega

theorem floorVal_old (x : Word) (he : ex x≤1053) : floorVal x=H3Range.mathFloor (sg x) (ex x) (frac x) := by
  by_cases hz : ex x=0
  · simp only [floorVal,valueNum,magNum,hz,H3Range.mathFloor,↓reduceIte,D]
  · have he0 : 1≤ex x := by omega
    have hd : D=p2 (ex x-1)*p2 (1075-ex x) := by
      rw [←p2_add]
      unfold D
      congr 1
      omega
    unfold floorVal valueNum magNum H3Range.mathFloor
    rw [ite_eq_right hz,ite_eq_right hz,hd]
    cases sg x <;> simp only [signed,Bool.false_eq_true,↓reduceIte]
    · rw [Int.mul_comm (mant (frac x))]
      exact Int.mul_ediv_mul_of_pos _ _ (p2_pos (ex x-1))
    · rw [Int.mul_comm (mant (frac x)),←Int.mul_neg]
      exact Int.mul_ediv_mul_of_pos _ _ (p2_pos (ex x-1))

theorem floorVal_range (x : Word) (hx : NumericCenter x) : -2147483283≤floorVal x ∧ floorVal x≤2147483281 := by
  have hlo := (Int.le_ediv_iff_mul_le D_pos).mpr hx.2.1
  have hhi := (Int.ediv_lt_iff_lt_mul D_pos).mpr hx.2.2
  change -2147483283≤valueNum x/D ∧ valueNum x/D≤2147483281
  omega
theorem negzero_fields (x : Word) : x.val=9223372036854775808 ↔ sg x=true ∧ ex x=0 ∧ frac x=0 := by
  unfold sg ex frac
  simp only [decide_eq_true_eq]
  have hw:=x.isLt
  omega
theorem zero_aware_parts (x : Word) (hx : NumericCenter x) :
    H3Range.floorParts (sg x) (ex x) (frac x)=floorVal x-eps0 x := by
  have he:=exponent_from_value x hx
  by_cases hz : x.val=9223372036854775808
  · obtain ⟨hs,he0,hf0⟩:=negzero_fields x |>.mp hz
    rw [floorVal_old x he,hs,he0,hf0,H3Range.negative_zero_exception.1,H3Range.negative_zero_exception.2]
    simp only [eps0,ite_eq_left hz]
    decide
  · have hn : H3Range.NotNegZero (sg x) (ex x) (frac x) := fun h => hz ((negzero_fields x).mpr h)
    rw [H3Range.floor_refinement (sg x) (ex x) (frac x) he (frac_bound x) hn,←floorVal_old x he]
    simp only [eps0,ite_eq_right hz,Int.sub_zero]

#check @NumericCenter
#check @exponent_from_value
#check @zero_aware_parts
#print axioms p2_pos
#print axioms D_pos
#print axioms p2_add
#print axioms frac_bound
#print axioms exponent_from_value
#print axioms floorVal_old
#print axioms floorVal_range
#print axioms negzero_fields
#print axioms zero_aware_parts
end ZeroScalar
