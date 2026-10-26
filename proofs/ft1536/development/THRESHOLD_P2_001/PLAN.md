# PLAN — progowy podpis FT1536 (P2)

**Wersja:** 0.1 (2026-10-26) · **Status:** G0 IN_PROGRESS
**Wejście:** `THRESHOLD_SPIKE_001` (414/414) · **Wyjście:** G5 = produkcja
z audytem, dowodem i operacjami.

---

## 1. Definicja celu

Zbudować **progowy podpis FT1536 k-z-n** taki, że:

1. **Poprawność:** dla dowolnego komunikatu wynik jest poprawnym podpisem
   FT1536 — weryfikowanym przez `ft1536-sys` (`pk` 2881 B, `sk` 7681–10369 B,
   nonce 40 B, q=18433, N=1536, pierścień `X^1536−X^768+1`, secret ternarny).
2. **Brak „momentu":** pełny klucz (`f,g,F,G`) ani seed nie istnieją w całości
   w żadnym procesie, hoście ani buforze — od DKG do podpisu.
3. **Próg:** dowolne `k` stron kończy protokół; `k−1` stron nic nie uczy
   o kluczu i nie wytwarza podpisu.
4. **Złośliwość:** do `t = k−1` złośliwych stron (static, rushing) nie może
   sfałszować podpisu ani wymusić cichego złego wyniku; protokół kończy się
   **identyfikowalnym abortem**.
5. **Publiczna weryfikowalność setupu:** wszystkie uczciwe strony zgadzają się
   na `pk` i transkrypt; błędny wkład jest wykryty i przypisany.
6. **Cykl życia:** odświeżenie udziałów bez zmiany `pk`, odzyskanie po
   utracie strony, unieważnienie starej epoki.
7. **Bezpieczeństwo transportu i stanu:** uwierzytelnione kanały, replay-window,
   udziały w HSM/TPM, zeroizacja, brak sekretów w logach.
8. **Dowód i audyt:** niezależny dowód (game-based/UC) i zewnętrzny audyt
   przed jakimkolwiek twierdzeniem produkcyjnym.

**To nie jest P1.** P1 (threshold seed custody z rekonstrukcją w enclave)
jest osobnym, znacznie mniejszym produktem i nie wolno go nazywać P2.

---

## 2. Zakres

### IN (v1)

- Rust, referencyjna implementacja **2-of-3** (jeden padający).
- DKG bez dealera: seed-share DKG 32 B `seed*` + **jednorazowy MPC
  `G(seed*)`** w setupie B′ (D-024), z pełnym VSS/complaints i `pk` bez
  reconstruct. Relacja NTRU wynika z poprawności `G`; jej zero-test
  pozostaje osobnym punktem (O-04).
- Podpis MPC: hash-to-point, ffSampling, `s2`, norm check, encoding, verify.
- PRSS/CDI bez dealera; złośliwe mnożenia z auth triples.
- Transport: mTLS/TLS 1.3, framing, sesje, epoki, timeouty, abort.
- Storage: HSM/TPM-ready interfejs, na start soft-seal z zeroizacją.
- Refresh/reshare, recovery, testy chaosu.
- Testkit: harness złośliwych stron, oracle silnika, KAT, fuzzing.
- Dowód + audyt + analiza side-channel i fault.

**Uwaga o kolejności:** G2 zamyka **signing plumbing** na profilu
`TEST-ORACLE` (znany klucz testowy + deterministyczny sampler), bo nie
blokujemy całego toru na nierozwiązanym keygenie NTRU. G3 jest pierwszą
bramką `PROD`: MPC `G(seed*)` B′ + realny Klein/ffSampling.
`TEST-ORACLE` nigdy nie jest prezentowany jako `PROD` ani „bez dealera”.

### OUT (świadomie)

- P1 seed custody, produkt FTKEY, `[N]` — osobne decyzje i odbiory.
  Z FTKEY bierzemy tylko pin silnika, token, pieczęć i weryfikator
  (D-023); nie przejmujemy produktu ani jego ścieżki VM.
- **QSX/VM, `ftkey-vm`, efemeryczna VM — wyłączone z P2 (D-023).**
  Próg zastępuje tę izolację: klucz nigdy nie istnieje w całości, więc
  nie ma czego „chować” w efemerycznej VM. Powrót QSX wymaga nowej decyzji.
- FT768/FT3072 — inne profile, poza v1.
- Quantum/QROM, FIPS 140-3 certification, multi-tenant SaaS.
- Produkt sprzętowy, aplikacja mobilna, UI.
- „Bezpieczeństwo bez dowodu" — nie jest deliverablem.

---

## 3. Parametry v1

| Element | v1 | v2 |
|---|---|---|
| Próg | **2-of-3** (k=2, n=3) | **3-of-5** (k=3, n=5) |
| Tolerancja | 1 padająca/złośliwa | 2 padające/złośliwe |
| Honest majority | 2 ≤ (3+1)/2 | 3 ≤ (5+1)/2 |
| Pierścień | `Z_q[X]/(X^1536−X^768+1)`, q=18433 | bez zmian |
| Secret | ternarny | bez zmian |
| Reprezentacja klucza | **B′** (D-024): seed-share DKG → jednorazowy MPC `G(seed*)` → udziały pułapki; seed zeroizowany | bez zmian |
| Udział w spoczynku | pieczęć na dysku/HSM; token = brama KEK (nie nośnik) | HSM/TPM |
| `pk` / `sk` | 2881 B / 7681–10369 B | bez zmian |
| Nonce | 40 B, hedged | bez zmian |
| Podpis | codec 0xAA, Golomb-Rice j=8 | bez zmian |
| Komunikacja | TLS 1.3 mTLS, synchroniczne rundy z timeoutem | + asynchroniczność |

**Warunek progu:** `k ≤ (n+1)/2` dla uczciwej większości. 2-of-3 i 3-of-5
spełniają. `2-of-2` **nie jest** progiem i nie wchodzi do v1.

---

## 4. Architektura

```
Klient ──mTLS──► Koordynator (bez udziałów; polityka, audyt, sesje)
                    │  kanały per-strona: mTLS, sesja, epoka, replay-window
                    ├──► Node 1  [udziały w sealed storage]
                    ├──► Node 2  [udziały w sealed storage]
                    └──► Node 3  [udziały w sealed storage]
```

### Crates (nowy workspace, `impl/`)

| Crate | Rola | Zasady |
|---|---|---|
| `ft-threshold-core` | arytmetyka: Shamir, `R_q`, NTT, MAC, VSS, PRSS | bez I/O, `#![forbid(unsafe_code)]`, `no_std`-ready |
| `ft-threshold-protocol` | maszyny stanów DKG/sign/refresh, komunikaty, transkrypt, abort | bez sieci |
| `ft-threshold-transport` | kanały, framing, sesje, replay, timeouty | TLS 1.3/mTLS |
| `ft-threshold-node` | binarium strony, konfiguracja, storage adapter | brak logów sekretów |
| `ft-threshold-coordinator` | orkiestracja, polityka, audyt | nie widzi udziałów |
| `ft-threshold-testkit` | harness, złośliwe strony, oracle, KAT, fuzz | tylko dev/test |
| `ft-threshold-verify` | wrapper `ft1536-sys` + niezależne kontrole | TCB, pinowane |

**Lokalizacja:** development tutaj; crate produkcyjne przenoszone do
`[N]/crates/` na bramce G3 (decyzja D-016 do potwierdzenia).

**Zakaz:** `ft1536-sys` przez absolutną ścieżkę; tylko vendor + pin commita.

---

## 5. Model bezpieczeństwa (skrót)

- **Napastnik:** static, malicious, rushing, kontroluje ≤ `k−1` stron,
  sieć i dysk skorumpowanych hostów; nie łamie SHAKE256, Ristretto DL,
  TLS 1.3; nie ma fizycznego dostępu do uczciwych hostów ani HSM.
- **Model:** honest majority, synchroniczne rundy z timeoutem, abort.
- **Cel dowodowy:** standalone/UC z identifiable abort; gra EUF-CMA dla
  podpisu progowego; redukcja do bazy FT1536 + MT-ISIS (tor T12.1) jako
  warunku jawnego.
- **Założenie jawne:** bezpieczeństwo bazy FT1536 nie jest dowiedzione w tym
  torze; bez niego claim produkcyjny jest **warunkowy**.

Szczegóły: [`THREAT_MODEL.md`](THREAT_MODEL.md).

---

## 6. Workstreamy

| ID | Workstream | Cel | Wyjście | Zależy | Rozmiar |
|---|---|---|---|---|---|
| **W1** | Spec & contract | `SPEC.md` v1, wire, state machines, wektory | spec + KAT skeleton | G0 | M |
| **W2** | Hardened core | port/rewrite prymitywów z hardeningiem | `core` + KAT + fuzz | W1 | L |
| **W3** | MAC / malicious mul | ukryte δ, auth triples, sacrifice, MAC na bitach | tamper matrix | W2 | L |
| **W4** | VSS / DKG | publicznie weryfikowalny DKG + MPC `G(seed*)` (B′) | transkrypt + complaints | W2,W3 | XL |
| **W5** | PRSS/CDI | pairwise PRF bez dealera | testy niezależności | W2 | M |
| **W6** | `R_q`/NTT binding | arytmetyka vs silnik/R1 | differential 10⁵ | W2 | L |
| **W7** | Sampler | Klein 73-bit, `D_Λ`, TV, σ | sampler + statystyka | W6 | XL |
| **W8** | ffSampling | FFT3 + LDL, norm bound | krótkie `s2`, verify | W7 | XL |
| **W9** | Sign protocol | hash-to-point, nonce, `s2`, encode, abort | end-to-end sign | W3,W4,W8 | XL |
| **W10** | Refresh/lifecycle | reshare, recovery, revocation | testy cyklu życia | W4,W9 | L |
| **W11** | Transport/session | mTLS, framing, replay, timeouty | node w sieci | W1 | L |
| **W12** | Assurance | dowód, audyt, side-channel, fault | raport + proof | wszystkie | XL |
| **W13** | Ops/release | HSM, monitoring, release, IR | readiness review | W11 | L |

**Zasada:** W7/W8/W12 są badaniami, nie „sprintem". Nie wolno ich zastąpić
stand-inem i ogłosić G3.

---

## 7. Bramki

| Bramka | Cel | Exit (skrót) |
|---|---|---|
| **G0** | kontrakt i plan | decyzje potwierdzone, SPEC v0, claims/threat/gates |
| **G1** | hardened foundation | wszystkie znane realne bugi zamknięte, fail-closed, hermetyczne CI, fuzz, brak dealera/stand-inu w prod |
| **G2** | signing protocol on `TEST-ORACLE` | setup message flow + sign + verify w harnessie; złośliwy nie forge'uje; brak reconstruct w sign; replay/abort. **Nie produkcja, nie „bez dealera”** |
| **G3** | realna krypto (`PROD`) | MPC `G(seed*)` B′ + MPC `pk` + realny sampler/ffSampling + check normy; podpis byte-exact; sieć; refresh; budżet wydajności |
| **G4** | assurance | dowód + audyt zewnętrzny + side-channel + fault; niezależny PASS |
| **G5** | production readiness | HSM, refresh/recovery, monitoring, release, IR; gotowość operacyjna |

Pełne kryteria: [`GATES.md`](GATES.md).

---

## 8. Graf zależności

```
G0 ──► W1 ──► W2 ──► W3 ──► W4 ──┐
        │       │       │        ├──► W9 ──► W10 ──► G5
        │       │       └──► W5  │
        │       └──► W6 ──► W7 ──► W8 ──┘
        └──► W11 ──────────────────────► G2/G3
W12 (proof/audit) ── równolegle od G2, obowiązkowo przed G5
W13 (ops) ── od G3
```

---

## 9. Kamienie milowe

| ID | Kamień | Deliverable |
|---|---|---|
| M0 | kontrakt | README/PLAN/SPEC/DECISIONS/CLAIMS/THREAT/GATES/WP/RISKS/SOURCE_MAP |
| M1 | hardened core | `core` + KAT + fuzz + zero known real bugs |
| M2 | reference setup flow | 2-of-3 setup message flow na `TEST-ORACLE`: VSS, complaints, transkrypt; bez claimu produkcji |
| M3 | reference sign | 2-of-3 podpis na `TEST-ORACLE`, engine verify, brak reconstruct w sign |
| M4 | malicious harness | złośliwe strony nie forge'ują; tamper matrix |
| M5 | real crypto | MPC `G(seed*)` B′ → ważny keygen NTRU, MPC `pk`, realny Klein/ffSampling, check normy, byte-exact |
| M6 | networked | 3 nodes, TLS, sesje, replay, chaos |
| M7 | assurance | proof + audit + CT/fault |
| M8 | production | HSM, refresh/recovery, release, IR |

---

## 10. Rząd wielkości (nie harmonogram)

| Faza | Rząd wielkości |
|---|---|
| G0 | 1–2 okna |
| G1 | tygodnie |
| G2 | miesiące |
| G3 | badania, miesiące |
| G4 | 6–12 miesięcy zewnętrznego audytu/dowodu |
| G5 | miesiące |

To są **rzędy wielkości**, nie obietnice dat. Każde „przyspieszenie" przez
skrót w W7/W8/W12 jest odrzucane na bramce.

---

## 11. Reguły pracy

- **Jeden writer Git naraz.** Małe commity z dokładnymi pathspecami;
  bez amend/force-push; push tylko po słowie właściciela.
- **Autor ≠ recenzent.** Każdy milestone ma niezależny odbiór.
- **Spec-first.** Kod bez specu i wektorów nie wchodzi.
- **Zero cichych napraw.** Retained z właścicielem i datą przeglądu.
- **Krypto pisze okno główne.** Subagent tylko do audytu/eksploracji
  (historia F-05/F-09/F-20 w spiku).
- **Sekrety:** dane syntetyczne, brak kluczy w repo/logach, `ft-secrets-hygiene`.
- **Rachunek:** Sage z preparserem, gdy pojawią się obliczenia; Lean4/Mathlib
  dla formalnych artefaktów; czyste logi.
- **Historia:** aktualizować po meldunku; nie nadpisywać zamrożonych raportów.

---

## 12. Finalna checklista „production"

Produkcja jest ogłaszana dopiero, gdy **wszystkie** punkty są `PASS`:

- [ ] G0–G5 zamknięte z niezależnym odbiorem.
- [ ] MPC `G(seed*)` B′ (ważny NTRU) i `pk` bez reconstruct.
- [ ] Brak symboli `TEST-ORACLE`/dealer/`xof`/`iso` w buildzie `PROD`.
- [ ] Brak znanych realnych bugów; wszystkie hardeningi zamknięte.
- [ ] Podpis byte-exact verify na KAT i differential vs silnik.
- [ ] Check normy wierny formie silnika (nie tylko `L2`).
- [ ] Brak reconstruct klucza w torze sign (test + audyt kodu).
- [ ] Malicious harness: żaden atak z macierzy nie przechodzi cicho.
- [ ] Dowód (lub jawna, podpisana decyzja właściciela o ryzyku).
- [ ] Zewnętrzny audyt bez otwartych critical/high.
- [ ] Side-channel i fault: wyniki w scope, bez otwartych wysokich.
- [ ] HSM/TPM, refresh/recovery, monitoring, IR przetestowane.
- [ ] Reproducible build + SBOM + pinowany toolchain.
- [ ] Claims register: żadne zdanie nie przekracza dowodu.

**Brak któregokolwiek punktu = nie ma produkcji.**
