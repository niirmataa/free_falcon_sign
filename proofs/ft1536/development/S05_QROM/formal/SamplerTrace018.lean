import Meter018
import StoredInterface018

set_option maxRecDepth 8192
/- Weighted call/event trace, not total machine cost. The weights are free
   nonnegative counters/prices. Calibrating all arithmetic, storage, address
   computation and backend overhead remains a distinct Q-RESC obligation. -/
namespace FT1536.S05.SamplerTrace018
open SamplerCode016 BitTapes016

structure Weights where
  bitRead : ℕ
  cdfRead : ℕ
  pairTrial : ℕ
  capStep : ℕ
  capStop : ℕ
  storePair : ℕ
  normBlock : ℕ
  cubeCoord : ℕ
  productPair : ℕ
  scatterUpdate : ℕ
  outputCell : ℕ

def trial (w : Weights) (t : Tables) (coins : PairBits) : Meter018.Run (Option Block) :=
  (CachedSampler018.pairTrial t coins,
    1024*w.bitRead+((BinaryCDF018.coordRun t coins.1).2+
      (BinaryCDF018.coordRun t coins.2.1).2+2)*w.cdfRead+w.pairTrial)

def trialBudget (w : Weights) : ℕ := 1024*w.bitRead+32*w.cdfRead+w.pairTrial

theorem trial_bound (w : Weights) (t : Tables) (coins : PairBits) :
    (trial w t coins).2≤trialBudget w := by
  have hx := BinaryCDF018.coord_probes t coins.1
  have hy := BinaryCDF018.coord_probes t coins.2.1
  unfold trial trialBudget
  dsimp only
  nlinarith

def pair (w : Weights) (t : Tables) (coins : PairSeed) : Meter018.Run Block :=
  let p := Meter018.first (trial w t) w.capStep w.capStop 80 coins
  (p.1.getD zeroBlock,p.2)

def pairBudget (w : Weights) : ℕ := 80*(trialBudget w+w.capStep)+w.capStop

attribute [local irreducible] CapExecution016.first

theorem pair_value (w : Weights) (t : Tables) (coins : PairSeed) :
    (pair w t coins).1=CachedSampler018.pair t coins := by
  unfold pair CachedSampler018.pair
  simp only [Meter018.first_value,trial]

theorem pair_bound (w : Weights) (t : Tables) (coins : PairSeed) :
    (pair w t coins).2≤pairBudget w :=
  Meter018.first_bound _ _ _ _ (trial_bound w t) _ _

def vector (w : Weights) (t : Tables) (coins : VectorSeed) : Meter018.Run CachedSampler018.CachedBox :=
  let a := Meter018.vector (fun i => pair w t (coins.1 i)) w.storePair
  let b := Meter018.vector (fun i => pair w t (coins.2 i)) w.storePair
  ((a.1,b.1),a.2+b.2)

def vectorBudget (w : Weights) : ℕ := 1536*(pairBudget w+w.storePair)

theorem vector_value (w : Weights) (t : Tables) (coins : VectorSeed) :
    (vector w t coins).1=CachedSampler018.vector t coins := by
  simp only [vector,Meter018.vector,CachedSampler018.vector,pair_value]

theorem vector_bound (w : Weights) (t : Tables) (coins : VectorSeed) :
    (vector w t coins).2≤vectorBudget w := by
  have ha := Meter018.vector_bound (fun i => pair w t (coins.1 i)) w.storePair _
    (fun i => pair_bound w t (coins.1 i))
  have hb := Meter018.vector_bound (fun i => pair w t (coins.2 i)) w.storePair _
    (fun i => pair_bound w t (coins.2 i))
  change _+_≤1536*(pairBudget w+w.storePair)
  omega

def normTrial (w : Weights) (t : Tables) (coins : VectorSeed) : Meter018.Run (Option CachedSampler018.CachedBox) :=
  let v := vector w t coins
  (if FT1536.Geometry.Q (FT1536.PublicSimulation.decode (CachedSampler018.view v.1))<FT1536.Geometry.B
    then some v.1 else none,v.2+1536*w.normBlock)

def normBudget (w : Weights) : ℕ := vectorBudget w+1536*w.normBlock

theorem norm_value (w : Weights) (t : Tables) (coins : VectorSeed) :
    (normTrial w t coins).1=CachedSampler018.normTrial t coins := by
  simp only [normTrial,vector_value,CachedSampler018.normTrial]

theorem norm_bound (w : Weights) (t : Tables) (coins : VectorSeed) :
    (normTrial w t coins).2≤normBudget w := Nat.add_le_add_right (vector_bound w t coins) _

def cubeBudget (w : Weights) : ℕ := 30720*w.bitRead+3072*w.cubeCoord+1536*w.storePair

def selected (w : Weights) (t : Tables) (coins : Seed) : Meter018.Run CachedSampler018.CachedBox :=
  let p := Meter018.first (normTrial w t) w.capStep w.capStop 196 coins.1
  match p.1 with
  | some v => (v,p.2)
  | none => (CachedSampler018.cube coins.2,p.2+cubeBudget w)

def selectedBudget (w : Weights) : ℕ := 196*(normBudget w+w.capStep)+w.capStop+cubeBudget w

attribute [local irreducible] Meter018.first normTrial CachedSampler018.normTrial selected CachedSampler018.selected

theorem selected_value (w : Weights) (t : Tables) (coins : Seed) :
    (selected w t coins).1=CachedSampler018.selected t coins := by
  have hv := Meter018.first_value (normTrial w t) w.capStep w.capStop 196 coins.1
  have he : (fun c => (normTrial w t c).1)=CachedSampler018.normTrial t := funext (norm_value w t)
  rw [he] at hv
  unfold selected CachedSampler018.selected
  dsimp only
  rw [hv]
  cases hx : CapExecution016.first (CachedSampler018.normTrial t) 196 coins.1 <;> rfl

theorem selected_bound (w : Weights) (t : Tables) (coins : Seed) :
    (selected w t coins).2≤selectedBudget w := by
  have hb := Meter018.first_bound (normTrial w t) w.capStep w.capStop (normBudget w)
    (norm_bound w t) 196 coins.1
  unfold selected selectedBudget
  dsimp only
  split <;> dsimp only <;> omega

def run (w : Weights) (h : StoredInterface018.Key) (coins : Seed) : Meter018.Run StoredInterface018.Output :=
  let z := selected w ActualTables016.tables coins
  ((StoredInterface018.challenge h z.1,z.1.2),z.2+
    Scatter018.pairVisits*w.productPair+Scatter018.updateVisits*w.scatterUpdate+3072*w.outputCell)

def budget (w : Weights) : ℕ := selectedBudget w+
  2359296*w.productPair+4718592*w.scatterUpdate+3072*w.outputCell

theorem run_value (w : Weights) (h : StoredInterface018.Key) (coins : Seed) :
    (run w h coins).1=StoredInterface018.run h coins := by
  simp only [run,selected_value,StoredInterface018.run]

theorem run_bound (w : Weights) (h : StoredInterface018.Key) (coins : Seed) :
    (run w h coins).2≤budget w := by
  have hs := selected_bound w ActualTables016.tables coins
  have hu := Scatter018.update_visits_bound
  unfold run budget
  simp only [Scatter018.pair_visits]
  nlinarith

#print axioms trial_bound
#print axioms pair_value
#print axioms pair_bound
#print axioms vector_value
#print axioms vector_bound
#print axioms norm_value
#print axioms norm_bound
#print axioms selected_value
#print axioms selected_bound
#print axioms run_value
#print axioms run_bound
end FT1536.S05.SamplerTrace018
