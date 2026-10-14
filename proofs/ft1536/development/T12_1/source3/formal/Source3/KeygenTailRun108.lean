import Source3.KeygenEncodingOps108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTailRun108
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenPublicCallerSite077 (Site)
open KeygenPublicCallerExecution077 (Head Encoding)

def prelude : List Stmt := KeygenMakeSkeChain.chain
def suffix : List Stmt := KeygenMakeInvocation.privkeyLenWrite :: KeygenPublicCallerExecution077.code

theorem source_parts : KeygenMakeProgram.encoding = prelude ++ KeygenMakeProgram.secretLoop :: suffix := by
  simpa only [KeygenSecretCallerTrace081.privateCode, prelude, suffix, List.append_assoc, List.cons_append, List.nil_append]
    using KeygenSecretCallerTrace081.source_parts

theorem prelude_no_secret : KeygenMakeProgram.secretLoop ∉ prelude := by decide +kernel

theorem suffix_no_secret : KeygenMakeProgram.secretLoop ∉ suffix := by decide +kernel

inductive Run (env : Env) (before : State) : Result → Prop where
  | preludeFailed (out : Result)
      (source : KeygenEncodingOps108.Run (canonical env) prelude before out) (exit : out.flow ≠ .normal) : Run env before out
  | privateFailed (prepared : State) (out : Result)
      (head : KeygenEncodingOps108.Run (canonical env) prelude before ⟨prepared,.normal⟩)
      (privateRun : KeygenPrivateSegments108.Run env 0 (KeygenMakeInvocation.initCounter prepared) out)
      (exit : out.flow ≠ .normal) : Run env before out
  | rest (prepared encoded : State) (out : Result)
      (head : KeygenEncodingOps108.Run (canonical env) prelude before ⟨prepared,.normal⟩)
      (privateRun : KeygenPrivateSegments108.Run env 0 (KeygenMakeInvocation.initCounter prepared) ⟨encoded,.normal⟩)
      (tail : KeygenEncodingOps108.Run (canonical env) suffix encoded out) : Run env before out

theorem erase (env : Env) (before : State) (out : Result) (calls : List (Site (canonical env)))
    (source : Encoding (canonical env) KeygenMakeProgram.encoding before out calls) : Run env before out := by
  rw [source_parts] at source
  rcases KeygenEncodingOps108.split (canonical env) prelude (KeygenMakeProgram.secretLoop :: suffix) before out calls source with
    ⟨prepared, head, ⟨later, tail⟩⟩ | ⟨head, exit⟩
  · cases tail with
    | step stmt ss prepared encoded out first later privateHead tail =>
        obtain ⟨privateCalls, actual⟩ := KeygenEncodingOps108.private_head (canonical env) prepared ⟨encoded,.normal⟩ first privateHead
        exact .rest prepared encoded out head (KeygenPrivateSegments108.erase env 0 _ _ privateCalls actual) ⟨later,tail⟩
    | exit stmt ss prepared out calls privateHead flow =>
        obtain ⟨privateCalls, actual⟩ := KeygenEncodingOps108.private_head (canonical env) prepared out _ privateHead
        exact .privateFailed prepared out head (KeygenPrivateSegments108.erase env 0 _ _ privateCalls actual) flow
  · exact .preludeFailed out head exit

theorem restored_head (env : Env) (before : State) (out : Result)
    (source : KeygenPrivateSegments108.Run env 0 (KeygenMakeInvocation.initCounter before) out) :
    Head (canonical env) KeygenMakeProgram.secretLoop before out [] := by
  obtain ⟨calls, actual⟩ := KeygenPrivateSegments108.restore env 0 _ out source
  exact .other _ _ _ calls (by decide +kernel) (.secret before out calls actual)

theorem restore (env : Env) (before : State) (out : Result) (source : Run env before out) :
    ∃ calls, Encoding (canonical env) KeygenMakeProgram.encoding before out calls := by
  cases source with
  | preludeFailed out source exit =>
      obtain ⟨calls, head⟩ := source
      exact ⟨calls, by simpa only [source_parts] using
        KeygenEncodingOps108.stopped_append (canonical env) prelude before out calls head exit (KeygenMakeProgram.secretLoop :: suffix)⟩
  | privateFailed prepared out source privateRun exit =>
      obtain ⟨calls, head⟩ := source
      have tail : Encoding (canonical env) (KeygenMakeProgram.secretLoop :: suffix) prepared out [] :=
        .exit _ _ prepared out [] (restored_head env prepared out privateRun) exit
      exact ⟨calls ++ [], by simpa only [source_parts] using
        KeygenSecretTailBinding081.append (canonical env) prelude before ⟨prepared,.normal⟩ calls head _ out [] tail rfl⟩
  | rest prepared encoded out source privateRun tailSource =>
      obtain ⟨early, head⟩ := source
      obtain ⟨later, tail⟩ := tailSource
      have rest : Encoding (canonical env) (KeygenMakeProgram.secretLoop :: suffix) prepared out later :=
        .step _ _ prepared encoded out [] later (restored_head env prepared ⟨encoded,.normal⟩ privateRun) tail
      exact ⟨early ++ later, by simpa only [source_parts] using
        KeygenSecretTailBinding081.append (canonical env) prelude before ⟨prepared,.normal⟩ early head _ out later rest rfl⟩

theorem source_iff (env : Env) (before : State) (out : Result) :
    Run env before out ↔ ∃ calls, Encoding (canonical env) KeygenMakeProgram.encoding before out calls :=
  ⟨restore env before out, fun ⟨calls, source⟩ => erase env before out calls source⟩

theorem prelude_unique (env : Env) (before : State) (a b : Result)
    (first : KeygenEncodingOps108.Run (canonical env) prelude before a)
    (second : KeygenEncodingOps108.Run (canonical env) prelude before b) : a = b :=
  KeygenEncodingOps108.run_no_secret _ prelude before a b prelude_no_secret first second

theorem suffix_unique (env : Env) (before : State) (a b : Result)
    (first : KeygenEncodingOps108.Run (canonical env) suffix before a)
    (second : KeygenEncodingOps108.Run (canonical env) suffix before b) : a = b :=
  KeygenEncodingOps108.run_no_secret _ suffix before a b suffix_no_secret first second

theorem private_unique (env : Env) (before prepared : State) (a b : Result)
    (cells : KeygenMakeInvocation.TailCells (canonical env) before)
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5)
    (head : KeygenEncodingOps108.Run (canonical env) prelude before ⟨prepared,.normal⟩)
    (first : KeygenPrivateSegments108.Run env 0 (KeygenMakeInvocation.initCounter prepared) a)
    (second : KeygenPrivateSegments108.Run env 0 (KeygenMakeInvocation.initCounter prepared) b) : a = b := by
  have words := KeygenMakeSkeChain.prefix_ske_chain (canonical env) before ⟨prepared,.normal⟩ cells
    (KeygenEncodingOps108.legacy (canonical env) prelude before _ head) rfl
  exact KeygenPrivateSegments108.unique env 0 _ a b separate first second words

theorem unique (env : Env) (before : State) (a b : Result)
    (cells : KeygenMakeInvocation.TailCells (canonical env) before)
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5)
    (first : Run env before a) (second : Run env before b) : a = b := by
  cases first <;> cases second
  all_goals grind (ematch := 8) only [prelude_unique, private_unique, suffix_unique]

end FT1536.Source3.KeygenTailRun108
