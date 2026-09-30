# T12.1 / RUN_003 — stable binary inplace, stan roboczy

**Status: PARTIAL_PROOF / WORKING_NOT_FROZEN.** Autor bieżącego podetapu:
GPT-6 Sol, `openai/gpt-6-sol`, sesja `ses_f12636605ffeL1FZg4teLUwUf5`.
To nie jest finalny handoff, niezależny odbiór ani akceptacja właściciela.

## Piny

- `inputs/source/falcon-keygen.c` SHA256
  `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`;
  funkcja **7491–7514**. `run/formal/Source3/KeygenSource.lean` SHA256
  `87b529d744eaf2c7c860d35dcc9113220ef3954928e59f41d880f64c0684ce25`.
  Źródłowy transport do tego pliku: `run/source_transport_002`, Sage accepted;
  kernel `StableBinaryPin.pinned` sprawdza wszystkie 24 linie względem
  KeygenSource, a `StableBinary.source_parses` rozpoznaje ich tokeny.
- `inputs/source/fpr-emulated.h` SHA256
  `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa`;
  parsed `fpr_half` (linia165–174) i `fpr_double` (linia176–181) są związane
  z `Pinned.fprLines` M0 i wykonane przez `CLogic.execute`.
- `inputs/source/fpr-emulated.c` SHA256
  `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f`.
  Trzy implementacje `fpr_add/mul/div` z tego źródła NIE zostały tu
  kernelowo wykonane ani związane z `FprCalls`.

## Sprawdzony zakres

Wyspecjalizowany parser akceptuje cały 24-liniowy fragment lub odrzuca
zmienione tokeny. AST ma jawny przypadek `n=1`, adresy dwóch odczytów,
przesunięcie prawej gałęzi i sprawdzony warunek równości z sparsowaną bazą.
Semantyka `execute` dla `2^k`, `0≤k≤8`, wykonuje sześć wywołań source-bound
`StablePositive` na iterację w kolejności C, wywołania add/mul/half/double/div,
zapis obu połówek scratch, odczyt całego scratch i `memcpy` do values,
rekurencję najpierw po pierwszej, potem po drugiej połowie. `source_loop_order`
i `source_recursion` drukują równania sterowania; `call_schedule_bounds` to
rzeczywista indukcja po `k` dla przedziałów wywołań.

`Layout.wellFormed` wymaga długości `2^k`, wyrównanych wskaźników, braku
64-bitowego overflow i rozłączności obiektów `values`, `scratch`, `bad`;
`Memory.initialized` wymaga zainicjalizowanych obu tablic oraz komórki bad.
Są to tylko warunki pamięciowe: żaden `positive`, zakres klucza, równość
Gram ani oczekiwana teza nie jest przesłanką. `none` odczytu/callee oznacza
niezdefiniowaną gałąź modelu; lemat dotyczy wszystkich **zdefiniowanych**
wyników. Obiektowa pamięć ma adresy bajtowe, ale reprezentuje obiekty
`fpr`/`uint32_t` w osobnych typed maps, nie pełny byte-heap C.

`source_recursion_memory_and_sticky` przy końcowym clear daje początkowe
`bad=0`, wszystkie wejścia sześciu kontrolnych wywołań positive, brak ich
zamiany na `fpr_one`, niezmienność słów poza tablicami i flag poza `bad`.
`source_preserves_prior_bad` daje dla każdego zdefiniowanego wyniku
`bad(initial)=1 ⇒ bad(final)≠0`. `StablePositive.source_refines` jest
wywołany w wykonaniu każdej kontroli, a `call1/2_no_caller_write` dowodzi
ramy **lokalnego modelu** callee. To ostatnie nie dowodzi ramy C callee.

Mutanty Lean `StableBinaryAudit`: podmiana `values+hn` na `values` przy drugim
wywołaniu jest odrzucona przez parser rekursji, a reset `*bad=0` nie daje
przypiętego AST `StablePositive`;
`detects_erased_bad` odrzuca wyzerowanie flagi ustawionej przed wejściem.

## Replay i ograniczenie

| Moduł | SHA256 źródła Lean | Strict receipt SHA256 | Wynik |
|---|---|---|---|
| `Source3/StableBinaryPin.lean` | `07123d82a9c98e57388dc15e8d146bc6517ddc4850b744e0c493b55a944f8b5e` | `8f02be6265e6486f38b70690565f2960a0e992e8edb5cb34396800ea0e93b45a` | `stable_binary_pin_001`, exit0 |
| `Source3/StableBinary.lean` | `6524207bd2e998a791a7304a214e8387a9b906cf0940ecc4161c60b11c041395` | `28487515206bc818fa92563c63d06e081da4d872c184f7e66bf6dfbcb3946d3b` | `stable_binary_020`, exit0 |
| `Source3/StableBinaryAudit.lean` | `3e76ad5bcfd3fb798cbee99e9898f4de62e17d9022df42fb1cfc0780d4a3c746` | `332840aa470cfccf5411ac989b455bc6c851ab569122b6f78d5e635445365034` | `stable_binary_audit_004`, exit0 |

Każdy job: `accepted=true`, `warningAsError`, bez wyciszania ostrzeżeń.
Surowe stdout mają wydrukowane typy i aksjomaty; w nowych twierdzeniach
wyłącznie `propext`, `Classical.choice`, `Quot.sound` (czasem podzbiór).
Nieudane próby i ich raw logs pozostają w `run/stable_binary_{001…019}`
oraz `run/stable_binary_audit_001…003`; finalne wyżej nie nadpisują ich.
Nie dodawano nowego rachunku liczbowego Sage: wszystkie operacje tego kroku
to semantyka bitów, sterowania i pamięci.

**Otwarty typ odbioru:** M0 `fpr-emulated.c:8–9` ustawia domyślnie
`FALCON_ASM_CORTEXM4=0` (przypięty Makefile nie nadpisuje makra).
Aktywne gałęzie C `fpr_add` (449–556), `fpr_mul` (681–776) oraz
`fpr_div` (916–1002) trzeba wykonać źródłowo na tych samych 64-bitowych
argumentach,
identyfikacji zwracanego słowa z `FprCalls` i dowodu ramy dla caller-owned
`values`, `scratch`, `bad`. Bez tego parametr `ops : FprCalls` opisuje
wyłącznie jawne środowisko wyników i lokalny brak jego zapisu w modelu.
Nie wolno promować obecnego lematu do uniwersalnego źródłowego wykonania
całego helpera, pełnej bramki leaf, M6 ani wyniku bezpieczeństwa.
