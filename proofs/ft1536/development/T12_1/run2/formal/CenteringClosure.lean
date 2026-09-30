/-
FT1536 CENTERING_CLOSURE — kernel-checked arithmetic closure of the centering
error interval (delta = probability that a positive Sign reply is rejected by
mathematical Verify, finite-box G16 model) and of the all-key T5 bridge.

Scope of THIS module (all kernel-checked, exact ℚ arithmetic):
  1. the exact interval endpoints (honest_lower/upper_rational from Astra's
     pinned `centering_interval_closure.json`, SHA256 5ac5c576...) lie in the
     open three-significant-digit bracket and satisfy the headline claim
     `delta < 1.27e-24` with slack (honestHi < 127/10^26);
  2. the conservative T5 arithmetic margin (H3 error contract, exact QQ
     propagation): g00 < 1/64 and source-to-leaf floor > 991 (machine word
     0x4090000053700377 decoding included);
  3. tau = (1+a)^1536 - 1 < 2^-40 (a = 6y/(1-y)^2, y = 2^-65) via a
     self-contained (1+a)^n <= 1 + 2na lemma;
  4. the all-key bridge prefactors with rational budgets
     (tauB = 2^-40, rejB = 2^-24, boxB = 10^-1000):
       lb*rawLo > 1265/10^27  and  ub*rawHi < 127/10^26,
     hence `all_keys_bridge_closure`: for EVERY admissible key the claim
     `1.265e-24 < delta < 1.27e-24` follows from exactly two named premises.

Remaining named premises (NOT proved here — this is the honest boundary of
this closure; mirror of the `complete_new_kernel_source_binding=false` scope):
  - `hraw`    : the numeric wiring rawLo <= rawBad <= rawHi (Astra's radial
                Arb product + corrections; sage-side, kernel binding of the
                products/tails is their stated open item);
  - `hbridge` : the analytic bridge transport for every admissible key
                (T5 dual theta bound + Poisson all-center coset mass
                comparison supplying `FiniteFlat` + norm/coordinate MGF
                transport + exact cap16 after-Emit relation);
  - source-domain: `Adm` is an abstract parameter standing for "every
    successful existing KeyGen passes its mandatory leaf gate" (binding to
    the actual FT1536 KeyGen is outside this module).

Relation to Astra's Run2 (no double accounting): their
`GuaranteedDigits.three_significant_digits` covers the per-key flat/reject
transfer; this module adds the corrected-interval bracket, the kernelized T5
margins (their `t5_conservative_margin.sage` was sage-only) and the all-key
bridge prefactors (their `legal_key_bridge_numbers.sage` was sage-only).
Companion exact/RealBall checks: sage/check_closure.sage
(CLOSURE_ARITHMETIC_PASS, logs/check_closure.log).
-/
import Mathlib.Data.Rat.Defs
import Mathlib.Basic.Real.Basic
import Mathlib.Tactic

namespace FT1536.CenteringClosure

/- ## 1. Exact interval endpoints (pinned record) -/

/-- Lower end of the corrected (honest) centering interval, exact rational. -/
def honestLo : ℚ :=
  10260880508318760891653070367525016986867591729469470280627172150863597913629111048780767610453241283654760952447048997865689080389623198386594468829293001 /
  8104522595470689372094546608771799123071184047348509570304018222052056272290836223436927829974812098219136497287696853871865529444163623648216552410378835326291370709768573288448

/-- Upper end of the corrected (honest) centering interval, exact rational. -/
def honestHi : ℚ :=
  5137559114731899136177356712616901192099874652136241987713288157609061997292540341902318914595866495742214384870562497506941387951348757122371097488122549 /
  4052261297735344686047273304385899561535592023674254785152009111026028136145418111718463914987406049109568248643848426935932764722081811824108276205189417663145685354884286644224

/-- Conservative rational enclosure of the raw (uncorrected) interval. -/
def rawLo : ℚ := 1266068 / 10^30
def rawHi : ℚ := 1267826 / 10^30

theorem honest_in_bracket :
    (1265:ℚ)/10^27 < honestLo ∧ honestHi < (1275:ℚ)/10^27 := by
  norm_num [honestLo, honestHi]

theorem honest_upper_lt_claim : honestHi < (127:ℚ)/10^26 := by
  norm_num [honestHi]

theorem honest_lower_gt_floor : (126:ℚ)/10^26 < honestLo := by
  norm_num [honestLo]

/- ## 2. Conservative T5 arithmetic margin (H3 error contract), exact ℚ -/

def u : ℚ := 1 / 281474976710656
def eps : ℚ := 1 / 1125899906842624
-- 2^900 jako literał: norm_num nie ewaluuje 2^900 pod Inv w tym toolchainie
def tiny : ℚ := 1 / 8452712498170643941637436558664265704301557216577944354047371344426782440907597751590676094202515006314790319892114058862117560952042968596008623655407033230534186943984081346699704282822823056848387726531379014466368452684024987821414350380272583623832617294363807973376

/-- Complex-multiplication error transport on the recurrence path. -/
def cmul (m e ce : ℚ) : ℚ :=
  2*m*ce + 2*e*(1+ce) + 5*u*(m+e)*(1+ce) + 5*tiny

/-- One recurrence step: error update at doubling-tripling scale m. -/
def sErr (m err : ℚ) : ℚ :=
  err + cmul m err eps + u*(3*m + err + cmul m err eps) + tiny

def e1 : ℚ := sErr 2 eps
def e2 : ℚ := sErr 6 e1
def e3 : ℚ := sErr 18 e2
def e4 : ℚ := sErr 54 e3
def e5 : ℚ := sErr 162 e4
def e6 : ℚ := sErr 486 e5
def e7 : ℚ := sErr 1458 e6
def e8 : ℚ := sErr 4374 e7
def m8 : ℚ := 13122
def b1 : ℚ := cmul m8 e8 eps
def b2 : ℚ := cmul (2*m8) b1 eps
def sq1 : ℚ := cmul 1 eps eps
def c1 : ℚ := cmul m8 e8 sq1
def c2 : ℚ := cmul (2*m8) c1 eps
def bc : ℚ := b2 + c2 + u*(4*m8 + b2 + c2) + tiny
def e9 : ℚ := e8 + bc + u*(5*m8 + e8 + bc) + tiny
def n1536 : ℚ := 1536
def t5sq : ℚ := 2*n1536*e9 + e9^2 + u*(n1536+e9)^2 + tiny
def t5norm : ℚ := 2*t5sq + u*(2*(n1536+e9)^2*(1+u)) + tiny
def t5g00 : ℚ := 2*t5norm + u*(4*(n1536+e9)^2*(1+u)^2) + tiny

theorem t5_g00_bound : t5g00 < 1/64 := by
  norm_num [t5g00, t5norm, t5sq, e9, bc, c2, c1, sq1, b2, b1,
    e8, e7, e6, e5, e4, e3, e2, e1, sErr, cmul, m8, n1536, u, eps, tiny]

/-- Machine word of the mandatory leaf gate, exact IEEE-754 decode. -/
def machineWord : ℕ := 0x4090000053700377

theorem machine_decode :
    (machineWord >>> 52) % 2048 = 1033 ∧ machineWord % 2^52 = 1399849847 := by
  decide

/-- Exact value of the decoded machine word: (2^52 + frac) * 2^(1033-1023-52). -/
def machine : ℚ := 4503601027220343 / 4398046511104

theorem machine_eq : machine = (2^52 + 1399849847) / 2^42 := by
  norm_num [machine]

def t5minus : ℚ := 1 - u
def t5plus : ℚ := 1 + u
def t5lo : ℚ := t5minus^20 / t5plus^11
def t5hi : ℚ := t5plus^20 / t5minus^11

/-- Source-to-leaf floor of the conservative T5 margin. -/
theorem t5_leaf_floor_gt :
    (991:ℚ) < machine * min ((31:ℚ)/32 / t5hi) ((32:ℚ)/33 * t5lo / t5plus) := by
  have hA : (991:ℚ) < machine * ((31:ℚ)/32 / t5hi) := by
    norm_num [t5hi, t5minus, t5plus, machine, u]
  have hB : (991:ℚ) < machine * ((32:ℚ)/33 * t5lo / t5plus) := by
    norm_num [t5lo, t5minus, t5plus, machine, u]
  rcases le_total ((31:ℚ)/32 / t5hi) ((32:ℚ)/33 * t5lo / t5plus) with h | h
  · rw [min_eq_left h]; exact hA
  · rw [min_eq_right h]; exact hB

/- ## 3. tau budget: (1+a)^1536 - 1 < 2^-40, exact ℚ -/

def t5y : ℚ := 1 / 36893488147419103232
def t5a : ℚ := 6*t5y / (1 - t5y)^2

theorem pow_succ_le (a : ℚ) (ha : 0 ≤ a) :
    ∀ n : ℕ, 2 * (n:ℚ) * a ≤ 1 → (1 + a)^n ≤ 1 + 2 * (n:ℚ) * a := by
  intro n
  induction n with
  | zero => intro _; simp
  | succ n ih =>
    intro h
    have hnn : (2:ℚ) * (n:ℚ) * a ≤ 1 := by
      have h' := h
      simp only [Nat.cast_succ] at h' ⊢
      nlinarith
    calc (1 + a)^n.succ = (1 + a)^n * (1 + a) := by rw [pow_succ]
      _ ≤ (1 + 2 * (n:ℚ) * a) * (1 + a) :=
        mul_le_mul_of_nonneg_right (ih hnn) (by nlinarith)
      _ ≤ 1 + 2 * (n.succ:ℚ) * a := by
        push_cast
        nlinarith

theorem tau_budget : (1 + t5a)^1536 - 1 < (1:ℚ)/1099511627776 := by
  have h0 : (0:ℚ) ≤ t5a := by norm_num [t5a, t5y]
  have hp : 2 * (1536:ℚ) * t5a ≤ 1 := by norm_num [t5a, t5y]
  have hle := pow_succ_le t5a h0 1536 hp
  have hle' : (1 + t5a)^1536 ≤ 1 + 2 * (1536:ℚ) * t5a := by simpa using hle
  have hkey : (1 + t5a)^1536 - 1 ≤ (2:ℚ) * 1536 * t5a :=
    (sub_le_sub_right hle' (1:ℚ)).trans_eq (by ring)
  have h3072 : (2:ℚ) * 1536 * t5a < 1/1099511627776 := by norm_num [t5a, t5y]
  calc (1 + t5a)^1536 - 1 ≤ (2:ℚ) * 1536 * t5a := hkey
    _ < 1/1099511627776 := h3072

/- ## 4. All-key bridge prefactors (rational budgets) -/

def tauB : ℚ := 1 / 1099511627776
def rejB : ℚ := 1 / 16777216
-- 10^1000 jako literał (norm_num nie ewaluuje potęg pod Inv w tym toolchainie)
def boxB : ℚ := 1 / 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

/-- Lower prefactor of the rawBad -> delta bridge. -/
def bridgeLb : ℚ := (1 - boxB) / (1 + tauB)
/-- Upper prefactor of the rawBad -> delta bridge. -/
def bridgeUb : ℚ := (1 + tauB) / ((1 - tauB) * (1 - boxB) * (1 - rejB))

theorem bridge_lb_nonneg : 0 ≤ bridgeLb := by
  norm_num [bridgeLb, boxB, tauB]

theorem bridge_ub_nonneg : 0 ≤ bridgeUb := by
  norm_num [bridgeUb, boxB, tauB, rejB]

theorem bridge_lb_rawLo : (1265:ℚ)/10^27 < bridgeLb * rawLo := by
  norm_num [bridgeLb, rawLo, boxB, tauB]

theorem bridge_ub_rawHi : bridgeUb * rawHi < (127:ℚ)/10^26 := by
  norm_num [bridgeUb, rawHi, boxB, tauB, rejB]

/- ## 5. Closure template over all admissible keys -/

/-- Arithmetic closure of the headline claim for EVERY admissible key,
from exactly two named premises: the raw numeric enclosure and the analytic
bridge transport (see module docstring for the honest boundary). -/
theorem all_keys_bridge_closure {K : Type} (delta : K → ℝ) (Adm : K → Prop)
    (rawBad : ℝ)
    (hraw : (rawLo:ℝ) ≤ rawBad ∧ rawBad ≤ (rawHi:ℝ))
    (hbridge : ∀ k, Adm k →
      (bridgeLb:ℝ) * rawBad ≤ delta k ∧ delta k ≤ (bridgeUb:ℝ) * rawBad) :
    ∀ k, Adm k → (1265:ℝ)/10^27 < delta k ∧ delta k < (127:ℝ)/10^26 := by
  intro k hk
  rcases hbridge k hk with ⟨hl, hu⟩
  have h1 : (1265:ℝ)/10^27 < (bridgeLb:ℝ) * rawLo := by
    norm_num [bridgeLb, rawLo, boxB, tauB]
  have h2 : (bridgeUb:ℝ) * rawHi < (127:ℝ)/10^26 := by
    norm_num [bridgeUb, rawHi, boxB, tauB, rejB]
  have hblb : (0:ℝ) ≤ (bridgeLb:ℝ) := by norm_num [bridgeLb, boxB, tauB]
  have hbub : (0:ℝ) ≤ (bridgeUb:ℝ) := by norm_num [bridgeUb, boxB, tauB, rejB]
  constructor
  · have gap : (0:ℝ) ≤ rawBad - (rawLo:ℝ) := by nlinarith
    have hmono : (bridgeLb:ℝ) * rawLo ≤ (bridgeLb:ℝ) * rawBad := by
      nlinarith [mul_nonneg hblb gap]
    nlinarith
  · have gap : (0:ℝ) ≤ (rawHi:ℝ) - rawBad := by nlinarith
    have hmono : (bridgeUb:ℝ) * rawBad ≤ (bridgeUb:ℝ) * rawHi := by
      nlinarith [mul_nonneg hbub gap]
    nlinarith

/-- Headline claim: every admissible key satisfies the computed interval
rounding `delta < 1.27e-24`, with the same two named premises. -/
theorem all_keys_headline {K : Type} (delta : K → ℝ) (Adm : K → Prop)
    (rawBad : ℝ)
    (hraw : (rawLo:ℝ) ≤ rawBad ∧ rawBad ≤ (rawHi:ℝ))
    (hbridge : ∀ k, Adm k →
      (bridgeLb:ℝ) * rawBad ≤ delta k ∧ delta k ≤ (bridgeUb:ℝ) * rawBad) :
    ∀ k, Adm k → delta k < (127:ℝ)/10^26 :=
  fun k hk => (all_keys_bridge_closure delta Adm rawBad hraw hbridge k hk).2

end FT1536.CenteringClosure
