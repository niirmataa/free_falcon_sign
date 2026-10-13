import Source3.KeygenPublicForeign081
import Source3.KeygenPublicCallerExecution077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicSuffixFrame081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env)
open KeygenPublicCallerSite077 (Site)
open KeygenPublicCallerExecution077 (Head Encoding code)
open ShakeExtractFrame (SameBlock)

theorem head_frame (env : Env) (stmt : Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Head env stmt s out calls) (member : stmt∈code) (block : Nat)
    (bufferSeparate : block≠env.args.pubkey.block) (lengthSeparate : block≠env.args.pubkeyLen.block) :
    SameBlock s.heap out.state.heap block := by
  cases source with
  | invoke c ter cell nonzero => exact KeygenPublicForeign081.site env c block bufferSeparate
  | other stmt s out privateCalls different source =>
    have old := KeygenCodecInvocation.head_erase env stmt s out privateCalls source
    cases old <;> try exact ⟨rfl,rfl,fun _ => rfl⟩
    case storePkHeader =>
      rename_i store
      exact ⟨store.2.2.2.1,store.2.2.2.2.1,
        fun offset => store.2.2.2.2.2.2 block offset (Or.inl bufferSeparate)⟩
    case storePubkeyLen =>
      rename_i store
      exact ⟨store.2.2.2.1,store.2.2.2.2.1,
        fun offset => store.2.2.2.2.2.2 block offset (Or.inl lengthSeparate)⟩
    case publicTernary => exact (different rfl).elim
    case publicBinary => exact (different rfl).elim
    all_goals simp [code,KeygenMakeInvocation.pubkeyLenRead,KeygenMakeProgram.capacityReturn,
      KeygenMakeProgram.capacityTest,KeygenMakeInvocation.pkHeader,KeygenMakeProgram.publicDispatch,
      KeygenMakeInvocation.zeroCapacity,KeygenMakeInvocation.pubkeyLenWrite,KeygenMakeInvocation.retOne,
      KeygenMakeInvocation.skHeader,KeygenMakeInvocation.skeBind,KeygenMakeProgram.secretLoop,
      KeygenMakeInvocation.privkeyLenWrite,KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at member

/-- All seven actual public suffix statements preserve secret-buffer and
    secret-length blocks outside the public destinations. -/
theorem encoding_frame (env : Env) (ss : List Stmt) (s : State) (out : Result) (calls : List (Site env))
    (source : Encoding env ss s out calls) (subset : ∀ stmt∈ss, stmt∈code) (block : Nat)
    (bufferSeparate : block≠env.args.pubkey.block) (lengthSeparate : block≠env.args.pubkeyLen.block) :
    SameBlock s.heap out.state.heap block := by
  induction source with
  | done => exact ⟨rfl,rfl,fun _ => rfl⟩
  | step stmt rest s middle out first later head tail ih =>
    exact KeygenPublicForeign081.same_trans _ _ _ block
      (head_frame env stmt s _ first head (subset stmt (List.mem_cons_self)) block bufferSeparate lengthSeparate)
      (ih (fun stmt member => subset stmt (List.mem_cons_of_mem _ member)))
  | exit stmt rest s out calls head flow =>
    exact head_frame env stmt s out calls head (subset stmt (List.mem_cons_self)) block bufferSeparate lengthSeparate

end FT1536.Source3.KeygenPublicSuffixFrame081
