import Source3.KeygenTailRun108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTailFunction108
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)

structure Input (env : Env) where
  before : State
  cells : KeygenMakeInvocation.TailCells (canonical env) before
  separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5

noncomputable def encode (env : Env) (input : Input env) : Part Result where
  Dom := ∃ out, ∃ calls, KeygenPublicCallerExecution077.Encoding (canonical env)
    KeygenMakeProgram.encoding input.before out calls
  get domain := Classical.choose domain

theorem encode_spec (env : Env) (input : Input env) (out : Result) :
    out ∈ encode env input ↔ ∃ calls, KeygenPublicCallerExecution077.Encoding (canonical env)
      KeygenMakeProgram.encoding input.before out calls := by
  constructor
  · rintro ⟨domain, equal⟩
    rw [← equal]
    exact Classical.choose_spec domain
  · rintro ⟨calls, source⟩
    let domain : ∃ result, ∃ trace, KeygenPublicCallerExecution077.Encoding (canonical env)
      KeygenMakeProgram.encoding input.before result trace := ⟨out, calls, source⟩
    obtain ⟨trace, actual⟩ := Classical.choose_spec domain
    have same := KeygenTailRun108.unique env input.before (Classical.choose domain) out input.cells input.separate
      (KeygenTailRun108.erase env input.before _ trace actual) (KeygenTailRun108.erase env input.before out calls source)
    exact ⟨domain, same⟩

/-- Derive all caller-tail inputs from actual binding, prefix and accepted
    capped loop. No encoding success, pointer-decoding oracle or codec
    postcondition is an input. -/
def from_loop (env : Env) (caller bound entry : State) (out : Result)
    (domain : KeygenWholeBytes088.Domain (canonical env) caller)
    (events : List KeygenEntropySource.Event)
    (attempts : List (KeygenCertificateSource080.AttemptExecution (canonical env).ctx))
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
      (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (loop : KeygenCertificateSource080.Loop (canonical env).ctx entry out attempts) (normal : out.flow = .normal) : Input env := by
  have boundEq := KeygenMakeArguments.bind_exact caller (canonical env).args bound binding
  have original : KeygenMakeEntry.Original (canonical env).ctx bound domain.primes domain.rev := by
    rw [boundEq]
    exact domain.rootLegal.original
  have shape := KeygenCertificateEntry104.shape (canonical env) caller domain
  have projected := KeygenCertificateSource080.loop_projection (canonical env).ctx entry out attempts shape loop
  have remaining := KeygenMakeLoopChronology.entry_remaining (canonical env) bound entry domain.primes domain.rev events original ready
  have initial := KeygenMakeLoopChronology.entry_tail_cells (canonical env) caller bound entry domain.primes domain.rev events original binding ready
  refine ⟨out.state, KeygenTailCellsAt080.loop_cells (canonical env) entry out _ projected 0 remaining initial normal, ?_⟩
  intro equal
  have empty := KeygenMakeLifetime.prefix_empty (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩ ready (5 : Fin 6)
  rw [boundEq] at empty
  change caller.heap.size ((canonical env).blocks 5) = 0 at empty
  have live := domain.buffers.privateLive
  rw [equal, empty] at live
  omega

theorem from_loop_before (env : Env) (caller bound entry : State) (out : Result)
    (domain : KeygenWholeBytes088.Domain (canonical env) caller)
    (events : List KeygenEntropySource.Event)
    (attempts : List (KeygenCertificateSource080.AttemptExecution (canonical env).ctx))
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
      (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (loop : KeygenCertificateSource080.Loop (canonical env).ctx entry out attempts) (normal : out.flow = .normal) :
    (from_loop env caller bound entry out domain events attempts binding ready loop normal).before = out.state := rfl

end FT1536.Source3.KeygenTailFunction108
