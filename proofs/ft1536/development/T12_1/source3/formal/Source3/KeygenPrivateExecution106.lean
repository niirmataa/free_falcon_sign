import Source3.KeygenCodecScope106

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrivateExecution106
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecExecution (Exec Flow)
open KeygenCodecAtoms106 (Clean)
open KeygenCodecScope106 (checkedCode)

theorem clean (args : Args) (code : Stmt) (before after : State) (flow : Flow)
    (checked : checkedCode code = true) (start : Clean before.locals)
    (source : Exec args code before after flow) : Clean after.locals := by
  revert checked start
  induction source <;> intro checked start
  all_goals try simp only [checkedCode, KeygenCodecExecution.desugar, KeygenCodecValues.withLocals, Bool.and_eq_true, Bool.false_eq_true] at *
  all_goals grind (ematch := 8) only [→ KeygenPrivateValues106.clean, → KeygenCodecAtoms106.update_clean,
    KeygenCodecScope106.declarations, KeygenCodecScope106.assign_clean, KeygenCodecScope106.scope,
    KeygenCodecValues.declared, KeygenCodecValues.withLocals]

theorem clean_activation (args : Args) (code : Stmt) (heap : C99MemoryReference.Memory)
    (locals : Locals) (buf : Option (Option C99MemoryReference.ArrayPointer)) (after : State) (flow : Flow)
    (checked : checkedCode code = true) (start : Clean locals)
    (source : Exec args code ⟨heap,locals,buf⟩ after flow) : Clean after.locals :=
  clean args code ⟨heap,locals,buf⟩ after flow checked start source

theorem execution (args : Args) (code : Stmt) (before a b : State) (r s : Flow)
    (checked : checkedCode code = true) (start : Clean before.locals)
    (first : Exec args code before a r) (second : Exec args code before b s) : a = b ∧ r = s := by
  revert checked start
  induction first generalizing b s <;> intro checked start <;> cases second
  all_goals try simp only [checkedCode, KeygenCodecExecution.desugar, KeygenCodecValues.withLocals, Bool.and_eq_true, Bool.false_eq_true] at *
  all_goals grind (ematch := 10) only [→ clean, → clean_activation, → KeygenPrivateValues106.clean, → KeygenPrivateValues106.expression,
    → KeygenCodecAtoms106.update, KeygenCodecAtoms106.assigned, KeygenCodecScope106.store_byte]

theorem leaf_unique (kind : Callee) (args : Args) (before a b : State) (r s : Flow)
    (start : Clean before.locals)
    (first : Exec args (KeygenCodecExecution.body kind) before a r)
    (second : Exec args (KeygenCodecExecution.body kind) before b s) : a = b ∧ r = s := by
  apply execution args _ before a b r s _ start first second
  cases kind
  · exact KeygenCodecScope106.none_checked
  · exact KeygenCodecScope106.static_checked

theorem initial_leaf (kind : Callee) (args : Args) (before : C99MemoryReference.Memory)
    (a b : State) (r s : Flow)
    (first : Exec args (KeygenCodecExecution.body kind) (initial args before) a r)
    (second : Exec args (KeygenCodecExecution.body kind) (initial args before) b s) : a = b ∧ r = s :=
  leaf_unique kind args (initial args before) a b r s (KeygenCodecAtoms106.initial_clean args) first second

end FT1536.Source3.KeygenPrivateExecution106
