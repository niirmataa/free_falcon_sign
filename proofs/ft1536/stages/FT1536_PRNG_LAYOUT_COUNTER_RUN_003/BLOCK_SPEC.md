# BLOCK_SPEC — exact ChaCha20 block / refill4096

Źródło: `refill_chacha20` (frng.c:200–278). Model: `falcon_block` /
`falcon_refill` w `model/prng_model.sage` (sekcja C); druga strukturalnie
odmienna implementacja `refill_spot` w checkerze (spot cross-check F0/F5).

## Blok

- `state[0..3] = CW = 61707865, 3320646e, 79622d32, 6b206574`;
  `state[4..15] = saved[0..11]` (12 stream words).
- XOR licznika (frng.c:222–223): lanes 14/15 (patrz LAYOUT.md: offsets 40..47).
- 20 rund = 10 double rounds w literalnym schedule QROUND (frng.c:224–252):
  column `(0,4,8,12),(1,5,9,13),(2,6,10,14),(3,7,11,15)`, diagonal
  `(0,5,10,15),(1,6,11,12),(2,7,8,13),(3,4,9,14)`; quarter-round: adds
  modulo 2^32, XOR, rotacje 16/12/8/7 w formie `(x<<s)|(x>>(32−s))`.
- Feed-forward: lanes 0..3 += CW; 4..13 += saved[0..9];
  14 += saved[10]^cc_lo; 15 += saved[11]^cc_hi (frng.c:254–263).
- Serializacja little-endian, 16 słów → 64 bajty (frng.c:266–275; memcpy na
  hoście LE; gałąź jawna LE w wariancie `FALCON_LE_U=0`).

## Refill4096

`for (u = 0; u < 4096; u += 64)`: dokładnie 64 bloki; blok k z licznikiem
(cc0+k) mod 2^64; po pętli `state.d[48..55] = cc0+64 mod 2^64` (frng.c:277).

## KAT rdzenia (zakres!)

5 wektorów IETF z niezależnego oracle OpenSSL CLI (`enc -chacha20`) plus
dosłowne literały RFC 8439 §2.3.2 i classic all-zero (oba muszą zgadzać się
z OpenSSL, inaczej generacja pada). Waliduje WSPÓLNĄ arytmetykę Word32 rund,
nie layout Falcona (IETF: counter w st[12], nonce st[13..15], standardowy
feed-forward — odmienny od Falcona). Wszystkie 5 match w modelu Sage.

## Mutacje bloku

Lane12/13 zamiast 14/15; XOR→ADD modulo 2^32; licznik 32-bitowy (stan 15
nietykany, advance mod 2^32); pominięty initial refill; feed-forward bez XOR
licznika (standard-ChaCha); serializacja BE — wszystkie KILLED (z jawnymi
klasami równoważności low-counter). No-op: LE-sklep per-byte i kolejność
feed-forward — NO_OP na wszystkich 7 fixtures. Szczegóły: `artifacts/mutations.json`.
