import Source3.KeygenPublicForwardProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Forward-call memory adapters. Automatic-array allocation/disposal changes
   other metadata, so read transport is block-local rather than asserting
   equality of the complete size map. The generator's uninitialized holes
   are retained; they cannot silently become extra canonical table inputs. -/
namespace FT1536.Source3.KeygenPublicForwardMemory
open C99MemoryReference
open C99ArrayReference (State)
open C99NarrowReads (Load16)
open KeygenSmallOutput (element)
open KeygenPublicExec (localPointer allocated localEntry localExit)
open KeygenPublicRangeMemory (Domain Initialized)
open KeygenPublicTableCells (Cell)
open KeygenPublicUpperLoops (PairCells)
open KeygenPublicUpperFrames (UpperFrame)

def Block (before after : Memory) (b : Nat) : Prop :=
  after.size b=before.size b ∧ ∀ offset, after.bytes b offset=before.bytes b offset
theorem block_refl (heap : Memory) (b : Nat) : Block heap heap b := ⟨rfl,fun _ => rfl⟩
theorem block_trans (a b c : Memory) (block : Nat) (first : Block a b block) (second : Block b c block) :
    Block a c block := ⟨second.1.trans first.1,fun offset => (second.2 offset).trans (first.2 offset)⟩
theorem block_symm (before after : Memory) (b : Nat) (same : Block before after b) : Block after before b :=
  ⟨same.1.symm,fun offset => (same.2 offset).symm⟩

theorem load_block (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (same : Block before after p.block) (read : Load16 before p w) : Load16 after p w := by
  cases read with
  | load bytes allocated width initialized =>
      have alloc : Allocated after p := by simpa only [Allocated,same.1] using allocated
      exact .load after p bytes alloc width (fun byte => (same.2 _).trans (initialized byte))
theorem domain_block (before after : Memory) (p : ArrayPointer)
    (same : Block before after p.block) (range : Domain before p) : Domain after p := by
  intro i w read
  exact range i w (load_block after before (element p i) w (block_symm before after p.block same) read)
theorem initialized_block (before after : Memory) (p : ArrayPointer) (n : Nat)
    (same : Block before after p.block) (initialized : Initialized before p n) : Initialized after p n := by
  intro i hi
  obtain ⟨w,read⟩ := initialized i hi
  exact ⟨w,load_block before after (element p i) w same read⟩
theorem initialized_live (heap : Memory) (p : ArrayPointer) (initialized : Initialized heap p 1536) :
    0<heap.size p.block := by
  obtain ⟨w,read⟩ := initialized 0 (by decide)
  obtain ⟨info,width⟩ := KeygenPublicRangeMemory.load_allocated _ _ _ read
  simp only [Allocated,element] at info
  change p.elementBytes=2 at width
  rw [width] at info
  omega

theorem allocated_other (heap : Memory) (localBlock count block : Nat) (outside : block≠localBlock) :
    Block heap (allocated heap localBlock count) block := by
  exact ⟨by simp only [allocated,outside,ite_false],fun _ => by simp only [allocated,outside,ite_false]⟩
theorem disposed_other (before after : Memory) (localBlock block : Nat) (outside : block≠localBlock) :
    Block after (KeygenRngSource.disposed before after localBlock) block := by
  exact ⟨by simp only [KeygenRngSource.disposed,outside,ite_false],
    fun _ => by simp only [KeygenRngSource.disposed,outside,ite_false]⟩
theorem upper_other (before after : Memory) (gm igm : ArrayPointer) (block : Nat)
    (gOutside : block≠gm.block) (iOutside : block≠igm.block) (frame : UpperFrame gm igm before after) :
    Block before after block := by
  refine ⟨congrFun frame.1 block,fun offset => frame.2.2 block offset ?_⟩
  intro p member
  rcases List.mem_cons.mp member with equal | member
  · subst p; exact Or.inl gOutside
  · have equal : p=igm := by simpa using member
    subst p; exact Or.inl iOutside

theorem generated_domain (before after : Memory) (gBlock iBlock : Nat) (different : gBlock≠iBlock)
    (empty : ∀ offset, before.bytes gBlock offset=none)
    (images : PairCells (localPointer gBlock 2048) (localPointer iBlock 2048) after 1)
    (top : Cell after (localPointer gBlock 2048) 0 (KeygenPublicRoots.root^KeygenMkgm3Indices.tableExponent 0))
    (frame : UpperFrame (localPointer gBlock 2048) (localPointer iBlock 2048) before after) :
    Domain after (localPointer gBlock 2048) := by
  intro i w read
  by_cases low : i<1024
  · have cell : ∃ z, Cell after (localPointer gBlock 2048) i z := by
      by_cases zero : i=0
      · subst i; exact ⟨_,top⟩
      · exact ⟨_,(images i (by omega) low).1⟩
    obtain ⟨z,word,loaded,range,scaled⟩ := cell
    rw [C99NarrowReads.load16_deterministic _ _ _ _ read loaded]
    exact range
  · cases read with
    | load bytes allocated width initialized =>
        have byte := initialized 0
        have keep := frame.2.2 gBlock (2*i) (by
          intro p member
          rcases List.mem_cons.mp member with equal | member
          · subst p
            exact Or.inr (Or.inr (by simp only [localPointer,ArrayPointer.offset]; omega))
          · have equal : p=localPointer iBlock 2048 := by simpa using member
            subst p
            exact Or.inl different)
        dsimp only [element,localPointer,ArrayPointer.offset] at byte
        simp only [Fin.val_zero,Nat.zero_add,Nat.add_zero] at byte
        rw [keep,empty] at byte
        cases byte

end FT1536.Source3.KeygenPublicForwardMemory
