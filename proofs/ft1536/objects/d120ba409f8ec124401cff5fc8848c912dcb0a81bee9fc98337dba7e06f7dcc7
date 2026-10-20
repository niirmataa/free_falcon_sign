import Source3.KeygenPublicInputProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Ordinary public coefficients, not Montgomery-scaled table cells. -/
namespace FT1536.Source3.KeygenPublicInputCells
open C99MemoryReference (Memory ArrayPointer Allocated)
open C99NarrowReads (Load16)
open KeygenSmallOutput (element Store16)
open KeygenPublicAlgebra (R Canonical value)

def Cell (heap : Memory) (p : ArrayPointer) (i : Nat) (z : R) : Prop :=
  ∃ w, Load16 heap (element p i) w ∧ w.toNat<18433 ∧ (w.toNat : R)=z
def Cells (heap : Memory) (p : ArrayPointer) (n : Nat) (a : Nat → R) : Prop :=
  ∀ i<n, Cell heap p i (a i)
def Signed (heap : Memory) (p : ArrayPointer) (a : Nat → Int) : Prop :=
  ∀ i<1536, ∃ w, Load16 heap (element p i) w ∧ w.toInt=a i ∧ -(18433 : Int)<a i ∧ a i<18433
def TailEmpty (heap : Memory) (p : ArrayPointer) : Prop :=
  ∀ (i : Nat) (w : BitVec 16), (1536 ≤ i) → ¬Load16 heap (element p i) w

theorem written (before after : Memory) (p : ArrayPointer) (i : Nat) (w : BitVec 32) (z : R)
    (range : Canonical w) (eq : value w=z)
    (source : Store16 before (element p i) (KeygenPublicWord.narrow (.uint32 w)) after) :
    Cell after p i z := by
  refine ⟨_,KeygenPublicTableCells.stored_load _ _ _ _ source,?_,?_⟩
  · rw [KeygenPublicTableCells.narrowing w range]; exact range
  · rw [KeygenPublicTableCells.narrowing w range]; exact eq

theorem preserves (before after : Memory) (p : ArrayPointer) (width : p.elementBytes=2)
    (i j : Nat) (different : i≠j) (w : BitVec 16) (z : R)
    (source : Store16 before (element p i) w after) (cell : Cell before p j z) : Cell after p j z := by
  obtain ⟨old,read,range,eq⟩ := cell
  exact ⟨old,C99NarrowReads.load16_transport _ _ _ _ read source.2.2.2.1
    (fun byte => source.2.2.2.2.2.2 _ _ (KeygenPublicTableCells.different_cell p width i j different byte)),range,eq⟩

theorem other_block (before after : Memory) (p q : ArrayPointer) (i j : Nat) (w : BitVec 16) (z : R)
    (different : p.block≠q.block) (source : Store16 before (element p i) w after)
    (cell : Cell before q j z) : Cell after q j z := by
  obtain ⟨old,read,range,eq⟩ := cell
  exact ⟨old,C99NarrowReads.load16_transport _ _ _ _ read source.2.2.2.1
    (fun _ => source.2.2.2.2.2.2 _ _ (Or.inl (Ne.symm different))),range,eq⟩

theorem signed_other (before after : Memory) (p q : ArrayPointer) (i : Nat) (w : BitVec 16) (a : Nat → Int)
    (different : p.block≠q.block) (source : Store16 before (element p i) w after)
    (input : Signed before q a) : Signed after q a := by
  intro j hj
  obtain ⟨old,read,eq,lower,upper⟩ := input j hj
  exact ⟨old,C99NarrowReads.load16_transport _ _ _ _ read source.2.2.2.1
    (fun _ => source.2.2.2.2.2.2 _ _ (Or.inl (Ne.symm different))),eq,lower,upper⟩

theorem tail_store (before after : Memory) (p root : ArrayPointer) (i : Nat) (w : BitVec 16)
    (width : root.elementBytes=2) (inside : i<1536) (same : p=root ∨ p.block≠root.block)
    (source : Store16 before (element p i) w after) (empty : TailEmpty before root) : TailEmpty after root := by
  intro j old hj read
  rcases same with rfl | different
  · have previous := C99NarrowReads.load16_transport after before (element p j) old read source.2.2.2.1.symm
      (fun byte => (source.2.2.2.2.2.2 _ _ (KeygenPublicTableCells.different_cell p width i j (by omega) byte)).symm)
    exact empty j old hj previous
  · rcases KeygenPublicRangeMemory.read_after_store before after (element p i) (element root j) w old source read with eq | previous
    · cases read with
      | load bytes allocated width initialized =>
          have previous := Load16.load before (element root j) bytes
            (by simpa only [Allocated,source.2.2.2.1] using allocated) width
            (fun byte => (source.2.2.2.2.2.2 _ _ (Or.inl (Ne.symm different))).symm.trans (initialized byte))
          exact empty j _ hj previous
    · exact empty j old hj previous

theorem empty_allocated (heap : Memory) (block count : Nat) :
    TailEmpty (KeygenPublicExec.allocated heap block count) (KeygenPublicExec.localPointer block count) := by
  intro i w hi read
  cases read with
  | load bytes allocated width initialized =>
      have impossible := initialized 0
      simp only [KeygenPublicExec.allocated,KeygenPublicExec.localPointer,element,ite_true] at impossible
      contradiction

theorem image (heap : Memory) (p : ArrayPointer) (a : Nat → R) (input : Cells heap p 1536 a) :
    KeygenPublicRangeMemory.Image heap p 1536 := by
  intro i hi
  obtain ⟨w,read,range,_⟩ := input i hi
  exact ⟨w,read,range⟩

theorem domain (heap : Memory) (p : ArrayPointer) (a : Nat → R)
    (input : Cells heap p 1536 a) (tail : TailEmpty heap p) : KeygenPublicRangeMemory.Domain heap p := by
  intro i w read
  by_cases hi : i<1536
  · obtain ⟨old,loaded,range,_⟩ := input i hi
    rw [C99NarrowReads.load16_deterministic _ _ _ _ read loaded]; exact range
  · exact (tail i w (by omega) read).elim

end FT1536.Source3.KeygenPublicInputCells
