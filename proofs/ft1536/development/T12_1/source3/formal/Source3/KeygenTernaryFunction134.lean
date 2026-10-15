import Source3.KeygenTernaryFunction094
import Source3.KeygenNormSource094
import Source3.KeygenAttemptNorm133
import Source3.KeygenCallerPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenTernaryFunction134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)


open KeygenTernaryFunction094
theorem source_unique (ctx : Context) (before : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev) (a b : Result)
    (first : KeygenCallerPrefix134.Ternary ctx before a) (second : KeygenCallerPrefix134.Ternary ctx before b) : a = b := by
  have legal := KeygenCappedSampler092.initial_legal ctx before input h primes rev initial
  cases first <;> cases second
  all_goals grind only [KeygenCappedSampler092.context_unique, → KeygenCappedSampler092.context_legal,
    resultants_after_samples, KeygenAttemptNorm133.unique]

end FT1536.Source3.KeygenTernaryFunction134
