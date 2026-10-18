import Source3.SelectedTreeNonzero170
import Source3.PublicDivisionSource157
import Source3.KeygenPublicSuffixProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicQuotientAtoms171
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value CompareExec)
open KeygenPublicWord (Address Eval)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed index)
open KeygenSmallOutput (element)

theorem zero_compare (w : BitVec 16) (nonzero : w.toNat≠0) :
    CompareExec .eq (C99NarrowReads.unsignedPromotion w) (.int32 0) (.int32 0) := by
  have step := CompareExec.step .eq (C99NarrowReads.unsignedPromotion w) (.int32 0) .int32 rfl
    (C99NarrowReads.unsignedPromotion w) (.int32 0)
    (C99CountedWords.convert_self (C99NarrowReads.unsignedPromotion w)).symm rfl
  have nz : (w.toNat : Int)≠0 := by omega
  have no : ¬ C99IntegerReference.compare .eq (C99NarrowReads.unsignedPromotion w).integer (Value.int32 0).integer=true := by
    change ¬ decide ((C99NarrowReads.unsignedPromotion w).integer=0)=true
    rw [decide_eq_true_eq,C99NarrowReads.unsigned_promotion_exact]
    exact nz
  have result : Value.int32 (if C99IntegerReference.compare .eq
      (C99NarrowReads.unsignedPromotion w).integer (Value.int32 0).integer then 1#32 else 0#32)=Value.int32 0 := by
    rw [ite_eq_right no]
    decide +kernel
  exact Eq.mp (congrArg (fun v => CompareExec .eq (C99NarrowReads.unsignedPromotion w) (.int32 0) v) result) step

theorem test (s : State) (p : ArrayPointer) (w : BitVec 16)
    (address : Address s "t".toList index p) (read : C99NarrowReads.Load16 s.heap p w)
    (nonzero : w.toNat≠0) :
    Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.test s ⟨s,.normal⟩ := by
  have loaded : Eval signed s (.load16 "t".toList index) (C99NarrowReads.unsignedPromotion w) :=
    .load16 _ _ p w address read
  have guard : Eval signed s KeygenPublicSuffixProgram.zeroTest (.int32 0) :=
    .cmp .eq _ _ _ _ _ loaded (.scalar _ _ (.literal .int32 0)) (zero_compare w nonzero)
  exact .branchFalse _ _ _ _ _ (.int32 0) guard rfl (.skip s)

def promoted (w : BitVec 16) : B20.C.Val := .i32 (BitVec.ofNat 32 w.toNat)
def quotient (x y : BitVec 16) : BitVec 32 := KeygenPublicDivisionWords.division
  (PublicArgumentSource157.word (promoted x)) (PublicArgumentSource157.word (promoted y))

theorem quotient_eval (s : State) (h t : ArrayPointer) (x y : BitVec 16)
    (ha : Address s "h".toList index h) (ta : Address s "t".toList index t)
    (hx : C99NarrowReads.Load16 s.heap h x) (ty : C99NarrowReads.Load16 s.heap t y) :
    Eval signed s (KeygenPublicSuffixProgram.quotient .divT) (.uint32 (quotient x y)) :=
  .call2 _ _ _ (C99NarrowReads.unsignedPromotion x) (C99NarrowReads.unsignedPromotion y) _
    (.load16 _ _ h x ha hx) (.load16 _ _ t y ta ty) (PublicDivisionSource157.source (promoted x) (promoted y))

end FT1536.Source3.PublicQuotientAtoms171
