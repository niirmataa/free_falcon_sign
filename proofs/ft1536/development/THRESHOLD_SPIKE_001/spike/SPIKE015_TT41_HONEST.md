# TT-41 — uczciwy kontrakt (po audycie)

**API:** `accept_bit_from_u_opened` (dawniej `share_accept_bit_from_u`).

| | |
|---|---|
| Wejście | udziały u, publiczny próg w |
| **MOMENT** | `reconstruct(u)` w torze (jawne u) |
| Wyjście | udziały bitu a = 1{u < w} (re-deal) |
| Nie jest | porównaniem MPC bez otwierania u |

Granice: `u==w` → 0 (test), `w>255` → `WrongThreshold`.
Otwarte: porównanie na udziałach (TODO TT-41).

**Po tym spiku:** 113/113 PASS, 0 warn.
