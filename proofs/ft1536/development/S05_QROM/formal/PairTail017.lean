import PairInfinite017
import BoxSupport015

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.PairTail017
open Finset FT1536.Geometry FT1536.Run2 RawProductLaw FT1536.PublicSimulation
open PairNormalizer017 PairInfinite017

/-- The exact full coefficient box, inside the integer pair lattice. -/
def embed : Block ↪ ℤ×ℤ where
  toFun b := blockDecode b
  inj' := by
    intro x y h
    exact Prod.ext (decode_injective (congrArg Prod.fst h)) (decode_injective (congrArg Prod.snd h))
noncomputable def finiteAtoms : Finset (ℤ×ℤ) := Finset.univ.map embed

theorem block_weight_atom (b : Block) : blockWeight b=atom 1 (embed b) := by
  change Real.exp (-(blockEnergy b : ℝ)/1179648)=Real.exp (-1*(blockEnergy b : ℝ)/1179648)
  congr 1
  ring

theorem finite_mass : blockNormalizer=∑ z ∈ finiteAtoms,atom 1 z := by
  rw [finiteAtoms,sum_map]
  exact sum_congr rfl (fun b _ => block_weight_atom b)

theorem outside_energy (z : ℤ×ℤ) (hz : z ∉ finiteAtoms) :
    (3221225472 : ℤ)≤Geometry.block z.1 z.2 := by
  by_contra hq
  have hb := BoxSupport015.coord_bounds_of_block z.1 z.2 (by omega)
  apply hz
  let b : Block := (encodeCoord z.1 hb.1,encodeCoord z.2 hb.2)
  have he : embed b=z := by
    apply Prod.ext
    · exact decode_encodeCoord z.1 hb.1
    · exact decode_encodeCoord z.2 hb.2
  simp only [finiteAtoms,mem_map,mem_univ,true_and]
  exact ⟨b,he⟩

theorem atom_tilt (z : ℤ×ℤ) (L : ℝ) (hL : L≤(Geometry.block z.1 z.2 : ℝ)) :
    atom 1 z≤Real.exp (-(3/4 : ℝ)*L/1179648)*atom (1/4) z := by
  unfold atom
  rw [←Real.exp_add]
  apply Real.exp_le_exp.mpr
  linarith

theorem predicate_tail (p : ℤ×ℤ → Prop) (L : ℝ)
    (hp : ∀ z,p z → L≤(Geometry.block z.1 z.2 : ℝ)) :
    (∑' z : {z : ℤ×ℤ // p z},atom 1 z.val)≤Real.exp (-(3/4 : ℝ)*L/1179648)*mass (1/4) := by
  have hs1 := atom_summable 1 (by norm_num) (by norm_num)
  have hs4 := atom_summable (1/4) (by norm_num) (by norm_num)
  have hh := Summable.tsum_le_tsum (fun z : {z : ℤ×ℤ // p z} => atom_tilt z.val L (hp z.val z.prop))
    (hs1.subtype p) ((hs4.subtype p).mul_left (Real.exp (-(3/4 : ℝ)*L/1179648)))
  rw [tsum_mul_left] at hh
  have he := Summable.tsum_subtype_le (atom (1/4)) {z | p z} (fun _ => (Real.exp_pos _).le) hs4
  exact hh.trans (mul_le_mul_of_nonneg_left he (Real.exp_pos _).le)

theorem finite_tail (s : Finset (ℤ×ℤ)) (L : ℝ)
    (hs : ∀ z∈s,L≤(Geometry.block z.1 z.2 : ℝ)) :
    (∑ z∈s,atom 1 z)≤Real.exp (-(3/4 : ℝ)*L/1179648)*mass (1/4) := by
  have hh := sum_le_sum (fun z hz => atom_tilt z L (hs z hz))
  rw [←mul_sum] at hh
  have he := (atom_summable (1/4) (by norm_num) (by norm_num)).sum_le_tsum s (fun _ _ => (Real.exp_pos _).le)
  exact hh.trans (mul_le_mul_of_nonneg_left he (Real.exp_pos _).le)

theorem exp_box_tail : Real.exp (-(3/4 : ℝ)*3221225472/1179648)≤1/2^32 := by
  have hl := Real.log_two_lt_d9
  have hh : -(3/4 : ℝ)*3221225472/1179648≤ -(32 : ℝ)*Real.log 2 := by linarith
  have he := Real.exp_nat_mul (Real.log 2) 32
  norm_num only [Nat.cast_ofNat] at he
  rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at he
  calc
    _ ≤ Real.exp (-(32 : ℝ)*Real.log 2) := Real.exp_le_exp.mpr hh
    _ = _ := by rw [neg_mul,Real.exp_neg,he,one_div]

theorem finite_box_loss : mass 1-blockNormalizer≤1 := by
  have hs := (atom_summable 1 (by norm_num) (by norm_num)).sum_add_tsum_compl (s:=finiteAtoms)
  rw [←finite_mass] at hs
  have ht := predicate_tail (fun z => z ∉ finiteAtoms) 3221225472
    (fun z hz => by exact_mod_cast outside_energy z hz)
  have hn := mul_le_mul exp_box_tail mass_quarter_upper
    (tsum_nonneg (fun _ => (Real.exp_pos _).le)) (by positivity : (0 : ℝ)≤1/2^32)
  have hnum : (1/(2 : ℝ)^32)*17200000≤1 := by norm_num
  change blockNormalizer+(∑' z : {z : ℤ×ℤ // z ∉ finiteAtoms},atom 1 z.val)=mass 1 at hs
  linarith

theorem block_normalizer_lower : (4200000 : ℝ)≤blockNormalizer := by
  linarith [mass_one_lower,finite_box_loss]

#print axioms block_weight_atom
#print axioms finite_mass
#print axioms outside_energy
#print axioms atom_tilt
#print axioms predicate_tail
#print axioms finite_tail
#print axioms exp_box_tail
#print axioms finite_box_loss
#print axioms block_normalizer_lower
end FT1536.S05.PairTail017
