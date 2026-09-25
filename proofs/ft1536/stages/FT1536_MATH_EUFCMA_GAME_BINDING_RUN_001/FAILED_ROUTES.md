# FAILED_ROUTES — historia prób tego wykonania

Surowe logi w `history/`. Nie dopisuję brakujących exit codes ani rzekomych
udanych replayów do prób przerwanych.

## Iteracje Lean (każda próba w run/history/<id>/{stdout,stderr})

- gamebyte_001: `set -e` w sterowniku shell przerwał po błędzie taktyk
  (niedomknięte `cases` na projekcjach Prod); brak artefaktu.
- gamebyte_002: `cases` na projekcjach zamiast `Prod.ext`; `rfl` po
  `subst` dla argumentów-dowodów (dowodowa nieróżność — ostatecznie `subst`);
  warning o nieużywanych `ha/hb` i próba ewaluacji `2^320` przez norm_num.
- gamebyte_003: kompiluje, ale 3 warningi (niewykorzystane zmienne,
  próg potęgowania). W finalnym kodzie: argumenty usunięte, `2^320`
  dowiedzione przez `pow_mul`, bez wyciszania linterów.
- gamebyte_004: **PASS, log pusty**.
- gamenames_001–003: dependent-motive rw (`nonceOf` z argumentem-dowodem),
  `List.take_left` z jawnymi argumentami (są implicit), brak `rfl` po `rw`
  na wyrażeniach redukowanych przez iota, `rw` nadmiarowo zamieniające
  liczbę 40 także wewnątrz `take 40`.
- gamenames_004: `if_pos/if_neg` (deprecated) + pozostałości motive.
- gamenames_005: **PASS, log pusty** (rozwiązanie: `nonceOfBytes` bez
  argumentów-dowodów; osobne lematy `bytesLE_bytesVal40`).
- gamemach_001–002: kwalifikacje `ROM.*`, nazwy pól produktu, `if_pos/neg`
  (deprecated), nieużywane `[DecidableEq C]`, `.1.st` na stanie ROM.
- gamemach_003: `omit [DecidableEq C]` po usunięciu zmiennej; `Bool.and_eq_true.mp`
  (brak takiego `.mp`).
- gamemach_004: **PASS, log pusty**.
- paidsteps_001–002: `sum_range_succ` vs karta filtrów, `pow_succ'` w złym
  porządku mnożenia, `Nat.pow_le_pow_of_le` (ℕ) zamiast `pow_le_pow_right₀` (ℝ),
  brak `pair_framing` w GameNames (jest w GameByte), `norm_num` ewaluujący 2^320.
- paidsteps_003: jedyny warning (próg potęgowania) w `norm_num`.
- paidsteps_004: **PASS, log pusty** (zamiana na `Nat.cast_pow/cast_ofNat`).

## Iteracje Sage

- sage_001: wyścig toolów (brak pliku przy starcie) — sterownik, nie matematyka.
- sage_002: mała skala nazw „short" mylnie obejmowała len=2 (analog len<40).
- sage_003: błędne liczenie zużycia celów w komentarzu/a-sercji (final czyta
  targets[1], nie [2]); zła kolejność konfliktu w kontroli negatywnej.
- sage_004: literał e_sign niezgodny z wagami modelu (1/32 vs 1/16) —
  model uproszczony do czystego e=1/4; szablon certyfikatu zsynchronizowany.
- sage_005: równość dokładna na RealBall zamiast zawierania (phi(0,b)=b).
- sage_006: Sage Integer nieserializowalny w JSON (owinięcie int()).
- sage_007: **PASS** (po korekcie trzech literałów/tożsamości w szablonie
  certyfikatu: suma konfliktów 9, second wspólnego kroku 1, `pow256_40`
  zamiast ewaluacji).

## Wyniki negatywne matematyczne (zachowane)

- Centrowanie A2 naprawdę może zwiększyć Q ponad B (2051350378 → 2143496945);
  kontrprzykład zachowany w certyfikacie i kontroli Sage.
- Nie uzyskano pełnego warunkowego twierdzenia EUF-CMA: brak
  game_kernel_identification / lazy_sampling_refinement / one_key_lift /
  bit-cost odnotowano jawnie (NEXT_INTERFACE), zamiast zakładać końcową
  nierówność. Błędy elaboracji z ww. iteracji NIE są kontrprzykładami
  matematycznymi.
