# GATES — bramki programu THRESHOLD_P2_001

**Zasada:** bramka jest spełniona tylko wtedy, gdy **wszystkie** punkty exit
są `PASS` z dowodem i niezależnym odbiorem. Brak punktu = bramka otwarta.
Wyjątek wymaga decyzji właściciela w `DECISIONS.md`.

---

## G0 — Kontrakt i plan

**Cel:** zamknąć definicję produktu, zakres, model i plan.

**Wejście:** decyzja właściciela o P2.

**Exit:**

- [ ] `README.md`, `PLAN.md`, `SPEC.md` v0, `THREAT_MODEL.md` istnieją.
- [ ] `DECISIONS.md`: decyzje blokujące G1 (D-003/010/011/013/016/D-024)
      mają status `ACCEPTED`; `PROPOSED` nie zamyka G0. D-022 jest
      wymagane przed G2, nie przed G1.
- [ ] `CLAIMS_REGISTER.md`: zakazane sformułowania wypisane.
- [ ] `WORK_PACKAGES.md`: pierwszy batch G1 ma kryteria odbioru.
- [ ] `RISKS.md`: ryzyka krytyczne mają właściciela i wyzwalacz.
- [ ] `SOURCE_MAP.md`: dyspozycja każdego modułu spike'a.
- [ ] Wpis S09 w `ROADMAP.md` + wpis w `STATE.md`.

**Artefakty:** ten katalog + commit.
**Recenzent:** właściciel (decyzje) + niezależny przegląd planu.
**Nie przechodź, jeśli:** brak wyboru parametrów, brak threat modelu,
brak claims register, plan nie ma bramek.

---

## G1 — Hardened foundation

**Cel:** fundament, który można pokazać audytorowi bez wstydu.

**Wejście:** G0.

**Exit:**

- [ ] Workspace crate'ów (`core`, `protocol`, `transport`, `node`,
      `coordinator`, `testkit`, `verify`) kompiluje się offline.
- [ ] **Brak zależności od `ftkey-vm`/QSX/VM w P2 (D-023)**; build nie
      wymaga KVM ani `qsx-alpine`.
- [ ] `rust-toolchain.toml`, `deny.toml`, `clippy -D warnings`,
      `#![forbid(unsafe_code)]`, hermetyczne CI.
- [ ] Prymitywy przeniesione/przepisane z KAT ze spike'a:
      Shamir, `gf_mul`, `R_q`, NTT, SHAKE, PRSS, Pedersen.
- [ ] **#9** ukryte δ: skorelowane fałszerstwo → `MacFail`; brak
      `delta_known` w API produkcyjnym.
- [ ] **#3** typestate: nie da się podpisać bez walidacji DKG/NTRU.
- [ ] **#4** maski: świeże, niezależne szerokości; test otwarć.
- [ ] **#7** pełne VSS w ścieżce sign (bez `G2_VSS_SAMPLE`).
- [ ] **#11** zeroizacja: `ZeroizeOnDrop`, brak `Clone`/`Debug`,
      `mlock`, no-dump; test braku kopii.
- [ ] **#13** SHAKE: bitność i spójność każdego udziału; forged bit → `Err`.
- [ ] **#14** malformed input: `TryFrom`, limity, brak paniki; fuzz.
- [ ] **#15** mailbox: uwierzytelnione koperty, licznik rund, replay-window.
- [ ] Wszystkie capy samplerów → `Err` (`AttemptsExhausted`), zero fail-open.
- [ ] Fuzz targets: wire, codec, `hash_to_point`, `decode_sk`.
- [ ] Differential vs silnik na KAT + 10⁴ przypadków.
- [ ] Brak dealera/stand-inu/`iso` w buildzie produkcyjnym.

**Artefakty:** `core` + testy + fuzz corpus + CI logi.

**Stan implementacji (2026-10-26, to NIE odbiór):** WP-010/011/012 `DONE`
(workspace, hermetyczne CI, prymitywy; 92 testy natywne, miri PASS),
WP-013 `DONE` (`Z_P` + MAC ukrytego δ, `impl/ci/WP013_CHECK_2026-10-26.txt`).
Bramka pozostaje **otwarta**: WP-014…WP-027 `TODO`, brak niezależnego
recenzenta (autor ≠ recenzent).

**Recenzent:** niezależny (inny model/człowiek).
**Nie przechodź, jeśli:** jest znany realny bug, fail-open, panic z wejścia,
albo build wymaga zewnętrznej ścieżki.

---

## G2 — Signing protocol on `TEST-ORACLE` (malicious harness)

**Cel:** działający protokół podpisu 2-of-3 z pełnym harnessem złośliwych
stron, na **jawnie testowym** setupie i samplerze. To nie jest produkcja
ani claim „bez dealera”.

**Wejście:** G1 + D-022 potwierdzone.

**Profil:** `TEST-ORACLE` (SPEC §5.1). Znany klucz testowy jest dzielony
na wkłady w testkicie; deterministyczny sampler tylko jako oracle.
**MUST NOT** linkować do binarium `PROD`; transkrypt ma `profile=0x01`.

**Exit:**

- [ ] Setup message flow: `SETUP_INIT/ACCEPT`, `CONTRIB_COMMIT/REVEAL`,
      `VSS_SHARE`, `COMPLAINT/RESPONSE`, `SETUP_FINAL/CERTIFY`.
- [ ] Pełny VSS (nie `G2_VSS_SAMPLE=8`), complaints, publiczny transkrypt.
- [ ] `pk` z wektora testowego; `pk_hash` w transkrypcie; wszystkie
      uczciwe strony uzgadniają `pk_hash` i `TH_final`.
- [ ] Sign 2-of-3: end-to-end, engine verify, **brak reconstruct
      w `protocol`/`core`**; testkit może użyć znanego klucza do
      wygenerowania `z` wyłącznie jako `TEST-ORACLE` (jawny wpis
      w transkrypcie), bez API reconstruct i bez linkowania do `PROD`.
- [ ] Nonce commit/reveal; unikalność; replay odrzucony.
- [ ] Harness złośliwych stron: ≥10 strategii (fałszywy wkład, zła runda,
      replay, equivocation, drop, tamper MAC, podmiana `pk`, selektywne
      otwarcie, crash/restart, sybil).
- [ ] Każda strategia → abort/`Err` z wskazaniem winnego; zero cichych.
- [ ] Test „k−1 nie podpisze”, „k podpisze”, „k+1 też”.
- [ ] 3-of-5 w testach parametrycznych (bez nowej logiki).
- [ ] Każdy wynik ma `profile=TEST_ORACLE`; raport nie zawiera słów
      „produkcja”, „bez dealera”, „malicious-secure”.

**Artefakty:** `protocol` + `testkit` + raport z macierzą ataków.
**Recenzent:** niezależny.
**Nie przechodź, jeśli:** protokół wymaga reconstruct w ścieżce sign,
albo złośliwa strona może wymusić cichy zły podpis, albo wynik jest
prezentowany jako `PROD`.

**Uwaga:** G2 nie zamyka O-16/O-02. To jest **plumbing**, nie krypto.

---

## G3 — Crypto completeness (`PROD` setup + real sampler)

**Cel:** usunąć `TEST-ORACLE`: MPC `G(seed*)` B′ (ważny NTRU bez
rekonstrukcji `seed*`); realny Klein/ffSampling; bajtowa zgodność; sieć.

**Wejście:** G2 + D-024 (B′) potwierdzone.

**Exit:**

- [ ] **O-16** MPC `G(seed*)` = `keygen_from_seed_32` w setupie B′:
      wejście `seed*` w udziałach, wyjście udziały `(f,g,F,G)`; brak
      rekonstrukcji `seed*`/klucza; seed zeroizowany po setupie.
      Nie da się zamknąć — jawna decyzja właściciela o zmianie zakresu;
      nie „cichy dealer”.
- [ ] **O-04** Zero-test poprawności relacji NTRU / zgodności MPC `G`
      bez otwierania różnicy (dowód lub ograniczony, jawny check).
- [ ] **O-05** `pk` bez reconstruct: MPC `f^{-1}`, `h = g·f^{-1}`,
      otwarcie tylko `h`; `pk_hash` zgodny.
- [ ] Pełny VSS w setupie (wszystkie współczynniki), complaints,
      dyskwalifikacja bez reconstruct.
- [ ] **O-02/O-03** Realny sampler: Klein 73-bit / `D_Λ`, budżet
      precyzji, TV vs target z przedziałem ufności, zero fail-open.
- [ ] ffSampling: FFT3 + LDL tree, krótkie `z`, norm bound ze slackiem.
- [ ] **O-06** Check normy wierny formie silnika (nie tylko `L2`);
      konserwatywne `c·L2 < B_norm` z dowodem/raportem.
- [ ] `s2` liczone w całości na udziałach, bez reconstruct `f,F`.
- [ ] Podpis byte-compatible: 10³ KAT + 10⁵ differential.
- [ ] Budżet wydajności: rundy, bajty, latency — zmierzone, nie szacowane.
- [ ] `ft1536-sys` vendor + pin; brak absolutnej ścieżki.
- [ ] Transport w sieci: 3 nody, mTLS, sesje, timeouty, chaos.
- [ ] Refresh/reshare: `pk` bez zmian, stare udziały bezużyteczne.
- [ ] HSM/TPM adapter dla udziałów w spoczynku.
- [ ] Wszystkie wyniki mają `profile=PROD`; brak symboli testkit.

**Artefakty:** `core`/`protocol`/`node` + KAT + benchmark + raport.
**Recenzent:** niezależny + przegląd kryptograficzny.
**Nie przechodź, jeśli:** został oracle-sampler, stand-in, dealer,
reconstruct, albo podpis nie przechodzi verify na KAT.

---

## G4 — Assurance

**Cel:** dowód i niezależne potwierdzenie.

**Wejście:** G3.

**Exit:**

- [ ] Dowód: game-based/UC, jawne założenia (w tym A-01 baza FT1536).
- [ ] Model sprawdzony formalnie (Tamarin/ProVerif) dla DKG/sign/refresh.
- [ ] Side-channel: dudect/TVLA + analiza CT; brak wysokich otwartych.
- [ ] Fault injection: testy, detekcja, zachowanie fail-closed.
- [ ] Zewnętrzny audyt: brak otwartych critical/high.
- [ ] Red team: scenariusze z threat modelu.
- [ ] Bug bounty/disclosure policy.
- [ ] Claims register zaktualizowany: każde `PROVEN` ma dowód.

**Artefakty:** proof, raport audytu, raport CT/fault, disclosure.
**Recenzent:** zewnętrzny audytor + niezależny model.
**Nie przechodź, jeśli:** brak dowodu (bez decyzji o ryzyku), otwarty
critical/high, albo claim szerszy niż dowód.

---

## G5 — Production readiness

**Cel:** gotowość operacyjna.

**Wejście:** G4.

**Exit:**

- [ ] HSM/TPM w produkcji; seal/unseal; attestation.
- [ ] Refresh/recovery/revocation przetestowane na sucho i w chaosie.
- [ ] Koordynator: polityka, limity, approvals, kill switch.
- [ ] Audyt: hash-chained log, monitoring, alerty, retencja bez sekretów.
- [ ] Reproducible build, podpisane release, SBOM, CVE process.
- [ ] IR: runbook, kontakt, procedura kompromitacji, ćwiczenie.
- [ ] DR: backup/restore, utrata kworum, rollback, test odtworzenia.
- [ ] SLO/limity: latency, throughput, dostępność; budżet potwierdzony.
- [ ] Operacyjny odbiór (owner + ops + security).

**Artefakty:** release, runbook, raport DR/IR, SBOM.
**Recenzent:** ops + security + właściciel.
**Nie przechodź, jeśli:** nie ma testu odtworzenia, monitoringu sekretów,
albo release nie jest reprodukowalny.

---

## Reguła stop-and-report

Przy każdym nieprzewidzianym wyniku (hash mismatch, test flake bez przyczyny,
brak pliku, rozjazd spec↔kod) zatrzymujemy się, zachowujemy stan i raportujemy.
Zakaz cichych napraw i obejść.
