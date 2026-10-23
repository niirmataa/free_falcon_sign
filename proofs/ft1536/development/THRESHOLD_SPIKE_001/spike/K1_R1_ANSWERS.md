# K1_R1_ANSWERS — odpowiedzi toru R1 dla T-THRESHOLD (pytania K1 + minimalny zestaw R5 §2)

Data: 2026-10-21. Zlecenie: `development/T12_1/run2/notes/PROMPT_K1_R5_ANSWERS_001.md`
(okno boczne, nie przerywa głównej trasy R1). Odpowiedzi wyprowadzone wyłącznie
z akt R1 (`development/T12_1/source3/` — kanoniczne), `Extra/c` i fixture'ów
z pinami; nic poza tym plikiem nie zostało zmienione. Stan R1 na datę raportów:
2026-10-20 (checkpoint 194 discharge CLOSED). Pytania wg
`spike/K1_R1_QUESTIONS.md`; wstępne odpowiedzi właściciela:
`spike/K1_R1_ANSWERS_PRELIM.md` (zgodne, tu uszczegółowione dowodami).

Zasada: każde twierdzenie ma ścieżkę + linię / pin / commit. Czego R1 nie ma —
„OPEN w R1" z opisem, kiedy będzie. Dane natywne (WITNESS113) są oznaczone jako
NIEZAUFANE kandydackie — nie są przesłanką ani artefaktem.

---

## Pytanie 1 — odpowiedź: `G(seed*)` jest SHAKE/XOF-owe w strumieniu losowym + algebraiczne w transformatach; koszt MPC zdominują permutacje XOF

`G(seed*) = KeygenByteGame134.evaluate env input seed* = some (.inr packet)`
uruchamia pełny KeyGen ze źródła C. Strumień losowy to SHAKE256: seed jest
wstrzykiwany przez `shake_init(&fk->rng, 512)` + `shake_inject(seed)` +
`shake_flip`, a sampler f/g czyta strumień przez `shake_extract`
(`get_rng_u64`/`get_rng_u32_bounded`); dalej idzie algebraika: mq_NTT
(Montgomery, n=1536), `mq_div_18433`, root solver (`solve_NTRU*`), CRT.
Czyli: **XOF (permutacje Keccak) jako PRNG + algebraika w regionach 2–4**;
koszt MPC jest zdominowany przez XOF (1 perm ≈ 10³–10⁵ × G_frag wg
`spike/I3_SHAKE_MPC_COST.md` — to szacunek spike'a, nie R1).

źródło: `Extra/c/falcon-keygen.c:4690` (shake_context rng), `:5170`, `:5253-5267`
(shake_init 512 / shake_inject seed), `:5271-5283` (rng_ready + shake_flip),
`:4707-4747` (get_rng_u64 / get_rng_u32_bounded → shake_extract);
`Extra/c/shake.c`, `Extra/c/frng.c` (SHAKE256);
`notes/run/KEYGEN_SAMPLER_129_REPORT.md:9-38` (ten sam SHAKE heap, 8 wykonań
process_block: 4×f + 4×g; po 24 rundy SHAKE source-proved);
`notes/run/KEYGEN_SELECTED_SEED_119_COMPUTATION.json` (capacity 512, rate 136,
kernel_fuel 128); status: **POTWIERDZONE**

## Pytanie 2 — odpowiedź: wyjście = pk 2881 B + sk 7681–10369 B (kontrakt emitu); kroki regionów 2–3 policzalne z przypiętych fragmentów C, region 4 OPEN

**Bajty wyjścia (kontrakt kernelowy):** `publicLength : (publicBytes r).length = 2881`
i `secretLength : 7681 ≤ (secretBytes r).length ≤ 10369`
(`formal/Source3/KeygenSourceToFiber001.lean:34-35`). Typ: `Secret = (length :
Fin 10370) × List.Vector (BitVec 8) length.val` ⇒ sk ≤ 10369 B (bufor 10370),
`Packet = Secret × List.Vector (BitVec 8) 2881`
(`KeygenWholeBytes088.lean:27-28,39`). Seed wejściowy: 32 B
(`KeygenSeedEntry089.lean:18`). Uwaga: „sk ≤ 10370 B" z R5 to rząd Fin 10370;
dokładne wiążące widełki to 7681–10369 B.

**Kroki regionów 2–4 (struktura przypięta, fragmenty C 1001 61 / 1537 10):**
- Region 2 (tail, `mq_NTT`/root w tablicach gm/igm 2048 słów): first pass
  **768 motyli** (X²−X+1 na `a[u]`, `a[u+768]`, po 1×montymul),
  **8 rund pośrednich** (t: 768→384→192→96→48→24→12→6, guard `t>3`),
  **tripling 512 trójek** (u: 0→1536, v: 512→1024, twiddles cubic).
- Region 3 (suffix 1537 10): testy `t[u]==0` na pozycjach tablicy,
  zapisy `mq_div_18433` na niezerowych, jedno wywołanie `mq_iNTT`, `return 1`.
- Region 4 (root + certificate + codec): `solve_NTRU` (`Extra/c/falcon-keygen.c:7279`)
  → `solve_NTRU_deepest:5742` → `solve_NTRU_intermediate:5802` →
  `solve_NTRU_binary_depth1:6399` / `_binary_depth0:6786` / `_ternary_depth0:7052`;
  **liczba kroków = OPEN** — region nie jest jeszcze zdekomponowany na policzalne
  pętle w R1.

**Bloki XOF:** dla fixture seed9 sampler f/g = 8 process_block × 24 rundy SHAKE
(source-proved, `KEYGEN_SAMPLER_129_REPORT.md:36-38`); pełny bilans bloków XOF
na cały KeyGen (pętla prób, odrzucenia) = **OPEN** (zależy od liczby prób).

źródło: `formal/Source3/KeygenSourceToFiber001.lean:34-35`;
`KeygenWholeBytes088.lean:27-28,39`; `notes/run/KEYGEN_R1_TAIL_TODO.md`
(tabele regionów 2–4, fragmenty 1001 61 / 1537 10);
`notes/run/KEYGEN_PUBLIC_FORWARD_159_REPORT.md:44-55,154-163`; status:
**POTWIERDZONE** (rozmiary bajtowe, regiony 2–3, XOF seed9) / **OPEN**
(kroki regionu 4, pełny bilans XOF)

## Pytanie 3 — odpowiedź: wolno — jako model pochodny toru T-THRESHOLD; R1 nie certyfikuje żadnego modelu kosztu MPC

R1 nie prowadzi semantyki udziałów ani modelu kosztu — to poza jego zakresem.
Dostarcza natomiast dokładne, przypięte i kernelowo wykonywane operacje
źródłowe (montymul/montysqr/add/sub, pętle ze stałymi licznikami iteracji —
patrz pytanie 2), więc **liczenie mnożeń na udziałach w ciałach regionów 2–4
jest dozwolone jako model kosztu**, o ile jest oznaczony jako szacunek pochodny
(nie twierdzenie R1) i mapuje regiony wg `KEYGEN_R1_TAIL_TODO.md`
(`spike/M4_REGION_MAP.md` deklaruje taką numerację). Rozstrzygnięcie granic
regionów pozostaje przy R1; koszt XOF (region PRNG) jest poza tym modelem
i dominuje rząd wielkości (pytanie 1). UWAGA: mapa regionów 2–4 do nazw
spiku (`mq_NTT`, root solver) jest zgodna z tabelą R1, ale R1 nie zatwierdziła
jeszcze żadnej implementacji obwodu.

źródło: `notes/run/KEYGEN_R1_TAIL_TODO.md` (regiony, operacje w pętlach);
`notes/run/KEYGEN_STEP_COPY_190_PLAN.md:16`, `KEYGEN_STEP_GS_194_REPORT.md`
(wartości jako executed words, bez własności semantycznych);
`spike/M4_REGION_MAP.md:3`; status: **POTWIERDZONE** (w zakresie: wolno jako
model pochodny; brak modelu kosztu po stronie R1)

## Pytanie 4 — odpowiedź: BRAK DANYCH — kanoniczny artefakt `packet` jeszcze nie istnieje

Emit i codec są w regionach 3–4 (OPEN), więc nie ma jeszcze bajtów `packet`
do przypięcia. Istnieje wyłącznie typ `Packet` i unikalność bajtów w fixed
final heap (`packetOf`/`Observed`/`observed_unique`/`packetOf_eq`).
Dane natywne z `.build/jobs/keygen_witness113_005/candidate_009/`
(`public.bin`, `private.bin`, `RESULT.json`: return=1, sk 7681 B, pk 2881 B)
są **NIEZAUFANYMI danymi kandydackimi** — nie są artefaktem kanonicznym,
nie są przesłanką dowodu i nie mogą służyć jako pin wejściowy obwodu.
Kanoniczny artefakt powstanie w oknie domykającym regiony 3–4 dla seed9
i zostanie przypięty w formacie R1 (SHA-256 + ENTRY_PINS/postseal — pytanie 9,
zestaw R5 (e)).

źródło: `formal/Source3/KeygenWholeBytes088.lean:75-87,41-57`
(packetOf/Observed/observed_unique); `notes/run/KEYGEN_R1_TAIL_TODO.md`
(regiony 3–5 OPEN); `KEYGEN_PUBLIC_FORWARD_159_REPORT.md:161-163`;
status: **BRAK DANYCH** (cel: po zamknięciu regionu 4/5)

## Pytanie 5 — odpowiedź: OPEN w R1 — `evaluate = some (.inr packet)` nie jest owner-accepted; to cel regionu 5

`G(seed*)` **nie jest dowiedzione**; nie ma żadnego owner acceptance. Całe
zadanie R1 ma status ACTIVE / NOT_COMPLETE, pakiety PARTIAL_PROOF /
NOT_REVIEWED. `evaluate = some (.inr packet)` jest jawnie celem regionu 5
i wymaga domknięcia regionów 2+3+4 (tail, suffix+emit, solver+certyfikat+codec).

źródło: `notes/run/KEYGEN_PUBLIC_FORWARD_159_REPORT.md:83-85` ("G(seed*) is NOT
proved in this window"), `:150`, `:163` (step 5 OPEN);
`notes/run/KEYGEN_R1_TAIL_TODO.md` (tabela regionów: 5 = OPEN, wymaga 2+3+4);
`notes/run/KEYGEN_SEED9_R1_REPORT.md:3-8`; status: **OPEN**

## Pytanie 6 — odpowiedź: tak — env/input można (i należy) zamrozić jako pin interfejsu; fixture seed9 jest jawny i przypięty

Elementy zamrożenia:
1. **Stały input:** `KeygenFullDomain127.input` dla `KeygenFullData127.rawEnv`
   (kompletne statics/globalne, PRIMES/REV10/size tables/RC); ENTRY_PINS 127 =
   `0f914c6ece44edaebf677ad4786f5a1e1d82bf4348d4610c24556ccb80dbe9aa`.
   `env` wiąże się kanonicznie przez `KeygenCanonicalAddresses108.canonical`.
2. **Fixture seed9 (jawny, 32 B):** hex
   `6d65617331000000000000000000000000000000000000000000000000000009`
   (ASCII „meas1" + 26×`00` + counter 9), plik
   `.build/jobs/keygen_witness113_005/candidate_009/seed.bin`,
   **SHA256 `4941edb1f4d7bcfdaa82833d1cda200ae85782dcaa7030fae439819298f3a450`**
   (identyczny `observed_repeat/seed.bin`; wartość `seed_hex` w
   `WITNESS113.json`, SHA256 pliku JSON
   `dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf`).
3. **Fixture Lean:** `GeneratedSeed119Fixture.lean` (SHA256
   `e66a1a490d3ed9bc0f59ad4a28268072c7628841a30f2971d2f2c9c43bd36392`),
   `formal/Source3/SelectedSeedBytes119.lean` (SHA256
   `f5e3f9d8427dea25769be34fca2b14cf8fe8dcfebaa19d9a82babfbc41e3fd18`);
   piny wejść w `notes/run/KEYGEN_SELECTED_SEED_119_COMPUTATION.json`
   (sha `keygen_selected_seed119.sage` = 71fcb93e…, WITNESS113 = dda0d8b5…).

Zastrzeżenie: kompletny kanoniczny caller KeyGen z dołączonymi
set_seed/readiness to osobne otwarte zobowiązanie (residual_risks w
KEYGEN_SELECTED_SEED_119_COMPUTATION.json); częściowo domknięte przez
`SelectedFullStart127.seeding` (faktyczny publiczny seed + pełny make prefix
na nowym inputie). Przypięcie = ENTRY_PINS.json + postseal JSON + SHA-256
fixture'ów (jak wyżej), **nie** wektory FNV spike'a (zestaw R5 (e)).

źródło: `notes/run/KEYGEN_ENVIRONMENT_127_REPORT.md:13-45`;
`notes/run/KEYGEN_SELECTED_SEED_119_REPORT.md`, `..._COMPUTATION.json`;
`formal/Source3/KeygenSeedEntry089.lean:18` (Seed = Fin 32 → BitVec 8),
`KeygenSeedPrefix092.lean:17-24` (Input: base/seedBlock/domain/fresh);
status: **POTWIERDZONE** (fixture + forma pina) / **OPEN**
(dokompletowanie canonical caller w pinie interfejsu)

## Pytanie 7 — odpowiedź: tak — `Failure` jest domknięte i fail-closed: brak klucza przy każdej porażce, alfabet porażek = {attemptLimit, encoding} w `evaluate`

`Failure` to domknięty typ induktywny: `readiness | attemptLimit | encoding`
(Fintype); `Outcome = Failure ⊕ Packet`. `observe` zwraca `.inl cause` ⇔
`trace.failure = some cause` — porażki zachowują fazę źródłową, żaden return-0
nie jest normalizowany do sukcesu. `keyOnly (.inl _) = none`, a
`keyOnly_none_iff` wiąże brak klucza z `flow = returned (some (.int32 0))` —
czyli **fail-closed: przy porażce nie ma materiału kluczowego**. Dodatkowo
`KeygenByteGame134.no_readiness_failure`: `evaluate ≠ some (.inl .readiness)`,
więc obserwowalny alfabet porażek w `evaluate` to `attemptLimit | encoding`
(oraz `evaluate = none`, gdy dla seeda nie istnieje żadne `Execution`).
Dla obwodu MPC: **abort na każdym wyniku innym niż `.inr packet`**
(`none`, `.inl _`), zgodnie ze `SpikeError` spike'a.

źródło: `formal/Source3/KeygenWholeCall088.lean:17-22` (Failure),
`:30-56` (Trace: readiness/capped/tailRejected);
`KeygenWholeBytes088.lean:88-131` (Outcome/observe/keyOnly/observe_left_iff/
keyOnly_none_iff; komentarz :90);
`KeygenByteGame134.lean:69-77` (no_readiness_failure); status: **POTWIERDZONE**

## Pytanie 8 — odpowiedź: wiążący dla progu jest atom `2⁻²⁵⁶` (to R1 dostarczy na seed9); `certified_set_lower` jest silniejszy, ale wymaga kernelowych świadków dla każdego seeda

Obie formy istnieją jako twierdzenia: `atom = 1/2^256`
(`KeygenSuccessMass112.lean:17`) i `success_lower_of_witness`: z jednego
świadcza `evaluate … = some (.inr packet)` wynika `atom ≤ Z`
(`KeygenSuccessMass134.lean:27-38`; plan regionu 5: „Z ≥ 2⁻²⁵⁶").
`certified_set_lower` (`KeygenSuccessMass134.lean:65-78`) daje
`|seeds|/2^256 ≤ Z`, ale przesłanką jest **osobisty kernelowy świadek dla
każdego seeda ze zbioru** — „A CSV success count is not this premise"
(`KeygenModelUnlock134.lean:158-160`). Przy obecnym świadczie R1 (jeden seed9)
wiążącą formą dla progu T-THRESHOLD jest więc **atom 2⁻²⁵⁶**; `certified_set_lower`
należy przyjąć dopiero, gdy R1 dostarczy certyfikowany zbiór ≥ 2 seedów
(wtedy dół rośnie liniowo ze zbiorem). Żadna z form nie jest numerycznym
`p_accept` (to nadal OPEN); droga analityczna ε>0 jest zatrzymana
(Z_LOWER_134: STOP_AND_REPORT). Z = `KeygenProbability134.successMass env input`.

źródło: `KeygenSuccessMass112.lean:17,27-33`; `KeygenSuccessMass134.lean:27-38,65-78`;
`KeygenModelUnlock134.lean:145-170` (package_of_witness / package_of_certified_set);
`notes/run/KEYGEN_Z_LOWER_134_REPORT.md:137-151`; status: **POTWIERDZONE**
(wiążące: atom 2⁻²⁵⁶ dla świadka seed9; wybór formy przez tor T-THRESHOLD)

## Pytanie 9 — odpowiedź: przy rozjeździe pinów/hash obowiązuje STOP_AND_REPORT; ownership decyzji ma WŁAŚCICIEL, oba tory raportują

Protokół R1: przed każdym wznowieniem — weryfikacja ENTRY_PINS (liczba pinów +
SHA-256 receiptu + brak aktywnego joba/Lean/Sage), retained failures z przyczynami
w aktach, a przy **każdym** rozjeździe hash/pin/fixture — STOP_AND_REPORT
(bez cichych napraw; precedens: Z_LOWER_134 STOP_AND_REPORT; „Zasady niezmienne"
w `KEYGEN_R1_TAIL_TODO.md`). Decyzja przy rozjeździe (co uznać za kanoniczne,
czy korygować piny) należy do **WŁAŚCICIELA** (AGENTS repo: zakaz cichych napraw,
nawet przez narzędzia kanoniczne tylko po decyzji właściciela). R1 nie arbitruje
rozjazdów z torem T-THRESHOLD; tor T-THRESHOLD raportuje rozjazd i czeka.
Samowolna zmiana fixture/pinów przez którykolwiek tor jest niedopuszczalna.

źródło: `notes/run/KEYGEN_R1_TAIL_TODO.md:953-1010` (zasady + rejestr STOP_AND_REPORT),
`notes/run/KEYGEN_PUBLIC_FORWARD_159_REPORT.md:133-146` (resume protocol: verify
ENTRY_PINS + postseal, confirm no live owned job), `notes/run/KEYGEN_STEP_GS_194_REPORT.md:9-24`
(entry verification); AGENTS repo (stop-and-report, decyzja właściciela);
status: **POTWIERDZONE**

---

## Minimalny zestaw R5 §2 — status dostarczenia

### (a) Sygnatury `evaluate` / `Outcome` / `Packet` (Lean) — POTWIERDZONE

- `KeygenByteGame134.evaluate (env : Env) (input : Input env) (seed : Seed) :
  Option Outcome` — `formal/Source3/KeygenByteGame134.lean:31`
  (noncomputable: `some (Classical.choice (Execution env input seed)).outcome`,
  albo `none` gdy `Execution` nie istnieje; `some_iff` :36).
- `Outcome := Failure ⊕ Packet` — `KeygenWholeBytes088.lean:88`;
  `Failure` = `readiness | attemptLimit | encoding` — `KeygenWholeCall088.lean:17-19`.
- `Packet := Secret × List.Vector (BitVec 8) 2881`,
  `Secret := (length : Fin 10370) × List.Vector (BitVec 8) length.val` —
  `KeygenWholeBytes088.lean:27-28`; projekcje `secretBytes`/`publicBytes` :36-37,
  `pack` :39, `Observed` :42, `packetOf` :75, `observe` :91, `keyOnly` :96.
- `Seed := Fin 32 → BitVec 8` — `KeygenSeedEntry089.lean:18`;
  `Input` = `KeygenSeedPrefix092.Input` na kanonicznym env
  (`KeygenWholeStages109.lean:14`).
- Świadek sukcesu ⇒ kontrakt bajtów: `KeygenByteGame134.successful_source`
  (`KeygenByteGame134.lean:59-73`) daje `KeygenSourceToFiber001.Contract result`
  z `secretBytes packet = secretBytes result`, `publicBytes packet = publicBytes result`.

### (b) Postać `packet` po emit — POTWIERDZONE (rozmiary) / OPEN (wewnętrzny rozkład bajtów sk)

- `publicBytes` = **2881 B dokładnie** (`publicLength`, `KeygenSourceToFiber001.lean:35`).
- `secretBytes`: **7681 ≤ |sk| ≤ 10369 B** (`secretLength`, tamże :34);
  typ `Secret` dopuszcza do 10369 B (Fin 10370). Seed: 32 B.
- Kontrakt dekodowania: `DecodeSecret (secretBytes r)` / `DecodePublic (publicBytes r)`
  = `some r.secret.h` (`KeygenSourceToFiber001.lean:31-33`).
- Wewnętrzny rozkład bajtów sk (header / f / g / F / G) wg codec C
  (`Extra/c/falcon-enc.c`) — **OPEN w R1**: ogony codec są w regionie 4,
  dotąd niecertyfikowane kernelowo. Bajty kandydackie (NIEZAUFANE, dane natywne):
  `candidate_009/public.bin` 2881 B, `private.bin` 7681 B
  (`WITNESS113.json`: return=1, counter=9).

### (c) Relacja `Accepted env input seed` + seed9 (fixture jawny) — fixture POTWIERDZONY / relacja OPEN

- `Accepted env input seed := Nonempty (First env input seed)`;
  `FirstEmitted` ⇒ `Accepted` (`first_emitted_accepted`) —
  `formal/Source3/KeygenFirstAttempt134.lean:30-58`.
- **Fixture seed9 istnieje** (pin w pytaniu 6): 32 B
  `6d65617331…0009`, SHA256 `4941edb1f4d7bcfdaa82833d1cda200ae85782dcaa7030fae439819298f3a450`;
  wygenerowany `GeneratedSeed119Fixture.lean` / `SelectedSeedBytes119.lean`;
  `SelectedFullStart127.seeding` wiąże go przez faktyczny publiczny seed +
  pełny make prefix (`KEYGEN_ENVIRONMENT_127_REPORT.md:34-40`).
- **Relacja `Accepted env input seed9` = OPEN** — brak kernelowego dowodu
  akceptacji dla seed9 (natywny return=1 to dane kandydackie). Dowód jest celem
  regionów 4–5 (patrz (d)).

### (d) Dowód `package_of_witness` na seed9 — OPEN (zależne od domknięcia świada)

„OPEN — zależne od domknięcia świada; oś czasu wg `KEYGEN_R1_TAIL_TODO.md`":
`package_of_witness` (`KeygenModelUnlock134.lean:151-156`) wymaga
`evaluate env input seed9 = some (.inr packet)` (region 5). Stan na 2026-10-20:
region 1d zamknięty; region 2 w toku — checkpoint 194 discharge CLOSED
(bezwarunkowe s0–s7 dla pierwszej liczby pierwszej); otwarte: ogon pętli
zewnętrznej (u++/guard), 2× `zint_rebuild_CRT`, część additional-prime
(slen 1 / tlen 2), kolejne d-levels, root/certificate/codec (regiony 3–4).
Historyczne tempo projektu: ~1 region na okno robocze
(`KEYGEN_PUBLIC_FORWARD_159_REPORT.md:176-178`) ⇒ regiony 2–5 to **co najmniej
kilkanaście okien roboczych**; dokładniejsza data nie jest w aktach R1.

### (e) Zgodność pinów/hash (SHA-256) — format R1 + uzgodnienie z VECTOR_PINS — POTWIERDZONE

- **Format pinów R1:** `ENTRY_PINS.json` (liczba pinów + SHA-256 receiptu) +
  postseal JSON na okno + SHA-256 modułów/receiptów/auditów; weryfikacja
  read-only przed każdym wznowieniem (0 missing / 0 changed).
- **Bieżące piny (checkpoint 193–194):** ENTRY_PINS
  `99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`
  (73564 ścieżek, 0/0), POSTSEAL_193
  `386e4cbcf8ecee725cec39de9e32e0012d8c0efbdb96b8f0f99fe9a03e964562`,
  receipt 193 `1d6f11ec19d5b0cb0f1f4ba4be63bd9d74f4800bcef66d55d611a00931b16d3e`.
  Starsze (159): ENTRY_PINS `528dbf18337a1e33322eac63ff99a9ba5008fc03449c1751483dcec7b9130290`
  (55659 pinów), POSTSEAL_159 `ccd05f39988fc963d38139928cacd17a307659dc2db74bbae97d51b0f2ea6299`,
  POSTSEAL_159B `1558cd5b1ffc98f8d8d3c78e96667e9a66a648cd3b813b122befefd87efe367c`.
- **Uzgodnienie z `spike/VECTOR_PINS.md`:** to mapa wektorów syntetycznych na
  **FNV-64** (H_fold/G_frag/mul/PRSS/S4 — własne modele spike'a), jawne ziarna
  syntetyczne; „ten plik jest mapą wektorów, nie skarbcem liczb". **Nie jest
  to SHA-256 ani pin source-bound.** Zasada harmonizacji: piny spike'a zostają
  lokalnymi pinami testów syntetycznych; każdy artefakt wchodzący do kontraktu
  interfejsu T-THRESHOLD ↔ R1 (env/input fixture, seed9, `packet`) musi mieć
  pin w formacie R1 (SHA-256 + ENTRY_PINS/postseal, jak w pytaniu 6).
  Nie przyrównywać wartości FNV do SHA-256; rozjazd = STOP_AND_REPORT (pytanie 9).

---

## Trzy zdania podsumowania

R1 dostarcza teraz: dokładne sygnatury `evaluate`/`Outcome`/`Packet`/`Failure`
z cytatami, wiążące rozmiary emitu (pk 2881 B, sk 7681–10369 B), policzalną
strukturę regionów 2–3 (768 + 8 rund + 512 trójek; suffix 1537 10), domkniętą
formę fail-closed porażek, jawny i przypięty fixture seed9 (32 B, SHA256
4941edb1…) oraz pełny format pinów R1 gotowy do uzgodnienia z VECTOR_PINS.
OPEN i kiedy: `packet` (regiony 3–4), `Accepted env input seed9` i
`package_of_witness`/`G(seed*)` (region 5) — po domknięciu ogona taila, CRT,
additional-prime, d-levels, root/certificate/codec; przy tempie ~1 region/okno
to co najmniej kilkanaście okien roboczych (oś: `KEYGEN_R1_TAIL_TODO.md`).
Niniejsze odpowiedzi nie rozstrzygają: modelu kosztu MPC (pytanie 3 — to tor
T-THRESHOLD), numerycznego `p_accept`/p_K, bezpieczeństwa SHAKE/EUF-CMA ani
tego, którą formę dołu (atom vs certified_set_lower) ostatecznie konsumuje
obwód.
