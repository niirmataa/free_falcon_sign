import Source3.KeygenPrivateExecution106

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicExecution106
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenPublicEncodeExecution077 (Exec Flow)
open KeygenCodecAtoms106 (Clean)
open KeygenCodecScope106 (checkedCode)

theorem clean (args : Args) (code : Stmt) (before after : State) (flow : Flow)
    (checked : checkedCode code = true) (start : Clean before.locals)
    (source : Exec args code before after flow) : Clean after.locals := by
  revert checked start
  induction source <;> intro checked start
  all_goals try simp only [checkedCode, KeygenCodecExecution.desugar, KeygenCodecValues.withLocals, Bool.and_eq_true] at *
  all_goals grind (ematch := 8) only [→ KeygenPublicValues106.clean, → KeygenCodecAtoms106.update_clean,
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
  all_goals try simp only [checkedCode, KeygenCodecExecution.desugar, KeygenCodecValues.withLocals, Bool.and_eq_true] at *
  all_goals grind (ematch := 10) only [→ clean, → clean_activation, → KeygenPublicValues106.clean, → KeygenPublicValues106.expression,
    → KeygenCodecAtoms106.update, KeygenCodecAtoms106.assigned, KeygenCodecScope106.store_byte]

theorem call_unique (args : Args) (before a b : C99MemoryReference.Memory) (x y : BitVec 64)
    (first : KeygenPublicEncodeExecution077.Call args before a x)
    (second : KeygenPublicEncodeExecution077.Call args before b y) : a = b ∧ x = y := by
  obtain ⟨out1, source1, heap1⟩ := first
  obtain ⟨out2, source2, heap2⟩ := second
  have same := execution args KeygenPublicEncodeBinding077.code (initial args before) out1 out2 (.returned x) (.returned y)
    KeygenCodecScope106.public_checked (KeygenCodecAtoms106.initial_clean args) source1 source2
  cases same.1
  exact ⟨heap1.symm.trans heap2, KeygenCodecExecution.Flow.returned.inj same.2⟩

noncomputable def encode (args : Args) (before : C99MemoryReference.Memory) : Part (C99MemoryReference.Memory × BitVec 64) where
  Dom := ∃ result : C99MemoryReference.Memory × BitVec 64,
    KeygenPublicEncodeExecution077.Call args before result.1 result.2
  get domain := Classical.choose domain

theorem encode_spec (args : Args) (before : C99MemoryReference.Memory) (out : C99MemoryReference.Memory × BitVec 64) :
    out ∈ encode args before ↔ KeygenPublicEncodeExecution077.Call args before out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    rw [← equal]
    exact Classical.choose_spec domain
  · intro source
    let domain : ∃ result : C99MemoryReference.Memory × BitVec 64,
      KeygenPublicEncodeExecution077.Call args before result.1 result.2 := ⟨out, source⟩
    have same := call_unique args before (Classical.choose domain).1 out.1
      (Classical.choose domain).2 out.2 (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenPublicExecution106
