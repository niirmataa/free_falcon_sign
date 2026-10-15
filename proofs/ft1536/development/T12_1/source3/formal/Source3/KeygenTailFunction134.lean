import Source3.KeygenTailFunction108
import Source3.KeygenTailRun108
import Source3.KeygenCertificateSource134
import Source3.KeygenTailCellsAt134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenTailFunction134
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)


open KeygenTailFunction108
def from_loop (env : Env) (caller bound entry : State) (out : Result)
    (domain : KeygenWholeBytes088.Domain (canonical env) caller)
    (events : List KeygenEntropySource.Event)
    (attempts : List (KeygenCertificateSource134.AttemptExecution (canonical env).ctx))
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
      (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (loop : KeygenCertificateSource134.Loop (canonical env).ctx entry out attempts) (normal : out.flow = .normal) : Input env := by
  have boundEq := KeygenMakeArguments.bind_exact caller (canonical env).args bound binding
  have original : KeygenMakeEntry.Original (canonical env).ctx bound domain.primes domain.rev := by
    rw [boundEq]
    exact domain.rootLegal.original
  have shape := KeygenCertificateEntry104.shape (canonical env) caller domain
  have projected := KeygenCertificateSource134.loop_projection (canonical env).ctx entry out attempts shape loop
  have remaining := KeygenMakeLoopChronology.entry_remaining (canonical env) bound entry domain.primes domain.rev events original ready
  have initial := KeygenMakeLoopChronology.entry_tail_cells (canonical env) caller bound entry domain.primes domain.rev events original binding ready
  refine ⟨out.state, KeygenTailCellsAt134.loop_cells (canonical env) entry out _ projected 0 remaining initial normal, ?_⟩
  intro equal
  have empty := KeygenMakeLifetime.prefix_empty (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩ ready (5 : Fin 6)
  rw [boundEq] at empty
  change caller.heap.size ((canonical env).blocks 5) = 0 at empty
  have live := domain.buffers.privateLive
  rw [equal, empty] at live
  omega

end FT1536.Source3.KeygenTailFunction134
