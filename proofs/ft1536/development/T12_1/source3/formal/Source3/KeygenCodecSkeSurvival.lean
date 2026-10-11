import Source3.KeygenCodecFootprint
import Source3.KeygenMakeSkeChain

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Cell-word survival for independently BODY-PROJECTED codec traces.
   The original caller's SmallSite has an unrestricted after heap; it is
   not silently upgraded here. Traces below add independent executions of
   the fixed source memory-effect projection, never an outcome/length/frame
   assertion. Full typed C-to-projection refinement remains OPEN, so this
   does not close B1.07 Acceptance or source codec value correctness. -/
namespace FT1536.Source3.KeygenCodecSkeSurvival
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env SmallSite skeElem inputOf wordOf assign byteOff)
open KeygenMakeSkeCells (SkeCellWord)

/-- The destination uses the actual call-site cursor. No capacity or
    successful encoded length is supplied to the frame proof. -/
def destination (env : Env) (s : State) (i : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite env s i after ret) : ArrayPointer := byteOff env.args.privkey site.skoff.toNat

def BodyRun (env : Env) (s : State) (i : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite env s i after ret) : Prop :=
  KeygenCodecFootprint.Run (destination env s i after ret site) s.heap after

/-- Non-aliasing follows from the existing executed allocation freshness
    and a live external destination; no codec-frame premise is involved. -/
theorem separate_of_allocation (env : Env) (before after : State)
    (allocation : KeygenMakeObjects.Exec 0 before env.blocks after)
    (live : 0<before.heap.size env.args.privkey.block) :
    env.args.privkey.block≠env.blocks 5 :=
  KeygenMakeObjects.fresh_separate 0 before after env.blocks allocation 5 (by omega)
    env.args.privkey.block live

/-- EVERY cell survives ANY projected codec return edge, including partial
    output writes. The destination block follows the executed buf=out. -/
theorem word_after_call (env : Env) (s : State) (i j : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite env s i after ret) (body : BodyRun env s i after ret site)
    (separate : env.args.privkey.block≠env.blocks 5) (word : SkeCellWord env j s) :
    SkeCellWord env j {s with heap := after} := by
  apply KeygenCodecFootprint.load64_frame (destination env s i after ret site)
    (skeElem env j) s.heap after (wordOf env.vb (inputOf env j)) body
  · simpa [destination,byteOff,KeygenMakeInvocation.skeElem,KeygenMakeInvocation.skePtr,
      KeygenMakeObjects.pointer] using Ne.symm separate
  · exact word

structure Site (env : Env) where
  index : Fin 4
  before : State
  after : Memory
  ret : BitVec 64
  site : SmallSite env before index after ret
  body : BodyRun env before index after ret site

def nextState (c : Site env) (skoff : BitVec 64) : State :=
  assign (assign {c.before with heap := c.after} "skoff".toList .uint64 (.uint64 (skoff+c.ret)))
    "i".toList .int32 (.int32 (BitVec.ofNat 32 (c.index.val+1)))

/-- The source segment chronology with independent fixed-body effect
    executions attached to its concrete calls. Observed zero/nonzero
    branch guards belong to the trace, not a codec success hypothesis. -/
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

theorem erase (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : Segments env i s out calls) : KeygenMakeInvocation.Segments env i s out := by
  induction source with
  | done i s bound counter => exact .done i s bound counter
  | capacity c counter zero => exact .capacity c.index.val c.before c.after c.index.isLt c.ret counter c.site zero
  | next c counter nonzero skoff skoffCell rest ih =>
    exact .next c.index.val c.before c.after c.index.isLt c.ret counter c.site nonzero skoff skoffCell ih

/-- Actual call-boundary histories for ALL segments, in particular 1–3,
    obtained by folding the body-derived frame over earlier codec calls. -/
theorem call_histories (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : Segments env i s out calls)
    (separate : env.args.privkey.block≠env.blocks 5)
    (words : ∀ j : Fin 4, SkeCellWord env j s) :
    ∀ c, c∈calls → SkeCellWord env c.index c.before := by
  induction source with
  | done i s bound counter => intro c member; cases member
  | capacity c counter zero =>
    intro d member
    have same : d=c := by simpa only [List.mem_singleton] using member
    subst d
    exact words c.index
  | next c counter nonzero skoff skoffCell rest ih =>
    have later : ∀ j : Fin 4, SkeCellWord env j (nextState c skoff) := by
      intro j
      exact word_after_call env c.before c.index j c.after c.ret c.site c.body separate (words j)
    intro d member
    rcases List.mem_cons.mp member with same | tail
    · subst d; exact words c.index
    · exact ih later d tail

/-- Consume 063's concrete nine-statement extraction at the loop entry;
    do not assume the four cell words at that boundary. -/
theorem chain_call_histories (env : Env) (s : State) (headOut out : Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (normal : headOut.flow=.normal)
    (source : Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (separate : env.args.privkey.block≠env.blocks 5) :
    ∀ c, c∈calls → SkeCellWord env c.index c.before :=
  call_histories env 0 _ out calls source separate
    (KeygenMakeSkeChain.chain_words_at_loop env s headOut cells chain normal)

end FT1536.Source3.KeygenCodecSkeSurvival
