import Source3.KeygenHelperStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchStability
open KeygenMemoryStability
open KeygenHelperStability (compose)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem deepest (ctx : Context) (code : KeygenDeepestSource.Stmt) (before : State) (out : Result)
    (source : KeygenDeepestSource.Exec ctx code before out) : Stable before.heap out.state.heap := by
  induction source
  case base code before out source => exact KeygenHelperStability.make _ _ _ source
  case make before entry out word binding read source returned =>
    have result := KeygenHelperStability.make _ _ _ source
    change Stable entry.heap out.state.heap at result
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
    exact result
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem small_to_fp (before after : State) (args : List C99ArrayReference.Arg)
    (source : KeygenSearchLeaves.SmallCall before args after) : Stable before.heap after.heap := by
  cases source with
  | run entry out binding body returned =>
    have result := procedure _ _ _ _ body
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
    exact result
theorem search (ctx : Context) (code : KeygenSearchExec.Stmt) (before : State) (out : Result)
    (source : KeygenSearchExec.Exec ctx code before out) : Stable before.heap out.state.heap := by
  induction source
  case procedure code before out source => exact procedure _ _ _ _ source
  case store32 dst index e before after p v address value write => exact store32 _ _ _ _ write
  case store64 dst index e before after p v address value write => exact store64 _ _ _ _ write
  case move dst src count before after p q word destination source length copy => exact move _ _ _ _ _ copy
  case small args before after source => exact small_to_fp _ _ _ source
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem intermediate_body (kind : KeygenIntermediateCalls.Kind) (before : State) (out : Result)
    (source : KeygenIntermediateCalls.Body kind before out) : Stable before.heap out.state.heap := by
  cases source with
  | zint kind before out source => exact zint _ _ _ source
  | make before out source => exact KeygenHelperStability.make _ _ _ source
  | poly kind before out source => exact KeygenHelperStability.poly _ _ _ source
  | subNtt before out source => exact KeygenHelperStability.sub_ntt _ _ _ source
  | subQuadratic before after source => exact KeygenHelperStability.quadratic _ _ _ source
  | binaryNtt kind before out source => exact KeygenHelperStability.binary _ _ _ source
  | ternaryNtt kind before out source => exact modular _ _ _ source
  | binaryFft kind before out p binding source => exact procedure _ _ _ _ source
  | ternaryFft kind before out p binding source => exact procedure _ _ _ _ source
theorem intermediate_call (ctx : Context) (kind : KeygenIntermediateCalls.Kind) (before after : State)
    (args : List KeygenIntermediateCalls.Arg) (v : Option C99IntegerReference.Value)
    (source : KeygenIntermediateCalls.Call ctx kind before args after v) : Stable before.heap after.heap := by
  cases source with
  | run entry out v binding execution returned =>
    have result := intermediate_body _ _ _ execution
    rw [KeygenIntermediateCalls.bind_heap _ _ _ _ _ binding] at result
    exact result
theorem intermediate (ctx : Context) (code : KeygenIntermediateExec.Stmt) (before : State) (out : Result)
    (source : KeygenIntermediateExec.Exec ctx code before out) : Stable before.heap out.state.heap := by
  induction source
  case store name index e before after p v address value write => exact store32 _ _ _ _ write
  case move dst src count before after p q word destination source length copy => exact move _ _ _ _ _ copy
  case call kind args dst before middle after v source rec =>
    exact compose _ _ _ (intermediate_call _ _ _ _ _ _ source) (receive _ _ _ _ rec)
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem root_call (ctx : Context) (kind : KeygenRootSearch.Kind) (before after : State) (v : C99IntegerReference.Value)
    (source : KeygenRootSearch.Call ctx kind before after v) : Stable before.heap after.heap := by
  cases kind with
  | deepest =>
    cases source with
    | run entry out v binding execution returned =>
      have result := deepest _ _ _ _ execution
      rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
      exact result
  | intermediate =>
    cases source with
    | run entry out v binding execution returned =>
      have result := intermediate _ _ _ _ execution
      rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
      exact result
  | depth0 =>
    cases source with
    | run entry out v binding execution returned =>
      have result := search _ _ _ _ execution
      rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
      exact result
theorem gate (ctx : Context) (kind : KeygenRootSearch.Kind) (before : State) (out : Result)
    (source : KeygenRootSearch.Gate ctx kind before out) : Stable before.heap out.state.heap := by
  cases source with
  | accept after v source nonzero | reject after v source zero => exact root_call _ _ _ _ _ source
theorem loop (ctx : Context) (before : State) (out : Result) (source : KeygenRootSearch.Loop ctx before out) :
    Stable before.heap out.state.heap := by
  induction source with
  | done before next v test zero => rw [(KeygenRootSearch.post_frame _ _ _ test).1]; exact refl _
  | step before next middle out v test nonzero body rest ih =>
    have first := gate _ _ _ _ body
    rw [(KeygenRootSearch.post_frame _ _ _ test).1] at first
    exact compose _ _ _ first ih
  | reject before next after v test nonzero body =>
    have first := gate _ _ _ _ body
    rw [(KeygenRootSearch.post_frame _ _ _ test).1] at first
    exact first
theorem dispatch (ctx : Context) (before : State) (out : Result) (source : KeygenRootSearch.Dispatch ctx before out) :
    Stable before.heap out.state.heap := by
  cases source with
  | run test logn ternary out small large read member isTernary source =>
    cases source with
    | reject after source =>
      have result := loop _ _ _ source
      exact result
    | last middle out source depth0 =>
      have first := loop _ _ _ source
      have last := gate _ _ _ _ depth0
      exact compose _ _ _ first last
theorem root (ctx : Context) (before : State) (out : Result) (source : KeygenRootSearch.Exec ctx before out) :
    Stable before.heap out.state.heap := by
  cases source with
  | deepestRejected ready after start deepest =>
    have first := gate _ _ _ _ deepest
    cases start
    exact first
  | searched ready deep out start deepest rest =>
    have first := gate _ _ _ _ deepest
    have last := dispatch _ _ _ rest
    cases start
    exact compose _ _ _ first last

end FT1536.Source3.KeygenSearchStability
