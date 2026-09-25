import FT1536.MathSign
import FT1536.Geometry
import FT1536.Divergence

namespace FT1536.PublicSimulation
open Finset Geometry

/- A finite enclosing box, not a centered box: all Q<B vectors fit inside it.
Only the strict norm gate changes the Gaussian candidate's support. -/
abbrev BoxVec := Fin 768 → Fin 131071 × Fin 131071
abbrev BoxPair := BoxVec × BoxVec
noncomputable instance boxVecFintype : Fintype BoxVec := Fintype.ofFinite BoxVec
noncomputable instance boxPairFintype : Fintype BoxPair := Fintype.ofFinite BoxPair
def decodeVec (v : BoxVec) : Vec := fun i =>
  ((v i).1.val - (65535 : ℤ), (v i).2.val - (65535 : ℤ))
def decode (z : BoxPair) : Vec × Vec := (decodeVec z.1, decodeVec z.2)
def zeroVec : BoxVec := fun _ => (⟨65535, by norm_num⟩, ⟨65535, by norm_num⟩)
def zeroPair : BoxPair := (zeroVec, zeroVec)

theorem zero_norm : Q (decode zeroPair) = 0 := by
  simp [Q, Q0, decode, decodeVec, zeroPair, zeroVec, block]

noncomputable def gaussianWeight (z : BoxPair) : ℝ :=
  Real.exp (-(Q (decode z) : ℝ) / (2 * 768^2))

noncomputable def boundedWeight (z : BoxPair) : ℝ :=
  if Q (decode z) < B then gaussianWeight z else 0

theorem boundedWeight_nonneg (z : BoxPair) : 0 ≤ boundedWeight z := by
  unfold boundedWeight gaussianWeight
  split_ifs
  · exact (Real.exp_pos _).le
  · rfl

theorem bounded_normalizer_pos : 0 < ∑ z, boundedWeight z := by
  classical
  apply sum_pos'
  · intro z _; exact boundedWeight_nonneg z
  · refine ⟨zeroPair, ?_, ?_⟩
    · exact Finset.mem_univ zeroPair
    · simp [boundedWeight, zero_norm, B, gaussianWeight]

noncomputable def boundedGaussian : Law BoxPair :=
  Law.weighted boundedWeight boundedWeight_nonneg bounded_normalizer_pos

theorem boundedGaussian_support (z : BoxPair) :
    boundedGaussian.mass z ≠ 0 ↔ Q (decode z) < B := by
  change boundedWeight z / (∑ y, boundedWeight y) ≠ 0 ↔ _
  rw [div_ne_zero_iff, and_iff_left (ne_of_gt bounded_normalizer_pos)]
  unfold boundedWeight gaussianWeight
  split_ifs <;> simp_all [Real.exp_ne_zero]

def signed16 (v : BoxVec) : Prop := ∀ i,
  -32768 ≤ (decodeVec v i).1 ∧ (decodeVec v i).1 ≤ 32767 ∧
  -32768 ≤ (decodeVec v i).2 ∧ (decodeVec v i).2 ≤ 32767

/- Coefficient-valued Sigma_math. Byte encoding is an explicit open bridge.
No centering or Verify test is applied to an emitted positive answer. -/
noncomputable def emit (z : BoxPair) : Option BoxVec := by
  classical
  exact if signed16 z.2 then some z.2 else none

variable {C : Type*} [Fintype C] [DecidableEq C]

noncomputable def publicJoint (A : BoxPair → C) : Law (C × Option BoxVec) :=
  boundedGaussian.map fun z => (A z, emit z)

theorem joint_law (A : BoxPair → C) : ∑ co, (publicJoint A).mass co = 1 :=
  (publicJoint A).total

/- Exact finite-box G16 signer: independently draw from the Gaussian-weighted
fiber at fixed c, norm-reject up to 16 times, then emit once. Empty fiber aborts.
This is a measure specification, not a claim of an efficient sampling algorithm. -/
noncomputable def fiberWeight (A : BoxPair → C) (c : C) (z : BoxPair) : ℝ :=
  if A z = c then gaussianWeight z else 0

omit [Fintype C] in
theorem fiberWeight_nonneg (A : BoxPair → C) (c : C) (z : BoxPair) :
    0 ≤ fiberWeight A c z := by
  unfold fiberWeight gaussianWeight
  split_ifs
  · exact (Real.exp_pos _).le
  · rfl

noncomputable def trial (A : BoxPair → C) (c : C) : Law (Option BoxPair) := by
  classical
  exact if h : 0 < ∑ z, fiberWeight A c z then
    (Law.weighted (fiberWeight A c) (fiberWeight_nonneg A c) h).map
      (fun z => if Q (decode z) < B then some z else none)
  else Law.pure none

noncomputable def signBody (A : BoxPair → C) (c : C) : Law (Option BoxVec) := by
  classical
  exact (MathSign.cap (trial A c) 16).map (MathSign.emit emit)

omit [Fintype C] in
theorem signBody_normalized (A : BoxPair → C) (c : C) :
    ∑ o, (signBody A c).mass o = 1 := (signBody A c).total

noncomputable def honestJoint (A : BoxPair → C) [Nonempty C] : Law (C × Option BoxVec) :=
  Divergence.joint Law.uniform (signBody A)

/- Computational public interface: run is supplied code on a finite uniform
coin tape, with public h/history/message/nonce only. No secret or future
challenge list occurs in this type. Exact realization of boundedGaussian is
not inferred from this interface. -/
structure PublicSampler (H History Message Nonce C O : Type) where
  coinCount : ℕ
  positiveCoins : 0 < coinCount
  run : H → History → Message → Nonce → Fin coinCount → C × O
  timeBound : ℕ
  spaceBound : ℕ

noncomputable def samplerLaw {H History Message Nonce C O : Type}
    [Fintype C] [Fintype O] [DecidableEq C] [DecidableEq O]
    (s : PublicSampler H History Message Nonce C O)
    (h : H) (hist : History) (m : Message) (r : Nonce) : Law (C × O) := by
  letI : NeZero s.coinCount := ⟨ne_of_gt s.positiveCoins⟩
  exact Law.uniform.map (s.run h hist m r)

end FT1536.PublicSimulation
