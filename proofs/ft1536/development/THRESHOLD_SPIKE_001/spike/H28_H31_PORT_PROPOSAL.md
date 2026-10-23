# Propozycja portu H-28/H-31 (nie aplikowana do upstream)

**Status:** patch-proposal w W. Oryginały `Obrazy/.../san-mpc` **nietknięte**.
Port wymaga decyzji właściciela (TT-56).

## H-28 (wg `INVENTORY.md` §D)

1. `spdz_setup`: `if n < 2 { return Vec::new(); }` lub `bail!` — bez pętli na `n=0`.
2. `spdz_input_dealer`: `if keys.is_empty() { return vec![]; }` przed `n-1`.
3. `spdz_open_batch`: `if all_values.is_empty() { bail! }`; sprawdź długości wierszy.

## H-31 (wg §E)

1. `SpdzKeyShare`: usunąć `Copy`, dodać `Zeroize` + `ZeroizeOnDrop`.
2. `AuthShare`: dodać `Zeroize` + Drop (już bez Copy).
3. `Share` (san-dkg): dodać Drop do istniejącego Zeroize.
4. `MpcByte`: Drop zeroize (nie tylko trait).

## Wzór z kopii kiełka

`spike/src/lib.rs`: `Share`/`MacShare`/`BeaverTriple` — `ZeroizeOnDrop`,
brak `derive(Clone, Copy)` na sekretach; `SpikeError` zamiast paniki
(H-28-style guards).

## Odbiór portu (gdy TT-56)

- testy upstream zielone + nowe edge-case (n=0, empty keys, ragged batch)
- mutation-check: świadomy `Copy` na `SpdzKeyShare` nie przechodzi review
- retained: lista zmian w historii, bez push bez sygnału
