import FT1536.Basic
import Mathlib.Data.BitVec

namespace FT1536.Run2.KeygenLeafGate

abbrev Word := BitVec 64
abbrev Flag := BitVec 32
def lowerBits : Word := 0x4090000053700377#64
def upperBits : Word := 0x4114444d1a037d50#64
def oneBits : Word := 0x3ff0000000000000#64

/- Word operations in falcon-keygen.c:7470--7488 and 7768--7776. The
   surrounding FFT/KeyGen execution is a separate refinement obligation. -/
def positive (w : Word) : Bool :=
  ((w >>> 63)==0#64) && (((w >>> 52) &&& 0x7ff#64)!=0x7ff#64) && ((w <<< 1)!=0#64)

def positiveFlag (w : Word) : Flag := if positive w then 1#32 else 0#32
def mask (w : Word) : Word := 0#64-(positiveFlag w).setWidth 64
def stableWord (w : Word) : Word := (w &&& mask w) ||| (oneBits &&& ~~~(mask w))
def stableBad (w : Word) (bad : Flag) : Flag := bad ||| (positiveFlag w ^^^ 1#32)

def rangeValid (w : Word) : Flag :=
  (1#32 ^^^ ((w-lowerBits) >>> 63).setWidth 32) &&&
    (1#32 ^^^ ((upperBits-w) >>> 63).setWidth 32)

def leafStep (w : Word) (bad : Flag) : Word×Flag :=
  (stableWord w, stableBad w bad ||| (rangeValid (stableWord w) ^^^ 1#32))

theorem subtract_sign (x y : Word) (hx : x.toNat<2^63) (hy : y.toNat<2^63) :
    (x-y) >>> 63 = if x.toNat<y.toNat then 1#64 else 0#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_sub]
  split_ifs <;> norm_num only [BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod] at * <;> omega

theorem positive_sign (w : Word) (hw : positive w=true) : w.toNat<2^63 := by
  have h0 := (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp hw).1).1
  have hs : w >>> 63=0#64 := by simpa only [beq_iff_eq] using h0
  have hn := congrArg BitVec.toNat hs
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat,
    Nat.zero_mod] at hn
  omega

theorem range_valid_iff (w : Word) (hw : w.toNat<2^63) :
    rangeValid w=1#32 ↔ lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat := by
  rw [rangeValid, subtract_sign w lowerBits hw (by decide),
    subtract_sign upperBits w (by decide) hw]
  by_cases hl : w.toNat<lowerBits.toNat <;> by_cases hu : upperBits.toNat<w.toNat <;>
    simp [hl,hu]
  omega

theorem stableWord_cases (w : Word) : stableWord w=if positive w then w else oneBits := by
  cases hp : positive w <;> simp [stableWord, mask, positiveFlag, hp] <;>
    exact BitVec.and_allOnes

theorem stableBad_clear (w : Word) (bad : Flag) :
    stableBad w bad=0#32 ↔ bad=0#32 ∧ positive w=true := by
  rw [stableBad, BitVec.or_eq_zero_iff, BitVec.xor_eq_zero_iff]
  cases hp : positive w <;> simp [positiveFlag, hp]

theorem leafStep_clear (w : Word) (bad : Flag) :
    (leafStep w bad).2=0#32 ↔ bad=0#32 ∧ positive w=true ∧
      lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat := by
  change stableBad w bad ||| (rangeValid (stableWord w) ^^^ 1#32)=0#32 ↔ _
  rw [BitVec.or_eq_zero_iff, BitVec.xor_eq_zero_iff, stableBad_clear]
  constructor
  · rintro ⟨⟨hb,hp⟩,hg⟩
    rw [stableWord_cases, hp] at hg
    have hh := (range_valid_iff w (positive_sign w hp)).mp hg
    exact ⟨hb,hp,hh⟩
  · rintro ⟨hb,hp,hg⟩
    refine ⟨⟨hb,hp⟩, ?_⟩
    rw [stableWord_cases, hp]
    exact (range_valid_iff w (positive_sign w hp)).mpr hg

def scan : List Word → Flag → List Word×Flag
  | [], bad => ([],bad)
  | w::ws, bad =>
    let next := leafStep w bad
    let rest := scan ws next.2
    (next.1::rest.1,rest.2)

theorem scan_clear (ws : List Word) (bad : Flag) :
    (scan ws bad).2=0#32 ↔ bad=0#32 ∧ ∀ w∈ws,
      positive w=true ∧ lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat := by
  induction ws generalizing bad with
  | nil => simp [scan]
  | cons w ws ih =>
    simp only [scan, ih, leafStep_clear, List.mem_cons, forall_eq_or_imp]
    tauto

theorem accepted_scan_preserves (ws : List Word) (bad : Flag) (h : (scan ws bad).2=0#32) :
    (scan ws bad).1=ws := by
  induction ws generalizing bad with
  | nil => rfl
  | cons w ws ih =>
    have hp := ((scan_clear (w::ws) bad).mp h).2 w (by simp)
    have ht : (scan ws (leafStep w bad).2).2=0#32 := h
    change (leafStep w bad).1::(scan ws (leafStep w bad).2).1=w::ws
    rw [ih _ ht]
    simp only [leafStep, stableWord_cases, hp.1, ite_true]

/- Decode positive normal words. Accepted range checks imply this domain;
   no floating-point rounding contract is being assumed. -/
noncomputable def positiveNormalValue (w : Word) : ℝ :=
  ((2^52+w.toNat%2^52 : ℕ) : ℝ) * (2 : ℝ)^((w.toNat/2^52 : ℕ) - (1075 : ℤ))

theorem accepted_value_lower (w : Word)
    (hw : lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat) :
    (1024 : ℝ) ≤ positiveNormalValue w := by
  have he : 1033≤w.toNat/2^52 := by
    norm_num [lowerBits, upperBits] at hw
    omega
  have hez : (-42 : ℤ)≤(w.toNat/2^52 : ℕ)-(1075 : ℤ) := by omega
  have hp := zpow_le_zpow_right₀ (by norm_num : (1 : ℝ)≤2) hez
  have hm : (2^52 : ℝ)≤((2^52+w.toNat%2^52 : ℕ) : ℝ) := by
    exact_mod_cast Nat.le_add_right (2^52) (w.toNat%2^52)
  calc
    (1024 : ℝ) = 2^52*(2 : ℝ)^(-42 : ℤ) := by norm_num
    _ ≤ 2^52*(2 : ℝ)^((w.toNat/2^52 : ℕ)-(1075 : ℤ)) :=
      mul_le_mul_of_nonneg_left hp (by norm_num)
    _ ≤ positiveNormalValue w :=
      mul_le_mul_of_nonneg_right hm (zpow_nonneg (by norm_num) _)

theorem successful_scan_all_leaf_values (ws : List Word) (bad : Flag) (h : (scan ws bad).2=0#32) :
    ∀ w∈ws, positive w=true ∧ (1024 : ℝ)≤positiveNormalValue w := by
  intro w hw
  have hh := ((scan_clear ws bad).mp h).2 w hw
  exact ⟨hh.1,accepted_value_lower w hh.2⟩

end FT1536.Run2.KeygenLeafGate
