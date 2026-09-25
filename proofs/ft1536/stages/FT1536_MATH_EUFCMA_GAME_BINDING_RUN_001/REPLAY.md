# Świeży replay

Sterownik: `tools/replay.py` (Python3 wyłącznie do organizacji/hashy).
Wymaga bwrap, prlimit, Lean 4.34.0/Mathlib (piny TOOLCHAIN.json) oraz
SageMath 10.9. Proof i Sage w `bwrap --unshare-net`; system RO poza nowym
DEST. `/tmp` w sandboxie to bind trwałego DEST/tmp — **nie systemowy tmpfs**.

```sh
python3 -B "$BUNDLE/tools/replay.py" \
  --bundle "$BUNDLE" \
  --dest /sciezka/do/NOWEGO/DEST/UNIQUE \
  --manifest OUTPUTS.sha256 \
  --manifest-sha SHA256_Z_ZEWNETRZNEGO_HANDOFFU
```

Pin manifestu bierze się Z ZEWNĘTRZNEGO HANDOFFU — nie oblicza go odbiorca
i nie ufa samemu odczytanemu pakietowi. Najpierw ten pin, potem wszyscy
względni członkowie (bez ścieżek bezwzględnych/`..`, bez symlinków).
DEST musi nie istnieć, leżeć w trwałym W tego pakietu (`run/replays/`)
i nie nakładać się z pakietem. Odrzucane: `/tmp`, ścieżki repo, istniejący
DEST, zły pin, zmieniony/brakujący członek, niepełny manifest. Poprawny
no-op (`--verify-only`) przechodzi.

Kolejność: pin → closure bibliotek (3456 modułów/17280 artefaktów RO,
źródła względem `library-source/` pakietu poprzednika wg LIBRARY_CLOSURE) →
`sage check_games.sage` (certificates.json + generated/GameCertificate.lean,
bajtowo = bundled) → przebudowa wszystkich własnych modułów od zera do DEST/lib
(21 modułów wg BUILD.json, kolejność topologiczna) → Audit (typy+aksjomaty) →
porównanie 3 produktów z EXPECTED (zadeklarowanych PRZED replayem) → audyt
eksportów: komplet = FORMAL_EXPORTS, aksjomaty ⊆ {propext, Classical.choice,
Quot.sound} (brak sorryAx) → ponowna weryfikacja manifestu.

Brak zgodnego cache bibliotek to jawny `BLOCKED_ENVIRONMENT`, nie dowód
fałszu. Nie pobiera się i nie buduje zależności przez sieć.
Własny replay ≠ niezależna recenzja.

Limity: 1 worker, `lean -j1 -M6144`, wall 1800s/krok, AS 12GiB, RSS ≤ 8GiB.
Schemat bez cyklu hashy: seed/EXPECTED → fresh replay → zamrożony OUTPUTS →
zewnętrzny handoff. Weryfikacja po freeze zapisuje wyłącznie do nowego DEST.
