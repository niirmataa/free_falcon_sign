import GaussianLiterals017
import CDFSelection017
import CountProbability017
import Mathlib.Order.Fin.Basic

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.CDFProbability017
open Finset FT1536.Run2.FiberBinding SamplerCode016 CDFSelection017
open GaussianLiterals017 GaussianCheck017 CountProbability017 ModuloCounts017

noncomputable def coordLaw (t : Tables) : Law CoordIndex :=
  (Law.uniform : Law (BitTapes016.Bits 384)).map (coord t)

theorem cdf_monotone (rows : Rows) : Monotone ActualTables016.tables.cdf := by
  apply Fin.monotone_iff_le_succ.mpr
  intro i
  have hi : i.val+1 < 30721 := by have := i.isLt; omega
  have hh := (cdf_rows rows (i.val+1) hi).1.le
  have hn : i.val+1≠0 := by omega
  simpa only [previous,ite_eq_right hn,Nat.add_sub_cancel,ActualTables016.tables,Fin.val_castSucc,Fin.val_succ] using hh

theorem prior_actual (i : CoordIndex) : prior ActualTables016.tables.cdf i=previous i.val := by
  unfold prior previous
  split <;> rfl

theorem coord_mass_count (t : Tables) (hc : Monotone t.cdf)
    (hS : 0<t.cdf ⟨30720,by decide⟩) (i : CoordIndex) :
    (coordLaw t).mass i=
    (Nat.count (intervalMod (t.cdf ⟨30720,by decide⟩) (prior t.cdf i) (t.cdf i)) (2^384) : ℝ)/(2 : ℝ)^384 := by
  have hm := FT1536.Run2.CorrectnessProbability.map_event
    (Law.uniform : Law (BitTapes016.Bits 384)) (BitTapes016.word 384)
    (fun x : Fin (2^384) => intervalMod (t.cdf ⟨30720,by decide⟩) (prior t.cdf i) (t.cdf i) x.val)
  rw [BitTapes016.word_uniform,uniform_event_count] at hm
  norm_num only [Nat.cast_pow,Nat.cast_ofNat] at hm ⊢
  rw [coordLaw,map_mass]
  rw [hm]
  unfold Law.event
  apply sum_congr rfl
  intro b _
  have he := actual_coord_interval t hc hS b i
  change (if coord t b=i then _ else 0)=(if intervalMod _ _ _ (BitTapes016.word 384 b).val then _ else 0)
  simp only [he,intervalMod]
  rfl

theorem coord_probability_bounds (t : Tables) (hc : Monotone t.cdf)
    (hS : 0<t.cdf ⟨30720,by decide⟩) (i : CoordIndex) :
    (1-(t.cdf ⟨30720,by decide⟩ : ℝ)/2^384)*(t.cdf i-prior t.cdf i : ℕ)/t.cdf ⟨30720,by decide⟩≤(coordLaw t).mass i ∧
    (coordLaw t).mass i≤(1+(t.cdf ⟨30720,by decide⟩ : ℝ)/2^384)*(t.cdf i-prior t.cdf i : ℕ)/t.cdf ⟨30720,by decide⟩ := by
  rw [coord_mass_count t hc hS]
  have hb : t.cdf i≤t.cdf ⟨30720,by decide⟩ := hc (show i≤(⟨30720,by decide⟩ : CoordIndex) from by change i.val≤30720; have := i.isLt; omega)
  have hh := probability_bounds (2^384) (t.cdf ⟨30720,by decide⟩) (prior t.cdf i) (t.cdf i) (by positivity) hS hb
  norm_num only [Nat.cast_pow,Nat.cast_ofNat] at hh ⊢
  exact hh

noncomputable def A : ℝ := 2^256/(TableData016.cdf 30720 : ℝ)
noncomputable def beta : ℝ := 1/2^115
noncomputable def delta : ℝ := 1/2^108

theorem total_bounds : 0<(TableData016.cdf 30720 : ℝ) ∧
    (TableData016.cdf 30720 : ℝ)≤2723*2^256 := by
  constructor
  · exact_mod_cast ActualTables016.last_cdf_positive
  · exact_mod_cast total_cdf_cap

theorem bias_bound : (TableData016.cdf 30720 : ℝ)/2^384≤beta := by
  have hh := total_bounds.2
  unfold beta
  linarith

theorem scale_bounds : 1/2723≤A ∧ 0<A := by
  unfold A
  constructor
  · apply (div_le_div_iff₀ (by norm_num) total_bounds.1).mpr
    nlinarith [total_bounds.2]
  · exact div_pos (by positivity) total_bounds.1

theorem actual_coord_bounds (rows : Rows) (i : CoordIndex) :
    (1-beta)*(1-delta)*A*GaussianSandwich017.gaussian ((i.val : ℤ)-15360).natAbs≤(coordLaw ActualTables016.tables).mass i ∧
    (coordLaw ActualTables016.tables).mass i≤(1+beta)*(1+delta)*A*GaussianSandwich017.gaussian ((i.val : ℤ)-15360).natAbs := by
  have hc := coord_probability_bounds ActualTables016.tables (cdf_monotone rows)
    ActualTables016.last_cdf_positive i
  rw [prior_actual] at hc
  change (1-(TableData016.cdf 30720 : ℝ)/2^384)*(weight i.val : ℝ)/TableData016.cdf 30720≤_ ∧
    _≤(1+(TableData016.cdf 30720 : ℝ)/2^384)*(weight i.val : ℝ)/TableData016.cdf 30720 at hc
  have hg := weight_bounds rows i.val i.isLt
  have hS := total_bounds.1
  have hW : (0 : ℝ)≤weight i.val := by positivity
  have hl := mul_le_mul_of_nonneg_right (sub_le_sub_left bias_bound 1) hW
  have hu := mul_le_mul_of_nonneg_right (add_le_add_right bias_bound 1) hW
  have hlo := (div_le_div_of_nonneg_right hl hS.le).trans hc.1
  have hup := hc.2.trans (div_le_div_of_nonneg_right hu hS.le)
  have hglo := mul_le_mul_of_nonneg_left hg.1
    (mul_nonneg (by norm_num [beta] : 0≤1-beta) scale_bounds.2.le)
  have hgup := mul_le_mul_of_nonneg_left hg.2
    (mul_nonneg (by norm_num [beta] : 0≤1+beta) scale_bounds.2.le)
  constructor
  · apply le_trans _ hlo
    convert hglo using 1 <;> simp only [A,delta] <;> field_simp
  · apply le_trans hup
    convert hgup using 1 <;> simp only [A,delta] <;> field_simp

#print axioms cdf_monotone
#print axioms prior_actual
#print axioms coord_mass_count
#print axioms coord_probability_bounds
#print axioms total_bounds
#print axioms bias_bound
#print axioms scale_bounds
#print axioms actual_coord_bounds
end FT1536.S05.CDFProbability017
