# Fresh replay — pojedynczy bounded worker

Standardowy interfejs po freeze:

```text
python3 -B scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA256
```

External SHA musi pochodzić z handoffu poza pakietem. DEST jest absolute,
nieistniejący, pod durable repo proofs/ft1536/work/ lub replay-work/, z
istniejącym niesymlinkowym parent. Dla Astry tego zadania używany jest nowy
podkatalog jej W/tmp/, a nie systemowy /tmp. Nie używać istniejącego DEST.

1. Przed mkdir DEST kontroler weryfikuje external SHA, CAŁY manifest,
   exact scope/member set, bezpieczeństwo ścieżek oraz semantic pin list.
2. Kopiuje wyłącznie proof/input source seeds opisane w OUTPUT_SCOPE,
   potwierdza brak .olean/cache/bin i tworzy lokalne świeże runtime dirs.
3. Bwrap: / RO, oryginalne worktrees/stages/background/Extra zasłonięte
   trwałym RO markerem, jedyny writable project tree to nowy DEST;
   inputs/bootstrap i source dodatkowo RO, network/pid isolated. Marker
   ma tylko puste directories pozwalające zamontować nested DEST; nie tmpfs.
4. scripts/recipe.py uruchamia sequential jobs przez run.py: pins/toolchain,
   source bindings, exact rational/Sage certificate, models/toy probability,
   normal i ASan/UBSan builds/checks, reset controls, mutations,6 topological
   Lean batches, final audit, metadata i semantic list. Per-job wall<=240s,
   normal AS8GiB, Lean-j1/-M2048, sanitizers osobno bez AS cap dla shadow.
   Controller ma1800s wall timeout; nie narzuca AS limitu sanitizer children.
5. Porównuje regenerated semantic list i KAŻDY path/SHA do przypiętych
   danych. Ponownie weryfikuje package manifest; zapisuje wyłącznie do DEST
   REPLAY_RESULT.json ze statusem FRESH_REPLAY_PASS i matches[{path,sha256}].

Wszystkie HOME/TMPDIR/cache/DOT_SAGE/LEAN_PATH są pod fresh DEST. Installed
toolchains są dostępne RO; brak project-generated cache z wcześniejszej pracy.
Normal C jest standalone extracted scheduler/codec z jawnymi public stubs,
nie pełnym Sign/do_sign/KeyGen/seeded PRNG. All commands/failed outputs w DEST.

Rehearsal przed REPORT/RESULT używa tej samej komendy z:
`--manifest artifacts/rehearsal_anchor.sha256` i external anchor SHA.
Anchor tworzy się po zakończeniu poprzedniego run.py, w bounded W-only
sandboxie bez wrappera run.py: anchor sam bierze executor.lock, a wrapper
nie może dopisywać nowych immutable logs już po policzeniu jego manifestu.
Completed receipt jest kopiowany do artifacts/fresh_replay.json przed freeze.
Wrong external pin test potwierdza failure przed DEST. Po REPORT/RESULT
scripts/freeze.py (poza trzymającym executor.lock run.py) tworzy immutable
OUTPUTS. Końcowy fresh replay używa już OUTPUTS pinu i kolejnego ABSENT_DEST;
nie poprawia zamrożonego raportu. Hashe i końcowy receipt są podawane w TUI.

Status theorem pozostaje mixed source/analytical/kernel; replay sprawdza
regeneration/pins/executable controls, nie zastępuje oceny analitycznych
argumentów i nie jest owner acceptance. Relay do drugiej sesji jest odwołany.
