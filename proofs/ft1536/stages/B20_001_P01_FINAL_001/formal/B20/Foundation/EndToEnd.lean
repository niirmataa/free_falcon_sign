import B20.Foundation.Certificate
import B20.Foundation.SourceBinding

namespace B20.Foundation

/-- Small end-to-end receipt: pinned source fragment → model program →
kernel theorem → checked certificate. -/
structure EndToEndReceipt where
  source : PinnedSource
  program : CStmt
  interval : RationalInterval
  sourceBinding : SourceBinding source program
  translation : SourceTranslation source program
  certificate : interval.checkSqrt2 = true

def endToEndReceipt : EndToEndReceipt := {
  source := source17ReturnZeroFragment
  program := source17ReturnZeroProgram
  interval := sqrt2Witness
  sourceBinding := source17ReturnZero_binding
  translation := source17ReturnZero_translation
  certificate := sqrt2Witness_checked
}

theorem endToEnd_receipt_valid :
    SourceBinding endToEndReceipt.source endToEndReceipt.program ∧
      SourceTranslation endToEndReceipt.source endToEndReceipt.program ∧
      endToEndReceipt.interval.checkSqrt2 = true :=
  ⟨endToEndReceipt.sourceBinding, endToEndReceipt.translation,
    endToEndReceipt.certificate⟩

/-- Kernel theorem of the pinned model: the translated program returns
exactly `0` in every state (`CExec` constructor `ret_ok`). -/
theorem source17ReturnZero_exec (s : State) :
    CExec source17ReturnZeroProgram s (.returned (some (BitVec.ofNat 64 0)) s) :=
  .ret_ok rfl

/-- Full chain for the pinned fragment in the initial state: the text
translates to the program, the program executes to `returned 0` and the
certificate bound is accepted by the checker. -/
theorem endToEnd_chain :
    SourceTranslation source17ReturnZeroFragment source17ReturnZeroProgram ∧
      CExec source17ReturnZeroProgram initState
        (.returned (some (BitVec.ofNat 64 0)) initState) ∧
      sqrt2Witness.checkSqrt2 = true :=
  ⟨source17ReturnZero_translation, source17ReturnZero_exec initState,
    sqrt2Witness_checked⟩

end B20.Foundation
