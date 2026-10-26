import Source3.ZintAddMulFixed213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintAddMulStep213
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set64)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintAddMulFixed213 (Fixed Pending Written carryWord outputWord output next)
open KeygenWordExec (Exec)

theorem step (s : State) (pa pb : ArrayPointer) (n v : Nat) (av bv : Nat → BitVec 32) (c : BitVec 32)
    (fixed : Fixed s pa pb n bv c) (slot : v < n) (uc : Cell s ZintMulWord205.u v)
    (cc : Slot s "cc" (carryWord av bv c v)) (pending : Pending s pa n av v) (written : Written s pa av bv c v) :
    let mid:=output s pa av bv c v; let out:=next s pa av bv c v
    Exec ZintAddMulWord205.scopedBody s ⟨mid,.normal⟩ ∧ Exec ZintMulWord205.inc mid ⟨out,.normal⟩ ∧
      Fixed out pa pb n bv c ∧ Cell out ZintMulWord205.u (v+1) ∧ Slot out "cc" (carryWord av bv c (v+1)) ∧
      Pending out pa n av (v+1) ∧ Written out pa av bv c (v+1) ∧
      (∀ q old, Separate (elem pa v) q → Load32 s.heap q old → Load32 out.heap q old) := by
  have ra:=pending v (Nat.le_refl v) slot
  have rb:=fixed.bRead v slot
  have bound : v < 2^64 := by have h:=fixed.nBound; omega
  have body:=ZintAddMulLimb213.source s pa pb v (av v) (bv v) c (carryWord av bv c v)
    fixed.aBinding fixed.bBinding uc bound fixed.sCell cc ra rb fixed.writable
  have midU : Cell (output s pa av bv c v) ZintMulWord205.u v :=
    (ZintAddMulLimb213.locals s (elem pa v) (av v) (bv v) c (carryWord av bv c v) ZintMulWord205.u (by decide)).trans uc
  have update : Exec ZintMulWord205.inc (output s pa av bv c v) ⟨next s pa av bv c v,.normal⟩ :=
    ZintSubWord194.update_run _ ZintMulWord205.u .add _ .uint64 (.uint64 (C99NatWord141.word v))
      (.int32 1) (.uint64 (C99NatWord141.word (v+1))) midU (.literal .int32 1) (C99NatWord141.add_one v bound)
  have keep (q : ArrayPointer) (old : BitVec 32) (apart : Separate (elem pa v) q) (read : Load32 s.heap q old) :
      Load32 (next s pa av bv c v).heap q old := Word32Memory176.outside _ _ _ _ _ apart read
  have hl:=ZintAddMulFixed213.next_locals s pa av bv c v
  have afterFixed : Fixed (next s pa av bv c v) pa pb n bv c := by
    refine ⟨fixed.nBound,fixed.width,fixed.capacity,fixed.writable,fixed.aBinding,fixed.bBinding,?_,?_,fixed.tailAllocated,?_,fixed.apart⟩
    · exact (hl ZintAddMulWord205.len (by decide) (by decide)).trans fixed.lenCell
    · exact (hl "s".toList (by decide) (by decide)).trans fixed.sCell
    · intro i bound
      exact keep _ _ (fixed.apart v i slot bound) (fixed.bRead i bound)
  have ccNext : Slot (next s pa av bv c v) "cc" (carryWord av bv c (v+1)) :=
    (CrtState205.keep64 (output s pa av bv c v) "u" "cc" (C99NatWord141.word (v+1)) (by decide)).trans
      (ZintAddMulLimb213.carry_cell s (elem pa v) (av v) (bv v) c (carryWord av bv c v))
  refine ⟨body,update,afterFixed,CrtState205.cell64 _ _ _,ccNext,?_,?_,keep⟩
  · intro i after before
    exact keep _ _ (StepCopyFixed203.elem_separate pa fixed.width v i (by omega)) (pending i (by omega) before)
  · intro i before
    by_cases equal : i=v
    · subst i
      have domain (w : BitVec 32) (read : Load32 s.heap (elem pa v) w) :
          Allocated s.heap (elem pa v) ∧ (elem pa v).elementBytes=4 := by
        cases read with | load _ h w _ => exact ⟨h,w⟩
      obtain ⟨alloc,width⟩:=domain _ ra
      exact Word32Memory176.here _ _ _ alloc width fixed.writable
    · exact keep _ _ (StepCopyFixed203.elem_separate pa fixed.width v i (by omega)) (written i (by omega))

end FT1536.Source3.ZintAddMulStep213
