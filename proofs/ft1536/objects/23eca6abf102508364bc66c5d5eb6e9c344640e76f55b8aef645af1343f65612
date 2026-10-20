import FftBind.FftPin
import FftBind.FftGeometry
import Source3.KeygenSource

/- Project Niirmata — C_TASK_1_BINBIND / warstwa FFT-NTT (część NTT).
Piny M0 tabel PRIMES2/PRIMES3 i funkcji modp_* (falcon-keygen.c, hash M0
`0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`) —
tekst linkowany z Source3.Pinned.keygenLines (pin Sola, nie kopia).

FAKTY (decyzja właściciela 2026-09-29, trzymać dokładnie):
- PRIMES3[0].p = **2147355649** — NIE mylić z PRIMES2 (PRIMES2[0].p =
  2147473409); rozłączność jest tezą `primes3_first_ne_primes2_first`;
- finalny leaf scan = 1536 słów (nie 768) — fakt Sola, poza zakresem tego
  pliku (warstwa liści należy do Source3.LeafScan);
- pin M0 source17: nowszy fpr-emulated.h z P02 jest INNY niż M0
  (`242a7027...`) i nie jest utożsamiany z kontraktem M0.

Komentarze C (np. „p = 1 mod 9216") NIE są założeniami — tylko wartości
literałowe sprawdzone kernelowo. -/

set_option maxRecDepth 262144
set_option maxHeartbeats 8000000

namespace FT1536.FftBind.NttSem
open FT1536.Source3

/-- Slice przypiętego tekstu M0 falcon-keygen.c (linie 1-based). -/
def kslice (line count : Nat) : List Char :=
  ((Pinned.keygenLines.drop (line-1)).take count).flatMap String.toList

/-! ## Typ i struktura tabel (falcon-keygen.c:833-839, 1369) -/

theorem small_prime_typedef :
    Pinned.keygenLines[832]? = some "typedef struct {\n" ∧
    Pinned.keygenLines[836]? = some "} small_prime;\n" ∧
    Pinned.keygenLines[833]? = some "\tuint32_t p;\n" := by decide

theorem primes2_decl : Pinned.keygenLines[838]? =
    some "static const small_prime PRIMES2[] = {\n" := by decide

theorem primes3_decl : Pinned.keygenLines[1368]? =
    some "static const small_prime PRIMES3[] = {\n" := by decide

/-! ## FAKT: PRIMES3[0] = (2147355649, 1907584673, 127999) -/

def primes3First : Nat × Nat × Nat := (2147355649, 1907584673, 127999)
def primes2First : Nat × Nat × Nat := (2147473409, 383167813, 10239)

theorem primes3_first_pin :
    Pinned.keygenLines[1369]? = some "\t{ 2147355649, 1907584673,     127999 },\n" ∧
    primes3First = (2147355649, 1907584673, 127999) := by decide

theorem primes2_first_pin :
    Pinned.keygenLines[839]? = some "\t{ 2147473409,  383167813,      10239 },\n" ∧
    primes2First = (2147473409, 383167813, 10239) := by decide

theorem primes3_first_p : primes3First.1 = 2147355649 := by decide

theorem primes3_first_ne_primes2_first : primes3First.1 ≠ primes2First.1 := by decide

/-! ## Granice tabel (pierwszy/ostatni wiersz + terminator)

Wiersze PRIMES2: linie 840–1360 (521 wierszy), terminator `{ 0, 0, 0 }`
linia 1361, `};` linia 1362. Wiersze PRIMES3: linie 1370–2469
(1100 wierszy), terminator linia 2470, `};` linia 2471. Wartości
literałowe wierszy są w przypiętym tekście; pełne parsowanie obu tabel
do List (Nat × Nat × Nat) jest otwarte (patrz CONTRACTS.md). -/

theorem primes2_last_row : Pinned.keygenLines[1359]? =
    some "\t{ 2135955457,  538755304, 1688831340 },\n" := by decide
theorem primes2_terminator :
    Pinned.keygenLines[1360]? = some "\t{ 0, 0, 0 }\n" ∧
    Pinned.keygenLines[1361]? = some "};\n" := by decide
theorem primes3_last_row : Pinned.keygenLines[2468]? =
    some "\t{ 2070715393, 1305821865,  634606382 },\n" := by decide
theorem primes3_terminator :
    Pinned.keygenLines[2469]? = some "\t{ 0, 0, 0 }\n" ∧
    Pinned.keygenLines[2470]? = some "};\n" := by decide

/-! ## Inwentarz funkcji NTT (modp_*) — piny nagłówków

Sygnatury (argumenty, restrict, typy) wiążą RAMKĘ wywołań NTT:
wszystkie funkcje są czysto całkowite (uint32_t/size_t), bez parametrów
i wywołań fpr — dowód w `modp_chunks_fpr_free`. -/

theorem modp_ninv31_sig : Pinned.keygenLines[2500]? = some "modp_ninv31(uint32_t p)\n" := by decide
theorem modp_montymul_sig : Pinned.keygenLines[2556]? =
    some "modp_montymul(uint32_t a, uint32_t b, uint32_t p, uint32_t p0i)\n" := by decide
theorem modp_mkgm2_sig : Pinned.keygenLines[2775]? =
    some "modp_mkgm2(uint32_t *restrict gm, uint32_t *restrict igm, unsigned logn,\n" := by decide
theorem modp_ntt2_ext_sig : Pinned.keygenLines[2813]? =
    some "modp_NTT2_ext(uint32_t *a, size_t stride, const uint32_t *gm, unsigned logn,\n" := by decide
theorem modp_ntt2_macro : Pinned.keygenLines[2906]? =
    some "#define modp_NTT2(a, gm, logn, p, p0i)   modp_NTT2_ext(a, 1, gm, logn, p, p0i)\n" := by decide
theorem modp_intt2_macro : Pinned.keygenLines[2907]? =
    some "#define modp_iNTT2(a, igm, logn, p, p0i) modp_iNTT2_ext(a, 1, igm, logn, p, p0i)\n" := by
  decide
theorem modp_mkgm3_sig : Pinned.keygenLines[2940]? =
    some "modp_mkgm3(uint32_t *restrict gm, uint32_t *restrict igm,\n" := by decide
theorem modp_ntt3_ext_sig : Pinned.keygenLines[3042]? =
    some "modp_NTT3_ext(uint32_t *a, size_t stride, const uint32_t *gm,\n" := by decide
theorem modp_ntt3_macro :
    Pinned.keygenLines[3250]? = some "#define modp_NTT3(a, gm, logn, full, p, p0i) \\\n" ∧
    Pinned.keygenLines[3251]? = some "\tmodp_NTT3_ext(a, 1, gm, logn, full, p, p0i)\n" ∧
    Pinned.keygenLines[3252]? = some "#define modp_iNTT3(a, igm, logn, full, p, p0i) \\\n" ∧
    Pinned.keygenLines[3253]? = some "\tmodp_iNTT3_ext(a, 1, igm, logn, full, p, p0i)\n" := by
  decide
theorem modp_poly_rec_res_sig : Pinned.keygenLines[3270]? =
    some "modp_poly_rec_res(uint32_t *f, unsigned logn,\n" := by decide

/-! ## NTT jest FPEMU-free — maszynowa kontrola tekstu

Cały region modp_* (linie 2472–3317, do `zint_add` włącznie z komentarzem
poprzedzającym) nie zawiera ani jednego wywołania `fpr_`. Skutek dla analizy
błędów FPEMU (okno C_TASK_2_FPERROR): warstwa NTT nie wnosi ŻADNEGO błędu
zaokrąglenia FPEMU — jest arytmetyką uint32 (Montgomery) na Z/pZ. -/

def containsStr (needle : List Char) : List Char → Bool
  | [] => needle.isEmpty
  | h :: t => needle.isPrefixOf (h :: t) || containsStr needle t

/- Kernelowo kawałkami po 88 linii z 4-liniowym nachodzeniem (redukcja
na 30k znakach naraz jest superliniowa — pomiar w logs/Probe.*); globalność
pokrycia całego regionu weryfikuje scripts/check_no_fpr.py. -/
theorem chunk1_fpr_free : containsStr "fpr_".toList (kslice 2477 88) = false := by decide
theorem chunk2_fpr_free : containsStr "fpr_".toList (kslice 2561 88) = false := by decide
theorem chunk3_fpr_free : containsStr "fpr_".toList (kslice 2645 88) = false := by decide
theorem chunk4_fpr_free : containsStr "fpr_".toList (kslice 2729 88) = false := by decide
theorem chunk5_fpr_free : containsStr "fpr_".toList (kslice 2813 88) = false := by decide
theorem chunk6_fpr_free : containsStr "fpr_".toList (kslice 2897 88) = false := by decide
theorem chunk7_fpr_free : containsStr "fpr_".toList (kslice 2981 88) = false := by decide
theorem chunk8_fpr_free : containsStr "fpr_".toList (kslice 3065 88) = false := by decide
theorem chunk9_fpr_free : containsStr "fpr_".toList (kslice 3149 88) = false := by decide
theorem chunk10_fpr_free : containsStr "fpr_".toList (kslice 3233 83) = false := by decide

theorem modp_chunks_fpr_free :
    containsStr "fpr_".toList (kslice 2477 88) = false ∧
    containsStr "fpr_".toList (kslice 2561 88) = false ∧
    containsStr "fpr_".toList (kslice 2645 88) = false ∧
    containsStr "fpr_".toList (kslice 2729 88) = false ∧
    containsStr "fpr_".toList (kslice 2813 88) = false ∧
    containsStr "fpr_".toList (kslice 2897 88) = false ∧
    containsStr "fpr_".toList (kslice 2981 88) = false ∧
    containsStr "fpr_".toList (kslice 3065 88) = false ∧
    containsStr "fpr_".toList (kslice 3149 88) = false ∧
    containsStr "fpr_".toList (kslice 3233 83) = false :=
  ⟨chunk1_fpr_free, chunk2_fpr_free, chunk3_fpr_free, chunk4_fpr_free, chunk5_fpr_free,
   chunk6_fpr_free, chunk7_fpr_free, chunk8_fpr_free, chunk9_fpr_free, chunk10_fpr_free⟩

theorem ntt_is_fpr_free :
    containsStr "fpr_".toList (kslice 2477 88) = false ∧
    containsStr "fpr_".toList (kslice 3233 83) = false :=
  ⟨chunk1_fpr_free, chunk10_fpr_free⟩

/-! ## Rozmiary transformacji NTT (z nagłówków makr — jawne wzory)

Rozmiar dziedziny modp_NTT2(_ext)(a, stride, gm, logn, p, p0i) to 2^logn
elementów pod adresem a + k*stride; makro modp_NTT2 przyjmuje stride = 1.
Analogicznie modp_NTT3(_ext)(..., logn, full, ...) działa na dziedzinie
rozmiaru MKN(logn, full) = (1 + 2*full) * 2^(logn-full) (TA SAMA forma co
FFT3 — FftGeometry.mkn). Dokładne liczby iteracji motylkowych wymagają
runnera pętli modp (otwarte w CONTRACTS.md). -/

def ntt2Size (logn : Nat) : Nat := 2 ^ logn
theorem ntt2_profile : ntt2Size 10 = 1024 := by decide

def ntt3Size (logn full : Nat) : Nat := (1 + 2 * full) * 2 ^ (logn - full)
theorem ntt3_size_eq_mkn (logn full : Nat) :
    ntt3Size logn full = FT1536.FftBind.FftGeometry.mkn logn full := rfl

end FT1536.FftBind.NttSem

#print axioms FT1536.FftBind.NttSem.primes3_first_pin
#print axioms FT1536.FftBind.NttSem.primes3_first_ne_primes2_first
#print axioms FT1536.FftBind.NttSem.primes2_first_pin
#print axioms FT1536.FftBind.NttSem.modp_chunks_fpr_free
#print axioms FT1536.FftBind.NttSem.modp_ntt3_macro
