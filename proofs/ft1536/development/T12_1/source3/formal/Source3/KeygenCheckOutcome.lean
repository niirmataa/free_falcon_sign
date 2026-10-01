import Source3.KeygenCheckLoopBridge
import Source3.KeygenCheckExpressionSound
import Source3.C99ModularFrame
import Source3.KeygenCheckMutations

namespace FT1536.Source3.KeygenCheckOutcome
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenCheckExpression (Inputs)
open KeygenFinalCheck (Arrays)

theorem read_only : C99ModularFrame.readOnly KeygenCheckProgram.code=true := by decide

/- This suffix theorem keeps the transform range, initializer execution and
   entry bindings explicit. The full solver must derive them from its own
   prefix. In particular, these are not premises of emitted_to_actual_fiber. -/
theorem accepted (arrays : Arrays) (before : State) (p0i target : BitVec 32)
    (old : Option C99IntegerReference.Value) (result : Result)
    (slot : before.locals "u".toList=some (.uint64,old)) (inputs : Inputs arrays p0i target before)
    (canonical : KeygenFinalCheck.Canonical arrays before.heap)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (targetCall : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (source : C99ModularReference.Exec KeygenCheckProgram.code before result)
    (success : result.flow=.returned (some (.int32 1))) :
    C99ModularParser.region 7386 11=some KeygenCheckProgram.code ∧
    result.state.heap=before.heap ∧ result.state.arrays=before.arrays ∧
    ∀ j<1536, ∃ a b bigF bigG,
      Load32 result.state.heap (KeygenSmallOutput.element arrays.f j) a ∧
      Load32 result.state.heap (KeygenSmallOutput.element arrays.g j) b ∧
      Load32 result.state.heap (KeygenSmallOutput.element arrays.bigF j) bigF ∧
      Load32 result.state.heap (KeygenSmallOutput.element arrays.bigG j) bigG ∧
      (a.toNat*bigG.toNat)%KeygenNinv31.prime.toNat=(18433+b.toNat*bigF.toNat)%KeygenNinv31.prime.toNat := by
  have frame := C99ModularFrame.source_frame KeygenCheckProgram.code before result source read_only
  refine ⟨KeygenCheckProgram.source_bound,frame.1,frame.2,?_⟩
  rw [frame.1]
  exact KeygenCheckLoopBridge.accepted_coordinates arrays before p0i target old result slot inputs canonical
    initialization targetCall source success

end FT1536.Source3.KeygenCheckOutcome
