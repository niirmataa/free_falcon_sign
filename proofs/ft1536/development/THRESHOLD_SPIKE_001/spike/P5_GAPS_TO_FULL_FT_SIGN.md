# P5 — luki do pełnego progu podpisu FT1536

| Element | Mamy w spiku | Brak do pełnego FT sign |
|---|---|---|
| Próg udziałów k-z-n | 2-z-2, 2-z-3, 3-z-5 | — |
| Wyprowadzanie | G_frag 64 B, native 128 B, nonce 40 B | prawdziwy obwód `G(seed*)` (L1 XOF + L3 NTT) |
| Sampler | Gaussa + probed accept + select | **Klein 73-bit**, rejection bias (P0.1) |
| Sygnatura | `sygnet_synthetic` 32 B (nie podpis) | **tor sign FT1536** (f,g,F,G / F04-F05) |
| Weryfikacja | — | pojedynczy weryfikator FT1536 |
| Bezpieczeństwo | semi-honest, dealer testowy | DKG, SPDZ-MAC, UC/2026-1300 |
| Piny | syntetyczne | packet/env R1 (ans 4–6) |

## Porządek prac (kolejka P kontynuacja)
1. Klein-lite 3-krokowy (P3) → pomiar rund
2. Obwód `G(seed*)` slice (NTT butterfly na udziałach wg M4)
3. Porównanie z 2026/1300 + F04 (TT-43)
4. Pełny tor sign tylko gdy powyższe domknięte

**Nie deklarować „próg gotowy".**
