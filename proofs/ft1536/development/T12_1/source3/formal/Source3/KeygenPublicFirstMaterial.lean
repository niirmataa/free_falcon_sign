import Source3.KeygenPublicFirstCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both original f/g folds belong to the SAME complete public invocation.
   The converted cells are conclusions of its actual conversion, not inputs
   borrowed from a separate run. h contains g and t contains f at this seam. -/
namespace FT1536.Source3.KeygenPublicFirstMaterial
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localEntry localPointer)
open KeygenPublicInputProgram (signed setup conversion hForward tForward)
open KeygenPublicInputCells (Signed Cells)
open KeygenPublicInputMaterial (Legal coefficient reduced)
open KeygenPublicInputLifetime (LiveTables legal_live signed_block)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)
open KeygenPublicFirstInvocation (Outcome)

def Front (s : State) (out : Result) (h : ArrayPointer) (fv gv : Geometry.Vec) : Prop :=
  ∃ (block : Nat) (converted afterH afterT : State) (inner : Result),
    KeygenRngSource.Fresh s.heap block ∧
    Cells converted.heap h 1536 (reduced gv) ∧
    Cells converted.heap (localPointer block 3072) 1536 (reduced fv) ∧
    Exec KeygenPublicSource.program signed hForward converted ⟨afterH,.normal⟩ ∧
    Exec KeygenPublicSource.program signed tForward afterH ⟨afterT,.normal⟩ ∧
    Outcome gv h ⟨afterH,.normal⟩ ∧ Outcome fv (localPointer block 3072) ⟨afterT,.normal⟩ ∧
    Exec KeygenPublicSource.program signed KeygenPublicInputProgram.suffix afterT inner ∧
    out.flow=inner.flow ∧ out.state.heap=KeygenRngSource.disposed s.heap inner.state.heap block

theorem source_front (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (profile : Slot s "logn" 10) (ternary : Ternary s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : Legal s.heap f) (legalG : Legal s.heap g) (legalH : Legal s.heap h)
    (inputF : Signed s.heap f (coefficient fv)) (inputG : Signed s.heap g (coefficient gv))
    (hf : h.block≠f.block) (hg : h.block≠g.block) (liveTables : LiveTables s)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : Front s out h fv gv := by
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
        dsimp only [entered]; rw [state]; rfl
      have layout : KeygenPublicInputLoop.Layout p :=
        ⟨rfl,legalH.1,Ne.symm hOutside,Ne.symm fOutside,Ne.symm gOutside,hf,hg⟩
      have entries : entered.arrays "f".toList=some p.f ∧ entered.arrays "g".toList=some p.g ∧
          entered.arrays "t".toList=some p.t ∧ entered.arrays "h".toList=some p.h := by
        rw [enteredEq]; exact ⟨arrays.1,arrays.2.1,rfl,arrays.2.2⟩
      have logn : Slot entered "logn" 10 := by rw [enteredEq]; exact profile
      have ter : Ternary entered := by rw [enteredEq]; exact ternary
      have fInput : Signed entered.heap p.f (coefficient fv) := by
        change Signed (KeygenPublicExec.allocated declared.heap block 3072) f (coefficient fv)
        rw [heap]
        exact signed_block _ _ f _ (KeygenPublicForwardMemory.allocated_other _ block 3072 f.block fOutside) inputF
      have gInput : Signed entered.heap p.g (coefficient gv) := by
        change Signed (KeygenPublicExec.allocated declared.heap block 3072) g (coefficient gv)
        rw [heap]
        exact signed_block _ _ g _ (KeygenPublicForwardMemory.allocated_other _ block 3072 g.block gOutside) inputG
      have tTables : KeygenPublicFrame.Tables entered p.t.block := by
        rw [enteredEq]
        change ∀ n table, s.tables n=some table → table.block≠block
        intro n table binding
        have live := liveTables n table binding
        intro equal
        rw [equal,freshOriginal.1] at live
        omega
      rw [KeygenPublicInputCalls.complete_seam] at executed
      obtain ⟨ready,setupExec,rest⟩ := KeygenPublicInputCalls.append_inv setup entered inner
        (.seq conversion KeygenPublicInputCalls.remaining) (by decide) executed
      obtain ⟨converted,conversionExec,rest⟩ := KeygenPublicInputAtoms.seq_inv signed conversion _ ready inner (by decide) rest
      obtain ⟨afterH,hExec,rest⟩ := KeygenPublicInputCalls.normal_seq_inv hForward _ converted inner (by decide) rest
      obtain ⟨afterT,tExec,last⟩ := KeygenPublicInputCalls.normal_seq_inv tForward _ afterH inner (by decide) rest
      have prefixExec := KeygenPublicInputBridge.append_intro setup entered ready ⟨converted,.normal⟩ conversion
        (by decide) setupExec conversionExec
      obtain ⟨_,inv,profileC,ternaryC⟩ := KeygenPublicInputCalls.prefix_result entered ⟨converted,.normal⟩ p _ _
        layout logn ter entries fInput gInput (KeygenPublicInputCells.empty_allocated declared.heap block 3072)
        none none (by rw [enteredEq]; rfl) (by rw [enteredEq]; rfl) prefixExec
      have tableC : KeygenPublicFrame.Tables converted p.t.block := by
        unfold KeygenPublicFrame.Tables
        rw [KeygenPublicInputBridge.tables_preserved signed KeygenPublicInputCalls.inputPrefix entered ⟨converted,.normal⟩ prefixExec]
        exact tTables
      obtain ⟨hRun,tRun⟩ := KeygenPublicFirstCalls.both converted afterH afterT p fv gv inv layout profileC ternaryC tableC hExec tExec
      refine ⟨block,converted,afterH,afterT,inner,freshOriginal,inv.h,inv.t,hExec,tExec,hRun,tRun,last,rfl,?_⟩
      change KeygenRngSource.disposed declared.heap inner.state.heap block=KeygenRngSource.disposed s.heap inner.state.heap block
      rw [heap]

theorem source_same_material (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (profile : Slot s "logn" 10) (ternary : Ternary s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : Legal s.heap f) (legalG : Legal s.heap g) (legalH : Legal s.heap h)
    (materialF : KeygenMaterial.Represents s.heap f fv) (materialG : KeygenMaterial.Represents s.heap g gv)
    (boundF : KeygenIntegerLift.Bound fv 1) (boundG : KeygenIntegerLift.Bound gv 1)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (liveTables : LiveTables s)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : Front s out h fv gv :=
  source_front s out f g h fv gv profile ternary arrays legalF legalG legalH
    (KeygenPublicInputMaterial.signed_material _ _ _ legalF materialF boundF)
    (KeygenPublicInputMaterial.signed_material _ _ _ legalG materialG boundG) hf hg liveTables source

end FT1536.Source3.KeygenPublicFirstMaterial
