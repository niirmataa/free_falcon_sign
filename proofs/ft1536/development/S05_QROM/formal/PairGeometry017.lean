import PairProbability017
import CentralMass017

set_option maxRecDepth 8192
namespace FT1536.S05.PairGeometry017
open Finset FT1536.Run2 RawProductLaw SamplerCode016 PairProbability017
open GaussianSandwich017 CentralMass017

def value (i : CoordIndex) : ℤ := (i.val : ℤ)-15360

theorem gaussian_abs (z : ℤ) : gaussian z.natAbs=Real.exp (-(z : ℝ)^2/2359296) := by
  have hs : ((z.natAbs : ℝ)^2)=(z : ℝ)^2 := by
    have hh : (z.natAbs : ℤ)^2=z^2 := by rw [Int.natCast_natAbs,sq_abs]
    have hr := congrArg (fun w : ℤ => (w : ℝ)) hh
    simpa only [Int.cast_pow,Int.cast_natCast] using hr
  unfold gaussian GaussianPolynomial017.c
  rw [hs]
  norm_num

theorem embed_decode (p : CoordIndex×CoordIndex) : blockDecode (pairEmbed p)=(value p.1,value p.2) := by
  apply Prod.ext <;> simp only [blockDecode,pairEmbed,embedCoord,value,Nat.cast_add,Nat.cast_ofNat] <;> ring

theorem gaussian_product (x y : CoordIndex) :
    gaussian (value x).natAbs*gaussian (value y).natAbs*
      gaussian (((thresholdIndex x y).val : ℤ)-30720).natAbs=blockWeight (pairEmbed (x,y)) := by
  have hs : ((thresholdIndex x y).val : ℤ)-30720=value x+value y := by
    simp only [thresholdIndex,value,Nat.cast_add]
    ring
  rw [hs,gaussian_abs,gaussian_abs,gaussian_abs]
  unfold blockWeight blockEnergy
  rw [embed_decode,←Real.exp_add,←Real.exp_add]
  congr 1
  simp only [FT1536.Geometry.block,Int.cast_add,Int.cast_mul,Int.cast_pow]
  ring

def encode (z : ℤ) (hz : |z|≤15360) : CoordIndex :=
  ⟨(z+15360).toNat,by have hh := abs_le.mp hz; omega⟩

theorem value_encode (z : ℤ) (hz : |z|≤15360) : value (encode z hz)=z := by
  have hh := abs_le.mp hz
  change ((z+15360).toNat : ℤ)-15360=z
  have hz0 : 0≤z+15360 := by omega
  rw [Int.toNat_of_nonneg hz0]
  omega

theorem central_cover (b : SamplerCode016.Block) (hb : central (blockDecode b)) : ∃ p,pairEmbed p=b := by
  let x := encode (blockDecode b).1 hb.1
  let y := encode (blockDecode b).2 hb.2.1
  refine ⟨(x,y),?_⟩
  apply PairTail017.embed.injective
  change blockDecode (pairEmbed (x,y))=blockDecode b
  rw [embed_decode]
  apply Prod.ext
  · exact value_encode _ hb.1
  · exact value_encode _ hb.2.1

attribute [local irreducible] PairTail017.finiteAtoms

theorem central_box_mass :
    (1-1/(2 : ℝ)^130)*blockNormalizer≤∑ b : SamplerCode016.Block,if central (blockDecode b) then blockWeight b else 0 := by
  have he : (∑ z∈PairTail017.finiteAtoms.filter central,PairInfinite017.atom 1 z)=
      ∑ b : SamplerCode016.Block,if central (blockDecode b) then blockWeight b else 0 := by
    rw [sum_filter,PairTail017.finiteAtoms,sum_map]
    apply sum_congr rfl
    intro b _
    change (if central (blockDecode b) then PairInfinite017.atom 1 (PairTail017.embed b) else 0)=_
    rw [←PairTail017.block_weight_atom]
  rw [←he]
  exact central_mass

#print axioms gaussian_abs
#print axioms embed_decode
#print axioms gaussian_product
#print axioms value_encode
#print axioms central_cover
#print axioms central_box_mass
end FT1536.S05.PairGeometry017
