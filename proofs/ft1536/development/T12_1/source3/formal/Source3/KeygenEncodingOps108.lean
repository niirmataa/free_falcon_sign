import Source3.KeygenPrivateSegments108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenEncodingOps108
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env)
open KeygenPublicCallerSite077 (Site)
open KeygenPublicCallerExecution077 (Head Encoding)

def Run (env : Env) (ss : List Stmt) (before : State) (out : Result) : Prop := ∃ calls, Encoding env ss before out calls

theorem legacy (env : Env) (ss : List Stmt) (before : State) (out : Result) (source : Run env ss before out) :
    KeygenMakeInvocation.Encoding env ss before out := by
  obtain ⟨calls, actual⟩ := source
  obtain ⟨privateCalls, erased⟩ := KeygenPublicCallerExecution077.erase env ss before out calls actual
  exact KeygenCodecInvocation.encoding_erase env ss before out privateCalls erased

theorem head_no_secret (env : Env) (stmt : Stmt) (before : State) (a b : Result) (xs ys : List (Site env))
    (absent : stmt ≠ KeygenMakeProgram.secretLoop)
    (first : Head env stmt before a xs) (second : Head env stmt before b ys) : a = b := by
  by_cases pub : stmt = KeygenMakeProgram.publicDispatch
  · subst stmt
    exact KeygenPublicSite108.head env before a b xs ys first second
  · exact KeygenPlainHead108.head env stmt before a b absent pub
      (KeygenPublicCallerExecution077.head_legacy env stmt before a xs first)
      (KeygenPublicCallerExecution077.head_legacy env stmt before b ys second)

theorem absent_head (stmt : Stmt) (rest : List Stmt) (absent : KeygenMakeProgram.secretLoop ∉ stmt :: rest) :
    stmt ≠ KeygenMakeProgram.secretLoop := by
  intro equal
  subst stmt
  exact absent List.mem_cons_self

theorem absent_tail (stmt : Stmt) (rest : List Stmt) (absent : KeygenMakeProgram.secretLoop ∉ stmt :: rest) :
    KeygenMakeProgram.secretLoop ∉ rest := fun member => absent (List.mem_cons_of_mem stmt member)

theorem encoding_no_secret (env : Env) (ss : List Stmt) (before : State) (a b : Result) (xs ys : List (Site env))
    (first : Encoding env ss before a xs) (second : Encoding env ss before b ys)
    (absent : KeygenMakeProgram.secretLoop ∉ ss) : a = b := by
  revert absent
  induction first generalizing b ys <;> intro absent <;> cases second
  all_goals grind only [→ absent_head, → absent_tail, head_no_secret]

theorem run_no_secret (env : Env) (ss : List Stmt) (before : State) (a b : Result)
    (absent : KeygenMakeProgram.secretLoop ∉ ss) (first : Run env ss before a) (second : Run env ss before b) : a = b := by
  obtain ⟨xs, first⟩ := first
  obtain ⟨ys, second⟩ := second
  exact encoding_no_secret env ss before a b xs ys first second absent

/-- Split every path, including an early exit before the suffix starts. -/
theorem split (env : Env) (pre rest : List Stmt) (before : State) (out : Result) (calls : List (Site env))
    (source : Encoding env (pre ++ rest) before out calls) :
    (∃ middle, Run env pre before ⟨middle,.normal⟩ ∧ Run env rest middle out) ∨
    (Run env pre before out ∧ out.flow ≠ .normal) := by
  induction pre generalizing before calls with
  | nil => exact Or.inl ⟨before, ⟨[], .done before⟩, ⟨calls, source⟩⟩
  | cons stmt pre ih =>
      cases source with
      | step stmt ss before middle out first later head tail =>
          rcases ih middle later tail with ⟨last, ⟨early, one⟩, two⟩ | ⟨⟨early, one⟩, exit⟩
          · exact Or.inl ⟨last, ⟨first ++ early, .step stmt pre before middle _ first early head one⟩, two⟩
          · exact Or.inr ⟨⟨first ++ early, .step stmt pre before middle out first early head one⟩, exit⟩
      | exit stmt ss before out calls head flow =>
          exact Or.inr ⟨⟨calls, .exit stmt pre before out calls head flow⟩, flow⟩

theorem stopped_append (env : Env) (pre : List Stmt) (before : State) (out : Result) (calls : List (Site env))
    (source : Encoding env pre before out calls) (exit : out.flow ≠ .normal) (rest : List Stmt) :
    Encoding env (pre ++ rest) before out calls := by
  induction source with
  | done before => exact (exit rfl).elim
  | step stmt pre before middle out first later head tail ih =>
      exact .step stmt (pre ++ rest) before middle out first later head (ih exit)
  | exit stmt pre before out calls head flow => exact .exit stmt (pre ++ rest) before out calls head flow

theorem private_head (env : Env) (before : State) (out : Result) (calls : List (Site env))
    (source : Head env KeygenMakeProgram.secretLoop before out calls) :
    ∃ privateCalls, KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter before) out privateCalls := by
  obtain ⟨privateCalls, head⟩ := KeygenPublicCallerExecution077.head_erase env _ before out calls source
  exact ⟨privateCalls, KeygenCodecInvocation.secret_extract env _ before out privateCalls head rfl⟩

end FT1536.Source3.KeygenEncodingOps108
