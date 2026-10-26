import Source3.ZintNormWalkStep208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWalkLoop208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open ZintNormWalkIncrement208 (row point)
open ZintNormWalkFixed208 (Fixed Pending Written)
open KeygenZintCall (Exec)

theorem guard (s : State) (v n : Nat) (vb : v < 2^64) (nb : n < 2^64)
    (uc : Cell s "u".toList v) (nc : Cell s "num".toList n) :
    KeygenWordExpr.Eval s ZintNormWalk194.walkGuard (C99ScalarReference.boolean (decide (v < n))) :=
  .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s "u".toList v uc))
    (.scalar _ _ (C99LoopScalar141.read s "num".toList n nc)) (C99NatWord141.less v n vb nb)

theorem remaining (count v : Nat) (s : State) (root tmp : ArrayPointer) (n len : Nat)
    (rows : Nat → Nat → BitVec 32) (pv : Nat → BitVec 32) (fixed : Fixed s root tmp n len pv)
    (uc : Cell s "u".toList v) (xb : s.arrays "x".toList=some (row root len v))
    (pending : Pending s root n len rows v) (written : Written s root len rows pv v) (finish : v+count=n) :
    ∃ out, Exec ZintNormWalk194.walkLoop s ⟨out,.normal⟩ ∧ Fixed out root tmp n len pv ∧ Cell out "u".toList n ∧
      out.arrays "x".toList=some (row root len n) ∧ Written out root len rows pv n ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i j, i < n → j < len → Separate (point root len i j) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  induction count generalizing v s with
  | zero =>
    have eq : v=n := by omega
    subst v
    have test : KeygenWordExpr.Eval s ZintNormWalk194.walkGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard s n n fixed.nBound fixed.nBound uc fixed.numCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),fixed,uc,xb,written,
      fun _ _ => rfl,fun _ _ => rfl,fun _ _ _ read => read⟩
  | succ count ih =>
    have slot : v < n := by omega
    obtain ⟨mid,next,body,update,nextFixed,nextU,nextX,nextPending,nextWritten,nextLocals,nextArrays,keep⟩:=
      ZintNormWalkStep208.step s root tmp n len v rows pv fixed slot uc xb pending written
    obtain ⟨out,rest,finalFixed,finalU,finalX,finalWritten,finalLocals,finalArrays,finalKeep⟩:=
      ih (v+1) next nextFixed nextU nextX nextPending nextWritten (by omega)
    refine ⟨out,?_,finalFixed,finalU,finalX,finalWritten,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s mid next ⟨out,.normal⟩ (C99ScalarReference.boolean (decide (v < n))) ?_ ?_ body update rest
      · exact guard s v n (by have h:=fixed.nBound; omega) fixed.nBound uc fixed.numCell
      · simp [slot,C99ScalarReference.boolean,Value.integer]
    · intro name different
      exact (finalLocals name different).trans (nextLocals name different)
    · intro name different
      exact (finalArrays name different).trans (nextArrays name different)
    · intro q old apart read
      exact finalKeep q old apart (keep q old (fun j bound => apart v j slot bound) read)

theorem source (s : State) (root tmp : ArrayPointer) (n len : Nat) (rows : Nat → Nat → BitVec 32) (pv : Nat → BitVec 32)
    (fixed : Fixed s root tmp n len pv) (uc : Cell s "u".toList 0) (xb : s.arrays "x".toList=some (row root len 0))
    (pending : Pending s root n len rows 0) :
    ∃ out, Exec ZintNormWalk194.walkLoop s ⟨out,.normal⟩ ∧ Fixed out root tmp n len pv ∧ Cell out "u".toList n ∧
      out.arrays "x".toList=some (row root len n) ∧ Written out root len rows pv n ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i j, i < n → j < len → Separate (point root len i j) q) →
        Load32 s.heap q old → Load32 out.heap q old) :=
  remaining n 0 s root tmp n len rows pv fixed uc xb pending (fun i h => by omega) (by omega)

end FT1536.Source3.ZintNormWalkLoop208
