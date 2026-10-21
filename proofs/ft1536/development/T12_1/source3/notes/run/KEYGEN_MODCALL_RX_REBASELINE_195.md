# RE-BASELINE łańcucha pinów — stratum ModCall `modp_Rx` (id 195)

2026-10-21, okno R1 decision-A (proof job suffixy 559-562). Forma
suplementu BATCH_061/063/073: **obie wersje łańcucha zachowane, nic nie
nadpisane**, stare akta nietknięte. Składnia dokumentu wg
`run2/notes/PINY_I_OLEAN_STRUKTURA.md` §3 (właściciel, 2026-10-21).

## Powołanie na decyzję właściciela

**OWNER DECISION A (2026-10-21)** — scope z WORK_STATE (decyzja-A window):
extend the pinned `C99ModularReference.lean` ModCall stratum with the
`modp_Rx` constructor exactly per the call `modp_Rx(slen, p, p0i, R2)` in
the body (the B1.03 r2/div precedent) + re-baseline the pin chain as a
SUPPLEMENT (both chain versions, never overwrite, BATCH_061/063/073
form). Przebudowa domknięcia jako akceptacja 4 draftów (precedens B1.03,
~810 modułów cache). Przyczyna rozszerzenia: `modp_Rx` nie ma
konstruktora w zamkniętym stratum `Exec = GenExec ModCall`
(montymul/add/sub/ninv31/set/R/R2/div); sekcja additional-prime była
zablokowana w zdaniu 7 pętli.

## Co się zmieniło (4 drafty, przebudowane i przyjęte)

1. `formal/Source3/C99ModularReference.lean` (ZMODYFIKOWANY) —
   konstruktor `| rx (args out) (body : rxBody args out) : ModCall
   "modp_Rx".toList args out` po `| div`, helpery rx-prefixed
   (rxParams/rxCell/rxShiftI/rxLoopGuard/rxBranchGuard/rxZMont/rxRMont/
   rxZAssign/rxRAssign/rxIfBody/rxIfStep/rxLoopBody/rxLoopStep/rxLoop/
   rxCode), `rxBody` (GenExec LeafCall rxCode), komentarz nagłówka.
2. `formal/Source3/KeygenProperModular096.lean` (ZMODYFIKOWANY) —
   wiersz Arity dla modp_Rx count = 4, nowe `four`, przypadek `rx.rx` w
   `calls` przez `KeygenModularRx096.source_unique`, projekcje arity,
   dodany import.
3. `formal/Source3/KeygenModularRx096.lean` (NOWY) — unikalność słowa
   czteroargumentowego rxBody (names ["x","p","p0i","R2"], checked,
   parameters_agree, source_unique) w wzorcu KeygenModularDiv096.
4. `formal/Source3/KeygenRxCallees.lean` (NOWY) — wiązanie parse
   (`rx_source_bound`: region 2609 18 = some rxCode, by decide) +
   `rx_transcription` (stratum rxCode = KeygenModpRx.rxCode, by decide).

Pochodzenie `rxBody` (odczyt jednokrotny, zapisany w WORK_STATE):
`rxBody/rxCode/rxParams = C99ModularReference.*` przez `open
C99ModularReference` w KeygenModularRx096; tor importów
`KeygenModularLeaf096 → KeygenModpR2Exec → KeygenMkgm3Callees → … →
C99ModularReference`.

## Pary pinów STARY → NOWY (obie wersje; nigdy nie nadpisane)

| moduł / produkt | STARY pin (SHA256) | NOWY pin (SHA256) |
|---|---|---|
| `formal/Source3/C99ModularReference.lean` | `ab9d082856281144e341fda050c243896cf82232658827c770ee562a07571b65` | `b2abbf443891f97d1608c08d8c0a045c2bf429ae4546832d4eb0fbc603712041` |
| C99ModularReference.olean | `479bc1b497d279e077ab9c1500c4e684efc09b8eee0622dee0660e3f5999bd1e` (`.build/cache/Source3/`) | `8b99a85057fc8c49169b49d48a4fa611cea2f6fabdbc54e76e56f6b5e19a4691` (job 559 `lib/`) |
| `formal/Source3/KeygenProperModular096.lean` | `ed270027c1daed035584e6d62adcda067fd1ba0b97c52058333797932f6754fc` | `92aa68594f06edbd8de52e63f560be547915fb07eb00c3bc08fd00d354d485d2` |
| KeygenProperModular096.olean | `e4dca69b0ba9556a66028d876f1e4c9b5d7dbdb33aec30eb3a9475dd0ca8c307` (job `keygen_solver096_016` `lib/`) | `0324b18bb42e6a1b544d0a4c92e5440e8aecd0d847898daf141fc47b51a0a0a0` (job 561 `lib/`) |
| `formal/Source3/KeygenModularRx096.lean` (NOWY) | — (brak; nowy plik) | `40fccaeb6ab6172cf5a59dea9db684cf68de32010147774dbfe1ea2ee607aa71` |
| KeygenModularRx096.olean (NOWY) | — (brak) | `7a34b238c14ceeb155ea4801943169d1d34f41e41527c87e80bde5cd4cead08a` (job 561 `lib/`) |
| `formal/Source3/KeygenRxCallees.lean` (NOWY) | — (brak; nowy plik) | `1191a7234e203fcf9251c6ca91548fa17bae1a462d6ae02eac5ec78553218362` |
| KeygenRxCallees.olean (NOWY) | — (brak) | `65288500b7ab1db4c570257d369514dab76191804f13d01ab960af5a24384f6e` (job 561 `lib/`) |
| `KeygenModularLeaf096.lean` / .olean | `24a8ce07c2749e7877a4372f4e9da05e3141776f421f2295ed5af1c65b8d028a` / `c9de9db98167a0cc30cd3ecb7734b5a7c02079ade96c493f53af80453c6f6a67` | IDENTYCZNE (źródło bez zmian; przebudowa bajt-identyczna) |
| `KeygenModpRx.lean` / .olean | `103a04ddb63fa1e593c5fb6d1a35232ad9dcec4cf1d41f87a380a407154ba0a8` / `5d3410103ec21314e465660efe4d9ce41300e2e00b29001486d94128726385aa` | IDENTYCZNE (źródło bez zmian; przebudowa bajt-identyczna) |

Łańcuch wejścia starego poziomu (nietknięty): `.build/stepgs194/
ENTRY_PINS.json` SHA256 `99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`
(73564 ścieżki; po edycjach 0 braków / **2 zmiany = dokładnie dwa pliki
powyżej** — delta w pełni opisana w tym dokumencie, PASS_SCOPED).

## Zakres przebudowy 096-lane (rozstrzygnięcie pytania zawieszonego w WORK_STATE)

- **Selekcja: 816 modułów** = 810 cache-descendant closure
  `Source3.C99ModularReference` (`.build/steprx195/CLOSURE_SET.json`) +
  root + 2 nowe (KeygenModularRx096, KeygenRxCallees) + 2 doklejone
  (`KeygenModularLeaf096`, `KeygenModpRx` — wskazane warunkiem
  `stale dependency` runnera, ten sam warunek co assert) +
  `Source3.KeygenProperModular096` na końcu. Kolejność
  `.build/steprx195/SELECTION_ORDER.txt`.
- **Przebieg (retained):** job 559 — przerwany zewnętrznie (kill) przy
  module 281 (`KeygenPublicForwardProgram`, puste logi, brak receipt);
  280 modułów z realnymi receiptami = CONSUMED (precedens joba 512);
  job 560 — 495 modułów przyjętych, FAILURE na `KeygenModularLeaf096`
  (wymagany tranzytywnie `KeygenWholeBytes088` stał dalej w kolejności);
  job 561 — 41/41 przyjętych, komplet 816 zamknięty.
- **TRAP (księga pułapek): kolejność domknięcia.** Cache'owe mapy
  `imports` zapisują wyłącznie zależności obecne w `bindings` w chwili
  budowy, więc kolejność topologiczna po nich jest NIEKOMPLETNA.
  Kolejność ustalać **prawdziwym grafem importów ze źródeł, tranzytywnie
  przez moduły cache'owane** (np. Leaf096 → PublicDomain095 → … →
  KeygenWholeBytes088). Kolejność joba 561:
  `.build/steprx195/SELECTION_ORDER_561.txt` (0 naruszeń).
- **Czego przebudowa NIE objęła (świadomie, poza zakresem decyzji A):**
  pozostałe moduły toru 096 determinizmu (`C99ModularLocalAgreement096`,
  `KeygenModularDiv096`, `C99ModularArity096`, `KeygenWordArity096`,
  `C99DeclarationAgreement096`) — nie są descendantami
  `C99ModularReference`, ich rejestrowane zależności się nie zmieniły,
  żaden assert `stale dependency` ich nie wskazał; ich produkty w
  `.build/jobs/keygen_solver096_*` zostają z pinami sprzed
  re-baseline'u. Zero zamrożonych seedów zależy od zmienionych modułów.
- **Determinizm buildu:** przebudowane bez zmian moduły dały oleany
  bajt-identyczne ze starymi pinami (Leaf096 `c9de9db9…`, ModpRx
  `5d341010…`) — fakt pomocniczy, nie twierdzenie.

## Odbiór draftów (kryteria akceptacji)

- **Logi 0/0:** job 561 — 41/41 receiptów `accepted=true`,
  `clean_log=true`, `exit_code=0`, `forbidden_proof_markers=[]`;
  job 562 — 1/1. Wcześniej 775 modułów (559/560) również 0/0.
- **3 aksjomaty:** job 562 DIAGNOSTIC (`Source3.KeygenRxAudit195`,
  source `f26c36bb33fc7cc3a4df1f65750498a7eed2f57d1a4f4d3b58088346bd995a26`,
  olean w job 562) — `#print axioms` wszystkich 11 eksportów czterech
  draftów: wyłącznie `[propext, Classical.choice, Quot.sound]`
  (`two`/`four`/`five` nawet tylko `[propext, Quot.sound]`). Rekord
  diagnostyczny, nie dowód.
- **Skan markerów:** `sorry|admit|native_decide` w czterech draftach i
  module audytu — 0 trafień; runner dodatkowo skanuje markery w każdym
  requeście (`forbidden_proof_markers=[]`).

## Skutki dla następnych okien

- Następne okna dziedziczą **NOWY** `ENTRY_PINS`:
  `.build/steprx195/ENTRY_PINS.json` (narzędzie
  `tools/keygen_steprx195_entry.py`); stary manifest 99ac47a1… zostaje
  nietknięty w `.build/stepgs194/`.
- **Meldunek (obowiązek §3):** „re-baseline wykonany, stary pin
  `ab9d0828…` → nowy `b2abbf44…` (C99ModularReference.lean), stary pin
  `ed270027…` → nowy `92aa6859…` (KeygenProperModular096.lean), oleany
  `479bc1b4…` → `8b99a850…` oraz `e4dca69b…` → `0324b18b…`".
- **NEXT_ROUTE (z decyzji A):** ta sama decyzja otwiera cztery późniejsze
  miejsca `modp_Rx`: `poly_sub_scaled_ntt` falcon-keygen.c:4626,
  `solve_NTRU_intermediate` :5906/:5985, `solve_NTRU_binary_depth1`
  :6474 — stratum nie wymaga już dalszych rozszerzeń, tylko egzekucji.
- Engine `ZintModSignedWord194` (per słowo marszu, dlen = 1) zostaje
  pierwszym krokiem wykonawczym następnego okna — nie rozpoczęty tutaj
  (budżet okna; czyste zamrożenie przed przeciąganiem).
