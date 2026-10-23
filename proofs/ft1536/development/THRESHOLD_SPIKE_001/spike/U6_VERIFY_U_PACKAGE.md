# U6 — weryfikacja pakietu U1–U5 (okno główne, retained fallback)

**Data:** 2026-10-21. **Retained F-U6-1:** ultra-WERYFIKATOR (`general-25`)
**anulowany** po 19 turach (wzorzec F-05/09/20 / F-Y5-1). Weryfikacja
w oknie głównym — **nie** niezależny kontekst.

## Protokół 5-punktowy (okno główne)

| # | Punkt | Wynik | Dowód |
|---|---|---|---|
| 1 | Kryteria U1–U5 | **PASS** | U1 (`u1d_*`: Bernoulli, piny, freq, overflow); U2 (`u2d_*`: NTT 768/765/512, NTRU FAIL); U3 (`u3_*`: EntryPin SHA-256, evaluate=None); U4 (`u4_*`: auth triple + MAC mul tamper); U5 paper JEST/NIE |
| 2 | Zakres IN/OUT | **PASS** | klein.rs, mul.rs, lib.rs, W4_PAPER.md; Obrazy/ nietknięte |
| 3 | Markery | **PASS** | clean rebuild: 0 `warning:`; 262/262 |
| 4 | Testy realne | **PASS** | TV vs analityka (nie własna waga); NTRU wrong-const `assert!(!ok)`; MAC/triple tamper → MacFail; evaluate stub = None |
| 5 | Powtórka | **PASS** | `u2d_full_chain_counts_match_m4` + `u4_auth_triple_ok` → ok |

**Suita:** 238 lib + 14 iso + 10 spike = **262/262** (iso: serial po F-18).

**Twierdzenia (RECENZENT skan):** brak „próg FT gotowy / Klein 73-bit /
malicious-secure / G(seed*) gotowe" — jedynie zakazy w `W4_PAPER.md`
i `SECURITY_POSITION`. `evaluate_gseed_stub` = `None` (OPEN, fail-closed).

## Granica tego odbioru

**Nie** jest to niezależny ultra-Y6 (F-U6-1). U1 i U2 miały osobne PASS
od `general-22` / `general-24` po CHANGES; U3–U5 — to okno.

## Trzy zdania

1. **Wykazane:** pakiet U1–U5 spójny — Klein Q73, NTT M4, EntryPin,
   auth triples, paper; 262/262, 0 warningów.
2. **Brak:** niezależnego ultra-U6 (anulowany); formalnego G(seed*);
   pełnego Kleina; UC.
3. **Nie implikuje:** progu FT ani zmiany SAFE-FOR-RESEARCH.
