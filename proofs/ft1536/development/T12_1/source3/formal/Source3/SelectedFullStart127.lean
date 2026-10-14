import Source3.KeygenFullDomain127
import Source3.KeygenFullStatics127
import Source3.KeygenFullBuffers127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFullStart127
open C99CompactState115 (State reference)
open KeygenFullData127 (env base rawEnv)

def seed := SelectedInput124.seed
def seedResult := KeygenPublicInput124.seed env base 0 seed 128 64
theorem seed_defined : seedResult.isSome=true := by decide +kernel
def seeded : State := seedResult.get seed_defined
theorem seed_computed : KeygenPublicInput124.seed env base 0 seed 128 64=some seeded :=
  SelectedInput124.option_get seedResult seed_defined
theorem seeding : KeygenSeedEntry089.Seeded env (reference base) 0 seed (reference seeded) :=
  KeygenPublicInput124.seed_sound env base seeded 0 seed 128 64 seed_computed

def domain : KeygenWholeBytes088.Domain env (reference seeded) :=
  KeygenWholeStages109.domain rawEnv KeygenFullDomain127.input seed (reference seeded) seeding

def prefixResult := KeygenMakePrefix125.run env seeded 128 64
theorem prefix_defined : prefixResult.isSome=true := by decide +kernel
def ready : State := prefixResult.get prefix_defined
theorem prefix_computed : KeygenMakePrefix125.run env seeded 128 64=some ready :=
  SelectedInput124.option_get prefixResult prefix_defined
theorem invocation : KeygenMakeArguments.PrefixInvocation env.args env.ctx (reference seeded) env.blocks [] ⟨reference ready,.normal⟩ :=
  KeygenMakePrefix125.run_sound env seeded ready 128 64 prefix_computed
theorem prefix_source : KeygenMakeReady.Prefix env.ctx
    (KeygenMakeArguments.entry (reference seeded) env.args) env.blocks [] ⟨reference ready,.normal⟩ :=
  (KeygenSeedPrefix092.invocation_iff env (reference seeded) (reference ready)).mp invocation

/-- This is the new explicit full static/global input. Earlier fixed-input
    instances remain separate and are not silently reinterpreted. -/
theorem source : KeygenSeedPrefix092.Source env KeygenFullDomain127.input seed (reference ready) :=
  ⟨reference seeded,seeding,invocation⟩

theorem entry_facts : KeygenCapWords.Count (reference ready) 0 ∧
    KeygenCallerEntry.Initial env.ctx (reference ready) (KeygenMakeEntry.input env.blocks)
      (KeygenMakeEntry.publicPointer env.blocks) domain.primes domain.rev ∧
    KeygenReadyResult.flagPresent env.ctx (reference ready).heap .seeded ∧
    KeygenReadyResult.flagPresent env.ctx (reference ready).heap .flipped :=
  KeygenMakeReady.normal_prefix env.ctx _ _ env.blocks domain.primes domain.rev domain.rootLegal.original [] prefix_source

end FT1536.Source3.SelectedFullStart127
