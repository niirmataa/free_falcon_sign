import Source3.SelectedPublicMemory157
import Source3.PublicSetupSource157
import Source3.PublicAppendSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicStart157
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)
open SelectedPublicBinding157 (before bound f g h)
open SelectedPublicMemory157 (temporary)

def names : List C99ArrayReference.Name := ["u".toList,"n".toList]
noncomputable def declared := C99DeclarationStatements.effect .u64 names bound
noncomputable def entered := KeygenPublicExec.localEntry declared "t".toList temporary 3072
noncomputable def ready := PublicSetupSource157.after entered
def t := KeygenPublicExec.localPointer temporary 3072

theorem declaration : Exec KeygenPublicSource.program signed KeygenPublicInputProgram.declareDimensions bound ⟨declared,.normal⟩ :=
  .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64 names bound.locals)
theorem fresh : KeygenRngSource.Fresh declared.heap temporary := SelectedPublicMemory157.fresh
theorem logn : entered.locals "logn".toList=some (.uint32,some (.uint32 10)) :=
  (C99DeclareOutside140.source .uint64 names bound.locals "logn".toList (by decide)).trans SelectedPublicBinding157.logn_cell
theorem ternary : entered.locals "ternary".toList=some (.int32,some (.int32 1)) :=
  (C99DeclareOutside140.source .uint64 names bound.locals "ternary".toList (by decide)).trans SelectedPublicBinding157.ternary_cell

theorem setup : Exec KeygenPublicSource.program signed KeygenPublicInputProgram.setup entered ⟨ready,.normal⟩ :=
  PublicSetupSource157.source entered none rfl logn ternary
theorem n_cell : ready.locals "n".toList=some (.uint64,some (.uint64 1536)) := PublicSetupSource157.n_cell entered
theorem q_cell : ready.locals "q".toList=some (.uint32,some (.uint32 18433)) := PublicSetupSource157.q_cell entered
theorem f_cell : ready.arrays "f".toList=some f := by rfl
theorem g_cell : ready.arrays "g".toList=some g := by rfl
theorem h_cell : ready.arrays "h".toList=some h := by rfl
theorem t_cell : ready.arrays "t".toList=some t := by rfl

def remaining := KeygenPublicInputProgram.append
  (KeygenPublicExec.chain [KeygenPublicInputProgram.conversion,KeygenPublicInputProgram.hForward,KeygenPublicInputProgram.tForward])
  KeygenPublicInputProgram.suffix

/-- The original dimensions, fresh automatic t array and MKN/q setup are discharged. -/
theorem continue_body (out : Result) (tail : Exec KeygenPublicSource.program signed remaining ready out) :
    Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) bound
      ⟨KeygenPublicExec.localExit declared out.state "t".toList temporary,out.flow⟩ := by
  rw [KeygenPublicInputProgram.source_complete]
  exact .seqNormal _ _ _ declared _ declaration
    (.arrayScope "t".toList 3072 _ declared out temporary (by decide) (by decide) fresh
      (PublicAppendSource157.source KeygenPublicSource.program signed KeygenPublicInputProgram.setup remaining
        entered ready out setup tail))

theorem continue_call (out : Result) (v : C99IntegerReference.Value)
    (tail : Exec KeygenPublicSource.program signed remaining ready out)
    (returned : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
    KeygenPublicSource.Call before {before with heap := (KeygenPublicExec.localExit declared out.state "t".toList temporary).heap} v :=
  .run bound ⟨KeygenPublicExec.localExit declared out.state "t".toList temporary,out.flow⟩ v
    SelectedPublicBinding157.source (continue_body out tail) returned

end FT1536.Source3.SelectedPublicStart157
