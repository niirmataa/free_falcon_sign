import PublicTables016
import SamplerAC016

set_option maxRecDepth 8192
namespace FT1536.S05.ActualTables016
open FT1536.Relation FT1536.Run2 SamplerCode016

/- Actual public integer tables from the pinned003 JSON. Generated literal
   sources are reproducible assets, not Gaussian-analysis certificates. -/
def tables : Tables where
  cdf i := TableData016.cdf i.val
  threshold i := TableData016.threshold i.val

def actualSampler : Sampler := sampler tables

theorem first_cdf_positive : 0<tables.cdf ⟨0,by decide⟩ := by decide

theorem last_cdf_positive : 0<tables.cdf ⟨30720,by decide⟩ := by decide

theorem edge_threshold_zero : tables.threshold ⟨0,by decide⟩=0 := by decide

theorem actual_all_h_ac (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw actualSampler h st m r) (SigmaMath.freshHonest h) :=
  SamplerAC016.all_h_ac tables h st m r

theorem actual_no_none (h c : Rq) (st : State) (m : Bytes) (r : Nonce) :
    (samplerLaw actualSampler h st m r).mass (c,none)=0 :=
  SamplerAC016.no_none tables h c st m r

theorem actual_bits : actualSampler.bits=24662538240 := rfl

#print axioms first_cdf_positive
#print axioms last_cdf_positive
#print axioms edge_threshold_zero
#print axioms actual_all_h_ac
#print axioms actual_no_none
#print axioms actual_bits
end FT1536.S05.ActualTables016
