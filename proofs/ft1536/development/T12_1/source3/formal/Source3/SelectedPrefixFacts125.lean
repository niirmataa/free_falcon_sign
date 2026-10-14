import Source3.SelectedPrefix125

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPrefixFacts125
open C99CompactState115 (reference)
open KeygenCallerData123 (env)
open SelectedPrefix125 (ready source)

theorem entry_facts : KeygenCapWords.Count (reference ready) 0 ∧
    KeygenCallerEntry.Initial env.ctx (reference ready) (KeygenMakeEntry.input env.blocks)
      (KeygenMakeEntry.publicPointer env.blocks) SelectedInput124.domain.primes SelectedInput124.domain.rev ∧
    KeygenReadyResult.flagPresent env.ctx (reference ready).heap .seeded ∧
    KeygenReadyResult.flagPresent env.ctx (reference ready).heap .flipped :=
  KeygenMakeReady.normal_prefix env.ctx _ _ env.blocks SelectedInput124.domain.primes SelectedInput124.domain.rev
    SelectedInput124.domain.rootLegal.original [] source

theorem locals_shape : (reference ready).locals=
    (KeygenMakePrologue.ready (KeygenMakeArguments.entry (reference SelectedInput124.seeded) env.args) env.blocks).locals :=
  KeygenMakeReady.normal_prefix_locals env.ctx _ _ env.blocks SelectedInput124.domain.primes SelectedInput124.domain.rev
    SelectedInput124.domain.rootLegal.original [] source

theorem dimension : (reference ready).locals "n".toList=some (.uint64,some (.uint64 1536)) := by
  rw [locals_shape]
  rfl

/-- The real enclosing prefix reaches the pinned first-sampler RNG image.
    This equality is a checked conclusion, not a source execution premise. -/
theorem rng_image : ∀ i : Fin 416, (reference ready).heap.bytes 1 (8+i.val)=
    some (GeneratedSeed119Fixture.flippedBytes[i.val]!) := by decide +kernel

end FT1536.Source3.SelectedPrefixFacts125
