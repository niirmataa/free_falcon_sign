import Source3.KeygenCodecProfile

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The secret-loop seam of the enclosing statement machine is replaced by
   actual typed codec executions. Other heads retain the existing source
   rules; in particular the public-codec seam remains open. Erasure is
   one-way and does not assert that unrestricted old heaps executed C. -/
namespace FT1536.Source3.KeygenCodecInvocation
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env TailCells)
open KeygenCodecTypedSegments (Site)

theorem segment_flow (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : KeygenCodecTypedSegments.Segments env i s out calls) :
    out.flow=.normal ∨ out.flow=.returned (some (.int32 0)) := by
  induction source with
  | done => exact Or.inl rfl
  | capacity => exact Or.inr rfl
  | next c counter nonzero skoff skoffCell rest ih => exact ih

def Consecutive (i : Nat) : List (Site env) → Prop
  | [] => True
  | c::rest => c.index.val=i ∧ Consecutive (i+1) rest

theorem segment_order (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : KeygenCodecTypedSegments.Segments env i s out calls) : Consecutive i calls := by
  induction source with
  | done => trivial
  | capacity => exact ⟨rfl,trivial⟩
  | next c counter nonzero skoff skoffCell rest ih => exact ⟨rfl,ih⟩

theorem segment_count (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : KeygenCodecTypedSegments.Segments env i s out calls)
    (normal : out.flow=.normal) (bound : i≤4) : calls.length+i=4 := by
  induction source with
  | done i s lower counter => simp only [List.length_nil]; omega
  | capacity c counter zero => cases normal
  | next c counter nonzero skoff skoffCell rest ih =>
    have count := ih normal (by have := c.index.isLt; omega)
    simp only [List.length_cons]
    omega

inductive Head (env : Env) : Stmt → State → Result → List (Site env) → Prop where
  | other (stmt : Stmt) (s : State) (out : Result)
      (different : stmt≠KeygenMakeProgram.secretLoop)
      (source : KeygenMakeInvocation.Head env stmt s out) : Head env stmt s out []
  | secret (s : State) (out : Result) (calls : List (Site env))
      (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter s) out calls) :
      Head env KeygenMakeProgram.secretLoop s out calls

theorem head_erase (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) : KeygenMakeInvocation.Head env stmt s out := by
  cases source with
  | other stmt s out different source => exact source
  | secret s out calls source =>
    have erased := KeygenCodecTypedSegments.erase env 0 _ out calls source
    rcases segment_flow env 0 _ out calls source with normal | returned
    · cases out with | mk state flow =>
        change flow = .normal at normal
        subst flow
        exact .segmentsNormal s ⟨state,.normal⟩ erased rfl
    · cases out with | mk state flow =>
        change flow = .returned (some (.int32 0)) at returned
        subst flow
        exact .segmentsReturn s ⟨state,.returned (some (.int32 0))⟩ erased rfl

inductive Encoding (env : Env) : List Stmt → State → Result → List (Site env) → Prop where
  | done (s : State) : Encoding env [] s ⟨s,.normal⟩ []
  | step (stmt : Stmt) (rest : List Stmt) (s middle : State) (out : Result)
      (first later : List (Site env))
      (head : Head env stmt s ⟨middle,.normal⟩ first)
      (tail : Encoding env rest middle out later) : Encoding env (stmt::rest) s out (first++later)
  | exit (stmt : Stmt) (rest : List Stmt) (s : State) (out : Result) (calls : List (Site env))
      (head : Head env stmt s out calls) (flow : out.flow≠.normal) : Encoding env (stmt::rest) s out calls

theorem encoding_erase (env : Env) (ss : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env ss s out calls) : KeygenMakeInvocation.Encoding env ss s out := by
  induction source with
  | done s => exact .done s
  | step stmt rest s middle out first later head tail ih =>
    exact .step stmt rest s middle out (head_erase env stmt s _ first head) ih
  | exit stmt rest s out calls head flow => exact .exit stmt rest s out (head_erase env stmt s out calls head) flow

/-- No unrestricted legacy secret-loop edge can bypass typed execution. -/
theorem secret_extract (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) (shape : stmt=KeygenMakeProgram.secretLoop) :
    KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter s) out calls := by
  cases source with
  | other stmt s out different source => exact (different shape).elim
  | secret s out calls source => exact source

theorem head_success (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) (success : out.flow=.returned (some (.int32 1))) :
    stmt=KeygenMakeInvocation.retOne := by
  have old := head_erase env stmt s out calls source
  cases old <;> simp_all

theorem split_success (env : Env) (prelude rest : List Stmt) (s : State) (out : Result)
    (calls : List (Site env)) (source : Encoding env (prelude++rest) s out calls)
    (success : out.flow=.returned (some (.int32 1)))
    (noReturn : KeygenMakeInvocation.retOne∉prelude) :
    ∃ middle first later, Encoding env prelude s ⟨middle,.normal⟩ first ∧
      Encoding env rest middle out later ∧ calls=first++later := by
  induction prelude generalizing s calls with
  | nil => exact ⟨s,[],calls,.done s,source,rfl⟩
  | cons stmt prelude ih =>
    cases source with
    | step stmt ss s middle out first later head tail =>
      obtain ⟨last,early,late,pre,post,same⟩ := ih middle later tail
        (fun member => noReturn (List.mem_cons_of_mem stmt member))
      refine ⟨last,first++early,late,.step stmt prelude s middle _ first early head pre,post,?_⟩
      rw [same,List.append_assoc]
    | exit stmt ss s out calls head flow =>
      have shape := head_success env stmt s out calls head success
      exact (noReturn (List.mem_cons.mpr (Or.inl shape.symm))).elim

theorem no_secret_calls (env : Env) (ss : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env ss s out calls) (absent : KeygenMakeProgram.secretLoop∉ss) : calls=[] := by
  induction source with
  | done => rfl
  | step stmt rest s middle out first later head tail ih =>
    have firstEmpty : first=[] := by
      cases head with
      | other => rfl
      | secret => exact (absent (List.mem_cons_self)).elim
    have laterEmpty := ih (fun member => absent (List.mem_cons_of_mem stmt member))
    simp only [firstEmpty,laterEmpty,List.nil_append]
  | exit stmt rest s out calls head flow =>
    cases head with
    | other => rfl
    | secret => exact (absent (List.mem_cons_self)).elim

def afterSecret : List Stmt := KeygenMakeProgram.encoding.drop 10

theorem tail_source : KeygenMakeProgram.encoding=
    KeygenMakeSkeChain.chain++(KeygenMakeProgram.secretLoop::afterSecret) := by
  rw [KeygenMakeInvocation.tail_source]
  rfl

/-- On return1 the enclosing tail contains the nine executed prelude
    statements and the same typed segment run. Later public statements
    cannot fabricate another secret trace. -/
theorem tail_trace (env : Env) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env KeygenMakeProgram.encoding s out calls)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ middle final, KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s ⟨middle,.normal⟩ ∧
      KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter middle) ⟨final,.normal⟩ calls := by
  rw [tail_source] at source
  obtain ⟨middle,first,later,pre,post,same⟩ := split_success env _ _ s out calls source success (by decide +kernel)
  have empty := no_secret_calls env _ s _ first pre (by decide +kernel)
  subst first
  simp only [List.nil_append] at same
  subst calls
  cases post with
  | step stmt rest s final out early late head tail =>
    have empty := no_secret_calls env afterSecret final out late tail (by decide +kernel)
    subst late
    simp only [List.append_nil]
    exact ⟨middle,final,encoding_erase env _ _ _ _ pre,secret_extract env _ _ _ early head rfl⟩
  | exit stmt rest s out calls head flow =>
    have shape := head_success env _ _ _ _ head success
    exact (by decide : KeygenMakeProgram.secretLoop≠KeygenMakeInvocation.retOne) shape |>.elim

inductive Invocation (env : Env) (caller : State) : List KeygenEntropySource.Event → Result → List (Site env) → Prop where
  | encoded (events : List KeygenEntropySource.Event) (bound after : State)
      (loopOut tailOut : Result) (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
      (calls : List (Site env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
      (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
      (succeeded : loopOut.flow=.normal) (cells : TailCells env loopOut.state)
      (legal : KeygenMakeInvocation.VirtualLegal env.live env.vb)
      (tail : Encoding env KeygenMakeProgram.encoding loopOut.state tailOut calls) :
      Invocation env caller events (KeygenMakeLifetime.close bound env.blocks tailOut) calls
  | capped (events : List KeygenEntropySource.Event) (bound after : State)
      (loopOut : Result) (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
      (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
      (aborted : loopOut.flow=KeygenCapExecution.abortFlow) :
      Invocation env caller events (KeygenMakeLifetime.close bound env.blocks loopOut) []

theorem invocation_erase (env : Env) (caller : State) (events : List KeygenEntropySource.Event)
    (out : Result) (calls : List (Site env)) (source : Invocation env caller events out calls) :
    KeygenMakeInvocation.Invocation env caller events out := by
  cases source with
  | encoded bound after loopOut tailOut attempts calls binding ready loop succeeded cells legal tail =>
    exact .encoded events bound after loopOut attempts tailOut binding ready loop succeeded cells legal
      (encoding_erase env _ _ _ calls tail)
  | capped bound after loopOut attempts binding ready loop aborted =>
    exact .capped events bound after loopOut attempts binding ready loop aborted

theorem invocation_trace (env : Env) (caller : State) (events : List KeygenEntropySource.Event)
    (out : Result) (calls : List (Site env)) (source : Invocation env caller events out calls)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ entry middle final, TailCells env entry ∧
      KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain entry ⟨middle,.normal⟩ ∧
      KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter middle) ⟨final,.normal⟩ calls ∧
      KeygenCodecSkeSurvival.Segments env 0 (KeygenMakeInvocation.initCounter middle) ⟨final,.normal⟩
        (calls.map KeygenCodecTypedSegments.projectedSite) := by
  cases source with
  | capped bound after loopOut attempts binding ready loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted] at success
    cases success
  | encoded bound after loopOut tailOut attempts calls binding ready loop succeeded cells legal tail =>
    rw [KeygenMakeLifetime.close_flow] at success
    obtain ⟨middle,final,pre,segments⟩ := tail_trace env _ tailOut calls tail success
    exact ⟨loopOut.state,middle,final,cells,pre,segments,
      KeygenCodecTypedSegments.projection env 0 _ _ calls segments⟩

/-- Whole invocation to the same-heap projected trace, source pointers
    and derived q/logn profile at every secret call. No codec outcome,
    length or write frame is supplied. Public codecs remain the old seam. -/
theorem invocation_calls (env : Env) (caller : State) (events : List KeygenEntropySource.Event)
    (out : Result) (calls : List (Site env)) (source : Invocation env caller events out calls)
    (success : out.flow=.returned (some (.int32 1)))
    (separate : env.args.privkey.block≠env.blocks 5)
    (legal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb) :
    ∀ c, c∈calls →
      c.site.src=KeygenMakeInvocation.inputOf env c.index ∧
      (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).q=18433 ∧
      (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).logn=10 := by
  obtain ⟨entry,middle,final,cells,pre,segments,projection⟩ :=
    invocation_trace env caller events out calls source success
  have material := KeygenCodecTypedSegments.chain_call_material env entry ⟨middle,.normal⟩ ⟨final,.normal⟩
    calls cells pre rfl segments separate legal
  have profiles := KeygenCodecProfile.chain_profiles env entry ⟨middle,.normal⟩ ⟨final,.normal⟩ calls cells pre segments
  intro c member
  exact ⟨material c member,KeygenCodecProfile.arguments_profile env c (profiles c member)⟩

theorem invocation_four_calls (env : Env) (caller : State) (events : List KeygenEntropySource.Event)
    (out : Result) (calls : List (Site env)) (source : Invocation env caller events out calls)
    (success : out.flow=.returned (some (.int32 1))) :
    calls.length=4 ∧ Consecutive 0 calls := by
  obtain ⟨entry,middle,final,cells,pre,segments,projection⟩ :=
    invocation_trace env caller events out calls source success
  exact ⟨by simpa using segment_count env 0 _ _ calls segments rfl (by omega),
    segment_order env 0 _ _ calls segments⟩

end FT1536.Source3.KeygenCodecInvocation
