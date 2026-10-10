import CDFProbability017
import ProgramLaw016

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.PairProbability017
open Finset FT1536.Run2 FT1536.Run2.FiberBinding
open SamplerCode016 CapExecution016 CDFProbability017 FiniteLaw016

def pairEmbed (z : CoordIndex×CoordIndex) : Block := (embedCoord z.1,embedCoord z.2)
def thresholdIndex (x y : CoordIndex) : PairIndex := ⟨x.val+y.val,by have := x.isLt; have := y.isLt; omega⟩
def out (t : Tables) (z : CoordIndex×(CoordIndex×Fin (2^256))) : Option Block :=
  if z.2.2.val<t.threshold (thresholdIndex z.1 z.2.1) then some (pairEmbed (z.1,z.2.1)) else none

theorem pairEmbed_injective : Function.Injective pairEmbed := by
  intro x y h
  apply Prod.ext <;> apply Fin.ext
  · have hh := congrArg (fun b : Block => b.1.val) h
    change x.1.val+50175=y.1.val+50175 at hh
    omega
  · have hh := congrArg (fun b : Block => b.2.val) h
    change x.2.val+50175=y.2.val+50175 at hh
    omega

attribute [local irreducible] coord BitTapes016.word

theorem pair_trial_map (t : Tables) : trialLaw (pairTrial t)=
    (Divergence.joint (coordLaw t) (fun _ =>
      Divergence.joint (coordLaw t) (fun _ => (Law.uniform : Law (Fin (2^256)))))).map (out t) := by
  have he : pairTrial t=out t ∘ (fun coins : PairBits =>
      (coord t coins.1,(coord t coins.2.1,BitTapes016.word 256 coins.2.2))) := rfl
  rw [trialLaw,he,←FiniteLaw016.map_map,←uniform_joint,
    ProgramLaw016.map_product (f:=coord t) (g:=fun p : BitTapes016.Bits 384×BitTapes016.Bits 256 => (coord t p.1,BitTapes016.word 256 p.2))]
  rw [←uniform_joint,ProgramLaw016.map_product (f:=coord t) (g:=BitTapes016.word 256),BitTapes016.word_uniform]
  rfl

theorem uniform_below (bits T : ℕ) (hT : T≤2^bits) :
    (Law.uniform : Law (Fin (2^bits))).event (fun x => x.val<T)=(T : ℝ)/(2 : ℝ)^bits := by
  rw [CountProbability017.uniform_event_count (2^bits) (fun k => k<T)]
  have hc : Nat.count (fun k => k<T) (2^bits)=T := by
    have hh := ModuloCounts017.short_count (2^bits) 0 T (2^bits) le_rfl
    have he := ModuloCounts017.count_congr (fun k => k<T) (ModuloCounts017.intervalMod (2^bits) 0 T)
      (2^bits) (fun k hk => by simp only [ModuloCounts017.intervalMod,Nat.mod_eq_of_lt hk,Nat.zero_le,true_and])
    rw [he,hh]
    simpa only [Nat.sub_zero] using min_eq_left hT
  rw [hc]
  norm_num only [Nat.cast_pow,Nat.cast_ofNat]

theorem trial_some_embedded (t : Tables) (hT : ∀ j,t.threshold j≤2^256) (x y : CoordIndex) :
    (trialLaw (pairTrial t)).mass (some (pairEmbed (x,y)))=
      (coordLaw t).mass x*(coordLaw t).mass y*(t.threshold (thresholdIndex x y) : ℝ)/2^256 := by
  rw [pair_trial_map,map_mass]
  simp only [Divergence.joint,Fintype.sum_prod_type]
  have hterm (a b : CoordIndex) (v : Fin (2^256)) :
      (if out t (a,(b,v))=some (pairEmbed (x,y)) then
        (coordLaw t).mass a*((coordLaw t).mass b*(Law.uniform : Law (Fin (2^256))).mass v) else 0)=
      (if a=x then if b=y then
        (coordLaw t).mass x*(coordLaw t).mass y*
          (if v.val<t.threshold (thresholdIndex x y) then (Law.uniform : Law (Fin (2^256))).mass v else 0)
       else 0 else 0) := by
    by_cases ha : a=x <;> by_cases hb : b=y
    · subst a; subst b
      by_cases hv : v.val<t.threshold (thresholdIndex x y) <;> simp [out,hv,mul_assoc]
    · have hn : pairEmbed (a,b)≠pairEmbed (x,y) := by intro h; have := congrArg Prod.snd (pairEmbed_injective h); exact hb this
      simp only [ha,ite_true,hb,ite_false,out]
      split <;> simp_all
    · have hn : pairEmbed (a,b)≠pairEmbed (x,y) := by intro h; have := congrArg Prod.fst (pairEmbed_injective h); exact ha this
      simp only [ha,ite_false,out]
      split <;> simp_all
    · have hn : pairEmbed (a,b)≠pairEmbed (x,y) := by intro h; have := congrArg Prod.fst (pairEmbed_injective h); exact ha this
      simp only [ha,ite_false,out]
      split <;> simp_all
  simp_rw [hterm]
  simp only [sum_ite_irrel, sum_const_zero, sum_ite_eq',mem_univ,ite_true]
  rw [←mul_sum]
  change _*(Law.uniform : Law (Fin (2^256))).event (fun v => v.val<t.threshold (thresholdIndex x y))=_
  rw [uniform_below 256 _ (hT _)]
  ring

theorem trial_some_outside (t : Tables) (z : Block) (hz : ∀ p,pairEmbed p≠z) :
    (trialLaw (pairTrial t)).mass (some z)=0 := by
  rw [pair_trial_map,map_mass]
  apply sum_eq_zero
  intro p _
  have hn : out t p≠some z := by
    unfold out
    split
    · exact fun h => hz (p.1,p.2.1) (Option.some.inj h)
    · simp
  simp only [hn,ite_false]

#print axioms pairEmbed_injective
#print axioms pair_trial_map
#print axioms uniform_below
#print axioms trial_some_embedded
#print axioms trial_some_outside
end FT1536.S05.PairProbability017
