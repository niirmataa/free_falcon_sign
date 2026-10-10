import Source3.KeygenMakeCertCall
import Source3.C99InitializationTrace

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Workspace relocation: a block transposition of the caller heap that moves
   the general `fk->tmp` scratch descriptor into the certificate model's
   block0. Relocation is an isomorphism of the byte machine: every primitive
   relation (allocation, loads, stores, memcpy, initialization, preservation
   and the derived step trace) is preserved and reflected, so caller-side
   source facts hold in the relocated world up to the block label. After
   relocation the workspace bridge loses its block condition and becomes
   exactly the workspace-extent condition. No bridge equality, scratch block
   fact or certificate outcome is a premise of any theorem below. -/
namespace FT1536.Source3.KeygenMakeWorkspaceRelocation
open C99MemoryReference
open C99InitializationTrace

/-! ## 1. The block transposition -/

/-- Swap heap blocks `0` and `b`; every other block label is fixed. -/
def swapBlock (b : Nat) : Nat → Nat := fun i => if i=0 then b else if i=b then 0 else i

theorem swapBlock_zero (b : Nat) : swapBlock b 0=b := by simp [swapBlock]
theorem swapBlock_self_zero (b : Nat) : swapBlock b b=0 := by
  by_cases h : b=0 <;> simp [swapBlock,h]
theorem swapBlock_fixed (b i : Nat) (nonzero : i≠0) (different : i≠b) : swapBlock b i=i := by
  simp [swapBlock,nonzero,different]
theorem swapBlock_self (b i : Nat) : swapBlock b (swapBlock b i)=i := by
  unfold swapBlock
  by_cases h0 : i=0
  · by_cases hb : b=0 <;> simp [h0,hb]
  · by_cases hi : i=b
    · by_cases hb : b=0
      · simp [hi,hb]
      · simp [hi,hb]
    · simp [h0,hi]

/-! ## 2. Memory and pointer transport -/

def swap (b : Nat) (h : Memory) : Memory where
  bytes := fun block offset => h.bytes (swapBlock b block) offset
  size := fun block => h.size (swapBlock b block)
  writable := fun block => h.writable (swapBlock b block)

def swapPtr (b : Nat) (p : ArrayPointer) : ArrayPointer :=
  {p with block := swapBlock b p.block}

theorem arrayPointer_ext (p q : ArrayPointer) (hblock : p.block=q.block)
    (hbase : p.base=q.base) (hcount : p.count=q.count)
    (helementBytes : p.elementBytes=q.elementBytes) (hindex : p.index=q.index) : p=q := by
  cases p
  cases q
  simp only [ArrayPointer.mk.injEq]
  exact ⟨hblock,hbase,hcount,helementBytes,hindex⟩

theorem memory_ext (h k : Memory)
    (bytes : ∀ block offset, h.bytes block offset=k.bytes block offset)
    (size : ∀ block, h.size block=k.size block)
    (writable : ∀ block, h.writable block=k.writable block) : h=k := by
  cases h
  cases k
  simp only [Memory.mk.injEq]
  exact ⟨funext fun block => funext fun offset => bytes block offset,funext size,funext writable⟩

theorem swap_bytes (b : Nat) (h : Memory) (block offset : Nat) :
    (swap b h).bytes block offset=h.bytes (swapBlock b block) offset := rfl
theorem swap_size (b : Nat) (h : Memory) (block : Nat) :
    (swap b h).size block=h.size (swapBlock b block) := rfl
theorem swap_writable (b : Nat) (h : Memory) (block : Nat) :
    (swap b h).writable block=h.writable (swapBlock b block) := rfl
theorem swap_zero (h : Memory) : swap 0 h=h :=
  memory_ext _ _ (fun block offset => by rw [swap_bytes]; by_cases hb : block=0 <;> simp [swapBlock,hb])
    (fun block => by rw [swap_size]; by_cases hb : block=0 <;> simp [swapBlock,hb])
    (fun block => by rw [swap_writable]; by_cases hb : block=0 <;> simp [swapBlock,hb])
theorem swap_swap (b : Nat) (h : Memory) : swap b (swap b h)=h :=
  memory_ext _ _ (fun block offset => by rw [swap_bytes,swap_bytes,swapBlock_self])
    (fun block => by rw [swap_size,swap_size,swapBlock_self])
    (fun block => by rw [swap_writable,swap_writable,swapBlock_self])

theorem swapPtr_block (b : Nat) (p : ArrayPointer) :
    (swapPtr b p).block=swapBlock b p.block := rfl
theorem swapPtr_offset (b : Nat) (p : ArrayPointer) :
    (swapPtr b p).offset=p.offset := rfl
theorem swapPtr_base (b : Nat) (p : ArrayPointer) : (swapPtr b p).base=p.base := rfl
theorem swapPtr_count (b : Nat) (p : ArrayPointer) : (swapPtr b p).count=p.count := rfl
theorem swapPtr_elementBytes (b : Nat) (p : ArrayPointer) :
    (swapPtr b p).elementBytes=p.elementBytes := rfl
theorem swapPtr_index (b : Nat) (p : ArrayPointer) : (swapPtr b p).index=p.index := rfl
theorem swapPtr_fields (b : Nat) (p : ArrayPointer) :
    (swapPtr b p).base=p.base ∧ (swapPtr b p).count=p.count ∧
      (swapPtr b p).elementBytes=p.elementBytes ∧ (swapPtr b p).index=p.index :=
  ⟨rfl,rfl,rfl,rfl⟩
theorem swapPtr_zero (p : ArrayPointer) : swapPtr 0 p=p := by
  cases p with
  | mk block base count elementBytes index =>
    show (⟨swapBlock 0 block,base,count,elementBytes,index⟩ : ArrayPointer)=_
    by_cases hb : block=0 <;> simp [swapBlock,hb]
theorem swapPtr_swapPtr (b : Nat) (p : ArrayPointer) : swapPtr b (swapPtr b p)=p := by
  cases p with
  | mk block base count elementBytes index =>
    show (⟨swapBlock b (swapBlock b block),base,count,elementBytes,index⟩ : ArrayPointer)=_
    rw [swapBlock_self]

/-! ## 3. Primitive relation transport -/

theorem allocated_forward (b : Nat) (h : Memory) (p : ArrayPointer)
    (source : Allocated h p) : Allocated (swap b h) (swapPtr b p) := by
  refine ⟨source.1,source.2.1,source.2.2.1,?_,?_⟩
  · rw [swap_size,swapPtr_block,swapBlock_self]
    exact source.2.2.2.1
  · rw [swap_size,swapPtr_block,swapBlock_self]
    exact source.2.2.2.2

theorem allocated_swap (b : Nat) (h : Memory) (p : ArrayPointer) :
    Allocated h p ↔ Allocated (swap b h) (swapPtr b p) :=
  ⟨allocated_forward b h p,fun source => by
    simpa only [swap_swap,swapPtr_swapPtr] using allocated_forward b (swap b h) (swapPtr b p) source⟩

theorem load64_forward (b : Nat) (h : Memory) (p : ArrayPointer) (w : BitVec 64)
    (source : Load64 h p w) : Load64 (swap b h) (swapPtr b p) w := by
  cases source with
  | load bytes allocated typeSize initialized =>
    refine Load64.load (swap b h) (swapPtr b p) bytes (allocated_forward b h p allocated) typeSize ?_
    intro i
    rw [swap_bytes,swapPtr_block,swapBlock_self,swapPtr_offset]
    exact initialized i

theorem load64_swap (b : Nat) (h : Memory) (p : ArrayPointer) (w : BitVec 64) :
    Load64 h p w ↔ Load64 (swap b h) (swapPtr b p) w :=
  ⟨load64_forward b h p w,fun source => by
    simpa only [swap_swap,swapPtr_swapPtr] using load64_forward b (swap b h) (swapPtr b p) w source⟩

theorem load32_forward (b : Nat) (h : Memory) (p : ArrayPointer) (w : BitVec 32)
    (source : Load32 h p w) : Load32 (swap b h) (swapPtr b p) w := by
  cases source with
  | load bytes allocated typeSize initialized =>
    refine Load32.load (swap b h) (swapPtr b p) bytes (allocated_forward b h p allocated) typeSize ?_
    intro i
    rw [swap_bytes,swapPtr_block,swapBlock_self,swapPtr_offset]
    exact initialized i

theorem load32_swap (b : Nat) (h : Memory) (p : ArrayPointer) (w : BitVec 32) :
    Load32 h p w ↔ Load32 (swap b h) (swapPtr b p) w :=
  ⟨load32_forward b h p w,fun source => by
    simpa only [swap_swap,swapPtr_swapPtr] using load32_forward b (swap b h) (swapPtr b p) w source⟩

theorem size_function_swap (b : Nat) (before after : Memory) (equal : after.size=before.size) :
    (swap b after).size=(swap b before).size := by
  funext block
  rw [swap_size,swap_size]
  exact congrFun equal (swapBlock b block)

theorem writable_function_swap (b : Nat) (before after : Memory)
    (equal : after.writable=before.writable) : (swap b after).writable=(swap b before).writable := by
  funext block
  rw [swap_writable,swap_writable]
  exact congrFun equal (swapBlock b block)

theorem size_function_swap_back (b : Nat) (before after : Memory)
    (equal : (swap b after).size=(swap b before).size) : after.size=before.size := by
  funext block
  have keep := congrFun equal (swapBlock b block)
  rw [swap_size,swap_size,swapBlock_self] at keep
  exact keep

theorem writable_function_swap_back (b : Nat) (before after : Memory)
    (equal : (swap b after).writable=(swap b before).writable) : after.writable=before.writable := by
  funext block
  have keep := congrFun equal (swapBlock b block)
  rw [swap_writable,swap_writable,swapBlock_self] at keep
  exact keep

theorem store64_forward (b : Nat) (before after : Memory) (p : ArrayPointer) (w : BitVec 64)
    (source : Store64 before p w after) :
    Store64 (swap b before) (swapPtr b p) w (swap b after) := by
  obtain ⟨allocated,width,writable,size,unchanged,written,frame⟩ := source
  refine ⟨allocated_forward b before p allocated,width,?_,?_,?_,?_,?_⟩
  · rw [swap_writable,swapPtr_block,swapBlock_self]
    exact writable
  · exact size_function_swap b before after size
  · exact writable_function_swap b before after unchanged
  · intro i
    rw [swap_bytes,swapPtr_block,swapBlock_self,swapPtr_offset]
    exact written i
  · intro block offset outside
    rw [swap_bytes,swap_bytes]
    apply frame (swapBlock b block) offset
    rcases outside with different | under | over
    · by_cases same : swapBlock b block=p.block
      · have impossible : block=(swapPtr b p).block := by
          rw [swapPtr_block,← swapBlock_self b block]
          exact congrArg (swapBlock b) same
        exact (different impossible).elim
      · exact Or.inl same
    · rw [swapPtr_offset] at under
      exact Or.inr (Or.inl under)
    · rw [swapPtr_offset] at over
      exact Or.inr (Or.inr over)

theorem store64_swap (b : Nat) (before after : Memory) (p : ArrayPointer) (w : BitVec 64) :
    Store64 before p w after ↔ Store64 (swap b before) (swapPtr b p) w (swap b after) :=
  ⟨store64_forward b before after p w,fun source => by
    simpa only [swap_swap,swapPtr_swapPtr] using
      store64_forward b (swap b before) (swap b after) (swapPtr b p) w source⟩

theorem store32_forward (b : Nat) (before after : Memory) (p : ArrayPointer) (w : BitVec 32)
    (source : Store32 before p w after) :
    Store32 (swap b before) (swapPtr b p) w (swap b after) := by
  obtain ⟨allocated,width,writable,size,unchanged,written,frame⟩ := source
  refine ⟨allocated_forward b before p allocated,width,?_,?_,?_,?_,?_⟩
  · rw [swap_writable,swapPtr_block,swapBlock_self]
    exact writable
  · exact size_function_swap b before after size
  · exact writable_function_swap b before after unchanged
  · intro i
    rw [swap_bytes,swapPtr_block,swapBlock_self,swapPtr_offset]
    exact written i
  · intro block offset outside
    rw [swap_bytes,swap_bytes]
    apply frame (swapBlock b block) offset
    rcases outside with different | under | over
    · by_cases same : swapBlock b block=p.block
      · have impossible : block=(swapPtr b p).block := by
          rw [swapPtr_block,← swapBlock_self b block]
          exact congrArg (swapBlock b) same
        exact (different impossible).elim
      · exact Or.inl same
    · rw [swapPtr_offset] at under
      exact Or.inr (Or.inl under)
    · rw [swapPtr_offset] at over
      exact Or.inr (Or.inr over)

theorem store32_swap (b : Nat) (before after : Memory) (p : ArrayPointer) (w : BitVec 32) :
    Store32 before p w after ↔ Store32 (swap b before) (swapPtr b p) w (swap b after) :=
  ⟨store32_forward b before after p w,fun source => by
    simpa only [swap_swap,swapPtr_swapPtr] using
      store32_forward b (swap b before) (swap b after) (swapPtr b p) w source⟩

theorem memcpy_forward (b : Nat) (before after : Memory) (dst src : ArrayPointer) (count : Nat)
    (source : Memcpy before dst src count after) :
    Memcpy (swap b before) (swapPtr b dst) (swapPtr b src) count (swap b after) := by
  obtain ⟨dstFit,srcFit,dstBound,srcBound,writable,separate,read,size,unchanged,copy,frame⟩ := source
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [swapPtr_offset,swap_size,swapPtr_block,swapBlock_self]
    exact dstFit
  · rw [swapPtr_offset,swap_size,swapPtr_block,swapBlock_self]
    exact srcFit
  · rw [swap_size,swapPtr_block,swapBlock_self]
    exact dstBound
  · rw [swap_size,swapPtr_block,swapBlock_self]
    exact srcBound
  · rw [swap_writable,swapPtr_block,swapBlock_self]
    exact writable
  · rcases separate with different | under | over
    · apply Or.inl
      rw [swapPtr_block,swapPtr_block]
      intro same
      rw [← swapBlock_self b dst.block,← swapBlock_self b src.block,same] at different
      exact different rfl
    · exact Or.inr (Or.inl under)
    · exact Or.inr (Or.inr over)
  · intro i bound
    rw [swap_bytes,swapPtr_block,swapBlock_self,swapPtr_offset]
    exact read i bound
  · exact size_function_swap b before after size
  · exact writable_function_swap b before after unchanged
  · intro i bound
    simp only [swap_bytes,swapPtr_block,swapBlock_self,swapPtr_offset]
    exact copy i bound
  · intro block offset outside
    rw [swap_bytes,swap_bytes]
    apply frame (swapBlock b block) offset
    rcases outside with different | under | over
    · by_cases same : swapBlock b block=dst.block
      · have impossible : block=(swapPtr b dst).block := by
          rw [swapPtr_block,← swapBlock_self b block]
          exact congrArg (swapBlock b) same
        exact (different impossible).elim
      · exact Or.inl same
    · exact Or.inr (Or.inl under)
    · exact Or.inr (Or.inr over)

theorem memcpy_swap (b : Nat) (before after : Memory) (dst src : ArrayPointer) (count : Nat) :
    Memcpy before dst src count after ↔
      Memcpy (swap b before) (swapPtr b dst) (swapPtr b src) count (swap b after) :=
  ⟨memcpy_forward b before after dst src count,fun source => by
    simpa only [swap_swap,swapPtr_swapPtr] using
      memcpy_forward b (swap b before) (swap b after) (swapPtr b dst) (swapPtr b src) count source⟩

/-! ## 4. Initialization and derived transition transport -/

theorem initialized_forward (b : Nat) (h : Memory) (block offset count : Nat)
    (source : Initialized h block offset count) :
    Initialized (swap b h) (swapBlock b block) offset count := by
  intro i bound
  rw [swap_bytes,swapBlock_self]
  exact source i bound

theorem initialized_block_swap (b : Nat) (h : Memory) (block offset count : Nat) :
    Initialized h block offset count ↔
      Initialized (swap b h) (swapBlock b block) offset count :=
  ⟨initialized_forward b h block offset count,fun source => by
    have back := initialized_forward b (swap b h) (swapBlock b block) offset count source
    rw [swap_swap,swapBlock_self] at back
    exact back⟩

theorem preserves_forward (b : Nat) (before after : Memory) (source : Preserves before after) :
    Preserves (swap b before) (swap b after) := by
  refine ⟨size_function_swap b before after source.size,
    writable_function_swap b before after source.writable,?_⟩
  intro block offset initialized
  rw [swap_bytes] at initialized
  have kept := source.initialized (swapBlock b block) offset initialized
  rw [swap_bytes]
  exact kept

theorem preserves_swap (b : Nat) (before after : Memory) :
    Preserves before after ↔ Preserves (swap b before) (swap b after) :=
  ⟨preserves_forward b before after,fun source => by
    simpa only [swap_swap] using preserves_forward b (swap b before) (swap b after) source⟩

theorem steps_swap_forward (b : Nat) (before after : Memory)
    (source : Steps before after) : Steps (swap b before) (swap b after) := by
  induction source with
  | done h => exact Steps.done _
  | write64 before middle after p w write rest ih =>
    exact Steps.write64 (swap b before) (swap b middle) (swap b after) (swapPtr b p) w
      (store64_forward b before middle p w write) ih
  | write32 before middle after p w write rest ih =>
    exact Steps.write32 (swap b before) (swap b middle) (swap b after) (swapPtr b p) w
      (store32_forward b before middle p w write) ih
  | copy before middle after dst src count copy rest ih =>
    exact Steps.copy (swap b before) (swap b middle) (swap b after) (swapPtr b dst) (swapPtr b src)
      count (memcpy_forward b before middle dst src count copy) ih

theorem steps_swap (b : Nat) (before after : Memory) :
    Steps before after ↔ Steps (swap b before) (swap b after) :=
  ⟨steps_swap_forward b before after,fun source => by
    simpa only [swap_swap] using steps_swap_forward b (swap b before) (swap b after) source⟩

/-! ## 5. The workspace bridge after relocation -/

theorem fprCast_swap (b : Nat) (p : ArrayPointer) :
    swapPtr b (KeygenMakeCertCall.fprCast p)=KeygenMakeCertCall.fprCast (swapPtr b p) := by
  cases p
  rfl

theorem workspacePointer_swap (b : Nat) (base slot : Nat) :
    swapPtr b (CertificateAfterConversion.workspacePointer base slot)=
      {CertificateAfterConversion.workspacePointer base slot with block := b} := by
  simp only [CertificateAfterConversion.workspacePointer,swapPtr,swapBlock_zero]

/-- The byte extent the fpr cast spans: the whole remaining buffer measured
    in bytes; the certificate model binds exactly `35840*8=286720`. -/
def extent (p : ArrayPointer) : Nat :=
  p.base+p.elementBytes*p.count-ArrayPointer.offset p

theorem extent_swapPtr (b : Nat) (p : ArrayPointer) : extent (swapPtr b p)=extent p := rfl

theorem bridge_iff (base : Nat) (p : ArrayPointer) :
    CertificateAfterConversion.workspacePointer base 0=KeygenMakeCertCall.fprCast p ↔
      p.block=0 ∧ base=ArrayPointer.offset p ∧ extent p/8=35840 := by
  cases p with
  | mk block base0 count elementBytes index =>
    constructor
    · intro equal
      refine ⟨(congrArg ArrayPointer.block equal).symm,congrArg ArrayPointer.base equal,?_⟩
      exact (congrArg ArrayPointer.count equal).symm
    · intro parts
      obtain ⟨hblock,hbase,hcount⟩ := parts
      apply arrayPointer_ext
      · exact hblock.symm
      · exact hbase
      · exact hcount.symm
      · rfl
      · rfl

theorem relocated_scratch_block (p : ArrayPointer) : (swapPtr p.block p).block=0 := by
  rw [swapPtr_block]
  exact swapBlock_self_zero p.block

theorem bridge_relocated (p : ArrayPointer) :
    CertificateAfterConversion.workspacePointer (ArrayPointer.offset p) 0=
      KeygenMakeCertCall.fprCast (swapPtr p.block p) ↔ extent p/8=35840 := by
  rw [bridge_iff]
  constructor
  · intro parts
    exact parts.2.2
  · intro bound
    refine ⟨relocated_scratch_block p,rfl,?_⟩
    rw [extent_swapPtr]
    exact bound

theorem bridge_of_extent (p : ArrayPointer) (exact : extent p=286720) :
    CertificateAfterConversion.workspacePointer (ArrayPointer.offset p) 0=
      KeygenMakeCertCall.fprCast (swapPtr p.block p) := by
  rw [bridge_relocated,exact]

end FT1536.Source3.KeygenMakeWorkspaceRelocation
