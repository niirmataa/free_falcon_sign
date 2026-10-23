# Spike 006 — integralność accept-shares + bias abort/retry

**Status: PROTOTYP.** Domknięcie dwóch luk ze spike 005.

## 1. Fail-closed na accept-shares (`select_first_accepted_checked`)

| Kontrola | Mechanizm | Błąd |
|---|---|---|
| spójność Shamir (n>k) | `verify_consistency` na każdym wierszu x i a | `InconsistentShare` |
| bitność accept | `a*(a+1)` → otwarcie produktu kontrolnego == 0 | `NonBitShare` |

- Otwarty jest **tylko** produkt kontrolny `a(a+1)` (0 dla bitów), **nie** bity accept.
- Fałszywy udział accept → **Err**, nie cichy zły wynik (wymóg P0.4-style).

## 2. Bias abort/retry (`measure_abort_retry_bias`)

- `single`: jedno okno, warunek na Accepted.
- `retry`: powtarzanie okna przy `AllRejected` do skutku.
- Metryka: TV (add-1 smoothing) między `x|accept` retry vs single +
  `mean_windows_per_success`.

**Retained finding F-11 (przegląd `explore` + pomiar):**
hipoteza „retry biasuje x vs single-accepted" jest **obalona** dla i.i.d. okien
— oba oszacowują ten sam rozkład `x | accept` (TV ≈ 0).
Bias jest względem rozkładu **docelowego** (nie warunkowanego na accept) —
patrz `BiasReport.max_rel_err` w spike 005; to jest właściwy kierunek
rozliczenia. `mean_windows_per_success > 1` przy małym `t_max` potwierdza
koszt retry (wiele okien na sukces).

## Wynik: 38/38 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 28 unit + 10 integration: ALL PASS
```

| # | Test | Twierdzenie |
|---|---|---|
| s6_checked_accepts_honest_bits | checked == clear oracle | PASS |
| s6_nonbit_accept_rejected | a=2 → `NonBitShare` | PASS |
| s6_forged_accept_share_detected | fałsz udziału → `InconsistentShare` | PASS |
| s6_abort_retry_bias_smoke | TV≈0 (F-11), retry > 1 okna | PASS |

### Przegląd `explore` (spike 006)

| Ustalenie | Status |
|---|---|
| bitność otwiera tylko `a(a+1)` | potwierdzone |
| fałsz accept → fail-closed (n>k) | potwierdzone |
| `NonBitShare` przy a=2 | potwierdzone |
| cap 10_000 zawyżał `mean_windows` | **naprawione** |
| hipoteza retry-bias vs single | **obalona (F-11)** |

## Ograniczenia

- Bitność przez otwarcie `a(a+1)` — jedno otwarcie na kandydata (produkt=0).
- Spójność działa tylko przy n>k (3 przy k=2).
- Dealer = model testowy; brak SPDZ-MAC.
- Bias mierzony na clear-oracle oknie (shared select jest równoważny — s5).
- Nie jest to Klein / `G(seed*)` / threshold FT.
