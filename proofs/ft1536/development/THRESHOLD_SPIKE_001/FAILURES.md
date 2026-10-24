# Retained failures — T-THRESHOLD spike 001

## F-01: `cargo test` bez ścieżki trafił w workspace `[N]`

- **Co:** pierwsze uruchomienie `cargo test` po `cd .../spike` i tak zbudowało
  workspace `[N]` (shell cwd zresetowany) — błąd `liboqs` (brak natywnej
  biblioteki) i inne obce craty.
- **Przyczyna:** brak `--manifest-path` / pewnego cwd w narzędziu powłoki.
- **Skutek:** chwilowy hałas w logu; brak zmian w `[N]`.
- **Naprawa:** `cargo test --manifest-path .../spike/Cargo.toml` — 9/9 PASS.
- **Zachowane:** jako przestroga — nie uruchamiać buildów kiełka z cwd `[N]`.

## F-02: brak `RngCore` w zasięgu w testach

- **Co:** `error[E0599]: no method named next_u32` w `src/lib.rs` (mod tests)
  i `tests/spike.rs`.
- **Przyczyna:** `rand::RngCore` nie zaimportowany w modułach testowych.
- **Naprawa:** `use rand::RngCore;` — 9/9 PASS.

## F-03 (obserwacja, nie awaria): sfałszowany udział daje cichy zły wynik

- **Co:** test `spike_04_forged_share_silent_wrong` **przechodzi** (assert_ne):
  fałszywy udział strony 2 → `K[0] ≠ H_fold(seed)`, brak paniki, brak detekcji.
- **To nie jest błąd kiełka** — to zamierzona retained luka (brak VSS/MAC).
- **Znaczenie:** dokładnie pokazuje, po co Pedersen DKG / SPDZ-MAC w torze.
- **Status:** otwarte pytanie P0.4 w `RESEARCH.md`.

## F-04 (scope): H-28/H-31 nie naprawione upstream

- **Co:** skazy z rejestru 2026-07-18 potwierdzone w kodzie (patrz `INVENTORY.md` §D–E).
- **Zakres tego okna:** naprawa H-31 **tylko w kopii kiełka** (`Drop` zeroize,
  brak Clone/Copy na sekretach). Brak portu do san-mpc (poza zakresem).
- **Status:** lista napraw w `INVENTORY.md` §H.

---

## Spike 002

### F-05: subagent `general-1` (ultra) utknął

- **Co:** spawn subagenta do implementacji 2-z-3 + VSS; zero zapisów w W
  po >15 min (turnCount=3, lastTurnTime zastygły).
- **Naprawa:** cancel + implementacja bezpośrednia w tym wątku.
- **Zachowane:** jako przestroga przy używaniu ciężkich subagentów do kodu
  kryptograficznego w tym środowisku.

### F-06: kompilacja — `Share` bez `Debug` blokuje `assert_eq!` na `Result<Vec<Share>>`

- **Co:** `error[E0277] Share doesn't implement Debug` przy `assert_eq!(shamir_share(...), Err(...))`.
- **Przyczyna:** celowy brak `Debug` na sekretach (H-31); `assert_eq!` go wymaga.
- **Naprawa:** `.map(|_| ()).unwrap_err()` — porównujemy wyłącznie `SpikeError`.
- **Zachowane:** Debug na udziałach **nie** wraca (kontrakt H-31).

### F-07: `coeffs` przeniesione do `Polynomial` przed `commits`

- **Co:** `error[E0382] borrow of moved value: coeffs`.
- **Naprawa:** budowa `commits` przed `Polynomial { coeffs }`.
- **Drobne;** retained dla kompletności.

---

## Spike 004

### F-08: hipoteza o korelacji |x| vs T obalona (retained finding)

- **Co:** test `r4` oczekiwał corr(|x|, T) > 0.05 („ogon dłużej czeka").
  Pomiar: corr ≈ -0.03.
- **Przyczyna:** przy i.i.d. reject (akceptacja zależy tylko od x) liczba
  prób jest geometryczna z parametrem średniej wagi — **niezależna od |x|**.
- **Status:** hipoteza **obalona**; test zmieniony na `r4_..._independent_reject`
  (assert corr≈0) + `r6` pokazuje realny wyciek (T zależne od sekretu).
- **Znaczenie:** nie wolno zakładać „T zdradza wartość próbki" bez modelu;
  jawność T jest problemem transkrypcji i zależności od sekretu, nie prostej
  korelacji z x.

---

## Spike 005

### F-09: `general-2` (ultra) utknął — drugi przypadek F-05

- **Co:** spawn subagenta do spike 005; 0 zapisów w W, turnCount zastygły
  (jak `general-1`).
- **Naprawa:** cancel + implementacja w wątku; przegląd niezależny przez
  `explore` (ten typ działa).
- **Wniosek:** `general` ultra w tym środowisku bywa niezawodny dopiero przy
  bardzo małych zadaniach; duży prompt implementacyjny = ryzyko stania.
  Krytyczny kod — pisać w wątku, używać `explore` do audytu.

### F-10: doctest `select_first_accepted_shares` — Unicode `·` w bloku kodu

- **Co:** doctest FAIL (`unknown start of token ·`) — wzór matematyczny
  wewnątrz ``` zinterpretowany jako Rust.
- **Naprawa:** wzór jako tekst w doc-komentarzu bez bloku kodu.

---

## Spike 006

### F-11: hipoteza „abort/retry biasuje x vs single-accepted" obalona

- **Co:** oczekiwano różnicy histogramów `x|accept` między retry-until-success
  a jednokrotnym oknem Accepted. Pomiar + przegląd `explore`: dla i.i.d. okien
  oba oszacowują **ten sam** rozkład; TV ≈ 0.
- **Naprawa:** metryka TV (add-1 smoothing zamiast rel-diff na rzadkich
  kubełkach — poprzednio rel=1 z pustego kubełka); dokumentacja: bias jest
  względem rozkładu **docelowego**, nie względem single.
- **Znaczenie:** nie mylić „retry kosztuje wiele okien" (prawda) z
  „retry biasuje wynik względem single" (fałsz w tym modelu).

### F-12: cap 10_000 zawyżał `mean_windows_per_success`

- **Co:** break po limicie zliczał `windows` bez `successes`.
- **Naprawa:** zliczanie `windows += used` tylko przy sukcesie; `hit_cap` flag.

---

## Granica (zgłoszenie właściciela) — F-13

### F-13: `verify_consistency` odtwarzało sekret (`a0` wielomianu)

- **Co:** `interpolate_poly` budowało współczynniki, w tym `a0=f(0)=sekret`.
  Kontrola „spójności" trzymała sekret w pamięci. Razem: harness widzi wszystkie
  udziały + dealer zna wejście ⇒ **nie wykazujemy** „żaden proces nie zna
  pełnego materiału".
- **Naprawa algebraiczna:** usunięto `interpolate_poly`; `eval_lagrange`
  wyłącznie w `x≠0` (`XZero` na 0); `PartyView` (jedna kolumna).
- **NIE zamknięte:** izolacja procesów, dealer bez wejścia (DKG),
  otwarcia tylko w kontrakcie — patrz `spike/BOUNDARY_NO_FULL_MATERIAL.md`.
- **Status twierdzeń:** „nie tworzymy f(0)" = TAK; „nikt nie zna materiału" = NIE.

---

## Spike 010

### F-14: wyścigi mailboxa na `fs::write` / wspólnym `pub.tmp`

- **Co:** `exists()` widział plik przed pełnym zapisem (`len=0`); dwa procesy
  walczyły o `r{m}_pub.tmp` (NotFound przy rename). Flaky testy izolacji
  przy równoległości.
- **Naprawa:** `tmp`+`rename` (atomiczny), unikalne `r{m}_pub{p}.tmp`,
  walidacja `de.len()==2`; mutex w `tests/isolation.rs` (F-14b).
- **Lekcja:** mailbox plikowy wymaga atomic publish — `write`+`exists`
  to nie synchronizacja.

### F-15: deal DKG nadpisywany (1 B zamiast 32 B)

- **Co:** `deal{p}_{x}.bin` zapisywany w pętli po bajtach — zostawał 1 B;
  `col[b] ^= bytes[0]` w pętli 32× to samo.
- **Naprawa:** jeden plik 32 B per (nadawca, odbiorca); zsumowanie XOR
  po bajtach z pełnych kolumn.

### F-18: flake testów izolacji (raz na ~10–20 uruchomień)

- **Co:** `tests/isolation.rs` (s8–s32) losowo FAILED przy pełnym `cargo test`;
  samo `--test isolation` zielone.
- **Prawdopodobna przyczyna:** wyścig mailboxa / limity 5–8 s przy obciążeniu.
- **Mitigacja:** mutex `ISO_LOCK`, atomiczne `tmp`+`rename`.
- **Status:** retained; nie kasować. Przy flake → powtórka; nie zamykać jako PASS
  z jednego zielonego biegu bez odnotowania.

### F-19: PRSS additive zero ≠ Shamir-zero w refresh

- **Co:** XOR `ZeroShareStream` w udziały Shamir **nie** zachowuje sekretu
  w rekonstrukcji Lagrange'a (Σ λ_i z_i ≠ 0). Test refresh→G_frag FAIL.
- **Naprawa:** refresh = deal Shamir **zera** (jeden deal na bajt dla wszystkich
  stron); PRSS zera zostają jako budulec addytywny.
- **Lekcja:** nie mylić sumy addytywnej zer z zerami wielomianu Shamir.

### F-20: implementator Q1 (general-3 ultra) skasowany — śmieć w buildzie

- **Co:** po `cancel` `general-3` w `rejection.rs` został `seed_from_u64(0x00R3_SEED_FIX)`
  (nieprawidłowy literał) + brak `SeedableRng` → build FAIL.
- **Naprawa:** `0xC35EED1` + `use rand::SeedableRng`.
- **Lekcja (ft-tryb-pracy):** po cancelu subagenta — **obowiązkowy** `cargo test`
  w głównym oknie przed meldunkiem; retained śmieci zostają w FAILURES.
- Powiązane: F-05/F-09 (general ultra bywa niezawodny/stall).


### F-18b: isolation flake nasila się pod obciążeniem (weryfikator I1/I2)

- **Co:** przy równoległych cargo/isolation: 11/11 → 5/11 → 0/11 faili
  (`status.success()` na subprocess iso; timeouty 5–8 s).
- **Mitigacja:** mutex ISO_LOCK, atomiczne tmp+rename — niewystarczające przy
  starcie wielu procesów.
- **Status:** retained; nie kasować. Przy flake → powtórka z `--test-threads=1`.


### F-21: /tmp tmpfs 100% — No space left on device (ściana)

- **Co:** isolation 0/11 w 0.06 s: `Os { code: 28, StorageFull }` w `iso`.
- **Przyczyna:** /tmp (tmpfs 7.6 G) pełny — VM/obrazy operacyjne
  (nexum-vm-*, ftkey-qsx, alpine-*.qcow2, …) **nie nasze**.
- **Naprawa:** skasowane wyłącznie `/tmp/iso-*` (nasze workdiry); 2.5 G wolne.
- **Stop-and-report:** nie kasuję cudzych VM/obrazów bez słowa właściciela.


### F-16: unused import SeedableRng (sprzątanie po batchu seedów)

- **Co:** `warning: unused import rand::SeedableRng` w modułach testowych.
- **Naprawa:** usunięcie nieużywanych importów.

### F-17: SACRIFICE_MUL_DONE nieecho w stdout demo (spike 011)

- **Co:** parent nie drukował stdout dziecka `sacrifice-mul`.
- **Naprawa:** `print!` child stdout w `cmd_triples_demo`.
- **Wpis uzupełniony** po audycie O2 (wcześniej tylko w SPIKE011_NOTES).

### F-22: U1 Klein — saturating/overflow w Bernoulli (CHANGES ultra)

- **Co:** (1) `u.saturating_mul(total) < w.saturating_mul(Q_ONE)` w
  `klein_step` — bias w lewo (freq_right≈0.0005 vs 0.25); (2) kodowanie
  accept 10/250 z progiem cmp≤10 gubi accept; (3) `w_hi<<32` cichy wrap
  przy w_hi≥2^96 (Rust `<<` bez sygnału).
- **Naprawa:** `prob_right_q32` (redukcja >>40); stały separator cmp=200;
  testy `u1d_klein_step_freq_matches_w`, `u1d_accept_thr_leq_10`,
  `u1d_large_weight_cmp_prob`. Szczegóły `spike/U1_KLEIN_MPC.md` §Retained.
- **Wzorzec:** saturating_mul ≠ overflow-guard; M3 accept = stały 200.

### F-23: U2-RF-1 — retained mid-pass nieścisły + s8 flake

- **Co:** (1) komentarz mid-pass „10 połowień vs 8 rund" błędny — kod robi
  **8 rund SOURCE** (768→6); prawdziwy rozjazd: **765 butterfly** (model
  n/2) vs M4 ESTIMATE **~6144**. (2) `s8_process_isolation_demo` FAIL
  w przebiegu V-U2 (iso.rs:242) — przy kolejnym run OK (flake F-18).
- **Naprawa:** komentarze/pin `n=765`; nazwa `u2c_ntru_fg_gf_ok_const`.
- **Wzorzec:** retained musi trzymać liczby z mapy M4 (SOURCE vs ESTIMATE
  osobno); suite count = mierzony przebieg, nie szacunek.

### F-U6-1 / F-Y5-1: ultra-WERYFIKATOR `general` anulowany

- **Co:** `general-18` (Y5) i `general-25` (U6) — status `cancelled`
  w połowie zadania (po 7 / 19 turach). **Nie** z naszego `cancel`.
  Wzorzec jak F-05/F-09 (general ultra stall/cancel).
- **Naprawa:** fallback weryfikacji w oknie głównym (`Y5_VERIFY_Y_PACKAGE.md`,
  `U6_VERIFY_U_PACKAGE.md`) — jawne, **nie** niezależny kontekst.
- **Zasada:** przy cancelu ultra → stop-and-report + retained; nie udawać
  niezależnego PASS.

### F-24: entry_pin_sha256 = SHA3 zamiast SHA-256 (pin seed9)

- **Co:** `entry_pin_sha256` używało `sha3::Sha3_256` — pin seed9 nie
  zgadzał się z R1 (`4941edb1…`).
- **Naprawa:** `sha2::Sha256` (zależność `sha2`); test
  `r1_answers_sk_range_and_seed9_pin`.
- **Wzorzec:** piny R1 = **SHA-256** (ENTRY_PINS/postseal), nie SHA3-256;
  FNV spike lokalne — nie utożsamiać z formatem R1.

### F-25: warning w ft1536-sys (unused import std::ptr)

- **Co:** `ft1536-sys` (ścieżka [N]/crates) generuje 1 warning przy build
  spiku. Nie nasz crate — nie ruszamy [N] bez słowa właściciela.
- **Stan:** retained; suita spiku zielona. Opcjonalnie: poprawka w [N].

---

## MPS4-F2 (2026-10-21)

### F-NEW-01 (poza zakresem F2): flake `s8_process_isolation_demo`

- **Co:** przy pełnym `cargo test` (paralel) test `s8_process_isolation_demo`
  (`src/bin/iso.rs:242`, asercja `log must not dump column bytes`) FAILED
  w 1. przebiegu; solo i w 2. pełnym — OK.
- **Przyczyna:** asercja `!log0.contains(&format!("{:02x?}", col0[0]))` to
  2-znakowy hex vs log z hashami — fałszywy alarm ~25%/bieg.
- **Status:** retained, **nie ruszać w MPS4-F2** (OUT). Osobne zadanie.
- **Zgłoszenie:** weryfikator T1.1; nie obniża werdyktu F2.

### F-NEW-02: norma engine-nonce nie jest pinem

- **Co:** n_ffsampling dla seed 0x77 + nonce z `Ft1536Signature::sign`:
  101122520 (autor) vs 107272510 (replay weryfikatora) — oba < bound.
- **Przyczyna:** nonce losowy per bieg → n zależy od nonce.
- **Pin reprodukowalny:** seed 0x42 / nonce=[0;40] → **n=103747771** (bit-exact).
- **Status:** retained — nie osadzać norm engine-nonce jako stałych w STATUS.

---

## G-2 (2026-10-21) — VSS + MAC na otwieraniach

### R-G2-1: wyciek Babai (Nguyen–Regev) przez deterministyczny round

- **Co:** deterministyczny `round_half_away` bez szumu Gaussa to otwarty
  wyciek statystyczny (Babai rounding). Właściciel wskazał 2026-10-21.
- **Skutek:** atakujący z wielu podpisów może odzyskać informację
  o f,F z wartości round(t·f/q).
- **Fix:** szum DGDG na udziałach przed round — osobne zadanie T6.
- **Status:** retained, otwarte. NIE deklarować bezpieczeństwa
  statystycznego round.

### R-G2-2: brak MAC na s1,s2 po ring-mulach

- **Co:** mnożenie udział×udział (4 × N² reshare-muls) nie zachowuje MAC.
  Pełne MAC wymaga auth triples (U4) przez każdy reshare-mul (~9.4M).
- **Detekcja tamper s1/s2:** engine verify false (fail-closed na poziomie
  podpisu). Komponentowy MAC na open: `g2_mac_forge_s1_s2_open_detected`.
- **Status:** retained — poza zakresem G-2.

### R-G2-3: VSS na próbce w integracji sign

- **Co:** pełne VSS na N=1536 × 4 poly = ~25K mnożeń Ristretto w debug
  (timeout w testach). Integracja sign używa `G2_VSS_SAMPLE=8`.
- **Status:** retained — produkcyjnie: pełne VSS lub batch verification.

### R-G2-4: InconsistentShare jako błąd bound max|F|

- **Co:** `validate_f_bound` zwraca `InconsistentShare` (najbliższy
  istniejący wariant; enum SpikeError poza zakresem plików G-2).
- **Status:** retained — dedykowany `FBoundViolation` byłby czytelniejszy.

---

## T13 (2026-10-24) — audyt fixes #16, #2, #9

### R-T13-1: fail-open cap w samplerach poza Q16/Q73

- **Co:** `sample_clear`, `sample_mpc_naive`, `sample_gaussian_clear` po
  `attempts > 10_000` zwracają `SampleOutcome` z ostatnim odrzuconym
  kandydatem (jak dawne Q16/Q73).
- **Zakres T13:** prompt wskazywał Q16/Q73 — tam `AttemptsExhausted`.
- **Status:** retained — zmiana API tych samplerów = osobny krok.

### R-T13-2: #9 jawny `delta_known` + skorelowane fałszerstwo (RETAINED)

- **Co:** liniowy MAC + jawne δ → Δ w wartości i δ·Δ w MAC przechodzi
  zero-check. `t13_correlated_forgery_with_known_delta_is_retained`
  pilnuje, że atak **nadal przechodzi**.
- **Decyzja:** prompt dopuszcza „ukryte δ **lub** retained + test
  skorelowany" — wybrane retained (granica modelu G-2 dealerskiego MAC).
- **Fix (przyszły):** MAC przez `dkg_zp_delta_shares` / ukryte δ (jak Y6),
  bez `delta_known` na ścieżce weryfikacji.
- **Status:** retained, jawne. NIE ogłaszać #9 „naprawione".

### R-T13-3: s8_process_isolation_demo flake (F-18/F-NEW-01)

- **Co:** raz przy pełnym `cargo test` (po lib) s8 fail: „log must not
  dump column bytes"; osobno `--test isolation` 14/14 OK.
- **Status:** retained flake (jak F-18); poza zakresem T13.

### R-T13-4: serce-verify --check-secrets → fixtures testowe

- **Co:** 9 podejrzanych linii w `SERCE/tools/tests/data/SECRETS_SAMPLE.md`
  i `run_tests.py` (sk-TES…, ghp_FA…, AKIAFA… — ewidentne markery testowe
  skanera). Nie wprowadzone przez T13.
- **Status:** STOP-AND-REPORT do właściciela; **bez** cichych czystek.
