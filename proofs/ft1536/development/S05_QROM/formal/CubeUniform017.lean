import ProgramLaw016
import SamplerSupport016

set_option maxRecDepth 8192
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
namespace FT1536.S05.CubeUniform017
open Finset FT1536.PublicSimulation FT1536.Run2.FiberBinding
open SamplerCode016 ProgramLaw016 BitTapes016

theorem cubeCoord_injective : Function.Injective cubeCoord := by
  intro x y he
  apply word_injective 10
  apply Fin.ext
  have hh := congrArg Fin.val he
  change (word 10 x).val+65023=(word 10 y).val+65023 at hh
  omega

theorem cube_injective : Function.Injective cube := by
  intro x y he
  apply Prod.ext
  · funext i
    have hh := congrFun (congrArg Prod.fst he) i
    exact Prod.ext (cubeCoord_injective (congrArg Prod.fst hh))
      (cubeCoord_injective (congrArg Prod.snd hh))
  · funext i
    have hh := congrFun (congrArg Prod.snd he) i
    exact Prod.ext (cubeCoord_injective (congrArg Prod.fst hh))
      (cubeCoord_injective (congrArg Prod.snd hh))

theorem cube_seed_card : Fintype.card CubeSeed=2^30720 := by
  rw [←Fintype.card_congr cubeSeedEquiv]
  rw [Fintype.card_fun,Fintype.card_bool,Fintype.card_fin]

theorem uniform_injective_bound {X Y : Type} [Fintype X] [Fintype Y] [Nonempty X]
    [DecidableEq Y] (f : X → Y) (hf : Function.Injective f) (y : Y) :
    ((Law.uniform : Law X).map f).mass y≤1/(Fintype.card X : ℝ) := by
  classical
  rw [map_mass]
  by_cases hx : ∃ x,f x=y
  · obtain ⟨x,hx⟩ := hx
    have he (z : X) : f z=y ↔ z=x := by
      constructor
      · intro hz; exact hf (hz.trans hx.symm)
      · intro hz; exact hz ▸ hx
    simp only [he,Law.uniform,sum_ite_eq',mem_univ,ite_true,le_refl]
  · push Not at hx
    simp only [hx,ite_false,sum_const_zero]
    positivity

theorem cube_atom_bound (z : BoxPair) : cubeLaw.mass z≤1/(2 : ℝ)^30720 := by
  have hh := uniform_injective_bound cube cube_injective z
  rw [cube_seed_card,Nat.cast_pow,Nat.cast_ofNat] at hh
  exact hh

theorem cube_support (z : BoxPair) (hz : cubeLaw.mass z≠0) : ∃ coins,cube coins=z := by
  classical
  by_contra no
  push Not at no
  apply hz
  rw [cubeLaw,map_mass]
  simp only [no,ite_false,sum_const_zero]

theorem cube_support_norm (z : BoxPair) (hz : cubeLaw.mass z≠0) :
    Geometry.Q (decode z)≤1207959552 := by
  obtain ⟨coins,rfl⟩ := cube_support z hz
  exact SamplerSupport016.cube_norm coins

#print axioms cubeCoord_injective
#print axioms cube_injective
#print axioms cube_seed_card
#print axioms uniform_injective_bound
#print axioms cube_atom_bound
#print axioms cube_support
#print axioms cube_support_norm
end FT1536.S05.CubeUniform017
