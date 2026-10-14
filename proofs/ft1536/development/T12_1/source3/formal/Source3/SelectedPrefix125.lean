import Source3.KeygenMakePrefix125

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPrefix125
open C99CompactState115 (State reference)
open KeygenCallerData123 (env)

def result := KeygenMakePrefix125.run env SelectedInput124.seeded 128 64
theorem defined : result.isSome=true := by decide +kernel
def ready : State := result.get defined
theorem computed : KeygenMakePrefix125.run env SelectedInput124.seeded 128 64=some ready :=
  SelectedInput124.option_get result defined

theorem invocation : KeygenMakeArguments.PrefixInvocation env.args env.ctx
    (reference SelectedInput124.seeded) env.blocks [] ⟨reference ready,.normal⟩ :=
  KeygenMakePrefix125.run_sound env SelectedInput124.seeded ready 128 64 computed

theorem source : KeygenMakeReady.Prefix env.ctx
    (KeygenMakeArguments.entry (reference SelectedInput124.seeded) env.args) env.blocks [] ⟨reference ready,.normal⟩ :=
  (KeygenSeedPrefix092.invocation_iff env (reference SelectedInput124.seeded) (reference ready)).mp invocation

/-- Exact seed-to-make-prefix source chain. This stops before the capped
    search loop; it is not a complete successful KeyGen trace. -/
theorem seeded_prefix : KeygenSeedPrefix092.Source env KeygenCallerDomain123.input
    SelectedInput124.seed (reference ready) :=
  ⟨reference SelectedInput124.seeded,SelectedInput124.source,invocation⟩

end FT1536.Source3.SelectedPrefix125
