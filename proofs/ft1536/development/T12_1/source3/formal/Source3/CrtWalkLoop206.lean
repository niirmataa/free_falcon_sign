import Source3.CrtWalkStep206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkLoop206
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open CrtWalkIncrement206 (cell)
open CrtWalkFixed206 (Fixed Pending Written high)
open KeygenZintCall (Exec)

theorem guard (s : State) (v n : Nat) (vb : v < 2^64) (nb : n < 2^64)
    (vc : Cell s "v".toList v) (nc : Cell s "num".toList n) :
    KeygenWordExpr.Eval s CrtRoundShape205.guard (C99ScalarReference.boolean (decide (v < n))) :=
  .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s "v".toList v vc))
    (.scalar _ _ (C99LoopScalar141.read s "num".toList n nc)) (C99NatWord141.less v n vb nb)

theorem remaining {n : Nat} (count v : Nat) (s : State) (root tmp : ArrayPointer)
    (av bv : Fin n → BitVec 32) (t p pi r2 c : BitVec 32)
    (fixed : Fixed s root tmp n t p pi r2 c) (vc : Cell s "v".toList v)
    (xb : s.arrays "x".toList=some (cell root v))
    (pending : Pending s root av bv v) (written : Written s root av bv t p pi r2 c v)
    (finish : v+count=n) :
    ∃ out, Exec CrtRoundShape205.walk s ⟨out,.normal⟩ ∧ Fixed out root tmp n t p pi r2 c ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (cell root n) ∧
      Written out root av bv t p pi r2 c n ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i : Fin n, Separate (cell root i.val) q ∧ Separate (high root i.val) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  induction count generalizing v s with
  | zero =>
    have eq : v=n := by omega
    subst v
    have test : KeygenWordExpr.Eval s CrtRoundShape205.guard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        guard s n n fixed.nBound fixed.nBound vc fixed.numCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),fixed,vc,xb,written,
      fun _ _ => rfl,fun _ _ => rfl,fun _ _ _ read => read⟩
  | succ count ih =>
    have slot : v < n := by omega
    have block:=CrtWalkStep206.step s root tmp v av bv t p pi r2 c fixed slot vc xb pending written
    obtain ⟨body,update,nextFixed,nextV,nextX,nextPending,nextWritten,keep⟩:=block
    obtain ⟨out,rest,finalFixed,finalV,finalX,finalWritten,finalLocals,finalArrays,finalKeep⟩:=
      ih (v+1) (CrtWalkStep206.next s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c)
        nextFixed nextV nextX nextPending nextWritten (by omega)
    refine ⟨out,?_,finalFixed,finalV,finalX,finalWritten,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s
        (CrtWalkStep206.output s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c)
        (CrtWalkStep206.next s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c) ⟨out,.normal⟩
        (C99ScalarReference.boolean (decide (v < n))) ?_ ?_ body update rest
      · exact guard s v n (by have nb:=fixed.nBound; omega) fixed.nBound vc fixed.numCell
      · simp [slot,C99ScalarReference.boolean,Value.integer]
    · intro name different
      exact (finalLocals name different).trans
        (CrtWalkStep206.next_locals s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c name different)
    · intro name different
      exact (finalArrays name different).trans
        (CrtWalkStep206.next_arrays s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c name different)
    · intro q old apart read
      exact finalKeep q old apart (keep q old (apart ⟨v,slot⟩).1 (apart ⟨v,slot⟩).2 read)

theorem source {n : Nat} (s : State) (root tmp : ArrayPointer)
    (av bv : Fin n → BitVec 32) (t p pi r2 c : BitVec 32)
    (fixed : Fixed s root tmp n t p pi r2 c) (vc : Cell s "v".toList 0)
    (xb : s.arrays "x".toList=some (cell root 0)) (pending : Pending s root av bv 0) :
    ∃ out, Exec CrtRoundShape205.walk s ⟨out,.normal⟩ ∧ Fixed out root tmp n t p pi r2 c ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (cell root n) ∧
      Written out root av bv t p pi r2 c n ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i : Fin n, Separate (cell root i.val) q ∧ Separate (high root i.val) q) →
        Load32 s.heap q old → Load32 out.heap q old) :=
  remaining n 0 s root tmp av bv t p pi r2 c fixed vc xb pending (fun i h => by omega) (by omega)

end FT1536.Source3.CrtWalkLoop206
