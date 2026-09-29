import ErrorArithmetic
import Half
import TargetSequence
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace OrderedReach
open ZeroScalar
inductive Outcome where
  | normal (sample : Int)
  | fault
  | stutter
  deriving DecidableEq,Repr
def nextFault (f : Bool) : Outcome → Bool
  | .fault => true
  | _ => f
def faults : Bool → List Outcome → Bool
  | f,[] => f
  | f,o::os => faults (nextFault f o) os
theorem fault_sticky (os : List Outcome) : faults true os=true := by
  induction os with
  | nil => rfl
  | cons o os ih => cases o <;> simp [faults,nextFault,ih]
theorem clear_prefix (f : Bool) (os : List Outcome) (h : faults f os=false) :
    f=false ∧ ∀o∈os,o≠Outcome.fault := by
  induction os generalizing f with
  | nil => exact ⟨h,by simp⟩
  | cons o os ih =>
    cases o with
    | fault => simp [faults,nextFault,fault_sticky] at h
    | normal z =>
      have hh:=ih f h
      refine ⟨hh.1,?_⟩
      intro a ha;rcases List.mem_cons.mp ha with he|ht
      · subst a;intro hbad;cases hbad
      · exact hh.2 a ht
    | stutter =>
      have hh:=ih f h
      refine ⟨hh.1,?_⟩
      intro a ha;rcases List.mem_cons.mp ha with he|ht
      · subst a;intro hbad;cases hbad
      · exact hh.2 a ht
def normalResult (mu : Word) (sample : Int) : Prop :=
  ∃z, -365≤z ∧ z≤366 ∧ sample=floorC mu+z
theorem safe_normal_return (mu : Word) (hm : NumericCenter mu) (sample : Int)
    (h : normalResult mu sample) : -2147483648≤sample ∧ sample≤2147483647 := by
  obtain ⟨z,hlo,hhi,hs⟩:=h
  have hc:=C_INT_BRIDGE mu hm z ⟨hlo,hhi⟩
  rw [hs];exact hc.2.2
theorem normal_residual_after_center (mu : Word) (hm : NumericCenter mu) (sample residual : Int)
    (h : normalResult mu sample)
    (source_error : H3Range.Between (residual-(valueNum mu-D*sample)) Eunits) :
    H3Range.Between residual (366*D+Eunits) := by
  obtain ⟨z,hlo,hhi,hs⟩:=h
  rw [hs] at source_error
  exact MACHINE_RESIDUAL_366 mu hm z residual ⟨hlo,hhi⟩ source_error
theorem fault_zero_is_not_close : (10000000:Int)>366+1 := by decide
theorem normal_zero_distinct_tag : Outcome.normal 0≠Outcome.fault := by intro h;cases h
def callerStep {M : Type} (normal fault : M → Int → M) (m : M) : Outcome → Option M
  | .normal z => some (normal m z)
  | .fault => some (fault m 0)
  | .stutter => none
theorem rejection_no_return {M : Type} (normal fault : M → Int → M) (m : M) :
    callerStep normal fault m .stutter=none := by rfl
theorem shifted_half_bound (r h E : Int) (hr : -367≤r ∧ r≤367)
    (he : -E≤2*h-r ∧ 2*h-r≤E) (hE : 0≤E ∧ E≤1) : -184≤h ∧ h≤184 := by omega
theorem next_center_needs_update (a h e mu A : Int) (ha : -A≤a ∧ a≤A)
    (hh : -184≤h ∧ h≤184) (he : -1≤e ∧ e≤1) (hm : mu=a+h+e) :
    -(A+185)≤mu ∧ mu≤A+185 := by omega
theorem final_residual_after_unshift (r h e out : Int)
    (hr : -367≤r ∧ r≤367) (hh : -184≤h ∧ h≤184) (he : -1≤e ∧ e≤1)
    (ho : out=r-h+e) : -552≤out ∧ out≤552 := by omega
theorem right_margin (mu : Word) (finite : ex mu<2047)
    (range : -156276714*D≤valueNum mu ∧ valueNum mu≤156276714*D) : NumericCenter mu := by
  have hd:=D_pos
  unfold NumericCenter
  refine ⟨finite,?_,?_⟩ <;> omega
theorem right_margin_constants : (2147483283-156276714:Nat)=1991206569 ∧
    (2147483282-156276714:Nat)=1991206568 := by decide
theorem cutoff_counts (sw : Nat) (h : sw<1048576) :
    ((4294967296+63-sw)%4294967296)/2147483648=if 63<sw then 1 else 0 := by
  split <;> omega
theorem safe_shift (sw : Nat) : (if sw≤63 then sw else 63)<64 := by split <;> omega
theorem scalar_integer_products (k : Nat) (hk : k≤365) :
    k*k≤133225 ∧ 2*k≤730 ∧ k+1≤366 := by
  have hm:=Nat.mul_le_mul hk hk
  constructor
  · exact hm
  · omega
end OrderedReach
