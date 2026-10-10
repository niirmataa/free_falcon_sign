import ModuloCounts017
import Run2.CorrectnessProbability

namespace FT1536.S05.CountProbability017
open Finset ModuloCounts017

theorem fin_filter_card (N : ℕ) (p : ℕ → Prop) [DecidablePred p] :
    ((univ : Finset (Fin N)).filter (fun x => p x.val)).card=Nat.count p N := by
  classical
  let e : Fin N ↪ ℕ := ⟨Fin.val,Fin.val_injective⟩
  have he : ((univ : Finset (Fin N)).filter (fun x => p x.val)).map e=(range N).filter p := by
    ext k
    simp only [mem_map,mem_filter,mem_univ,true_and,mem_range]
    constructor
    · rintro ⟨x,hx,hk⟩
      change x.val=k at hk
      exact ⟨hk ▸ x.isLt,hk ▸ hx⟩
    · rintro ⟨hk,hp⟩
      exact ⟨⟨k,hk⟩,hp,rfl⟩
  rw [Nat.count_eq_card_filter_range,←he,card_map]

theorem uniform_event_count (N : ℕ) [NeZero N] (p : ℕ → Prop) [DecidablePred p] :
    (Law.uniform : Law (Fin N)).event (fun x => p x.val)=(Nat.count p N : ℝ)/N := by
  unfold Law.event
  simp only [Law.uniform,Fintype.card_fin]
  rw [←sum_filter,sum_const,nsmul_eq_mul,fin_filter_card]
  ring

theorem word_interval_probability (bits S a b : ℕ) (hS : 0<S) (hb : b≤S) :
    (Law.uniform : Law (BitTapes016.Bits bits)).event
      (fun w => intervalMod S a b (BitTapes016.word bits w).val)=
    (((2^bits)/S*(b-a)+min (b-a) ((2^bits)%S-a) : ℕ) : ℝ)/(2 : ℝ)^bits := by
  have hm := FT1536.Run2.CorrectnessProbability.map_event
    (Law.uniform : Law (BitTapes016.Bits bits)) (BitTapes016.word bits)
    (fun x : Fin (2^bits) => intervalMod S a b x.val)
  rw [BitTapes016.word_uniform,uniform_event_count,interval_mod_count (2^bits) S a b hS hb] at hm
  simpa only [Nat.cast_pow,Nat.cast_ofNat] using hm.symm

theorem probability_bounds (N S a b : ℕ) (hN : 0<N) (hS : 0<S) (hb : b≤S) :
    (1-(S : ℝ)/N)*(b-a : ℕ)/S≤(Nat.count (intervalMod S a b) N : ℝ)/N ∧
    (Nat.count (intervalMod S a b) N : ℝ)/N≤(1+(S : ℝ)/N)*(b-a : ℕ)/S := by
  have hn : (0 : ℝ)<N := by exact_mod_cast hN
  have hs : (0 : ℝ)<S := by exact_mod_cast hS
  have bounds := interval_count_bounds N S a b hS hb
  have hl : ((N/S : ℕ) : ℝ)*(b-a : ℕ)≤(Nat.count (intervalMod S a b) N : ℝ) := by exact_mod_cast bounds.1
  have hu : (Nat.count (intervalMod S a b) N : ℝ)≤(((N/S : ℕ) : ℝ)+1)*(b-a : ℕ) := by exact_mod_cast bounds.2
  have he : (N : ℝ)=((N/S : ℕ) : ℝ)*(S : ℝ)+((N%S : ℕ) : ℝ) := by
    have h := (Nat.div_add_mod N S).symm
    exact_mod_cast (by simpa only [Nat.mul_comm S (N/S)] using h)
  have hr : ((N%S : ℕ) : ℝ)<(S : ℝ) := by exact_mod_cast Nat.mod_lt N hS
  have hr0 : (0 : ℝ)≤(N%S : ℕ) := by positivity
  have hw : (0 : ℝ)≤(b-a : ℕ) := by positivity
  have hlo : ((N : ℝ)-S)*(b-a : ℕ)≤(Nat.count (intervalMod S a b) N : ℝ)*S := by
    have hm := mul_le_mul_of_nonneg_right hl hs.le
    have hq := mul_le_mul_of_nonneg_right (show (N : ℝ)-S≤((N/S : ℕ) : ℝ)*S by linarith) hw
    nlinarith
  have hup : (Nat.count (intervalMod S a b) N : ℝ)*S≤((N : ℝ)+S)*(b-a : ℕ) := by
    have hm := mul_le_mul_of_nonneg_right hu hs.le
    have hq := mul_le_mul_of_nonneg_right (show ((N/S : ℕ) : ℝ)*S≤(N : ℝ) by linarith) hw
    nlinarith
  constructor
  · apply (div_le_div_iff₀ hs hn).mpr
    convert hlo using 1; field_simp
  · apply (div_le_div_iff₀ hn hs).mpr
    convert hup using 1; field_simp

#print axioms fin_filter_card
#print axioms uniform_event_count
#print axioms word_interval_probability
#print axioms probability_bounds
end FT1536.S05.CountProbability017
