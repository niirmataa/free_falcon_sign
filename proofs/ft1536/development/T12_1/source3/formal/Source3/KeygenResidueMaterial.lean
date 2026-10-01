import Source3.KeygenResidueFrame

namespace FT1536.Source3.KeygenResidueMaterial
open C99MemoryReference
open KeygenResidueTrace (Arrays Writes slots)
open KeygenResidueLoop (Trace)
open KeygenResidueRanges (Layout)
open KeygenResidueFrame (InputSeparate)
open KeygenSmallOutput (element)

def Related (arrays : Arrays) (heap : Memory) (slot : Fin 4) (i : Nat) : Prop :=
  ∃ (input : BitVec 16) (output : BitVec 32),
    C99NarrowReads.Load16 heap (element (arrays.input slot) i) input ∧
    Load32 heap (element (arrays.output slot) i) output ∧ output.toNat<KeygenNinv31.prime.toNat ∧
    (output.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=input.toInt%(KeygenNinv31.prime.toNat : Int)

theorem writes_related (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (separate : InputSeparate arrays) (i : Nat) (indices : List (Fin 4)) (before after : Memory)
    (hi : i<1536) (source : Writes arrays i indices before after) (slot : Fin 4) (member : slot∈indices) :
    Related arrays after slot i := by
  induction source with
  | done => simp at member
  | next head rest before middle after cell tail ih =>
      by_cases later : slot∈rest
      · exact ih later
      · have equal : slot=head := (List.mem_cons.mp member).resolve_right later
        subst head
        have inputAtMiddle := C99NarrowReads.load16_transport before middle _ cell.input cell.read cell.write.2.2.2.1
          (fun byte => cell.write.2.2.2.2.2.2 _ _ (separate slot slot i i hi hi byte))
        have outputAtMiddle := KeygenResidueStore.written_word before middle _ cell.output cell.write
        refine ⟨cell.input,cell.output,
          KeygenResidueFrame.writes_input_read arrays separate i i rest middle after tail hi hi slot cell.input inputAtMiddle,
          KeygenResidueRanges.writes_preserve arrays root layout i i slot rest middle after hi hi ?_ tail cell.output outputAtMiddle,
          cell.range,cell.residue⟩
        intro other ho
        exact Or.inl (fun equal => later (equal ▸ ho))

theorem trace_related (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (separate : InputSeparate arrays) (i : Nat) (before after : Memory) (source : Trace arrays i before after)
    (slot : Fin 4) (j : Nat) (lower : i≤j) (upper : j<1536) : Related arrays after slot j := by
  induction source with
  | done i heap guard => omega
  | next i before middle after guard writes rest ih =>
      by_cases equal : j=i
      · subst j
        obtain ⟨input,output,readIn,readOut,range,residue⟩ := writes_related arrays root layout separate i slots before middle guard writes slot
          (KeygenResidueRanges.slot_member slot)
        exact ⟨input,output,
          (KeygenResidueFrame.trace_input_read arrays separate (i+1) i middle after rest guard slot input).mp readIn,
          KeygenResidueRanges.trace_preserves_earlier arrays root layout (i+1) i slot middle after rest (by omega) guard output readOut,
          range,residue⟩
      · exact ih (by omega)

theorem source_material (arrays : Arrays) (root : ArrayPointer) (layout : Layout arrays root)
    (separate : InputSeparate arrays) (before : C99ArrayReference.State)
    (old : Option C99IntegerReference.Value) (result : C99ProcedureReference.Result)
    (counter : before.locals "u".toList=some (.uint64,old)) (inputs : KeygenResidueTrace.Inputs arrays before)
    (source : C99ModularReference.Exec KeygenResidueProgram.code before result) :
    ∀ (slot : Fin 4) (i : Nat), i<1536 → ∃ (input : BitVec 16) (output : BitVec 32),
      C99NarrowReads.Load16 before.heap (element (arrays.input slot) i) input ∧
      Load32 result.state.heap (element (arrays.output slot) i) output ∧ output.toNat<KeygenNinv31.prime.toNat ∧
      (output.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=input.toInt%(KeygenNinv31.prime.toNat : Int) := by
  have trace := (KeygenResidueLoop.source_trace arrays before old result counter inputs source).2.2.2
  intro slot i hi
  obtain ⟨input,output,readIn,readOut,range,residue⟩ := trace_related arrays root layout separate 0 before.heap result.state.heap trace slot i
    (Nat.zero_le i) hi
  exact ⟨input,output,
    (KeygenResidueFrame.trace_input_read arrays separate 0 i before.heap result.state.heap trace hi slot input).mpr readIn,
    readOut,range,residue⟩

end FT1536.Source3.KeygenResidueMaterial
