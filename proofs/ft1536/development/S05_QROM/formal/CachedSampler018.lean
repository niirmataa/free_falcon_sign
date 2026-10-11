import BinaryCDF018
import CapMap018
import Init.Data.Vector.OfFn

set_option maxRecDepth 8192
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
namespace FT1536.S05.CachedSampler018
open FT1536.Geometry FT1536.PublicSimulation FT1536.Run2
open SamplerCode016 CapExecution016

abbrev CachedBox := Vector Block 768 × Vector Block 768
def view (v : CachedBox) : BoxPair := (fun i => v.1[i.val],fun i => v.2[i.val])
def save (v : BoxPair) : CachedBox := (Vector.ofFn v.1,Vector.ofFn v.2)

theorem view_save (v : BoxPair) : view (save v)=v := by
  apply Prod.ext <;> funext i <;> simp [view,save]

def pairTrial (t : Tables) (coins : PairBits) : Option Block :=
  let x := BinaryCDF018.coord t coins.1
  let y := BinaryCDF018.coord t coins.2.1
  if (BitTapes016.word 256 coins.2.2).val<t.threshold ⟨x.val+y.val,by have := x.isLt; have := y.isLt; omega⟩
    then some (embedCoord x,embedCoord y) else none

def pair (t : Tables) (coins : PairSeed) : Block :=
  (first (pairTrial t) 80 coins).getD zeroBlock

def vector (t : Tables) (coins : VectorSeed) : CachedBox :=
  (Vector.ofFn (fun i => pair t (coins.1 i)),Vector.ofFn (fun i => pair t (coins.2 i)))

def normTrial (t : Tables) (coins : VectorSeed) : Option CachedBox :=
  let v := vector t coins
  if Q (decode (view v))<B then some v else none

def cube (coins : CubeSeed) : CachedBox := save (SamplerCode016.cube coins)

def selected (t : Tables) (coins : Seed) : CachedBox :=
  match first (normTrial t) 196 coins.1 with
  | some v => v
  | none => cube coins.2

attribute [local irreducible] BinaryCDF018.coord SamplerCode016.coord

theorem pairTrial_eq (t : Tables) (hc : Monotone t.cdf) (hS : 0<t.cdf ⟨30720,by decide⟩) :
    pairTrial t=SamplerCode016.pairTrial t := by
  funext coins
  unfold pairTrial SamplerCode016.pairTrial
  simp only [BinaryCDF018.coord_eq_linear t hc hS]

attribute [local irreducible] first

theorem pair_eq (t : Tables) (hc : Monotone t.cdf) (hS : 0<t.cdf ⟨30720,by decide⟩)
    (coins : PairSeed) : pair t coins=SamplerCode016.pair t coins := by
  unfold pair SamplerCode016.pair
  rw [pairTrial_eq t hc hS]

theorem vector_eq (t : Tables) (hc : Monotone t.cdf) (hS : 0<t.cdf ⟨30720,by decide⟩)
    (coins : VectorSeed) : view (vector t coins)=SamplerCode016.vector t coins := by
  apply Prod.ext <;> funext i <;> simp only [view,vector,Vector.getElem_ofFn,SamplerCode016.vector]
  · exact pair_eq t hc hS _
  · exact pair_eq t hc hS _

theorem normTrial_eq (t : Tables) (hc : Monotone t.cdf) (hS : 0<t.cdf ⟨30720,by decide⟩)
    (coins : VectorSeed) : Option.map view (normTrial t coins)=SamplerCode016.normTrial t coins := by
  unfold normTrial SamplerCode016.normTrial
  dsimp only
  simp only [vector_eq t hc hS]
  split <;> simp [vector_eq t hc hS]

theorem cube_eq (coins : CubeSeed) : view (cube coins)=SamplerCode016.cube coins :=
  view_save _

theorem selected_eq (t : Tables) (hc : Monotone t.cdf) (hS : 0<t.cdf ⟨30720,by decide⟩)
    (coins : Seed) : view (selected t coins)=SamplerCode016.selected t coins := by
  have hh := CapMap018.first_map (normTrial t) view 196 coins.1
  have htrial : (fun c => Option.map view (normTrial t c))=SamplerCode016.normTrial t :=
    funext (normTrial_eq t hc hS)
  rw [htrial] at hh
  unfold selected SamplerCode016.selected
  rw [←hh]
  generalize hx : first (normTrial t) 196 coins.1=x
  cases x <;> simp only [Option.map_none,Option.map_some]
  · exact cube_eq coins.2

theorem actual_selected_eq (coins : Seed) :
    view (selected ActualTables016.tables coins)=SamplerCode016.selected ActualTables016.tables coins :=
  selected_eq _ (CDFProbability017.cdf_monotone ActualInterface017.actual_rows)
    ActualTables016.last_cdf_positive coins

#print axioms view_save
#print axioms pairTrial_eq
#print axioms pair_eq
#print axioms vector_eq
#print axioms normTrial_eq
#print axioms cube_eq
#print axioms selected_eq
#print axioms actual_selected_eq
end FT1536.S05.CachedSampler018
