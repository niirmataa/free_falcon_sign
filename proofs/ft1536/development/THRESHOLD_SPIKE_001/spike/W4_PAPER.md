# W4 / U5 — paper (szkic 2-stronny, rolling)

**Status: szkic.** Zakres twierdzeń szczery — spike, nie próg FT.

## 1. Problem

Współdzielone klucze FT1536: jak wyprowadzać materiał i podpisywać
bez rekonstrukcji sekretu w jednym procesie?

## 2. Architektura (wariant B — udział seeda)

- **L0** seed* w Shamir k-z-n (DKG / re-deal; bez `seed.bin`)
- **L1** prawdziwy SHAKE256 na udziałach (Keccak-f χ = 38400 muls/perm)
- **L2** sampler: wagi Q73 + accept-bit (cmp) + Klein-lite bit-by-bit
- **L3** algebra: NTT (768/765/512 butterfly, M4 SOURCE), fG−gF=18433
- **L4** packet: pk 2881 / sk ≤10370 (kontrakt; evaluate OPEN)

## 3. Bezpieczeństwo (zakres)

| Jest | NIE jest |
|---|---|
| SPDZ-MAC ukryte δ, DKG δ | pełne malicious-secure / UC |
| Auth triples + MAC na mul | autentykacja każdej linii MPC |
| FIPS SHAKE na udziałach | G(seed*) formalne (R1 OPEN) |
| Q73 + TV vs analityka | Klein 73-bit z 2026/1300 |
| Fail-closed (abort) | odporność na DoS / kanały boczne |

## 4. Koszt (rzędy wielkości)

- G_frag 64 B: 64 reshare-muls
- SHAKE256: 38 400 AND/perm ≈ 10³ × G_frag
- accept-bit: 255 Beaver/bit (I1)
- NTT first+mid+triple: 768+765+512 butterfly (scalar model)

## 5. Wnioski i otwarte

Share-native derive + real XOF + MAC/δ jest wykonalne i testowalne.
Pozostaje: R1 evaluate/piny, pełny Klein, F04 solver (regiony 3–4),
model złośliwy w pełni. **Nie deklarować „próg FT gotowy".**

*Dowody: TESTS.md (262), Y1–U4, SECURITY_POSITION, FAILURES F-01..F-23.*
