# COUNTER_AND_FRAME — licznik 64-bit i ramka pamięci

Model: sekcja E (`ZZ`), checker `counter.*` (rederywacja + formuły
`cc_after = (cc0+64k) mod 2^64`, flagi wrapu).

## Arytmetyka licznika

- Blok k refilla: `(cc0+k) mod 2^64`, `0 ≤ k < 64`; post counter
  `(cc0+64) mod 2^64`; pierwsze 48 bajtów state zachowane; `ptr = 0`.
- Fixed context, N ≤ 2^64 kolejnych bloków: brak powtórzeń także przez wrap
  (każdy badany fixture: 192 counters, 192 różnych — asercja).
- Wrap ≠ repeat: F4 (cc0=2^64−1) wrap w `after_init`; F6 (cc0=2^64−65) wrap
  w `after_refill1`; F5 (cc0=2^64−64) kończy 1. refill DOKŁADNIE na 2^64−1
  (post counter 0) — flaga wrapu per-stage to crossing wewnątrz stage
  (`cc_last < cc_start`), więc F5 ma `[]`, co jest poprawne.
- F3 (cc0=2^32−1) zmienia high word w pierwszym refillu bez wrapu.
- q-refill corollary: refills = ⌊q/4096⌋, ptr = q mod 4096 (exhaustive 0..20000
  + punkty 4095/4096/4097/8192/25408); zakres: wniosek z odebranych reguł
  getterów, nie nowy schedule.

## Ramka

Init: state.d[0..55]. Refill: buf.d[0..4095] + state.d[48..55] + ptr=0.
state.d[56..255]: nigdy (poison 0xA5 w modelu i harnessie; `state_poison_ok`
na 21 stages). Canaries head 0x5A / tail 0xC3 wokół `prng` całe na każdym
stage. ECC: brak OS entropy/sekretów — stub zwraca publiczne 56 B
(`stub_calls == 1`, `stub_last_len == 56` na init).

## Przykłady deterministyczne

- Świeża instancja z tymi samymi 56 B odtwarza identyczny buf4096 i post state
  (model + kontrola determinism w C).
- F0 i F2 dzielą cc0 = 0, bufory różnią się (licznik sam nie wyznacza
  keystreamu) — ograniczenie przyszłej gry, nie atak/Emitted witness.
- Cross-context: wartości liczników powtarzają się MIĘDZY kontekstami
  (jawnie asercja) — brak tezy o unikalności globalnej.
