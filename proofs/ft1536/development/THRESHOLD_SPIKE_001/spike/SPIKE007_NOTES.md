# Spike 007 — bias vs target + wektory deterministyczne

**Status: POMIAR / PROTOTYP.** Domknięcie pomiarowe P0.1.

## Co robi (`src/rejection.rs` — sekcja Spike 007)

Po F-11 (retry vs single = ten sam `x|accept`) **prawdziwy** bias P0.1 to
odchylenie `x|accept` od **rozkładu docelowego**:

| API | Twierdzenie |
|---|---|
| `target_absx_pmf(w, σ²)` | PMF \|x\| ∝ (liczba punktów) × `accept_weight` |
| `measure_vs_target` | TV + `max_rel_err` empirii vs target |
| `deterministic_vector(seed, p, n)` | powtarzalny wektor `sample_clear` |
| `vector_fingerprint` | pin FNV-1a wektora do akt |

## Wynik: 42/42 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 32 unit + 10 integration: ALL PASS
```

| # | Test | Wynik |
|---|---|---|
| s7_target_pmf_sums_to_one | PMF normalizacja | PASS |
| s7_bias_vs_target_small_tv | TV < 0.15 przy 2k próbkach | PASS |
| s7_deterministic_vector_stable | ten sam seed → ten sam wektor | PASS |
| s7_vector_fingerprint_pin | fingerprint ≠ 0 (pin w aktach) | PASS |

## Odczyt

- Rejection ważone **dąży** do target (TV mały) — potwierdza model akceptacji.
- Wektory deterministyczne (`StdRng::seed_from_u64`) — pod hash-pin w RESEARCH
  (zadanie 14); zmiana modelu akceptacji zmieni fingerprint.
- To **nie** jest Klein ani 73-bit Gauss — to siatka `accept_weight` stand-in.

## Otwarte (po tym pomiarze)

- bias dla **właściwego** dyskretnego Gaussa / Kleina (waga nie jest `exp`)
- F04/F05 vs 2026/1300, `G(seed*)` z R1
- warunkowanie abort/retry **vs target** (nie vs single) przy wyższym `t_max`
