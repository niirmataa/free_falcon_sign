import StoredInterface018
import TableWidths017

namespace FT1536.S05.WordBounds018
open FT1536.Geometry FT1536.PublicSimulation FT1536.Run2 FT1536.Relation

/-- Applies to the entire enclosing box, including all rejected proposals. -/
theorem coordinate_bounds (x : Fin 131071) :
    -(65535 : ℤ)≤(x.val : ℤ)-65535 ∧ (x.val : ℤ)-65535≤65535 := by
  have hx := x.isLt
  omega

theorem block_bound (x y : Fin 131071) :
    0≤block ((x.val : ℤ)-65535) ((y.val : ℤ)-65535) ∧
    block ((x.val : ℤ)-65535) ((y.val : ℤ)-65535)≤3*65535^2 := by
  constructor
  · exact block_nonneg _ _
  · have hx := coordinate_bounds x
    have hy := coordinate_bounds y
    have hxx := mul_nonneg (show 0≤65535-((x.val : ℤ)-65535) by omega)
      (show 0≤65535+((x.val : ℤ)-65535) by omega)
    have hyy := mul_nonneg (show 0≤65535-((y.val : ℤ)-65535) by omega)
      (show 0≤65535+((y.val : ℤ)-65535) by omega)
    unfold block
    nlinarith [sq_nonneg (((x.val : ℤ)-65535)-((y.val : ℤ)-65535))]

theorem half_norm_bound (v : BoxVec) : 0≤Q0 (decodeVec v) ∧ Q0 (decodeVec v)≤768*(3*65535^2) := by
  constructor
  · exact Finset.sum_nonneg (fun i _ => (block_bound (v i).1 (v i).2).1)
  · calc
      _ ≤ ∑ _i : Fin 768,(3*(65535 : ℤ)^2) :=
        Finset.sum_le_sum (fun i _ => (block_bound (v i).1 (v i).2).2)
      _ = _ := by simp

theorem norm_width (v : BoxPair) : 0≤Q (decode v) ∧ Q (decode v)<2^45 := by
  have ha := half_norm_bound v.1
  have hb := half_norm_bound v.2
  change 0≤Q0 (decodeVec v.1)+Q0 (decodeVec v.2) ∧ _
  change _ ∧ Q0 (decodeVec v.1)+Q0 (decodeVec v.2)<2^45
  omega

attribute [local irreducible] TableData016.cdf

theorem cdf_width (i : SamplerCode016.CoordIndex) : ActualTables016.tables.cdf i<2^268 := by
  have hm := CDFProbability017.cdf_monotone ActualInterface017.actual_rows
  have hi : i≤(⟨30720,by decide⟩ : SamplerCode016.CoordIndex) := by
    change i.val≤30720
    have := i.isLt
    omega
  exact (hm hi).trans_lt TableWidths017.total_cdf_width.2

theorem threshold_width (i : SamplerCode016.PairIndex) : ActualTables016.tables.threshold i<2^257 :=
  TableWidths017.threshold_storage_bound ActualInterface017.actual_rows i

theorem tape_address_width (i : Fin 24662538240) : i.val<2^35 := by
  have := i.isLt
  omega

theorem full_tape_bytes : 24662538240=8*3082817280 := by norm_num

/-- Width of a field product before modular reduction; no unbounded field
    multiplication is hidden in this particular width bound. -/
theorem field_product_width (a b : ZMod 18433) : a.val*b.val<2^29 := by
  have ha := ZMod.val_lt a
  have hb := ZMod.val_lt b
  nlinarith

theorem field_add_width (a b : ZMod 18433) : a.val+b.val<2^16 := by
  have ha := ZMod.val_lt a
  have hb := ZMod.val_lt b
  omega

#print axioms coordinate_bounds
#print axioms block_bound
#print axioms half_norm_bound
#print axioms norm_width
#print axioms cdf_width
#print axioms threshold_width
#print axioms tape_address_width
#print axioms full_tape_bytes
#print axioms field_product_width
#print axioms field_add_width
end FT1536.S05.WordBounds018
