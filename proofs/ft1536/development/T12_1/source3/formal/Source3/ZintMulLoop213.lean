import Source3.ZintMulStep213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintMulLoop213
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem)
open ZintMulFixed213 (Fixed Pending Written carryWord output next)
open KeygenWordExec (Exec)

theorem guard (s : State) (v n : Nat) (vb : v < 2^64) (nb : n < 2^64)
    (uc : Cell s ZintMulWord205.u v) (len : Cell s ZintMulWord205.mlen n) :
    KeygenWordExpr.Eval s ZintMulWord205.guard (C99ScalarReference.boolean (decide (v < n))) :=
  .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s ZintMulWord205.u v uc))
    (.scalar _ _ (C99LoopScalar141.read s ZintMulWord205.mlen n len)) (C99NatWord141.less v n vb nb)

theorem remaining (count v : Nat) (s : State) (pa : ArrayPointer) (n : Nat) (av : Nat → BitVec 32) (b : BitVec 32)
    (fixed : Fixed s pa n b) (uc : Cell s ZintMulWord205.u v)
    (cc : Slot s "cc" (carryWord av b v)) (pending : Pending s pa n av v) (written : Written s pa av b v)
    (finish : v+count=n) :
    ∃ out, Exec ZintMulWord205.loop s ⟨out,.normal⟩ ∧ Fixed out pa n b ∧ Cell out ZintMulWord205.u n ∧
      Slot out "cc" (carryWord av b n) ∧ Written out pa av b n ∧
      (∀ name : Name, name≠ZintMulWord205.u → name≠ZintMulWord205.cc → out.locals name=s.locals name) ∧
      out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < n → Separate (elem pa i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  induction count generalizing v s with
  | zero =>
    have eq : v=n := by omega
    subst v
    have test : KeygenWordExpr.Eval s ZintMulWord205.guard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard s n n fixed.nBound fixed.nBound uc fixed.lenCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),fixed,uc,cc,written,
      fun _ _ _ => rfl,rfl,fun _ _ _ read => read⟩
  | succ count ih =>
    have slot : v < n := by omega
    obtain ⟨body,update,nextFixed,nextU,nextCC,nextPending,nextWritten,keep⟩:=
      ZintMulStep213.step s pa n v av b fixed slot uc cc pending written
    obtain ⟨out,rest,finalFixed,finalU,finalCC,finalWritten,finalLocals,finalArrays,finalKeep⟩:=
      ih (v+1) (next s pa av b v) nextFixed nextU nextCC nextPending nextWritten (by omega)
    refine ⟨out,?_,finalFixed,finalU,finalCC,finalWritten,?_,finalArrays.trans (ZintMulFixed213.next_arrays s pa av b v),?_⟩
    · refine .loopNormal _ _ _ s (output s pa av b v) (next s pa av b v) ⟨out,.normal⟩
        (C99ScalarReference.boolean (decide (v < n))) ?_ ?_ body update rest
      · exact guard s v n (by have h:=fixed.nBound; omega) fixed.nBound uc fixed.lenCell
      · simp [slot,C99ScalarReference.boolean,Value.integer]
    · intro name nu nc
      exact (finalLocals name nu nc).trans (ZintMulFixed213.next_locals s pa av b v name nu nc)
    · intro q old apart read
      exact finalKeep q old apart (keep q old (apart v slot) read)

end FT1536.Source3.ZintMulLoop213
