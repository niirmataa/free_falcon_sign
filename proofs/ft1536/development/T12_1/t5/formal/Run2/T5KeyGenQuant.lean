import Run2.KeygenLeafGate
import Run2.StableLeafSchedule
import Run2.QuotientOperations

namespace FT1536.Run2.T5KeyGenQuant
open FT1536.Relation FT1536.Geometry
open CoefficientQuotient KeygenLeafGate StableLeafSchedule StableLeafAlgebra

/- Accepted-KeyGen output predicate of the committed FT1536 keygen: exact
   NTRU/public/invertibility equations of the emitted key material and an
   accepted mandatory leaf gate on its 768 machine leaf words. Legal keys
   are NOT defined through FiniteFlat, CoefficientRange or any desired
   error bound; the quantifier below ranges over real gate outputs. -/
noncomputable def successfulKeyGen (h : Rq) : Prop :=
  ∃ (f g bigF bigG : Vec) (fInv : Rq) (words : List Word),
    multiply f bigG - multiply g bigF = constantCoeffs (18433 : ℤ) ∧
    mulRq h (reduceVec f) = reduceVec g ∧
    mulRq fInv (reduceVec f) = constantCoeffs (1 : ZMod 18433) ∧
    words.length = 768 ∧
    (scan words 0#32).2 = 0#32

/- Upper end of the accepted gate range (upperBits), mirroring
   KeygenLeafGate.accepted_value_lower at the top of the range. -/
theorem accepted_value_upper (w : Word)
    (hw : lowerBits.toNat ≤ w.toNat ∧ w.toNat ≤ upperBits.toNat) :
    positiveNormalValue w ≤ (332054 : ℝ) := by
  norm_num [lowerBits, upperBits] at hw
  have hlt : w.toNat%2^52 < 2^52 := Nat.mod_lt _ (by norm_num)
  by_cases h1041 : w.toNat/2^52 = 1041
  · have hrm : w.toNat%2^52 ≤ 1200997846449488 := by omega
    have hexp : (w.toNat/2^52 : ℕ)-(1075 : ℤ) = (-34 : ℤ) := by omega
    have hbase : ((2^52 + w.toNat%2^52 : ℕ) : ℝ)
        ≤ ((2^52 + 1200997846449488 : ℕ) : ℝ) :=
      by exact_mod_cast Nat.add_le_add_left hrm (2^52)
    have hmul : ((2^52 + 1200997846449488 : ℕ) : ℝ)*(2 : ℝ)^(-34 : ℤ) ≤ (332054 : ℝ) := by
      norm_num
    unfold positiveNormalValue
    calc
      ((2^52 + w.toNat%2^52 : ℕ) : ℝ)*(2 : ℝ)^((w.toNat/2^52 : ℕ)-(1075 : ℤ)) =
          ((2^52 + w.toNat%2^52 : ℕ) : ℝ)*(2 : ℝ)^(-34 : ℤ) := by rw [hexp]
      _ ≤ ((2^52 + 1200997846449488 : ℕ) : ℝ)*(2 : ℝ)^(-34 : ℤ) :=
        mul_le_mul_of_nonneg_right hbase (zpow_nonneg (by norm_num) _)
      _ ≤ (332054 : ℝ) := hmul
  · have he2 : w.toNat/2^52 ≤ 1040 := by omega
    have hexp : (w.toNat/2^52 : ℕ)-(1075 : ℤ) ≤ (-35 : ℤ) := by omega
    have hpow : (2 : ℝ)^((w.toNat/2^52 : ℕ)-(1075 : ℤ)) ≤ (2 : ℝ)^(-35 : ℤ) :=
      zpow_le_zpow_right₀ (by norm_num) hexp
    have hbase : ((2^52 + w.toNat%2^52 : ℕ) : ℝ) ≤ (2^53 : ℝ) := by
      exact_mod_cast (by omega : 2^52 + w.toNat%2^52 ≤ 2^53)
    unfold positiveNormalValue
    calc
      ((2^52 + w.toNat%2^52 : ℕ) : ℝ)*(2 : ℝ)^((w.toNat/2^52 : ℕ)-(1075 : ℤ))
          ≤ (2^53 : ℝ)*(2 : ℝ)^(-35 : ℤ) :=
        mul_le_mul hbase hpow (zpow_nonneg (by norm_num) _) (by norm_num)
      _ ≤ (332054 : ℝ) := by norm_num

theorem gate_scan_values (words : List Word)
    (hscan : (scan words 0#32).2 = 0#32) :
    ∀ w ∈ words, (1024 : ℝ) ≤ positiveNormalValue w ∧
      positiveNormalValue w ≤ (332054 : ℝ) := by
  intro w hw
  have hh := successful_scan_all_leaf_values words 0#32 hscan w hw
  have hs := (scan_clear words 0#32).mp hscan
  exact ⟨hh.2, accepted_value_upper w (hs.2 w hw).2⟩

/- Every stable-schedule leaf operation is a weighted mean of its inputs, so
   [lo,hi] boxes propagate through the whole schedule. -/
theorem average_mem {lo hi a b : ℝ} (ha : lo ≤ a ∧ a ≤ hi) (hb : lo ≤ b ∧ b ≤ hi) :
    lo ≤ average a b ∧ average a b ≤ hi := by
  unfold average
  constructor <;> nlinarith

theorem harmonic_mem {lo hi a b : ℝ} (hlo : 0 < lo)
    (ha : lo ≤ a ∧ a ≤ hi) (hb : lo ≤ b ∧ b ≤ hi) :
    lo ≤ harmonic a b ∧ harmonic a b ≤ hi := by
  unfold harmonic
  have ha0 : 0 < a := lt_of_lt_of_le hlo ha.1
  have hb0 : 0 < b := lt_of_lt_of_le hlo hb.1
  have hp : 0 < a + b := by linarith
  constructor
  · apply (le_div_iff₀ hp).2
    have := add_nonneg (mul_nonneg ha0.le (sub_nonneg.mpr hb.1))
      (mul_nonneg hb0.le (sub_nonneg.mpr ha.1))
    nlinarith
  · apply (div_le_iff₀ hp).2
    have := add_nonneg (mul_nonneg ha0.le (sub_nonneg.mpr hb.2))
      (mul_nonneg hb0.le (sub_nonneg.mpr ha.2))
    nlinarith

theorem ternary0_mem {lo hi a b c : ℝ} (ha : lo ≤ a ∧ a ≤ hi)
    (hb : lo ≤ b ∧ b ≤ hi) (hc : lo ≤ c ∧ c ≤ hi) :
    lo ≤ ternary0 a b c ∧ ternary0 a b c ≤ hi := by
  unfold ternary0
  constructor <;> nlinarith

theorem ternary1_mem {lo hi a b c : ℝ} (hlo : 0 < lo) (ha : lo ≤ a ∧ a ≤ hi)
    (hb : lo ≤ b ∧ b ≤ hi) (hc : lo ≤ c ∧ c ≤ hi) :
    lo ≤ ternary1 a b c ∧ ternary1 a b c ≤ hi := by
  unfold ternary1
  have hp : 0 < a + b + c := by linarith
  constructor
  · apply (le_div_iff₀ hp).2
    have t1 := mul_nonneg (le_of_lt (lt_of_lt_of_le hlo ha.1)) (sub_nonneg.mpr hb.1)
    have t2 := mul_nonneg (le_of_lt (lt_of_lt_of_le hlo hb.1)) (sub_nonneg.mpr hc.1)
    have t3 := mul_nonneg (le_of_lt (lt_of_lt_of_le hlo hc.1)) (sub_nonneg.mpr ha.1)
    nlinarith [t1, t2, t3]
  · apply (div_le_iff₀ hp).2
    have t1 := mul_nonneg (le_of_lt (lt_of_lt_of_le hlo ha.1)) (sub_nonneg.mpr hb.2)
    have t2 := mul_nonneg (le_of_lt (lt_of_lt_of_le hlo hb.1)) (sub_nonneg.mpr hc.2)
    have t3 := mul_nonneg (le_of_lt (lt_of_lt_of_le hlo hc.1)) (sub_nonneg.mpr ha.2)
    nlinarith [t1, t2, t3]

theorem ternary2_mem {lo hi a b c : ℝ} (hlo : 0 < lo) (ha : lo ≤ a ∧ a ≤ hi)
    (hb : lo ≤ b ∧ b ≤ hi) (hc : lo ≤ c ∧ c ≤ hi) :
    lo ≤ ternary2 a b c ∧ ternary2 a b c ≤ hi := by
  unfold ternary2
  have ha0 : 0 < a := lt_of_lt_of_le hlo ha.1
  have hb0 : 0 < b := lt_of_lt_of_le hlo hb.1
  have hc0 : 0 < c := lt_of_lt_of_le hlo hc.1
  have hp : 0 < a*b + a*c + b*c := by positivity
  constructor
  · apply (le_div_iff₀ hp).2
    have t1 := mul_nonneg (mul_nonneg ha0.le hb0.le) (sub_nonneg.mpr hc.1)
    have t2 := mul_nonneg (mul_nonneg ha0.le hc0.le) (sub_nonneg.mpr hb.1)
    have t3 := mul_nonneg (mul_nonneg hb0.le hc0.le) (sub_nonneg.mpr ha.1)
    nlinarith [t1, t2, t3]
  · apply (div_le_iff₀ hp).2
    have t1 := mul_nonneg (mul_nonneg ha0.le hb0.le) (sub_nonneg.mpr hc.2)
    have t2 := mul_nonneg (mul_nonneg ha0.le hc0.le) (sub_nonneg.mpr hb.2)
    have t3 := mul_nonneg (mul_nonneg hb0.le hc0.le) (sub_nonneg.mpr ha.2)
    nlinarith [t1, t2, t3]

theorem pairMap_bounded {lo hi : ℝ} (f : ℝ → ℝ → ℝ)
    (hf : ∀ a b, lo ≤ a → a ≤ hi → lo ≤ b → b ≤ hi → lo ≤ f a b ∧ f a b ≤ hi) :
    ∀ xs : List ℝ, (∀ x ∈ xs, lo ≤ x ∧ x ≤ hi) → ∀ y ∈ pairMap f xs, lo ≤ y ∧ y ≤ hi
  | [], _ => by simp [pairMap]
  | [_], _ => by simp [pairMap]
  | a::b::xs, hp => by
    intro z hz
    simp only [pairMap, List.mem_cons] at hz
    rcases hz with rfl | hz
    · obtain ⟨ha1, ha2⟩ := hp a (by simp)
      obtain ⟨hb1, hb2⟩ := hp b (by simp)
      exact hf a b ha1 ha2 hb1 hb2
    · exact pairMap_bounded f hf xs (fun x hx => hp x (by simp [hx])) z hz

theorem tripleMap_bounded {lo hi : ℝ} (hlo : 0 < lo) (f : ℝ → ℝ → ℝ → ℝ)
    (hf : ∀ a b c, lo ≤ a → a ≤ hi → lo ≤ b → b ≤ hi → lo ≤ c → c ≤ hi →
      lo ≤ f a b c ∧ f a b c ≤ hi) :
    ∀ xs : List ℝ, (∀ x ∈ xs, lo ≤ x ∧ x ≤ hi) → ∀ y ∈ tripleMap f xs, lo ≤ y ∧ y ≤ hi
  | [], _ => by simp [tripleMap]
  | [_], _ => by simp [tripleMap]
  | [_,_], _ => by simp [tripleMap]
  | a::b::c::xs, hp => by
    intro z hz
    simp only [tripleMap, List.mem_cons] at hz
    rcases hz with rfl | hz
    · obtain ⟨ha1, ha2⟩ := hp a (by simp)
      obtain ⟨hb1, hb2⟩ := hp b (by simp)
      obtain ⟨hc1, hc2⟩ := hp c (by simp)
      exact hf a b c ha1 ha2 hb1 hb2 hc1 hc2
    · exact tripleMap_bounded hlo f hf xs (fun x hx => hp x (by simp [hx])) z hz

theorem binaryLeaves_bounded {lo hi : ℝ} (hlo : 0 < lo) :
    ∀ n xs, (∀ x ∈ xs, lo ≤ x ∧ x ≤ hi) → ∀ y ∈ binaryLeaves n xs, lo ≤ y ∧ y ≤ hi := by
  intro n
  induction n with
  | zero => intro xs hp y hy; exact hp y hy
  | succ n ih =>
    intro xs hp y hy
    have havg := pairMap_bounded average
      (fun a b ha1 ha2 hb1 hb2 => average_mem ⟨ha1, ha2⟩ ⟨hb1, hb2⟩) xs hp
    have hharm := pairMap_bounded harmonic
      (fun a b ha1 ha2 hb1 hb2 => harmonic_mem hlo ⟨ha1, ha2⟩ ⟨hb1, hb2⟩) xs hp
    simp only [binaryLeaves, List.mem_append] at hy
    rcases hy with hl | hr
    · exact ih _ havg y hl
    · exact ih _ hharm y hr

theorem primary_bounded {lo hi : ℝ} (hlo : 0 < lo) :
    ∀ n xs, (∀ x ∈ xs, lo ≤ x ∧ x ≤ hi) → ∀ y ∈ primary n xs, lo ≤ y ∧ y ≤ hi := by
  intro n xs hp y hy
  have ht0 := tripleMap_bounded hlo ternary0
    (fun a b c ha1 ha2 hb1 hb2 hc1 hc2 => ternary0_mem ⟨ha1, ha2⟩ ⟨hb1, hb2⟩ ⟨hc1, hc2⟩) xs hp
  have ht1 := tripleMap_bounded hlo ternary1
    (fun a b c ha1 ha2 hb1 hb2 hc1 hc2 => ternary1_mem hlo ⟨ha1, ha2⟩ ⟨hb1, hb2⟩ ⟨hc1, hc2⟩) xs hp
  have ht2 := tripleMap_bounded hlo ternary2
    (fun a b c ha1 ha2 hb1 hb2 hc1 hc2 => ternary2_mem hlo ⟨ha1, ha2⟩ ⟨hb1, hb2⟩ ⟨hc1, hc2⟩) xs hp
  simp only [primary, List.mem_append] at hy
  rcases hy with (hy | hy) | hy
  · exact binaryLeaves_bounded hlo _ _ ht0 y hy
  · exact binaryLeaves_bounded hlo _ _ ht1 y hy
  · exact binaryLeaves_bounded hlo _ _ ht2 y hy

theorem reciprocal_bounded {lo hi q : ℝ} (hq : 0 < q) (hlo : 0 < lo)
    (xs : List ℝ) (hp : ∀ x ∈ xs, lo ≤ x ∧ x ≤ hi) :
    ∀ y ∈ reciprocal q xs, q/hi ≤ y ∧ y ≤ q/lo := by
  intro y hy
  obtain ⟨x, hx, rfl⟩ := List.mem_map.mp hy
  obtain ⟨hl, hu⟩ := hp x hx
  have hx0 : 0 < x := lt_of_lt_of_le hlo hl
  have hhi0 : 0 < hi := lt_of_lt_of_le hx0 hu
  constructor
  · rw [div_le_div_iff₀ hhi0 hx0]
    nlinarith [hq.le]
  · rw [div_le_div_iff₀ hx0 hlo]
    nlinarith [hq.le]

/- Quantification (C): every accepted gate output has a combined stable leaf
   list (primary + q^2-reciprocal) whose members are all at least 1023.
   This is exactly the leaf floor consumed by T5GateBudget.gateCoefficientCap
   (1023 <= 1023.24 = 18433^2/332054). -/
theorem gate_full_floor (words : List Word)
    (hscan : (scan words 0#32).2 = 0#32) :
    ∀ x ∈ full (18433^2) 8 (words.map positiveNormalValue), (1023 : ℝ) ≤ x := by
  have hvals := gate_scan_values words hscan
  have hroots : ∀ x ∈ words.map positiveNormalValue,
      (1024 : ℝ) ≤ x ∧ x ≤ (332054 : ℝ) := by
    intro x hx
    obtain ⟨w, hw, rfl⟩ := List.mem_map.mp hx
    exact hvals w hw
  have hprim : ∀ y ∈ primary 8 (words.map positiveNormalValue),
      (1024 : ℝ) ≤ y ∧ y ≤ (332054 : ℝ) :=
    primary_bounded (by norm_num) 8 _ hroots
  have hrec : ∀ y ∈ reciprocal (18433^2)
      (primary 8 (words.map positiveNormalValue)).reverse,
      ((18433^2 : ℝ)/332054) ≤ y := by
    intro y hy
    exact (reciprocal_bounded (by norm_num : (0 : ℝ) < 18433^2)
      (by norm_num : (0 : ℝ) < 1024) _
      (fun x hx => hprim x (List.mem_reverse.mp hx)) y hy).1
  intro x hx
  simp only [full, List.mem_append] at hx
  rcases hx with hx | hx
  · exact (by norm_num : (1023 : ℝ) ≤ 1024).trans (hprim x hx).1
  · have hh := hrec x hx
    have hn : ((18433^2 : ℝ)/332054) ≥ (1023 : ℝ) := by norm_num
    linarith

end FT1536.Run2.T5KeyGenQuant
