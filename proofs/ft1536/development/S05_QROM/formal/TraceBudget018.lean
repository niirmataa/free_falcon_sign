import SamplerTrace018
import WordBounds018

namespace FT1536.S05.TraceBudget018
open SamplerTrace018

theorem expanded_budget (w : Weights) : budget w=
    24662538240*w.bitRead+770703360*w.cdfRead+24084480*w.pairTrial+
    24084676*w.capStep+301057*w.capStop+302592*w.storePair+
    301056*w.normBlock+3072*w.cubeCoord+2359296*w.productPair+
    4718592*w.scatterUpdate+3072*w.outputCell := by
  unfold budget selectedBudget normBudget vectorBudget pairBudget trialBudget cubeBudget
  ring

/-- This is a bound on accounted events, deliberately not CPU operations. -/
theorem weighted_event_bound (w : Weights) (h : StoredInterface018.Key) (coins : SamplerCode016.Seed) :
    (run w h coins).2≤
    24662538240*w.bitRead+770703360*w.cdfRead+24084480*w.pairTrial+
    24084676*w.capStep+301057*w.capStop+302592*w.storePair+
    301056*w.normBlock+3072*w.cubeCoord+2359296*w.productPair+
    4718592*w.scatterUpdate+3072*w.outputCell := by
  rw [←expanded_budget]
  exact run_bound w h coins

def bitWeights : Weights := ⟨1,0,0,0,0,0,0,0,0,0,0⟩
def cdfWeights : Weights := ⟨0,1,0,0,0,0,0,0,0,0,0⟩

theorem bits_bound (h : StoredInterface018.Key) (coins : SamplerCode016.Seed) :
    (run bitWeights h coins).2≤24662538240 := by
  have hh := weighted_event_bound bitWeights h coins
  simpa [bitWeights] using hh

theorem cdf_reads_bound (h : StoredInterface018.Key) (coins : SamplerCode016.Seed) :
    (run cdfWeights h coins).2≤770703360 := by
  have hh := weighted_event_bound cdfWeights h coins
  simpa [cdfWeights] using hh

/-- Empty cap, full exhaustion and early success have distinct event costs. -/
theorem empty_cap_control :
    Meter018.first (fun (_ : Bool) => (some (7 : ℕ),4)) 2 7 0 (fun i => Fin.elim0 i)=(none,7) := by decide +kernel

theorem exhaustion_control :
    Meter018.first (fun (_ : Bool) => ((none : Option ℕ),4)) 2 7 3 (fun _ => false)=(none,25) := by decide +kernel

theorem early_success_control :
    Meter018.first (fun b => (if b then some (7 : ℕ) else none,4)) 2 7 3 (fun _ => true)=(some 7,6) := by decide +kernel

theorem late_success_control :
    Meter018.first (fun b => (if b then some (7 : ℕ) else none,4)) 2 7 3 (fun i => decide (i.val=2))=(some 7,18) := by decide +kernel

theorem plateau_cdf_control : BinarySearch018.search (fun k => 2*(k/3)) 0 4 0 10=(3,4) := by decide +kernel

#print axioms expanded_budget
#print axioms weighted_event_bound
#print axioms bits_bound
#print axioms cdf_reads_bound
#print axioms empty_cap_control
#print axioms exhaustion_control
#print axioms early_success_control
#print axioms late_success_control
#print axioms plateau_cdf_control
end FT1536.S05.TraceBudget018
