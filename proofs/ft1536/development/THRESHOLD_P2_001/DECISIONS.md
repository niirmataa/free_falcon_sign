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
- **Status:** **ACCEPTED** (właściciel, 2026-10-26: potwierdzone domyślne)
- **Treść:** v1 = k=2, n=3 (jeden padający/złośliwy); v2 = 3-of-5.
- **Uzasadnienie:** najmniejszy realny próg z honest majority i tolerancją
  jednej awarii; 2-of-2 nie jest progiem.

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
- **Status:** **ACCEPTED** (właściciel, 2026-10-26: potwierdzone domyślne)
- **Treść:** rustls + mTLS; framing długość+typ; sesje i replay-window.
- **Odrzucona alternatywa:** Noise XX (na razie); powrót wymaga nowej decyzji.

## D-011 — Serializacja: kanoniczne CBOR

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (właściciel, 2026-10-26: potwierdzone domyślne)
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
- **Status:** **ACCEPTED** (właściciel, 2026-10-26: potwierdzone domyślne)
- **Treść:** G2 może używać soft-seal z zeroizacją; G3 wymaga HSM/TPM
  dla udziałów w spoczynku.
- **Konsekwencja:** HSM nie jest warunkiem G1/G2; udział B′ w spoczynku
  na G3 wymaga HSM/TPM (albo jawnej decyzji o ryzyku).

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
- **Status:** **ACCEPTED** (właściciel, 2026-10-26: potwierdzone domyślne)
- **Treść:** development w `free_falcon_sign`; crate produkcyjne do
  `[N]/crates/` po G3, z zachowaniem pinów i manifestu.
- **Konsekwencja:** przeniesienie wykonuje koordynator po odbiorze G3;
  nie jest automatyczne i nie zmienia historii lane'u.

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
- **Status:** **SUPERSEDED** przez D-024 (2026-10-26); zachowany jako historia.
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
- **Status:** **ACCEPTED** (właściciel, 2026-10-26: potwierdzone domyślne)
- **Treść:** G2 zamyka **protokół podpisu** na profilu `TEST-ORACLE`
  (znany klucz testowy + deterministyczny sampler), z pełnym harnessem
  złośliwych stron i brakiem reconstruct w ścieżce sign. G3 wymaga MPC
  `G(seed*)` B′ (ważny NTRU bez rekonstrukcji), realnego Klein/ffSampling,
  bajtowej zgodności i sieci.
- **Uzasadnienie:** nie blokować całego postępu na nierozwiązanym
  keygenie NTRU; jednocześnie nie ogłaszać G2 „produkcją” ani „bez
  dealera”. `TEST-ORACLE` jest jawnie testowy i nie linkuje do `PROD`.
- **Konsekwencje:** G2 nie jest claimem bezpieczeństwa ani „threshold
  FT gotowy”; G3 jest pierwszą bramką, która może dotknąć `PROD`.
  Wszystkie wyjścia G2 mają `profile=TEST_ORACLE` w transkrypcie.

---

## D-023 — QSX/VM wyłączone z P2

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (właściciel: „nie używamy już VM QSX, ponieważ
  właśnie po to robimy próg, żeby rozwiązać tę historię”)
- **Treść:** P2 **nie używa** `ftkey-vm`, QSX ani efemerycznej VM jako
  elementu architektury. Node P2 to osobne procesy/hosty z udziałami;
  izolację zapewnia próg i brak pełnego klucza w jednym miejscu, a nie VM.
  QSX był obejściem dla single-signera (pełny seed w RAM hosta), nie
  fundamentem P2.
- **Konsekwencje:**
  - F-1/F-3/F-6/F-7 w FTKEY pozostają długiem FTKEY; **nie są blockerami P2**.
  - `FTKEY_INTEGRATION_MAP`: R-7 (QSX lifecycle) i S-6 (izolacja QSX)
    są **OUT OF SCOPE**; nie przenosimy `network_cut`, lifecycle,
    `ftkey-vm` ani GUI VM do P2.
  - G1/G2/G3 nie wymagają KVM/QSX; E2E P2 to trzy nody, nie VM.
  - Powrót QSX/VM do P2 wymaga **nowej decyzji** i nie jest warunkiem
    żadnej bramki.
  - HSM/TPM (D-013) pozostaje dla udziałów w spoczynku — to nie QSX.

---

## D-024 — Reprezentacja klucza w v1: wariant B′

- **Data:** 2026-10-26
- **Status:** **ACCEPTED** (właściciel wybrał **B′**; zastępuje D-021)
- **Treść:** v1 używa **B′**: setup dzieli 32-bajtowy `seed*` na udziały
  (seed-share DKG), a następnie **jednorazowo** liczy w MPC funkcję
  `G(seed*)` = `keygen_from_seed_32` i otrzymuje udziały pułapki
  `(f_i,g_i,F_i,G_i)` oraz publiczne `pk` (`h = g·f^{-1}`), bez
  rekonstrukcji `seed*`, `f`, `g`, `F` ani `G`. Po udanym setupie udziały
  seeda są zeroizowane i **nie** są przechowywane w normalnej ścieżce.
- **Podpis:** A-style MPC ffSampling na udziałach pułapki; brak seeda
  i brak reconstruct w ścieżce sign.
- **Magazyn:** udział pułapki to ~11,5 KB binarnie, więc **nie** mieści
  się w kopercie 4 KB tokena. Udział leży w pieczęci na dysku/HSM
  (G2: soft-seal z zeroizacją; G3: HSM/TPM — D-013). Token per node
  pozostaje **bramą KEK** (`hmac-secret` + PIN/UV) do odpieczętowania
  udziału, a nie nośnikiem udziału.
- **Dlaczego nie czysty B:** B płaci MPC `G(seed*)` **per podpis** i trzyma
  udziały seeda bezterminowo; B′ płaci to raz w setupie i usuwa seed
  z systemu. Czysty B pozostaje odrzuconą alternatywą; powrót wymaga
  nowej decyzji.
- **Konsekwencje:**
  - **O-16** (MPC `G(seed*)`) wchodzi do zakresu v1 jako blocker G3;
    nie jest już „po v1”. O-01 (bezdealerowy ważny keygen NTRU) jest
    **subsumowany** przez O-16 na ścieżce B′ — nie wolno ogłaszać O-01
    „rozwiązanego”, dopóki O-16 nie ma implementacji i dowodu.
  - **O-02** (realny MPC ffSampling) pozostaje największym blockerem G3.
  - `TEST-ORACLE`/G2 bez zmian: znany klucz testowy + deterministyczny
    sampler; G2 nadal nie jest `PROD` ani „bez dealera”.
  - Refresh/reshare działa na udziałach pułapki (A-style), bez `G`;
    odzyskanie po utracie udziału wymaga backupu pieczęci albo nowego
    setupu z nowym `pk` — dokładna polityka to punkt otwarty O-21.
  - `SOURCE_MAP.md`: `MAP_GSEED_SHARE_NATIVE.md` przestaje być „odłożony”,
    staje się materiałem wejściowym do O-16 (nadal `REFERENCE`, nie kod).

---

## Status decyzji po potwierdzeniu 2026-10-26

Potwierdzone przez właściciela (domyślne): **D-003** (2-of-3), **D-010**
(TLS 1.3/mTLS), **D-011** (kanoniczne CBOR), **D-013** (HSM od G3),
**D-016** (produkcja w `[N]` na G3), **D-022** (G2 = `TEST-ORACLE`,
G3 = `PROD`). Wybór wariantu: **D-024 = B′** (D-021 `SUPERSEDED`).

Nadal `PROPOSED` (nie blokują WP-010/011/012): D-004 (warunek honest
majority), D-005 (byte-compatibility), D-006 (model bezpieczeństwa),
D-012 (język/MSRV), D-014 (refresh w v1.1/G5), D-015 (nonce hedged).
Wymagają potwierdzenia przed G2 (D-005/D-006) i przed G3 (D-012/D-014).

**Uwaga o spójności:** GATES G3 wymaga „refresh/reshare”, a D-014
odkłada implementację do v1.1/G5. To nie jest rozstrzygnięte tym wpisem;
przed G3 trzeba albo potwierdzić D-014, albo zaostrzyć G3.
