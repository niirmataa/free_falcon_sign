import Source3.ZintMulWhole213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintAddMulLimb213
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
open ZintMulWord205 (u cc z)
open ZintAddMulWord205 (x y xw yw)

def wide (a b c carry : BitVec 32) := (widen b*widen c+widen a)+widen carry
 def low (a b c carry : BitVec 32) := narrow (wide a b c carry) &&& 2147483647
 def nextCarry (a b c carry : BitVec 32) := narrow (wide a b c carry >>> 31)
 def privateNames : List Name := [xw,yw,z]
 def d1 (s : State) := C99DeclarationStatements.effect .u32 [xw,yw] s
 def d2 (s : State) := C99DeclarationStatements.effect .u64 [z] (d1 s)
 def d3 (s : State) (a : BitVec 32) := set32 (d2 s) "xw" a
 def d4 (s : State) (a b : BitVec 32) := set32 (d3 s a) "yw" b
 def d5 (s : State) (a b c carry : BitVec 32) := set64 (d4 s a b) "z" (wide a b c carry)
 def d6 (s : State) (p : ArrayPointer) (a b c carry : BitVec 32) :=
  {d5 s a b c carry with heap:=Word32Memory176.write s.heap p (low a b c carry)}
 def d7 (s : State) (p : ArrayPointer) (a b c carry : BitVec 32) := set32 (d6 s p a b c carry) "cc" (nextCarry a b c carry)
 def after (s : State) (p : ArrayPointer) (a b c carry : BitVec 32) := restoreScope s (d7 s p a b c carry) privateNames []

theorem before2 (s : State) (name : Name) (hx : name≠xw) (hy : name≠yw) (hz : name≠z) :
    (d2 s).locals name=s.locals name := by
  simp only [d2,d1,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set,hx,hy,hz,ite_false]

theorem locals (s : State) (p : ArrayPointer) (a b c carry : BitVec 32) (name : Name) (other : name≠cc) :
    (after s p a b c carry).locals name=s.locals name := by
  by_cases member : name∈privateNames
  · simp only [after,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,member,ite_true]
  · have hx : name≠xw := by intro eq; apply member; rw [eq]; decide
    have hy : name≠yw := by intro eq; apply member; rw [eq]; decide
    have hz : name≠z := by intro eq; apply member; rw [eq]; decide
    rw [show (after s p a b c carry).locals name=(d7 s p a b c carry).locals name from WordControl205.restored _ _ privateNames name member]
    exact (SelectedStepAddPrime195.locals_keep (d6 s p a b c carry) cc .uint32 (.uint32 (nextCarry a b c carry)) name other).trans
      ((SelectedStepAddPrime195.locals_keep (d4 s a b) z .uint64 (.uint64 (wide a b c carry)) name hz).trans
        ((SelectedStepAddPrime195.locals_keep (d3 s a) yw .uint32 (.uint32 b) name hy).trans
          ((SelectedStepAddPrime195.locals_keep (d2 s) xw .uint32 (.uint32 a) name hx).trans (before2 s name hx hy hz))))

theorem carry_cell (s : State) (p : ArrayPointer) (a b c carry : BitVec 32) : Slot (after s p a b c carry) "cc" (nextCarry a b c carry) :=
  (WordControl205.restored s (d7 s p a b c carry) privateNames cc (by decide)).trans (CrtState205.cell32 _ _ _)

theorem source (s : State) (pa pb : ArrayPointer) (i : Nat) (a b c carry : BitVec 32)
    (px : s.arrays x=some pa) (qy : s.arrays y=some pb) (uc : Cell s u i) (bound : i < 2^64)
    (cs : Slot s "s" c) (ccCell : Slot s "cc" carry)
    (readX : Load32 s.heap (elem pa i) a) (readY : Load32 s.heap (elem pb i) b)
    (writable : s.heap.writable pa.block=true) :
    Exec ZintAddMulWord205.scopedBody s ⟨after s (elem pa i) a b c carry,.normal⟩ := by
  obtain ⟨alloc,width⟩ : Allocated s.heap (elem pa i) ∧ (elem pa i).elementBytes=4 := by
    cases readX with | load _ h w _ => exact ⟨h,w⟩
  have pc : pa.index+i ≤ pa.count := by have h:=alloc.2.2.1; change pa.index+i<pa.count at h; omega
  have qc : pb.index+i ≤ pb.count := by
    have h:=StepProductFixed203.load_allocated readY; have b:=h.2.2.1; change pb.index+i<pb.count at b; omega
  have u2 : Cell (d2 s) u i := (before2 s u (by decide) (by decide) (by decide)).trans uc
  have cc2 : Slot (d2 s) "cc" carry := (before2 s cc (by decide) (by decide) (by decide)).trans ccCell
  have c2 : Slot (d2 s) "s" c := (before2 s "s".toList (by decide) (by decide) (by decide)).trans cs
  have ptrX : Pointer (d2 s) x (.var u) (elem pa i) := by
    refine .add _ _ pa _ (.uint64 (word i)) px (.variable _ _ _ u2) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]; exact .within pa i pc
  have xd : (d2 s).locals xw=some (.uint32,none) := by
    change (d2 s).locals "xw".toList=_
    unfold d2
    rw [ZintSubWord194.effect_one_other .u64 z xw (d1 s) (by decide)]
    simp only [d1,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set]
    rfl
  have rx : Exec ZintAddMulWord205.readX (d2 s) ⟨d3 s a,.normal⟩ := WordAtoms205.assign32 _ "xw" none _ a xd (.load32 _ _ _ a ptrX readX)
  have yd : (d3 s a).locals yw=some (.uint32,none) := by
    change (set32 (d2 s) "xw" a).locals yw=_
    rw [CrtState205.keep32 _ "xw" "yw" a (by decide)]
    unfold d2
    rw [ZintSubWord194.effect_one_other .u64 z yw (d1 s) (by decide)]
    simp only [d1,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set]
    rfl
  have u3 : Cell (d3 s a) u i := (CrtState205.keep32 (d2 s) "xw" "u" a (by decide)).trans u2
  have ptrY : Pointer (d3 s a) y (.var u) (elem pb i) := by
    refine .add _ _ pb _ (.uint64 (word i)) qy (.variable _ _ _ u3) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]; exact .within pb i qc
  have ry : Exec ZintAddMulWord205.readY (d3 s a) ⟨d4 s a b,.normal⟩ := WordAtoms205.assign32 _ "yw" none _ b yd (.load32 _ _ _ b ptrY readY)
  have a4 : Slot (d4 s a b) "xw" a := (CrtState205.keep32 (d3 s a) "yw" "xw" b (by decide)).trans (CrtState205.cell32 _ _ _)
  have b4 : Slot (d4 s a b) "yw" b := CrtState205.cell32 _ _ _
  have c4 : Slot (d4 s a b) "s" c := (CrtState205.keep32 (d3 s a) "yw" "s" b (by decide)).trans ((CrtState205.keep32 (d2 s) "xw" "s" a (by decide)).trans c2)
  have cc4 : Slot (d4 s a b) "cc" carry := (CrtState205.keep32 (d3 s a) "yw" "cc" b (by decide)).trans ((CrtState205.keep32 (d2 s) "xw" "cc" a (by decide)).trans cc2)
  have ze : Eval (d4 s a b) ZintAddMulWord205.rhs (.uint64 (wide a b c carry)) :=
    .bin .add _ _ _ _ _ (.bin .add _ _ _ _ _
      (.bin .mul _ _ _ _ _ (WordAtoms205.widen _ _ b (expr32 _ "yw" b b4))
        (WordAtoms205.widen _ _ c (expr32 _ "s" c c4)) (CrtWordOps205.mul64 _ _))
      (WordAtoms205.widen _ _ a (expr32 _ "xw" a a4)) (CrtWordOps205.add64 _ _))
      (WordAtoms205.widen _ _ carry (expr32 _ "cc" carry cc4)) (CrtWordOps205.add64 _ _)
  have zd : (d4 s a b).locals z=some (.uint64,none) := by
    unfold d4
    rw [CrtState205.keep32 _ "yw" "z" b (by decide)]
    unfold d3
    rw [CrtState205.keep32 _ "xw" "z" a (by decide)]
    exact ZintSubWord194.effect_one_cell .u64 z (d1 s)
  have rz : Exec ZintAddMulWord205.setZ (d4 s a b) ⟨d5 s a b c carry,.normal⟩ := WordAtoms205.assign64 _ "z" none _ _ zd ze
  have z5 : Slot64 (d5 s a b c carry) "z" (wide a b c carry) := CrtState205.cell64 _ _ _
  have u4 : Cell (d4 s a b) u i := (CrtState205.keep32 (d3 s a) "yw" "u" b (by decide)).trans u3
  have u5 : Cell (d5 s a b c carry) u i := (CrtState205.keep64 (d4 s a b) "z" "u" (wide a b c carry) (by decide)).trans u4
  have ptr5 : Pointer (d5 s a b c carry) x (.var u) (elem pa i) := by
    refine .add _ _ pa _ (.uint64 (word i)) px (.variable _ _ _ u5) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]; exact .within pa i pc
  have store : Exec ZintAddMulWord205.storeX (d5 s a b c carry) ⟨d6 s (elem pa i) a b c carry,.normal⟩ :=
    .store _ _ _ _ _ (elem pa i) (.uint32 (low a b c carry)) ptr5
      (.bin .band _ _ _ _ _ (WordAtoms205.narrow _ _ _ (expr64 _ "z" _ z5))
        (WordAtoms205.literal _ 2147483647) (CrtWordOps205.mask31 _)) (by
        change C99MemoryReference.Store32 s.heap (elem pa i) (BitVec.ofInt 32 ((low a b c carry).toNat : Int)) _
        rw [ZintSubWord194.ofInt_word]; exact Word32Memory176.source _ _ _ alloc width writable)
  have cc6 : Slot (d6 s (elem pa i) a b c carry) "cc" carry := (CrtState205.keep64 (d4 s a b) "z" "cc" (wide a b c carry) (by decide)).trans cc4
  have rc : Exec ZintAddMulWord205.setCC (d6 s (elem pa i) a b c carry) ⟨d7 s (elem pa i) a b c carry,.normal⟩ :=
    WordAtoms205.assign32 _ "cc" _ _ _ cc6
      (WordAtoms205.narrow _ _ _ (.bin .shr _ _ _ _ _ (expr64 _ "z" _ z5)
        (WordAtoms205.literal _ 31) (CrtWordOps205.right64 (wide a b c carry) 31 (by decide))))
  have inner : Exec ZintAddMulWord205.inner s ⟨d7 s (elem pa i) a b c carry,.normal⟩ :=
    .seqNormal _ _ _ _ _ (ZintSubWord194.declare_run .u32 [xw,yw] s)
      (.seqNormal _ _ _ _ _ (ZintSubWord194.declare_run .u64 [z] (d1 s))
        (.seqNormal _ _ _ _ _ rx (.seqNormal _ _ _ _ _ ry (.seqNormal _ _ _ _ _ rz
          (.seqNormal _ _ _ _ _ store (.seqNormal _ _ _ _ _ rc (ZintSubWord194.skip_run _)))))))
  exact .scope _ _ _ _ inner

end FT1536.Source3.ZintAddMulLimb213
