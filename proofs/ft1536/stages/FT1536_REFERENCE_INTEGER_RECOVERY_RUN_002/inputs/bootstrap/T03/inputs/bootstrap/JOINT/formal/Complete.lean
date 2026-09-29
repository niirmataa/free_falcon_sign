import Product
import Rho
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global
open FT1536Composition (product subtract canonical)

theorem L_NTT (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) (hc : CanonVec c) :
    pipelineC h r c=(product h r,subtract (product h r) c) :=
  L_NTT_pending_forward forward_product h r c hh hr hc

theorem L_NTT_p (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) (hc : CanonVec c) :
    (pipelineC h r c).1=product h r := by rw [L_NTT h r c hh hr hc]
theorem L_NTT_d (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) (hc : CanonVec c) :
    (pipelineC h r c).2=subtract (product h r) c := by rw [L_NTT h r c hh hr hc]
theorem product_range (h r : Vec) : CanonVec (product h r) := by
  intro i
  change 0≤FT1536Composition.productCoefficient h r i%18433 ∧ FT1536Composition.productCoefficient h r i%18433<18433
  omega
theorem subtract_range (a b : Vec) : CanonVec (subtract a b) := by
  intro i; unfold CanonVal subtract; omega
theorem L_NTT_ranges (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) (hc : CanonVec c) :
    CanonVec (pipelineC h r c).1 ∧ CanonVec (pipelineC h r c).2 := by
  rw [L_NTT h r c hh hr hc]
  exact ⟨product_range h r,subtract_range _ _⟩

theorem toMontC_range (v : Vec) : CanonVec (toMontC v) := by
  rw [toMontC_eq]
  intro i; unfold CanonVal FT1536Composition.toMont; omega
theorem montPointC_range (a b : Vec) : CanonVec (montPointC a b) := by
  rw [montPointC_eq]
  exact montPoint_canonical a b
theorem subtractC_range (a b : Vec) : CanonVec (subtractC a b) := by
  rw [subtractC_eq]; exact subtract_range a b

theorem point_prefix_range (op : Nat → Int → Int)
    (hop : ∀ i, i<1536 → ∀ x, CanonVal x → CanonVal (op i x))
    (n : Nat) (_hn : n≤1536) (v : Vec) (hv : CanonVec v) :
    CanonMem (runSteps (pointStep op) n (fromVec v)) := by
  intro i hi
  rw [point_prefix]
  split
  · exact hop i hi _ (fromVec_canonical v hv i hi)
  · exact fromVec_canonical v hv i hi
theorem point_read_bound (n i : Nat) (hn : n≤1536) (hi : i<n) : i<1536 := by omega

theorem pipeline_intermediate_ranges (h r c : Vec) (hh : CanonVec h) (hr : CanonVec r) (_hc : CanonVec c) :
    let H0:=forwardC h;let H:=toMontC H0;let a0:=forwardC r
    let a1:=montPointC a0 H;let p:=inverseC a1
    CanonVec H0 ∧ CanonVec H ∧ CanonVec a0 ∧ CanonVec a1 ∧ CanonVec p ∧ CanonVec (subtractC p c) := by
  dsimp only
  exact ⟨forwardC_canonical h hh,toMontC_range _,forwardC_canonical r hr,montPointC_range _ _,
    inverseC_canonical _ (montPointC_range _ _),subtractC_range _ _⟩

def rhoVec (s : Vec) : Vec := fun i => FT1536.rhoWord (s i)
theorem rhoVec_eq (s : Vec) (hs : ∀ i, FT1536.InInt16 (s i)) : rhoVec s=canonical s := by
  funext i
  exact (FT1536.rho_contract (s i) (hs i)).1
theorem rhoVec_range (s : Vec) (hs : ∀ i, FT1536.InInt16 (s i)) : CanonVec (rhoVec s) := by
  rw [rhoVec_eq s hs]; exact canonicalVec s

theorem L_NTT_rho (h s c : Vec) (hh : CanonVec h) (hs : ∀ i, FT1536.InInt16 (s i)) (hc : CanonVec c) :
    pipelineC h (rhoVec s) c=(product h s,subtract (product h s) c) := by
  rw [L_NTT h (rhoVec s) c hh (rhoVec_range s hs) hc,rhoVec_eq s hs]
  have hp:=product_canonical_inputs h s
  rw [canonical_fixed h hh] at hp
  rw [hp]
theorem L_NTT_rho_ranges (h s c : Vec) (hh : CanonVec h) (hs : ∀ i, FT1536.InInt16 (s i)) (hc : CanonVec c) :
    CanonVec (pipelineC h (rhoVec s) c).1 ∧ CanonVec (pipelineC h (rhoVec s) c).2 :=
  L_NTT_ranges h (rhoVec s) c hh (rhoVec_range s hs) hc

#check @L_NTT
#check @L_NTT_p
#check @L_NTT_d
#check @L_NTT_ranges
#check @pipeline_intermediate_ranges
#check @L_NTT_rho
#check @L_NTT_rho_ranges
#print axioms L_NTT
#print axioms L_NTT_p
#print axioms L_NTT_d
#print axioms product_range
#print axioms subtract_range
#print axioms L_NTT_ranges
#print axioms toMontC_range
#print axioms montPointC_range
#print axioms subtractC_range
#print axioms point_prefix_range
#print axioms point_read_bound
#print axioms pipeline_intermediate_ranges
#print axioms rhoVec_eq
#print axioms rhoVec_range
#print axioms L_NTT_rho
#print axioms L_NTT_rho_ranges
end FT1536Forward
