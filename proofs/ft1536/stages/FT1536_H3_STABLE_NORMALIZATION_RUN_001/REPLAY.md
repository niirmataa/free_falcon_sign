# Świeży standard replay STABLE_NORMALIZATION

Z katalogu pakietu, z istniejącym tmp i nowym ABSENT_DEST pod nim:

```sh
python3 -B scripts/replay.py /ABS/PACKAGE/tmp/replay_001 EXPECTED_OUTPUTS_SHA256
```

External pin i każdy member pełnego manifestu są sprawdzane PRZED utworzeniem
DEST. Istniejący DEST/symlinki/escapes są odrzucane. Seed to publiczne inputs,
źródła i własne recipe; bez project binaries/cache/olean i bez odczytu dawnych
Dokumenty/stages/innych W. INPUTS provenance paths są danymi, nie fetch URLs.

Jeden worker kolejno odtwarza toolchain/source binding/typed proof binding,
Sage exact source bounds,40 modułów Lean i pełne audyty, scalar/8 pipeline
fixtures, Lean sqrt values, C normal i ASan/UBSan, source leaf/sampler map,
mutations i normalized certificate. Wszystkie262 semantic path/SHA muszą
się zgadzać. Po obliczeniach oryginalny manifest jest ponownie sprawdzany.

DEST/REPLAY_RESULT.json ma FRESH_REPLAY_PASS i pełne matches. Archiwizer
porównuje je z artifacts/fresh_replay.json oraz rzeczywistymi bajtami;
sam napis PASS nie wystarcza. Full receipts/streams pozostają w DEST również
przy błędzie. Proof scope i mixed boundary pozostają takie jak w REPORT.

Wymagane: Linux x86_64 LP64, GCC Debian14.2.0-19, Python3.13.5, bwrap,
Sage10.9, Lean4.34.0/Std pod ścieżkami TOOLCHAIN. Bez instalacji/sieci.
Każdy child ma W-only/network-off sandbox, bootstrap/source RO i lokalne
HOME/TMP/DOT_SAGE/cache/olean/bin. Jobs≤240 s, normal8GiB, Lean-j1/-M2048;
ASan oddzielnie bez virtual address cap. Controller nie może dziedziczyć
hard RLIMIT_AS8GiB z powodu shadow ASan; LSan false. Standard archiwizera
może użyć outer watchdog600 s. Lokalny rehearsal trwał61.766 s.

## Kotwica i kontrola po freeze

Pre-freeze --rehearsal użył artifacts/rehearsal_inputs.sha256 o SHA:
`4f996ecae24c1d0514ddd16dc0ba4c55014f419824655ccd474deb7792d6bfcd`.
Nie zastępuje on external final OUTPUTS pin. Wynik262/262 i235 unikalnych
receipt/stream copies są zarchiwizowane; kotwica nie zawiera własnego hasha,
wyniku lub późniejszego raportu.

`python3 -B scripts/final_control.py replay EXPECTED_OUTPUTS_SHA256` wykonuje
standard po freeze z pakietem RO, writable tylko nowy tmp/final_replay_001,
Dokumenty/H/stages ukryte RO i outer limit240 s. Jego pełne receipts nie
zmieniają OUTPUTS lub frozen COMMANDS.

Replay używa publicznych helper/suffix slices. Nie uruchamia KeyGen, całego
loadera/private-key API, Sign, PRNG/samplera lub dudect i nie tworzy kluczy.
Mandatory KeyGen acceptance jest twierdzeniem o source Emitted success,
a nie wynikiem wygenerowania/testowania klucza w tym replayu.
