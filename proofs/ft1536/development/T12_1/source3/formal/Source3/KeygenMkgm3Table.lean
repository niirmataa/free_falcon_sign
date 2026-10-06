import Source3.KeygenMkgm3IndexCert
import Source3.KeygenMkgm3Layout
import Source3.KeygenMkgm3Control

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3Table
open C99MemoryReference
open KeygenSmallOutput (element)
open KeygenMkgm3Rows (Scaled root)
open KeygenNttWordAlgebra (radix value)
open KeygenMkgm3Indices (tableExponent tableOrder lastIndex reverse9)

def Cell (heap : Memory) (gm : ArrayPointer) (i : Nat) : Prop :=
  ∃ w, Load32 heap (element gm i) w ∧ Scaled (tableExponent i) w
def Initialized (heap : Memory) (gm : ArrayPointer) : Prop := ∀ i<1024, Cell heap gm i

theorem exact_order (i : Nat) (hi : i<1024) : orderOf (root^tableExponent i)=tableOrder i := by
  obtain ⟨positive,order⟩ := (KeygenMkgm3IndexCert.all_indices i hi).2.2.2 hi
  rw [orderOf_pow' root (by omega),KeygenMkgm3Rows.root_order,order]

theorem canonical_root (heap : Memory) (gm : ArrayPointer) (i : Nat)
    (hi : i<1024) (h : Cell heap gm i) :
    ∃ w, Load32 heap (element gm i) w ∧ w.toNat<KeygenNinv31.prime.toNat ∧
      value w=radix*root^tableExponent i ∧ orderOf (root^tableExponent i)=tableOrder i := by
  obtain ⟨w,read,range,law⟩ := h
  exact ⟨w,read,range,law,exact_order i hi⟩

theorem last_range (u : Nat) (hu : u<512) : 512 ≤ lastIndex u ∧ lastIndex u<1024 := by
  have hr := (KeygenMkgm3IndexCert.all_indices u (by omega)).1 hu
  dsimp [lastIndex]
  omega

theorem last_injective (u v : Nat) (hu : u<512) (hv : v<512)
    (equal : lastIndex u=lastIndex v) : u=v := by
  have hr := congrArg reverse9 (Nat.add_left_cancel equal)
  rw [(KeygenMkgm3IndexCert.all_indices u (by omega)).1 hu |>.2.1,
    (KeygenMkgm3IndexCert.all_indices v (by omega)).1 hv |>.2.1] at hr
  exact hr

theorem last_covers (i : Nat) (lo : 512 ≤ i) (hi : i<1024) :
    ∃ u<512, lastIndex u=i := by
  have hj : i-512<512 := by omega
  obtain ⟨hb,he,_⟩ := (KeygenMkgm3IndexCert.all_indices (i-512) (by omega)).1 hj
  exact ⟨reverse9 (i-512),hb,by dsimp [lastIndex]; rw [he]; omega⟩

theorem different_cell (p : ArrayPointer) (width : p.elementBytes=4) (i j : Nat)
    (different : i≠j) (byte : Fin 4) :
    (element p j).block≠(element p i).block ∨
      (element p j).offset+byte.val<(element p i).offset ∨
      (element p i).offset+4≤(element p j).offset+byte.val := by
  simp only [element,ArrayPointer.offset,width]
  have := byte.isLt
  omega

theorem store_preserves_cell (p : ArrayPointer) (width : p.elementBytes=4) (i j : Nat)
    (different : i≠j) (before after : Memory) (w : BitVec 32)
    (write : Store32 before (element p i) w after) (read : Cell before p j) : Cell after p j := by
  obtain ⟨word,loaded,scaled⟩ := read
  exact ⟨word,Gate00Memory.load32_transport before after _ word loaded write.2.2.2.1
    (fun byte => write.2.2.2.2.2.2 _ _ (different_cell p width i j different byte)),scaled⟩

theorem store_initializes (p : ArrayPointer) (i : Nat) (before after : Memory) (w : BitVec 32)
    (scaled : Scaled (tableExponent i) w) (write : Store32 before (element p i) w after) : Cell after p i :=
  ⟨w,KeygenResidueStore.written_word before after _ w write,scaled⟩

theorem inverse_preserves_cell (gm igm : ArrayPointer) (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (i j : Nat) (hi : i<1024) (hj : j<1024) (before after : Memory) (w : BitVec 32)
    (write : Store32 before (element igm i) w after) (read : Cell before gm j) : Cell after gm j := by
  obtain ⟨word,loaded,scaled⟩ := read
  refine ⟨word,Gate00Memory.load32_transport before after _ word loaded write.2.2.2.1 ?_,scaled⟩
  intro byte
  apply write.2.2.2.2.2.2
  simp only [KeygenMkgm3Layout.DisjointBytes,ArrayPointer.offset] at separate
  simp only [element,ArrayPointer.offset,gw,iw] at *
  have hb := byte.isLt
  omega

theorem overwritten_table (arrays : KeygenResidueTrace.Arrays) (scratch : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays scratch)
    (before : C99ArrayReference.State) (old : Option C99IntegerReference.Value)
    (out : C99ProcedureReference.Result)
    (counter : before.locals "u".toList=some (.uint64,old))
    (inputs : KeygenResidueTrace.Inputs arrays before)
    (table : Initialized before.heap (KeygenMkgm3Layout.gm scratch))
    (source : C99ModularReference.Exec KeygenResidueProgram.code before out) :
    Initialized out.state.heap (KeygenMkgm3Layout.gm scratch) := by
  have trace := (KeygenResidueLoop.source_trace arrays before old out counter inputs source).2.2.2
  intro i hi
  obtain ⟨w,read,law⟩ := table i hi
  exact ⟨w,KeygenMkgm3Layout.trace_preserves_gm arrays scratch layout 0 i hi _ _ trace w read,law⟩

end FT1536.Source3.KeygenMkgm3Table
