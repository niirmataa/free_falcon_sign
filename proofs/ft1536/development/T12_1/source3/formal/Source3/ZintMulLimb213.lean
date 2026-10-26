import Source3.SecondStepReturn212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintMulLimb213
open C99ArrayReference (State Name Pointer restoreScope)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open KeygenWordExec (Exec)
open KeygenWordExpr (Eval)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64 Slot64 expr32 expr64)
open CrtWordOps205 (widen narrow)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open StepCopyBody190 (elem)
open ZintMulWord205 (u cc z m x)

def wide (a b carry : BitVec 32) := widen a*widen b+widen carry
 def low (a b carry : BitVec 32) := narrow (wide a b carry) &&& 2147483647
 def nextCarry (a b carry : BitVec 32) := narrow (wide a b carry >>> 31)
 def d1 (s : State) := C99DeclarationStatements.effect .u64 [z] s
 def d2 (s : State) (a b carry : BitVec 32) := set64 (d1 s) "z" (wide a b carry)
 def d3 (s : State) (p : ArrayPointer) (a b carry : BitVec 32) :=
  {d2 s a b carry with heap:=Word32Memory176.write s.heap p (low a b carry)}
 def d4 (s : State) (p : ArrayPointer) (a b carry : BitVec 32) := set32 (d3 s p a b carry) "cc" (nextCarry a b carry)
 def after (s : State) (p : ArrayPointer) (a b carry : BitVec 32) := restoreScope s (d4 s p a b carry) [z] []

theorem locals (s : State) (p : ArrayPointer) (a b carry : BitVec 32) (name : Name) (other : name≠cc) :
    (after s p a b carry).locals name=s.locals name := by
  by_cases same : name=z
  · subst name
    change (if [z].contains z then s.locals z else (d4 s p a b carry).locals z)=s.locals z
    rfl
  · rw [show (after s p a b carry).locals name=(d4 s p a b carry).locals name from
      WordControl205.restored _ _ [z] name (by simpa only [List.mem_singleton] using same)]
    exact (SelectedStepAddPrime195.locals_keep (d3 s p a b carry) cc .uint32 (.uint32 (nextCarry a b carry)) name other).trans
      ((SelectedStepAddPrime195.locals_keep (d1 s) z .uint64 (.uint64 (wide a b carry)) name same).trans
        (ZintSubWord194.effect_one_other .u64 z name s same))

theorem carry_cell (s : State) (p : ArrayPointer) (a b carry : BitVec 32) : Slot (after s p a b carry) "cc" (nextCarry a b carry) :=
  (WordControl205.restored s (d4 s p a b carry) [z] cc (by decide)).trans (CrtState205.cell32 _ _ _)

theorem source (s : State) (root : ArrayPointer) (i : Nat) (a b carry : BitVec 32)
    (binding : s.arrays m=some root) (uc : Cell s u i) (bound : i < 2^64)
    (xb : Slot s "x" b) (ccCell : Slot s "cc" carry)
    (read : Load32 s.heap (elem root i) a) (writable : s.heap.writable root.block=true) :
    Exec ZintMulWord205.scopedBody s ⟨after s (elem root i) a b carry,.normal⟩ := by
  obtain ⟨alloc,width⟩ : Allocated s.heap (elem root i) ∧ (elem root i).elementBytes=4 := by
    cases read with | load _ h w _ => exact ⟨h,w⟩
  have cap : root.index+i ≤ root.count := by have h:=alloc.2.2.1; change root.index+i < root.count at h; omega
  have u1 : Cell (d1 s) u i := (ZintSubWord194.effect_one_other .u64 z u s (by decide)).trans uc
  have cc1 : Slot (d1 s) "cc" carry := (ZintSubWord194.effect_one_other .u64 z cc s (by decide)).trans ccCell
  have x1 : Slot (d1 s) "x" b := (ZintSubWord194.effect_one_other .u64 z x s (by decide)).trans xb
  have ptr : Pointer (d1 s) m (.var u) (elem root i) := by
    refine .add _ _ root _ (.uint64 (word i)) binding (.variable _ _ _ u1) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]; exact .within root i cap
  have h1 : Exec ZintMulWord205.declZ s ⟨d1 s,.normal⟩ := ZintSubWord194.declare_run .u64 [z] s
  have ze : Eval (d1 s) ZintMulWord205.rhs (.uint64 (wide a b carry)) :=
    .bin .add _ _ _ _ _ (.bin .mul _ _ _ _ _ (WordAtoms205.widen _ _ a (.load32 _ _ _ a ptr read))
      (WordAtoms205.widen _ _ b (expr32 _ "x" b x1)) (CrtWordOps205.mul64 _ _))
      (expr32 _ "cc" carry cc1) (CrtWordOps205.add64_32 _ carry)
  have h2 : Exec ZintMulWord205.setZ (d1 s) ⟨d2 s a b carry,.normal⟩ :=
    WordAtoms205.assign64 _ "z" none _ _ (ZintSubWord194.effect_one_cell .u64 z s) ze
  have z2 : Slot64 (d2 s a b carry) "z" (wide a b carry) := CrtState205.cell64 _ _ _
  have u2 : Cell (d2 s a b carry) u i := (CrtState205.keep64 (d1 s) "z" "u" _ (by decide)).trans u1
  have ptr2 : Pointer (d2 s a b carry) m (.var u) (elem root i) := by
    refine .add _ _ root _ (.uint64 (word i)) binding (.variable _ _ _ u2) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]; exact .within root i cap
  have h3 : Exec ZintMulWord205.storeM (d2 s a b carry) ⟨d3 s (elem root i) a b carry,.normal⟩ :=
    .store _ _ _ _ _ (elem root i) (.uint32 (low a b carry)) ptr2
      (.bin .band _ _ _ _ _ (WordAtoms205.narrow _ _ _ (expr64 _ "z" _ z2))
        (WordAtoms205.literal _ 2147483647) (CrtWordOps205.mask31 _)) (by
        change C99MemoryReference.Store32 s.heap (elem root i) (BitVec.ofInt 32 ((low a b carry).toNat : Int)) _
        rw [ZintSubWord194.ofInt_word]
        exact Word32Memory176.source _ _ _ alloc width writable)
  have cc3 : Slot (d3 s (elem root i) a b carry) "cc" carry := (CrtState205.keep64 (d1 s) "z" "cc" (wide a b carry) (by decide)).trans cc1
  have h4 : Exec ZintMulWord205.setCC (d3 s (elem root i) a b carry) ⟨d4 s (elem root i) a b carry,.normal⟩ :=
    WordAtoms205.assign32 _ "cc" _ _ _ cc3
      (WordAtoms205.narrow _ _ _ (.bin .shr _ _ _ _ _ (expr64 _ "z" _ z2)
        (WordAtoms205.literal _ 31) (CrtWordOps205.right64 (wide a b carry) 31 (by decide))))
  have hi : Exec ZintMulWord205.inner s ⟨d4 s (elem root i) a b carry,.normal⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3 (.seqNormal _ _ _ _ _ h4 (ZintSubWord194.skip_run _))))
  exact .scope _ _ _ _ hi

end FT1536.Source3.ZintMulLimb213
