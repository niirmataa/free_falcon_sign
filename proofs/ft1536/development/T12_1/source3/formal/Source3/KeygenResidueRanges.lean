import Source3.KeygenResidueLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenResidueRanges
open C99MemoryReference
open KeygenResidueTrace (Arrays Writes slots)
open KeygenResidueLoop (Trace)
open KeygenSmallOutput (element)

def Layout (arrays : Arrays) (root : ArrayPointer) : Prop :=
  root.elementBytes=4 ∧ ∀ slot, arrays.output slot={root with index := root.index+1536*slot.val}

theorem separated_cells (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (written readSlot : Fin 4) (i j : Nat) (hi : i<1536) (hj : j<1536)
    (different : written≠readSlot ∨ i≠j) (byte : Fin 4) :
    (element (arrays.output readSlot) j).block≠(element (arrays.output written) i).block ∨
      (element (arrays.output readSlot) j).offset+byte.val<(element (arrays.output written) i).offset ∨
      (element (arrays.output written) i).offset+4≤(element (arrays.output readSlot) j).offset+byte.val := by
  have indices : written.val≠readSlot.val ∨ i≠j := by
    rcases different with h | h
    · exact Or.inl (fun equal => h (Fin.ext equal))
    · exact Or.inr h
  rw [layout.2 written,layout.2 readSlot]
  dsimp [element,ArrayPointer.offset]
  rw [layout.1]
  have hb := byte.isLt
  omega

theorem store_preserves_other (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (written readSlot : Fin 4) (i j : Nat) (hi : i<1536) (hj : j<1536)
    (different : written≠readSlot ∨ i≠j) (before after : Memory) (out word : BitVec 32)
    (write : Store32 before (element (arrays.output written) i) out after)
    (read : Load32 before (element (arrays.output readSlot) j) word) :
    Load32 after (element (arrays.output readSlot) j) word :=
  Gate00Memory.load32_transport before after _ word read write.2.2.2.1
    (fun byte => write.2.2.2.2.2.2 _ _ (separated_cells arrays root layout written readSlot i j hi hj different byte))

theorem writes_preserve (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (i j : Nat) (readSlot : Fin 4) (indices : List (Fin 4)) (before after : Memory)
    (hi : i<1536) (hj : j<1536) (different : ∀ slot∈indices, slot≠readSlot ∨ i≠j)
    (source : Writes arrays i indices before after) (word : BitVec 32)
    (read : Load32 before (element (arrays.output readSlot) j) word) :
    Load32 after (element (arrays.output readSlot) j) word := by
  induction source with
  | done => exact read
  | next slot rest before middle after cell tail ih =>
      have atMiddle := store_preserves_other arrays root layout slot readSlot i j hi hj
        (different slot (by simp)) before middle cell.output word cell.write read
      exact ih (fun slot hs => different slot (by simp [hs])) atMiddle

theorem writes_range (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (i : Nat) (indices : List (Fin 4)) (before after : Memory) (hi : i<1536)
    (source : Writes arrays i indices before after) (slot : Fin 4) (member : slot∈indices) :
    ∃ word, Load32 after (element (arrays.output slot) i) word ∧ word.toNat<KeygenNinv31.prime.toNat := by
  induction source with
  | done => simp at member
  | next head rest before middle after cell tail ih =>
      by_cases later : slot∈rest
      · exact ih later
      · have equal : slot=head := (List.mem_cons.mp member).resolve_right later
        subst head
        have stored := KeygenResidueStore.written_word before middle _ cell.output cell.write
        refine ⟨cell.output,writes_preserve arrays root layout i i slot rest middle after hi hi ?_ tail cell.output stored,cell.range⟩
        intro other ho
        exact Or.inl (fun equal => later (equal ▸ ho))

theorem trace_preserves_earlier (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (i j : Nat) (slot : Fin 4) (before after : Memory) (source : Trace arrays i before after)
    (earlier : j < i) (hj : j<1536) (word : BitVec 32)
    (read : Load32 before (element (arrays.output slot) j) word) :
    Load32 after (element (arrays.output slot) j) word := by
  induction source with
  | done => exact read
  | next i before middle after guard writes rest ih =>
      have atMiddle := writes_preserve arrays root layout i j slot slots before middle guard hj
        (by intro _ _; exact Or.inr (by omega)) writes word read
      exact ih (by omega) atMiddle

theorem slot_member (slot : Fin 4) : slot∈slots := by fin_cases slot <;> decide

theorem trace_range (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (i : Nat) (before after : Memory) (source : Trace arrays i before after)
    (slot : Fin 4) (j : Nat) (lower : i≤j) (upper : j<1536) :
    ∃ word, Load32 after (element (arrays.output slot) j) word ∧ word.toNat<KeygenNinv31.prime.toNat := by
  induction source with
  | done i heap guard => omega
  | next i before middle after guard writes rest ih =>
      by_cases equal : j=i
      · subst j
        obtain ⟨word,read,range⟩ := writes_range arrays root layout i slots before middle guard writes slot (slot_member slot)
        exact ⟨word,trace_preserves_earlier arrays root layout (i+1) i slot middle after rest (by omega) guard word read,range⟩
      · exact ih (by omega)

theorem source_canonical (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (before : C99ArrayReference.State) (old : Option C99IntegerReference.Value) (result : C99ProcedureReference.Result)
    (slot : before.locals "u".toList=some (.uint64,old)) (inputs : KeygenResidueTrace.Inputs arrays before)
    (source : C99ModularReference.Exec KeygenResidueProgram.code before result) :
    ∀ (which : Fin 4) (j : Nat), j<1536 → ∀ word,
      Load32 result.state.heap (element (arrays.output which) j) word → word.toNat<KeygenNinv31.prime.toNat := by
  have trace := (KeygenResidueLoop.source_trace arrays before old result slot inputs source).2.2.2
  intro which j hj word read
  obtain ⟨actual,actualRead,range⟩ := trace_range arrays root layout 0 before.heap result.state.heap trace which j (Nat.zero_le j) hj
  have equal := Gate00Memory.load32_deterministic result.state.heap _ word actual read actualRead
  rw [equal]
  exact range

end FT1536.Source3.KeygenResidueRanges
