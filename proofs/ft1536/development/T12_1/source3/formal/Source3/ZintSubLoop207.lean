import Source3.ZintSubStep207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSubLoop207
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem)
open ZintSubFixed207 (Fixed Pending Written borrowWord output next)
open KeygenWordExec (Exec)

theorem guard (s : State) (v n : Nat) (vb : v < 2^64) (nb : n < 2^64)
    (uc : Cell s ZintSubWord194.uName v) (len : Cell s ZintSubWord194.lenName n) :
    KeygenWordExpr.Eval s ZintSubWord194.guard (C99ScalarReference.boolean (decide (v < n))) :=
  .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s ZintSubWord194.uName v uc))
    (.scalar _ _ (C99LoopScalar141.read s ZintSubWord194.lenName n len)) (C99NatWord141.less v n vb nb)

theorem remaining (count v : Nat) (s : State) (pa pb : ArrayPointer) (n : Nat) (av bv : Nat → BitVec 32)
    (fixed : Fixed s pa pb n bv) (uc : Cell s ZintSubWord194.uName v)
    (cc : Slot s "cc" (borrowWord av bv v)) (pending : Pending s pa n av v) (written : Written s pa av bv v)
    (finish : v+count=n) :
    ∃ out, Exec ZintSubWord194.loop s ⟨out,.normal⟩ ∧ Fixed out pa pb n bv ∧ Cell out ZintSubWord194.uName n ∧
      Slot out "cc" (borrowWord av bv n) ∧ Written out pa av bv n ∧
      (∀ name : Name, name≠ZintSubWord194.uName → name≠ZintSubWord194.ccName → out.locals name=s.locals name) ∧
      out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < n → Separate (elem pa i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  induction count generalizing v s with
  | zero =>
    have eq : v=n := by omega
    subst v
    have test : KeygenWordExpr.Eval s ZintSubWord194.guard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard s n n fixed.nBound fixed.nBound uc fixed.lenCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),fixed,uc,cc,written,
      fun _ _ _ => rfl,rfl,fun _ _ _ read => read⟩
  | succ count ih =>
    have slot : v < n := by omega
    obtain ⟨body,update,nextFixed,nextU,nextCC,nextPending,nextWritten,keep⟩:=
      ZintSubStep207.step s pa pb n v av bv fixed slot uc cc pending written
    obtain ⟨out,rest,finalFixed,finalU,finalCC,finalWritten,finalLocals,finalArrays,finalKeep⟩:=
      ih (v+1) (next s pa av bv v) nextFixed nextU nextCC nextPending nextWritten (by omega)
    refine ⟨out,?_,finalFixed,finalU,finalCC,finalWritten,?_,finalArrays.trans (ZintSubFixed207.next_arrays s pa av bv v),?_⟩
    · refine .loopNormal _ _ _ s (output s pa av bv v) (next s pa av bv v) ⟨out,.normal⟩
        (C99ScalarReference.boolean (decide (v < n))) ?_ ?_ body update rest
      · exact guard s v n (by have h:=fixed.nBound; omega) fixed.nBound uc fixed.lenCell
      · simp [slot,C99ScalarReference.boolean,Value.integer]
    · intro name nu nc
      exact (finalLocals name nu nc).trans (ZintSubFixed207.next_locals s pa av bv v name nu nc)
    · intro q old apart read
      exact finalKeep q old apart (keep q old (apart v slot) read)

end FT1536.Source3.ZintSubLoop207
