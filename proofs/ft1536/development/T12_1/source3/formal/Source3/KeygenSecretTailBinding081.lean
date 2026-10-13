import Source3.KeygenSecretTailSource081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretTailBinding081
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env)
open KeygenPublicCallerSite077 (Site)
open KeygenPublicCallerExecution077 (Head Encoding)
open KeygenSecretTailSource081 (Source)

theorem prelude_head (env : Env) (stmt : Stmt) (s : State) (out : Result)
    (source : KeygenMakeInvocation.Head env stmt s out) (member : stmt∈KeygenMakeSkeChain.chain) :
    Head env stmt s out [] := by
  have noSecret : stmt≠KeygenMakeProgram.secretLoop := by
    intro equal; subst stmt
    exact (by decide +kernel : KeygenMakeProgram.secretLoop∉KeygenMakeSkeChain.chain) member
  have noPublic : stmt≠KeygenMakeProgram.publicDispatch := by
    intro equal; subst stmt
    exact (by decide +kernel : KeygenMakeProgram.publicDispatch∉KeygenMakeSkeChain.chain) member
  exact .other stmt s out [] noPublic (.other stmt s out noSecret source)

theorem prelude_encoding (env : Env) (ss : List Stmt) (s : State) (out : Result)
    (source : KeygenMakeInvocation.Encoding env ss s out) (subset : ∀ stmt∈ss, stmt∈KeygenMakeSkeChain.chain) :
    Encoding env ss s out [] := by
  induction source with
  | done s => exact .done s
  | step stmt rest s middle out head tail ih =>
    exact .step stmt rest s middle out [] [] (prelude_head env stmt s _ head (subset stmt (List.mem_cons_self)))
      (ih (fun stmt member => subset stmt (List.mem_cons_of_mem _ member)))
  | exit stmt rest s out head flow =>
    exact .exit stmt rest s out [] (prelude_head env stmt s out head (subset stmt (List.mem_cons_self))) flow

theorem append (env : Env) (ss : List Stmt) (s : State) (middle : Result) (firstCalls : List (Site env))
    (first : Encoding env ss s middle firstCalls) :
    ∀ rest out laterCalls, Encoding env rest middle.state out laterCalls → middle.flow=.normal →
      Encoding env (ss++rest) s out (firstCalls++laterCalls) := by
  induction first with
  | done s => intro rest out laterCalls tail normal; exact tail
  | step stmt ss s middle firstOut early late head tail ih =>
    intro rest out laterCalls last normal
    have source := Encoding.step stmt (ss++rest) s middle out early (late++laterCalls) head
      (ih rest out laterCalls last normal)
    simpa only [List.append_assoc,List.cons_append] using source
  | exit stmt rest s out calls head flow =>
    intro suffix result laterCalls tail normal
    exact (flow normal).elim

/-- The decomposed source really executes the pinned18-statement tail with
    actual private/public bodies. This is a source binding, not a postcondition. -/
theorem to_encoding (env : Env) (s : State) (out : Result) (source : Source env s out) :
    Encoding env KeygenMakeProgram.encoding s out source.publicCalls := by
  have prelude := prelude_encoding env KeygenMakeSkeChain.chain s ⟨source.headState,.normal⟩ source.prelude
    (fun _ member => member)
  have secretHead : Head env KeygenMakeProgram.secretLoop source.headState ⟨source.segmentState,.normal⟩ [] :=
    .other _ _ _ source.privateCalls (by decide +kernel)
      (.secret source.headState ⟨source.segmentState,.normal⟩ source.privateCalls source.segments)
  have lengthHead : Head env KeygenMakeInvocation.privkeyLenWrite source.segmentState ⟨source.suffixState,.normal⟩ [] :=
    .other _ _ _ [] (by decide +kernel) (.other _ _ _ (by decide +kernel) source.lengthHead)
  have rest : Encoding env (KeygenMakeProgram.secretLoop::KeygenMakeInvocation.privkeyLenWrite::KeygenPublicCallerExecution077.code)
      source.headState out source.publicCalls :=
    .step _ _ source.headState source.segmentState out [] source.publicCalls secretHead
      (.step _ _ source.segmentState source.suffixState out [] source.publicCalls lengthHead source.publicRun)
  have combined := append env KeygenMakeSkeChain.chain s ⟨source.headState,.normal⟩ [] prelude _ out source.publicCalls rest rfl
  simpa only [KeygenSecretCallerTrace081.source_parts,KeygenSecretCallerTrace081.privateCode,
    List.append_assoc,List.cons_append,List.nil_append] using combined

end FT1536.Source3.KeygenSecretTailBinding081
