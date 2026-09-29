import NodeConstants
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
set_option exponentiation.threshold 4096
namespace Node2
open ZeroScalar
open H3Range (p2 signed mant)
def halfC (x : Word) : Word :=
  let w := (x.val+18442240474082181120)%18446744073709551616
  ⟨if (w/4503599627370496%2048+1)/2048=0 then w else 0,by
    split
    · exact Nat.mod_lt _ (by decide)
    · decide⟩
theorem half_bits (x : Word) :
    (halfC x).val=if ex x=0 then 0 else x.val-4503599627370496 := by
  have hw:=x.isLt
  unfold halfC ex
  dsimp only
  split <;> split <;> omega
theorem half_fields (x : Word) (he : ex x≠0) :
    ex (halfC x)=ex x-1 ∧ frac (halfC x)=frac x ∧ sg (halfC x)=sg x := by
  have hh : (halfC x).val=x.val-4503599627370496 := by rw [half_bits,ite_eq_right he]
  have hw:=x.isLt
  unfold ex at he
  unfold ex frac sg
  rw [hh]
  refine ⟨by omega,by omega,?_⟩
  by_cases hs : 9223372036854775808≤x.val
  · have ht : 9223372036854775808≤x.val-4503599627370496 := by omega
    simp only [hs,ht,decide_true]
  · have ht : ¬9223372036854775808≤x.val-4503599627370496 := by omega
    simp only [hs,ht,decide_false]
def inputNum (s : Bool) (e f : Nat) : Int := signed s (if e=0 then (f:Int) else mant f*p2 (e-1))
def halfNum (s : Bool) (e f : Nat) : Int :=
  if e=0 then 0 else signed s (if e=1 then (f:Int) else mant f*p2 (e-2))
theorem half_value (x : Word) : valueNum (halfC x)=halfNum (sg x) (ex x) (frac x) := by
  by_cases hz : ex x=0
  · have he : halfC x=⟨0,by decide⟩ := Fin.ext (by rw [half_bits,ite_eq_left hz])
    rw [he]
    change 0=halfNum (sg x) (ex x) (frac x)
    rw [halfNum,ite_eq_left hz]
  have h:=half_fields x hz
  unfold valueNum magNum
  rw [h.1,h.2.1,h.2.2]
  unfold halfNum
  rw [ite_eq_right hz]
  by_cases ho : ex x=1
  · rw [ho];rfl
  · have hp : ex x-1≠0 := by omega
    rw [ite_eq_right hp,ite_eq_right ho]
    congr 3
theorem parts_error (s : Bool) (e f : Nat) (hf : f<4503599627370496) :
    -4503599627370496≤2*halfNum s e f-inputNum s e f ∧
    2*halfNum s e f-inputNum s e f≤4503599627370496 := by
  by_cases h0 : e=0
  · subst e
    cases s <;> simp [halfNum,inputNum,signed] <;> omega
  by_cases h1 : e=1
  · subst e
    cases s <;> simp [halfNum,inputNum,signed,mant,p2] <;> omega
  have hp : p2 (e-1)=2*p2 (e-2) := by
    rw [show e-1=(e-2)+1 by omega,ZeroScalar.p2_add]
    rw [show p2 1=2 by decide,Int.mul_comm]
  cases s <;> simp [halfNum,inputNum,h0,h1,signed,hp] <;> grind
theorem half_error_units (x : Word) :
    -4503599627370496≤2*valueNum (halfC x)-valueNum x ∧
    2*valueNum (halfC x)-valueNum x≤4503599627370496 := by
  rw [half_value]
  exact parts_error (sg x) (ex x) (frac x) (frac_bound x)
theorem finite_half (x : Word) (he : ex x<2047) : ex (halfC x)<2047 := by
  by_cases hz : ex x=0
  · have hh : halfC x=⟨0,by decide⟩ := Fin.ext (by rw [half_bits,ite_eq_left hz])
    rw [hh];decide
  · have h:=half_fields x hz
    omega
theorem half_endpoint_classes :
    (halfC ⟨9223372036854775808,by decide⟩).val=0 ∧
    (halfC ⟨4503599627370496,by decide⟩).val=0 ∧
    (halfC ⟨4503599627370497,by decide⟩).val=1 ∧
    (halfC ⟨9227875636482146304,by decide⟩).val=9223372036854775808 := by decide
end Node2
