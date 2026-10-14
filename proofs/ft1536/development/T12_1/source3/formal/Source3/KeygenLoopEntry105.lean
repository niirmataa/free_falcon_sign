import Source3.KeygenLoopFunction105
import Source3.KeygenSeedPrefix092

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLoopEntry105
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenWholeBytes088 (Domain)

/-- Derive every loop invariant from the existing whole-call memory domain
    and the actual completed prefix, including the public object's liveness. -/
def from_prefix (env : Env) (caller after : State) (domain : Domain env caller)
    (events : List KeygenEntropySource.Event)
    (source : KeygenMakeReady.Prefix env.ctx (KeygenMakeArguments.entry caller env.args)
      env.blocks events ⟨after,.normal⟩) : KeygenLoopFunction105.Domain env.ctx := by
  let bound := KeygenMakeArguments.entry caller env.args
  have original := domain.rootLegal.original
  have facts := KeygenMakeReady.normal_prefix env.ctx bound after env.blocks domain.primes domain.rev original events source
  have locals := KeygenMakeReady.normal_prefix_locals env.ctx bound after env.blocks domain.primes domain.rev original events source
  have dimensions : KeygenMakeSearchPrefix.Dimensions after := by
    change C99CountedWords.Limit after ∧ _
    unfold C99CountedWords.Limit
    rw [locals]
    exact ⟨rfl, rfl, rfl⟩
  have sizes := KeygenEntryAt080.scratch_size env.ctx bound after env.blocks domain.primes domain.rev events original source
  exact ⟨after, {
    count := 0
    polynomials := KeygenMakeEntry.input env.blocks
    h := KeygenMakeEntry.publicPointer env.blocks
    primes := domain.primes
    rev := domain.rev
    initial := facts.2.1
    remaining := ⟨facts.1, dimensions, by decide⟩
    shape := KeygenCertificateEntry104.shape env caller domain
    space := by
      change C99Automatic32.align4 (after.heap.size env.ctx.scratch.block) + 4 < 2^64
      rw [sizes]
      exact domain.rootLegal.workspaceSpace
    publicLive := KeygenPublicDomain095.prefix_public_live env.ctx bound env.blocks events ⟨after,.normal⟩ source }⟩

/-- The SAME state obtained from the actual seeded prefix supplies the
    stopped-loop input. The source evidence supplies no future success. -/
noncomputable def from_seed (env : Env) (input : KeygenSeedPrefix092.Input env)
    (seed : KeygenSeedEntry089.Seed) (after : State)
    (source : KeygenSeedPrefix092.Source env input seed after) : KeygenLoopFunction105.Domain env.ctx := by
  let seeded := Classical.choose source
  have evidence := Classical.choose_spec source
  let domain := KeygenSeedDomain089.seeded_domain env input.base input.seedBlock seed seeded input.domain input.fresh evidence.1
  exact from_prefix env seeded after domain [] ((KeygenSeedPrefix092.invocation_iff env seeded after).mp evidence.2)

theorem from_seed_before (env : Env) (input : KeygenSeedPrefix092.Input env)
    (seed : KeygenSeedEntry089.Seed) (after : State) (source : KeygenSeedPrefix092.Source env input seed after) :
    (from_seed env input seed after source).before = after := rfl

end FT1536.Source3.KeygenLoopEntry105
