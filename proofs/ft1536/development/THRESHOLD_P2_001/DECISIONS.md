# DECISIONS — rejestr decyzji (ADR)

**Zasada:** decyzja niezapisana = decyzja nieistniejąca. Statusy:
`ACCEPTED` (właściciel), `PROPOSED` (domyślna, czeka na potwierdzenie),
`OPEN` (brak decyzji), `SUPERSEDED` (zastąpiona nowym wpisem).
Nie nadpisujemy historii — korekta = nowy wpis.

---

## D-001 — Wybór P2 (MPC threshold signing)

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (właściciel: „idę w P2, mimo że może to trwać długo”)
- **Treść:** programem jest pełny progowy podpis MPC, nie seed-custody (P1).
- **Konsekwencje:** zakres obejmuje ffSampling, Klein, DKG NTRU, dowód i audyt.
  P1 nie jest deliverablem i nie może być reklamowany jako P2.

## D-002 — Nowy lane zamiast rozbudowy spike'a

- **Data:** 2026-10-26
- **Status:** **ACCEPTED**
- **Treść:** nowy katalog `THRESHOLD_P2_001`; spike pozostaje zamrożonym
  spec/oracle/testkit i nie jest kopiowany 1:1.
- **Konsekwencje:** brak dealerów, stand-inów, fail-openów i `iso` w produkcji.
  Mapa: `SOURCE_MAP.md`.

## D-003 — Parametry v1: 2-of-3

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** v1 = k=2, n=3 (jeden padający/złośliwy); v2 = 3-of-5.
- **Uzasadnienie:** najmniejszy realny próg z honest majority i tolerancją
  jednej awarii; 2-of-2 nie jest progiem.
- **Do potwierdzenia:** czy v1 nie ma być od razu 3-of-5.

## D-004 — Warunek honest majority

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** `k ≤ (n+1)/2`; 2-of-3 i 3-of-5 spełniają.
- **Konsekwencje:** dla `k > (n+1)/2` potrzebny inny model/dowód; nie w v1.

## D-005 — Byte-compatibility z `ft1536-sys`

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** podpis progowy musi przechodzić `Ft1536Signature::verify`
  bez zmian w silniku; `pk` 2881 B, `sk` 7681–10369 B, nonce 40 B.
- **Konsekwencje:** KAT i differential są bramką G3.

## D-006 — Model bezpieczeństwa v1

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** malicious static ≤ k−1, rushing, synchroniczne rundy z timeoutem,
  abort; cel: standalone/UC z identifiable abort.
- **Konsekwencje:** brak asynchroniczności w v1; jasny zakres claimu.

## D-007 — Koordynator nie widzi udziałów

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (architektura)
- **Treść:** koordynator orkiestruje, autoryzuje i audytuje; nie ma dostępu
  do udziałów ani kluczy.
- **Konsekwencje:** koordynator może być osobnym procesem/hostem; jego
  kompromitacja nie może ujawnić klucza.

## D-008 — Weryfikator w TCB

- **Data:** 2026-10-26
- **Status:** **ACCEPTED**
- **Treść:** `ft1536-sys` jest zaufanym weryfikatorem do czasu audytu;
  pin wersji + KAT + differential.
- **Konsekwencje:** zmiana silnika = nowy pin i re-run KAT.

## D-009 — Brak dealera i stand-inów w produkcji

- **Data:** 2026-10-26
- **Status:** **ACCEPTED**
- **Treść:** `g2_deal_trapdoor`, `xof.rs`, deterministyczny Babai i `bin/iso.rs`
  są wyłącznie testowe (`#[cfg(test)]` / `testkit`).
- **Konsekwencje:** build produkcyjny nie linkuje tych ścieżek.

## D-010 — Transport: TLS 1.3 / mTLS

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** rustls + mTLS; framing długość+typ; sesje i replay-window.
- **Alternatywa:** Noise XX. Decyzja po WP-011.

## D-011 — Serializacja: kanoniczne CBOR

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** deterministyczne CBOR (RFC 8949) + ścisłe schematy + limity.
- **Uzasadnienie:** audytowalność, wersjonowanie, brak zależności od
  niestabilnego `bincode`.

## D-012 — Język i platforma

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** Rust, MSRV pinowany, `#![forbid(unsafe_code)]`,
  Linux x86_64 najpierw; aarch64 w G3.
- **Konsekwencje:** brak `unsafe` w core/protocol; FFI tylko w `verify`.

## D-013 — HSM/TPM od G3

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** G2 może używać soft-seal z zeroizacją; G3 wymaga HSM/TPM
  dla udziałów w spoczynku.
- **Do potwierdzenia:** czy HSM ma być wymagany już w G2.

## D-014 — Refresh w v1.1

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** v1 dowozi DKG + sign; proactive refresh i recovery w v1.1
  (G5), ale interfejs projektowany od G0.

## D-015 — Nonce hedged

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** nonce 40 B z OS RNG + wkład stron, wiązany z komunikatem i sesją;
  deterministyczny wariant tylko do KAT.
- **Uzasadnienie:** odporność na fault/replay; unikalność per sesja.

## D-016 — Produkcja przenoszona do `[N]` na G3

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** development w `free_falcon_sign`; crate produkcyjne do
  `[N]/crates/` po G3, z zachowaniem pinów i manifestu.
- **Do potwierdzenia:** docelowa lokalizacja i właściciel integracji.

## D-017 — Dowód i audyt przed produkcją

- **Data:** 2026-10-26
- **Status:** **ACCEPTED**
- **Treść:** brak produkcji bez niezależnego dowodu (lub podpisanej decyzji
  o ryzyku) i bez zewnętrznego audytu.
- **Konsekwencje:** G4 jest bramką twardą, nie „nice to have”.

## D-018 — P1 nie jest P2

- **Data:** 2026-10-26
- **Status:** **ACCEPTED**
- **Treść:** seed custody z rekonstrukcją w enclave nie może być opisywane
  jako „klucz nigdy nie istnieje”.
- **Konsekwencje:** osobny produkt, osobny claims register.

## D-019 — Commity i push

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (dom house)
- **Treść:** małe commity z dokładnymi pathspecami; jeden writer; bez amend;
  push tylko po słowie właściciela.

## D-020 — Subagenty

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (na podstawie F-05/F-09/F-20)
- **Treść:** krytyczny kod kryptograficzny pisze okno główne; subagent
  wyłącznie do eksploracji/audytu.
- **Konsekwencje:** brak „równoległej implementacji” przez general-ultra.

---

## D-021 — Reprezentacja klucza w v1: wariant A (udziały pułapki)

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** v1 używa udziałów `(f_i,g_i,F_i,G_i)` i MPC-ffSampling
  (wariant A). Wariant B (udział seeda + obwód `G(seed*)` w MPC) jest
  odłożony poza v1.
- **Uzasadnienie:** A ma istniejący złoty łańcuch dla równania i pinu F2
  (`shares → s1,s2 → engine verify`), jest bliższy literaturze
  threshold-Falcon i nie wymaga kompilacji `G(seed*)` do obwodu MPC.
  **Ale** ten łańcuch używa retained G-1 (reconstruct `f,F` do `z`);
  A produkcyjne wymaga zastąpienia tego realnym MPC-ffSampling (O-02).
  B ma atrakcyjniejszą własność „klucz nigdy nie istnieje”, ale jego
  koszt to rząd `10⁵–10⁷ × G_frag` i brak obwodu; to osobny program
  badawczy, nie skrót.
- **Konsekwencje:** setup musi rozwiązać bezdealerowy, ważny keygen NTRU
  (O-01); bez tego `PROD` nie istnieje. B pozostaje celem po v1.

## D-022 — Podział bramek: G2 = signing plumbing, G3 = realna krypto

- **Data:** 2026-10-26
- **Status:** **PROPOSED**
- **Treść:** G2 zamyka **protokół podpisu** na profilu `TEST-ORACLE`
  (znany klucz testowy + deterministyczny sampler), z pełnym harnessem
  złośliwych stron i brakiem reconstruct w ścieżce sign. G3 wymaga
  bezdealerowego, ważnego setupu NTRU, realnego Klein/ffSampling,
  bajtowej zgodności i sieci.
- **Uzasadnienie:** nie blokować całego postępu na nierozwiązanym
  keygenie NTRU; jednocześnie nie ogłaszać G2 „produkcją” ani „bez
  dealera”. `TEST-ORACLE` jest jawnie testowy i nie linkuje do `PROD`.
- **Konsekwencje:** G2 nie jest claimem bezpieczeństwa ani „threshold
  FT gotowy”; G3 jest pierwszą bramką, która może dotknąć `PROD`.
  Wszystkie wyjścia G2 mają `profile=TEST_ORACLE` w transkrypcie.

---

## Decyzje do potwierdzenia teraz (blokują G1)

| ID | Pytanie | Domyślna odpowiedź |
|---|---|---|
| D-003 | 2-of-3 czy 3-of-5 w v1? | 2-of-3 |
| D-010 | TLS 1.3/mTLS czy Noise? | TLS 1.3/mTLS |
| D-013 | HSM od G2 czy G3? | od G3 |
| D-016 | produkcja w `[N]` na G3? | tak |
| D-011 | CBOR czy inny format? | kanoniczne CBOR |
| D-021 | wariant A czy B w v1? | A (udziały pułapki) |

**D-022** nie blokuje G1; porządkuje G2/G3 i wymaga potwierdzenia przed
startem WP-030. Brak potwierdzenia = zostaje `PROPOSED`; nie blokuje G0,
blokuje G1 (D-021) albo G2 (D-022).
