# FT1536 — tożsamość wariantu (mapa twarda)

**FT1536 = autorski wariant właściciela** (nie standard Falcon / FN-DSA):
sekrety **ternarne** (coefficient-domain), pierścień historycznej linii
ternarnej FREE Falcon.

## Parametry (SOURCE: `FREE_FALCON.md`, `Extra/c`)

| Parametr | Wartość |
|---|---|
| **q** | **18433** (NIE 12289 — to standardowy Falcon) |
| **N** | 1536 (`logn=10`, doświadczalny checkpoint) |
| **Pierścień** | `R = Z_q[X] / (X^1536 - X^768 + 1)` |
| **Secret** | **ternarny** (TRUE_TERNARY_SECRET; fixed-weight n/3+1, n/3−1, n/3 zero w wariancie 2) |
| **NTRU** | `fG - gF = q = 18433` |
| **pk** | 2881 B (encode 18433) |
| **sk** | 7681–10369 B (bufor Fin 10370) |
| **logn=9** | N=768, q=18433 — historyczny punkt publiczny |

## Kod C

- `mq_div_18433`, `falcon_encode_18433` / `falcon_decode_18433`
- `mq_NTT_ternary`, `mq_mkgm3`, `TRUE_TERNARY_SECRET`
- `solve_NTRU*`, CRT na prime'ach ternary (`p ≡ 1 mod 2304`)

## Implikacja dla MPC (MPS)

- Arytmetyka progowa sign = **Shamir / addytywne nad Z_18433**, nie GF(256).
- GF(256) zostaje dla SHAKE/MAC/BAJTÓW; **q-arytmetyka** dla f,g,F,G, NTT, s.
- Nie używać 12289 ani parametrów Falcon-512/1024.

*Zmapowane po korekcie właściciela 2026-10-21 („FT1536 = mój autorski
wariant z secretem ternarnym").*
