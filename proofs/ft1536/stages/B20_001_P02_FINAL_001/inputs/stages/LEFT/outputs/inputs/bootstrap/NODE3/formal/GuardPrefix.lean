import OrderedResidual
import Comparator
namespace H3Range
def exponent (x : Nat) : Nat := x/4503599627370496%2048
def fraction (x : Nat) : Nat := x%4503599627370496
def signBit (x : Nat) : Bool := decide (9223372036854775808≤x)
def finite (x : Nat) : Bool := decide (exponent x≠2047)
def positiveFinite (x : Nat) : Bool := decide (x<9223372036854775808 ∧ exponent x≠2047 ∧ x≠0)
inductive Admission where
  | stickyReturnZero
  | setFaultReturnZero
  | atFloor (mu sigma : Nat)
  deriving DecidableEq,Repr
-- Exact source prefix order, ending BEFORE floor/dss. No center bound is
-- built into this executable admission relation.
def admitCall (fault mu sigma : Nat) : Admission :=
  if fault≠0 then .stickyReturnZero
  else if finite mu && positiveFinite sigma then .atFloor mu sigma
  else .setFaultReturnZero
theorem active_guards (fault mu sigma : Nat) (h : admitCall fault mu sigma=.atFloor mu sigma) :
    fault=0 ∧ exponent mu≠2047 ∧ sigma<9223372036854775808 ∧ exponent sigma≠2047 ∧ sigma≠0 := by
  unfold admitCall at h
  split at h
  · cases h
  · rename_i hz
    split at h
    · rename_i hg
      have hs:=Bool.and_eq_true_iff.mp hg
      exact ⟨by omega,of_decide_eq_true hs.1,of_decide_eq_true hs.2⟩
    · cases h
theorem sticky_path (fault mu sigma : Nat) (hf : fault≠0) : admitCall fault mu sigma=.stickyReturnZero := by
  simp only [admitCall,ite_eq_left hf]
theorem negative_zero_admitted : admitCall 0 0x8000000000000000 0x3ff8000000000000=.atFloor 0x8000000000000000 0x3ff8000000000000 := by decide
theorem guards_do_not_imply_floor_refinement :
    ∃ mu sigma, admitCall 0 mu sigma=.atFloor mu sigma ∧
      floorParts (signBit mu) (exponent mu) (fraction mu)≠mathFloor (signBit mu) (exponent mu) (fraction mu) := by
  refine ⟨0x8000000000000000,0x3ff8000000000000,negative_zero_admitted,?_⟩
  change floorParts true 0 0≠mathFloor true 0 0
  rw [negative_zero_exception.1,negative_zero_exception.2]
  decide
def CenterClass (mu : Nat) : Prop :=
  mu<18446744073709551616 ∧ exponent mu≤1053 ∧
  NotNegZero (signBit mu) (exponent mu) (fraction mu) ∧
  -2147483283≤mathFloor (signBit mu) (exponent mu) (fraction mu) ∧
  mathFloor (signBit mu) (exponent mu) (fraction mu)≤2147483281
theorem complete_local_lift (mu : Nat) (hm : CenterClass mu) (k : Nat) (hk : k≤365) (b : Bool) :
    floorParts (signBit mu) (exponent mu) (fraction mu)=mathFloor (signBit mu) (exponent mu) (fraction mu) ∧
    -2147483648≤floorParts (signBit mu) (exponent mu) (fraction mu)+proposalZ k b ∧
    floorParts (signBit mu) (exponent mu) (fraction mu)+proposalZ k b≤2147483647 := by
  exact conditional_H3_local _ _ _ _ hm.2.1 (Nat.mod_lt _ (by decide)) hm.2.2.1 hm.2.2.2 (proposal_support k hk b)

#check @active_guards
#check @complete_local_lift
#print axioms active_guards
#print axioms sticky_path
#print axioms negative_zero_admitted
#print axioms guards_do_not_imply_floor_refinement
#print axioms complete_local_lift
end H3Range
