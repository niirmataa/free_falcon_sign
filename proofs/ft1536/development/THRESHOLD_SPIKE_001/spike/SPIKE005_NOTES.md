# Spike 005 — accept-bit bez otwierania + bias okna (ciąg P0.1)

**Status: PROTOTYP.** Nie Klein-sampler, nie pełne malicious-secure MPC.

## Co robi (`src/select.rs`)

Obwód „pierwszy przyjęty" **na udziałach** GF(256), Shamir 2-z-3 + Beaver:

```
t       = a_i * (1+found)      // weź iff accept i jeszcze nic
sel    += t * (x_i + sel)
found  += a_i + found * a_i    // OR bitów
```

- **Nie otwiera** bitów `a_i` w pętli (w odróżnieniu od `sample_mpc_naive`).
- Jawne na końcu: **finalny `x`** (kontrakt: to jest wynik) oraz **1 bit `found`**
  (trafione okno vs `AllRejected`).
- Dealer = model testowy (buduje udziały kandydatów i accept-bits).

API: `select_first_accepted_shares` → `SelectShares` → `open_selected`.
`measure_fixed_window_bias` — pomiar rozkładu / AllRejected / max rel. error.

## Wynik: 34/34 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 24 unit + 10 integration: ALL PASS
```

| # | Test | Twierdzenie |
|---|---|---|
| s5_select_matches_clear_first_accepted | shared == clear oracle | PASS |
| s5_first_accept_wins | pierwszy accept wygrywa | PASS |
| s5_all_rejected_flag | found=0 przy pustym accept | PASS |
| s5_opened_select_contract | otwarcie tylko (x, found) | PASS |
| s5_encode_range_guard | \|x\|≤127, brak kolizji sentinelu | PASS |
| s5_bias_report_smoke | mały `t_max` ⇒ AllRejected > 0 | PASS |

### Przegląd niezależny (`explore`) — ustalenia i poprawki

| Ustalanie | Status |
|---|---|
| obwód nie otwiera `a_i` (tylko d,e z Beavera) | **potwierdzone** |
| algebra bitów GF(256) (1+found, OR, mux) | **poprawna** |
| kolejność found-then-update (inaczej t≡0) | **poprawna** |
| placebo test `s5_api_hides_accept_trace` | **naprawiony** → `s5_opened_select_contract` |
| sentinel `x==0` vs `encode_candidate(-128)` | **naprawiony**: `w<=127` guard, `found` jako jedyny sygnał |
| niezerowane pośrednie `Vec` | **naprawione**: `Zeroizing` na `t`, `d/e`, `x+sel` |
| brak bitness/`verify_consistency` na accept | **ograniczenie** (model dealerski) — w RESEARCH |

## Jawność (uczciwie)

| Kanał | Jawny? |
|---|---|
| per-try accept bits | **NIE** (to była poprawa vs spike 004) |
| finalny x | TAK (jawny wynik kontraktu) |
| bit found / AllRejected | TAK (1 bit okna) |
| d,e z Beavera | TAK (maski — nie bity accept) |
| T (liczba prób) | N/A — okno stałe `t_max`, brak pętli |

## Bias okna

`measure_fixed_window_bias`: warunkowanie na `Accepted` (odrzucanie
`AllRejected` i powtórka całego okna) **warunkuje rozkład x** — raport
`max_rel_err` vs waga docelowa. To jest bias do rozliczenia w protokole
(kiedy wolno abort/retry). Wartości z pomiaru w testach smoke — nie jest to
dowód bezpieczeństwa.

## Retained / ograniczenia

- Dealer zna `x` i `a` przy generacji udziałów (model testowy).
- Bity jako bajty GF(256) {0,1} — OR przez `a+b+a*b` (inwariant bitowy).
- `found` jawny na końcu = 1 bit wycieku o oknie (rozliczone, nie ukryte).
- Nie jest to Klein, nie 73-bit precision, nie F04/F05.
- **Subagent `general-2` (ultra) utknął** (F-05 pattern) — kod pisany w wątku;
  przegląd niezależny przez `explore`.
