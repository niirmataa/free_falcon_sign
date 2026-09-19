# Standardowy replay audytu

Wymagane istniejące narzędzia: GCC14.2.0, Python3, bubblewrap, objdump,
Sage10.9 i Lean4.34/Std pod ścieżkami zapisanymi w TOOLCHAIN. Sieć i instalacje
nie są używane. Oba źródła FPEMU muszą mieć piny z REPORT/INPUTS.

Uruchomienie z katalogu pakietu, `DEST` absolutny, **nieistniejący** i pod
katalogiem tego pakietu; jego parent musi istnieć:

```text
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Skrypt najpierw sprawdza zewnętrzny hash manifestu oraz każdy member,
bezpieczne ścieżki i symlinki. Dopiero potem tworzy DEST. Kopiuje wyłącznie
przypięte inputs/scripts/checks. Testy pracują z nowego DEST, z osobnymi
cache/bin/formal, przez rzeczywisty bwrap DEST-only writable, bootstrap RO,
root RO, sieć odłączona. Nie korzystają z oryginalnych Dokumenty/H, active W
innych wykonawców ani starych binariów.

Kolejność: verify → fresh normal build/smoke → independent arithmetic →
fresh ASan+UBSan build/smoke → ten sam arithmetic corpus → oracle controls →
platform/preprocessing/disassembly → QQ/RBF → historyczny Lean rebuild →
original-TU assembly → audit matrix → package negative controls. Poszczególne wall/CPU limity wynoszą
30–240s; normal8GiB, ASan shadow oddzielnie. **Nie otaczać całego replayu
hard RLIMIT_AS8GiB**, bo ograniczyłoby to shadow-address ASan.

`DEST/REPLAY_RESULT.json` ma status `FRESH_REPLAY_PASS` i listę29 `matches`
(path/SHA-256). Wszystkie wyniki z SEMANTIC_FILES odtwarza się bajtowo;
w tym pełny normal i ASan stdout140225 przypadków, delta250, model/proof
receipts, RBF, assembly i obie macierze. Nazwanie nowego wyniku PASS bez
porównania oczekiwanych bajtów jest niewystarczające.

Pełne argv/cwd/limits/status/streams są w DEST/COMMANDS.log i logs/jobs oraz
logs/replay_driver. Binaries mają nowe build receipts; wariant ASan zawiera
debug paths i nie musi mieć tego samego binary hash po relokacji. Platform,
load, elapsed times i dostępność narzędzi są nowymi obserwacjami. Oryginalny
raport/manifest pozostają read-only z punktu widzenia skryptu replay.

## Rehearsal i freeze

`scripts/package.py anchor` tworzy osobną `artifacts/rehearsal_anchor.sha256`
z inputs, kodem i oczekiwanymi plikami znaczeniowymi. Jej hash przekazuje się
zewnętrznie do tej samej implementacji:

```text
python3 -B scripts/replay.py /ABS/W/tmp/rehearsal001 ANCHOR_SHA256 --rehearsal
python3 -B scripts/package.py receive /ABS/W/tmp/rehearsal001
```

Odebrany receipt zapisuje się jako `artifacts/fresh_replay.json`; pełne
logs są kopiowane do logs/rehearsal. Ta kotwica nie udaje finalnego OUTPUTS.
Następnie finalizuje się REPORT/RESULT i wykonuje `scripts/package.py freeze`.
Freeze sprawdza semantic matches/INPUTS/status, zamraża prefiks COMMANDS,
a OUTPUTS obejmuje pełny zakres określony w OUTPUT_SCOPE.

**Po freeze** standardowe dwie pozycje argv są testowane ponownie do
`/ABS/W/tmp/postfreeze001`, z finalnym zewnętrznym OUTPUTS hash. Finalnych
REPORT/OUTPUTS nie zmienia się w celu wpisania wyniku tej próby; hash
REPLAY_RESULT jest osobnym elementem handoffu.

Protokół jest zgodny z importerem `proofs/ft1536/tools/archive.py --replay standard`:
receipt bazowy to artifacts/fresh_replay.json, child receipt to REPLAY_RESULT,
te same path/SHA matches są obecne w obu i wszystkie są członkami OUTPUTS.
Odbiór/import/commit wykonuje prowadzący sesję.
