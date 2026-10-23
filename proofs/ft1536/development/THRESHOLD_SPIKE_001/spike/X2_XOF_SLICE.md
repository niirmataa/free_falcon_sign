# X2 — XOF multi-block squeeze stand-in (NIE SHAKE)

**Status: STAND-IN / koszt.** To **nie jest SHAKE/Keccak** i nie twierdzi
zgodności z FIPS 202 ani `G(seed*)` z toru R1. Algebraiczny łańcuch GF(256)
w stylu `G_frag` — w miejscu XOF-a. Koszt prawdziwego XOF: `I3_SHAKE_MPC_COST.md`.

## Czym to jest

| Element | Decyzja |
|---|---|
| API | `xof_squeeze_blocks(rng, seed_shares, n_blocks, xs, k) -> Vec<Vec<Share>>` |
| Blok | **32 B** (`XOF_BLOCK_LEN`); 4 bloki = 128 B (testy) |
| Wzorzec | `block[i]=state[i]⊕(state[i+1]⊗state[i+7+b])`; `state[i]⊕=block[i+3]⊕block[i+11]` |
| Mul na blok | **32** `mul_shamir_reshare` (`XOF_MULS_PER_BLOCK`); absorb liniowy = 0 |
| Koszt | **blocks × 32 muls** (licznik `cost::bump_reshare`; 0 Beaver) |
| Otwarcie | tylko jawny kontrakt `open_xof_byte` (k udziałów); 1 udział = `InsufficientShares` |

Układ wyjścia jak `G_frag`: wiersz = bajt, `Share` per strona; blok `b`
zajmuje bajty `[b*32..(b+1)*32)`. Tor **nie otwiera** seeda ani bloków.

## Dlaczego nie SHAKE (i co zostaje z kontraktu)

- Realny SHAKE w MPC = Keccak-f[1600] na udziałach: ~**4×10⁴ AND/perm**
  (= tyle Beaver triples) + ~25–50 rund głębokości (I3 §1–2).
- Stand-in ma **32 reshare-muls / 32 B** i 0 triples — rząd G_frag,
  nie permutacji. Służy do pomiaru kosztu i testów toru progowego,
  **nie** do produkcji klucza.
- Kontrakt „klucz nigdy w całości" **przetrwa** oba tory (udziały do końca);
  zmienia się tylko cena i wierność wobec `G(seed*)`.

## Koszt vs I3 (10³×/perm)

| tor | muls / triples | na 32 B | na 4 bloki (128 B) |
|---|---|---|---|
| X2 stand-in | 32 reshare-muls | 32 | **128** |
| `G_frag` (I1) | 64 reshare-muls / 64 B | 32 | 256 (2× G_frag) |
| SHAKE256 (I3) | ~4×10⁴ triples / perm | ~10⁴* | ~10⁴* (rate 136 B) |
| **SHAKE / X2** | **~10³ ×** (per perm, I3) | ~10³ | ~10²–10³ |

\* rate 136 B = ~4 bloki na permutację; multi-blok ponad rate = kolejne perm
(liniowo). 10⁸ bramek z ballparku = pełny `G(seed*)` bit-blast + XOR-count,
nie jeden squeeze (I3 §2).

Pin kosztu: `x2_cost_is_blocks_times_muls` (1/4/7 bloków = 32/128/224 reshare;
0 Beaver).

## Co byłoby potrzebne dla prawdziwego XOF

1. **Keccak-f[1600] na udziałach** (lub GC/SPDZ): theta/rho/pi/iota liniowo;
   chi = ~1600 AND2/rundę × 24 rundy; batch na rate 136 B.
2. **Pad/domena** FIPS 202 (SHAKE256 `0x1F` + padding) — bit-exact vs
   jawne SHAKE; stand-in tego **nie ma**.
3. **Squeeze incrementalny** w udziałach (bez otwierania stanu) — kontrakt
   „n bloków" jak tu, ale permutacja zamiast mul-shake.
4. **Preprocessing** triples ~4×10⁴/perm (I1 licznik `bump_triple`) +
   runda-komunikacja = głębokość ~25–50, nie liczba muls.
5. **Wiązanie z R1** (`G(seed*)` = KeygenByteGame134): czy kontrakt wymaga
   dokładnie SHAKE, czy dopuszcza mapę algebraiczną (pytanie I3 §4).
   Bez odpowiedzi: X2 = pomiar kosztu, nie podmiana SHAKE.

## Testy (green, `tests_x2` w `src/xof.rs`)

- `x2_oracle_per_block` — 4 bloki vs `xof_squeeze_local` (per bajt)
- `x2_one_share_insufficient` — 1 udział → `InsufficientShares`
- `x2_cost_is_blocks_times_muls` — 1/4/7 bloków = 32/128/224 reshare; 0 Beaver
- `x2_local_pattern_pin` — determinizm + FNV `0x03446e0f55c52dd4` (pat=0xA5, 4 bloki)
- `x2_share_level_stable_pin` — StdRng `0xC0FFEE`, 2 bloki, pat=0x5A,
  FNV `0xf330a4077be3921f`
- `x2_guards_fail_closed` — 31-bajtowy seed / zła kolumna → `PartyCountMismatch`

## Retained findings (X2)

1. **Brak Clone na `Share` (H-31):** kopiowanie w testach guardów przez
   jawne `Share { x, share }` — Drop-zeroizacja zostaje nienaruszona.
2. **Pin share-level zależy od kolejności RNG** (deal w `split_seed` + muls):
   zmiana modelu lub liczby mul = zmiana pinu; oracle lokalny jest osobno.

## Następnie (poza X2)

- Odpowiedź R1 na `G(seed*)` (pytanie 1 I3 §4) — dopiero potem wierność XOF
- Hibryda I3: tani łańcuch + SHAKE tylko gdy kontrakt go wymaga
- Licznik triples dla prawdziwego toru (teraz stand-in = 0 Beaver)


## Realny SHAKE (doprecyzowanie)

| Warstwa | Co | Status |
|---|---|---|
| **Oracle FIPS 202** | `shake256_clear` — prawdziwy SHAKE256 (`sha3`) | **JEST**, wektor RFC |
| **Model bramek MPC** | `shake256_mpc_and_gates` = 38 400 AND/perm | **JEST** (I3) |
| **Tor na udziałach** | `xof_squeeze_blocks` — **stand-in** (32 muls/blok) | JEST (nie SHAKE) |

Dlaczego nie pełny SHAKE w MPC teraz: 10²–10³ perm na pk+sk = 10⁵–10⁷ × G_frag.
Architektura share-native jest gotowa; bit-blast Keccaka = osobny tor po R1/L1.
