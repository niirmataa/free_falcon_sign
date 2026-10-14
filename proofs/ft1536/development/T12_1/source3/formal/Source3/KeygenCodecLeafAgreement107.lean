import Source3.KeygenCodecStateAgreement107

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecLeafAgreement107
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecExecution (Exec Flow)
open KeygenCodecAtoms106 (Clean)
open KeygenCodecAgreement107 (Agree noComp)
open KeygenCodecStateAgreement107 (Related checkedCode)

theorem execution (argsA argsB : Args) (code : Stmt) (beforeA beforeB a b : State) (r s : Flow)
    (first : Exec argsA code beforeA a r) (second : Exec argsB code beforeB b s)
    (safe : KeygenCodecScope106.checkedCode code = true) (checked : checkedCode code = true)
    (start : Clean beforeA.locals) (same : Related beforeA beforeB) (outEqual : argsA.out = argsB.out) :
    Related a b ∧ r = s := by
  revert safe checked start same outEqual
  induction first generalizing argsB beforeB b s <;> intro safe checked start same outEqual <;> cases second
  all_goals have heaps := same.1
  all_goals have values := same.2.1
  all_goals have buffers := same.2.2
  all_goals try simp only [checkedCode, KeygenCodecScope106.checkedCode, KeygenCodecExecution.desugar,
    KeygenCodecValues.withLocals, noComp, Bool.and_eq_true, Bool.false_eq_true, decide_eq_true_eq] at *
  all_goals grind (ematch := 12) only [Related, → KeygenPrivateExecution106.clean,
    → KeygenPrivateExecution106.clean_activation, → KeygenPrivateValues106.clean,
    → KeygenCodecStateAgreement107.expression, → KeygenCodecValueAgreement107.expression,
    → KeygenCodecAgreement107.update, KeygenCodecAgreement107.cell,
    KeygenCodecAgreement107.set, KeygenCodecAgreement107.pointer,
    KeygenCodecStateAgreement107.locals, KeygenCodecStateAgreement107.assignment,
    → KeygenCodecStateAgreement107.declarations, KeygenCodecStateAgreement107.declared,
    KeygenCodecStateAgreement107.scope, KeygenCodecAtoms106.assigned, KeygenCodecScope106.store_byte]

theorem leaf (kind : Callee) (argsA argsB : Args) (beforeA beforeB a b : State) (r s : Flow)
    (first : Exec argsA (KeygenCodecExecution.body kind) beforeA a r)
    (second : Exec argsB (KeygenCodecExecution.body kind) beforeB b s)
    (start : Clean beforeA.locals) (same : Related beforeA beforeB) (outEqual : argsA.out = argsB.out) :
    Related a b ∧ r = s := by
  apply execution argsA argsB _ beforeA beforeB a b r s first second _ _ start same outEqual
  · cases kind
    · exact KeygenCodecScope106.none_checked
    · exact KeygenCodecScope106.static_checked
  · cases kind
    · exact KeygenCodecStateAgreement107.none_checked
    · exact KeygenCodecStateAgreement107.static_checked

end FT1536.Source3.KeygenCodecLeafAgreement107
