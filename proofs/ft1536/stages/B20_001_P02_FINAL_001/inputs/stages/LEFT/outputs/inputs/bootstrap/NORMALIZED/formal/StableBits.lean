import RootModel
import RawMatching
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace StableNorm
open ZeroScalar
def flip (x : Word) : Word :=
  ⟨if x.val<9223372036854775808 then x.val+9223372036854775808 else x.val-9223372036854775808,by have h:=x.isLt;split <;> omega⟩
theorem flip_fields (x : Word) : frac (flip x)=frac x ∧ ex (flip x)=ex x := by
  have h:=x.isLt
  simp only [flip,frac,ex]
  split <;> omega
theorem square_neg_bit_invariant (x : Word) : RootLDL.mulC (flip x) (flip x)=RootLDL.mulC x x := by
  have hf:=(flip_fields x).1
  have he:=(flip_fields x).2
  simp [RootLDL.mulC,hf,he]
def selfadj (plus : Word → Word → Word) (re im : Word) := plus (RootLDL.mulC re re) (RootLDL.mulC im im)
theorem selfadj_neg_bit_invariant (plus : Word → Word → Word) (re im : Word) :
    selfadj plus (flip re) (flip im)=selfadj plus re im := by
  simp [selfadj,square_neg_bit_invariant]
def swapFlag (x y : Nat) := ((18446744073709551616+x-y)%18446744073709551616)/9223372036854775808
theorem signzero_source_swap (x y : Nat) (hx : x<9223372036854775808) (hy : y<9223372036854775808) :
    swapFlag x y=if x<y then 1 else 0 := by
  unfold swapFlag;split <;> omega
def ordered (x y : Nat) := if x<y then (y,x) else (x,y)
theorem ordered_comm (x y : Nat) : ordered x y=ordered y x := by
  unfold ordered
  by_cases h : x<y
  · simp [h,show ¬y<x by omega]
  · by_cases k : y<x
    · simp [h,k]
    · have e : x=y := by omega
      subst y;simp
def sourceAddRest {W : Type} (rest : Nat → Nat → W) (x y : Nat) := rest (ordered x y).1 (ordered x y).2
theorem nonnegative_add_bit_comm {W : Type} (rest : Nat → Nat → W) (x y : Nat) :
    sourceAddRest rest x y=sourceAddRest rest y x := by
  unfold sourceAddRest;rw [ordered_comm]
def sticky (bad valid : Bool) : Bool := bad || !valid
theorem sticky_clear (bad valid : Bool) : sticky bad valid=false ↔ bad=false ∧ valid=true := by
  cases bad <;> cases valid <;> decide
def scan (bad : Bool) : List Bool → Bool
  | [] => bad
  | v::vs => scan (sticky bad v) vs
theorem scan_clear (bad : Bool) (vs : List Bool) : scan bad vs=false ↔ bad=false ∧ ∀v∈vs,v=true := by
  induction vs generalizing bad with
  | nil => simp [scan]
  | cons v vs ih =>
    rw [scan,ih,sticky_clear]
    constructor
    · intro ⟨⟨hb,hv⟩,ht⟩
      refine ⟨hb,?_⟩
      intro a ha
      rcases List.mem_cons.mp ha with h|h
      · subst a;exact hv
      · exact ht a h
    · intro ⟨hb,ht⟩
      refine ⟨⟨hb,ht v (by simp)⟩,?_⟩
      intro a ha;exact ht a (by simp [ha])
def gate (x : Nat) :=
  ((18446744073709551616+x-0x4090000053700377)%18446744073709551616)/9223372036854775808=0 ∧
  ((18446744073709551616+0x4114444d1a037d50-x)%18446744073709551616)/9223372036854775808=0
theorem inclusive_gate (x : Nat) (hx : x<9223372036854775808) :
    gate x ↔ 0x4090000053700377≤x ∧ x≤0x4114444d1a037d50 := by unfold gate;omega
theorem fallback_identity {W : Type} (x one : W) (valid : Bool) (h : valid=true) :
    (if valid then x else one)=x := by simp [h]
end StableNorm
