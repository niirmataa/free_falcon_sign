import Source3.KeygenAcceptedLoop079
import Source3.KeygenInt16Caller076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual nine statements before the private codec loop preserve the
   accepted arrays. Header and pointer-array stores are accounted for. -/
namespace FT1536.Source3.KeygenSerializationEntry079
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation
open KeygenMakeSkeChain (chain)
open ShakeExtractFrame (SameBlock)

theorem head_frame (env : Env) (stmt : Stmt) (s t : State) (block : Nat)
    (source : Head env stmt s ⟨t,.normal⟩) (member : stmt∈chain)
    (privateSeparate : block≠env.args.privkey.block) (skeSeparate : block≠env.blocks 5) :
    SameBlock s.heap t.heap block := by
  cases source <;> try exact ⟨rfl,rfl,fun _ => rfl⟩
  case storeSkHeader =>
    rename_i store
    exact ⟨store.2.2.2.1,store.2.2.2.2.1,
      fun offset => store.2.2.2.2.2.2 block offset (Or.inl privateSeparate)⟩
  case bindSke =>
    rename_i store
    exact ⟨store.2.2.2.2.1,store.2.2.2.2.2.1,
      fun offset => store.2.2.2.2.2.2.2 block offset (Or.inl skeSeparate)⟩
  all_goals simp [chain,privkeyLenRead,skbufAssign,KeygenMakeProgram.capacityReturn,
    KeygenMakeProgram.capacityTest,skHeader,skoffOne,skeBind,KeygenMakeProgram.secretLoop,
    privkeyLenWrite,pkHeader,KeygenMakeProgram.publicDispatch,
    pubkeyLenWrite,KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at member

theorem prefix_frame (env : Env) (ss : List Stmt) (s : State) (out : Result) (block : Nat)
    (source : Encoding env ss s out) (subset : ∀ stmt∈ss, stmt∈chain)
    (normal : out.flow=.normal)
    (privateSeparate : block≠env.args.privkey.block) (skeSeparate : block≠env.blocks 5) :
    SameBlock s.heap out.state.heap block := by
  induction source with
  | done s => exact ⟨rfl,rfl,fun _ => rfl⟩
  | step stmt rest s middle out head tail ih =>
    have first := head_frame env stmt s middle block head
      (subset stmt (by simp)) privateSeparate skeSeparate
    have later := ih (fun stmt member => subset stmt (List.mem_cons_of_mem _ member)) normal
    exact ⟨later.1.trans first.1,later.2.1.trans first.2.1,
      fun offset => (later.2.2 offset).trans (first.2.2 offset)⟩
  | exit stmt rest s out head flow => exact (flow normal).elim

/-- SAME accepted f/g/F/G/h and equations reach the concrete serialization
    input heap after all header/pointer stores. No codec fact is a premise. -/
theorem prefix_material (env : Env) (s : State) (out : Result)
    (source : Encoding env chain s out) (normal : out.flow=.normal)
    (privateSeparate : ∀ slot : Fin 4, (inputOf env slot).block≠env.args.privkey.block)
    (skeSeparate : ∀ slot : Fin 4, (inputOf env slot).block≠env.blocks 5)
    (publicPrivate : (publicOf env).block≠env.args.privkey.block)
    (publicSke : (publicOf env).block≠env.blocks 5)
    (material : KeygenMakeMaterialWitness.EncodingInputs s.heap (inputOf env) (publicOf env)) :
    KeygenMakeMaterialWitness.Witness out.state.heap (inputOf env) (publicOf env) :=
  KeygenMakeMaterialWitness.witness_represented s.heap out.state.heap (inputOf env) (publicOf env)
    (fun slot => prefix_frame env chain s out _ source (fun _ member => member) normal
      (privateSeparate slot) (skeSeparate slot))
    (prefix_frame env chain s out _ source (fun _ member => member) normal publicPrivate publicSke)
    material

theorem prefix_legal (env : Env) (s : State) (out : Result)
    (source : Encoding env chain s out) (normal : out.flow=.normal)
    (privateSeparate : ∀ slot : Fin 4, (inputOf env slot).block≠env.args.privkey.block)
    (skeSeparate : ∀ slot : Fin 4, (inputOf env slot).block≠env.blocks 5)
    (legal : KeygenInt16FourMaterial076.Legal s.heap (inputOf env)) :
    KeygenInt16FourMaterial076.Legal out.state.heap (inputOf env) := by
  intro slot
  have frame := prefix_frame env chain s out _ source (fun _ member => member) normal
    (privateSeparate slot) (skeSeparate slot)
  exact KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.1.symm (legal slot)

end FT1536.Source3.KeygenSerializationEntry079
