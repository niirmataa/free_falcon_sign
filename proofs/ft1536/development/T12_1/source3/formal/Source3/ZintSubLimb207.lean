import Source3.CrtCoLoop256206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSubLimb207
open C99ArrayReference (State Name Pointer restoreScope)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open KeygenWordExec (Exec)
open KeygenWordExpr (Eval)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open StepCopyBody190 (elem)
open ZintSubWord194 (aName bName uName ccName wName)

def difference (a b cc : BitVec 32) := (a-b)-cc
 def limb (a b cc : BitVec 32) := difference a b cc &&& 2147483647
 def borrow (a b cc : BitVec 32) := difference a b cc >>> 31
 def d1 (s : State) := C99DeclarationStatements.effect .u32 [wName] s
 def d2 (s : State) (a b cc : BitVec 32) := set32 (d1 s) "w" (difference a b cc)
 def d3 (s : State) (p : ArrayPointer) (a b cc : BitVec 32) :=
  {d2 s a b cc with heap:=Word32Memory176.write s.heap p (limb a b cc)}
 def d4 (s : State) (p : ArrayPointer) (a b cc : BitVec 32) := set32 (d3 s p a b cc) "cc" (borrow a b cc)
 def after (s : State) (p : ArrayPointer) (a b cc : BitVec 32) := restoreScope s (d4 s p a b cc) [wName] []

theorem locals (s : State) (p : ArrayPointer) (a b cc : BitVec 32) (name : Name) (other : name≠ccName) :
    (after s p a b cc).locals name=s.locals name := by
  by_cases same : name=wName
  · subst name
    change (if [wName].contains wName then s.locals wName else (d4 s p a b cc).locals wName)=s.locals wName
    rw [show [wName].contains wName=true by decide]
    rfl
  · rw [show (after s p a b cc).locals name=(d4 s p a b cc).locals name from
      WordControl205.restored _ _ [wName] name (by simpa only [List.mem_singleton] using same)]
    exact (SelectedStepAddPrime195.locals_keep (d3 s p a b cc) ccName .uint32 (.uint32 (borrow a b cc)) name other).trans
      ((SelectedStepAddPrime195.locals_keep (d1 s) wName .uint32 (.uint32 (difference a b cc)) name same).trans
        (ZintSubWord194.effect_one_other .u32 wName name s same))

theorem ccCell (s : State) (p : ArrayPointer) (a b cc : BitVec 32) : Slot (after s p a b cc) "cc" (borrow a b cc) := by
  unfold Slot after
  exact (WordControl205.restored s (d4 s p a b cc) [wName] "cc".toList (by decide)).trans
    (CrtState205.cell32 (d3 s p a b cc) "cc" (borrow a b cc))

theorem source (s : State) (pa pb : ArrayPointer) (i : Nat) (a b cc : BitVec 32)
    (aa : s.arrays aName=some pa) (ba : s.arrays bName=some pb)
    (uc : Cell s uName i) (bound : i < 2^64) (cc0 : Slot s "cc" cc)
    (ra : Load32 s.heap (elem pa i) a) (rb : Load32 s.heap (elem pb i) b)
    (writable : s.heap.writable pa.block=true) :
    Exec ZintSubWord194.bodyScope s ⟨after s (elem pa i) a b cc,.normal⟩ := by
  obtain ⟨alloc,width⟩ : Allocated s.heap (elem pa i) ∧ (elem pa i).elementBytes=4 := by
    cases ra with | load _ h w _ => exact ⟨h,w⟩
  have aCap : pa.index+i ≤ pa.count := by have h:=alloc.2.2.1; change pa.index+i < pa.count at h; omega
  have bCap : pb.index+i ≤ pb.count := by
    cases rb with | load _ h _ _ => have h1:=h.2.2.1; change pb.index+i < pb.count at h1; omega
  have u1 : Cell (d1 s) uName i := (ZintSubWord194.effect_one_other .u32 wName uName s (by decide)).trans uc
  have cc1 : Slot (d1 s) "cc" cc := (ZintSubWord194.effect_one_other .u32 wName ccName s (by decide)).trans cc0
  have ptrA : Pointer (d1 s) aName (.var uName) (elem pa i) := by
    refine .add _ _ pa _ (.uint64 (word i)) aa (.variable _ _ _ u1) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]
      exact .within pa i aCap
  have ptrB : Pointer (d1 s) bName (.var uName) (elem pb i) := by
    refine .add _ _ pb _ (.uint64 (word i)) ba (.variable _ _ _ u1) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]
      exact .within pb i bCap
  have h1 : Exec ZintSubWord194.declW s ⟨d1 s,.normal⟩ := ZintSubWord194.declare_run .u32 [wName] s
  have h2 : Exec ZintSubWord194.setW (d1 s) ⟨d2 s a b cc,.normal⟩ :=
    WordAtoms205.assign32 _ "w" none _ (difference a b cc) (ZintSubWord194.effect_one_cell .u32 wName s)
      (.bin .sub _ _ _ _ _ (.bin .sub _ _ _ _ _ (.load32 _ _ _ a ptrA ra) (.load32 _ _ _ b ptrB rb)
        (KeygenDecodeWordOps.sub32 a b)) (CrtState205.expr32 _ "cc" cc cc1) (KeygenDecodeWordOps.sub32 (a-b) cc))
  have u2 : Cell (d2 s a b cc) uName i := (CrtState205.keep32 (d1 s) "w" "u" (difference a b cc) (by decide)).trans u1
  have w2 : Slot (d2 s a b cc) "w" (difference a b cc) := CrtState205.cell32 _ _ _
  have ptr2 : Pointer (d2 s a b cc) aName (.var uName) (elem pa i) := by
    refine .add _ _ pa _ (.uint64 (word i)) aa (.variable _ _ _ u2) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]
      exact .within pa i aCap
  have h3 : Exec ZintSubWord194.storeA (d2 s a b cc) ⟨d3 s (elem pa i) a b cc,.normal⟩ :=
    .store _ _ _ _ _ (elem pa i) (.uint32 (limb a b cc)) ptr2
      (.bin .band _ _ _ _ _ (CrtState205.expr32 _ "w" _ w2)
        (WordAtoms205.literal _ 2147483647) (CrtWordOps205.mask31 _)) (by
        change C99MemoryReference.Store32 s.heap (elem pa i) (BitVec.ofInt 32 ((limb a b cc).toNat : Int)) _
        rw [ZintSubWord194.ofInt_word]
        exact Word32Memory176.source _ _ _ alloc width writable)
  have cc3 : Slot (d3 s (elem pa i) a b cc) "cc" cc :=
    (CrtState205.keep32 (d1 s) "w" "cc" (difference a b cc) (by decide)).trans cc1
  have h4 : Exec ZintSubWord194.setCC1 (d3 s (elem pa i) a b cc) ⟨d4 s (elem pa i) a b cc,.normal⟩ :=
    WordAtoms205.assign32 _ "cc" _ _ _ cc3
      (.bin .shr _ _ _ _ _ (CrtState205.expr32 _ "w" _ w2) (WordAtoms205.literal _ 31)
        (KeygenDecodeWordOps.right32 (difference a b cc) 31 (by decide)))
  have hs : Exec ZintSubWord194.bodySkip (d4 s (elem pa i) a b cc) ⟨d4 s (elem pa i) a b cc,.normal⟩ := ZintSubWord194.skip_run _
  have hi : Exec ZintSubWord194.bodyInner s ⟨d4 s (elem pa i) a b cc,.normal⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3 (.seqNormal _ _ _ _ _ h4 hs)))
  exact .scope _ _ _ _ hi

end FT1536.Source3.ZintSubLimb207
