import Source3.KeygenWholeTrace109

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWholeStages109
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)

abbrev Input (env : Env) := KeygenSeedPrefix092.Input (canonical env)

def domain (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (source : Seeded (canonical env) input.base input.seedBlock seed seeded) :
    KeygenWholeBytes088.Domain (canonical env) seeded :=
  KeygenSeedDomain089.seeded_domain (canonical env) input.base input.seedBlock seed seeded input.domain input.fresh source

theorem prefixes (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (boundA boundB : State) (eventsA eventsB : List KeygenEntropySource.Event) (a b : Result)
    (bindA : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) boundA)
    (bindB : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) boundB)
    (first : KeygenMakeReady.Prefix (canonical env).ctx boundA (canonical env).blocks eventsA a)
    (second : KeygenMakeReady.Prefix (canonical env).ctx boundB (canonical env).blocks eventsB b) :
    boundA = boundB ∧ a = b ∧ eventsA = eventsB := by
  have left := KeygenMakeArguments.bind_exact seeded (canonical env).args boundA bindA
  have right := KeygenMakeArguments.bind_exact seeded (canonical env).args boundB bindB
  subst boundA boundB
  let legal := KeygenSeedPrefix092.prefixInput (canonical env) input seed seeded seeding
  exact ⟨rfl, KeygenPrefixFunction092.prefix_unique (canonical env).ctx legal.before (canonical env).blocks
    legal.primes legal.rev legal.original legal.flags eventsA eventsB a b first second⟩

theorem prefix_normal (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (bound : State) (events : List KeygenEntropySource.Event) (out : Result)
    (binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
    (source : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events out) :
    out.flow = .normal ∧ events = [] :=
  KeygenSeedTrace092.prefix_facts (canonical env) input seed seeded bound seeding binding events out source

theorem loops (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (bound entry : State) (events : List KeygenEntropySource.Event) (a b : Result)
    (xs ys : List (KeygenCertificateSource080.AttemptExecution (canonical env).ctx))
    (binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (first : KeygenCertificateSource080.Loop (canonical env).ctx entry a xs)
    (second : KeygenCertificateSource080.Loop (canonical env).ctx entry b ys) : a = b := by
  have equal := KeygenMakeArguments.bind_exact seeded (canonical env).args bound binding
  subst bound
  let legal := KeygenLoopEntry105.from_prefix (canonical env) seeded entry (domain env input seed seeded seeding) events ready
  exact KeygenLoopFunction105.execution (canonical env).ctx entry a b xs ys first second legal.entry

theorem tails (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut a b : Result)
    (attempts : List (KeygenCertificateSource080.AttemptExecution (canonical env).ctx))
    (xs ys : List (KeygenPublicCallerSite077.Site (canonical env)))
    (binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
    (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
    (loop : KeygenCertificateSource080.Loop (canonical env).ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
    (first : KeygenPublicCallerExecution077.Encoding (canonical env) KeygenMakeProgram.encoding loopOut.state a xs)
    (second : KeygenPublicCallerExecution077.Encoding (canonical env) KeygenMakeProgram.encoding loopOut.state b ys) : a = b := by
  let legal := KeygenTailFunction108.from_loop env seeded bound entry loopOut (domain env input seed seeded seeding)
    events attempts binding ready loop normal
  exact KeygenTailRun108.unique env loopOut.state a b legal.cells legal.separate
    (KeygenTailRun108.erase env loopOut.state a xs first) (KeygenTailRun108.erase env loopOut.state b ys second)

end FT1536.Source3.KeygenWholeStages109
