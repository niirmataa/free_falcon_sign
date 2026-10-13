import Source3.KeygenDecodeNonePrologueExists

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual for initialization and final return expression, composed with
   the checked source while-loop. No successful return/length assumption. -/
namespace FT1536.Source3.KeygenDecodeNoneFor
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeNoneReady KeygenDecodeNonePrologue
open KeygenDecodeNoneMemory KeygenDecodeNoneImages
open KeygenDecodeNonePairs (CarrierList)

def initialized (s : State) : State := withLocals s (localSet s.locals "u".toList .uint64 (some (.uint64 0)))

theorem init_source (args : Args) (s t : State) (flow : Flow)
    (declaredU : s.locals.scalars "u".toList=some (.uint64,none))
    (source : Exec args KeygenDecodeNoneBinding.loop042Init s t flow) : t=initialized s ∧ flow=.normal := by
  have actual := assign_set args s t flow "u".toList .uint64 none (.number .i32 0) (.int32 0)
    declaredU (.number _ _ _ (by decide +kernel)) source
  simpa only [initialized,show C99IntegerReference.convert .uint64 (C99IntegerReference.Value.int32 0).integer=.uint64 0 by decide +kernel] using actual

theorem init_exists (args : Args) (s : State)
    (declaredU : s.locals.scalars "u".toList=some (.uint64,none)) :
    Exec args KeygenDecodeNoneBinding.loop042Init s (initialized s) .normal := by
  have actual := assign_exists args s "u".toList .uint64 none (.number .i32 0) (.int32 0)
    (by decide +kernel) (by decide +kernel) declaredU (.number _ _ _ (by decide +kernel))
  simpa only [initialized,show C99IntegerReference.convert .uint64 (C99IntegerReference.Value.int32 0).integer=.uint64 0 by decide +kernel,
    KeygenDecodeNoneBinding.loop042Init] using actual

theorem init_ready (args : Args) (s : State) (src dst : ArrayPointer)
    (prepared : Prepared args src dst s) : Ready args 0 src dst (initialized s) := by
  have other (name : String) (ty : C99IntegerReference.Ty) (value : C99IntegerReference.Value)
      (different : name.toList≠"u".toList) (cell : Cell name ty value s.locals) :
      Cell name ty value (initialized s).locals := by
    simpa only [Cell,initialized,withLocals,localSet,C99ScalarReference.set,different,ite_false] using cell
  refine ⟨?_,other "q" _ _ (by decide +kernel) prepared.q,
    other "hq" _ _ (by decide +kernel) prepared.hq,
    other "tq" _ _ (by decide +kernel) prepared.tq,
    other "n" _ _ (by decide +kernel) prepared.count,
    other "len" _ _ (by decide +kernel) prepared.length,prepared.buffer,prepared.destination⟩
  simp only [KeygenDecodeNoneRead.Cursor,Cell,initialized,withLocals,localSet,C99ScalarReference.set,ite_true,show (0 : BitVec 64)=BitVec.ofNat 64 0 by decide +kernel]

theorem for_source (args : Args) (s t : State) (flow : Flow) (src dst : ArrayPointer)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (prepared : Prepared args src dst s) (images : ImagesAt s.heap src 0 inputs)
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block)
    (source : Exec args KeygenDecodeNoneBinding.node042 s t flow) :
    flow=.normal ∧ Trace dst s.heap t.heap 0 inputs ∧ Ready args 1536 src dst t := by
  cases source with
  | forLoop initial condition increment body s t flow expanded =>
    obtain ⟨middle,initExec,remaining⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.loop042Init
      KeygenDecodeNoneCounter.loopCode s t flow expanded (by rfl)
    have same := (init_source args s middle .normal prepared.counter initExec).1
    subst middle
    exact KeygenDecodeNoneLoop.source_loop args _ (initialized s) t flow remaining rfl 0 (by decide +kernel)
      src dst inputs (by rw [count]) carrier (init_ready args s src dst prepared) images legal separate

theorem for_exists (args : Args) (s : State) (src dst : ArrayPointer)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (prepared : Prepared args src dst s) (images : ImagesAt s.heap src 0 inputs)
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block) :
    ∃ after, Exec args KeygenDecodeNoneBinding.node042 s after .normal := by
  have initExec := init_exists args s prepared.counter
  obtain ⟨after,loopExec⟩ := KeygenDecodeNoneLoop.loop_exists args (initialized s) 0 src dst inputs
    (by rw [count]) carrier (init_ready args s src dst prepared) images legal separate
  have expanded : Exec args (desugar KeygenDecodeNoneBinding.loop042Init KeygenDecodeNoneBinding.loop042Test
      KeygenDecodeNoneBinding.loop042Update KeygenDecodeNoneBinding.node041) s after .normal :=
    .seq args _ _ s (initialized s) after .normal initExec loopExec
  exact ⟨after,.forLoop args _ _ _ _ s after .normal expanded⟩

theorem return_source (args : Args) (s t : State) (flow : Flow)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node043 s t flow) : t=s ∧ flow=.returned 3072 := by
  cases source with
  | ret s e value locals evaluated =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ _
      (KeygenDecodeNoneEntryCalculations.length_calculation args s count) locals (.integer value) evaluated
    have sameValue := Value.integer.inj same
    subst value; subst locals
    exact ⟨rfl,rfl⟩

theorem return_exists (args : Args) (s : State)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Exec args KeygenDecodeNoneBinding.node043 s s (.returned 3072) :=
  .ret args s _ (.uint64 3072) s.locals
    (computes_exists args s.heap s.buf s.locals _ _ (KeygenDecodeNoneEntryCalculations.length_calculation args s count))

theorem return_tail_source (args : Args) (s t : State) (flow : Flow)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node045 s t flow) : t=s ∧ flow=.returned 3072 := by
  cases source with
  | seq a b s middle t flow first second =>
    have impossible := (return_source args s middle .normal count first).2
    cases impossible
  | seqReturn a b s t ret first => exact return_source args s t (.returned ret) count first

theorem return_tail_exists (args : Args) (s : State)
    (count : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Exec args KeygenDecodeNoneBinding.node045 s s (.returned 3072) :=
  .seqReturn args _ _ s s 3072 (return_exists args s count)

end FT1536.Source3.KeygenDecodeNoneFor
