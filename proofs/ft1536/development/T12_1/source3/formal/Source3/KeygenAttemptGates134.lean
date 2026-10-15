import Source3.KeygenAttemptGates105
import Source3.KeygenCertificateEntry104
import Source3.KeygenCallerPrefix134
import Source3.KeygenMakeSearchPrefix134
import Source3.KeygenPublicDomain134
import Source3.KeygenTernaryFunction134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenAttemptGates134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)


open KeygenAttemptGates105
theorem public_after (ctx : Context) (before : State) (i : Nat) (normed : State)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (size : C99CountedWords.Limit before) (hLive : 0 < before.heap.size h.block)
    (source : KeygenCallerPrefix134.Ternary ctx (KeygenMakeSearchPrefix.updated ctx before i) ⟨normed,.normal⟩)
    (a b : Result)
    (first : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close before normed) a)
    (second : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close before normed) b) : a = b := by
  let domain := KeygenPublicDomain134.after_ternary ctx before i ⟨normed,.normal⟩ polynomials h primes rev initial size hLive source
  have unique := KeygenPublicCall095.call_unique domain
  change ∀ (a b : State) (x y : C99IntegerReference.Value),
    KeygenPublicSource.Call (KeygenCallerPrefix.close before normed) a x →
    KeygenPublicSource.Call (KeygenCallerPrefix.close before normed) b y → a = b ∧ x = y at unique
  cases first <;> cases second
  all_goals grind

theorem gates (ctx : Context) (before : State) (i : Nat)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (size : C99CountedWords.Limit before) (hLive : 0 < before.heap.size h.block) (a b : Result)
    (first : KeygenMakeSearchPrefix134.Gates ctx before (KeygenMakeSearchPrefix.updated ctx before i) a)
    (second : KeygenMakeSearchPrefix134.Gates ctx before (KeygenMakeSearchPrefix.updated ctx before i) b) : a = b := by
  have prepared := KeygenMakeSampling.prepared_initial ctx before i polynomials h primes rev initial
  have ternary := KeygenTernaryFunction134.source_unique ctx (KeygenMakeSearchPrefix.updated ctx before i)
    polynomials h primes rev prepared
  have publicUnique := public_after ctx before i
  cases first <;> cases second
  all_goals grind (ematch := 8) only [root]

theorem sampled (ctx : Context) (before : State) (i : Nat)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (hLive : 0 < before.heap.size h.block) (a b : Result)
    (first : KeygenMakeSearchPrefix134.Sampled ctx before a) (second : KeygenMakeSearchPrefix134.Sampled ctx before b) : a = b := by
  cases first with
  | run entry1 a cap1 gates1 =>
      cases second with
      | run entry2 b cap2 gates2 =>
          have same := congrArg Result.state (KeygenCappedSampler092.cap_unique ctx before i _ _ remaining cap1 cap2)
          change entry1 = entry2 at same
          subst entry2
          rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry1,.normal⟩
            remaining.2.2 remaining.1 remaining.2.1.1 cap1 with exhausted | running
          · have impossible := congrArg Result.flow exhausted.2
            cases impossible
          · have entryEq := congrArg Result.state running.2.1
            change entry1 = KeygenMakeSearchPrefix.updated ctx before i at entryEq
            subst entry1
            exact gates ctx before i polynomials h primes rev initial remaining.2.1.1 hLive a b gates1 gates2

end FT1536.Source3.KeygenAttemptGates134
