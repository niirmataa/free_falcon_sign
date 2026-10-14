import Source3.KeygenCodecTerminal107

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrivateDispatcher107
open C99MemoryReference
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecExecution (Exec Flow)
open KeygenCodecAtoms106 (Clean)

def checkedCode : Stmt → Bool
  | .declare objects => KeygenCodecScope106.declarationsChecked objects
  | .seq a b | .branch _ a b => checkedCode a && checkedCode b
  | .scope body | .whileLoop _ body => checkedCode body
  | .switch _ a b c => checkedCode a && checkedCode b && checkedCode c
  | .loop initial _ increment body => checkedCode initial && (checkedCode body && checkedCode increment)
  | .skip | .write _ _ _ | .increment _ | .evaluate _ | .ret _ | .breakLoop | .continueLoop => true

theorem leaf_checked (kind : Callee) : checkedCode (KeygenCodecExecution.body kind) = true := by
  cases kind <;> decide +kernel

theorem dispatcher_checked : checkedCode KeygenCodecDispatchBinding.code = true := by decide +kernel

theorem clean (args : Args) (code : Stmt) (before after : State) (flow : Flow)
    (checked : checkedCode code = true) (start : Clean before.locals)
    (source : Exec args code before after flow) : Clean after.locals := by
  revert checked start
  induction source <;> intro checked start
  all_goals try simp only [checkedCode, KeygenCodecExecution.desugar, KeygenCodecValues.withLocals,
    KeygenCodecValues.initial, Bool.and_eq_true] at *
  all_goals grind (ematch := 10) only [→ KeygenPrivateValues106.clean, → KeygenCodecAtoms106.update_clean,
    KeygenCodecScope106.declarations, KeygenCodecScope106.assign_clean, KeygenCodecScope106.scope,
    KeygenCodecValues.declared, KeygenCodecValues.withLocals, KeygenCodecAtoms106.initial_clean, leaf_checked]

theorem clean_activation (args : Args) (code : Stmt) (heap : Memory) (locals : Locals)
    (buf : Option (Option ArrayPointer)) (after : State) (flow : Flow)
    (checked : checkedCode code = true) (start : Clean locals)
    (source : Exec args code ⟨heap,locals,buf⟩ after flow) : Clean after.locals :=
  clean args code ⟨heap,locals,buf⟩ after flow checked start source

theorem no_expression_call (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (kind : Callee) (params : Expr) (a b : Locals) (v : Value)
    (source : Eval args heap buf (.call kind params) a v b) : False := by cases source

/-- After a return only heap and returned value are observed. Normal
    fallthrough retains full activation equality for the next statement. -/
def SameOutcome (a : State) (r : Flow) (b : State) (s : Flow) : Prop :=
  r = s ∧ a.heap = b.heap ∧ (r = .normal → a = b)

theorem execution (args : Args) (code : Stmt) (before a b : State) (r s : Flow)
    (checked : checkedCode code = true) (start : Clean before.locals)
    (first : Exec args code before a r) (second : Exec args code before b s) : SameOutcome a r b s := by
  revert checked start
  induction first generalizing b s <;> intro checked start <;> cases second
  all_goals try simp only [checkedCode, KeygenCodecExecution.desugar, KeygenCodecValues.withLocals,
    Bool.and_eq_true, SameOutcome] at *
  all_goals grind (ematch := 12) only [→ clean, → clean_activation, → KeygenPrivateValues106.clean,
    → KeygenPrivateValues106.expression, → KeygenCodecAtoms106.update, KeygenCodecAtoms106.assigned,
    KeygenCodecScope106.store_byte, → no_expression_call, → KeygenCodecTerminal107.terminal,
    KeygenCodecExecution.scopeExit]

theorem call_unique (args : Args) (before a b : Memory) (x y : BitVec 64)
    (first : KeygenCodecExecution.Call args before a x) (second : KeygenCodecExecution.Call args before b y) :
    a = b ∧ x = y := by
  obtain ⟨out1, source1, heap1⟩ := first
  obtain ⟨out2, source2, heap2⟩ := second
  have same := execution args KeygenCodecDispatchBinding.code (initial args before) out1 out2 (.returned x) (.returned y)
    dispatcher_checked (KeygenCodecAtoms106.initial_clean args) source1 source2
  exact ⟨heap1.symm.trans (same.2.1.trans heap2), Flow.returned.inj same.1⟩

noncomputable def encode (args : Args) (before : Memory) : Part (Memory × BitVec 64) where
  Dom := ∃ result : Memory × BitVec 64, KeygenCodecExecution.Call args before result.1 result.2
  get domain := Classical.choose domain

theorem encode_spec (args : Args) (before : Memory) (out : Memory × BitVec 64) :
    out ∈ encode args before ↔ KeygenCodecExecution.Call args before out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    rw [← equal]
    exact Classical.choose_spec domain
  · intro source
    let domain : ∃ result : Memory × BitVec 64, KeygenCodecExecution.Call args before result.1 result.2 := ⟨out, source⟩
    have same := call_unique args before (Classical.choose domain).1 out.1
      (Classical.choose domain).2 out.2 (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenPrivateDispatcher107
