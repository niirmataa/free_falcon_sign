import ForwardProgress
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000
namespace FT1536Global
open FT1536Composition

def toMontC (v : Vec) : Vec :=
  toVec (runSteps (pointStep (fun _ x => mmQ x 4564)) 1536 (fromVec v))
def montPointC (a b : Vec) : Vec :=
  toVec (runSteps (pointStep (fun i x => mmQ x (fromVec b i))) 1536 (fromVec a))
def subtractC (a b : Vec) : Vec :=
  toVec (runSteps (pointStep (fun i x => subQ x (fromVec b i))) 1536 (fromVec a))
def pipelineC (h r c : Vec) : Vec × Vec :=
  let H:=toMontC (forwardC h)
  let z:=montPointC (forwardC r) H
  let p:=inverseC z
  (p,subtractC p c)

theorem toMontC_eq (v : Vec) : toMontC v=toMont v := by
  funext i
  unfold toMontC toVec
  rw [point_prefix]
  simp only [i.isLt,↓reduceIte,fromVec,↓reduceDIte,mmQ,toMont]
  exact tomont_factor (v i)
theorem montPointC_eq (a b : Vec) : montPointC a b=montPoint a b := by
  funext i
  unfold montPointC toVec
  rw [point_prefix]
  simp only [i.isLt,↓reduceIte,fromVec,↓reduceDIte,mmQ,montPoint]
theorem subtractC_eq (a b : Vec) : subtractC a b=subtract a b := by
  funext i
  unfold subtractC toVec
  rw [point_prefix]
  simp only [i.isLt,↓reduceIte,fromVec,↓reduceDIte,subQ,subtract]
theorem montPoint_canonical (a b : Vec) : CanonVec (montPoint a b) := by
  intro i; unfold CanonVal montPoint; omega
theorem pipelineC_lift (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) :
    pipelineC h r c=pipeline liftForward liftInverse h r c := by
  unfold pipelineC pipeline
  rw [toMontC_eq,montPointC_eq,subtractC_eq,liftForward_agrees h hh,liftForward_agrees r hr,
    liftInverse_agrees _ (montPoint_canonical _ _)]

-- This is intentionally conditional. Only the still-open forward_product
-- remains; inverse_forward is the proved source-model theorem, not a parameter.
theorem L_NTT_pending_forward
    (forward_product : ∀ h r, liftForward (product h r)=pointMul (liftForward h) (liftForward r))
    (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) (_hc : CanonVec c) :
    pipelineC h r c=(product h r,subtract (product h r) c) := by
  rw [pipelineC_lift h r c hh hr]
  exact L_NTT_after_global_interfaces liftForward liftInverse forward_product inverse_forward h r c

#check @pipelineC_lift
#check @L_NTT_pending_forward
#print axioms toMontC_eq
#print axioms montPointC_eq
#print axioms subtractC_eq
#print axioms pipelineC_lift
#print axioms L_NTT_pending_forward
end FT1536Global
