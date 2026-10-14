import Source3.KeygenCappedSampler092
import Source3.KeygenSeedDomain089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedPrefix092
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenWholeBytes088 (Domain)
open KeygenSeedEntry089 (Seed Seeded)

structure Input (env : Env) where
  base : State
  domain : Domain env base
  seedBlock : Nat
  fresh : base.heap.size seedBlock = 0

def prefixInput (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (source : Seeded env input.base input.seedBlock seed seeded) : KeygenPrefixFunction092.Input env.ctx := by
  let domain := KeygenSeedDomain089.seeded_domain env input.base input.seedBlock seed seeded input.domain input.fresh source
  exact ⟨KeygenMakeArguments.entry seeded env.args, env.blocks, domain.primes, domain.rev,
    domain.rootLegal.original, KeygenSeedFlags089.seeded_flags env input.base input.seedBlock seed seeded source⟩

/-- The actual source chain from supplied bytes through the complete
    readiness prefix. The next state still contains the SAME SHAKE state. -/
def Source (env : Env) (input : Input env) (seed : Seed) (after : State) : Prop :=
  ∃ seeded, Seeded env input.base input.seedBlock seed seeded ∧
    KeygenMakeArguments.PrefixInvocation env.args env.ctx seeded env.blocks [] ⟨after, .normal⟩

theorem invocation_iff (env : Env) (seeded after : State) :
    KeygenMakeArguments.PrefixInvocation env.args env.ctx seeded env.blocks [] ⟨after, .normal⟩ ↔
      KeygenMakeReady.Prefix env.ctx (KeygenMakeArguments.entry seeded env.args) env.blocks [] ⟨after, .normal⟩ := by
  constructor
  · intro source
    cases source with
    | run bound events raw binding body =>
        rw [KeygenMakeArguments.bind_exact seeded env.args bound binding] at body
        exact body
  · intro body
    exact .run _ [] _ (KeygenMakeArguments.bind_exists seeded env.args) body

theorem source_unique (env : Env) (input : Input env) (seed : Seed) (a b : State)
    (first : Source env input seed a) (second : Source env input seed b) : a = b := by
  obtain ⟨s1, seed1, prefix1⟩ := first
  obtain ⟨s2, seed2, prefix2⟩ := second
  have same := KeygenSeedFunction089.seeded_unique env input.base input.seedBlock seed s1 s2 seed1 seed2
  subst s2
  let legal := prefixInput env input seed s1 seed1
  have equal := KeygenPrefixFunction092.prefix_unique env.ctx legal.before env.blocks legal.primes legal.rev
    legal.original legal.flags [] [] ⟨a, .normal⟩ ⟨b, .normal⟩
    ((invocation_iff env s1 a).mp prefix1) ((invocation_iff env s1 b).mp prefix2)
  exact congrArg C99ProcedureReference.Result.state equal.1

noncomputable def prepare (env : Env) (input : Input env) (seed : Seed) : Part State where
  Dom := ∃ after, Source env input seed after
  get domain := Classical.choose domain

theorem prepare_spec (env : Env) (input : Input env) (seed : Seed) (after : State) :
    after ∈ prepare env input seed ↔ Source env input seed after := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ value, Source env input seed value := ⟨after, source⟩
    exact ⟨domain, source_unique env input seed (Classical.choose domain) after (Classical.choose_spec domain) source⟩

theorem prepare_legal (env : Env) (input : Input env) (seed : Seed) (after : State)
    (returned : after ∈ prepare env input seed) :
    KeygenMakeSearchPrefix.Remaining after 0 ∧ KeygenSamplerTail091.Legal (KeygenSamplerContext.rng env.ctx) after := by
  obtain ⟨seeded, seeding, invocation⟩ := (prepare_spec env input seed after).mp returned
  exact KeygenCappedSampler092.prefix_remaining env.ctx (prefixInput env input seed seeded seeding) after
    ((KeygenPrefixFunction092.prefix_spec env.ctx _ after).mpr ((invocation_iff env seeded after).mp invocation))

end FT1536.Source3.KeygenSeedPrefix092
