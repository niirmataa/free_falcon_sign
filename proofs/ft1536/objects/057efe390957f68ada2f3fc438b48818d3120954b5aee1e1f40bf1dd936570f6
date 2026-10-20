import Source3.KeygenPublicTableRows
import Source3.KeygenResidueVectors

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Public table objects are two-byte cells. Writes, narrowing, unsigned
   promotion and byte frames are derived, not borrowed from uint32 tables. -/
namespace FT1536.Source3.KeygenPublicTableCells
open C99MemoryReference
open KeygenSmallOutput (element Store16)
open KeygenPublicAlgebra (Canonical value radix R)
open KeygenPublicDivisionAlgebra (Scaled)

def Cell (heap : Memory) (p : ArrayPointer) (i : Nat) (z : R) : Prop :=
  ∃ w : BitVec 16, C99NarrowReads.Load16 heap (element p i) w ∧ w.toNat<18433 ∧
    (w.toNat : R)=radix*z
theorem narrowing (w : BitVec 32) (canonical : Canonical w) :
    (KeygenPublicWord.narrow (.uint32 w)).toNat=w.toNat := by
  change (BitVec.ofInt 16 (w.toNat : Int)).toNat=w.toNat
  rw [BitVec.ofInt_natCast,BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt (by unfold Canonical at canonical; omega)
theorem stored_load (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (source : Store16 before p w after) : C99NarrowReads.Load16 after p w := by
  have reconstructed := C99NarrowReads.Load16.load after p (KeygenSmallOutput.byte16 w)
    (by simpa only [Allocated,source.2.2.2.1] using source.1) source.2.1 source.2.2.2.2.2.1
  rw [KeygenResidueVectors.join_bytes] at reconstructed
  exact reconstructed
theorem written_cell (before after : Memory) (p : ArrayPointer) (i : Nat) (w : BitVec 32) (z : R)
    (scaled : Scaled w z) (source : Store16 before (element p i) (KeygenPublicWord.narrow (.uint32 w)) after) :
    Cell after p i z := by
  refine ⟨_,stored_load _ _ _ _ source,?_,?_⟩
  · rw [narrowing w scaled.1]
    exact scaled.1
  · rw [narrowing w scaled.1]
    exact scaled.2
theorem different_cell (p : ArrayPointer) (width : p.elementBytes=2) (i j : Nat) (different : i≠j) (byte : Fin 2) :
    (element p j).block≠(element p i).block ∨ (element p j).offset+byte.val<(element p i).offset ∨
      (element p i).offset+2≤(element p j).offset+byte.val := by
  simp only [element,ArrayPointer.offset,width]
  have bound := byte.isLt
  omega
theorem preserves_cell (before after : Memory) (p : ArrayPointer) (width : p.elementBytes=2)
    (i j : Nat) (different : i≠j) (w : BitVec 16) (z : R)
    (source : Store16 before (element p i) w after) (cell : Cell before p j z) : Cell after p j z := by
  obtain ⟨old,read,range,scaled⟩ := cell
  exact ⟨old,C99NarrowReads.load16_transport _ _ _ _ read source.2.2.2.1
    (fun byte => source.2.2.2.2.2.2 _ _ (different_cell p width i j different byte)),range,scaled⟩
theorem separate_store (before after : Memory) (gm igm : ArrayPointer) (i j : Nat) (w : BitVec 16) (z : R)
    (separate : ∀ byte : Fin 2, (element gm j).block≠(element igm i).block ∨
      (element gm j).offset+byte.val<(element igm i).offset ∨
        (element igm i).offset+2≤(element gm j).offset+byte.val)
    (source : Store16 before (element igm i) w after) (cell : Cell before gm j z) : Cell after gm j z := by
  obtain ⟨old,read,range,scaled⟩ := cell
  exact ⟨old,C99NarrowReads.load16_transport _ _ _ _ read source.2.2.2.1
    (fun byte => source.2.2.2.2.2.2 _ _ (separate byte)),range,scaled⟩
theorem unsigned_argument (w : BitVec 16) :
    KeygenPublicArguments.U32 (C99NarrowReads.unsignedPromotion w) (BitVec.ofNat 32 w.toNat) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 (BitVec.ofNat 32 w.toNat).toInt)=_
  rw [BitVec.ofInt_toInt]
theorem promoted_cell (heap : Memory) (p : ArrayPointer) (i : Nat) (z : R) (cell : Cell heap p i z) :
    ∃ w, C99NarrowReads.Load16 heap (element p i) w ∧
      KeygenPublicArguments.U32 (C99NarrowReads.unsignedPromotion w) (BitVec.ofNat 32 w.toNat) ∧
        Scaled (BitVec.ofNat 32 w.toNat) z := by
  obtain ⟨w,read,range,scaled⟩ := cell
  have natural : (BitVec.ofNat 32 w.toNat).toNat=w.toNat := Nat.mod_eq_of_lt (by have bound := w.isLt; omega)
  refine ⟨w,read,unsigned_argument w,?_,?_⟩
  · change (BitVec.ofNat 32 w.toNat).toNat<18433
    rw [natural]
    exact range
  · change ((BitVec.ofNat 32 w.toNat).toNat : R)=radix*z
    rw [natural]
    exact scaled

end FT1536.Source3.KeygenPublicTableCells
