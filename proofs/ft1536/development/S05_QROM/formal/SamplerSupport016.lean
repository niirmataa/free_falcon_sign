import SamplerCode016
import BoxSupport015

set_option maxRecDepth 8192
namespace FT1536.S05.SamplerSupport016
open Finset FT1536.Geometry FT1536.PublicSimulation
open SamplerCode016 CapExecution016

def pairSigned (b : Block) : Prop :=
  -32768≤(b.1.val : ℤ)-65535 ∧ (b.1.val : ℤ)-65535≤32767 ∧
  -32768≤(b.2.val : ℤ)-65535 ∧ (b.2.val : ℤ)-65535≤32767

theorem embed_signed (x y : CoordIndex) : pairSigned (embedCoord x,embedCoord y) := by
  have hx := x.isLt
  have hy := y.isLt
  unfold pairSigned embedCoord
  simp only [Nat.cast_add,Nat.cast_ofNat]
  omega

theorem pair_signed (t : Tables) (coins : PairSeed) : pairSigned (pair t coins) := by
  unfold pair
  cases he : first (pairTrial t) 80 coins with
  | none => norm_num [Option.getD,zeroBlock,pairSigned]
  | some a =>
    obtain ⟨i,hi⟩ := first_some_witness (pairTrial t) 80 coins a he
    dsimp only [pairTrial] at hi
    split at hi
    · cases hi
      exact embed_signed _ _
    · cases hi

theorem vector_signed (t : Tables) (coins : VectorSeed) : signed16 (vector t coins).2 := by
  intro i
  exact pair_signed t (coins.2 i)

theorem cube_coord_bounds (bits : BitTapes016.Bits 10) :
    -512≤((cubeCoord bits).val : ℤ)-65535 ∧ ((cubeCoord bits).val : ℤ)-65535≤511 := by
  have hh := (BitTapes016.word 10 bits).isLt
  norm_num at hh
  unfold cubeCoord
  simp only [Nat.cast_add,Nat.cast_ofNat]
  omega

theorem cube_block_bound (a b : BitTapes016.Bits 10) :
    block ((cubeCoord a).val-65535) ((cubeCoord b).val-65535)≤3*512^2 := by
  have ha := cube_coord_bounds a
  have hb := cube_coord_bounds b
  have hxx : (((cubeCoord a).val : ℤ)-65535)^2≤512^2 := by nlinarith
  have hyy : (((cubeCoord b).val : ℤ)-65535)^2≤512^2 := by nlinarith
  unfold block
  nlinarith [sq_nonneg ((((cubeCoord a).val : ℤ)-65535)-(((cubeCoord b).val : ℤ)-65535))]

theorem cube_norm (coins : CubeSeed) : Q (decode (cube coins))≤1207959552 := by
  have hsum (v : Fin 768 → BitTapes016.Bits 10 × BitTapes016.Bits 10) :
      (∑ i,block ((cubeCoord (v i).1).val-65535) ((cubeCoord (v i).2).val-65535))≤768*(3*512^2) := by
    calc
      _ ≤ ∑ _i : Fin 768,(3*512^2 : ℤ) := sum_le_sum (fun i _ => cube_block_bound _ _)
      _ = _ := by rw [sum_const,card_univ,Fintype.card_fin,nsmul_eq_mul]; norm_num
  have h1 := hsum coins.1
  have h2 := hsum coins.2
  change (∑ i,block ((cubeCoord (coins.1 i).1).val-65535) ((cubeCoord (coins.1 i).2).val-65535))+
    (∑ i,block ((cubeCoord (coins.2 i).1).val-65535) ((cubeCoord (coins.2 i).2).val-65535))≤_
  linarith

theorem cube_signed (coins : CubeSeed) : signed16 (cube coins).2 := by
  intro i
  have ha := cube_coord_bounds (coins.2 i).1
  have hb := cube_coord_bounds (coins.2 i).2
  change -32768≤((cubeCoord (coins.2 i).1).val : ℤ)-65535 ∧
    ((cubeCoord (coins.2 i).1).val : ℤ)-65535≤32767 ∧
    -32768≤((cubeCoord (coins.2 i).2).val : ℤ)-65535 ∧
    ((cubeCoord (coins.2 i).2).val : ℤ)-65535≤32767
  omega

theorem selected_norm (t : Tables) (coins : Seed) : Q (decode (selected t coins))<B := by
  unfold selected
  cases he : first (normTrial t) 196 coins.1 with
  | none => exact (cube_norm coins.2).trans_lt (by norm_num [B])
  | some z =>
    obtain ⟨i,hi⟩ := first_some_witness (normTrial t) 196 coins.1 z he
    dsimp only [normTrial] at hi
    split at hi
    next good => cases hi; exact good
    next => cases hi

theorem selected_signed (t : Tables) (coins : Seed) : signed16 (selected t coins).2 := by
  unfold selected
  cases he : first (normTrial t) 196 coins.1 with
  | none => exact cube_signed coins.2
  | some z =>
    obtain ⟨i,hi⟩ := first_some_witness (normTrial t) 196 coins.1 z he
    dsimp only [normTrial] at hi
    split at hi
    · cases hi; exact vector_signed t _
    · cases hi

theorem selected_emit (t : Tables) (coins : Seed) : emit (selected t coins)=some (selected t coins).2 := by
  exact ite_eq_left (selected_signed t coins)

theorem code_as_emission (t : Tables) (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
    (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (coins : BitTapes016.Bits 24662538240) :
    (sampler t).code h st m r coins=
      (SigmaMath.syndrome h (selected t (seedEquiv coins)),emit (selected t (seedEquiv coins))) := by
  rw [selected_emit]
  change (challenge h _,some _)=(SigmaMath.syndrome h _,some _)
  rw [challenge_correct]

#print axioms embed_signed
#print axioms pair_signed
#print axioms vector_signed
#print axioms cube_coord_bounds
#print axioms cube_block_bound
#print axioms cube_norm
#print axioms cube_signed
#print axioms selected_norm
#print axioms selected_signed
#print axioms selected_emit
#print axioms code_as_emission
end FT1536.S05.SamplerSupport016
