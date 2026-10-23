# Y5 — weryfikacja pakietu Y1–Y4 (okno główne, retained fallback)

**Data:** 2026-10-21. **Retained F-Y5-1:** ultra-WERYFIKATOR (`general-18`)
**anulowany** po 7 turach (wzorzec F-05/09/20). Weryfikacja w oknie
głównym jako jawny fallback — **nie** niezależny kontekst.

## Protokół 5-punktowy (okno główne)

| # | Punkt | Wynik | Dowód |
|---|---|---|---|
| 1 | Kryteria Y1–Y4 | **PASS** | Y1/Y2 FIPS bit-exact (`y1_shake256_*`, `y2_msg_*`); koszt 38400/76800 (`y1_cost_*`, `y2_cost_*`); Y3 derive == oracle (`y3_derive_matches_shake_local_oracle`) i ≠ stand-in; Y4 siatka vs f64 (`y4_weight_matches_f64_exp_grid`) + TV vs analityka (`y4_sample_vs_analytical_tv`) |
| 2 | Zakres IN/OUT | **PASS** | shake.rs + rejection.rs + SpikeError/moduł; OUT (Obrazy/, inne craty) nietknięte |
| 3 | Markery | **PASS** | clean rebuild: 0 `warning:`; product path bez unwrap/panic (unwrapy tylko w testach) |
| 4 | Testy realne | **PASS** | FIPS vs obcy `sha3` + RFC vector; Q73 vs f64 exp (nie vs własna waga); TV vs **analityczna** PMF |
| 5 | Powtórka dowodu | **PASS** | `y1_shake256_empty_matches_fips_clear` + `y4_sample_vs_analytical_tv` → ok |

**Suita:** `cargo clean -p` + `cargo test --manifest-path spike/Cargo.toml`
→ **201/201** (178 lib + 13 iso + 10 spike), 0 failed, 0 warnings.

**Twierdzenia:** akta Y1/X1§Y4 jawnie przeczą „próg FT / Klein gotowy /
bezpieczny klucz" (`BOUNDARY_NO_FULL_MATERIAL.md` NIE). Spójne z
`SECURITY_POSITION` (wymagania bezpieczeństwa nadal otwarte: SPDZ-MAC,
model złośliwy, R1 pins, pełny Klein MPC).

## Granica tego odbioru

To **nie** jest niezależny WERYFIKATOR (F-Y5-1). Y1/Y2/Y3 miały
wcześniej **osobne PASS** od `general-15/16/17`; Y4 — wyłącznie to okno.
Pełny Y5 (ultra + RECENZENT) zostaje otwarty do powtórki przy stabilnym
subagencie.

## Trzy zdania

1. **Wykazane:** pakiet Y1–Y4 zielony i spójny — realny SHAKE256 na
   udziałach (FIPS), derive z domeną, Q73 + bias vs analityka; 201/201.
2. **Brak:** niezależnego ultra-Y5 (subagent anulowany) i pełnego Klein MPC.
3. **Nie implikuje:** progu FT ani zmiany werdyktu `SECURITY_POSITION`.
