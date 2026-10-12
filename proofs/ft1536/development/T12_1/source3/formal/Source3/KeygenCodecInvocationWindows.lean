import Source3.KeygenCodecInvocation
import Source3.KeygenCodecStaticDispatch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecInvocationWindows
open KeygenMakeInvocation (Env)
open KeygenCodecTypedSegments (Site arguments)

/-- The actual STATIC dispatcher at a caller site supplies its complete
    capacity window, including rejection/partial-write paths. Capacity is
    the evaluated caller subtraction at this site; no final length or
    aggregate output-buffer bound is inferred from it. -/
theorem site_window (env : Env) (c : Site env) (comp : env.args.comp=1) :
    KeygenCodecGuardedWrite.Window
      (KeygenCodecSkeSurvival.destination env c.before c.index c.after c.ret c.site)
      (arguments env c.before c.index c.after c.ret c.site).capacity.toNat c.before.heap c.after := by
  exact KeygenCodecStaticDispatch.dispatch_window _ _ _ c.ret _ rfl comp c.execution

theorem invocation_windows (env : Env) (caller : C99ArrayReference.State)
    (events : List KeygenEntropySource.Event) (out : C99ProcedureReference.Result)
    (calls : List (Site env)) (source : KeygenCodecInvocation.Invocation env caller events out calls)
    (success : out.flow=.returned (some (.int32 1))) (comp : env.args.comp=1)
    (separate : env.args.privkey.block≠env.blocks 5)
    (legal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb) :
    calls.length=4 ∧ KeygenCodecInvocation.Consecutive 0 calls ∧
    ∀ c, c∈calls →
      c.site.src=KeygenMakeInvocation.inputOf env c.index ∧
      (arguments env c.before c.index c.after c.ret c.site).q=18433 ∧
      (arguments env c.before c.index c.after c.ret c.site).logn=10 ∧
      KeygenCodecGuardedWrite.Window
        (KeygenCodecSkeSurvival.destination env c.before c.index c.after c.ret c.site)
        (arguments env c.before c.index c.after c.ret c.site).capacity.toNat c.before.heap c.after := by
  have count := KeygenCodecInvocation.invocation_four_calls env caller events out calls source success
  have facts := KeygenCodecInvocation.invocation_calls env caller events out calls source success separate legal
  refine ⟨count.1,count.2,fun c member => ?_⟩
  exact ⟨(facts c member).1,(facts c member).2.1,(facts c member).2.2,site_window env c comp⟩

end FT1536.Source3.KeygenCodecInvocationWindows
