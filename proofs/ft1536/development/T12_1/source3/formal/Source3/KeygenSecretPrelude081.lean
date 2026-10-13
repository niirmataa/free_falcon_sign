import Source3.KeygenSecretChain081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretPrelude081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation
open KeygenSecretChain081 (Cursor)
open ShakeExtractFrame (SameBlock)

def skeStores : List Stmt :=
  [skeBind 0 "f".toList,skeBind 1 "g".toList,skeBind 2 "F".toList,skeBind 3 "G".toList]

theorem header_value : BitVec.setWidth 8 (((1 : BitVec 32) <<< 7)+((1 : BitVec 32) <<< 5)+10)=
    (170 : BitVec 8) := by decide +kernel

theorem header (env : Env) (s t : State) (profile : KeygenCodecProfile.Profile env s)
    (comp : env.args.comp=1) (source : Head env skHeader s ⟨t,.normal⟩) :
    KeygenCodecExecution.StoreByte s.heap (byteOff env.args.privkey 0) 170 t.heap := by
  cases source with
  | storeSkHeader s ter cmp logn byte after terCell compCell lognCell skbufCell value store =>
    have terEq : ter=1 := by simpa using terCell.symm.trans profile.ter
    have cmpEq : cmp=1 := by simpa [comp] using compCell.symm.trans profile.comp
    have lognEq : logn=10 := by simpa using lognCell.symm.trans profile.logn
    subst ter; subst cmp; subst logn
    rw [header_value] at value
    subst byte
    exact store

theorem ske_head (env : Env) (stmt : Stmt) (s t : State)
    (source : Head env stmt s ⟨t,.normal⟩) (member : stmt∈skeStores)
    (separate : env.args.privkey.block≠env.blocks 5) :
    SameBlock s.heap t.heap env.args.privkey.block ∧ t.locals "skoff".toList=s.locals "skoff".toList := by
  cases source <;> try exact ⟨⟨rfl,rfl,fun _ => rfl⟩,rfl⟩
  case bindSke =>
    rename_i store
    exact ⟨⟨store.2.2.2.2.1,store.2.2.2.2.2.1,
      fun offset => store.2.2.2.2.2.2.2 _ offset (Or.inl separate)⟩,rfl⟩
  all_goals simp [skeStores,skeBind,skoffOne,skHeader,KeygenMakeProgram.secretLoop,
    privkeyLenWrite,pkHeader,KeygenMakeProgram.publicDispatch,pubkeyLenWrite,
    KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at member

theorem ske_frame (env : Env) (ss : List Stmt) (s : State) (out : Result)
    (source : Encoding env ss s out) (subset : ∀ stmt∈ss, stmt∈skeStores)
    (normal : out.flow=.normal) (separate : env.args.privkey.block≠env.blocks 5) :
    SameBlock s.heap out.state.heap env.args.privkey.block ∧
      out.state.locals "skoff".toList=s.locals "skoff".toList := by
  induction source with
  | done s => exact ⟨⟨rfl,rfl,fun _ => rfl⟩,rfl⟩
  | step stmt rest s middle out head tail ih =>
    have first := ske_head env stmt s middle head (subset stmt (List.mem_cons_self)) separate
    have later := ih (fun stmt member => subset stmt (List.mem_cons_of_mem _ member)) normal
    exact ⟨⟨later.1.1.trans first.1.1,later.1.2.1.trans first.1.2.1,
      fun offset => (later.1.2.2 offset).trans (first.1.2.2 offset)⟩,later.2.trans first.2⟩
  | exit stmt rest s out head flow => exact (flow normal).elim

/-- Header0xaa and cursor1 are derived from the actual prelude stores;
    the later four pointer stores preserve the observed header byte. -/
theorem prelude (env : Env) (s : State) (out : Result) (cells : TailCells env s)
    (source : Encoding env KeygenMakeSkeChain.chain s out) (normal : out.flow=.normal)
    (comp : env.args.comp=1) (separate : env.args.privkey.block≠env.blocks 5) :
    Cursor out.state 1 ∧ KeygenDecodeValues.LoadByte out.state.heap (byteOff env.args.privkey 0) 170 := by
  obtain ⟨m1,h1,r1⟩ := KeygenMakeSkeChain.encoding_cons_normal env privkeyLenRead _ s out source normal
  obtain ⟨m2,h2,r2⟩ := KeygenMakeSkeChain.encoding_cons_normal env skbufAssign _ m1 out r1 normal
  obtain ⟨m3,h3,r3⟩ := KeygenMakeSkeChain.encoding_cons_normal env KeygenMakeProgram.capacityReturn _ m2 out r2 normal
  obtain ⟨m4,h4,r4⟩ := KeygenMakeSkeChain.encoding_cons_normal env skHeader _ m3 out r3 normal
  obtain ⟨m5,h5,r5⟩ := KeygenMakeSkeChain.encoding_cons_normal env skoffOne _ m4 out r4 normal
  have first : Encoding env [privkeyLenRead,skbufAssign,KeygenMakeProgram.capacityReturn] s ⟨m3,.normal⟩ :=
    .step _ _ s m1 _ h1 (.step _ _ m1 m2 _ h2 (.step _ _ m2 m3 _ h3 (.done m3)))
  have profile := KeygenCodecProfile.encoding_profile env _ s _ first ⟨cells.logn,cells.ter,cells.comp⟩
  have stored := header env m3 m4 profile comp h4
  have cursor : Cursor m5 1 := by cases h5; rfl
  have sameHeap : m5.heap=m4.heap := by cases h5; rfl
  have frame := ske_frame env skeStores m5 out r5 (fun _ member => member) normal separate
  have read : KeygenDecodeValues.LoadByte m5.heap (byteOff env.args.privkey 0) 170 := by
    rw [sameHeap]
    exact KeygenPublicObserved077.byte_after_store m3.heap m4.heap _ _ stored
  exact ⟨frame.2.trans cursor,
    KeygenPublicObserved077.byte_transport m5.heap out.state.heap (byteOff env.args.privkey 0) 170
      frame.1.1 (frame.1.2.2 _) read⟩

end FT1536.Source3.KeygenSecretPrelude081
