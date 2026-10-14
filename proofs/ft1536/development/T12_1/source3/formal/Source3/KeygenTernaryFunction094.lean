import Source3.KeygenNormSource094

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTernaryFunction094
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem resultants_after_samples (ctx : Context) (before middle sampled : State)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (first : KeygenSamplerContext.Call ctx before "f" middle)
    (second : KeygenSamplerContext.Call ctx middle "g" sampled) (a b : Result)
    (left : KeygenResultantGate.Exec sampled a) (right : KeygenResultantGate.Exec sampled b) : a = b := by
  let legal := KeygenResultantFunction093.from_samples ctx before middle sampled input h primes rev initial first second
  exact KeygenResultantCall093.gate_unique sampled legal.f legal.g a b
    legal.fPointer legal.gPointer legal.fLive legal.gLive legal.tablesLive left right

theorem source_unique (ctx : Context) (before : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev) (a b : Result)
    (first : KeygenCallerPrefix.Ternary ctx before a) (second : KeygenCallerPrefix.Ternary ctx before b) : a = b := by
  have legal := KeygenCappedSampler092.initial_legal ctx before input h primes rev initial
  cases first <;> cases second
  all_goals grind only [KeygenCappedSampler092.context_unique, → KeygenCappedSampler092.context_legal,
    resultants_after_samples, KeygenNormSource094.norm_unique]

structure Input (ctx : Context) where
  before : State
  polynomials : Fin 4 → ArrayPointer
  h : ArrayPointer
  primes : ArrayPointer
  rev : ArrayPointer
  initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev

/-- The real two samplers, resultant gates, raw norm and GS gate in their
    source order. Rejection remains a source result; public computation,
    NTRU solving and certification follow normal completion. -/
noncomputable def ternary (ctx : Context) (input : Input ctx) : Part Result where
  Dom := ∃ out, KeygenCallerPrefix.Ternary ctx input.before out
  get domain := Classical.choose domain

theorem ternary_spec (ctx : Context) (input : Input ctx) (out : Result) :
    out ∈ ternary ctx input ↔ KeygenCallerPrefix.Ternary ctx input.before out := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result, KeygenCallerPrefix.Ternary ctx input.before result := ⟨out, source⟩
    exact ⟨domain, source_unique ctx input.before input.polynomials input.h input.primes input.rev input.initial
      (Classical.choose domain) out (Classical.choose_spec domain) source⟩

end FT1536.Source3.KeygenTernaryFunction094
