import Source3.KeygenSolverTarget
import Source3.KeygenNttMemoryFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete validation seam from table generation through conversion, four
   transforms and return1. Original material, legal caller bindings and its
   coefficient bounds are still local entry inputs; the preceding sampler,
   small-output gates and full solver call graph must supply those inputs. -/
namespace FT1536.Source3.KeygenSolverValidation
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Stmt Exec)
open KeygenMkgm3Layout (output gm)
open KeygenSmallOutput (element)

theorem sequence_frame (indices : List (Fin 4)) (before after : State)
    (root : ArrayPointer) (p0i : BitVec 32) (width : root.elementBytes=4)
    (caller : KeygenSolverNttCalls.Caller before p0i (gm root))
    (bindings : KeygenSolverTransforms.Bindings before root)
    (source : KeygenSolverNttCalls.Exec (KeygenSolverTransforms.code indices) before after) :
    KeygenNttMemoryFrame.Frame before.heap after.heap root := by
  induction indices generalizing before with
  | nil => cases source; exact ⟨rfl,rfl,fun _ _ _ => rfl⟩
  | cons slot rest ih =>
      cases source with
      | seq first second before middle after head tail =>
          have desc : KeygenNttMemoryFrame.Descendant root (output root slot) :=
            ⟨rfl,rfl,rfl,width,by dsimp [output,element]; omega⟩
          have first := KeygenNttMemoryFrame.call_frame _ before middle root (output root slot) (gm root) p0i
            width desc caller (bindings slot) head
          have keep := KeygenSolverNttCalls.frame _ before middle head
          have second := ih middle (KeygenSolverNttCalls.caller_preserved _ before middle p0i (gm root) head caller)
            (fun other => (congrFun keep.2.1 _).trans (bindings other)) tail
          exact KeygenNttMemoryFrame.frame_trans _ _ _ root first second

def readOnly : Stmt → Bool
  | .base .skip | .base (.scalar _) | .assign _ _ | .ret _ | .retVoid => true
  | .seq a b | .branch _ a b | .loop _ a b => readOnly a && readOnly b
  | .scope _ body => readOnly body
  | _ => false

theorem read_only_heap (code : Stmt) (before : State) (out : Result) (checked : readOnly code=true)
    (source : Exec code before out) : out.state.heap=before.heap := by
  induction source with
  | base code before after body =>
      cases code with
      | skip | scalar => cases body; rfl
      | assign | declarePtr | bindPtr | store64 | store32 | copy | seq | scope | branch | «while» | call => cases checked
  | assign | ret | retVoid | loopFalse => rfl
  | store32 | storeRev => cases checked
  | seqNormal first second before middle out head tail ih1 ih2 =>
      have hs := Bool.and_eq_true_iff.mp checked
      exact (ih2 hs.2).trans (ih1 hs.1)
  | seqExit first second before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope names body before out inner ih => exact ih checked
  | branchTrue condition yes no before out v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before out v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      have hs := Bool.and_eq_true_iff.mp checked
      exact (ih3 checked).trans ((ih2 hs.2).trans (ih1 hs.1))
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).1

theorem loop_counter (arrays : KeygenResidueTrace.Arrays) (code : Stmt) (before : State) (out : Result)
    (source : Exec code before out) (shape : code=KeygenResidueProgram.loop) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : KeygenResidueTrace.Inputs arrays before) :
    C99CountedWords.Counter out.state 1536 := by
  induction source generalizing i with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse | ret | retVoid => cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      have equal : i=1536 := by
        have := C99CountedWords.guard_false before i v hi counter inputs.size guard zero
        omega
      simpa only [equal] using counter
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have strict := C99CountedWords.guard_true before i v hi counter inputs.size guard nonzero
      obtain ⟨_,hl,ha,_⟩ := KeygenResidueTrace.source_iteration arrays before ⟨middle,.normal⟩ i hi counter inputs iteration
      change middle.locals=before.locals at hl
      change middle.arrays=before.arrays at ha
      have hc : C99CountedWords.Counter middle i := by simpa only [C99CountedWords.Counter,hl] using counter
      have hm := KeygenResidueTrace.inputs_transport arrays before middle hl ha inputs
      have he := congrArg Result.state (KeygenCheckLoopBridge.increment_result middle i ⟨next,.normal⟩ hi hc update)
      change next=SmallintsCounter.advanced middle i at he
      subst next
      exact ih3 rfl (i+1) (by omega) (SmallintsCounter.advanced_counter middle i)
        (KeygenResidueLoop.advanced_inputs arrays middle i hm)
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      have normal := (KeygenResidueTrace.source_iteration arrays before ⟨after,.returned (some value)⟩ i hi counter inputs iteration).1
      cases normal

theorem conversion_counter (arrays : KeygenResidueTrace.Arrays) (before : State)
    (old : Option C99IntegerReference.Value) (out : Result)
    (counter : before.locals "u".toList=some (.uint64,old)) (inputs : KeygenResidueTrace.Inputs arrays before)
    (source : Exec KeygenResidueProgram.code before out) : C99CountedWords.Counter out.state 1536 := by
  obtain ⟨middle,head,tail⟩ := KeygenNttControl.seq_inv _ _ before out (by decide) source
  have loop := C99ModularReference.continuation _ _ before (KeygenCheckLoopBridge.ready before) ⟨middle,.normal⟩
    (fun result execution => KeygenCheckLoopBridge.initial_result before old result counter execution) head
  rw [C99ModularReference.skip_result middle out tail]
  exact loop_counter arrays _ _ ⟨middle,.normal⟩ loop rfl 0 (by decide) (KeygenCheckLoopBridge.ready_counter before)
    (KeygenResidueLoop.ready_inputs arrays before inputs)

theorem bounds_wide (v : Fin 4 → Geometry.Vec) (bounded : KeygenSolverEquation.Bounds v) :
    ∀ slot, KeygenIntegerLift.Bound (v slot) 2047 := by
  intro slot
  fin_cases slot
  · intro i; obtain ⟨ha,hb⟩ := bounded.1 i; exact ⟨ha.trans (by decide),hb.trans (by decide)⟩
  · intro i; obtain ⟨ha,hb⟩ := bounded.2.1 i; exact ⟨ha.trans (by decide),hb.trans (by decide)⟩
  · exact bounded.2.2.1
  · exact bounded.2.2.2

theorem generated_converted_checked (s : State) (generated : Result) (scratch rev : ArrayPointer) (p0i : BitVec 32)
    (generationEntry : KeygenMkgm3.Entry s p0i scratch rev)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (generation : Exec KeygenMkgm3Program.code s generated)
    (arrays : KeygenResidueTrace.Arrays) (conversionEntry : State) (converted : Result)
    (sameGenerationHeap : conversionEntry.heap=generated.state.heap)
    (layout : KeygenResidueRanges.Layout arrays scratch)
    (inputWidth : ∀ slot, (arrays.input slot).elementBytes=2)
    (separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (arrays.input slot) 3072 scratch
      (KeygenMkgm3Frame.objectBytes scratch))
    (old : Option C99IntegerReference.Value)
    (counter : conversionEntry.locals "u".toList=some (.uint64,old))
    (inputs : KeygenResidueTrace.Inputs arrays conversionEntry)
    (caller : KeygenSolverNttCalls.Caller conversionEntry p0i (gm scratch))
    (declared : KeygenNttButterflyCalls.U32Declared conversionEntry "r")
    (conversion : Exec KeygenResidueProgram.code conversionEntry converted)
    (v : Fin 4 → Geometry.Vec)
    (represented : ∀ slot, KeygenMaterial.Represents s.heap (arrays.input slot) (v slot))
    (bounded : KeygenSolverEquation.Bounds v)
    (transformed : State) (out : Result)
    (transforms : KeygenSolverNttCalls.Exec KeygenSolverNttCalls.code converted.state transformed)
    (validation : Exec KeygenSolverTarget.code transformed out) (success : out.flow=.returned (some (.int32 1))) :
    KeygenSolverEquation.Equation v ∧ ∀ slot, KeygenMaterial.Represents out.state.heap (arrays.input slot) (v slot) := by
  have gen := KeygenMkgm3.source_contract s generated p0i scratch rev generationEntry initialization generation
  have legal := generationEntry.2.2.2.2.2.2.2
  have count : scratch.index≤scratch.count := by have := legal.2.2.1; omega
  have table : KeygenMkgm3Table.Initialized conversionEntry.heap (gm scratch) := by
    rw [sameGenerationHeap]; exact gen.2.1
  have convertedTable := KeygenMkgm3Table.overwritten_table arrays scratch layout conversionEntry old converted
    counter inputs table conversion
  have materialBefore (slot : Fin 4) : KeygenMaterial.Represents conversionEntry.heap (arrays.input slot) (v slot) := by
    rw [sameGenerationHeap]
    exact KeygenMkgm3Frame.source_material s generated scratch (arrays.input slot) legal.1 count
      (inputWidth slot) generationEntry.2.2.2.2.1 (separate slot) (v slot) (represented slot) generation
  have isolated := KeygenMkgm3Layout.input_separation arrays scratch layout
    (fun slot => KeygenMkgm3.prefix_separate s.heap scratch (arrays.input slot) legal (separate slot)) inputWidth
  have vectors := KeygenResidueVectors.source_vectors arrays scratch layout isolated conversionEntry old converted
    counter inputs v materialBefore (bounds_wide v bounded) conversion
  have conversionControl := KeygenNttControl.frame _ conversionEntry converted (by decide) conversion
  have trace := KeygenResidueLoop.source_trace arrays conversionEntry old converted counter inputs conversion
  have callerOut : KeygenSolverNttCalls.Caller converted.state p0i (gm scratch) :=
    ⟨(conversionControl.2.1 _ (by decide)).trans caller.logn,
      (conversionControl.2.1 _ (by decide)).trans caller.prime,
      (conversionControl.2.1 _ (by decide)).trans caller.inverse,
      (congrFun trace.2.2.1 _).trans caller.table⟩
  have bindings : KeygenSolverTransforms.Bindings converted.state scratch := by
    intro slot
    have ptr : arrays.output slot=output scratch slot := layout.2 slot
    rw [← ptr]
    exact trace.2.1.output slot
  have convertedInputs (slot : Fin 4) : KeygenResidueVectors.Represents converted.state.heap (output scratch slot) (v slot) := by
    have ptr : arrays.output slot=output scratch slot := layout.2 slot
    rw [← ptr]; exact vectors slot
  have uc := conversion_counter arrays conversionEntry old converted counter inputs conversion
  obtain ⟨oldr,rslot⟩ := declared
  have rc : KeygenNttButterflyCalls.U32Declared converted.state "r" :=
    ⟨oldr,(conversionControl.2.1 _ (by decide)).trans rslot⟩
  refine ⟨KeygenSolverTarget.transformed_checked converted.state transformed out scratch p0i v legal.1
    callerOut bindings trace.2.1.size ⟨some (.uint64 1536),uc⟩ rc convertedInputs convertedTable bounded
    initialization transforms validation success,?_⟩
  have materialConverted := (KeygenMkgm3.source_then_overwrite s generated p0i scratch rev generationEntry initialization
    generation arrays conversionEntry converted sameGenerationHeap layout inputWidth separate old counter inputs conversion v represented).2
  have frame := sequence_frame [0,1,2,3] converted.state transformed scratch p0i legal.1 callerOut bindings
    (by rw [KeygenSolverTransforms.four_code]; exact transforms)
  have finalHeap := read_only_heap _ transformed out (by decide) validation
  intro slot
  rw [finalHeap]
  exact KeygenNttMemoryFrame.material_preserved _ _ scratch (arrays.input slot) (v slot) legal.1 count
    (inputWidth slot) (separate slot) frame (materialConverted slot)

end FT1536.Source3.KeygenSolverValidation
