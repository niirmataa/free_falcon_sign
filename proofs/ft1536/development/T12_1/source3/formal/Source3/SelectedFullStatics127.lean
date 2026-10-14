import Source3.SelectedFullStart127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFullStatics127
open C99MemoryReference
open C99CompactState115 (reference)
open KeygenFullData127 (env base)
open SelectedFullStart127 (seed seeded ready seeding domain prefix_source)

theorem block_frame (block : Nat) (live : 0<(reference base).heap.size block) (outside : block≠env.ctx.object.block) :
    KeygenMakeObjects.Block (reference base).heap (reference ready).heap block := by
  have installed := (KeygenSeedDomain089.seed_input_frame env.ctx (reference base) 0 seed KeygenFullDomain127.seed_fresh).block
    block live outside
  have suppliedLive : 0<(KeygenSeedEntry089.caller (reference base) 0 seed).heap.size block := by
    rw [installed.1]
    exact live
  have initialized := (KeygenSeedDomain089.seeded_frame env (reference base) 0 seed (reference seeded) seeding).block
    block suppliedLive outside
  have seededLive : 0<(reference seeded).heap.size block := by
    rw [initialized.1]
    exact suppliedLive
  have prefixFrame := KeygenPublicEntry082.ready_block env.ctx
    (KeygenMakeArguments.entry (reference seeded) env.args) (reference ready) env.blocks domain.primes domain.rev []
    domain.rootLegal.original prefix_source block seededLive outside
  exact KeygenMakeObjects.block_trans _ _ _ block installed
    (KeygenMakeObjects.block_trans _ _ _ block initialized prefixFrame)

theorem tables : (reference ready).tables=(reference base).tables := by
  have first := KeygenPublicEntry082.ready_tables env.ctx
    (KeygenMakeArguments.entry (reference seeded) env.args) (reference ready) env.blocks domain.primes domain.rev []
    domain.rootLegal.original prefix_source
  have second := (KeygenSeedDomain089.seeded_frame env (reference base) 0 seed (reference seeded) seeding).tables
  exact first.trans second

theorem fft_frame (table : FftTableParser.Table) :
    KeygenMakeObjects.Block (reference base).heap (reference ready).heap (FftGlobalMemory.block table) := by
  apply block_frame
  · change 0<(C99FiniteMemory114.memory KeygenFullData127.heap).size (FftGlobalMemory.block table)
    rw [KeygenFullFacts127.sizes]
    cases table <;> decide
  · cases table <;> decide

theorem fft_pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment (reference ready).heap := by
  refine ⟨rfl,?_⟩
  intro table i bound
  have initial := KeygenFullFacts127.fft_pinned.2 table i bound
  have same := fft_frame table
  exact ⟨KeygenCallerShape123.load64_block _ _ _ _ same initial.1,same.2.1.trans initial.2⟩

theorem certificate_pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment
    (KeygenMakeWorkspaceRelocation.swap env.ctx.scratch.block (reference ready).heap) :=
  KeygenFftObjects127.pinned_swap (reference ready).heap 31 (by decide) (by decide) fft_pinned

end FT1536.Source3.SelectedFullStatics127
