import Source3.KeygenRootSearch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Allocation metadata and immutable source objects are preserved by actual
   defined memory writes. This invariant is derived through the fixed helper
   bodies; it is not a callee contract or a caller-supplied heap frame. -/
namespace FT1536.Source3.KeygenMemoryStability
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)

structure Stable (before after : Memory) : Prop where
  size : after.size=before.size
  writable : after.writable=before.writable
  readonly : ∀ block offset, before.writable block=false → after.bytes block offset=before.bytes block offset
theorem refl (heap : Memory) : Stable heap heap := ⟨rfl,rfl,fun _ _ _ => rfl⟩
theorem trans (a b c : Memory) (first : Stable a b) (second : Stable b c) : Stable a c :=
  ⟨second.size.trans first.size,second.writable.trans first.writable,fun block offset h =>
    (second.readonly block offset (by rw [first.writable]; exact h)).trans (first.readonly block offset h)⟩
theorem store32 (before after : Memory) (p : ArrayPointer) (v : BitVec 32) (source : Store32 before p v after) : Stable before after := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,?_⟩
  intro block offset readonly
  have ne : block≠p.block := by intro he; subst block; rw [source.2.2.1] at readonly; cases readonly
  exact source.2.2.2.2.2.2 block offset (Or.inl ne)
theorem store64 (before after : Memory) (p : ArrayPointer) (v : BitVec 64) (source : Store64 before p v after) : Stable before after := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,?_⟩
  intro block offset readonly
  have ne : block≠p.block := by intro he; subst block; rw [source.2.2.1] at readonly; cases readonly
  exact source.2.2.2.2.2.2 block offset (Or.inl ne)
theorem copy (before after : Memory) (p q : ArrayPointer) (n : Nat) (source : Memcpy before p q n after) : Stable before after := by
  obtain ⟨_,_,_,_,write,_,_,hs,hw,_,hf⟩ := source
  refine ⟨hs,hw,?_⟩
  intro block offset readonly
  have ne : block≠p.block := by intro he; subst block; rw [write] at readonly; cases readonly
  exact hf block offset (Or.inl ne)
theorem move (before after : Memory) (p q : ArrayPointer) (n : Nat)
    (source : KeygenSearchMemory.Memmove before p q n after) : Stable before after := by
  obtain ⟨_,_,_,_,_,_,write,_,hs,hw,_,hf⟩ := source
  refine ⟨hs,hw,?_⟩
  intro block offset readonly
  have ne : block≠p.block := by intro he; subst block; rw [write] at readonly; cases readonly
  exact hf block offset (Or.inl ne)
theorem zero (before after : Memory) (p : ArrayPointer) (n : Nat)
    (source : KeygenZintCall.Memzero before p n after) : Stable before after := by
  obtain ⟨_,_,write,hs,hw,_,hf⟩ := source
  refine ⟨hs,hw,?_⟩
  intro block offset readonly
  have ne : block≠p.block := by intro he; subst block; rw [write] at readonly; cases readonly
  exact hf block offset (Or.inl ne)
theorem steps (before after : Memory) (source : C99InitializationTrace.Steps before after) : Stable before after := by
  induction source with
  | done => exact refl _
  | write32 before middle after p v write rest ih => exact trans _ _ _ (store32 _ _ _ _ write) ih
  | write64 before middle after p v write rest ih => exact trans _ _ _ (store64 _ _ _ _ write) ih
  | copy before middle after p q n source rest ih => exact trans _ _ _ (copy _ _ _ _ _ source) ih
theorem procedure (program : C99ProcedureReference.Program) (code : C99ProcedureReference.Stmt)
    (before : State) (out : Result) (source : C99ProcedureReference.Exec program code before out) : Stable before.heap out.state.heap :=
  steps _ _ (C99ProcedureReference.memory_steps _ _ _ _ source)
theorem modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
    (source : C99ModularReference.Exec code before out) : Stable before.heap out.state.heap :=
  steps _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _ source)
theorem word (code : KeygenWordExec.Stmt) (before : State) (out : Result)
    (source : KeygenWordExec.Exec code before out) : Stable before.heap out.state.heap := by
  induction source with
  | modular code before out source => exact modular _ _ _ source
  | store name index e before after p v address value write => exact store32 _ _ _ _ write
  | seqNormal a b before middle out head tail ih1 ih2 => exact trans _ _ _ ih1 ih2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact trans _ _ _ ih1 (trans _ _ _ ih2 ih3)
  | assign | ret | loopFalse => exact refl _
  | seqExit | scope | branchTrue | branchFalse | loopReturn => assumption
theorem receive (dst : KeygenZintCall.CDest) (before after : State) (v : Option C99IntegerReference.Value)
    (source : KeygenZintCall.ReceiveC dst before v after) : Stable before.heap after.heap := by
  cases source with
  | discard | into => exact refl _
  | store array index s after p v address write => exact store32 _ _ _ _ write
theorem zint (code : KeygenZintCall.Stmt) (before : State) (out : Result)
    (source : KeygenZintCall.Exec code before out) : Stable before.heap out.state.heap := by
  induction source with
  | word code before out source => exact word _ _ _ source
  | storePrime array index src srcIndex field before after p w read address write => exact store32 _ _ _ _ write
  | memzero before after array index count p n address length object zeroed => exact zero _ _ _ _ zeroed
  | call before kind args dst entry out v after binding source returned rec ih =>
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at ih
    have received := receive _ _ _ _ rec
    exact trans _ _ _ ih received
  | callTrue before kind args test bound yes no entry out v w z next binding source returned boundValue compare nonzero execution ih1 ih2
  | callFalse before kind args test bound yes no entry out v w z next binding source returned boundValue compare zero execution ih1 ih2 =>
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at ih1
    exact trans _ _ _ ih1 ih2
  | seqNormal a b before middle out head tail ih1 ih2 => exact trans _ _ _ ih1 ih2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3
  | loopContinue condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact trans _ _ _ ih1 (trans _ _ _ ih2 ih3)
  | static32 | prime | bitcastInto | breakLoop | continueLoop | retVoid | loopFalse => exact refl _
  | retSum | seqExit | scope | branchTrue | branchFalse | loopReturn | loopBreak => assumption

end FT1536.Source3.KeygenMemoryStability
