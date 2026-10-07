import Source3.KeygenNttTransform
import Source3.KeygenNttEvaluation
import Source3.KeygenCheckLoopBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The validation-to-integer seam. Images and coefficient bounds are local
   inputs here; enclosing source executions must discharge them. In particular
   this helper is not a theorem about the complete solve_NTRU call. -/
namespace FT1536.Source3.KeygenSolverEquation
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec)
open KeygenNttWordAlgebra (R value)
open KeygenNttPolynomial (castVec)
open KeygenNttEvaluation (evaluate)
open KeygenNttTransform (Image)
open KeygenSmallOutput (element)
open FT1536.Run2.CoefficientQuotient

def arrays (p : Fin 4 → ArrayPointer) : KeygenFinalCheck.Arrays := ⟨p 0,p 1,p 2,p 3⟩
def Images (heap : Memory) (p : Fin 4 → ArrayPointer) (v : Fin 4 → Geometry.Vec) : Prop :=
  ∀ slot, Image heap (p slot) (v slot)
def Bounds (v : Fin 4 → Geometry.Vec) : Prop :=
  KeygenIntegerLift.Bound (v 0) 1 ∧ KeygenIntegerLift.Bound (v 1) 1 ∧
  KeygenIntegerLift.Bound (v 2) 2047 ∧ KeygenIntegerLift.Bound (v 3) 2047
def Equation (v : Fin 4 → Geometry.Vec) : Prop :=
  multiply (v 0) (v 3)-multiply (v 1) (v 2)=constantCoeffs (18433 : Int)

theorem image_read (heap : Memory) (p : ArrayPointer) (v : Geometry.Vec) (i : Fin 1536)
    (word : BitVec 32) (image : Image heap p v) (read : Load32 heap (element p i.val) word) :
    KeygenNttButterflyAlgebra.Canonical word ∧ value word=evaluate (castVec v) i :=
  KeygenNttCells.read_cell heap (element p i.val) _ word (image i) read

theorem images_canonical (heap : Memory) (p : Fin 4 → ArrayPointer) (v : Fin 4 → Geometry.Vec)
    (images : Images heap p v) : KeygenFinalCheck.Canonical (arrays p) heap := by
  intro j hj ptr member word read
  have choices : ptr=p 0 ∨ ptr=p 1 ∨ ptr=p 2 ∨ ptr=p 3 := by
    simpa only [arrays,List.mem_cons,List.not_mem_nil,or_false] using member
  rcases choices with rfl | rfl | rfl | rfl
  all_goals exact (image_read heap _ _ ⟨j,hj⟩ word (images _) read).1

theorem checked_pointwise (p : Fin 4 → ArrayPointer) (v : Fin 4 → Geometry.Vec)
    (before : State) (out : Result) (p0i target : BitVec 32) (old : Option C99IntegerReference.Value)
    (counter : before.locals "u".toList=some (.uint64,old))
    (inputs : KeygenCheckExpression.Inputs (arrays p) p0i target before)
    (images : Images before.heap p v)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (targetCall : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (source : Exec KeygenCheckProgram.code before out) (success : out.flow=.returned (some (.int32 1))) :
    ∀ i, evaluate (castVec (v 0)) i*evaluate (castVec (v 3)) i-
      evaluate (castVec (v 1)) i*evaluate (castVec (v 2)) i=(18433 : R) := by
  intro i
  obtain ⟨a,b,bigF,bigG,ra,rb,rF,rG,equation⟩ := KeygenCheckLoopBridge.accepted_coordinates
    (arrays p) before p0i target old out counter inputs (images_canonical before.heap p v images)
    initialization targetCall source success i.val i.isLt
  have va := (image_read before.heap (p 0) (v 0) i a (images 0) ra).2
  have vb := (image_read before.heap (p 1) (v 1) i b (images 1) rb).2
  have vF := (image_read before.heap (p 2) (v 2) i bigF (images 2) rF).2
  have vG := (image_read before.heap (p 3) (v 3) i bigG (images 3) rG).2
  have field := (ZMod.natCast_eq_natCast_iff' _ _ 2147355649).mpr equation
  have sum : value a*value bigG=(18433 : R)+value b*value bigF := by
    simpa only [value,Nat.cast_mul,Nat.cast_add,Nat.cast_ofNat] using field
  rw [va,vb,vF,vG] at sum
  exact sub_eq_iff_eq_add.mpr sum

theorem cast_multiply (v w : Geometry.Vec) :
    castVec (multiply v w)=multiply (castVec v) (castVec w) := by
  apply toQuot_injective R
  change toQuot (mapCoeffs (Int.castRingHom R) (multiply v w))=_
  rw [← quotientMap_toQuot,toQuot_multiply,map_mul,quotientMap_toQuot,
    quotientMap_toQuot,toQuot_multiply]
  rfl

theorem cast_sub (v w : Geometry.Vec) : castVec (v-w)=castVec v-castVec w := by
  funext i
  apply Prod.ext <;> simp [castVec]

theorem cast_constant (z : Int) : castVec (constantCoeffs z)=constantCoeffs (z : R) := by
  funext i
  by_cases hi : i=0 <;> simp [castVec,constantCoeffs,hi]

theorem residual_zero (v : Fin 4 → Geometry.Vec)
    (pointwise : ∀ i, evaluate (castVec (v 0)) i*evaluate (castVec (v 3)) i-
      evaluate (castVec (v 1)) i*evaluate (castVec (v 2)) i=(18433 : R)) :
    mapCoeffs (Int.castRingHom R) (KeygenIntegerLift.residual (v 0) (v 1) (v 2) (v 3))=0 := by
  have equation := KeygenNttEvaluation.equation_of_pointwise _ _ _ _ 18433 pointwise
  change castVec (KeygenIntegerLift.residual (v 0) (v 1) (v 2) (v 3))=0
  rw [KeygenIntegerLift.residual,cast_sub,cast_sub,cast_multiply,cast_multiply,cast_constant]
  simpa only [Int.cast_ofNat,sub_self] using congrArg (fun x => x-constantCoeffs (18433 : R)) equation

theorem exact_of_images (p : Fin 4 → ArrayPointer) (v : Fin 4 → Geometry.Vec)
    (before : State) (out : Result) (p0i target : BitVec 32) (old : Option C99IntegerReference.Value)
    (counter : before.locals "u".toList=some (.uint64,old))
    (inputs : KeygenCheckExpression.Inputs (arrays p) p0i target before)
    (images : Images before.heap p v) (bounded : Bounds v)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (targetCall : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (source : Exec KeygenCheckProgram.code before out) (success : out.flow=.returned (some (.int32 1))) :
    Equation v := by
  exact KeygenIntegerLift.exact_ntru_of_modular_check _ _ _ _ bounded.1 bounded.2.1 bounded.2.2.1
    bounded.2.2.2 (residual_zero v (checked_pointwise p v before out p0i target old counter inputs images
      initialization targetCall source success))

end FT1536.Source3.KeygenSolverEquation
