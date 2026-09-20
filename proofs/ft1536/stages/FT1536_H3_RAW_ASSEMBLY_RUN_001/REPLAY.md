# Świeży replay RAW_ASSEMBLY

W katalogu pakietu, z istniejącym tmp i nowym ABSENT_DEST pod nim:

```sh
python3 -B scripts/replay.py /ABS/PACKAGE/tmp/replay_001 EXPECTED_OUTPUTS_SHA256
```

EXPECTED_OUTPUTS_SHA256 jest zewnętrznym pinem otrzymanym w handoffie.
Skrypt weryfikuje pin i pełny manifest PRZED utworzeniem DEST. Sprawdza
duplikaty/escapes/symlinki, kopiuje tylko potrzebne publiczne inputs/sources,
nie stare binaria/cache/olean i nie sięga do oryginalnych Dokumenty/stages/W.
Istniejący DEST jest błędem, nie miejscem do kontynuowania starego buildu.

Kolejno, jeden worker:
1. TOOLCHAIN, active preprocessing/call graph i dokładny source/PATCH/cut
   transport; RO mounts i source/reuse pins;
2. fresh Sage10.9 INIT/S8/1524 records/twiddle certificate;
3.33 moduły Lean4.34/Std, pełne czyste logs/axioms/types/terms;
4. niezależny model/preflight sześciu publicznych fixtures;
5. oryginalny C tree i literalny raw slice, normal i ASan/UBSan, z porównaniem
   wszystkich basis/tree/intermediate words, traces, frame i leaf map;
6. wykonane structural/memory mutations i invalid preflight cases;
7. composition certificate, RAW_PREFIX_CERTIFICATE i OBLIGATIONS;
8. dokładne195 path/SHA matches oraz ponowna weryfikacja oryginalnego manifestu.

DEST/REPLAY_RESULT.json musi mieć FRESH_REPLAY_PASS i pełną listę matches.
Nie wystarcza sam status: archiwizer porównuje listę z przypiętym
artifacts/fresh_replay.json i rzeczywiste bajty obu zestawów plików.
Full receipts/streams pozostają w DEST przy powodzeniu i błędzie.

Wymagane Linux x86_64 LP64, GCC Debian14.2.0-19, Python3.13.5, bwrap,
Sage10.9 i Lean4.34/Std pod ścieżkami TOOLCHAIN. Nic nie jest instalowane
lub pobierane. Każdy child używa bwrap W-only/network-off, bootstrap/source
RO, HOME/TMP/DOT_SAGE/cache/olean/bin pod swoim DEST. Bounded jobs≤240 s,
normal8GiB, Lean-j1/-M2048, ASan osobno bez virtual address-space cap.
Controller nie może dziedziczyć hard RLIMIT_AS8GiB (ASan shadow). LSan false.
Rehearsal trwał70.806 s; standard archiwizera może użyć outer watchdog600 s.

## Rehearsal i kontrola po freeze

Zarchiwizowany pre-freeze rehearsal użył trybu --rehearsal z niezależną
kotwicą artifacts/rehearsal_inputs.sha256 o SHA:
`3d230a9e3a7e240bd46b98033a92eb69b4db7f12721f0ea06fb67c6836bcc93e`.
Dał195/195 i200 unikalnych kopii receipts/streams. Kotwica nie zawiera
własnego hasha, wyniku replayu lub późniejszego raportu.

`python3 -B scripts/final_control.py replay EXPECTED_OUTPUTS_SHA256`
to lokalna kontrola standardu po freeze: pakiet RO, tylko nowy
tmp/final_replay_001 writable, Dokumenty/H/stages ukryte RO; limit240 s.
Controller zapisuje argv/limits/exit/stdout/stderr pod tym nowym DEST
i ponownie weryfikuje cały pakiet. Nie dopisuje do frozen COMMANDS/OUTPUTS.

Standard nie wywołuje KeyGen/private loader API/Sign, stable rebuild,
normalization lub dudect. Synthetic inputs nie są P_key/emitted witnesses.
Replay jest odtworzeniem proof/check evidence, nie nowym dowodem przez same
hashes; mathematical scope i analytical/kernel boundary pozostają z REPORT.
