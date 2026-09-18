# Replay pakietu częściowego L_NTT

Cwd:

```text
/home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001
```

Narzędzia: GCC 14.2.0, Python 3, bwrap, Sage 10.9 przez
`/home/footfalcon/.local/bin/sage`, Lean 4.34.0/Std przez
`/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean`.
Nie używa się mathlib, instalacji ani sieci. Cache i nowe artefakty są pod W.

Weź oczekiwany SHA-256 OUTPUTS z zewnętrznego przekazania wyniku i wykonaj:

```sh
python3 -B scripts/run.py 240 python3 -B scripts/replay.py /home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001/tmp/replay_003 EXPECTED_OUTPUTS_SHA256
```

Cel musi nie istnieć; w przeciwnym razie wybierz następny numer. Skrypt
sprawdza digest i wpisy manifestu przed utworzeniem świeżej kopii. Nie
nadpisuje ukończonego runu ani nie uruchamia jego prepare.py.

Reprodukcja obejmuje binding źródła, Words, build C, tablice, dzielenie,
niezależne certyfikaty Sage, fixtures, prymitywy, odtworzenie Tables,
Linear, Composition, test suite normal/sanitizer/observed/mutants oraz audit.
Pochodne `inputs/slices` i `formal/Tables.lean` są generowane ponownie,
a nie kopiowane jako substytut obliczeń.

Oczekiwane:

- `REPLAY_RESULT.json`: FRESH_REPLAY_PASS, 98 identycznych plików znaczeniowych;
- 186 sprawdzonych deklaracji, z warunkową końcową kompozycją;
- 737 kontroli prymitywów i 18432 mianowniki;
- 28 poprawnych pipeline baseline, cztery wykryte mutacje, no-op PASS;
- jawne `PARTIAL_PROOF`, również po udanym replayu.

Przebieg `tmp/replay_001` jest zachowaną nieudaną próbą techniczną.
Udana próba przed freeze to `tmp/replay_002`. Ich historie nie są
podmieniane ani reinterpretowane jako dowód/kontrprzykład.

Nowa kopia ma własny COMMANDS/logs; stare katalogi L_RHO/L_V/Blue i H nie
są miejscem zapisu. Oryginalne source/ tego zadania pozostaje niezmienione.
Digest OUTPUTS nie jest częścią samego manifestu; podanie digestu dopiero
co policzonego ze zmienionej kopii nie zastępuje zewnętrznego pinu.

Zakres manifestu i append-only dziennika opisuje OUTPUT_SCOPE.md.
Udany replay odtwarza uzyskane ogniwa i ograniczenia, nie uzupełnia
brakujących globalnych hipotez Source/CRT.
