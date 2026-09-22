# REVIEW — niezależny odbiór T02.1 PRNG_LAYOUT_COUNTER (RUN_002)

REVIEW_ID=FT1536_PRNG_LAYOUT_COUNTER_INDEPENDENT_REVIEW_001.
Recenzent niezależny, wybrany i ręcznie uruchomiony przez właściciela.
Model recenzenta: **MiMo V2.6 Pro** (xiaomi-token-plan-ams/mimo-v2.6-pro,
thinking) — inny niż wykonawca pakietu; kontekst świeży.
Autor projektu: Niirmata. Falcon Project / Thomas Pornin attribution zachowana.

SOURCE_W (RO): `…/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_002`
REVIEW_W: `…/work/FT1536_PRNG_LAYOUT_COUNTER_REVIEW_001`
Subagenty: **nie użyto** (reguła właściciela: dopuszczalny tylko subagent o tym
samym modelu i tym samym efforcie; równoważności nie dało się potwierdzić → 0).

## Werdykt

**CHANGES_REQUIRED** — wyłącznie sprostowania zakresu/dokumentacji (F1–F4).
**Matematyka A/B+C, kernel Lean, wiązanie C, KAT/mutacje i mój fresh replay są
POTWIERDZONE; brak luki matematycznej.** Żadna z uwag nie zmienia liczb
396 / 25408 / 406528 / 896 / 936 ani kontraktów A/B/C. Wzorzec naprawy: nowy
checkpoint/suplement (bez edycji frozen bajtów SOURCE_W).

## 1. Integralność (§2/§4) — moja, przed i po replayu + finalna

- 7/7 pinów zgodne bajtowo w trzech momentach: REPORT `68a00fee…`, OUTPUTS
  `8eda4cb9…`, TASK `7b0007c0…`, bootstrap MANIFEST `03b0612c…`, CANDIDATE
  `56974571…`, POLICY `b6afcdca…` (3 kopie identyczne), RUN_001/OUTPUTS
  `34c49d61…`. Prompt + sidecar `00349948…` ✓.
- OUTPUTS 142/142; INPUTS 61/61 (kopia POLICY `inputs/documents/SAGEMATH_RULE.md`
  i TASK ✓); bootstrap 39/39 = 5 750 423 B, 37 ORIGINS wszystkie na BASE
  `c90233c1…` (hash+bajty zgodne), source17 17/17 (CANDIDATE = source/ w MANIFEST).
- Brak symlinków / traversal / duplikatów / mismatchów. INPUTS używa absolutnych
  ścieżek proweniencji (claims.py: „absolute provenance paths") — celowe,
  zawierają się w pakiecie.
- SEMANTIC_FILES.json (17) ↔ OUTPUTS: pełne pokrycie, identyczne hashe.
- **RUN_001 nietknięty**: pin + 153/153 członków zweryfikowane; nie recenzowany.
- Szczegóły: `INTEGRITY.json` (checkers/verify_integrity.py).

## 2. Mój świeży replay (§5) — nie receipt autora

- `python3 -B SOURCE_W/scripts/replay.py REVIEW_W/seed/tmp/independent_001
  8eda4cb9…` (skrypty autora jako RO-kopie w `scripts/author_ro/`, ich SHA
  przed/po zgodne — 16/16). Pełny manifest + zewnętrzny SHA przed tworzeniem
  DEST; bwrap `--unshare-net`, work/replay/stages/documents/objects/validation/
  catalog/history/Extra ukryte; świeży cache/build; bounded single-worker.
- **Wynik: FRESH_REPLAY_PASS 17/17, exit 0, 28.9 s**, mismatches=[],
  `only_destination_written=true`, `network_off=true`, `original_trees_hidden=true`.
  Receipt: `logs/receipt_INDEPENDENT_001_REPLAY_RESULT.json` (kopia z DEST).
- Niezależne porównanie bajtowe MOIM checkerem (`checkers/verify_replay.py`):
  17/17 plików semantycznych identycznych DEST↔SOURCE_W↔piny, oba
  SEMANTIC_FILES.json identyczne. → `checkers/REPLAY_CHECKS.json`.
- Failed attempts moje: `FAILED_ATTEMPTS.md` (7; w tym 3 błędy moich checkerów
  — poprawione, wyniki po poprawkach).

## 3. Kernel Lean (§6)

- `formal/CounterLayout.lean`: **28 twierdzeń** (policzone `^theorem `),
  core-only (brak `import`), brak sorry/admit/native_decide/Lean.ofReduceBool/
  aksjomatu celu/supresji (grep + odczyt). Mój przebieg na kopii: stdout
  **bajt-identyczny** z sealed, stderr 0 B.
- **Mój audyt `#print axioms` wszystkich 28 twierdzeń**
  (`formal/CounterLayoutAudit.lean`, `logs/lean_axiom_audit.stdout`):
  23 × `[propext, Quot.sound]`, 4 × `[propext]` (blockCounter_zero,
  typeOut_zero/one/other), 1 × brak aksjomatów (`refill_post` = `rfl`).
  Brak `Classical.choice`/`sorryAx` — zgodne z deklaracją (split równoważności
  wrapu na dwie implikacje; FAILED_ROUTES §8 to potwierdza).
- Treść sprawdzona: `blockCounter` = (cc0+k) mod 2^64 (frng.c:214-215),
  `counters_distinct` dla N ≤ 2^64 (wrap ≠ repeat) — prawdziwe i na temat;
  `WrapsInStage` ↔ `cc_last < cc_start` (obie implikacje); instancje F4/F5
  (post_F4=63, post_F5=0, nowrap_F5); `typeOut` (0→1, 1→1, reszta→0);
  offsets 32/48/56 i lanes 40..48; `rmax_value` 396, 25408, 6336, 406528,
  896, 936; `qrefill`. Wszystkie tezy z §3 promptu pokryte.
- **Granica kernela**: rundy ChaCha Word32 są ŚWIADOMIE poza kernelem i jest to
  jawne (SOURCE_MODEL_BINDING.md „Poza kernelem (celowo): 20 rund ChaCha…",
  REPORT „z granicą kernelową", certificate scope). Nie-kernelizacja nie jest
  przemilczana. Patrz uwaga F2 (słowo „frame" w scope kernela).

## 4. Pułapki Sage — 3 historyczne błędy RUN_001 (§6)

Przegląd kodu + mój mechaniczny `checkers/trap_scan.sage` (TRAP_CHECKS 9/9):
1. **`^` jako XOR**: nieobecne — całe XOR-y jako `^^` (model 18 linii, checker 8),
   pojedyncze `^` tylko jako potęga/kontrola preparsera (`2^10 == 1024`) i w prozie.
2. **Sage Integer w JSON**: nieobecne — int()/str()/bool() przy zapisach; mój test:
   6 artefaktów JSON parsuje się ściśle, same skalary pythonowe.
3. **Redukcja startu mod 2^64**: jawna wszędzie tam, gdzie licznik jest
   rederywowany (prng_model.sage:146,152,276; prng_checker.sage:68,138,141,211)
   — z komentarzem wprost o błędzie RUN_001 („The start itself must be reduced
   mod 2^64 first"). Moje przeliczenie daje te same flagi wrapu.

## 5. Wiązanie C (§6)

- 3 przebudowane harnessy u mnie (flags literalnie jak pinned Makefile +
  sanitizer/altbranch), **czyste stderr 0 B** przy wszystkich buildach; moje
  dump-y = sealed (`harness_dump{,_sanitized,_altbranch}.json`) — IDENTYCZNIE.
- Porównane całe buf4096 + state256 + ptr/type/counter, canaries (head/tail),
  poison state[56..255], stub_calls==1 / len==56, typy {0,1,2,3,−1,99,2^20}
  (return 0, zero extract, cały `prng` w poisonie — dispatch PRZED zapisem),
  determinizm (2 przebiegi równe), type0==type1. Checker: 405 checks, 105 pól
  (policzone). Layout: sizeof 4368, offsets 0/4096/4104/4360, align 8 ✓ (mój build).
- **1-bajtowa różnica normal-vs-altbranch wyjaśniona**: `cmp -l` → dokładnie 1 bajt
  (poz. 141, wartości 61/60 okt = `'1'`/`'0'`) = tag `falcon_le_u`; po wyrownaniu
  tagu całe drzewo JSON identyczne. Potwierdzona równość pól semantycznych;
  przenośność BE pozostaje analityczna (FAILED_ROUTES §4 — zawężenie słuszne).

## 6. KAT, fixtures, mutacje (§6)

- **Mój OpenSSL CLI** (niezależny od skryptów autora): 5/5 wektorów z
  `kat_vectors.json` odtworzonych z key/nonce/counter; oba literały zgodne:
  RFC 8439 §2.3.2 (counter=1) i classic all-zero — potwierdzam literały z tekstu
  standardu. Proweniencja: `/usr/bin/openssl enc -chacha20` (3.5.7) + literały.
- Fixtures: publiczne stałe (bytes(range(32)), KEY+IV, cc0 ∈ {0, 2^32−1, 2^64−1,
  2^64−64, 2^64−65}) — jawny stub SHAKE-extract, **nie losowość**, tag
  PUBLIC_SYNTHETIC_FIXTURE_BYTES ✓.
- Mutacje 8 = 6 MEANINGFUL (wszystkie KILLED) + 2 NO_OP_BY_CONSTRUCTION (NO_OP
  7/7 czyste). Klasy równoważności udokumentowane i poprawne: `counter32` ≡
  [F0_ALLZERO, F2_IV_ASYM_CTR0] (niski licznik < 2^32), `xor_to_add` ≡
  [F0_ALLZERO] (same zera w lanes). Inferencja „mutant ≠ reference ⇒ mutant ≠ C"
  poprawna (reference ≡ C na porównanych polach).

## 7. Consumer (§6) — mój własny `.sage`

`checkers/consumer_check.sage` przez `sage consumer_check.sage` (Sage 10.9,
standard preparser, exact ZZ) — 49 checks PASS:
- r_max = ⌊(33·49152−8)/4087⌋ = **396**; 64·(1+396) = **25408**; 16·396 = 6336;
  64·6352 = **406528**; 56·16 = **896**; +40 nonce = **936** (poza cutem);
  monotoniczność r = 0..396;
- formuła `r_j<=floor((33T_j-8)/4087)` zgodna z pinned T01
  `inputs/bootstrap/T01/RESOURCE_BOUND.json` ✓;
- **ghost budget T01: 11/11 liczb** zgodnych z pinned T01 (786432 / 25952256 /
  6336 / 16 / 6352 / 26017792 / 57024 / 15 / 61320 / 4088 / 896) + spójności
  algebraiczne; `Pr(H^c)<2^-1020` **zostaje w T01** (nie przeniesione);
- q-refill: refills = ⌊q/4096⌋, ptr = q mod 4096 (wyczerpująco 0..5000 + punkty
  graniczne w tym 25408) + tożsamość dzielenia w kernelu (`qrefill`);
- wrap: **F4 `['after_init']`** (wrap wewnątrz 1. refilla, post=63),
  **F6 `['after_refill1']`** (wrap w 2. refillu), **F5 `[]`** — kończy dokładnie
  na 2^64−1, post=0, brak wrapu w stage → **flaga `[]` poprawnie**;
  192 różne liczniki na kontekst mimo wrapu (wrap ≠ repeat).

## 8. Zakazy awansu (§6) — przestrzegane

56 B nie jest przedstawiane jako klucz 448-bit (przeciwnie: „brak rozkładu/IID/
448-bit key" w założeniach), small block count nie jest pseudorandomness,
determinizm nie jest atakiem („limitation of the future game, not a statistical
attack"). Brak tez o real→IID hop, security, całym Sign, T02 — flagi
`real_prng_to_iid_bridge_proved/SHAKE_security_proved/ChaCha_security_proved/
whole_real_Sign_proved/owner_accepted` = false wszędzie; `T02_parent_open=true`.
Kernelizacja brakująca (rundy) jawnie opisana — nie przemilczana (patrz F2).

## 9. Findings (severity, plik:linie, wpływ, naprawa)

- **F1 — severity: medium (nieprawdziwy zakres w sealed artefakcie).**
  `model/prng_checker.sage:300` (→ sealed `artifacts/checker_result.json`, pole
  `scope.open`): „…owner acceptance; **Lean not used (optional in TASK)**" —
  zdanie z RUN_001 jest w RUN_002 fałszywe (kernel Lean 28 thm istnieje i jest
  w OUTPUTS). Wpływ: konsument samego tego artefaktu dostaje fałszywy obraz
  formalizacji (zaniżenie, nie awans; matematyka nienaruszona). Naprawa:
  suplement/nowy checkpoint ze sprostowaniem tekstu scope (np. „kernel Lean 4.34:
  counter/layout/resource/q-refill; ChaCha rounds poza kernelem"); bez zmian
  matematyki i bez edycji frozen bajtów.
- **F2 — severity: low (rozmycie scope kernela).** `REPORT.md:23` („kernel
  (`typeOut`, offsets, frame)") i `SOURCE_MODEL_BINDING.md:23-24` („offsets
  layoutu56 i ramki") — w kernelu jest arytmetyka ramki (`frame_tail_nonempty`
  56<256, `refill_blocks_per_buffer`), natomiast niepisalność `state[56..255]`
  jest argumentem strukturalnym (SOURCE_MODEL_BINDING A.4) + kontrolą poison,
  **nie twierdzeniem kernelowym**. Wpływ: minimalny zawyż pokrycia kernela w tych
  dwóch zdaniach. Naprawa: doprecyzowanie słowa „frame" („frame-arithmetic w
  kernelu; niepisalność strukturalnie + poison").
- **F3 — severity: low (błąd dokumentacyjny).** `REPLAY.md:9` — „porównuje
  15 plików z SEMANTIC_FILES.json"; faktycznie 17 (15 z RUN_001 +
  `formal/CounterLayout.lean` + `logs/lean_counter_layout.stdout`). Dodatkowo
  `REPLAY.md:24` — komórka „(poniżej)" nie wskazuje receiptu post-freeze
  (`SOURCE_W/tmp/postfreeze-001/REPLAY_RESULT.json`, historia). Naprawa: 15→17
  + wskazanie receiptu.
- **F4 — severity: low (precyzja danych T01).** `model/prng_model.sage:441,447,452`
  (+ `prng_checker.sage:244-251`, `RESOURCE_INTERFACE.json` `received_T01`):
  nazwy `abandoned_bytes`/`final_unused_bytes` zrzucają sufiks `_max` z pinned T01
  (`abandoned_at_reinit_max`=61320, `final_unused_tail_max`=4088) i asserts
  traktują je jak wartości dokładne. Wpływ: żaden na 396/25408/406528/896/936
  (te liczby tego nie używają). Naprawa: przywrócić nazwy `_max` lub jawnie „≤".
- **F5 — severity: info (etykiety).** `LAYOUT.json:3` i `SEMANTIC_FILES.json:3`
  niosą `task_id=…RUN_001`, podczas gdy `RESULT.json:3`/`PRNG_LAYOUT_CERTIFICATE.json:4`
  niosą `…RUN_002` (kontynuacja, `continues_from` obecny). Rozbieżność etykiet
  identyfikatora między artefaktami; zero wpływu merytorycznego. Naprawa:
  ujednolicić etykiety w przyszłym checkpoincie.

Finding autora **frng.c:198** („The block counter is XORed into the first 8 bytes
of the IV" vs instrukcje: `state[14]/state[15]` = offsets 40..47 = **OSTATNIE**
8 B IV) — **potwierdzony przeze mnie** w źródle (frng.c:198, 222-223) i w mutacji
`counter_lanes_state12_13` (KILLED); zachowany bez zmiany C — zgodnie z TASK.

## 10. Granica i scope odbioru

Mixed kernel/Sage/C/source-argument dla **pinned source model** (GCC 14.2/C99/
x86_64 LP64 LE, FALCON_LE_U=1, source pin `56974571…`, BASE `c90233c1…`).
Poza kernelem (świadomie): 20 rund ChaCha Word32 + niepisalność ramki
(strukturalnie + poison) + uniwersalność pętli 64-blokowej (struktura źródła).
Poza odbiorem: real→IID hop, rozkłady/security (SHAKE/ChaCha), KeyGen/sekrety,
pełny Sign, BE-hardware, T02 jako całość — **OPEN**. FIXTURE-equality to kontrola
wiążąca, nie kwantyfikator uniwersalny (kwantyfikator = argument strukturalny
ze źródła). PASS tego odbioru nie jest owner acceptance ani zgodą na publikację.

## 11. Rekomendacja / następny krok (bez automatycznego startu)

1. Katalog A/B/C + kernel + replay + KAT/mutacje/consumer: **przyjąć w scope**
   opisanym wyżej (moje potwierdzenia: replay 17/17, kernel 28 thm, 405 checks,
   KAT 5/5, consumer 49 checks).
2. Przed formalnym zamknięciem T02.1 — minimalny suplement sprostowawczy F1–F4
   (nowy checkpoint, brak edycji frozen bajtów, brak zmian matematyki); F5 opcjonalnie.
3. Po suplemencie — krótki odbiór samego suplementu (ta sama zasada: inny,
  niezależny model). T02 pozostaje OPEN; dalsze kroki wg ROADMAP — bez
  automatycznego startu.

Własne obliczenia zakończone; joby zakończone; źródeł/frozen nie zmieniono;
brak Git/publikacji/relay/dudect; owner_accepted=false.
