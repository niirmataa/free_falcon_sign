# Spike 014 / TT-40 — Klein-lite (dyskretna Gaussa)

**Status: PROTOTYP / pomiar.** Nie Klein 73-bit, nie ATMACA.

## Co jest

| API | Opis |
|---|---|
| `gauss_weight_pub` | W(x)=256/(1+x²/σ²)² — approx exp(-x²/2σ²) |
| `sample_gaussian_clear` | rejection z wagą Gaussa |
| `target_gauss_absx_pmf` / `measure_gauss_vs_target` | TV vs target |
| `draw_gauss_window` + select | accept-bity Gaussa **bez otwierania** (spike 005) |

## Wynik: 68/68 PASS

| # | Test | |
|---|---|---|
| g1–g4 | waga malejąca, PMF=1, TV<0.2, zakres | PASS |
| gs1 | shared select == clear (okno Gaussa) | PASS |

## Granice

- Waga to **nie** exp — inna rodzina rozkładów niż Klein/Falcon.
- Brak fixed-point 73-bit, brak f,g,F,G, brak toru R1 `G(seed*)`.
- Accept-bity z dealera (model testowy) — nie z porównania MPC.

## Następnie (TT-41/43)

- accept-bit bez dealera (porównanie na udziałach)
- zgodność F04/F05 z 2026/1300
