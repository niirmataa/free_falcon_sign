# Świeży replay

Sterownik: `tools/replay.py`. Wymaga Python3 (wyłącznie organizacja), bwrap,
prlimit, przypiętego Lean4.34.0/Mathlib oraz SageMath10.9. Proof i Sage działają
w `bwrap --unshare-net`; cały system jest RO poza **nowym DEST**. `/tmp` wewnątrz
sandboxu jest bindem trwałego DEST/tmp, nie systemowym tmp/tmpfs.

```sh
python3 -B "$BUNDLE/tools/replay.py" \
  --bundle "$BUNDLE" \
  --dest /home/footfalcon/free_falcon_sign/proofs/ft1536/replay-work/UNIQUE_NEW_REPLAY \
  --manifest OUTPUTS.sha256 \
  --manifest-sha SHA256_Z_ZEWNETRZNEGO_HANDOFFU
```

**Pin należy wziąć z zewnętrznego handoffu, nie obliczać go i ufać samemu
odczytanemu pakietowi.** Najpierw sprawdzany jest ten pin, potem wszystkie
względne members. DEST musi nie istnieć i leżeć poza frozen BUNDLE. Inputs
bootstrap są wewnątrz przenoszalnego pakietu, względem jego korzenia.

`LIBRARY_CLOSURE.json` wiąże 3456 rzeczywiście importowanych modułów:
źródła są dołączone w library-source/, build cache ma dokładne hashe artefaktów.
RO cache jest zależnością środowiska, nie własnym starym buildem zadania.
Przy relokacji można podać `--library-map roots.json`, zachowując te same
źródłowe i binarne piny. Nie pobiera się ani nie buduje zależności przez sieć.
Brak zgodnego cache to jawny bootstrap blocker. Piny wersji i proweniencję
uprzedniego library build opisują TOOLCHAIN.json, PREFLIGHT.json i bootstrap.

Każdy własny moduł Lean jest kompilowany od początku do DEST/lib; żadnego
własnego .olean nie bierze się z bundle albo history. Sage uruchamiane jest
**`sage check_bounds.sage`**, generuje certificates.json i Certificate.lean.
Generator musi odtworzyć dokładne pinned bytes źródła konsumenta Lean.
Następnie sprawdzane są trzy zadeklarowane PRZED replayem produkty EXPECTED:
JSON, wygenerowany Lean i kompletny log typów/axioms. Dodatkowo wszystkie
jobs muszą mieć exit0, czysty stderr i brak ostrzeżeń Lean. Audyt obejmuje
wszystkie 101 eksportowanych twierdzeń i dopuszcza tylko standardowe
propext/Classical.choice/Quot.sound (część ma ich podzbiór).

Własny replay autora używa `REPLAY_SEED.sha256`, z pinem
`a5ff7f1a2f34dd0735b35c1b84afb915773c226e797f16b0b767bea777b4b707`
przekazanym jawnie przed startem. Seed obejmuje kompletny kod/konfigurację/
wejścia/closure/expected replayu. Raport i receipty dopina się następnie przez
OUTPUTS, unikając cyklu manifest→własny receipt→manifest. Odbiorca używa
końcowego zewnętrznego pinu OUTPUTS; kod replayu jest identyczny.

Wyniki autora są w replay/; historia nieudanych i wcześniejszych prób w
history/. Nie utożsamiać własnego replayu z niezależną recenzją.

Limity: jeden worker, Lean -j1 -M6144, wall1800s/krok. RLIMIT_AS12GiB
uwzględnia mapowane biblioteki; max RSS jest sprawdzany względem8GiB.
Uzasadnienie odstępstwa od początkowego -M2048/AS8GiB: FAILED_ROUTES.
