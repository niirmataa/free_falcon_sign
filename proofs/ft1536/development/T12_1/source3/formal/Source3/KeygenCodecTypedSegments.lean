import Source3.KeygenCodecRefinement
import Source3.KeygenCodecSkeSurvival

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Execute the codecs at the concrete source caller's four segment sites.
   Open SmallSite heaps are replaced by actual fixed-body value execution,
   never by an assumed projection, frame, result or encoded length.
   Erasure to the old caller relation is one-way: its unrestricted heaps
   cannot imply that any C body executed. Full invocation replacement and
   public output still need their remaining source composition. -/
namespace FT1536.Source3.KeygenCodecTypedSegments
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env SmallSite byteOff assign)
open KeygenMakeSkeCells (SkeCellWord)

/-- The six actual argument values of falcon_encode_small at the pinned
    caller expression. comp comes from compCell/env.args.comp: the legacy
    SmallSite.comp field has no equality tying it to that read and must
    not be used as an evaluated argument. All other cells are read below. -/
def arguments (env : Env) (s : State) (i : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite env s i after ret) : KeygenCodecValues.Args :=
  ⟨some (byteOff env.args.privkey site.skoff.toNat),site.klen-site.skoff,
    env.args.comp,(if site.ter=0 then 12289 else 18433),some site.src,site.logn⟩

structure Site (env : Env) where
  index : Fin 4
  before : State
  after : Memory
  ret : BitVec 64
  site : SmallSite env before index after ret
  execution : KeygenCodecExecution.Call (arguments env before index after ret site) before.heap after ret

def projectedSite (c : Site env) : KeygenCodecSkeSurvival.Site env :=
  ⟨c.index,c.before,c.after,c.ret,c.site,
    KeygenCodecRefinement.call_projection _ _ _ _ c.execution
      (KeygenCodecSkeSurvival.destination env c.before c.index c.after c.ret c.site)
      (by intro p held; exact (Option.some.inj held).symm)⟩

def nextState (c : Site env) (skoff : BitVec 64) : State :=
  KeygenCodecSkeSurvival.nextState (projectedSite c) skoff

/-- Actual chronological four-segment statement execution with body calls
    carrying the observed returns, including capacity return0 after any
    partial writes. Local cursor/counter updates are exactly the old
    source caller's updates. The desired frame is absent from this type. -/
inductive Segments (env : Env) : Nat → State → Result → List (Site env) → Prop where
  | done (i : Nat) (s : State) (bound : 4 ≤ i)
      (counter : s.locals "i".toList=some (.int32,some (.int32 (BitVec.ofNat 32 i)))) :
      Segments env i s ⟨s,.normal⟩ []
  | capacity (c : Site env)
      (counter : c.before.locals "i".toList=some (.int32,some (.int32 (BitVec.ofNat 32 c.index.val))))
      (zero : c.ret=0) :
      Segments env c.index.val c.before ⟨{c.before with heap := c.after},.returned (some (.int32 0))⟩ [c]
  | next (c : Site env)
      (counter : c.before.locals "i".toList=some (.int32,some (.int32 (BitVec.ofNat 32 c.index.val))))
      (nonzero : c.ret≠0) (skoff : BitVec 64)
      (skoffCell : c.before.locals "skoff".toList=some (.uint64,some (.uint64 skoff)))
      (rest : Segments env (c.index.val+1) (nextState c skoff) out calls) :
      Segments env c.index.val c.before out (c::calls)

/-- Extract the previously missing body-bound projection from the typed
    caller execution, preserving every call boundary and observed return. -/
theorem projection (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : Segments env i s out calls) :
    KeygenCodecSkeSurvival.Segments env i s out (calls.map projectedSite) := by
  induction source with
  | done i s bound counter => exact .done i s bound counter
  | capacity c counter zero => exact .capacity (projectedSite c) counter zero
  | next c counter nonzero skoff skoffCell rest ih =>
    exact .next (projectedSite c) counter nonzero skoff skoffCell ih

theorem erase (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : Segments env i s out calls) : KeygenMakeInvocation.Segments env i s out :=
  KeygenCodecSkeSurvival.erase env i s out _ (projection env i s out calls source)

theorem chain_call_histories (env : Env) (s : State) (headOut out : Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (normal : headOut.flow=.normal)
    (source : Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (separate : env.args.privkey.block≠env.blocks 5) :
    ∀ c, c∈calls → SkeCellWord env c.index c.before := by
  have histories := KeygenCodecSkeSurvival.chain_call_histories env s headOut out
    (calls.map projectedSite) cells chain normal (projection env _ _ out calls source) separate
  intro c member
  exact histories (projectedSite c) (List.mem_map.mpr ⟨c,member,rfl⟩)

/-- Read the same input array at every actual segment boundary, from the
    concrete pre-loop stores and derived survival through earlier bodies.
    The finite virtual-map extension remains the pinned explicit legality
    domain; no codec write-frame is assumed. -/
theorem chain_call_material (env : Env) (s : State) (headOut out : Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (normal : headOut.flow=.normal)
    (source : Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (separate : env.args.privkey.block≠env.blocks 5)
    (legal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb) :
    ∀ c, c∈calls → c.site.src=KeygenMakeInvocation.inputOf env c.index := by
  have histories := chain_call_histories env s headOut out calls cells chain normal source separate
  intro c member
  exact KeygenMakeSkeCells.small_site_material_extended env c.before c.index c.after c.ret c.site
    (legal c member) (histories c member)

end FT1536.Source3.KeygenCodecTypedSegments
