import Source3.KeygenPublicInputBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Extract the canonical forward midpoint from the SAME complete compute
   execution. t is allocated at its actual3072-cell extent, starts empty,
   remains live at the midpoint and is disposed on leaving this invocation. -/
namespace FT1536.Source3.KeygenPublicInputLifetime
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localEntry localPointer)
open KeygenPublicInputProgram (signed setup conversion hForward tForward)
open KeygenPublicInputCalls (Globals forwards)
open KeygenPublicInputCells (Signed)
open KeygenPublicInputMaterial (Legal)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)

def LiveTables (s : State) : Prop := ∀ n p, s.tables n=some p → 0<s.heap.size p.block
def Front (s : State) (out : Result) (h : ArrayPointer) : Prop :=
  ∃ (block : Nat) (afterT : State) (inner : Result), KeygenRngSource.Fresh s.heap block ∧
    KeygenPublicRangeMemory.Image afterT.heap h 1536 ∧
    KeygenPublicRangeMemory.Image afterT.heap (localPointer block 3072) 1536 ∧
    Exec KeygenPublicSource.program signed KeygenPublicInputProgram.suffix afterT inner ∧
    out.flow=inner.flow ∧ out.state.heap=KeygenRngSource.disposed s.heap inner.state.heap block

theorem legal_live (heap : Memory) (p : ArrayPointer) (legal : Legal heap p) : 0<heap.size p.block := by
  have allocated := legal.2 0 (by decide)
  simp only [C99MemoryReference.Allocated,KeygenSmallOutput.element] at allocated
  rw [legal.1] at allocated
  omega

theorem signed_block (before after : Memory) (p : ArrayPointer) (f : Nat → Int)
    (same : KeygenPublicForwardMemory.Block before after p.block) (input : Signed before p f) : Signed after p f := by
  intro i hi
  obtain ⟨w,read,eq,lower,upper⟩ := input i hi
  exact ⟨w,KeygenPublicForwardMemory.load_block before after (KeygenSmallOutput.element p i) w same read,eq,lower,upper⟩

theorem source_front (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Nat → Int)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (globals : Globals s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : Legal s.heap f) (legalG : Legal s.heap g) (legalH : Legal s.heap h)
    (inputF : Signed s.heap f fv) (inputG : Signed s.heap g gv)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (hExtent : h.count≤h.index+1536)
    (liveTables : LiveTables s) (hTables : KeygenPublicFrame.Tables s h.block)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : Front s out h := by
  rw [KeygenPublicInputProgram.source_complete] at source
  obtain ⟨declared,declare,localExec⟩ := KeygenPublicInputCalls.normal_seq_inv _ _ s out (by decide) source
  have state := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ signed s .u64
    ["u".toList,"n".toList] ⟨declared,.normal⟩ declare)
  dsimp only at state
  have heap : declared.heap=s.heap := by rw [state]
  cases localExec with
  | arrayScope _ _ _ _ inner block positive size fresh executed =>
      have freshOriginal : KeygenRngSource.Fresh s.heap block := by rw [heap] at fresh; exact fresh
      have outside (p : ArrayPointer) (legal : Legal s.heap p) : p.block≠block := by
        intro equal
        have live := legal_live s.heap p legal
        rw [equal,freshOriginal.1] at live
        omega
      have fOutside := outside f legalF
      have gOutside := outside g legalG
      have hOutside := outside h legalH
      let p : KeygenPublicInputLoop.Pointers := ⟨f,g,localPointer block 3072,h⟩
      let entered := localEntry declared "t".toList block 3072
      have enteredEq : entered=localEntry {s with locals :=
        (C99DeclarationCells.declareCells .uint64 ["u".toList,"n".toList] s.locals)} "t".toList block 3072 := by
        dsimp only [entered]
        rw [state]
        rfl
      have layout : KeygenPublicInputLoop.Layout p :=
        ⟨rfl,legalH.1,Ne.symm hOutside,Ne.symm fOutside,Ne.symm gOutside,hf,hg⟩
      have entries : entered.arrays "f".toList=some p.f ∧ entered.arrays "g".toList=some p.g ∧
          entered.arrays "t".toList=some p.t ∧ entered.arrays "h".toList=some p.h := by
        rw [enteredEq]
        exact ⟨arrays.1,arrays.2.1,rfl,arrays.2.2⟩
      have logn : Slot entered "logn" 10 := by rw [enteredEq]; exact profile
      have ter : Ternary entered := by rw [enteredEq]; exact ternary
      have global : Globals entered := by rw [enteredEq]; exact globals
      have fInput : Signed entered.heap p.f fv := by
        change Signed (KeygenPublicExec.allocated declared.heap block 3072) f fv
        rw [heap]
        exact signed_block _ _ f fv (KeygenPublicForwardMemory.allocated_other _ block 3072 f.block fOutside) inputF
      have gInput : Signed entered.heap p.g gv := by
        change Signed (KeygenPublicExec.allocated declared.heap block 3072) g gv
        rw [heap]
        exact signed_block _ _ g gv (KeygenPublicForwardMemory.allocated_other _ block 3072 g.block gOutside) inputG
      have tTables : KeygenPublicFrame.Tables entered p.t.block := by
        rw [enteredEq]
        change ∀ n table, s.tables n=some table → table.block≠block
        intro n table binding
        have live := liveTables n table binding
        intro equal
        rw [equal,freshOriginal.1] at live
        omega
      have hTablesEntry : KeygenPublicFrame.Tables entered p.h.block := by rw [enteredEq]; exact hTables
      rw [KeygenPublicInputCalls.complete_seam] at executed
      obtain ⟨ready,setupExec,rest⟩ := KeygenPublicInputCalls.append_inv setup entered inner
        (.seq conversion KeygenPublicInputCalls.remaining) (by decide) executed
      obtain ⟨converted,conversionExec,rest⟩ := KeygenPublicInputAtoms.seq_inv signed conversion _ ready inner (by decide) rest
      obtain ⟨afterH,hExec,rest⟩ := KeygenPublicInputCalls.normal_seq_inv hForward _ converted inner (by decide) rest
      obtain ⟨afterT,tExec,last⟩ := KeygenPublicInputCalls.normal_seq_inv tForward _ afterH inner (by decide) rest
      have forwardExec : Exec KeygenPublicSource.program signed forwards converted ⟨afterT,.normal⟩ :=
        .seqNormal _ _ _ _ _ hExec (.seqNormal _ _ _ _ _ tExec (.skip afterT))
      have prefixExec : Exec KeygenPublicSource.program signed KeygenPublicInputCalls.convertedForward entered ⟨afterT,.normal⟩ :=
        KeygenPublicInputBridge.append_intro setup entered ready ⟨afterT,.normal⟩ (.seq conversion forwards) (by decide)
          setupExec (.seqNormal _ _ _ _ _ conversionExec forwardExec)
      obtain ⟨_,tImage,hImage⟩ := KeygenPublicInputBridge.source_converted_forward entered ⟨afterT,.normal⟩ p fv gv
        layout logn ter entries fInput gInput (KeygenPublicInputCells.empty_allocated declared.heap block 3072)
        none none (by rw [enteredEq]; rfl) (by rw [enteredEq]; rfl) global hExtent tTables hTablesEntry prefixExec
      refine ⟨block,afterT,inner,freshOriginal,hImage,tImage,last,rfl,?_⟩
      change KeygenRngSource.disposed declared.heap inner.state.heap block=KeygenRngSource.disposed s.heap inner.state.heap block
      rw [heap]

theorem source_same_material_front (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (globals : Globals s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : Legal s.heap f) (legalG : Legal s.heap g) (legalH : Legal s.heap h)
    (materialF : KeygenMaterial.Represents s.heap f fv) (materialG : KeygenMaterial.Represents s.heap g gv)
    (boundF : KeygenIntegerLift.Bound fv 1) (boundG : KeygenIntegerLift.Bound gv 1)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (hExtent : h.count≤h.index+1536)
    (liveTables : LiveTables s) (hTables : KeygenPublicFrame.Tables s h.block)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : Front s out h :=
  source_front s out f g h _ _ profile ternary globals arrays legalF legalG legalH
    (KeygenPublicInputMaterial.signed_material _ _ _ legalF materialF boundF)
    (KeygenPublicInputMaterial.signed_material _ _ _ legalG materialG boundG) hf hg hExtent liveTables hTables source

end FT1536.Source3.KeygenPublicInputLifetime
