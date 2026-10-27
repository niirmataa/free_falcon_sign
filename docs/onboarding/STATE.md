# Stan projektu — punkt wejścia

**2026-10-27 — S09/THRESHOLD_P2_001: WP-030 DONE — pełny przepływ setupu 2-z-3 (G2).**
`protocol::setup`: `SetupSession` w pełni wdrożone dla 3 stron ($k=2, n=3$) na
profilu `TEST-ORACLE`. Wdrożono kanoniczne kodeki CBOR (`SetupInit`,
`VssSharePayload`, `ComplaintPayload`, `SetupFinal`), weryfikację 32 instancji
VSS nad $Z_q$ i $Z_p$, generowanie skarg i blame przy błędzie dealera oraz
finalizację DKG do `PartyState<DkgOk>`. Integracyjne testy honest (zgodny
`dkg_root`, interpolacja Lagrange'a) i malicious (P2 sfałszowany udział →
skarga, dyskwalifikacja, abort) w 100% PASS (31 testów protocol, clippy 0).
Następny krok: WP-031 (protokół podpisu 2-z-3).

**2026-10-27 — S09/THRESHOLD_P2_001: Bramka G1 ODEBRANA — werdykt PASS_SCOPED_REVIEW.**
Niezależny recenzent Gemini 4 Argon (Google AI Studio, wyznaczony przez
właściciela; autor ≠ recenzent) przeprowadził pełny odbiór G1 na HEAD `5883b19e`
(raport `REVIEW_G1_VERDICT_ARGON.md`). Przeliczył 7 skryptów KAT, diff CBOR = 0,
44 pliki korpusu fuzzera, wektory silnika C oraz SBOM. Wykryte 3 kwestie
techniczne zostały natychmiast zaadresowane w kodzie:
1. `envelope.rs`: sprzężenie monotoniczności `(seq, round)` i obsługa duplikatów
   ze starszych rund bez fałszywych `RoundMismatch` (3 nowe testy PASS).
2. `cbor.rs`: kanoniczna obsługa tablic CBOR (major 4) pod `payloads_v0.cddl`
   z odrzucaniem form niekanonicznych (2 nowe testy PASS).
3. `fuzz.rs`: ujednolicenie losowania `rng.below(16)` i `#![forbid(unsafe_code)]`.
Wszystkie testy workspace: 163/163 PASS, clippy -D warnings 0 uwag. Bramka G1
zamknięta ze statusem PASS_SCOPED_REVIEW; wejście w Bramkę G2 (WP-030).

**2026-10-27 — S09/THRESHOLD_P2_001: pakiet materiałów odbioru G1 gotowy.**
`REVIEW_G1_PACKAGE.md` (v1): jedna komenda powtórzenia całości
(`impl/ci/check.sh`, ~10,5 min, oczekiwane 158/162 testów, 0 symboli
oracle w PROD, 35/35 rlib identycznych, SBOM zgodny, miri 100/14),
indeks dowodów per WP z pinami, granice jawne (9 punktów: silnik poza
P2, PROD martwy bez O-05, odtwarzalność per-checkout, fuzz
deterministyczny, kodery payloadów w G2, …), inwarianty do szybkiej
kontroli i format werdyktu (`PASS_SCOPED_REVIEW`/`CHANGES_REQUIRED`/
`BLOCKED`). Rejestr twierdzeń zaktualizowany jawnie: **C-109 → TESTED**
(scope: per-checkout G1; między hostami G5), **C-110** opatrzony
kotwicami prymitywów (WP-023/024), status całości podpisu pozostaje
OPEN (G3 KAT). Materiały przekazane do odbioru.

**2026-10-27 — S09/THRESHOLD_P2_001: WP-026 DONE — G1 kompletne po stronie implementacji.**
`ci/repro_build.sh`: podwójny build release `--frozen` (locked+offline)
do osobnych katalogów target → **35/35 artefaktów .rlib bitowo
identycznych** (manifest SHA256 `444ff57c…`) — kryterium „dwa buildy =
ten sam hash" spełnione wprost. SBOM wyprowadzony **wprost z
Cargo.lock** (stdlib `tomllib`, zero sieci — `cargo metadata --frozen`
pada, bo chce ściągać manifest niecache'owanego opcjonalnego backendu
`fiat-crypto`): 32 pakiety, przypięty w `sbom/sbom_v1.txt`, rozjazd z
pina = FAIL w CI. Pliki `.d`/`.fingerprint` świadomie poza porównaniem
(zawierają ścieżki target-dir). Pełne `ci/check.sh` end-to-end PASS
(10,5 min; miri core 100/14). Granica jawna: odtwarzalność per-checkout,
nie między hostami (remap-path-prefix i stabilny cache rejestru — poza
G1). Dowód: `impl/ci/WP026_CHECK_2026-10-27.txt`. **Wszystkie pakiety
implementacyjne G1 są DONE** (WP-017 PARTIAL z deferral mlock→G2);
bramka czeka już tylko na **niezależny odbiór** (autor ≠ recenzent,
wyznaczenie należy do właściciela). Następny krok: przygotować pakiet
materiałów odbioru G1 (dowody, piny, zakresy twierdzeń).

**2026-10-27 — S09/THRESHOLD_P2_001: WP-022 DONE (fuzz + korpus w repo).**
Bez offline libFuzzera fuzz jest deterministyczny i seedowany (styl
WP-019), ale z trzema wzmocnieniami: (1) korpus **44 plików w repo**
(`fuzz/corpus/wire/`: 2 poprawne, 10 non-canonical z niezależnej
referencji Python, 32 mutacje seedowane) z runnerem weryfikującym bitową
odtwarzalność w `check.sh`; (2) niezmiennik **fixpoint** — jeśli dekoder
zaakceptuje bajty, re-kodowanie musi dać identyczne bajty (dekoder nie
może „naprawiać” wejścia); (3) ~340 000 mutacji łącznie: wire 100k,
codec 4×60k (`Poly`/`ExpShare`/`VssCommitments`/`PairwiseKey`),
`hash_to_point` 8k z determinizmem. Wynik: **0 panik, 0 złamań
fixpointu**; 158 testów PASS (default) / 162 (all-features); miri
ignoruje ciężkie pętle z powodem. `decode_sk` odroczony — dekoder
klucza w Rust nie istnieje (format jest własnością silnika C; pin KAT
WP-024); wróci z portem sign/verify. Dowód:
`impl/ci/WP022_CHECK_2026-10-27.txt`. W G1 został tylko **WP-026**
(reproducible build) i niezależny odbiór.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-027 DONE (wire v1: CBOR freeze).**
Format `body`/`envelope` przełączony z przejściowego binarnego na
**kanoniczny CBOR** (RFC 8949 §4.2): własny moduł `cbor.rs` bez zależności
(writer najkrótszą formą; reader odrzuca nint/text/array/tag/float, formy
nieskrócone, długości nieokreślone i zarezerwowane, śmieci po elemencie),
`Body`/`Envelope` mają `to_cbor`/`to_bytes` + ścisłe `TryFrom<&[u8]>`.
MAC liczony teraz dokładnie wg SPEC §9.3: `HMAC(K, domain ||
canonical(envelope\{3}))`. Wektor end-to-end wygenerowała **niezależna
referencja Python** (własna implementacja CBOR); Rust koduje/dekoduje
bajt w bajt identycznie, `msg_id` i MAC zgodne z pinem, a **10/10
wariantów non-canonical** (nieskrócone uinty, mapa nieokreślona, klucze
nieposortowane, duplikat, obcy klucz, trailing, tag, text, brak klucza)
jest odrzuconych z `NonCanonicalCbor`. Schematy w repo: `wire/schema/
envelope.cddl` (FROZEN v1) + `payloads_v0.cddl` (24 typy; SIGN_OPEN
DRAFT → WP-041). Stare koperty WP-020 są nieważne — to zamierzone
zamrożenie v1. Wynik: **150 testów PASS** (default) / 154 (all-features),
clippy/deny/fmt + skrypty KAT/wire/PROD PASS. Dowód:
`impl/ci/WP027_CHECK_2026-10-26.txt`. Kodery payloadów i wektory per typ:
G2. Następne w G1: WP-026 (reproducible build) albo WP-022 (fuzz, teraz
ma gotowy cel: dekoder wire).

**2026-10-26 — S09/THRESHOLD_P2_001: WP-024 DONE (KAT-piny z silnika).**
`impl/KAT/falcon_ternary_logn10_v1.txt` to wektor z rzeczywistego
silnika: syntetyczne publiczne seedy (keygen/sign, `replace=1`) +
zewnętrzny nonce 40 B + msg 32 B → pk 2881 B, podpis 2363 B i c0 (1536
współczynników); silnik sam zweryfikował swój podpis (`engine_vrfy=PASS`).
Klucz prywatny tylko jako `skey_shake256` — nie ma bajtów klucza w repo.
`ci/kat/run_falcon_kat.sh` regeneruje KAT bitowo identycznie i pilnuje 13
pinów plików silnika; test Rust (`tests/kat_pins.rs`, 3/3) reprodukuje c0
współczynnik po współczynniku przez `hash_to_point` i sprawdza
digesty/nagłówki (pk `0x8A`, sig `0xAA`). Piny pk/sig czekają na
konsumpcję w WP-027 (wire) i porcie sign/verify. Wynik: 139 testów
PASS (default) / 143 (all-features), clippy/deny/fmt/skan-PROD PASS.
Dowód: `impl/ci/WP024_CHECK_2026-10-26.txt`. Następne: WP-027 (wire
freeze) albo WP-026 (reproducible build).

**2026-10-26 — S09/THRESHOLD_P2_001: WP-025 DONE (build PROD bez oracle).**
Ścieżka `TEST-ORACLE` (jawny NTRU) jest teraz za cechą `test-oracle`,
domyślnie wyłączoną: `verify_plaintext`, `validate_ntru` i wariant
`EvidenceSource::PlaintextTestkit` nie istnieją w buildzie PROD. Skutek
zamierzony: bez O-05 (MPC NTRU) build PROD nie ma żadnej ścieżki do
`SignSession` — fail-closed na poziomie kompilacji, nie tylko runtime.
`ci/check_prod_symbols.sh` skanuje źródła (brak `xof`/`iso`/trusted
dealera, node/coordinator nie linkują testkitu) oraz `nm` release-rlib:
PROD = 0 symboli oracle, kontrola negatywna z cechą = 2 symbole.
`ci/check.sh` uruchamia teraz testy/clippy także `--all-features` i ten
skaner. Wynik: **136 testów PASS** domyślnie, **140 PASS** z
`--all-features`; clippy/deny/fmt/release build PASS. Dowód:
`impl/ci/WP025_CHECK_2026-10-26.txt`. To nie odbiór; PROD nadal czeka na
O-05. Następne w G1: WP-024 (KAT pinów), WP-026 (reproducible build),
WP-027 (wire freeze), WP-022 (fuzz).

**2026-10-26 — S09/THRESHOLD_P2_001: WP-023 DONE (differential vs silnik).**
Cztery prymitywy Rust porównano bajtowo z rzeczywistym źródłem silnika
`Extra/c` (nie z kopią): `hash_to_point`, NTT ternarna, iNTT ternarna i
mnożenie w `R_q` ścieżką NTT. Harness C kompiluje `falcon-vrfy.c`
(z dostępem do `static mq_*`) oraz `falcon-enc.c`/`shake.c`; program Rust
liczy te same przypadki przez publiczne API. Wynik: **10 000 przypadków
na kategorię (40 000 digestów, 1 280 036 B), 0 rozjazdów**, oba pliki
mają ten sam SHA256 `b5d5baf8…f083`. Piny silnika i harnessu są w
`impl/ci/engine_diff/PIN_2026-10-26.txt`, opis formatu i pułapek w
`engine_diff/README.md`, dowód `impl/ci/WP023_CHECK_2026-10-26.txt`.
Po drodze złapano dwa błędy harnessu (SHAKE capacity 256 zamiast 512;
przeplatana kolejność generowania `a`/`b`) — po poprawkach zgodność
pełna. To nie jest odbiór ani dowód bezpieczeństwa: FFT/ffSampling,
sampler, keygen/sign/verify i ścieżka binarna `q = 12289` pozostają poza
zakresem. Następne w G1: WP-024 (KAT pinów) albo WP-022 (fuzz).

**2026-10-26 — S09/THRESHOLD_P2_001: WP-021 DONE (fail-closed sampler).**
Audyt #16 domknięty po stronie mechanizmu prób: `sampler::RejectionSampler`
ma twardy cap, a po jego wyczerpaniu zwraca wyłącznie
`AttemptsExhausted`. Nie istnieje `SampleOutcome` ani „awaryjne” `Ok`
z odrzuconą próbką; cap 0 jest błędem, nie nieskończonością. `uniform_below`
odrzuca ogon `[limit, 2^64)`, więc nie ma modulo bias. `hash_to_point`
korzysta teraz z tego samplera z capem 1 MiB w 16-bitowych słowach; jego
KAT pozostał identyczny. Stan: 140 testów natywnych PASS (core 114 +
integracyjne 2 + protocol 19 + 5 doctestów), clippy/deny PASS, miri
`sampler::` 5/5. Dowód: `impl/ci/WP021_CHECK_2026-10-26.txt`. Granica:
to licznik prób, nie źródło entropii; rozkłady Klein/Gaussian (WP-040)
pozostają do dowiedzenia.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-020 DONE (koperty, replay, rollback).**
Audyt #15 domknięty po stronie warstwy aplikacyjnej: `protocol::envelope`
ma `Body` zgodne z SPEC §9.3, MAC per para (HMAC-SHA256 z domenami),
`msg_id` z SHAKE256 niezależny od odbiorcy oraz `SessionReceiver`, który
sprawdza kolejno MAC → rundę → `seq`. Cofnięcie rundy daje
`RoundMismatch`, stara lub sprzeczna sekwencja `ReplayDetected`, a
identyczna retransmisja (`seq` + `msg_id`) jest idempotentna (`Duplicate`).
Okno replay ma 64 pozycje; skoki nie powodują pętli po całym `u64`.
Stan: 135 testów natywnych PASS (core 109 + integracyjne 2 + protocol 19
+ 5 doctestów), clippy/deny PASS, miri `envelope::` 7/7. Dowód:
`impl/ci/WP020_CHECK_2026-10-26.txt`. Granice: to nie AEAD/TLS — klucz
`K_mac` z PSK jest tylko TEST-ORACLE, a PROD wymaga TLS exporter+HKDF
(WP-045); kodowanie jest przejściowe binarne, CBOR to WP-027.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-019 DONE (malformed input, limity).**
Audyt #14 domknięty dla zaimplementowanych typów wire: `ExpShare`,
`VssCommitments`, `Poly` i `PairwiseKey` mają `TryFrom<&[u8]>` z dokładną
długością i walidacją kanoniczności; `VssCommitments` odrzuca >16 punktów
**przed** alokacją, a `Poly` ma serializację LE dokładnie `2·N` bajtów.
Test 10⁶ deterministycznych wejść (losowe bufory + 1–4-bitowe mutacje
poprawnych serializacji) zakończył się **0 panik**; błędy wyłącznie przez
`Result`. Stan: 128 testów natywnych PASS (core 109 + integracyjne 2 +
protocol 12 + 5 doctestów), clippy/deny PASS, miri `poly_le_bytes` 1/1.
Dowód: `impl/ci/WP019_CHECK_2026-10-26.txt`. To nie coverage-guided fuzzing
— brak instrumentacji/korpusu (WP-022); 10⁶ nie jest dowodem formalnym.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-018 DONE (bitność i spójność udziałów bitu).**
Audyt #13 domknięty po stronie walidacji udziału: `bits::shake_bits` daje
strumień bitów 0/1 z SHAKE256 (LSB-first, znany KAT `0x46 0xb9…`), a
`bits::BitShare` przechowuje ten sam bit w GF(2^8) i `Z_q`/`Z_P`.
Konstruktor odrzuca każdą wartość spoza `{0,1}` (`NonBitShare`) oraz
niezgodność reprezentacji (`InconsistentShare`), więc sfałszowany udział
nie wejdzie do obwodu. Udział nie jest `Clone`, jest zeroizowany, a `Debug`
nie pokazuje bitów. Stan: 125 testów natywnych PASS (core 108 + protocol 12
+ 5 doctestów), clippy/deny PASS, miri `bits::` 4/4. Dowód:
`impl/ci/WP018_CHECK_2026-10-26.txt`. Granica: to walidacja pojedynczego
udziału, nie obwód `a(a+1)=0` ani SHAKE na udziałach (WP-030+/O-16).

**2026-10-26 — S09/THRESHOLD_P2_001: WP-015 DONE (maski otwarć w `Z_P`).**
Audyt #4 domknięty po stronie prymitywu: `mask::Mask` jest jednorazowa
i liniowa (brak `Clone`/`Copy`, `apply` konsumuje maskę), więc dwóch otwarć
tego samego sekretu nie da się wykonać tą samą maską. Szerokości 1..=60 są
dokładnie jednostajne (2^128 dzieli się przez 2^bits), a `bits=61` to pełne
`Z_P` z redukcją `% P` i obciążeniem ≤ 2^-67 (osobny test). Maski wąskie
wymagają `secret < 2^bits` — węższa maska nie ukrywa górnych bitów, więc
takie użycie jest błędem, nie „prawie poprawnym” wynikiem. Test statystyczny:
2048 par otwarć tego samego sekretu, brak powtórzeń, |Pearson| < 0.05,
różnice jednostajne (chi² < 45); 120 testów natywnych PASS, miri `mask::`
4/4 (3 statystyczne ignorowane z powodem). Dowód:
`impl/ci/WP015_CHECK_2026-10-26.txt`. To prymityw — wiązanie masek z rundą
i MAC należy do WP-030+; odbiór niezależny pozostaje otwarty.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-016 DONE (pełne VSS + agregacja S5).**
Domknięto lukę „próbki 8 współczynników”: `state::validate_dkg` składa teraz
udziały dealerów per instancja seeda (`vss::fold_shares`), sumuje zobowiązania
(`vss::fold_commitments`) i weryfikuje agregat **wszystkimi** współczynnikami.
Test przy k=16 fałszuje wyłącznie współczynnik `x^15` i dostaje
`InconsistentShare`, więc obejście z próbkowaniem zostałoby złapane.
Bound dokładności: 16 dealerów × (q−1) < 2^244 < L ≈ 2^252 — suma Scalarów
nie zawija modulo L. Zagregowany seed jest trzymany jako
`Zeroizing<[u16; 32]>`, wydawany przez `seed_share()` bez kopiowania, `Debug`
go nie wypisuje. Stan: 112 testów natywnych PASS (core 97 + protocol 12 +
3 doctesty), clippy `-D warnings`/deny PASS, miri `vss::` 22/22 oraz protocol
1 passed/11 ignored (powód w atrybucie). Dowód:
`impl/ci/WP016_CHECK_2026-10-26.txt`. To nie jest odbiór — autor ≠ recenzent.
Następne w G1: WP-015 (maski w `Z_P`) albo message flow setupu (WP-030).

**2026-10-26 — S09/THRESHOLD_P2_001: WP-017 PARTIAL (zeroizacja typów).**
Wszystkie typy sekretne w `core` mają `ZeroizeOnDrop`; `MacShare` stracił
`Clone` (dowód: doctest `compile_fail`), `Debug` nie wypisuje sekretów.
`VssCommitments` zostaje `Clone`/`Debug` świadomie — to dane publiczne.
Poza zakresem i jawnie otwarte: `mlock`/no-dump (node, G2/WP-045) oraz
test allocator-hook na brak kopii (G2). Dowód:
`impl/ci/WP017_CHECK_2026-10-26.txt`.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-014 DONE (typestate DKG/NTRU).**
`ft-threshold-protocol::state` wymusza typami drogę do podpisu:
`PartyState<Unvalidated>` → `validate_dkg` (weryfikacja VSS wszystkich
dealerów dla 32 instancji seeda + kanoniczny `dkg_root` wiązany z `sid`,
`pk_hash`, `k` i transkryptem) → `validate_ntru` (`f·h = g` w `R_q`) →
`PartyState<Ready>` → `SignSession::begin`. Nie ma publicznego konstruktora
`Ready`; dwa doctesty `compile_fail` pilnują, że ścieżka nie zniknie.
`PROD` odrzuca evidence NTRU z jawnego klucza (`ProdEvidenceMissing`) —
O-05 pozostaje otwarte. Testy: 10 jednostkowych + 2 `compile_fail`, pełny
miri core 81/11 PASS (log `.build/miri_full_2026-10-26.log`), miri protocol
1/9 ignored (powód w atrybucie). Dowód: `impl/ci/WP014_CHECK_2026-10-26.txt`.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-013 DONE (dwie domeny + ukryte δ).**
Właściciel potwierdził **D-025** (dwie jawne domeny: `Z_q` dla udziałów
pułapki, `Z_P` dla MPC). Zaimplementowano `zp` (`P = 2^61−1`: add/sub/mul/
inv/pow, Shamir, Lagrange, spójność) oraz `mac` (SPDZ-style MAC
z **ukrytym** δ: `DeltaShares` z wkładów stron, `open_checked`,
`CoreError::MacFail`). W API produkcyjnym **nie ma** `delta_known` ani
konstruktora z dealerem — dealer istnieje wyłącznie w `#[cfg(test)]`.
KAT niezależny (`ci/kat/zp_reference.py`), **92 testy natywne PASS**,
clippy/deny PASS, miri: `zp` 9/9 i `mac` 12/12. Granica utrzymana: MAC
pojedynczego otwarcia wykrywa niespójne pary `(share, mac)`, ale nie
zastępuje kontroli MAC na wynikach obliczeń (auth triples, WP-016).
Commit `91b0ca52`; bez push.

**2026-10-26 — S09/THRESHOLD_P2_001: WP-010/011/012 DONE (prymitywy + CI).**
Workspace 7 crate'ów (toolchain 1.94.0) i hermetyczne `impl/ci/check.sh`
(fmt/build/test/clippy `-D warnings`/`cargo deny --offline`/miri) gotowe;
`cargo-deny 0.20.2` z pinem bazy advisoryjnej. WP-012 portu prymitywów
**DONE**: `gf256` (GF(2^8)+Shamir seeda), `ring` (`R_q`, q=18433, N=1536),
`shake` (SHAKE256 + `hash_to_point` silnika), `prss` (pary kluczy, udziały
zera), `ntt` (wierny port `mq_mkgm3`/`mq_NTT_ternary`, logn=10),
`shamir_zq` (Shamir w `Z_q` dla seeda B′) i `vss` (Pedersen nad `Z_q`,
zobowiązania + udziały wykładnikowe, pin `H`). Dowody: **71 testów
natywnych PASS**, KAT niezależne w Pythonie/OpenSSL/dalek, differential NTT
vs szkolne `Poly::mul`, miri PASS (52 uruchomione + 11 `ignore` na czas
Miri; blok `shamir_zq` 8/8 PASS). Log zbiorczy:
`impl/ci/WP012_CHECK_2026-10-26.txt`. Commity lokalne: `d3c17014` (deny),
`e7036a0b` (VSS), `5d87932f` (Shamir Z_q + WP-012 DONE). To **nie** jest
odbiór G1: brak niezależnego recenzenta (autor ≠ recenzent). Bez push.

**2026-10-26 — S09: decyzje potwierdzone, wariant B′ (D-024).**
Właściciel potwierdził: **2-of-3** (D-003), **TLS 1.3/mTLS** (D-010),
**kanoniczne CBOR** (D-011), **HSM od G3** (D-013), **produkcja w `[N]`
na G3** (D-016), **G2 = `TEST-ORACLE` / G3 = `PROD`** (D-022) oraz
**B′** jako reprezentację klucza (D-024; D-021 `SUPERSEDED`).
B′ = seed-share DKG + jednorazowy MPC `G(seed*)` w setupie → udziały
pułapki; seed zeroizowany, token = brama KEK pieczęci (nie nośnik).
O-16 (MPC `G`) wchodzi do v1 jako blocker G3; O-01 jest przez nie
subsumowany, nie „rozwiązany”. WP-003 `DONE`; G1 odblokowany —
następne WP-010/011 (workspace + CI), potem WP-012. Nadal `PROPOSED`:
D-004/005/006/012/014/015 (nie blokują G1). Live `sign`/`verify`
host-path: **PASS** 2026-10-26 (`verify` rc=0; fp bez zmian; bundle
5 pól, hashe w `FTKEY_INTEGRATION_MAP.md` F-8); PIN wpisał właściciel
lokalnie. Zmiany lokalne; bez push.

**2026-10-26 — S09/D-023: QSX/VM wyłączone z P2.**
Właściciel: „nie używamy już VM QSX, ponieważ właśnie po to robimy próg,
żeby rozwiązać tę historię”. P2 **nie używa** `ftkey-vm`, QSX ani
efemerycznej VM; node = osobny proces/host z udziałem, a izolację zapewnia
próg, nie hypervisor. F-1/F-3/F-6/F-7 w FTKEY pozostają długiem FTKEY,
nie blockerami P2; G1 wymaga braku zależności od QSX w buildzie.
Mapa FTKEY: `development/THRESHOLD_P2_001/FTKEY_INTEGRATION_MAP.md`.
Live host-path: `getInfo` + `pub` na tokenie **PASS** (fp = `ftkey.fp`);
live `sign`/`verify` **NOT_RUN**. D-021 (A vs B/B′) nadal `PROPOSED`;
D-003/010/011/013/016/022 bez zmian. Zmiany lokalne; bez push.

**2026-10-26 — S09/THRESHOLD_P2_001: otwarcie toru P2 (G0).**
Na polecenie właściciela („idę w P2, mimo że może to trwać długo”)
otwarto nowy tor progowego podpisu FT1536 w
[`development/THRESHOLD_P2_001/`](../../proofs/ft1536/development/THRESHOLD_P2_001/README.md).
Wejściem jest spike 001 (414/414) jako spec/oracle/testkit, nie fundament
produkcji. Powstały: README, PLAN, SPEC v0, THREAT_MODEL, DECISIONS,
CLAIMS_REGISTER, GATES, WORK_PACKAGES, RISKS i SOURCE_MAP.
Wybór **2-of-3** (D-003), wariantu **A** — udziały pułapki (D-021) — oraz
podział **G2 = signing plumbing na `TEST-ORACLE`, G3 = bezdealerowy ważny
setup NTRU + realny Klein/ffSampling** (D-022) są `PROPOSED`, czekają na
potwierdzenie. G0 jest gotowy dokumentacyjnie (poza decyzjami); G1 blokują
decyzje D-003/010/011/013/016/021, a G2 dodatkowo D-022. **To nie jest
produkcja, nie jest „threshold FT gotowy” i nie jest deklaracja
bezpieczeństwa** — G2 nie może być opisywany jako „bez dealera”. Najbliższe kroki:
WP-010/011 (workspace + hermetyczne CI) i WP-012 (port prymitywów z KAT).
Zmiany lokalne; push wyłącznie po słowie właściciela.

**2026-10-11 — F04/F05: targeted recheck SCOPE_002 = PASS_SCOPED.**
Na polecenie właściciela sprawdzono (a)–(e) bez nowego pełnego replayu
i bez wywołań Lean. Przyjęty zakres: dokładnie **166 modułów, #001–#165
i #167**, z dwoma udokumentowanymi wyjątkami: #166 SelectBitPreserve
wyłączony (zero konsumentów, cytat dodatkowego bv_decide); #156 ThetaBox
wewnątrz closure z historycznym wyjątkiem lintera i evidence rekurencji.
Wszystkie 167 historycznych źródeł są zgodne z pinami i d053369e;
3813 wcześniejszych plików, PREVIOUS_* i oba receipty replayu nienaruszone.
Standard-only dotyczy zapisanych audytów: 569 rekordów z listą zależności
plus 12 wyników axiom-free, razem 581 wyników #print axioms w closure 166.
[Raport, macierz i proweniencja](../../proofs/ft1536/development/T12_1/run2/notes/F04_ROM_VARIANT_A_RECHECK_002/REVIEW.md)
oraz REVIEW_RESULT.json zapisują nowy PASS_SCOPED; historyczny REVIEW_001
pozostaje CHANGES_REQUIRED, receipt SCOPE_002 bez zmian. To odbiór zakresu
i evidence z jawnym rozliczeniem self-review korekty oraz dwóch izolowanych
kontrolerów surowych artefaktów. ReplyShape/sampler źródłowy, most bajtowy,
hzero/budżety i computational PRG/F06 nadal OPEN. Bez owner acceptance,
push/importu/tagu; MIGRATION_HOLD i NISKI priorytet utwardzania zachowane.

**2026-10-11 — F04/F05: korekta zakresu po R1/R2 REVIEW_001.**
Na polecenie właściciela skorygowano granicę zaufania w NOTES/CHECKPOINT,
bez zmian matematycznych. Odbierana closure to dokładnie **166 modułów,
#001–#165 i #167**; #166 SelectBitPreserve świadomie wyłączono jako
historyczną diagnostykę z aksjomatem `select_bits_equiv._native.bv_decide.ax_1_5`.
Graf potwierdza zero konsumentów. Standard-only dotyczy audytów closure 166 modułów:
569 zachowanych wydruków oraz 21 deklaracji odbioru; nie całego builda 167 modułów.
#156 ThetaBox zachowuje jawny wyjątek narzędziowy lintera, z przypiętą
testową kopią i logiem błędu rekurencji. Nowy [receipt i lista modułów](../../proofs/ft1536/development/T12_1/run2/notes/F04_ROM_VARIANT_A_SCOPE_002/RECEIPT.json)
wiąże piny i kontrolę 3813 wcześniejszych plików; `final_clean_002` oraz
REVIEW_001 są nienaruszone. **SCOPE_CORRECTED_AWAITING_TARGETED_RECHECK**;
historyczny werdykt CHANGES_REQUIRED nie został podniesiony. Następny krok:
ukierunkowany recheck zakresu/evidence. Dwa zadania utwardzania mają NISKI
priorytet w ROADMAP, osobna partia. Bez nowego replayu Lean, push/importu/tagu;
ReplyShape, sampler źródłowy, most bajtowy, hzero/budżety i F06 nadal OPEN.
MIGRATION_HOLD zachowany.

**2026-10-11 — F04 wariant A + F05: niezależny odbiór CHANGES_REQUIRED.**
Na polecenie właściciela („no to odbierdxz”) wykonano własny fresh replay
HEAD `d053369e`: 167/167 modułów exit 0, bez diagnostyk kompilatora;
własny audyt 21 deklaracji i 3 dodatkowe lematy supportu mają standardowe
aksjomaty. Matematyczna naprawa interfejsów jest poprawna pod jawnymi
przesłankami źródłowymi. Pełny pakiet nie spełnia jednak literalnego
kryterium 1 prompta: nieimportowany przez naprawę historyczny
`SelectBitPreserve` ma 3 eksporty z dodatkowym aksjomatem natywnego
`bv_decide`; `ThetaBox:166` zachowuje historyczny wyjątek lintera
(własny test z włączeniem: błąd limitu rekurencji lintera).
[Raport i zakres](../../proofs/ft1536/work/FT1536_F04_ROM_A_REVIEW_001/REVIEW.md),
REPORT `42e5e11fb7dc8b35c71312705733f3ab16e9055bacd099b48cf6cc3c7727f8d7`.
Wymagana korekta dowodów/evidence albo jawne zawężenie zakresu i rozliczenie
wyjątku; nie trzeba od nowa wykonywać matematycznego F04/F05.
ReplyShape/source-defined sampler, most bajtowy, hzero/budżety oraz
computational PRG/F06 nadal OPEN. Bez owner acceptance, importu,
commita, tagu i push w tym odbiorze; MIGRATION_HOLD zachowany.

**2026-09-30 — przygotowany dodatkowy audyt GPT-6.1 Sol: całe development + T03-B.**
Właściciel rozszerzył test nowego modelu na połączenie wszystkich aktualnych
ścieżek `development/T12_1/{run2,source3,t5}` oraz własny audyt T03 RUN_002.
[TASK/prompt/W](../../proofs/ft1536/CURRENT_SOL61_AUDIT_TASK.md):
`FT1536_SOL61_DEVELOPMENT_T03_AUDIT_001`, **PREPARED_OWNER_START**,
`openai/gpt-6.1-sol`, sugerowany xhigh/świeża sesja. Snapshot523 plików
development,3669 przypiętych wejść; MANIFEST `c7ca6aa4…`, TASK `65b7e63b…`.
Wymagane mapa integracji, końcowy typ/premises, własny clean replay oraz
FINDINGS/MISSING_TYPES/COVERAGE. source3 nadal IN_PROGRESS; audyt otrzyma
werdykt snapshotu i osobny werdykt końcowego połączenia. Przygotowano tylko
wejścia/zlecenie, bez startu modelu/replayu. Istniejące scoped reviews,
ownership i MIGRATION_HOLD pozostają podstawą pracy.

**2026-09-30 — najnowsza decyzja: dalsza migracja po zakończeniu wszystkich prac.**
Właściciel wstrzymał dalsze przenosiny/scalanie omawianych torów T12.1
do zakończenia wszystkich tych prac. Raport SOURCE_MAP służy późniejszemu
scaleniu; dwa małe dodatki i dziewięć duplikatów pozostają na liście.
Workerzy kontynuują w aktualnych, potwierdzonych miejscach z uzgodnionymi
małymi commitami/push. Pojedynczy zakończony krok nie zwalnia tej blokady.
[Zasady](WORK_COMMITS.md), [bieżące komponenty](../../proofs/ft1536/CURRENT_DEVELOPMENT.md).

**2026-09-30 — właściciel: małe commity źródeł od work i bieżący GitHub.**
Zapis rzeczywistej pracy na main powstaje po małych logicznych krokach,
przed końcowym verify/review/stages. Po odbiorze osobny checkpoint i tag
z rzeczywistym scope. [Schemat i komendy](WORK_COMMITS.md).
Docelowo nowy [development/T12_1](../../proofs/ft1536/development/T12_1/README.md):
tylko nowości RUN_002, RUN_003 i T5 względem committed stages. Całe stare
work pozostaje ignorowane. Status **PREPARED_HANDOFF**; aktywny agent kończy
krok w swoim W. Dopiski sprawdzamy przez `ft1536_dev_sources.py pending`
i przełączamy go dopiero po handoffie. Kopia nie zatrzymuje ani nie wznawia jobów.
Właściciel zatwierdził katalog i podział: **worker sam robi małe commity/push
po uzgodnieniu z nim; koordynator prowadzi odbiór i commit/tag stages**.
Po handoffie zastępuje to historyczne „bez Git” dla źródeł development.
Worker i koordynator zachowują jeden writer Git naraz.
Pierwszy zapis jest source baseline aktualnych bajtów, nie nowym odbiorem.

**2026-09-29 — P02 v2 REVIEWED / PARTIAL_PROOF; V02 PASS_SCOPED_REVIEW.**
[Autor](../../proofs/ft1536/stages/B20_001_P02_FINAL_001/REPORT.md),
[recenzja](../../proofs/ft1536/stages/B20_001_V02_FINAL_001/REVIEW.md).
Autor dowodów Astra Fast,recenzent Sol w świeżej sesji
`ses_f12645f4effei2l7zDf6rzsuJN`. Właściciel doprecyzował niezależność
względem autora dowodu;wspólny model z pakującym w innej sesji pozostaje jawny.
30612 outputs autora/29751 inputs i343 review outputs/30633 inputs zgodne.
Własny replay V02:43/43,16/16,45 child commands,254.708s;własne Sage/Lean/C
1437 przypadków,10/10 expected exits. Koordynator sprawdził piny/receipty
i wykonał import,setter:P02=REVIEWED,V02=REVIEW_COMPLETE,bez nowego replayu.
Odebrane LE64 i literal-word execution tylko w dokładnych domenach V02.
**no_add_dispatch** potwierdza niespełnialność AddCallObligation;conditional
sub nie jest używalnym kontraktem arytmetycznym. Real add/mul/div/sqrt,
real-rint,caller domains i C→machine nadal OPEN,T03-B bez pełnego recovery.
Zachowano6 nadpisanych old child streams,old HEAD UNRECORDED i granice
druków/historii recenzenta. REVIEW30a82492…/REVIEW_OUTPUTS792b5fb6…;
owner_accepted=false. Global verify:46 checkpointów/59 dokumentów PASS.
Checkpoint pary:`02cb572`,main jako niirmataa,bez push.
[Dokładny scope i następny interfejs](../../proofs/ft1536/CURRENT_P02_TASK.md).

**2026-09-29 — P02 v2 przyjęty integralnościowo; V02 gotowy do nowego okna.**
REPORTce3cad72…/OUTPUTSaf60f1b4…,HEAD41216bb…;30612/30612 outputs,
29751 static inputs,68 poprzednika zgodne. Recorded fresh43/43 i16/16,
50 source bindings,45 child commands,9 historycznych runów/144 kroków/
288 raw logs sprawdzone,bez nowego proofu/replayu koordynatora.
Autor suplementu:Sol,sesja ses_f13139bc5ffeFI41laN8mgF1PA,kontekst
kontynuowany po T03-B (właściciel potwierdził). Ograniczenia:6 nadpisanych
old child log paths,old HEAD UNRECORDED,old print skrócony z nowym pełnym
auditem. P02 **FROZEN_AWAITING_REVIEW / PARTIAL_PROOF** zapisany setterem.
[V02](../../proofs/ft1536/CURRENT_P02_REVIEW_TASK.md):30626 pinned inputs,
MANIFEST6b076251…,BOUND_INPUTS15d1ee66…,prompt/suplement gotowe. Właściciel
zapowiedział verify w nowym oknie;recenzenta tutaj nie uruchomiono.
Matematyczne add/mul/div/sqrt i real-rint pozostają OPEN;V02 oceni scope.

**2026-09-29 — właściciel: najpierw istniejący P02,uzupełnienie freezu i V02.**
P02 ma wykonany `output/` z2026-09-25:COMPLETE_FOR_REVIEW/PARTIAL_PROOF,
68/68 hashy zgodnych,REPORT98ea050b…/OUTPUTS4e8942cc…. Kontrola przygotowania
V02 ujawniła poza manifestem runner,dwa audit modules oraz9 receiptów/raw
logs i brak jednoznacznego final HEAD. Materiały istnieją w W;to brak
kompletnego frozen handoffu,nie ponowne zlecenie całego dowodu P02.
Po stop-and-report właściciel wybrał „Przygotuj uzupełnienie (Recommended)”.
[CURRENT_P02_TASK](../../proofs/ft1536/CURRENT_P02_TASK.md):nowy W
FT1536_P02_FREEZE_CLOSURE_RUN_001,PREPARED_OWNER_START,TASKce02389f…,
bootstrap8700/088b407a…. Zweryfikowano7371 historycznych inputs oraz9
przebiegów/144 kroków/288 raw logs. Wykonawca/model nieuruchomiony.
Nowe add/sub odłożone do odebrania scope P02. STATUS B20 IN_PROGRESS jest
historycznym wpisem;setter otrzyma nowy komplet piny/HEAD po uzupełnieniu.

**2026-09-29 — T03-B RUN_002 odebrany zakresowo i zaimportowany do stages.**
GPT-6 Sol Fast (`openai/gpt-6-sol-fast`),świeży kontekst,sesja
`ses_f13139bc5ffeFI41laN8mgF1PA`: **PASS_SCOPED_REVIEW** dla autorskiego
**BLOCKED_UPSTREAM_EXPORTS**. [Autor](../../proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002/REPORT.md),
[recenzja](../../proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001/REVIEW.md).
1939 outputs autora/1437 inputs i115 review outputs/1946 inputs zgodne.
Własny replay recenzenta7/7 kroków,10/10 produktów;UBSan/ASan3/3 każde,
własne Sage/Lean exit0. Koordynator sprawdził piny i recorded bindings,
bez ponownego mathematical review/replayu. **source_gap=null,full_recovery=false**.
Odebrano15 identities algebra-only,10-termowy ledger,old-target add_C1643
i warunkową arytmetykę;brak required-domain counterexample. E dodaje się po
physical inverse I,A1–D są root-space.7 brakujących source interfaces jawne.
Ograniczenie review:3 wczesne stderr własnych prób Sage nadpisane;opis i
końcowe źródła/logi/wyniki zachowane,bez twierdzenia o kompletności tamtych prób.
REVIEW `acad9276…`,REVIEW_OUTPUTS `a4118200…`;owner_accepted=false.
Checkpoint pary `5ca9abf`,main jako niirmataa;global verify44/57 PASS.
Następne:P02 real arithmetic/domain dispatcher,P06 mapping,potem pełny
INTEGER_DEFECT_TRANSPORT. [Żywy status](../../proofs/ft1536/CURRENT_B_GAP_TASK.md).

**2026-09-29 — potwierdzone powiązanie obu W matematycznych.**
Wskazany GAME_BINDING_RUN_001_V2_1_ERRATA ma295/295 plików zgodnych
z istniejącym stage’em (PARTIAL_PROOF,bez niezależnego odbioru).
RUN_002 już zawiera28/28 zgodnych modułów integracji:13 nowych MiMo
i15 odziedziczonych. Jego OperationTrace konsumuje BitCost na rzeczywistych
śladach simulate;następny brak A3 to kalibracja cen do procedur bitowych,
globalne zasoby i Resources w ConcreteReduction. Oba W są uwzględnione
w [CURRENT_MATH_TASK](../../proofs/ft1536/CURRENT_MATH_TASK.md),z pełnymi pinami.

**2026-09-29 — otrzymano frozen T03-B/RUN_002: BLOCKED_UPSTREAM_EXPORTS.**
Autor GPT-6 Astra Fast,sesja `ses_f13640949ffeJ0RtC7tFAz07UR`,zakończył joby.
REPORT `b2e8c9af…`;OUTPUTS `12df6105…`. Koordynator potwierdził1939/1939
outputs,1437 inputs,13 receiptów/57 kroków/114 raw logów,27 poleceń Sage,
10 semantic bindings i15 eksportów. To integralność,bez nowego review/replayu.
Wynik autora:15 kernelowych identities algebra-only,ledger10 termów,
diagnoza add_C1643±2^-25 (lokalne C,bez membership required domain).
Warunkowa reszta≈11.51331245 nadal przekracza1/2;nowy uniform source bound=null.
P02/P06 i transport3072 old-target defects pozostają otwarte. Workflow:
**FROZEN_AWAITING_REVIEW**,bez awansu B20 i bez importu do stages.
[Osobny odbiór](../../proofs/ft1536/CURRENT_B_GAP_REVIEW_TASK.md) przygotowany,
1946 RO input files,manifest `6a784862…`;model/świeży kontekst wybiera właściciel.

**2026-09-29 — odczyt stanu T12.1/RUN_002 przed kontynuacją.**
Właściciel chce kontynuować `FT1536_MATH_EUFCMA_MTISIS_RUN_002`.
[CURRENT_MATH_TASK](../../proofs/ft1536/CURRENT_MATH_TASK.md) wskazuje teraz
rzeczywisty **WORKING_NOT_FROZEN**,zastępując nieaktualny nagłówek przygotowania.
Jest konkretna nierówność AdvEUF→AdvMT dla `Reduction.build`; żywe źródło
i raw logs zgodne z udanym receiptem.24/24 źródeł komponentów zasobowych
zgodnych z audytem185 eksportów; **globalne Resources całego B nadal OPEN**.
M6 ma liczbowy przedział dający1.27e-24,lecz pełne `hraw`/numeryczne bindingi
i all-KeyGen bridge pozostają otwarte. Osobny T5 ma dalsze MGF/Chernoff;
Gram/source-leaf i końcowy box-tail wymagają domknięcia. CENTERING_CLOSURE
w stages jest osobnym PARTIAL,nie automatycznym rozwiązaniem tych typów.
`output/NOT_FROZEN.md` obecny,finalnego OUTPUTS brak; pełny aktualny replay
i niezależny odbiór pozostają do wykonania. Odczyt10:15:11Z nie wykazał
jobu przypisanego do RUN_002. To kontrola orientacyjna,bez nowego proofu,
replayu,importu lub uruchomienia wykonawcy.

**2026-09-29 — właściciel powierzył tej sesji koordynację T03-B.**
Koordynator: GPT-6 Astra Fast,sesja `ses_f137502d0ffe6BYk3HEHU1xxZL`.
Wykonawca zapisuje pakiet w `work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002/`
pod `proofs/ft1536`,następnie oddaje frozen handoff. Koordynator przygotowuje
osobny niezależny odbiór i po zaakceptowaniu zakresu prowadzi import przez
`archive.py` do stages oraz lokalny commit main jako niirmataa.
[Dokładny folder i kolejność](../../proofs/ft1536/CURRENT_B_GAP_TASK.md).

**2026-09-29 — T03 B-gap: przygotowany RUN_002 z pełnym budżetem A–E.**
[CURRENT_B_GAP_TASK](../../proofs/ft1536/CURRENT_B_GAP_TASK.md) wskazuje nowy
TASK/W: **PREPARED_OWNER_START**,wykonawca jeszcze nieprzydzielony.
Na prośbę właściciela sprawdzono spójność ścieżki SOURCE_ERROR§3 w Sage10.9:
trzy wskazane poprawki same nie wystarczają,bo pozostaje D≈15.6675 oraz
A3≈0.432907; nawet po wyzerowaniu A2/A4/B/C1/C2/C3 suma pozostałych
majorant≈16.10836. To brak wystarczającego budżetu,nie kontrprzykład C.
TASK dodaje jawny source suffix D/target A3 i wspólną kompozycję dla P07–P10;
B-gap nadal OPEN,historyczny REVIEWED/PARTIAL zachowany. Bootstrap1396 plików,
MANIFEST `a47dc77e…`; TASK `c10d5030…`. Rachunek przygotowawczy exit0,
nie nowy review/source proof; nieudaną pierwszą próbę i zgodę na poprawkę QQ
zachowano w [evidence](../../proofs/ft1536/background/T03_B_GAP_2026-09-29/README.md).
P02 ma nowszy lokalny HANDOFF z deklarowanym freeze2026-09-25,ale jego odbiór
i required exports nie zostały związane tym przygotowaniem; STATUS B20 zachowany.

**2026-09-27 — tor treningowy: Qwen3-14B zamiast Kairosa (decyzja właściciela).**
Aktywna baza to `Qwen/Qwen3-14B`, rewizja
`40c069824f4251a91eefaf281ebe4c544efd3e18`; **LoRA BF16 bez kwantyzacji**, A100 80 GB,
etapy do 8 h ciągłej sesji. Konfiguracja i runbook:
`proofs/ft1536/work/KAIROS_RLVR_001/` (historyczna nazwa katalogu).
Eksport Qwen ma natywne think i sprawdzony tokenowy prefiks; cały paper SFT
451/30/19 mieści się w 4096 (max 3021 tokenów). Krótki pilot Lean: SFT192/250
train przy8192; GRPO187/250 train przy prompt6144 + completion2048. Holdouty31/31
są pełne. Tokenizer/testy CPU i adapter native-think→final-proof→Lean sprawdzono;
**trening GPU oraz poprawa skuteczności modelu nie były jeszcze mierzone**.
Aktualne archiwa: `KAIROS_SFT_PAPERS_001/release/QWEN3_14B_SFT_v1.zip` i
`KAIROS_RLVR_001/release/QWEN3_14B_RLVR_v1.zip`, pod `proofs/ft1536/work/`.

**2026-09-25 — import nowości work/ do stages + przeniesienie na NVMe.**
Kanoniczna lokalizacja pracy to od teraz
**`/media/footfalcon/FT1536_DATA/free_falcon_sign`** (decyzja właściciela;
sesja prowadzącego przeniesiona przez session_move). Stary
`/home/footfalcon/free_falcon_sign` = porzucone mirror, nie commitować stąd.
Zaimportowano i zacommitowano checkpointami (integrity PASS, wszystkie
PARTIAL_PROOF, **bez niezależnego odbioru**):
- `FT1536_MATH_EUFCMA_MTISIS_RUN_001` (T12.1 RUN_001): 4461/27 wejść,
  OUTPUTS `a9e3af2e…`, REPORT `fa6bbac7…`; prawo retry, Phi/chi² kierunkowe,
  przypisanie/ekstrakcja celu. Otwarte: interpreter gry, prawa, bit-cost,
  sampler. Nazwa `REPLAY_SEED.sha256` rozliczona **wyjątkiem w archive.py**
  (literalna nazwa, publiczny manifest hashy; test w tests/, 29/29).
- `FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001` (v2.1 errata): 295/6, OUTPUTS
  `c80b3e54…`, REPORT `e593d91e…`. 9 domkniętych typów wiążących kernelowo
  (mixture, lazy, game-law, adversary fold + paid counter, BitCost×3,
  Win→MT, kolizje ≤ K/2^320); audyt 289 eksportów. **Errata v2.1**: zamrożony
  `RESULT.json` v2 (`cc01337d…`) był niepoprawnym JSON-em (1 surowy backslash);
  decyzja właściciela — korekta 1 bajta + `ERRATA.md`, v1/v2 zostają historią.
  v2 rozlicza resztki `badAt_ordinal_union_bound` i `end_to_end…` jako DISCHARGED
  przez RUN_002 — to claim autora, nie odbiór.
- `FT1536_CENTERING_CLOSURE_RUN_001`: 266/6, OUTPUTS `2b74c9cd…`, REPORT
  `35546416…`. **Pełny lemat 2 BEZ premises** (`Rejection ≤ 2^-24`, czyste
  axioms), kanapka theta Fazy A–D, hnum kernelowo; warunkowo dla kluczy z `Adm`:
  `1265/10^27 < delta(h) < 127/10^26` przy przesłankach `hraw`/`hbridge`.
  Freeze opakowany przez koordynatora (autor bez formalnego freezu); sprostowanie
  w REPORT: Faza D zamknięta mimo starszego HANDOFF. Binaria `.so` wykluczone.
Źródła: kopia W `/Obrazy/` w `work/…_OBRAZY` (właściciel wskazał ją jako
kanoniczną; rozbieżność v1 293/v2 294 członków rozliczona wyżej). Materiały:
zlecenie GAME_BINDING w `documents/`, weryfikacja startu dudect w
`provenance/checks/2026-09-23-dudect-start-preparation/` (PREFLIGHT bez
duplikatu — identyczny w dudect-ready). Luka opisowa domknięta też dla trzech
freezów z 09-24 zacommitowanych wcześniej bez wpisów: ADAPTIVE_PROPOSAL,
MUTATION_WRONG_H (kontrprzykład M_wrong_h T03), HOLE_CENSUS — po `PARTIAL_PROOF`.
P02 (B20) nadal `IN_PROGRESS` u wykonawcy; A3 (RUN_002, `NOT_FROZEN`) i A4
(T5_FLAT_REJECT, brak freeze) **nie importowane** — wymagają freeze wg rygoru.
Publikacja: push wyłącznie na jawne polecenie właściciela.

**2026-09-23 — konkretna kontynuacja matematyczna dla Astry: RUN_002.**
[CURRENT_MATH_TASK](../../proofs/ft1536/CURRENT_MATH_TASK.md) wskazuje jedno
zlecenie A1→A2→A3 według oceny właściciela i Astry Pro: interpreter gry,
powiązanie praw/≤Q_s płatnych kroków,zasoby i właściwa redukcja forall A,exists B.
Cap/Emit oraz dodatnia masa BadVerify są częścią A2. Jeden W,jeden finalny
handoff; bez ponownego wyprowadzania Phi i bez pętli odbiorów komponentów.
RUN_001 pozostaje frozen PARTIAL; odziedziczone źródła trzeba przebudować
i audytować w nowym runie. Status RUN_002:PREPARED_OWNER_START.

**2026-09-23 — dudect RUN_002 zakończony: COMPLETED_SCHEDULE.**
Start **07:53:08 CEST**,koniec **17:52:50 CEST**,elapsed35982.034s
(9h59m42s),CPU11,floor-ct. **3 rundy,36/36 prób produkcyjnych bez wykrytego
sygnału**,6 kontroli zgodnych z oczekiwaniem,max raportowane końcowe |t|=3.57049
przy progu10. Controller stderr pusty. Usługa inactive,MainPID0,inhibitor zwolniony.
[Końcowe dane kontrolera](../../provenance/checks/2026-09-23-dudect-completed/COMPLETION.json),
[raport](../../provenance/checks/2026-09-23-dudect-completed/REPORT.md).
To wynik diagnostyczny dla zapisanych kontrastów/hosta,nie proof CT; pełna
niezależna kontrola raw timings pozostaje osobnym odbiorem. Raw są na NVMe.
[Zapis przygotowania](../../provenance/checks/2026-09-23-dudect-ready/README.md).
Blokada równoległych proof jobs wynikająca z trwania pomiaru wygasła.
P02 i niezależny odbiór matematyczny można kontynuować na polecenie właściciela.

**Wstępnie odebrane handoffy,bez matematycznego PASS:**
- T12.1:PARTIAL_PROOF,zgodne4461/4461 oraz REPORTfa6bbac7…/OUTPUTSa9e3af2e…;
  101 twierdzeń to claim autora. Otwarty interpreter/prawa gry/bit-cost;
  kontrprzykład centrowania zachowany. [CURRENT_MATH_TASK](../../proofs/ft1536/CURRENT_MATH_TASK.md).
  Przy późniejszym imporcie wymaga rozliczenia nazwa publicznego
  REPLAY_SEED.sha256 odrzucana przez filtr nazw archiwizatora.
- P02: **IN_PROGRESS** zapisane kanonicznym setterem; wykonawca
  openai/gpt-6-astra-fast,sesja ses_f33f9f0afffeLad43JuCwKBDk2.
  WORD_HELPERS_001:176/176 plików zgodnych,REPORT
  `cac19467943635fb007a86f3dbff31305528b29dde11cc3bacae5639d0c7701f`,
  PROGRESS_MANIFEST `30df495f351cd53a6bf45f27481e5f5a16de46e342c2dd17de0ab80b8758ed3a`.
  Roboczy komponent w W,nie final P02. Następne:literalne dec64le/enc64le,
  floor/rint,FPEMU i domeny. V02/P03 nie odblokowano przez ten snapshot.

**2026-09-23 — przygotowany osobny tor Astry T12.1.**
[CURRENT_MATH_TASK](../../proofs/ft1536/CURRENT_MATH_TASK.md):pełne matematyczne
prawo Sign,publiczny symulator i kernelowy warunkowy lemat EUF-CMA→MT-ISIS.
TASK i25 wejść przypięte,osobny W; PREPARED_OWNER_START,ręczny start właściciela.
Praca równoległa do B20/P02,według T07–T14 ROADMAP. Instancjacja samplera,
małych błędów i mostów do kodu ma pozostać jawnie odrębna od lematu warunkowego.

**2026-09-23 — P01 v2 REVIEWED; V01 PASS_SCOPED_REVIEW w wąskim zakresie.**
**Import,binding i pełne archive verify PASS:**36 checkpointów,51 dokumentów,
exit0,61.28s. Po początkowym timeout120s właściciel zatwierdził ponowienie
z limitem600s. Logi i oba przebiegi zachowane w
`work/B20_001/_coordination/PAIR01_IMPORT_001/` (wynik:global_verify_002).
Para wraz z objects,STATUS i dziennikiem jest objęta lokalnym checkpointem main.
REPORT `e7431aa06716e2960a86fd60bebea2ea213e770dd3f61b39a00292ac80ddd888`,
OUTPUTS `ebd4cff87995d34d318fa86512aef266a3c3c05f6147c81b8bac307cb2553386`.
Recenzent Muse Spark1.3 Free (`opencode/muse-spark-1.3-contributor-free`),
świeży kontekst wg HANDOFF. REVIEW
`2a0e18baecd18af09dc382872582b71044bfb69b1f1d79762f7d67091c0b2106`,
REVIEW_OUTPUTS `acd37b12408e9fa6f6ab3c2d01d022b3f6bbeae54a3933c27257ab9b72492441`.
[Autor w stages](../../proofs/ft1536/stages/B20_001_P01_FINAL_001/REPORT.md),
[pełny odbiór](../../proofs/ft1536/stages/B20_001_V01_FINAL_001/REVIEW.md).
Potwierdzono62/62 autora,30/30 review,12 wejść recenzji i powiązania21 źródeł,
12 raw logs,5 produktów/porównań z własnego replayu recenzenta6/6 exit0.
Sage niezależny22/22 według przypiętych logów. W opisie review liczba22 źródeł
jest erratą: rzeczywisty receipt zawiera21 zgodnych. Koordynator nie powtarzał obliczeń.

**Odebrane:** abstrakcyjne CExec i soundness,parser `return <decimal>;`,checker
√2 i transport,definicje kernel/TV/chi² oraz self-zero/resume po stanie.
**Otwarte:** bazowe abort,konwers/determinizm CExec,source refinement operatorów
i wydobycia fragmentu z pliku,warunkowanie po obserwacjach,nietrywialne TV/chi²,
maszyna/pełny front-end/real PRNG. `compile=id` nie daje dowodu kompilacji.
Katalog zachowuje autorski PROVED; wiążący zakres konsumpcji określa review_scope
w STATUS oraz V01/REVIEW_RESULT.json. P02 może przygotować wejścia z tych
odebranych eksportów i musi sformalizować potrzebne braki. Właściciel otrzymał
potwierdzenie możliwości startu P02; wybór/model i start należą do niego,
worker pracuje w W,P02 bez operacji Git.
[Dziennik](COORDINATOR_LOG.md) zachowuje pełną historię v1/v2 i importu pary.

**2026-09-23 — naprawa narzędzi koordynatora na polecenie właściciela.**
Frozen binding autora działa w W przed importem. REVIEWED wymaga przypiętego
odbioru właściwej pary i zgodnych stage'ów; negatywny werdykt zachowuje swój
status. Checkpoint zapisuje kompletną odebraną parę z objects,STATUS i dziennikiem
na main jako niirmataa. [Komendy](B20_COORDINATOR_TOOLS.md),
[dziennik](COORDINATOR_LOG.md). Testy28/28,archiwum34 checkpointów i51 dokumentów
PASS. Workflow pozostaje work → review → zaakceptowane stages → commit main.

**Najnowsze polecenie właściciela2026-09-22:** wypchnąć bieżący `main`;
właściciel zapowiedział start B20/P01. Zgoda padła po podaniu stanu `6060f34`
i pozostałych uwag S01/S06. Bieżący push jest jawnym wyjątkiem od wcześniejszej
blokady publikacji; nie zmienia werdyktów i nie upoważnia do kolejnych pushów.
P01: [TASK](../../proofs/ft1536/batches/B20_001/tasks/P01/TASK.md),
praca w `work/B20_001/P01`,potem review,zaakceptowane stages i commit main.

**Aktualizacja2026-09-22:** T01 niezależnie odebrany w `a2cdf317`;
następnie właściciel poprosił o zadanie korekt S01 przed publikacją.
Nowsza szybka kontrola FIX_001/E1:
[ustalenia](../../proofs/ft1536/validation/2026-09-22-fix001-e1-quickcheck/README.md).
S01:116/116 plików,rdzeń R1/R5 poprawiony i liczby potwierdzone; pozostaje
świeżość semantic/PDF w replayu oraz drobna sprzeczność radius/half-width.
Finalnego scoped PASS nie wydano. S06/E1:13 finite β i8 no-crossing do capu,
niezależny Sage/MPFI potwierdza tabelę; E2–E5 nadal w toku.
Po nim przygotowano na jego prośbę małe T02.1 dla kolejnego ręcznie wybranego modelu.
Najnowszy odbiór: **T02.1 RUN_003 REVIEWED / PASS_SCOPED_SUPPLEMENT** —
MiMo V2.6 Flash,świeży kontekst; piny/48 plików review i141 autora zgodne,
replay recenzenta17/17,525.24s. Szczegóły w sekcji T02.1 poniżej.
Wcześniejszy odbiór: **T03 REVIEWED — PARTIAL_PROOF**,na podstawie REVIEW_002
z PASS_SCOPED_REVIEW. Autor MiMo2.6Pro; recenzent Muse Spark1.3 xhigh w świeżym
kontekście według doprecyzowania właściciela.78 plików i3 finalne bindings
zgodne; replay recenzenta11/11,15s. Historia rozbieżności REVIEW_001 zachowana.
Nowszy zwrot: **S01 COMPLETE_FOR_REVIEW / FROZEN_AWAITING_REVIEW**,
osobny niezależny odbiór przygotowany. Właściciel potwierdził także częściowy
run estymatora S06/RUN_001 —70 zapisanych komórek NTRU,bez finalnego freeze.
**Aktualna decyzja wykonawcza:** właściciel polecił temu prowadzącemu
osobiście ocenić S01 i S06. Oba odbiory zakończono z **CHANGES_REQUIRED**,
recenzent GPT-6 Astra; S06 obejmuje częściowy snapshot,nie pełne120 komórek. Właściciel
przekazał REVIEW_002 T03 oraz końcowy odbiór suplementu T02.1.
To jawny wyjątek od wcześniejszego podziału ról,bez delegacji/relay.
Historyczne obserwacje procesów/dudect poniżej pochodzą z około04:33 CEST.
Stan procesów jest ulotny: sprawdź go ponownie przed pracą. Ten dokument
aktualizujemy po odbiorze etapu, zmianie wykonawcy lub decyzji właściciela.

Główna kolejka zadań i kryteria: [ROADMAP](ROADMAP.md).
Astra: **T01 REVIEWED**, pełny **T02 OPEN**, podzadanie **T02.1 REVIEWED_SCOPED**;
osobny MiMo = **T03 REVIEWED / PARTIAL_PROOF, B-gap OPEN**,
poprawki Family = **S01 CHANGES_REQUIRED**, dudect = **S02**,
estymator = **S06 CHANGES_REQUIRED / PARTIAL_DIAGNOSTIC**, oryginalny run w pauzie.

## Decyzje właściciela

- **B20_001 przygotowany:**20 następnych zadań według ROADMAP +20 sparowanych
  odbiorów,40 własnych W. [OWNER_GUIDE](../../proofs/ft1536/batches/B20_001/OWNER_GUIDE.md)
  i [INDEX](../../proofs/ft1536/batches/B20_001/INDEX.json) wybierają kolejne role.
  Właściciel wymaga **SageMath + Lean4 + Mathlib,kernelowo**,bez mixed-proof
  substytutu. [Pełny protokół](AGENT_EXECUTION_AND_REVIEW_PROTOCOL.md) opisuje
  wykonanie,weryfikację,receipty i freeze. **Ostateczne polecenie właściciela:
  dotychczasowy workflow — work → review → zaakceptowane stages → lokalny
  commit main jako niirmataa; bez nowych gałęzi/worktrees i obowiązkowych CP.**
  P01 zaczyna od formalnego/toolchain bootstrapu; pozostałe
  role czekają na konkretne proved exports/frozen pins. Odebrany handoff T02.1
  ma realne piny w żywym STATUS B20; P03 nadal potrzebuje P01/P02 i własnej
  kernelizacji. Właściciel zapowiedział start P01. [Wymagania](BATCH_20_REQUIREMENTS.md) zabezpieczają ciągłość po
  zmianie modelu/limitu. Aktualny manifest rewizji2:
  [PACKAGE.sha256](../../proofs/ft1536/batches/B20_001/PACKAGE.sha256).
- Nowy obowiązkowy standard rachunku: **pliki `.sage`, uruchomienie
  `sage lemma.sage` z preparserem SageMath**. Dotyczy nowych rachunków/checkerów
  i niezakończonych S01/T03/T02.1 przez
  [przypięte uzupełnienie](../../proofs/ft1536/documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md).
  `.py` organizuje procesy/manifesty/logi. Pierwotne TASK/bootstrap oraz stare
  wyniki pozostają niezmienne. Właściciel przekazuje zasadę obecnym wykonawcom;
  prowadzący nie uruchamia ich ponownie.
- Aktualny podział ról: prowadzący przygotowuje zadania i prompty do odbioru.
  **Weryfikację i replay zwrotów wykonuje inny niezależny model wskazany przez
  właściciela**. Nowe wyniki czekają na jego raport; ten prowadzący nie wykonuje
  ich odbioru automatycznie. Starsze opisane niżej odbiory są faktami historycznymi.
- T03/REVIEW_002: właściciel doprecyzował,że MiMo2.6Pro był autorem,a Muse
  Spark1.3 xhigh recenzentem w świeżym kontekście. Przyjęto niezależność od
  autora; nie przypisuje się zmiany modelu między dwiema recenzjami Muse.
- **Publikacja czegokolwiek na GitHub wstrzymana**, aż MiMo poprawi
  FT_FAMILY_SCALING i poprawiona wersja przejdzie pozytywny niezależny odbiór.
  Późniejszy push nadal wymaga osobnego polecenia. Aktualny dystans do origin
  odczytuj z Git; lokalny checkpoint nie oznacza publikacji.
- Jeden wykonawca danego W. Właściciel uruchamia/przekazuje zadania jawnie.
  Nie używaj `opencode run --session` jako sposobu wklejenia do otwartego czatu:
  uruchamia to oddzielnego wykonawcę.
- Etapy/logi/cache/skrypty wyłącznie pod kanonicznym repo; żadnego systemowego tmp.
- Dudect: **10h, rano przed wyjściem właściciela do pracy, po jego sygnale**.
  Brak automatycznego timera. Pomiar bez równoległej Astry/kompilacji/replayów.

## Najnowsze odebrane wyniki

| Etap / commit | Faktycznie odebrany zakres |
|---|---|
| SCALAR_GAUSSIAN `64af4cb` | IID_BUFFER, lokalnie TV(K,G)≤2^-36, chi2(K\|\|G)≤2^-60; reverse chi2 nieskończone |
| ORDERED_JOINT `22e6dd4` | Dokładne adaptacyjne3072 calls jednego root, closure/fresh-tail, TV≤2^-25, forward chi2<2^-48, zasoby |
| H6P_REFERENCE_BAD_EVENT `1ba7ae0` | Uniform joint BadPrecast OBU pre-narrow vectors: Q_S≤2^-119, one-root P_IID≤2^-84 |
| IID_RETRY_COMPOSITION / T01 `a2cdf317` | Niezależny PASS_SCOPED_REVIEW: one post-H2P cap16 region G_retry_IID, WholeRegionBad≤2^-80,coupling,wspólne resources,STATIC bytes |
| REFERENCE_INTEGER_RECOVERY / T03, REVIEW_002 | REVIEWED PARTIAL:A independent reference/mapping/congruence,C rounding-gap lemma,D conditional; B≈6086.4≥1/2 i pełny recovery OPEN |

H6P: niezależny replay **197/197**,73.819s;48 modułów Lean/327 twierdzeń,
26 nowych. Osobne QQ/RBF768 sprawdzenie rachunku. V<5462457,E<1095.
Dowód mieszany source/analytical/kernel; nie pełna kernelizacja kompilatora/C.
Sam H6P nie daje universal Safe16, real-PRNG bridge, retry composition, integer recovery
ani Sign→Verify. Pełne exact rationals są istotne dla końcowego wykładnika.

Raport i odbiór:
- [H6P REPORT](../../proofs/ft1536/stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md)
- [H6P validation](../../proofs/ft1536/validation/2026-09-22-h6p-reference-bad-event/README.md)

## T01 — REVIEWED po niezależnym odbiorze

`FT1536_IID_RETRY_COMPOSITION_RUN_001`, przygotowanie `c4e9d35`.

- W: `proofs/ft1536/work/FT1536_IID_RETRY_COMPOSITION_RUN_001/`.
- [TASK w repo](../../proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_IID_RETRY_COMPOSITION_2026-09-22.md).
- TASK SHA: `f773b8f31f7d307850ee3d1eb948bb05ceacee5589d5c4971e3eaee34c5bed97`.
- Bootstrap SHA: `daa95bc07516271ff897f95af11b3c90950ccb1a7dc20f0f3da5e994785a46b8`;
  1270 plików/1268 origins; BASE `1ba7ae07c17d135fc8eff4aac7b56f8c2b3bc88c`.
- Cel: od jednego legalnego post-H2P entry wyprowadzić re-entry/fresh-tail,
  actual16-attempt scheduler/norm/codec, WholeRegionBad, coupling i zasoby.
- Właściciel przekazał **PASS_SCOPED_REVIEW** od innego niezależnego modelu.
  Jego własny świeży replay:492/492,exit0,662.514s. Review A–F potwierdził
  post-H2P G_retry_IID cap16,WholeRegionBad<=2^-80,coupling,6352 blocks/
  26017792 bytes na wspólnym event H,tail<2^-1020 i exact STATIC<=3160.
  Formalizacja120 modułów/922 twierdzenia/26 nowych; mixed source/analytical/kernel.
- REPORT SHA `b7164dbbee02db248ea43adce1d63ae0a38ed4493a566c5acd3a2f507db14590`;
  OUTPUTS SHA `3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074`.
- [Archiwum niezależnego odbioru](../../proofs/ft1536/validation/2026-09-22-iid-retry-independent/README.md)
  zachowuje raport,oryginalny manifest12 plików,492 semantic results i pełne
  dostępne logi/receipts. REVIEW SHA
  `8523b1ea63faabdf2d78c602ccf1a5f7aaceba9c71ecc3ee6032c1add02344ec`;
  REVIEW_OUTPUTS SHA `5072eacae41c4eedf6184484385076a5447b538a2f646166e3dc5d872a7ca318`.
- Prowadzący wykonał import/pin-byte binding i Git; bez powtórnego własnego
  odbioru matematycznego/replayu. Dwa stale live INPUTS mają zgodne sealed kopie;
  failed routes/overlap i strict-tail convention zachowano. owner_accepted=false.
- Autor i recenzent zakończyli obliczenia. Nie wznawiaj ich W ani relay.
  T02 można teraz przygotować z odebranych zasobów; start wymaga nowego TASK/W
  i ręcznego polecenia. T03 odebrano w zakresie PARTIAL przez REVIEW_002.
- Granica: nie ma boundu Bad|success bez success denominatoru. Real PRNG,H2P,
  whole real Sign,integer recovery,Sign→Verify/security/CT pozostają otwarte.

## T03 — REVIEWED / PARTIAL_PROOF po REVIEW_002

`FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001`,one-root,autor MiMo2.6Pro.
[CURRENT_MIMO_TASK](../../proofs/ft1536/CURRENT_MIMO_TASK.md) wiąże pierwotne
TASK/bootstrap i [nowy REVIEW_002](../../proofs/ft1536/CURRENT_REVIEW_TASK.md).
Właściciel przekazał REVIEW_002 i doprecyzował role:MiMo2.6Pro autor,
Muse Spark1.3 xhigh recenzent w świeżym kontekście. Raport zachowuje własną
etykietę Free i przyznanie braku zmiany modelu względem REVIEW_001; podstawą
odbioru jest późniejsze doprecyzowanie właściciela i zgodny nowy binding.

- REPORT SHA `e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c`;
  OUTPUTS SHA `0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de`.
- **Odebrany scoped PASS:** A niezależna integralna reference i mapping3072/
  congruence; C rounding-gap lemma; D conditional consumer. B≈6086.4008 nie
  osiąga `<1/2`; Safe16/center/norm/bytes i pełny recovery pozostają otwarte.
- [Archiwum REVIEW_002](../../proofs/ft1536/validation/2026-09-22-integer-recovery-review-002/README.md):
 78 członków review,bundle1429+manifest,11 wyników i dostępne raw logs.
 Finalne3 Sage source/receipt/output hashes zgodne; własny replay recenzenta
 11/11,exit0,15s. Prowadzący wykonał archiwalne kontrole integralności,
 bez nowego własnego review matematycznego/replayu T03.
- REVIEW SHA `2df1b7fa36921d14ea84e41c35e8a60707e044bd6d19688c41e4d79ea172b75f`;
 REVIEW_OUTPUTS SHA `9ea0274b78bfd5c0123a9502644ce081e3cc11dc9b59843c40597a6f5e76ef04`.
- [Historia REVIEW_001](../../proofs/ft1536/validation/2026-09-22-integer-recovery-independent/README.md)
 zachowuje rozbieżność3 hashy. Nowy werdykt nie opiera się na tamtych receiptach.
 Uwagi do kompletności historii failed-source/stderr oraz deklaracji kontekstu
 zachowano w nowym archiwum,bez dopisywania brakujących danych.
- Recenzent rozliczył v3→v4/5 plików,wiersze Z versus cały JSON i fixture counts
  (20110 różnych słów/60384 wykonania). Niewygodne wyniki/uwagi zachowane.
  B-gap fix jest następnym proponowanym tranche; niczego nowego nie uruchomiono.

## T02.1 — REVIEWED / PASS_SCOPED_SUPPLEMENT

[RUN_003 w stages](../../proofs/ft1536/stages/FT1536_PRNG_LAYOUT_COUNTER_RUN_003/REPORT.md)
oraz [archiwum odbioru](../../proofs/ft1536/validation/2026-09-22-prng-layout-supplement/README.md).
Recenzent MiMo V2.6 Flash w świeżym kontekście potwierdził F1–F5 po RUN_002.
Autor141/141 i61 inputs; review48/48 i46 inputs. Własny replay recenzenta17/17,
exit0,525.24s; checker Sage13/13. Prowadzący sprawdził piny,17 trójstronnych
matches i2 Sage source/receipt/log bindings,bez ponownego proofu/replayu.

REPORT `3b7c2b3bbc7f0b72b3a25d3f2cb32623294f1135acb61d8c65b905eefe1a6168`;
OUTPUTS `e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc`;
REVIEW `31a7353d052bb36e422672de7e60e429932fe10a5733a9906a3de95f5b61f24b`;
REVIEW_OUTPUTS `344520eeee07b089a8a611942fec2646fdbd27665121ee37cda41e11485e4f30`.

Odebrany zakres historyczny: init/layout/counter/resource model,Lean28 dla
arytmetyki,Sage/C controls; 396/25408/406528/896/936 i maxima61320/4088.
**kernel_complete=false,B20_P03_formalization_required=true.** Rundy ChaCha,
frame source refinement i uniwersalność pętli wymagają pełnej formalizacji.
T02 parent/real PRNG→IID/security nadal OPEN. B20/P03 ma dostępny zewnętrzny
handoff w STATUS,ale pozostaje zależny od odebranych P01/P02.
Historie RUN_001/RUN_002 i review210 plików zachowane; resztki R1–R3 i opis
failed attempts pozostają jawne. Zakończonych workerów nie wznawiaj.

### Incydent dwóch wykonawców

CLI z PATH to OpenCode2.0.12, podczas gdy okna właściciela używały
`/home/footfalcon/.opencode/bin/opencode`1.18.31. Kopie sesji miały takie same
ID i nazwy w odrębnych magazynach. Pierwsza wysyłka trafiła do2.x i przerwała
się na permission. Następne `run --session` w1.18.31 uruchomiło model w tle;
po wznowieniu okna właściciela wystąpiły nakładające się wykonania tego samego W.

Własny background PID593062 zatrzymano SIGINT; przy snapshotcie pozostało
okno Astry PID596312. Numery PID nie są trwałą identyfikacją. **Przekaźnik
`FT1536_SESSION_RELAY_2026-09-22/relay.py` jest zablokowany**, również callback.
Nie odblokowuj go automatycznie. Handoff przez plik i istniejącą sesję właściciela.
Pełna kontrola świeżego replayu po zakończeniu ma szczególne znaczenie po overlap.

Sesja Astry: `ses_f4f1aa5e4ffed4MiXn4d8dtwEj`, „Audyt wznowienia FT1536 i zakres
T01 oraz T03”. Prowadzący: `ses_f4f4e545cffeG2sZ5xvZEyTbi5`, „Przegląd i scalenie
historii Falcon FT1536 readonly”. **ID samo nie wystarcza do ustalenia instancji.**
Historia osiągnęła około900k tokenów/krok; nowe etapy zaleca się rozpoczynać
w świeżym małym kontekście po kontrolowanym przekazaniu, bez drugiego workera.

## MiMo — materiał zachowany, poprawki wymagane

`FT_FAMILY_SCALING_REVIEW_RUN_001`, commit `0c1ddc1`, status
**RESEARCH_REVIEW_CHANGES_REQUIRED**. Autorzy: projekt Niirmata, opracowanie MiMo.
Sprawdzone4 moduły Lean/14 nazwanych twierdzeń,5 JSON/CSV i12 FFT-port cases.
[Recenzja R1–R7](../../proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md):
kierunek redukcji; definicja losowych celów ROM i zależność prób; brak F przy
trapdoor completion; homogeneous SIS w szkielecie P2; idealna hipoteza chi-square;
spójność statusu proposed FFT bound; lokalna tabela high-water16384 zamiast15360.
Nie zastępuj poprawkami zamrożonych bajtów. Nowa wersja wymaga osobnego odbioru.
Nie ma w tym snapshotcie pozytywnego odbioru poprawek. Nie uruchamiaj MiMo sam.

Aktualizacja przygotowania2026-09-22: właściciel wybrał dla MiMo NOWY obowiązek
głównego toru, odrębny od korekt Family. [CURRENT_MIMO_TASK](../../proofs/ft1536/CURRENT_MIMO_TASK.md)
wskazuje **T03 / one-root REFERENCE_INTEGER_RECOVERY**. Przygotowane wcześniej
W zwrócono jako PARTIAL_PROOF; REVIEW_002 przekazano i odebrano po
doprecyzowaniu ról MiMo/świeży kontekst Muse. Dokładny zakres opisano wyżej.
S01 i blokada publikacji pozostają
otwarte. Nieuruchomiony szkic CORRECTIONS_RUN_002 zachowano lokalnie jako anulowany.

**Zwrot S01 CORRECTIONS_RUN_003:** właściciel przekazał
FT_FAMILY_CORRECTIONS_COMPLETE_FOR_REVIEW. [CURRENT_FAMILY_TASK](../../proofs/ft1536/CURRENT_FAMILY_TASK.md)
wiąże TASK/bootstrap i [osobny prompt odbioru](../../proofs/ft1536/CURRENT_FAMILY_REVIEW_TASK.md).
Właściciel wskazał później tego prowadzącego jako recenzenta. W:
`proofs/ft1536/work/FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001`.

**Późniejszy własny odbiór na polecenie właściciela:** GPT-6 Astra zakończył
review z CHANGES_REQUIRED. [Raport i archiwum](../../proofs/ft1536/validation/2026-09-22-family-corrections-independent/README.md),
[minimalne poprawki](../../proofs/ft1536/stages/FT_FAMILY_CORRECTIONS_REVIEW_RUN_001/REQUIRED_CORRECTIONS.md).
I1:R1 typ oracles/nierówności Adv i zakres N3; I2:R5 claim≈1e-305 nie wynika
z autorskiego Arb256 (≈1.06e-82,written endpoints width1e-50). Core tail
2^-40<tail<2^-28 poprawny. Własny replay18/18,16/16 exit0,354.775s i PDF9 stron
potwierdzone; raw controller exit1 jawnie rozlicza tylko transportowe pole
source_header FFT JSON. Dwa udane własne `.sage`,13 R4 mocks,4/14 Lean.
REVIEW SHA `6cb263741571922d9326decb7f22cc2713532658cee69bd9a46354423a415dc4`;
REVIEW_OUTPUTS SHA `7ad83392a6c31762b791517935ccb5f6d042b8f0eac90970f1e7e02f031d1982`.
Joby zakończone,publikacyjna bramka korekt niespełniona. S06 nie był wykonany
ani oceniony tym review. Własne failed attempts recenzenta zachowane.

- REPORT SHA `7d2f17cc51126b6dbb03279d7c876c460aa9f48bb581f63b9f512f87adee485d`;
  OUTPUTS SHA `9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e`.
- Na etapie przygotowania prowadzący sprawdził100 outputs,197 bootstrap
  members,source17 i zapisany postfreeze autora. Właściwy własny odbiór
  wykonano następnie na nowe polecenie właściciela i opisano powyżej.
- Read-only bundle323 plików,7.6MB; [origins/przygotowanie](../../proofs/ft1536/background/FAMILY_CORRECTIONS_REVIEW_2026-09-22/README.md).
  Plan odbioru obejmował R1–R7,wycofanie R4,ujemny R5,proposed R6,tabelę/PDF,
  stale-result guard,semantic-only steps,stary hash lemma_controls i sealed .pyc.
- Author COMPLETE nie znosi bramki publikacji. Wymagany pozytywny niezależny
  scoped review,a później osobne polecenie push. T03 REVIEW_002 ma odrębne W.

## S06 — niezależny odbiór częściowego runu: CHANGES_REQUIRED

[Pełny odbiór i piny](../../proofs/ft1536/validation/2026-09-22-family-estimator-independent/README.md)
wykonał GPT-6 Astra po S01,na to samo bezpośrednie polecenie właściciela.
Pięć natywnych `.sage`:12 model rows/pola,21 exact moments +mean checks,
132 cost values+12 error rows,3 wybrane NTRU usvp samples i kontrtest agregatora.
Wymagane E1:subfield n=N/2 (kod używaN),E2:rop/log2 i grouping modeli,
E3:MATZOV/EMPTY/inf/repair accounting,E4:weakest-link i multi-target convention.
Joby zakończone,oryginalnej kampanii nie wznowiono. Nie jest to pełny replay70/120.
REVIEW SHA `49fabdfaff749a54a651b9d11e8d56dbc118762fcfe25fdb3c3d32a95c327fdf`;
REVIEW_OUTPUTS SHA `f1605f5f4d1418248dff5725559c310b973bd90dcf775380b84e83f860de73df`.

W: `proofs/ft1536/work/FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001`.
STATUS=`DIAGNOSTIC_NOT_CANDIDATE_READY`; RESUME_STATE opisuje pauzę i wznowienie
na polecenie właściciela. Odczyt2026-09-22: ntru_grid.ndjson ma71 rekordów,
z czego1 metadata +70 zapisanych komórek: FT76824,FT153624,FT307222.
Docelowa siatka120 obejmuje także kotwice Falcon; brak finalnego report.md
i OUTPUTS.sha256. To rzeczywiste zapisane oszacowania,jeszcze nie odebrany freeze.
Snapshot hash siatki: `3f766b1a4f46080f99422f2f7f7c8c270708bc949e25ed01f9a482df95bab4d3`.

S01 estimator_campaign_executed_in_this_task=false nie przeczy temu osobnemu
runowi. Wyniki mają zakres model-dependent/diagnostic; aktualny SCOPE wymienia
otwarte modeling/population/lift obligations. Pełne domknięcie kampanii wymaga
napraw z odbioru oraz handoffu z pinami i kompletnymi wynikami. Komendy env-python z
RESUME_STATE nie traktuj jako nowego polecenia startu; nowe rachunki stosują
obowiązujący tryb Sage. Prowadzący nie wznawiał ani nie zatrzymywał kampanii.

## Build i dudect

Extra/c: aktywny kandydat L_RHO+FLOOR_CT, manifest17 plików
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
FLOOR_CT zintegrowany w `fe6f92a`; fpr_floor zachowuje floor(-0)=-1.
F01 numeric fpr_lt(-0,+0)=1 nie jest ogólnie naprawione.

RUN_002: **COMPLETED_SCHEDULE**,2026-09-23 07:53:08→17:52:50 CEST;
usługa ft1536-dudect-run-002.service inactive,MainPID0,inhibitor zwolniony.
Budżet36000s,CPU11,attempt006,PREPARATION SHA
`2621ed0121f981c1149236de98a00261e3b55cb651f55fec7dfe7d6e9ccff74c`.
Magazyn NVMe UUID da38b9e9… zgodny,AC online; wolne235815215104 bajty,
wymagane93751083008. Kontrole positive/negative/3 floor/timebox i raw replay
PASS; brak aktywnych Lean/Sage/C/estymatora przy preflighcie.
[Instrukcja magazynu/startu](../../provenance/FT1536_DATA_STORAGE.md).
Właściciel wydał znak „odpalaj dudect komp czysty”; start potwierdzony w RUN/LAUNCH.
36/36 prób produkcyjnych NO_LEAKAGE_EVIDENCE_YET;6 kontroli zgodnych.
Nie wznawiaj zakończonej kampanii. Dalsze proof jobs mogą być przydzielone przez właściciela.

## Co aktualizować po zmianie stanu

Po odebraniu retry zaktualizuj powyższą sekcję, CURRENT_TASK i indeks dowodów.
Po poprawkach MiMo zapisz dokładny wynik odbioru, a nie samo „model skończył”.
Po uruchomieniu dudect podaj faktyczny RUN/start/deadline, nie planowaną godzinę.
Nowy model ma odróżnić snapshot od stanu procesów na żywo.
