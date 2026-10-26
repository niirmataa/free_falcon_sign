# RISKS — rejestr ryzyk THRESHOLD_P2_001

**Skala:** P = prawdopodobieństwo (L/M/H), I = wpływ (L/M/H).
**Wyzwalacz** = sygnał, że ryzyko się materializuje.
**Właściciel** = osoba/tor odpowiedzialny za mitigację.

---

## Krytyczne (blokują produkcję)

| ID | Ryzyko | P | I | Wyzwalacz | Mitigacja | Właściciel |
|---|---|---|---|---|---|---|
| R-01 | **Brak dowodu bezpieczeństwa bazy FT1536** — nie ma czego „przenieść” na próg | H | H | brak A-01 w T12.1 | dowód bazy albo jawna decyzja o ryzyku; nie ogłaszać „secure” | tor T12.1 + właściciel |
| R-02 | **ffSampling/Klein to badania**, nie implementacja | H | H | brak postępu w WP-040/041 | budżet badawczy, prototypy, alternatywne samplery; bramka G3 | W7/W8 |
| R-03 | **Wydajność MPC** — 10³–10⁵ × koszt G_frag na SHAKE; może zabić latency | H | H | benchmark poza budżetem | batch, hybryda, optymalizacja obwodów, wybór poziomu bezpieczeństwa | W7/W9 |
| R-04 | **Side-channel** — gałęzie na sekretach, cache, timing | H | H | dudect/TVLA sygnał | CT, masking, przebudowa gorących ścieżek; G4 | W12 |
| R-05 | **Supply chain** — `ft1536-sys` poza repo, absolutna ścieżka | H | H | build na innym hoście | vendor + pin + SBOM + reproducible | W13 |
| R-06 | **Brak zewnętrznego audytu** — koszt/czas | M | H | brak firmy/budżetu | wczesny kontakt, scope, budżet; G4 | właściciel |

## Wysokie

| ID | Ryzyko | P | I | Wyzwalacz | Mitigacja | Właściciel |
|---|---|---|---|---|---|---|
| R-07 | **Scope creep** — P1, FTKEY, **QSX/VM**, `[N]`, UI wchodzą do P2 | H | M | nowe zadania bez WP | claims register + gates + D-023 (QSX out) + decyzja właściciela | prowadzący |
| R-08 | **Fałszywe claims** — „threshold gotowy” w komunikacji | M | H | publikacja bez rejestru | claims register, review przed publikacją | prowadzący |
| R-09 | **Brak HSM/TPM** — soft-seal w produkcji | M | H | G5 bez HSM | D-013; HSM od G3 | W13 |
| R-10 | **Złożoność protokołu** — za dużo rund/stanów | M | M | testy chaosu fail | spec-first, model checking, uproszczenie | W1/W11 |
| R-11 | **MPC `G(seed*)` (B′) nie domyka się** — obwód keygenu/rejection jest za drogi lub błędny | H | H | O-16 bez implementacji; zły `pk` | badania W4; zero-test O-04; stop-and-report; jawna decyzja o zmianie zakresu | W4 |
| R-12 | **Zależność od jednej osoby** — cała wiedza w jednym oknie | M | M | brak handoffu | WORK_STATE, dokumenty, review | prowadzący |
| R-13 | **Flaky testy/IO** — jak F-18 w spiku | M | M | niestabilne CI | deterministyczne harnessy, `--test-threads=1`, retry z raportem | W2 |
| R-14 | **Zły nonce/fault** — deterministyczny nonce, replay | M | M | atak na sesję | hedged nonce, sesja/epoka, testy | W9 |
| R-15 | **Regulacje/compliance** — krypto, eksport, certyfikacja | L | M | wymóg klienta | wczesna analiza, FIPS później | właściciel |

## Średnie / operacyjne

| ID | Ryzyko | P | I | Wyzwalacz | Mitigacja |
|---|---|---|---|---|---|
| R-16 | Operatorzy nie stosują ceremonii | M | M | błąd ludzki | checklisty, kworum, szkolenie |
| R-17 | Brak testu odtworzenia backupu | M | H | DR fail | ćwiczenie DR w G5 |
| R-18 | Logi zawierają sekrety | L | H | skan logów | `ft-secrets-hygiene`, redakcja, test |
| R-19 | Nieaktualne piny/KAT po zmianie silnika | M | M | zmiana `ft1536-sys` | pin + re-run KAT |
| R-20 | Zbyt późne wykrycie buga w audycie | M | H | audyt na końcu | audyt ciągły, scope w G2 |
| R-21 | **Utrata tokena/HSM blokuje node** (B′: token = brama KEK) | M | M | brak tokena przy podpisie | co najmniej 2 nody sprawne; procedura wymiany tokena; backup pieczęci wg O-21 |

---

## Reguła eskalacji

Ryzyko krytyczne (R-01…R-06) materializujące się = **stop-and-report**
do właściciela. Nie kontynuujemy „na około”, nie zmieniamy claimu bez decyzji.
