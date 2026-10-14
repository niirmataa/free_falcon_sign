import Source3.KeygenCertificateDomain104

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateCall104
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenCertificateSource080

/-- The call's observable state and truth bit are unique. The source
    interface intentionally does not fix an arbitrary truthy scalar Value. -/
theorem call_unique (ctx : Context) (before a b : State) (x y : Value) (r s : Bool)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratch : KeygenMkgm3Layout.Legal before.heap ctx.scratch)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (first : Call ctx before a x r) (second : Call ctx before b y s) : a = b ∧ r = s := by
  cases first with
  | run args1 cells1 base1 mem1 g1 e1 r source1 x bit1 =>
      cases second with
      | run args2 cells2 base2 mem2 g2 e2 s source2 y bit2 =>
          have sameArgs := KeygenCertificateDomain104.arguments ctx before args1 args2 cells1 cells2 base1 base2
          subst args2
          have hp := KeygenCertificateDomain104.profile ctx before args1 cells1 dimensions
          have hl := KeygenCertificateDomain104.frame ctx before {before with heap := mem1} args1
            shape scratch base1 g1 e1 r source1
          have same := KeygenCertificateFunction104.execution
            (KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args1) FftGlobalMemory.environment
            (KeygenMakeWorkspaceRelocation.swap ctx.scratch.block before.heap)
            (KeygenMakeWorkspaceRelocation.swap ctx.scratch.block mem1)
            (KeygenMakeWorkspaceRelocation.swap ctx.scratch.block mem2)
            g1 g2 e1 e2 r s hp hl source1.2 source2.2
          have heaps := congrArg (KeygenMakeWorkspaceRelocation.swap ctx.scratch.block) same.1
          rw [KeygenMakeWorkspaceRelocation.swap_swap, KeygenMakeWorkspaceRelocation.swap_swap] at heaps
          exact ⟨congrArg (fun heap => {before with heap := heap}) heaps, same.2.2.2⟩

theorem gate_unique (ctx : Context) (before : State) (a b : Result)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratch : KeygenMkgm3Layout.Legal before.heap ctx.scratch)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (first : Gate ctx before a) (second : Gate ctx before b) : a = b := by
  have profiled := KeygenMakeCertCall.profile_of_dimensions before dimensions
  cases first <;> cases second
  all_goals grind only [→ call_unique]

structure Input (ctx : Context) where
  before : State
  shape : KeygenMakeWorkspaceBridge.Shape ctx
  scratch : KeygenMkgm3Layout.Legal before.heap ctx.scratch
  dimensions : KeygenMakeSearchPrefix.Dimensions before

noncomputable def runCall (ctx : Context) (input : Input ctx) : Part (State × Bool) where
  Dom := ∃ result : State × Bool, ∃ v, Call ctx input.before result.1 v result.2
  get domain := Classical.choose domain

theorem runCall_spec (ctx : Context) (input : Input ctx) (out : State × Bool) :
    out ∈ runCall ctx input ↔ ∃ v, Call ctx input.before out.1 v out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    rw [← equal]
    exact Classical.choose_spec domain
  · rintro ⟨v, source⟩
    let domain : ∃ result : State × Bool, ∃ value, Call ctx input.before result.1 value result.2 := ⟨out, v, source⟩
    obtain ⟨value, actual⟩ := Classical.choose_spec domain
    have same := call_unique ctx input.before (Classical.choose domain).1 out.1 value v
      (Classical.choose domain).2 out.2 input.shape input.scratch input.dimensions actual source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenCertificateCall104
