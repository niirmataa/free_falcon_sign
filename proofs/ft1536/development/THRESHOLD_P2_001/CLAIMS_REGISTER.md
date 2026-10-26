# CLAIMS REGISTER — co wolno twierdzić

**Zasada:** twierdzenie bez dowodu nie jest twierdzeniem. Statusy:
`PROVEN` (dowód/checker), `TESTED` (testy w scope), `ASSUMED` (jawna przesłanka),
`OPEN` (brak dowodu), `FORBIDDEN` (nie wolno używać w komunikacji).
Każdy wpis ma właściciela i datę przeglądu.

---

## 1. Twierdzenia dozwolone dziś (spike, nie P2)

| ID | Twierdzenie | Status | Dowód | Właściciel |
|---|---|---|---|---|
| C-001 | Spike 001 ma 414/414 testów i złoty łańcuch `z udziałów f,F → s1,s2 → engine verify` | **TESTED** | `THRESHOLD_SPIKE_001/REPORT.md`, pin F2 `103747771` | koordynator |
| C-002 | W spiku fałszywe udziały/otwarcia są wykrywane fail-closed w zadeklarowanym zakresie | **TESTED** | `Y13_MALICIOUS_MAP.md`, macierz testów | koordynator |
| C-003 | Spike nie jest threshold signingiem | **PROVEN** (brak pełnego, bezpiecznego ffSampling/Kleina i modelu złośliwego) | `P5_GAPS`, `BOUNDARY_*` | koordynator |

## 2. Twierdzenia P2 — status docelowy

| ID | Twierdzenie | Status | Warunek zamknięcia |
|---|---|---|---|
| C-101 | Protokół jest poprawny: każda uczciwa koalicja ≥k kończy z poprawnym podpisem | **OPEN** | G2/G3 + KAT |
| C-102 | Klucz nigdy nie istnieje w całości | **OPEN** | G2 (brak reconstruct) + audyt kodu |
| C-103 | Protokół jest malicious-secure do t=k−1 | **OPEN** | G4 dowód |
| C-104 | Setup jest publicznie weryfikowalny | **OPEN** | G2 DKG transcript |
| C-105 | Abort jest identyfikowalny | **OPEN** | G2/G4 |
| C-106 | Refresh zachowuje `pk` i unieważnia stare udziały | **OPEN** | G5 |
| C-107 | Implementacja jest odporna na znane ataki z macierzy | **OPEN** | G2/G4 |
| C-108 | Brak wycieku side-channel w zadeklarowanym modelu | **OPEN** | G4 |
| C-109 | Build jest reprodukowalny i pinowany | **OPEN** | G1/G5 |
| C-110 | Podpis jest byte-compatible z `ft1536-sys` | **OPEN** | G3 KAT |

## 3. Twierdzenia zakazane (FORBIDDEN)

| ID | Zakazane sformułowanie | Dlaczego | Zamiennik |
|---|---|---|---|
| F-01 | „threshold FT1536 gotowy” | brak ffSampling/Kleina/dowodu | „prototyp badawczy, zakres X” |
| F-02 | „klucz nigdy nie istnieje” (o spiku/P1) | dealer/„moment” w spiku; P1 rekonstruuje | „w torze X po bramce Y” |
| F-03 | „malicious-secure” | brak dowodu i pełnych auth triples | „semi-honest + detekcja” |
| F-04 | „`G_frag` = `G(seed*)`” | to nieprawda | „liniowy stand-in, nie R1” |
| F-05 | „bezpieczny kryptograficznie” | brak dowodu bazy | „testy w scope, brak proofu” |
| F-06 | „produkcyjny” | brak G4/G5 | „research prototype” |
| F-07 | „2-of-2 to próg” | quorum „obaj albo nikt” | „2-of-3/3-of-5” |
| F-08 | „UC-secure” | brak dowodu | „cel: UC, status OPEN” |
| F-09 | „zero-knowledge” bez definicji | brak formalizacji | „brak claimu” |
| F-10 | „post-quantum threshold” | brak analizy QROM | „klasyczny model” |
| F-11 | „P2 działa w QSX/VM” / „threshold w efemerycznej VM” | D-023 wyłącza QSX/VM z P2; próg nie potrzebuje VM | „P2 = osobne nody z udziałami, bez QSX” |

## 4. Reguły publikacji

1. Każdy tekst zewnętrzny (paper, README, post) przechodzi przez ten rejestr.
2. Status `OPEN` nie może być prezentowany jako `PASS`/`PROVEN`.
3. Retained failures muszą być widoczne w tym samym dokumencie co claim.
4. „Scope” musi być wyrażony parametrami (k,n,model,platforma,wersja).
5. Brak wpisu = brak zgody na twierdzenie.

## 5. Przegląd

- Przegląd rejestru: po każdym milestone i przed każdą publikacją.
- Właściciel: prowadzący tor; zatwierdza: właściciel projektu.
- Data ostatniego przeglądu: **2026-10-26** (G0).
