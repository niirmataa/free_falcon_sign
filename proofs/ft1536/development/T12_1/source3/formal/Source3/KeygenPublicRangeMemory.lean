import Source3.KeygenPublicUpperImages

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Canonical unsigned16 storage, including partially initialized automatic
   tables. Domain constrains actual defined loads; Initialized separately
   records the input/output cells that must exist. Neither is an evaluation
   or transform-correctness predicate. -/
namespace FT1536.Source3.KeygenPublicRangeMemory
open C99MemoryReference
open C99NarrowReads (Load16)
open KeygenSmallOutput (element Store16 byte16)

def Domain (heap : Memory) (root : ArrayPointer) : Prop :=
  ∀ i w, Load16 heap (element root i) w → w.toNat<18433
def Initialized (heap : Memory) (root : ArrayPointer) (n : Nat) : Prop :=
  ∀ i<n, ∃ w, Load16 heap (element root i) w
def Image (heap : Memory) (root : ArrayPointer) (n : Nat) : Prop :=
  ∀ i<n, ∃ w, Load16 heap (element root i) w ∧ w.toNat<18433

theorem image (heap : Memory) (root : ArrayPointer) (n : Nat)
    (range : Domain heap root) (initialized : Initialized heap root n) : Image heap root n := by
  intro i hi
  obtain ⟨w,read⟩ := initialized i hi
  exact ⟨w,read,range i w read⟩

theorem aligned (heap : Memory) (p : ArrayPointer) (allocated : Allocated heap p)
    (width : p.elementBytes=2) : p.offset%2=0 := by
  have base : p.base%2=0 := by simpa only [width] using allocated.2.1
  change (p.base+p.elementBytes*p.index)%2=0
  rw [width]
  omega

theorem load_allocated (heap : Memory) (p : ArrayPointer) (w : BitVec 16)
    (read : Load16 heap p w) : Allocated heap p ∧ p.elementBytes=2 := by
  cases read
  exact ⟨‹_›,‹_›⟩

theorem byte_frame (before after : Memory) (p q : ArrayPointer) (w : BitVec 16)
    (source : Store16 before p w after) (qa : Allocated after q) (qw : q.elementBytes=2)
    (different : q.block≠p.block ∨ q.offset≠p.offset) :
    ∀ byte : Fin 2, after.bytes q.block (q.offset+byte.val)=before.bytes q.block (q.offset+byte.val) := by
  intro byte
  apply source.2.2.2.2.2.2
  rcases different with blocks | offsets
  · exact Or.inl blocks
  · have pa := aligned before p source.1 source.2.1
    have qa' := aligned after q qa qw
    have bound := byte.isLt
    exact Or.inr (by omega)

theorem read_after_store (before after : Memory) (p q : ArrayPointer) (w old : BitVec 16)
    (source : Store16 before p w after) (read : Load16 after q old) :
    old=w ∨ Load16 before q old := by
  obtain ⟨qa,qw⟩ := load_allocated after q old read
  by_cases same : q.block=p.block ∧ q.offset=p.offset
  · left
    cases read with
    | load bytes allocated width initialized =>
        have equal : bytes=byte16 w := by
          funext byte
          exact Option.some.inj ((initialized byte).symm.trans (by
            rw [same.1,same.2]
            exact source.2.2.2.2.2.1 byte))
        rw [equal,KeygenResidueVectors.join_bytes]
  · right
    exact C99NarrowReads.load16_transport after before q old read source.2.2.2.1.symm
      (fun byte => (byte_frame before after p q w source qa qw (by tauto) byte).symm)

theorem domain_store (before after : Memory) (p root : ArrayPointer) (w : BitVec 16)
    (source : Store16 before p w after) (range : w.toNat<18433) (old : Domain before root) :
    Domain after root := by
  intro i word read
  rcases read_after_store before after p (element root i) w word source read with equal | previous
  · rw [equal]; exact range
  · exact old i word previous

theorem load_survives (before after : Memory) (p q : ArrayPointer) (w old : BitVec 16)
    (source : Store16 before p w after) (read : Load16 before q old) :
    ∃ word, Load16 after q word := by
  obtain ⟨allocated,width⟩ := load_allocated before q old read
  have allocatedAfter : Allocated after q := by
    simpa only [Allocated,source.2.2.2.1] using allocated
  by_cases same : q.block=p.block ∧ q.offset=p.offset
  · refine ⟨w,?_⟩
    have result := Load16.load after q (byte16 w) allocatedAfter width (fun byte => by
      rw [same.1,same.2]
      exact source.2.2.2.2.2.1 byte)
    rw [KeygenResidueVectors.join_bytes] at result
    exact result
  · exact ⟨old,C99NarrowReads.load16_transport before after q old read source.2.2.2.1
      (byte_frame before after p q w source allocatedAfter width (by tauto))⟩

theorem initialized_store (before after : Memory) (p root : ArrayPointer) (w : BitVec 16) (n : Nat)
    (source : Store16 before p w after) (old : Initialized before root n) :
    Initialized after root n := by
  intro i hi
  obtain ⟨word,read⟩ := old i hi
  exact load_survives before after p (element root i) w word source read

theorem domain_same_block (before after : Memory) (root : ArrayPointer)
    (same : ShakeExtractFrame.SameBlock before after root.block) (old : Domain before root) :
    Domain after root := by
  intro i w read
  cases read with
  | load bytes allocated width initialized =>
      have alloc : Allocated before (element root i) := by
        simpa only [Allocated,element,same.1] using allocated
      exact old i _ (.load before (element root i) bytes alloc width
        (fun byte => (same.2.2 _).symm.trans (initialized byte)))

theorem initialized_same_block (before after : Memory) (root : ArrayPointer) (n : Nat)
    (same : ShakeExtractFrame.SameBlock before after root.block) (old : Initialized before root n) :
    Initialized after root n := by
  intro i hi
  obtain ⟨word,read⟩ := old i hi
  cases read with
  | load bytes allocated width initialized =>
      have alloc : Allocated after (element root i) := by
        simpa only [Allocated,element,same.1] using allocated
      exact ⟨_,.load after (element root i) bytes alloc width
        (fun byte => (same.2.2 _).trans (initialized byte))⟩

end FT1536.Source3.KeygenPublicRangeMemory
