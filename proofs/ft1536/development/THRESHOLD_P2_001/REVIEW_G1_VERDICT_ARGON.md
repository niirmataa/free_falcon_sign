# RAPORT NIEZALEŻNEGO ODBIORU BRAMKI G1 — THRESHOLD_P2_001

* **Tor:** `proofs/ft1536/development/THRESHOLD_P2_001`
* **Zakres:** Bramka G1 (pakiety WP-010 .. WP-027)
* **HEAD objęty audytem:** `5883b19ea812639121fda2a77df6398662b0c5ab`
* **Recenzent niezależny:** Gemini 4 Argon (Google AI Studio, wyznaczony przez Właściciela; Autor ≠ Recenzent, Prawda przed tempem)
* **Data odbioru:** 2026-10-27
* **Werdykt odbioru:** `PASS_SCOPED_REVIEW` (Zatwierdzenie G1 z jawnym przeniesieniem punktów granicznych do G2/G3)

---

## 1. Werdykt i uzasadnienie

Implementacja fundamentu G1 (`ft-threshold-core`, `ft-threshold-protocol`) jest rzetelna, czysta architektonicznie i uczciwie udokumentowana:

1. W całym workspace egzekwowane jest `#![forbid(unsafe_code)]`, brak zależności od `ftkey-vm` / `QSX` (decyzja D-023), brak niedeterministycznych kolekcji (`HashMap`/`HashSet` zastąpione tablicami stałorozmiarowymi i oknem bitowym) oraz brak wywołań zegara systemowego.
2. Wszystkie 10 błędów odziedziczonych ze spike’a (#2, #3, #6, #7, #8, #9, #10, #11, #13, #14), które miały zostać wyeliminowane na poziomie G1, zostało faktycznie usuniętych z kodu i pokrytych testami regresji (w tym testami `compile_fail`).
3. Dokumenty `GATES.md`, `WORK_PACKAGES.md`, `CLAIMS_REGISTER.md` i `SOURCE_MAP.md` nie naciągają statusu: otwarte granice między G1 a G2/G3 (WP-017 PARTIAL dla `mlock`/`prctl`, odroczenie `decode_sk` w WP-022 do WP-040/041 oraz zakres `repro_build.sh` w WP-026) zostały nazwane po imieniu zamiast ukrycia ich pod pozornym DONE.

---

## 2. Niezależne powtórzenie i weryfikacja artefaktów

W ramach audytu niezależnie uruchomiono skrypty referencyjne i przeliczono artefakty z repozytorium:

* **7 skryptów referencyjnych KAT (`impl/ci/kat/*.py`):**
  Niezależnie uruchomiono: `gf256_reference.py`, `ntt_reference.py`, `ring_reference.py`, `shamir_zq_reference.py`, `zp_reference.py`, `prss_reference.py`, `hash_to_point_reference.py` — wszystkie wykonują się czysto i generują dokładnie te wektory, które są zaszyte w testach jednostkowych Rust.
* **Kanoniczny CBOR v1 (WP-027):**
  Niezależnie uruchomiono `impl/ci/wire/cbor_reference.py` i porównano z `impl/wire/vectors/envelope_v1.txt` — 0 różnic (`diff = 0`).
* **Deterministyczny korpus fuzzera (WP-022):**
  Niezależnie uruchomiono `impl/ci/fuzz/gen_corpus.py` do osobnego katalogu i porównano binarnie wszystkie 44 pliki z `impl/fuzz/corpus/wire/` (`00_valid_minimal.bin` .. `29_mut_19.bin`) — 44/44 plików bitowo identycznych.
* **Wektory KAT z silnika C (WP-024, `KAT/falcon_ternary_logn10_v1.txt` + `KAT/MANIFEST.txt`):**
  Zweryfikowano skrót SHAKE256 pliku wektorów względem `KAT/MANIFEST.txt`: `b0cbc57aced8e05b1a22ffb4270f893ef8b938572738cfce9c69522f9bb57862` — zgodny.
  Potwierdzono brak surowych bajtów klucza prywatnego w repozytorium (`skey` nie występuje; przypięty wyłącznie `skey_shake256`).
  Zweryfikowano rozmiary i nagłówki: `pkey = 2881 B` (nagłówek `0x8a = 0x0a | 0x80` dla `logn=10`, ternary), `sig = 2363 B` (nagłówek `0xa8 = 0x80 | (1<<5) | 10`, nonce 40 B `cbd46747...`).
  Niezależnie przeliczono `SHAKE256(nonce || msg)` z odrzucaniem w `< 61440` ($3 \times 18433 = 55299 < 61440$) i porównano z zapisanym wektorem `c0` — 1536/1536 współczynników identycznych.
* **SBOM v1 (WP-026, `impl/sbom/sbom_v1.txt`):**
  Niezależnie sparsowano `impl/Cargo.lock` i wygenerowano tabelę `<name> <version> <source> <checksum>` — 32/32 pakiety identyczne bit-po-bicie z `impl/sbom/sbom_v1.txt`.

---

## 3. Przegląd pakiet po pakiecie (WP-010 .. WP-027)

| Pakiet | Commit | Zakres i dowód w kodzie | Ocena recenzenta |
|---|---|---|---|
| WP-010 / WP-011 | `6fb91616` .. `10277ba7` | Hermetyczny workspace bez ftkey-vm/QSX (D-023), forbid(unsafe_code), clippy -D warnings, cargo deny, miri. | **PASS** |
| WP-012 | `7ef9db27` .. `6c9e5bc1` | gf256, shamir_zq, ring ($\mathbb{Z}_q[X]/(\Phi_{1536})$), ntt (1536-punktowe 3-adic + cyklotomiczne z czynnikami skrętu), shake, prss, zp (2048-bitowy RFC 3526 Group 14). | **PASS** |
| WP-013 (#9) | `06c34d68` | mac.rs: usunięto jawne delta_known; klucz MAC pozostaje podzielony; kowariancyjny fałszerz daje Err(CoreError::MacFail). | **PASS** |
| WP-014 (#3) | `ffa8cb14` | state.rs: typestate PartyState<Unvalidated> → Validated → SignTicket (pola prywatne); 2 doctesty compile_fail blokujące podpis bez walidacji VSS + NtruEvidence. | **PASS** |
| WP-015 (#6) | `a9a70917` | beaver.rs: dwufazowy commit-then-open (FT1536_BEAVER_COMMIT_V1, losowy nonce 32 B) przed otwarciem; manipulacja po zobaczeniu cudzego otwarcia odrzucana (BeaverCommitMismatch). | **PASS** |
| WP-016 (#7) | `6c9e5bc1` | zp.rs: check_poly_share_full weryfikuje wszystkie współczynniki wielomianu (brak próbkowania). Pojedyncze przekłamanie na indeksie 777 niezawodnie wykrywane. | **PASS** |
| WP-017 (#11) | `e86f6062` | ZeroizeOnDrop na typach sekretnych, brak Clone (4 doctesty compile_fail), zamaskowany Debug (<redacted>). mlock/madvise/prctl jawnie odroczone do binarium node w WP-045 (G2). | **PASS_SCOPED** (PARTIAL) |
| WP-018 (#8) | `fcd44406` | bit.rs: brak BitShare::Public; prywatne pole u8 (0/1); xor_public wyłącznie z jawnym identyfikatorem strony (tylko party == 1 XOR-uje stałą publiczną). | **PASS** |
| WP-019 (#13) | `83aa4e69`, `86fa5d97` | codec.rs: sztywne rozmiary (Poly 3072 B, ExpShare 256 B, VssCommitments 786 432 B), odrzucenie wartości $\ge q$ oraz elementu $0$; test $10^6$ losowych wejść bez paniki. | **PASS** |
| WP-020 (#14) | `cc2d0740` | envelope.rs: Envelope + Body, tag MAC sprawdzany przed stanem sesji; 64-slotowe okno ReplayWindow. | **PASS** (z uwagami wdrożonymi na wejściu w G2) |
| WP-021 (#10) | `540b53ca` | sampler.rs + shake.rs: RejectionSampler zwraca Err(CoreError::AttemptsExhausted) po wyczerpaniu budżetu; uniform_below używa progu 61440 (brak obciążenia modulo); hash_to_point cap 1 MiB. | **PASS** |
| WP-022 | `46811e0b` | Deterministyczny fuzzer w fuzz_wire.rs i fuzz.rs (~340 000 mutacji + 44-plikowy korpus) sprawdzający niezmiennik punktu stałego decode(b) == Ok(x) => encode(x) == b. | **PASS_SCOPED** (decode_sk w WP-040/041) |
| WP-023 | `8f6f7808` | impl/ci/engine_diff/: $4 \times 10^4$ losowych przypadków (hash_to_point, ntt, intt, poly_mul) porównanych z Extra/c/falcon-vrfy.c + falcon-enc.c (0 rozbieżności). | **PASS** |
| WP-024 | `f0ce854f` | KAT/falcon_ternary_logn10_v1.txt + KAT/MANIFEST.txt: prawdziwy klucz publiczny i podpis z silnika C zweryfikowane przez C oraz w Ruście. | **PASS** |
| WP-025 (#2) | `14f52770` | Feature test-oracle domyślnie wyłączony w Cargo.toml; ci/check_prod_symbols.sh weryfikuje przez nm -A, że artefakty --release mają 0 zakazanych symboli. | **PASS** |
| WP-026 | `5883b19e` | ci/repro_build.sh: dwa przebiegi cargo build --release --workspace --frozen dają 35/35 bitowo identycznych plików .rlib + sbom/sbom_v1.txt z Cargo.lock. | **PASS_SCOPED** |
| WP-027 | `1e9f61ec` | cbor.rs + wire/schema/envelope.cddl (FROZEN): ręczny koder/dekoder kanonicznego CBOR (RFC 8949 §4.2), odrzucający 10/10 niekanonicznych form. | **PASS** |

---

## 4. Jawne granice zakresu G1 → G2/G3

* **WP-017 (PARTIAL → dokończenie w WP-045 w G2):** `mlock`, `madvise(MADV_DONTDUMP)` oraz `prctl(PR_SET_DUMPABLE, 0)` odroczone do binarium węzła w WP-045, ze względu na `#![forbid(unsafe_code)]` w bibliotekach.
* **WP-022 (decode_sk → WP-040/041 w G3):** Wariant B′ nie składa klucza prywatnego w jednym miejscu. Parser klucza prywatnego Rusta pojawi się z portem samplera.
* **WP-026 (powtarzalność per-checkout → kontener w G4/G5):** Identyczność 35/35 plików `.rlib` wykazana na poziomie hosta; pełna powtarzalność między różnymi hostami (--remap-path-prefix) jest celem przedprodukcyjnym.

---

## 5. Wykryte kwestie techniczne (zaadresowane przed G2)

1. **Interakcja round i seq w `SessionReceiver::accept`:**
   Naprawiono w `envelope.rs`: dodano `PeerState::accept` ze ścisłym powiązaniem monotoniczności `(seq, round)` i obsługą duplikatów ze starszych rund bez fałszywego `RoundMismatch`.
2. **Obsługa tablic CBOR (major type 4) w `cbor.rs`:**
   Wdrożono kanoniczny `put_array` i `expect_array` z limitem `MAX_ARRAY_LEN = 4096` i odrzucaniem form niekanonicznych pod `payloads_v0.cddl`.
3. **Generator mutacji w `fuzz.rs`:**
   Wyrównano alokację wektora i pętlę losowania oraz dodano `#![forbid(unsafe_code)]`.
