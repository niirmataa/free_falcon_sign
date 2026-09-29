# RUN_002 — zachowane próby i niedomknięte trasy

## initial_001: zewnętrzny timeout narzędzia, nie porażka dowodu

Komenda `python3 -B scripts/job.py initial_001 full` miała wewnętrzny limit
1800 s/krok i 8 GiB, ale wywołanie narzędzia miało omyłkowo 120 s.
Narzędzie przerwało komendę podczas hashowania runtime Lean. Nie powstał
końcowy receipt, nie wykonano Sage ani Lean. Log potwierdza przejście hashy
źródeł/cache wszystkich9 bibliotek. Następny odczyt `/proc` nie wykazał
pozostawionych procesów tego runu. Snapshot i oba logi pozostają w
`run/initial_001/`; nie udajemy kodu wyjścia wewnętrznego kroku.
Powtórzenie do nowego `initial_002`, z limitem wywołania narzędzia zgodnym
z 1800 s/krok. Nie zmieniono wewnętrznych limitów TASK.

## Trasy matematyczne

- Stara suma dziesięciu majorant ≈6086.4008 i ich idealizowana ablacja
  ≈16.10836 nie są boundem <1/2 ani kontrprzykładem implementacji.
- Redukcja D z joint do per-vector i usunięcie dyadycznego zaokrąglenia
  rho nie daje wymaganego budżetu; konkretne wyniki w BUDGET_ANALYSIS.json.
- Przesunięcie H6P innovation mean do starego targetu wymaga błędu add_C
  (falcon-sign.c1643). Nie importujemy innowacyjnego Eterminal jako C2
  niezależnej referencji całkowitej.
- Niewykazane add/mul/div/sqrt, caller domains i P06 nie są przesłankami
  lokalnych tożsamości algebraicznych ani zadeklarowanymi source proofami.

## normal_001: serialization w Sage preflight

Sage poprawnie preparsował liczby do ZZ, lecz pole JSON
`suffix_slots_each_vector=1536` pozostało Sage Integer. JSON encoder
przerwał preflight (exit1); C nie zostało uruchomione. Poprawiono wyłącznie
serializację do `int(1536)` oraz analogiczny count768 w wyniku. Matematyka
pozostaje QQ/ZZ. Snapshot, stderr, wygenerowany header i receipt zachowane.
Kolejna próba: `normal_002`, nowy DEST.

## Udany final_001/fresh_001 — zachowany, uzupełniony przed freeze

Pierwszy komplet final_001,ubsan_001,asan_001,fresh_001 przeszedł wszystkie
kroki,10/10 semantic matches. Przy przeglądzie zakresu rozdzielono dodatkowo
obserwacje poszczególnych terminal defects: zamiast sprawdzać tylko ich
łączny residual, harness ponownie wywołuje pure half/sub na identycznych
word operands (returned z1 i actual callback mu0), porównuje final raw z0
oraz zapisuje rx/sub0. Sage osobno sprawdza first-sub/half/sub0/last-sub.
To wzmocnienie lokalnej diagnostyki, nie nowy uniform proof. Źródło C
produkcyjne i formalne lematy nie zmienione. Cała pierwsza seria pozostaje
udana i zachowana; nowy final_002/ubsan_002/asan_002/fresh_002 uwzględnia
uzupełnienie oraz nowy plan semantic files. Nie nadpisano żadnego runu.

## finalize_001 — stop przed freeze na niepełnym wydruku terms

Kernel, Sage i wszystkie kontrole final_002/fresh_002 przeszły, lecz pakujący
guard wykrył `⋯` w wydruku proof terms. `pp.all=true` rozwinęło też tysiące
implicit typeclass arguments i druk został ograniczony przez pp.maxSteps.
Zatrzymano freeze; nie było OUTPUTS.sha256. Pełne stare logi, snapshot
finalizera i record błędu w `artifacts/finalize_001_FAILURE.json` zachowane.

Korekta dotyczy tylko formatu wydruku: pp.proofs/deepTerms/fullNames/
funBinderTypes/universes=true oraz pp.maxSteps2000000, zwykłe implicit args.
Nie zmienia proofu ani nie wycisza ostrzeżeń. Nowy fresh Lean build
`audit_001` i pełny replay `fresh_003`; mathematical/C sources bez zmian.
Sanitizerów nie powtarza się z powodu samej zmiany pretty-printera.

## finalize_002 — notacja uniwersum w nazwie aksjomatu

Po pełnym audit_001/fresh_003 wydruki są kompletne. Pakujący skrypt przerwał
na nazwie `Quot.sound.{u}`: porównywał ją literalnie z `Quot.sound`.
Nie jest to nowy/zakazany aksjomat. Frozen manifest jeszcze nie powstał.
`scripts/finalize.py` pozostawiono byte-exact wraz z replay-bound snapshotem.
Raportująca korekta jest osobnym `packaging/seal.py`; rozpoznaje suffix
uniwersum wyłącznie na trzech jawnie dozwolonych nazwach, zachowując także
oryginalne printed names. Żadne źródło proofu, checkera lub replayu nie jest
zmieniane po fresh_003. Ten błąd parsera metadanych nie uzasadnia ponownej
kompilacji ani powtarzania zakończonych obliczeń. Record błędu zachowany.
