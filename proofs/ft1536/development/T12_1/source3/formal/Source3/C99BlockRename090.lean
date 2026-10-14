import Source3.C99HeapDeterminism089
import Mathlib.Logic.Equiv.Basic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Renaming abstract memory-block identifiers. Offsets, integer values,
   object sizes and source instructions are unchanged. This is the basis
   for eliminating the unobservable fresh temporary choice in get_rng_u64. -/
namespace FT1536.Source3.C99BlockRename090
open C99MemoryReference
open C99ArrayReference (State)

abbrev Renaming := Equiv.Perm Nat

def ptr (r : Renaming) (p : ArrayPointer) : ArrayPointer := {p with block := r p.block}
def heap (r : Renaming) (h : Memory) : Memory where
  bytes b o := h.bytes (r.symm b) o
  size b := h.size (r.symm b)
  writable b := h.writable (r.symm b)
def state (r : Renaming) (s : State) : State where
  heap := heap r s.heap
  locals := s.locals
  arrays n := (s.arrays n).map (ptr r)
  globals := s.globals
  tables n := (s.tables n).map (ptr r)

theorem ptr_offset (r : Renaming) (p : ArrayPointer) : (ptr r p).offset = p.offset := rfl
theorem bytes_at (r : Renaming) (h : Memory) (b o : Nat) : (heap r h).bytes (r b) o = h.bytes b o := by
  simp [heap]
theorem size_at (r : Renaming) (h : Memory) (b : Nat) : (heap r h).size (r b) = h.size b := by
  simp [heap]
theorem writable_at (r : Renaming) (h : Memory) (b : Nat) : (heap r h).writable (r b) = h.writable b := by
  simp [heap]

theorem allocated (r : Renaming) (h : Memory) (p : ArrayPointer) (source : Allocated h p) :
    Allocated (heap r h) (ptr r p) := by
  simpa only [Allocated, ptr, heap, Equiv.symm_apply_apply] using source

theorem pointer_add (r : Renaming) (p q : ArrayPointer) (n : Nat) (source : PointerAdd p n q) :
    PointerAdd (ptr r p) n (ptr r q) := by
  cases source
  exact .within _ _ (by assumption)

theorem load64 (r : Renaming) (h : Memory) (p : ArrayPointer) (w : BitVec 64) (source : Load64 h p w) :
    Load64 (heap r h) (ptr r p) w := by
  cases source with
  | load bytes legal width initialized =>
      exact .load _ _ bytes (allocated r h p legal) width
        (fun i => (bytes_at r h p.block (p.offset + i.val)).trans (initialized i))

theorem load32 (r : Renaming) (h : Memory) (p : ArrayPointer) (w : BitVec 32) (source : Load32 h p w) :
    Load32 (heap r h) (ptr r p) w := by
  cases source with
  | load bytes legal width initialized =>
      exact .load _ _ bytes (allocated r h p legal) width
        (fun i => (bytes_at r h p.block (p.offset + i.val)).trans (initialized i))

theorem block_ne (r : Renaming) (b p : Nat) : r.symm b ≠ p ↔ b ≠ r p := by
  constructor
  · intro different equal
    apply different
    rw [equal]
    simp
  · intro different equal
    apply different
    simpa using congrArg r equal

theorem byte_write (r : Renaming) (before after : Memory) (p : ArrayPointer) (count : Nat)
    (data : Fin count → Byte) (source : C99HeapDeterminism089.ByteWrite before p count data after) :
    C99HeapDeterminism089.ByteWrite (heap r before) (ptr r p) count data (heap r after) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · funext b
    exact congrFun source.sizes (r.symm b)
  · funext b
    exact congrFun source.writable (r.symm b)
  · intro i
    exact (bytes_at r after p.block (p.offset + i.val)).trans (source.bytes i)
  · intro b o outside
    apply source.frame (r.symm b) o
    simpa only [ptr, ArrayPointer.offset, block_ne] using outside

theorem store64 (r : Renaming) (before after : Memory) (p : ArrayPointer) (w : BitVec 64)
    (source : Store64 before p w after) : Store64 (heap r before) (ptr r p) w (heap r after) := by
  obtain ⟨legal, width, writable, sizes, permissions, bytes, frame⟩ := source
  have writes := byte_write r before after p 8 (byte64 w) ⟨sizes, permissions, bytes, frame⟩
  exact ⟨allocated r before p legal, width,
    by simpa only [ptr, heap, Equiv.symm_apply_apply] using writable,
    writes.sizes, writes.writable, writes.bytes, writes.frame⟩

theorem store32 (r : Renaming) (before after : Memory) (p : ArrayPointer) (w : BitVec 32)
    (source : Store32 before p w after) : Store32 (heap r before) (ptr r p) w (heap r after) := by
  obtain ⟨legal, width, writable, sizes, permissions, bytes, frame⟩ := source
  have writes := byte_write r before after p 4 (byte32 w) ⟨sizes, permissions, bytes, frame⟩
  exact ⟨allocated r before p legal, width,
    by simpa only [ptr, heap, Equiv.symm_apply_apply] using writable,
    writes.sizes, writes.writable, writes.bytes, writes.frame⟩

theorem store8 (r : Renaming) (before after : Memory) (p : ArrayPointer) (w : Byte)
    (source : ShakeEncode.Store8 before p w after) :
    ShakeEncode.Store8 (heap r before) (ptr r p) w (heap r after) := by
  obtain ⟨legal, width, writable, sizes, permissions, byte, frame⟩ := source
  refine ⟨allocated r before p legal, width, ?_, ?_, ?_, ?_, ?_⟩
  · simpa only [ptr, heap, Equiv.symm_apply_apply] using writable
  · funext b; exact congrFun sizes (r.symm b)
  · funext b; exact congrFun permissions (r.symm b)
  · exact (bytes_at r after p.block p.offset).trans byte
  · intro b o outside
    apply frame (r.symm b) o
    simpa only [ptr, ArrayPointer.offset, block_ne] using outside

theorem memcpy (r : Renaming) (before after : Memory) (dst src : ArrayPointer) (count : Nat)
    (source : Memcpy before dst src count after) :
    Memcpy (heap r before) (ptr r dst) (ptr r src) count (heap r after) := by
  obtain ⟨dstBound, srcBound, dstFit, srcFit, writable, separate, initialized,
    sizes, permissions, bytes, frame⟩ := source
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simpa only [ptr, ArrayPointer.offset, heap, Equiv.symm_apply_apply] using dstBound
  · simpa only [ptr, ArrayPointer.offset, heap, Equiv.symm_apply_apply] using srcBound
  · simpa only [ptr, heap, Equiv.symm_apply_apply] using dstFit
  · simpa only [ptr, heap, Equiv.symm_apply_apply] using srcFit
  · simpa only [ptr, heap, Equiv.symm_apply_apply] using writable
  · simpa only [ptr, ArrayPointer.offset, ne_eq, Equiv.apply_eq_iff_eq] using separate
  · intro i bound
    simpa only [ptr, ArrayPointer.offset, heap, Equiv.symm_apply_apply] using initialized i bound
  · funext b; exact congrFun sizes (r.symm b)
  · funext b; exact congrFun permissions (r.symm b)
  · intro i bound
    simpa only [ptr, ArrayPointer.offset, heap, Equiv.symm_apply_apply] using bytes i bound
  · intro b o outside
    apply frame (r.symm b) o
    simpa only [ptr, ArrayPointer.offset, block_ne] using outside

end FT1536.Source3.C99BlockRename090
