# LAYOUT — 56-bajtowa mapa init i dispatch typów

Pinned: `source/frng.c` (`4b1289ad…`), `source/internal.h` (`512629d3…`),
ABI GCC14.2/C99/x86_64 LP64 (`sizeof(prng)=4368`, `alignof=8`, offsets
buf 0 / ptr 4096 / state 4104 / type 4360; `sizeof buf=4096`, `sizeof state=256`
— asercje statyczne harnessu + piny checkera). Maszyna: `model/prng_model.sage`
(sekcja D), checker `layout.*`.

## Mapa stream bytes (little-endian)

| Offsets | Słowa stanu | Rola |
|---|---|---|
| 0..31 | state[0..7] | key (8× Word32) |
| 32..47 | state[8..11] | IV (4× Word32) |
| 48..55 | — | Word64 cc0 (initial counter) |

Gałąź `FALCON_LE_U=1` (ten build): `shake_extract(src, state.d, 56)`.
Gałąź `=0`: jawny LE-skład 14 słów + odbudowa `tl + (th<<32)` (frng.c:296–316).
Na hoście LE obie dają te same wartości/bujty (kontrola altbranch).

## XOR lanes licznika

`state[14] ^= cc mod 2^32`, `state[15] ^= cc >> 32` (frng.c:222–223) —
offsets **40..47** (słowa 10/11 strumienia = OSTATNIE 8 bajtów pola IV 32..47),
NIE offsets 32..39. Feed-forward dodaje `saved[10]^cc_lo` / `saved[11]^cc_hi`
(frng.c:261–264). Komentarz frng.c:198 („pierwsze 8 bajtów IV") vs instrukcje:
FINDING, bez zmiany C.

## Dispatch i kolejność

`type 0 → PRNG_CHACHA20 (1)`; jawne 1 akceptowane (type_equivalence: identyczne
state/buf); każdy inny `int` → `return 0` przed zapisem i przed extractem
(kontrole {2,3,−1,99,1048576}: 0 wywołań extractu, cały `prng` w poisonie).
Kolejność: extract 56 B → `p->type = type` → initial refill → `ptr = 0` →
return type. Nie zakładamy cc0 = 0 (fixtures mają 0 … 2^64−1).

## Ramka i alignment

Init pisze state.d[0..55]; refill: buf.d[0..4095], state.d[48..55], ptr=0;
state.d[56..255] nigdy (poison 0xA5 na każdym stage). Unie z `uint64_t dummy`
dają 8-byte alignment; casty u32 (offsets 4i) i u64 (48/52) są wyrównane.
Szczegóły ramki: COUNTER_AND_FRAME.md. Maszynowa tabela: LAYOUT.json.
