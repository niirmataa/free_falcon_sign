import Source3.CrtRound206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCoLoop206
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open Word32Memory176 (Separate)
open CrtRoundReady206 (Input)
open CrtWalkFixed206 (Pending Written high)
open CrtWalkIncrement206 (cell)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open CrtPrimePrefix206 (s1)
open KeygenZintCall (Exec)

theorem increment_shape : ZintRebuildCrt194.coInc=
    .word (.modular (.base (.scalar (.update "u".toList .add (.literal .i32 1))))) := by decide

theorem guard (s : State) (v : Nat) (bound : v < 2^64)
    (u : Cell s "u".toList v) (len : Cell s "xlen".toList 2) :
    KeygenWordExpr.Eval s ZintRebuildCrt194.coGuard (C99ScalarReference.boolean (decide (v < 2))) := by
  rw [ZintRebuildCrt194.co_guard]
  exact .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s "u".toList v u))
    (.scalar _ _ (C99LoopScalar141.read s "xlen".toList 2 len)) (C99NatWord141.less v 2 bound (by decide))

theorem source {n : Nat} (s : State) (root tmp : ArrayPointer) (av bv : Fin n → BitVec 32)
    (t : BitVec 32) (input : Input s root tmp n t) (len : Cell s "xlen".toList 2)
    (pending : Pending s root av bv 0) :
    ∃ out, Exec ZintRebuildCrt194.coLoop s ⟨out,.normal⟩ ∧ Written out root av bv t p1 p0i1 r21 s1 n ∧
      Load32 out.heap tmp (ZintMulWord205.low t p1) ∧
      Load32 out.heap (ZintAddMulWord205.next tmp) (ZintMulWord205.carry t p1) ∧ Cell out "u".toList 2 ∧
      out.arrays "x".toList=some (cell root n) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i : Fin n, Separate (cell root i.val) q ∧ Separate (high root i.val) q) →
        Separate tmp q → Separate (ZintAddMulWord205.next tmp) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨round,roundRun,written,lo,hi,locals,xptr,arrays,keep⟩:=CrtRound206.source s root tmp av bv t input pending
  have u1 : Cell round "u".toList 1 := (congrFun locals "u".toList).trans input.uCell
  have len1 : Cell round "xlen".toList 2 := (congrFun locals "xlen".toList).trans len
  have update : Exec ZintRebuildCrt194.coInc round ⟨set64 round "u" 2,.normal⟩ := by
    rw [increment_shape]
    exact .word _ _ _ (ZintSubWord194.update_run _ "u".toList .add _ .uint64 (.uint64 1) (.int32 1)
      (.uint64 2) u1 (.literal .int32 1) (C99NatWord141.add_one 1 (by decide)))
  have u2 : Cell (set64 round "u" 2) "u".toList 2 := CrtState205.cell64 _ _ _
  have len2 : Cell (set64 round "u" 2) "xlen".toList 2 :=
    (CrtState205.keep64 round "u" "xlen" 2 (by decide)).trans len1
  have terminal : Exec ZintRebuildCrt194.coLoop (set64 round "u" 2) ⟨set64 round "u" 2,.normal⟩ := by
    rw [ZintRebuildCrt194.co_split]
    exact .loopFalse _ _ _ _ (.int32 0) (guard _ 2 (by decide) u2 len2) (by decide)
  refine ⟨set64 round "u" 2,?_,written,lo,hi,u2,xptr,?_,arrays,keep⟩
  · rw [ZintRebuildCrt194.co_split]
    exact .loopNormal _ _ _ s round (set64 round "u" 2) ⟨set64 round "u" 2,.normal⟩ (.int32 1)
      (guard s 1 (by decide) input.uCell len) (by decide) roundRun update terminal
  · intro name different
    exact (SelectedStepAddPrime195.locals_keep round "u".toList .uint64 (.uint64 2) name different).trans
      (congrFun locals name)

end FT1536.Source3.CrtCoLoop206
