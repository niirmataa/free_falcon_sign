import FftBind.FftPin
import Source3.CLogicParser
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Ring

/- Project Niirmata — C_TASK_1_BINBIND / warstwa FFT-NTT.
Rozmiary transformacji FFT3 wyliczone z WYKONANIA przypiętej treści M0
(makro MKN, falcon-fft.c:755) i rozpisy pętli transformacji — dokładne
liczby z egzekucji, NIE z komentarzy C. Styl Source3: pinned text ->
parser (odrzucanie każdego nadmiarowego tokenu) -> typed execution.
Komentarze C ani RN binary64 nie są tu żadnym założeniem. -/

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.FftBind.FftGeometry
open FT1536.Source3 B20.C

/-! ## Makro MKN (falcon-fft.c:755) — text pin + parser + wykonanie -/

def mknWrap : String := "#define MKN(logn, full)   "
def mknBody : String := "((size_t)(1 + ((full) << 1)) << ((logn) - (full)))\n"

theorem mkn_split : FftPin.fftLines[754]? = some (mknWrap ++ mknBody) := by decide

def nameLogn : Name := "logn".toList
def nameFull : Name := "full".toList

/-- Znormalizowany program makra MKN. `(size_t)` jest tu jawnym rzutem na
`.u64` (PROFILE word_bits.size_t = 64); parametry makra są podstawiane na
poziomie tokenów jak `FprPrimitives.substitute`. -/
def mknExpr : CLogic.Expr :=
  .bin .shl
    (.cast .u64 (.bin .add (.literal .i32 1) (.bin .shl (.var nameFull) (.literal .i32 1))))
    (.bin .sub (.var nameLogn) (.var nameFull))

/-- Makro-parametrowe podstawienie tokenów: `(logn)` -> `logn`,
`(full)` -> `full` (jak substitute w Source3.FprPrimitives). -/
def substitute : List Token → List Token
  | ['(' ]::['l','o','g','n']::[')']::ts => "logn".toList :: substitute ts
  | ['(' ]::['f','u','l','l']::[')']::ts => "full".toList :: substitute ts
  | t::ts => t :: substitute ts
  | [] => []

/-- Parser jednego makra: rozpoznaje CAŁE jego ciało po podstawieniu
parametrów; każdy nadmiarowy/zmieniony token odrzuca program. -/
def parseMkn : List Token → Option CLogic.Expr
  | tk0 :: tk1 :: sz :: tk3 :: tk4 :: one :: tk6 :: tk7 :: fullv :: tk9 :: one2 ::
    tk11 :: tk12 :: tk13 :: tk14 :: lognv :: tk16 :: fullv2 :: tk18 :: tk19 :: [] =>
      if tk0 = ['('] && tk1 = ['('] && sz = "size_t".toList && tk3 = [')'] &&
          tk4 = ['('] && tk6 = ['+'] && tk7 = ['('] && fullv = "full".toList &&
          tk9 = ['<','<'] && tk11 = [')'] && tk12 = [')'] && tk13 = ['<','<'] &&
          tk14 = ['('] && lognv = "logn".toList && tk16 = ['-'] &&
          fullv2 = "full".toList && tk18 = [')'] && tk19 = [')'] then do
        let a ← CLogicParser.number one
        let b ← CLogicParser.number one2
        if a = .literal .i32 1 && b = .literal .i32 1 then some mknExpr else none
      else none
  | _ => none

def mknTokens : Option (List Token) :=
  (CLogicParser.tokenize (mknBody.length+1) mknBody.toList).map substitute

theorem mkn_tokens_ok :
    mknTokens = some [
      ['('], ['('], "size_t".toList, [')'], ['('], "1".toList, ['+'], ['('],
      "full".toList, ['<','<'], "1".toList, [')'], [')'], ['<','<'], ['('],
      "logn".toList, ['-'], "full".toList, [')'], [')']] := by decide

def mknParse : Option CLogic.Expr :=
  (CLogicParser.tokenize (mknBody.length+1) mknBody.toList).bind (fun ts => parseMkn (substitute ts))

theorem mkn_source : mknParse = some mknExpr := by decide

def mknEnv (logn full : Nat) : Env := fun n =>
  if n = nameLogn then some (.u32 (BitVec.ofNat 32 logn))
  else if n = nameFull then some (.u32 (BitVec.ofNat 32 full))
  else none

/-- Wykonanie sparsowanego MKN na argumentach (logn, full). Odrzuca
nielegalne przesunięcia (np. full > logn) zamiast przyjmować wartość. -/
def mknEval (logn full : Nat) : Option Val :=
  CLogic.eval (fun _ _ => none) (mknEnv logn full) 32 mknExpr

/-- Zamknięta forma rozmiaru: MKN(logn, full) = (1 + 2*full) * 2^(logn-full). -/
def mkn (logn full : Nat) : Nat := (1 + 2 * full) * 2 ^ (logn - full)

theorem mkn_zero : ∀ logn, mkn logn 0 = 2 ^ logn := by
  intro logn
  simp [mkn]

theorem mkn_full_one : ∀ logn, mkn logn 1 = 3 * 2 ^ (logn - 1) := by
  intro logn
  simp [mkn]

/-- Wykonanie parsera = zamknięta forma; dla 0 < logn ≤ 10 i full ≤ 1
(profil FT1536: logn = 10). Dowód: pełne wyliczenie przypadków kernelowo. -/
theorem mkn_exec (logn full : Nat) (h1 : 1 ≤ logn) (h2 : logn ≤ 10) (h3 : full ≤ 1) :
    mknEval logn full = some (.u64 (BitVec.ofNat 64 (mkn logn full))) := by
  interval_cases logn <;> interval_cases full <;> first | omega | decide

/-! ## Dokładne rozmiary profilu (logn = 10) — wartości liczbowe -/

theorem mkn_profile_half : mkn 10 0 = 1024 := by decide
theorem mkn_profile_full : mkn 10 1 = 1536 := by decide
theorem mkn_exec_profile_half : mknEval 10 0 = some (.u64 1024#64) := by decide
theorem mkn_exec_profile_full : mknEval 10 1 = some (.u64 1536#64) := by decide

/-- Połówki (hn = n >> 1) — sloty real/imag. -/
theorem hn_profile_half : mkn 10 0 / 2 = 512 := by decide
theorem hn_profile_full : mkn 10 1 / 2 = 768 := by decide

/-! ## Rozpisy pętli falcon_FFT3 / falcon_iFFT3 (falcon-fft.c:758-965)

Iteracja wewnętrzna = trójka (m, u1, v) kroku podwajającego albo para
(vstart, u) kroku potrajającego; wartości wyliczone z egzekucji warunków
pętli (`t > tmin`, `t < n`, `u1 < hm`, `v < v2`) na Nat. -/

/-- Kroki podwajające FFT3 (`for (m = 2; t > tmin; m <<= 1)`, t = hn/2^k):
krotki (m, t, hm, ht) w kolejności źródłowej. -/
def fft3DoublingSteps (hn tmin : Nat) : List (Nat × Nat × Nat × Nat) :=
  (List.range (hn + 1)).filterMap (fun k =>
    let t := hn / 2^k
    if t > tmin then some (2^(k+1), t, 2^k, t/2) else none)

/-- Pełna rozpiska iteracji wewnętrznych (m, u1, v) kroku podwajającego,
w kolejności źródłowej (u1 rosnąco, v = u1*t + offset). -/
def fft3DoublingInner (hn tmin : Nat) : List (Nat × Nat × Nat) :=
  (fft3DoublingSteps hn tmin).flatMap (fun (m, t, hm, ht) =>
    (List.range hm).flatMap (fun u1 =>
      (List.range ht).map (fun j => (m, u1, u1 * t + j))))

/-- Krok potrajający FFT3 (`for (u = 0, v = 1 << logn; u < hn; u += 3,
v += 2)`): pary (v0, u) kolejnych iteracji; iteracji jest ⌈hn/3⌉. -/
def fft3Tripling (logn hn : Nat) : List (Nat × Nat) :=
  (List.range ((hn + 2) / 3)).map (fun i => (2 ^ logn + 2 * i, 3 * i))

/-- Kroki halvingowe iFFT3 (`for (m = 1 << (logn-1-full); t < n; m >>= 1)`
z t = t0*2^k, m = m0/2^k): krotki (m, t, hm, ht). -/
def ifft3HalvingSteps (t0 m0 n : Nat) : List (Nat × Nat × Nat × Nat) :=
  (List.range 64).filterMap (fun k =>
    let t := t0 * 2^k
    if t < n then some (m0 / 2^k, t, m0 / 2^(k+1), t/2) else none)

/-- Pełna rozpiska iteracji wewnętrznych (m, u1, v) kroku halwingowego
iFFT3 (v = u1*t + offset). -/
def ifft3HalvingInner (t0 m0 n : Nat) : List (Nat × Nat × Nat) :=
  (ifft3HalvingSteps t0 m0 n).flatMap (fun (m, t, hm, ht) =>
    (List.range hm).flatMap (fun u1 =>
      (List.range ht).map (fun j => (m, u1, u1 * t + j))))

end FT1536.FftBind.FftGeometry

#print axioms FT1536.FftBind.FftGeometry.mkn_source
#print axioms FT1536.FftBind.FftGeometry.mkn_exec
#print axioms FT1536.FftBind.FftGeometry.mkn_profile_full
#print axioms FT1536.FftBind.FftGeometry.mkn_exec_profile_full
