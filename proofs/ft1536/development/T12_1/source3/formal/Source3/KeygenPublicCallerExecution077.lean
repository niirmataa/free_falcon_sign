import Source3.KeygenPublicCallerSite077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicCallerExecution077
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env)
open KeygenPublicCallerSite077 (Site nextState)

/-- Refinement of the existing caller: private calls remain body-bound,
    and the M0 public branch now requires its actual fixed-body execution. -/
inductive Head (env : Env) : Stmt → State → Result → List (Site env) → Prop where
  | other (stmt : Stmt) (s : State) (out : Result) (privateCalls : List (KeygenCodecTypedSegments.Site env))
      (different : stmt≠KeygenMakeProgram.publicDispatch)
      (source : KeygenCodecInvocation.Head env stmt s out privateCalls) : Head env stmt s out []
  | invoke (c : Site env) (ter : BitVec 32)
      (terCell : c.before.locals "ter".toList=some (.uint32,some (.uint32 ter))) (nonzero : ter≠0) :
      Head env KeygenMakeProgram.publicDispatch c.before ⟨nextState c,.normal⟩ [c]

theorem head_erase (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) : ∃ privateCalls, KeygenCodecInvocation.Head env stmt s out privateCalls := by
  cases source with
  | other stmt s out privateCalls different source => exact ⟨privateCalls,source⟩
  | invoke c ter cell nonzero =>
    exact ⟨[],.other _ _ _ (by decide +kernel) (.publicTernary c.before c.after c.ret ter cell nonzero c.site)⟩

theorem head_legacy (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) : KeygenMakeInvocation.Head env stmt s out := by
  obtain ⟨privateCalls,erased⟩ := head_erase env stmt s out calls source
  exact KeygenCodecInvocation.head_erase env stmt s out privateCalls erased

inductive Encoding (env : Env) : List Stmt → State → Result → List (Site env) → Prop where
  | done (s : State) : Encoding env [] s ⟨s,.normal⟩ []
  | step (stmt : Stmt) (rest : List Stmt) (s middle : State) (out : Result) (first later : List (Site env))
      (head : Head env stmt s ⟨middle,.normal⟩ first) (tail : Encoding env rest middle out later) :
      Encoding env (stmt::rest) s out (first++later)
  | exit (stmt : Stmt) (rest : List Stmt) (s : State) (out : Result) (calls : List (Site env))
      (head : Head env stmt s out calls) (flow : out.flow≠.normal) : Encoding env (stmt::rest) s out calls

theorem erase (env : Env) (ss : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env ss s out calls) : ∃ privateCalls, KeygenCodecInvocation.Encoding env ss s out privateCalls := by
  induction source with
  | done s => exact ⟨[],.done s⟩
  | step stmt rest s middle out first later head tail ih =>
    obtain ⟨early,one⟩ := head_erase env stmt s _ first head
    obtain ⟨late,two⟩ := ih
    exact ⟨early++late,.step stmt rest s middle out early late one two⟩
  | exit stmt rest s out calls head flow =>
    obtain ⟨privateCalls,erased⟩ := head_erase env stmt s out calls head
    exact ⟨privateCalls,.exit stmt rest s out privateCalls erased flow⟩

theorem head_success (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) (success : out.flow=.returned (some (.int32 1))) :
    stmt=KeygenMakeInvocation.retOne := by
  have old := head_legacy env stmt s out calls source
  cases old <;> simp_all

theorem next (env : Env) (stmt : Stmt) (rest : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env (stmt::rest) s out calls) (success : out.flow=.returned (some (.int32 1)))
    (notReturn : stmt≠KeygenMakeInvocation.retOne) :
    ∃ middle first later, Head env stmt s ⟨middle,.normal⟩ first ∧ Encoding env rest middle out later ∧ calls=first++later := by
  cases source with
  | step stmt rest s middle out first later head tail => exact ⟨middle,first,later,head,tail,rfl⟩
  | exit stmt rest s out calls head flow => exact (notReturn (head_success env stmt s out calls head success)).elim

theorem plain (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) (different : stmt≠KeygenMakeProgram.publicDispatch) :
    calls=[] ∧ KeygenMakeInvocation.Head env stmt s out := by
  refine ⟨?_,head_legacy env stmt s out calls source⟩
  cases source with
  | other => rfl
  | invoke => exact (different rfl).elim

theorem public_extract (env : Env) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env KeygenMakeProgram.publicDispatch s out calls) :
    ∃ c : Site env, c.before=s ∧ out=⟨nextState c,.normal⟩ ∧ calls=[c] := by
  cases source with
  | other stmt s out privateCalls different source => exact (different rfl).elim
  | invoke c ter cell nonzero => exact ⟨c,rfl,rfl,rfl⟩

def code : List Stmt := [KeygenMakeInvocation.pubkeyLenRead,KeygenMakeProgram.capacityReturn,
  KeygenMakeInvocation.pkHeader,KeygenMakeProgram.publicDispatch,KeygenMakeInvocation.zeroCapacity,
  KeygenMakeInvocation.pubkeyLenWrite,KeygenMakeInvocation.retOne]
theorem source_suffix : KeygenMakeProgram.encoding.drop 11=code := by
  rw [KeygenMakeInvocation.tail_source]
  rfl

theorem return_final (env : Env) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env [KeygenMakeInvocation.retOne] s out calls) :
    out=⟨s,.returned (some (.int32 1))⟩ ∧ calls=[] := by
  cases source with
  | step stmt rest s middle out first later head tail =>
    have old := head_legacy env _ _ _ _ head
    cases old
  | exit stmt rest s out calls head flow =>
    obtain ⟨empty,old⟩ := plain env _ _ _ _ head (by decide +kernel)
    cases old
    exact ⟨rfl,empty⟩

end FT1536.Source3.KeygenPublicCallerExecution077
