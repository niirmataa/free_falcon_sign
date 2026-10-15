import Source3.KeygenWholeStages109
import Source3.KeygenWholeTrace109
import Source3.KeygenCertificateSource134
import Source3.KeygenLoopFunction134
import Source3.KeygenTailFunction134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenWholeStages134
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)


open KeygenWholeStages109
theorem loops (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (bound entry : State) (events : List KeygenEntropySource.Event) (a b : Result)
    (xs ys : List (KeygenCertificateSource134.AttemptExecution (canonical env).ctx))
    (binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (first : KeygenCertificateSource134.Loop (canonical env).ctx entry a xs)
    (second : KeygenCertificateSource134.Loop (canonical env).ctx entry b ys) : a = b := by
  have equal := KeygenMakeArguments.bind_exact seeded (canonical env).args bound binding
  subst bound
  let legal := KeygenLoopEntry105.from_prefix (canonical env) seeded entry (domain env input seed seeded seeding) events ready
  exact KeygenLoopFunction134.execution (canonical env).ctx entry a b xs ys first second legal.entry

theorem tails (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut a b : Result)
    (attempts : List (KeygenCertificateSource134.AttemptExecution (canonical env).ctx))
    (xs ys : List (KeygenPublicCallerSite077.Site (canonical env)))
    (binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (loop : KeygenCertificateSource134.Loop (canonical env).ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
    (first : KeygenPublicCallerExecution077.Encoding (canonical env) KeygenMakeProgram.encoding loopOut.state a xs)
    (second : KeygenPublicCallerExecution077.Encoding (canonical env) KeygenMakeProgram.encoding loopOut.state b ys) : a = b := by
  let legal := KeygenTailFunction134.from_loop env seeded bound entry loopOut (domain env input seed seeded seeding)
    events attempts binding ready loop normal
  exact KeygenTailRun108.unique env loopOut.state a b legal.cells legal.separate
    (KeygenTailRun108.erase env loopOut.state a xs first) (KeygenTailRun108.erase env loopOut.state b ys second)

end FT1536.Source3.KeygenWholeStages134
