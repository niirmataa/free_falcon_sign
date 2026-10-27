# PAKIET ODBIORU G1 — THRESHOLD_P2_001

**Wersja:** 1 (2026-10-27) · **Autor pakietu:** niirmataa (okno S09/THRESHOLD_P2_001)
**Recenzent:** do wyznaczenia przez właściciela (**autor ≠ recenzent**)
**Status pakietu:** PRZYGOTOWANY DO NIEZALEŻNEGO ODBIORU.

To są **materiały odbioru, nie werdykt**. Autor nie wystawia sobie PASS;
każde twierdzenie ma komendę lub pin do niezależnej weryfikacji.

---

## 1. Zasady odbioru

1. Recenzent powtarza materiał z §2; przy rozjeździe najpierw pełne
   powtórzenie komendy, potem zgłoszenie (możliwa różnica środowiska).
2. Werdykt w jednym z formatów:
   - `PASS_SCOPED_REVIEW` — plus jawny zakres twierdzeń po odbiorze;
   - `CHANGES_REQUIRED` — plus numerowana lista (plik → problem → oczekiwanie);
   - `BLOCKED` — plus powód i lista braków materiałowych.
3. Recenzent ocenia **scope twierdzeń**, nie tylko wyniki: czy coś nie
   jest udowodnione szerzej niż dowód (patrz §5, granice).
4. Nic w tym pakiecie nie jest twierdzeniem bezpieczeństwa protokołu;
   G1 to bramka fundamentu implementacyjnego, nie G3/G4.

## 2. Jak powtórzyć całość (jedna komenda)

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
./ci/check.sh          # ~10,5 min, wymaga nightly (miri), offline
```

Oczekiwane sekcje i wyniki:

| Sekcja | Oczekiwany wynik |
|---|---|
| fmt / build / clippy (default + all-features) | PASS, zero ostrzeżeń (`-D warnings`) |
| test (default) | **158 PASS** = core 124 (lib 114 + integracyjne 10: `kat_pins` 3, `fuzz` 5, `malformed` 2) + protocol 29 (lib 22 + integracyjne 7: `fuzz_wire` 3, `wire_vectors` 4) + doctesty 5 |
| test (all-features) | **162 PASS** (+4 testy oracle w protocol) |
| skan PROD (WP-025) | 0 symboli oracle w buildzie domyślnym; kontrola negatywna: 2 symbole z `--features test-oracle`; artefakt PROD czysty |
| korpus fuzz (WP-022) | 44/44 pliki bitowo identyczne z regeneracją |
| repro build + SBOM (WP-026) | 35/35 `.rlib` bitowo identycznych; SBOM zgodny z pinem |
| cargo deny (offline) | advisories/bans/licenses/sources: ok |
| miri | core **100 passed / 14 ignored**; protocol **15 passed / 7 ignored**; ciężkie pętle ignorowane z jawnym powodem |

Skrypty pojedyncze (każdy ma tryb `--update` tylko dla świadomych zmian):

| Skrypt | Co weryfikuje |
|---|---|
| `ci/kat/run_falcon_kat.sh` | KAT z realnego silnika: regeneracja bajtowa + 13 pinów `Extra/c` |
| `ci/wire/run_wire_vectors.sh` | wektor wire v1 z niezależnej referencji Python (bajtowo) |
| `ci/fuzz/run_fuzz_corpus.sh` | korpus fuzz 44 pliki (bajtowo) |
| `ci/repro_build.sh` | podwójny build `--frozen` + SBOM vs pin |
| `ci/check_prod_symbols.sh` | PROD bez ścieżki TEST-ORACLE (źródła + `nm`) |

## 3. Co G1 twierdzi — mapowanie na rejestr twierdzeń

| Claim | Treść (scope) | Status w `CLAIMS_REGISTER.md` | Dowód G1 |
|---|---|---|---|
| C-109 | Build reprodukowalny **per-checkout** i pinowany (locked, toolchain, SBOM) | `TESTED` (scope G1; między hostami → G5) | `impl/ci/WP026_CHECK_2026-10-27.txt` |
| C-110 (część) | Prymitywy (`hash_to_point`, NTT/iNTT, `mul`) są byte-equal z silnikiem; pk/sig/c0 przypięte jako kotwice | `OPEN` (całość: G3 KAT); prymitywy: WP-023 | `impl/ci/WP023_CHECK_2026-10-26.txt`, `impl/ci/WP024_CHECK_2026-10-26.txt` |
| — | Fundament hardened: fail-closed, limity, replay/rollback, maski, MAC ukrytego δ, bitność, wire v1 ścisły | `TESTED` w scope G1 | tabela w §4 |
| — | Build PROD nie zawiera ścieżki TEST-ORACLE ani QSX/VM | `TESTED` (mechanicznie, WP-025 + check.sh D-023) | `impl/ci/WP025_CHECK_2026-10-26.txt` |

## 4. Indeks pakietów roboczych i dowodów

| WP | Zakres | Status | Dowód (`impl/ci/…`) | Kluczowe wyniki/piny |
|---|---|---|---|---|
| WP-010/011 | workspace, hermetyczne CI, deny, miri | DONE | `WP010/WP011_CHECK_2026-10-26.txt` | offline, `--locked`, QSX/VM grep |
| WP-012 | prymitywy: GF(256), Shamir Z_q, R_q, SHAKE, HTP, NTT, PRSS, VSS | DONE | `WP012_CHECK_2026-10-26.txt` + `ci/kat/*_reference.py` | niezależne KAT-y Python |
| WP-013 | `Z_P` (2⁶¹−1) + MAC ukrytego δ | DONE | `WP013_CHECK_2026-10-26.txt` | brak `delta_known` w API |
| WP-014 | typestate DKG/NTRU; `PROD` odrzuca jawny evidence | DONE | `WP014_CHECK_2026-10-26.txt` | `compile_fail` pilnują typów |
| WP-015 | maski otwarć w `Z_P` | DONE | `WP015_CHECK_2026-10-26.txt` | brak Clone, bias ≤ 2⁻⁶⁷ |
| WP-016 | pełne VSS + agregacja S5 | DONE | `WP016_CHECK_2026-10-26.txt` | bound 2²⁴⁴ < L; seed `Zeroizing` |
| WP-017 | zeroizacja po stronie typów | **PARTIAL** (mlock/no-dump → node G2/WP-045) | `WP017_CHECK_2026-10-26.txt` | jawny deferral w GATES |
| WP-018 | bitność i spójność udziałów bitu | DONE | `WP018_CHECK_2026-10-26.txt` | gf≠zp → `InconsistentShare` |
| WP-019 | `TryFrom`/limity + 10⁶ wejść bez paniki | DONE | `WP019_CHECK_2026-10-26.txt` | 0 panik (~23 s) |
| WP-020 | koperty, licznik rund, replay-window | DONE | `WP020_CHECK_2026-10-26.txt` | tamper/rollback/replay → `Err` |
| WP-021 | fail-closed sampler (`AttemptsExhausted`) | DONE | `WP021_CHECK_2026-10-26.txt` | bez modulo bias |
| WP-022 | fuzz wire/codec/htp + korpus w repo | DONE | `WP022_CHECK_2026-10-27.txt` | ~340 tys. mutacji, fixpoint 100% |
| WP-023 | differential Rust vs realny silnik | DONE | `WP023_CHECK_2026-10-26.txt` | 4×10⁴ przypadków, 0 rozjazdów; `engine_diff/PIN_2026-10-26.txt` |
| WP-024 | KAT-piny z silnika (seed/nonce/msg → pk/sig/c0) | DONE | `WP024_CHECK_2026-10-26.txt` | `KAT/MANIFEST.txt` (13 pinów silnika); `skey` tylko jako hash |
| WP-025 | build PROD bez ścieżek zakazanych | DONE | `WP025_CHECK_2026-10-26.txt` | `nm`: 0 symboli oracle; negatywna kontrola: 2 |
| WP-026 | odtwarzalny build + SBOM | DONE | `WP026_CHECK_2026-10-27.txt` | 35/35 rlib identycznych; SBOM z locka przypięty |
| WP-027 | wire v1: kanoniczny CBOR + CDDL + wektory | DONE | `WP027_CHECK_2026-10-26.txt` | 10/10 non-canonical odrzucone; niezależna referencja Python |

Formaty/piny zamrożone: `wire/schema/envelope.cddl` (FROZEN v1),
`wire/schema/payloads_v0.cddl` (pola v0; `SIGN_OPEN` DRAFT → WP-041),
`wire/vectors/envelope_v1.txt`, `fuzz/corpus/wire/` (44), `sbom/sbom_v1.txt`,
`KAT/falcon_ternary_logn10_v1.txt`.

## 5. Granice jawne (co ten materiał NIE dowodzi)

1. **Poprawność silnika** jest poza P2 (silnik przypięty hashami w
   `KAT/MANIFEST.txt` i `engine_diff/PIN_2026-10-26.txt`; jego status
   prowadzi T12.1/Gates A5). KAT-y i differentiale dowodzą zgodności
   Rust↔silnik, nie poprawności obu.
2. **Bezpieczeństwo protokołu** (C-101…C-108) — OPEN; G1 nie zbliża się
   do malicious-secure ani side-channel (F-03/F-05/F-08 obowiązują).
3. **PROD jest mechanicznie martwy**: bez O-05 (MPC NTRU) build PROD nie
   ma ścieżki do `SignSession` (`ProdEvidenceMissing` + wycięty oracle).
4. **Odtwarzalność między hostami** — poza G1 (per-checkout zweryfikowane;
   remap-path-prefix i stabilny cache rejestru — G5).
5. **Fuzz deterministyczny, nie coverage-guided** (libFuzzer niedostępny
   offline); `decode_sk` odroczony do portu sign/verify (WP-040/041).
6. **Kodery payloadów 0x01–0x24** — lądują z ruchami G2 (WP-030+);
   zamrożone są zbiory pól i warstwa koperty.
7. **WP-017 PARTIAL**: `mlock`/no-dump → node G2/WP-045.
8. **TLS exporter (O-09)**: `K_mac` z PSK to wyłącznie TEST-ORACLE.
9. KAT to **jeden wektor** syntetyczny na profil (ternary logn=10);
   FFT/ffSampling/sampler/keygen/sign/verify silnika poza WP-023/024.

## 6. Inwarianty do szybkiej niezależnej kontroli

- **D-023 (brak QSX/VM):** sekcja w `ci/check.sh` (grep po `Cargo.toml`/lock).
- **WP-025:** `nm -C target/release/libft_threshold_protocol.rlib | grep validate_ntru`
  po buildzie domyślnym = puste; po `--features test-oracle` = 2 trafienia.
- **D-025 (dwie domeny):** testy `zp::`/`mac::` w core; crossing jawnie w SPEC §7.0.
- **Fail-closed:** testy `envelope::` (tamper → `AuthFail`, rollback →
  `RoundMismatch`, replay → `ReplayDetected`), `sampler::` (cap → `AttemptsExhausted`).
- **Higiena sekretów:** `skey` tylko jako SHAKE256 w KAT; korpus i wektory
  syntetyczne; `PairwiseKey` bez akcesora bajtów; `Debug` redaguje sekrety.

## 7. Środowisko i piny

- Toolchain: `rust-toolchain.toml` (1.94.0, minimal); rustc
  `1.94.0 (4a4ef493e 2026-03-02)`; cargo `1.94.0 (85eff7c80)`.
- Zależności: `Cargo.lock` (tracked) + `sbom/sbom_v1.txt`
  (sha256 `fad5934d7991b275a2d2f1299ad9d7f65ffcb6393dd00d000cdf75c6fcaad974`).
- Silnik: 13 pinów w `KAT/MANIFEST.txt` (m.in. `falcon-vrfy.c
  3fe78f8d…`, `falcon-enc.c 0f7085fa…`); harness WP-023 w
  `engine_diff/PIN_2026-10-26.txt`.
- Commity toru: 37 w `git log -- proofs/ft1536/development/THRESHOLD_P2_001`
  (od `6bd63535` otwarcie toru, po `5883b19e` WP-026). Push wstrzymany
  do odwołania przez właściciela.

## 8. Sugerowana checklista recenzenta

1. Powtórzyć `./ci/check.sh` i porównać z tabelą w §2.
2. Wybrać po jednym pinie z każdej klasy (KAT, wire, corpus, SBOM,
   silnik) i sprawdzić ręcznie `sha256sum` vs dokument.
3. Sprawdzić §5: czy któreś twierdzenie (w tym dokumenty toru) nie
   wykracza poza wymienione granice; szczególnie komunikaty statusów
   (F-01…F-12 w `CLAIMS_REGISTER.md`).
4. Sprawdzić inwersję kontroli w testach: czy „PASS" nie pochodzi z
   porównania kodu z samym sobą (wszystkie KAT-y mają niezależne
   referencje Python/C — zweryfikować jedną ścieżkę w całości).
5. Werdykt w formacie z §1, z zakresem explicit; niezgodności jako
   `CHANGES_REQUIRED` z plikami i oczekiwaniami.

---

*Pakiet przygotował autor implementacji (niirmataa); niezależny odbiór
wykona recenzent wyznaczony przez właściciela. Zmiany w materiale po
przekazaniu = nowa wersja pakietu (v2), nie cicha edycja.*
