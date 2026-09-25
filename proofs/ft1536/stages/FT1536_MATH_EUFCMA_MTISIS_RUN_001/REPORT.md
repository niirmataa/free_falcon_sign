# T12.1 — matematyczne składniki EUF-CMA → MT-ISIS

**Wynik: PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW.**
Nie uzyskano `PROVED_CONDITIONAL_REDUCTION`. Powstało101 kernelowo
sprawdzonych twierdzeń w15 własnych modułach Lean oraz osobny audyt eksportów.
Własny świeży replay: **19/19 exit0, czyste logi,3/3 produkty zgodne**.

Autor projektu: Niirmata. Wykonawca: GPT-6 Astra Fast
(`openai/gpt-6-astra-fast`), sesja `ses_f33dcb1cbffe1cK536p26REYAg`,
świeży kontekst zadania,2026-09-23. Bez delegacji i operacji zapisujących Git.

## 1. Co zostało dowiedzione

| Rodzina | Rzeczywisty zakres |
|---|---|
| MathSign.full_reply_law | Normalizacja i dokładne masy cap(n), exhaustion i pierwszego terminalnego wyniku; IID jest definicją tego kernela |
| cap_mixture / success_vs_capped_second | p=1−(1−a)^n, mieszanina z abortem i kierunkowy drugi moment1/p przy p>0; support mismatch przy p=0 |
| Gaussian/public law | Finite box, dodatni normalizer D^B, dokładny support Q<B, pełny norm-support mieści się w box, znormalizowany pushforward i honest U*K |
| Divergence | AC, likelihood ratio, chi²=∞ przy mismatch, drugi moment, wspólna faktoryzacja oraz (1+e_img)(1+e_sign)−1 |
| Adaptive | Pełne historie, history-dependent kernels, mnożenie lokalnych momentów, product bound i stałe (1+e)^n−1 |
| EventTransfer | (a−b)²≤Δa(1−a), zadany górny pierwiastek Phi, monotoniczność, Δ=0, b=0/1, Phi∈[b,1] |
| ROM/PublicCode | Publiczny kod simSign; SeenSign przed wszystkimi gałęziami; stop przy konflikcie; Good/Unique, cached H, nieczytanie przyszłych celów w kroku hash |
| Extraction | Właściwy indeks TEGO SAMEGO celu, także final fresh H; ≤Q_H+1; A(extract)=c_j i ścisła norma z Verify; bez guessing factor |
| Conflicts | Jednostajny świeży nonce po historii, bound cardinality, uśrednienie, union bound i dokładna suma Q_sQ_H+Q_s(Q_s−1)/2 |
| TraceBound | Końcowa postać min(1,eps+Phi(...)) dla abstrakcyjnych skończonych praw transkryptów oraz monotoniczne podstawienie boundu MT |

Wszystkie typy, także dodatkowe przesłanki i rzeczywiste dziedziny, są w
`formal_types.txt`. Nazwa `stopped_adaptive_chi2` nie dowodzi sama z siebie,
że zdefiniowane kernels są prawami pełnej gry kryptograficznej.

## 2. Trzy wymagane warstwy wyniku

### (a) Lemat warunkowy

**Zamknięte są składniki oraz finite-trace inequality. Pełny lemat
warunkowy ordinary EUF-CMA→MT-ISIS pozostaje OPEN.** Nie ma jeszcze typów
i interpretera `ClassicalAdversary beta`/`MTAdversary`, dowodu utożsamiającego
lokalne kernels z całą interakcją, włączenia jednego latent key i bounded
challenge list, ani typed bit-cost theorem. Zatem nie eksportuję twierdzenia
`exists B ... Resources(B) ... AdvEUF≤...`.

### (b) Rzeczywiście zrealizowane przesłanki Sigma_math

Jawna instancja to **E0/coefficient-valued finite-box G16**. Jest pełną
skończoną specyfikacją prawa odpowiedzi, z uniform nonce320bit, strict Q<B,
do16 IID prób przy ustalonym c oraz jednorazowym Emit po acceptance.
Puste włókno, norm-exhaustion i signed16 failure mają jawne POST_ABORT.
Nie ma cichego post-sign Verify. Jest oddzielny publiczny joint law D^B oraz
kod symulatora względem parametrycznego `PublicSampler.run` bez sk/future targets.

**Niezrealizowane:** efektywny sampler z kosztem, małe e_img/e_sign,
accepted conditional-law factorization dla tego konkretnego body po Emit,
globalna symulacja ROM. `muH` jest marginalem parametrycznego muKey,
nigdy uniform public key. Nie podstawiono nieznanych błędów jako zera.

### (c) Mosty do FT1536/M0/C

Pozostają OPEN: nieobcięty coset Gaussian (zmienia masę retry), M0 ogólne E,
source proposal/retry/PRNG, definedness/STUCK/nonreturn, pre-cast transport,
byte codec/parser/Verify, successful K_seed[E], real H2P/XOF i zasoby kodu.
Szczegóły i przyporządkowanie T07–T14: `BRIDGE_LEDGER.md`.

## 3. Ważny wynik negatywny: centrowanie A2

Nie wystarcza Q(z)<B. W jednym aktywnym bloku:

```
z1 = (9217, -5000), z2 = (32767, 18000), reszta współczynników = 0
Q(z1,z2)                      = 2051350378 < B=2093922385
Q(center_q(z1),z2)            = 2143496945 > B
```

z2 mieści się w signed16. To kernelowy kontrprzykład do **ogólnego lematu
transportu normy**, nie dowód, że rzeczywisty FT1536 osiąga tę próbkę.
Jego znaczenie: nie wolno budować symulacji na założeniu, że każdy dodatni
Emit automatycznie przejdzie późniejszy Verify.

## 4. Weryfikacja wykonania

- Lean4.34.0; Mathlib `5ed2965256430c3649e86755f9576b54eca72435`.
- SageMath10.9, rzeczywiste `sage check_bounds.sage`, preparser, ZZ/QQ,
  RealBallField256. Nie użyto Sage-Python/Fraction jako rachunku.
- Źródłowa closure importów:3456 modułów;17280 pinów cached artifacts,
  dodatkowo9825 źródeł/configów w początkowym inventory bibliotek.
- Finalne101 eksportów: transitive axioms wyłącznie podzbiory
  propext/Classical.choice/Quot.sound. Brak sorry/admit/native_decide/
  Lean.ofReduceBool/axiomu celu i brak wyciszania ostrzeżeń w nowych źródłach.
- Fresh replay w NOWYM DEST, z zewnętrznym pinem semantycznego seeda:
  19/19 kroków,3/3 dokładne produkty. Suma wall jobs24.628s
  (bez kosztu sprawdzenia pinów). MaxRSS2509688KiB. Własne cache świeże.
-4/4 negatywne kontrole sterownika: zły external pin, zmieniony member,
  niepełny manifest i istniejący DEST odrzucone przed uruchomieniem proofu.
-34 katalogi wcześniejszych prób, ich źródła i dostępne raw logs/receipty
  zachowano w history/. Nieudane drogi opisuje FAILED_ROUTES.md.

Biblioteki są shared RO z dokładnymi pinami; nie przebudowano tu upstream
Mathlib. Własne15 modułów i Audit przebudowano od zera. To własna kontrola
autora, **nie niezależny review** i nie owner acceptance.

## 5. Piny i zakres administracyjny

- TASK_ID=`FT1536_MATH_EUFCMA_MTISIS_RUN_001`, ROADMAP=`T12.1`.
- TASK SHA256=`0fe2ad810e476e44e6cc3a1bca0bcc409004810cfe4b5424523ba914ac9e0cc3`.
- Bootstrap MANIFEST SHA256=`a1fe3416478599c3f19200cdfeedc80e98a1291678dd1c871b3f6e6511d28b15`,25 wejść zgodnych.
- BASE=`c5faaeb6395c8238724494e8000eb6df55e65baf`.
- HEAD odczytany na starcie i przy odbiorze własnym: `ba1c576ea680e4d8cf6bebbdc9e356bbf64f20c1`, main.
- REPLAY_SEED SHA256=`a5ff7f1a2f34dd0735b35c1b84afb915773c226e797f16b0b767bea777b4b707`.
- Zewnętrzny finalny pin REPORT/OUTPUTS znajduje się w W/HANDOFF.md oraz
  komunikacie końcowym; raport nie próbuje hashować sam siebie.

Wszystkie zapisy autora pozostały we własnym W. Nie zmieniano P02, root STATE,
stages, indeksu ani gałęzi; niczego nie publikowano. Import i commit po
niezależnym odbiorze pozostają po stronie koordynatora.

## 6. Moja ocena

Udało się zamienić najważniejszy rachunek prawdopodobieństwa i znaczną część
operacyjnego reduktora w rzeczywiste dowody kernelowe. Najcenniejsze są
kierunkowy transfer Phi bez degeneracyjnych założeń, pełna historia adaptacyjna
i uczciwe rozliczenie abortów oraz centrowania. Nie udało się domknąć
interaktywnej gry i zasobów. Bez nich nazwanie wyniku pełną redukcją byłoby
nieprawdziwe. Następny krok to niezależny scoped review tych eksportów,
potem interpreter/semantic binding wskazany w NEXT_INTERFACE; samo lepsze
oszacowanie samplera nie zastąpi tego brakującego proofu.
