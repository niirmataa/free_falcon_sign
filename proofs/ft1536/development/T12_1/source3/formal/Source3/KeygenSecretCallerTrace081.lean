import Source3.KeygenSecretPrelude081
import Source3.KeygenPublicCallerExecution077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretCallerTrace081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env)
open KeygenPublicCallerSite077 (Site)
open KeygenPublicCallerExecution077 (Encoding Head)

def privateCode : List Stmt :=
  KeygenMakeSkeChain.chain++[KeygenMakeProgram.secretLoop,KeygenMakeInvocation.privkeyLenWrite]

theorem source_parts : KeygenMakeProgram.encoding=privateCode++KeygenPublicCallerExecution077.code := by
  rw [KeygenMakeInvocation.tail_source]
  rfl

theorem split_success (env : Env) (prelude rest : List Stmt) (s : State) (out : Result)
    (calls : List (Site env)) (source : Encoding env (prelude++rest) s out calls)
    (success : out.flow=.returned (some (.int32 1))) (noReturn : KeygenMakeInvocation.retOne∉prelude) :
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
      have shape := KeygenPublicCallerExecution077.head_success env stmt s out calls head success
      exact (noReturn (List.mem_cons.mpr (Or.inl shape.symm))).elim

theorem split_normal (env : Env) (prelude rest : List Stmt) (s : State) (out : Result)
    (calls : List (Site env)) (source : Encoding env (prelude++rest) s out calls) (normal : out.flow=.normal) :
    ∃ middle first later, Encoding env prelude s ⟨middle,.normal⟩ first ∧
      Encoding env rest middle out later ∧ calls=first++later := by
  induction prelude generalizing s calls with
  | nil => exact ⟨s,[],calls,.done s,source,rfl⟩
  | cons stmt prelude ih =>
    cases source with
    | step stmt ss s middle out first later head tail =>
      obtain ⟨last,early,late,pre,post,same⟩ := ih middle later tail
      refine ⟨last,first++early,late,.step stmt prelude s middle _ first early head pre,post,?_⟩
      rw [same,List.append_assoc]
    | exit stmt ss s out calls head flow => exact (flow normal).elim

theorem next_normal (env : Env) (stmt : Stmt) (rest : List Stmt) (s : State) (out : Result)
    (calls : List (Site env)) (source : Encoding env (stmt::rest) s out calls) (normal : out.flow=.normal) :
    ∃ middle first later, Head env stmt s ⟨middle,.normal⟩ first ∧
      Encoding env rest middle out later ∧ calls=first++later := by
  cases source with
  | step stmt ss s middle out first later head tail => exact ⟨middle,first,later,head,tail,rfl⟩
  | exit stmt ss s out calls head flow => exact (flow normal).elim

theorem no_public_calls (env : Env) (ss : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env ss s out calls) (absent : KeygenMakeProgram.publicDispatch∉ss) : calls=[] := by
  induction source with
  | done => rfl
  | step stmt rest s middle out first later head tail ih =>
    have firstEmpty : first=[] := by
      cases head with
      | other => rfl
      | invoke => exact (absent (List.mem_cons_self)).elim
    have laterEmpty := ih (fun member => absent (List.mem_cons_of_mem stmt member))
    simp only [firstEmpty,laterEmpty,List.nil_append]
  | exit stmt rest s out calls head flow =>
    cases head with
    | other => rfl
    | invoke => exact (absent (List.mem_cons_self)).elim

theorem legacy (env : Env) (ss : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env ss s out calls) : KeygenMakeInvocation.Encoding env ss s out := by
  obtain ⟨privateCalls,encoded⟩ := KeygenPublicCallerExecution077.erase env ss s out calls source
  exact KeygenCodecInvocation.encoding_erase env ss s out privateCalls encoded

theorem length_store (env : Env) (s t : State)
    (source : KeygenMakeInvocation.Head env KeygenMakeInvocation.privkeyLenWrite s ⟨t,.normal⟩) :
    ∃ skoff, s.locals "skoff".toList=some (.uint64,some (.uint64 skoff)) ∧
      Store64 s.heap env.args.privkeyLen skoff t.heap := by
  cases source with
  | storePrivkeyLen s skoff after cell store => exact ⟨skoff,cell,store⟩

/-- Extract the actual private prelude, four codec calls, length store and
    still-body-bound public suffix from one successful source tail. -/
theorem trace (env : Env) (s : State) (out : Result) (publicCalls : List (Site env))
    (source : Encoding env KeygenMakeProgram.encoding s out publicCalls)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ (headState segmentState suffixState : State) (privateCalls : List (KeygenCodecTypedSegments.Site env)) (skoff : BitVec 64),
      KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s ⟨headState,.normal⟩ ∧
      KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headState) ⟨segmentState,.normal⟩ privateCalls ∧
      segmentState.locals "skoff".toList=some (.uint64,some (.uint64 skoff)) ∧
      Store64 segmentState.heap env.args.privkeyLen skoff suffixState.heap ∧
      KeygenMakeInvocation.Head env KeygenMakeInvocation.privkeyLenWrite segmentState ⟨suffixState,.normal⟩ ∧
      KeygenMakeInvocation.Encoding env privateCode s ⟨suffixState,.normal⟩ ∧
      Encoding env KeygenPublicCallerExecution077.code suffixState out publicCalls := by
  rw [source_parts] at source
  obtain ⟨suffixState,early,later,privateRun,publicRun,same⟩ := split_success env privateCode _ s out publicCalls source success
    (by decide +kernel)
  have empty := no_public_calls env privateCode s ⟨suffixState,.normal⟩ early privateRun (by decide +kernel)
  subst early
  simp only [List.nil_append] at same
  subst publicCalls
  have privateLegacy := legacy env privateCode s ⟨suffixState,.normal⟩ [] privateRun
  obtain ⟨headState,pc0,pc1,prelude,segmentsRest,pcEq⟩ := split_normal env KeygenMakeSkeChain.chain _ s
    ⟨suffixState,.normal⟩ [] privateRun rfl
  obtain ⟨segmentState,pc2,pc3,secretHead,lengthRest,pcEq2⟩ := next_normal env KeygenMakeProgram.secretLoop _ headState
    ⟨suffixState,.normal⟩ pc1 segmentsRest rfl
  obtain ⟨afterLength,pc4,pc5,lengthHead,last,pcEq3⟩ := next_normal env KeygenMakeInvocation.privkeyLenWrite [] segmentState
    ⟨suffixState,.normal⟩ pc3 lengthRest rfl
  cases last
  obtain ⟨privateCalls,secret⟩ := KeygenPublicCallerExecution077.head_erase env KeygenMakeProgram.secretLoop headState
    ⟨segmentState,.normal⟩ pc2 secretHead
  have segments := KeygenCodecInvocation.secret_extract env _ _ _ privateCalls secret rfl
  obtain ⟨skoff,cell,store⟩ := length_store env segmentState suffixState
    (KeygenPublicCallerExecution077.head_legacy env _ _ _ pc4 lengthHead)
  exact ⟨headState,segmentState,suffixState,privateCalls,skoff,
    legacy env _ _ _ pc0 prelude,segments,cell,store,
    KeygenPublicCallerExecution077.head_legacy env _ _ _ pc4 lengthHead,privateLegacy,publicRun⟩

end FT1536.Source3.KeygenSecretCallerTrace081
