# Y1 — prawdziwy SHAKE256 na udziałach (zamiast stand-in X2)

**Status: IMPLEMENTACJA ZIELONA — do weryfikacji ultra.** To **nie** jest
jeszcze próg FT ani twierdzenie bezpieczeństwa klucza. Wypełnia wymóg 1
z `SECURITY_POSITION.md` (XOF = prawdziwy SHAKE256 w torze na udziałach).

## Co zrobiono

| Element | Decyzja |
|---|---|
| Moduł | `spike/src/shake.rs` |
| Stan | 1600 bitów Keccaka, każdy = Shamir GF(256), sekret ∈ {0,1} |
| XOR bitów | dodawanie GF(256) = `^` na udziałach (liniowe, 0 muls) |
| AND bitów | `mul_shamir_reshare` (gf_mul 0/1 = ∧) |
| NOT b | b ⊕ 1 (każda strona ⊕ 1) |
| χ | `out = a ⊕ c ⊕ (b∧c)` — 1 mul/bit |
| Koszt | 24 × 1600 = **38 400** reshare-muls / Keccak-f (zgodność I3) |
| API | `shake256_shares(rng, input_bits, out_len, xs, k) -> Vec<BitShares>` |
| Wejście | udziały **bitów** (dealer `split_msg_to_bit_shares`) |
| Wyjście | `out_len*8` wierszy bitów — **bez** składania bajtów z udziałów |
| Oracle | `shake256_clear` (FIPS 202 via `sha3`) — bit-exact |

## Dowody (testy `tests_y1_shake`)

1. `y1_shake256_empty_matches_fips_clear` — SHAKE256('') == wektor FIPS
2. `y1_shake256_abc_matches_fips_clear` — SHAKE256('abc') bit-exact
3. `y1_shake256_64bytes_out_matches` — 64 B wyjścia vs clear
4. `y1_cost_is_38400_reshare_per_perm` — licznik `cost` = 38400
5. `y1_fail_closed_bad_input` — rate / zła liczba stron / niepełny bajt
6. `y1_stays_shared_one_party_cannot_open` — 1 udział ≠ bity wyjścia
7. `y1_keccak_pad_empty_is_fips` — pad `0x1F…0x80`
8. `y1_bit_roundtrip_clear` — pakowanie bitów

Suita: `cargo test --manifest-path spike/Cargo.toml` → **186/186**
(163 lib + 13 iso + 10 spike). Bez regresji.

## Retained findings (Y1)

### Y1-RF-1 — Lagrange λ na innych punktach niż suma
`reconstruct_bit` liczył `lagrange_at_zero(xs, i)` po **wszystkich** xs,
a sumował tylko pierwsze `k` udziałów — zły wynik (wyjście „prawie same
jedynki"). Naprawa: λ z `xs[..k]`, suma po `k`. **Wzorzec:** λ i zbiór
punktów muszą być te same.

### Y1-RF-2 — dekompozycja bitów z udziałów bajtu jest niepoprawna
`(share >> bit) & 1` **nie** daje udziału bitu sekretu (udziały Shamira
nie są bit-rozłożalne). Dealer dzieli **każdy bit** osobno
(`split_msg_to_bit_shares`). Składanie bajtów z bit-udziałów przez
`row[p] |= v << shift` — również niepoprawne. Wyjście = bity; bajt
dopiero po `open_bit_shares`. **Wzorzec globalny** obok RF-3 (length-prefix).

### Y1-RF-3 — `reconstruct` z 1 udziału nie rzuca błędu
`crate::reconstruct` interpoluje z dowolnej liczby punktów (1 udział =
„sekret" = ten udział). Test `stays_shared` porównuje 1-udział vs pełne k,
nie oczekuje `Err`. Osobna granica API (`InsufficientShares`) — otwarte.

## Weryfikacja (V-Y1)

**WERYFIKATOR+RECENZENT (general-14): CHANGES_REQUIRED** — kryteria (a–e)
PASS, Keccak-f/RHO/RC/χ/pad FIPS **OK** (pad `1F…80` potwierdzony niezależnym
Keccakem vs NIST). Warunki:

1. **V-Y1-1** dead_code `shake256_pad` / `bits_to_bytes_clear` → `#[cfg(test)]`.
2. **V-Y1-2** duplikacja padu (helper vs inline) → `shake256_pad_block`
   single source; tor i testy wołają to samo.

Po poprawkach: **186/186, 0 warningów**. **Re-weryfikacja: PASS**
(V-Y1-1 `#[cfg(test)]`, V-Y1-2 `shake256_pad_block` single source).

## Granice twierdzeń

- **Jest:** wierny SHAKE256 (FIPS 202) na udziałach, koszt 38400 muls/perm,
  fail-closed, brak otwarcia stanu w torze.
- **NIE jest:** próg FT, G(seed*) z R1, multi-block absorb (Y2),
  Klein 73-bit, SPDZ-MAC, model złośliwy, produkcyjny klucz.
- Stand-in `xof_squeeze_blocks` **zostaje** jako tani łańcuch kosztowy
  (I3 hibryda); realny SHAKE wchodzi tam, gdzie kontrakt go wymaga.

## Y2 — multi-block absorb (dopięte)

Pad w **ostatnim** bloku (`shake256_pad_block(rem)`); `rem=0` = dodatkowy
blok padu. Testy: 136 B / 137 B / 2×136+50 bit-exact vs clear; koszt
2×38400 na wiadomość = rate. Suite **190/190** (167 lib + 13 iso + 10).

## Y3 — derive na prawdziwym SHAKE (dopięte)

`derive_key_material_shake(seed_bits, out_len)` — absorb `KEY_DERIVE_DOMAIN || seed`
(udziały bitów), squeeze `out_len` B jako bit-udziały. Oracle
`derive_key_material_shake_local` == `shake256_clear(domain||seed)`.
Jawnie **≠** `g_frag_local` (stand-in zostaje tani). Suite **194/194**.

## Y4 — Q73 + bias vs analityka (dopięte)

`rejection.rs`: `GAUSS_Q73_ONE`, `exp_neg_q73`, `gauss_weight_q73`,
`sample_gaussian_q73_clear`, `measure_gaussian_q73_vs_analytical`.
Szczegóły i retained: `X1_KLEIN_PRECISION.md` §Y4. Suite **201/201**.

## Następnie (konkretne rozwiązania)

| ID | Cel |
|---|---|
| Y5 | ULTRA-WERYFIKATOR Y1–Y4 + RECENZENT |
