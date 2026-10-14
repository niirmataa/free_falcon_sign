import Source3.KeygenMakeFgArity099

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeFgCall099
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeFgSource

theorem body_unique (kind : Kind) (before : State) (a b : Result)
    (first : Exec (code kind) before a) (second : Exec (code kind) before b) : a = b :=
  KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step) _ before a b
    (KeygenMakeFgArity099.body kind) first second

theorem call_unique (kind : Kind) (before a b : State) (args : List C99ArrayReference.Arg)
    (first : Call kind before args a) (second : Call kind before args b) : a = b := by
  obtain ⟨entry1, out1, binding1, source1, returned1, state1⟩ := first
  obtain ⟨entry2, out2, binding2, source2, returned2, state2⟩ := second
  have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
  subst entry2
  have outcomes := body_unique kind entry1 out1 out2 source1 source2
  subst out2
  exact state1.trans state2.symm

noncomputable def runCall (kind : Kind) (before : State) (args : List C99ArrayReference.Arg) : Part State where
  Dom := ∃ after, Call kind before args after
  get domain := Classical.choose domain

theorem runCall_spec (kind : Kind) (before : State) (args : List C99ArrayReference.Arg) (after : State) :
    after ∈ runCall kind before args ↔ Call kind before args after := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result, Call kind before args result := ⟨after, source⟩
    exact ⟨domain, call_unique kind before (Classical.choose domain) after args (Classical.choose_spec domain) source⟩

end FT1536.Source3.KeygenMakeFgCall099
