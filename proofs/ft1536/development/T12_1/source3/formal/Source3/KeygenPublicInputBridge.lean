import Source3.KeygenPublicInputCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicInputBridge
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicInputProgram (signed append setup conversion)
open KeygenPublicInputCalls (inputPrefix forwards convertedForward Globals)
open KeygenPublicInputLoop (Pointers Layout)
open KeygenPublicInputCells (Signed TailEmpty)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)

theorem append_intro (a : Stmt) (s middle : State) (out : Result) (tail : Stmt)
    (ok : KeygenPublicTableControl.supported a=true)
    (first : Exec KeygenPublicSource.program signed a s ⟨middle,.normal⟩)
    (second : Exec KeygenPublicSource.program signed tail middle out) :
    Exec KeygenPublicSource.program signed (append a tail) s out := by
  induction a generalizing s with
  | skip => cases first; exact second
  | seq a b ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp ok
      obtain ⟨afterA,head,rest⟩ := KeygenPublicInputAtoms.seq_inv signed a b s ⟨middle,.normal⟩ ha first
      exact .seqNormal _ _ _ _ _ head (ih2 afterA hb rest)
  | scalar | assign | declarePointer | pointer | store | call | scope | arrayScope | branch | loop | ret =>
      exact .seqNormal _ _ _ _ _ first second

theorem tables_preserved (sgn : List Name) (code : Stmt) (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program sgn code s out) : out.state.tables=s.tables := by
  induction source with
  | skip | scalar | assign | declarePointer | pointer | store | call | loopFalse | ret | retVoid => rfl
  | seqNormal _ _ _ _ _ _ _ ih1 ih2 => exact ih2.trans ih1
  | seqExit _ _ _ _ _ _ ih => exact ih
  | scope _ _ _ _ _ _ ih => exact ih
  | arrayScope _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih
  | loopNormal _ _ _ _ _ _ _ _ _ _ _ _ _ ih1 ih2 ih3 => exact ih3.trans (ih2.trans ih1)
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih

theorem source_converted_forward (s : State) (out : Result) (p : Pointers) (f g : Nat → Int)
    (layout : Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (arrays : s.arrays "f".toList=some p.f ∧ s.arrays "g".toList=some p.g ∧
      s.arrays "t".toList=some p.t ∧ s.arrays "h".toList=some p.h)
    (inputF : Signed s.heap p.f f) (inputG : Signed s.heap p.g g) (tail : TailEmpty s.heap p.t)
    (oldN oldU : Option C99IntegerReference.Value)
    (n : s.locals "n".toList=some (.uint64,oldN)) (u : s.locals "u".toList=some (.uint64,oldU))
    (globals : Globals s) (hExtent : p.h.count≤p.h.index+1536)
    (tTables : KeygenPublicFrame.Tables s p.t.block) (hTables : KeygenPublicFrame.Tables s p.h.block)
    (source : Exec KeygenPublicSource.program signed convertedForward s out) :
    out.flow=.normal ∧ KeygenPublicRangeMemory.Image out.state.heap p.t 1536 ∧
      KeygenPublicRangeMemory.Image out.state.heap p.h 1536 := by
  obtain ⟨ready,setupExec,rest⟩ := KeygenPublicInputCalls.append_inv setup s out (.seq conversion forwards) (by decide) source
  obtain ⟨converted,conversionExec,forwardExec⟩ := KeygenPublicInputAtoms.seq_inv signed conversion forwards ready out (by decide) rest
  have prefixExec := append_intro setup s ready ⟨converted,.normal⟩ conversion (by decide) setupExec conversionExec
  obtain ⟨_,inv,logn,ter⟩ := KeygenPublicInputCalls.prefix_result s ⟨converted,.normal⟩ p f g
    layout profile ternary arrays inputF inputG tail oldN oldU n u prefixExec
  exact KeygenPublicInputCalls.source_both_forward converted out p f g inv layout logn ter
    (by rw [Globals,KeygenPublicInputCalls.globals_preserved signed inputPrefix s ⟨converted,.normal⟩ prefixExec]; exact globals)
    hExtent
    (by unfold KeygenPublicFrame.Tables; rw [tables_preserved signed inputPrefix s ⟨converted,.normal⟩ prefixExec]; exact tTables)
    (by unfold KeygenPublicFrame.Tables; rw [tables_preserved signed inputPrefix s ⟨converted,.normal⟩ prefixExec]; exact hTables) forwardExec

theorem source_same_vectors_forward (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec)
    (layout : Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (arrays : s.arrays "f".toList=some p.f ∧ s.arrays "g".toList=some p.g ∧
      s.arrays "t".toList=some p.t ∧ s.arrays "h".toList=some p.h)
    (legalF : KeygenPublicInputMaterial.Legal s.heap p.f) (legalG : KeygenPublicInputMaterial.Legal s.heap p.g)
    (materialF : KeygenMaterial.Represents s.heap p.f f) (materialG : KeygenMaterial.Represents s.heap p.g g)
    (boundF : KeygenIntegerLift.Bound f 1) (boundG : KeygenIntegerLift.Bound g 1)
    (tail : TailEmpty s.heap p.t) (oldN oldU : Option C99IntegerReference.Value)
    (n : s.locals "n".toList=some (.uint64,oldN)) (u : s.locals "u".toList=some (.uint64,oldU))
    (globals : Globals s) (hExtent : p.h.count≤p.h.index+1536)
    (tTables : KeygenPublicFrame.Tables s p.t.block) (hTables : KeygenPublicFrame.Tables s p.h.block)
    (source : Exec KeygenPublicSource.program signed convertedForward s out) :
    out.flow=.normal ∧ KeygenPublicRangeMemory.Image out.state.heap p.t 1536 ∧
      KeygenPublicRangeMemory.Image out.state.heap p.h 1536 :=
  source_converted_forward s out p (KeygenPublicInputMaterial.coefficient f) (KeygenPublicInputMaterial.coefficient g)
    layout profile ternary arrays (KeygenPublicInputMaterial.signed_material _ _ _ legalF materialF boundF)
    (KeygenPublicInputMaterial.signed_material _ _ _ legalG materialG boundG) tail oldN oldU n u globals hExtent tTables hTables source

end FT1536.Source3.KeygenPublicInputBridge
