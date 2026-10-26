import Source3.KeygenHelperStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Initialization is monotone through the actual helper executions used by
   the section. This preserves initialized bytes, not their values. -/
namespace FT1536.Source3.StepMemoryInit195
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99InitializationTrace (Preserves)

theorem refl (h : Memory) : Preserves h h := C99InitializationTrace.preserves_refl h
theorem trans (a b c : Memory) (ab : Preserves a b) (bc : Preserves b c) : Preserves a c :=
  C99InitializationTrace.preserves_trans a b c ab bc
theorem compose (a b c : Memory) (ab : Preserves a b) (bc : Preserves b c) : Preserves a c :=
  trans a b c ab bc

theorem store32 (a b : Memory) (p : ArrayPointer) (w : BitVec 32) (write : Store32 a p w b) :
    Preserves a b := C99InitializationTrace.store32_preserves a b p w write

theorem move (before after : Memory) (p q : ArrayPointer) (n : Nat)
    (source : KeygenSearchMemory.Memmove before p q n after) : Preserves before after := by
  obtain ⟨_,_,_,_,_,_,_,read,size,writable,copy,frame⟩ := source
  refine ⟨size,writable,?_⟩
  intro block offset old
  by_cases inside : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+n
  · obtain ⟨rfl,lo,hi⟩ := inside
    have same : p.offset+(offset-p.offset)=offset := by omega
    have written := copy (offset-p.offset) (by omega)
    rw [same] at written
    rw [written]
    exact read (offset-p.offset) (by omega)
  · rw [frame block offset (by omega)]
    exact old

theorem zero (before after : Memory) (p : ArrayPointer) (n : Nat)
    (source : KeygenZintCall.Memzero before p n after) : Preserves before after := by
  obtain ⟨_,_,_,size,writable,written,frame⟩ := source
  refine ⟨size,writable,?_⟩
  intro block offset old
  by_cases inside : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+n
  · obtain ⟨rfl,lo,hi⟩ := inside
    have same : p.offset+(offset-p.offset)=offset := by omega
    have write := written (offset-p.offset) (by omega)
    rw [same] at write
    rw [write]
    rfl
  · rw [frame block offset (by omega)]
    exact old

theorem modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
    (source : C99ModularReference.Exec code before out) : Preserves before.heap out.state.heap :=
  C99InitializationTrace.steps_preserve _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _ source)
theorem word (code : KeygenWordExec.Stmt) (before : State) (out : Result)
    (source : KeygenWordExec.Exec code before out) : Preserves before.heap out.state.heap := by
  induction source with
  | modular code before out source => exact modular _ _ _ source
  | store name index e before after p v address value write => exact store32 _ _ _ _ write
  | seqNormal a b before middle out head tail ih1 ih2 => exact trans _ _ _ ih1 ih2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact trans _ _ _ ih1 (trans _ _ _ ih2 ih3)
  | assign | ret | loopFalse => exact refl _
  | seqExit | scope | branchTrue | branchFalse | loopReturn => assumption
theorem receive (dst : KeygenZintCall.CDest) (before after : State) (v : Option C99IntegerReference.Value)
    (source : KeygenZintCall.ReceiveC dst before v after) : Preserves before.heap after.heap := by
  cases source with
  | discard | into => exact refl _
  | store array index s after p v address write => exact store32 _ _ _ _ write
theorem zint (code : KeygenZintCall.Stmt) (before : State) (out : Result)
    (source : KeygenZintCall.Exec code before out) : Preserves before.heap out.state.heap := by
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

theorem level_call (kind : KeygenLevelCalls.Kind) (before after : State) (args : List KeygenLevelCalls.Arg)
    (source : KeygenLevelCalls.Call kind before args after) : Preserves before.heap after.heap := by
  cases source with
  | run entry out binding execution returned =>
    have result := modular _ _ _ execution
    rw [KeygenLevelCalls.bind_heap _ _ _ _ binding] at result
    exact result
theorem level (code : KeygenLevelExec.Stmt) (before : State) (out : Result)
    (source : KeygenLevelExec.Exec code before out) : Preserves before.heap out.state.heap := by
  induction source
  case modular code before out source => exact modular _ _ _ source
  case call kind args before after source => exact level_call _ _ _ _ source
  case move dst src di si count before after p q word destination source length copy => exact move _ _ _ _ _ copy
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem binary (code : KeygenBinaryNtt.Stmt) (before : State) (out : Result)
    (source : KeygenBinaryNtt.Exec code before out) : Preserves before.heap out.state.heap := by
  induction source
  case base code before out source => exact modular _ _ _ source
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem binary_call (kind : KeygenBinaryNtt.Kind) (before after : State) (args : List KeygenLevelCalls.Arg)
    (source : KeygenBinaryNtt.Call kind before args after) : Preserves before.heap after.heap := by
  cases source with
  | run entry out binding execution returned =>
    have result := binary _ _ _ execution
    rw [KeygenLevelCalls.bind_heap _ _ _ _ binding] at result
    exact result
theorem make_top (before after : State) (args : List C99ArrayReference.Arg)
    (source : KeygenMakeFgTop.Call before args after) : Preserves before.heap after.heap := by
  cases source with
  | run entry out binding execution returned =>
    have result := level _ _ _ execution
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
    exact result
theorem make (code : KeygenMakeFgSource.Stmt) (before : State) (out : Result)
    (source : KeygenMakeFgSource.Exec code before out) : Preserves before.heap out.state.heap := by
  induction source
  case level code before out source => exact level _ _ _ source
  case zint code before out source => exact zint _ _ _ source
  case word code before out source => exact word _ _ _ source
  case binary kind args before after source => exact binary_call _ _ _ _ source
  case top args before after source => exact make_top _ _ _ source
  case step args before entry out binding source returned ih =>
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at ih
    exact ih
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
end FT1536.Source3.StepMemoryInit195
