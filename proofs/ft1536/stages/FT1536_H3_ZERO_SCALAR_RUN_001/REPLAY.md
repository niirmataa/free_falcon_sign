# H3_ZERO_SCALAR — standardowy replay

Pre-freeze rehearsal: **FRESH_REPLAY_PASS**,95/95 plików znaczeniowych zgodnych.
Kotwica `artifacts/semantic_manifest.sha256`:
`a8e12dd3c55d8af56a419b2dda877d776a79b96d5a01a08616437a9febdd0ea7`.
To osobny pin rehearsal, nie końcowy hash OUTPUTS.

Po freeze, ze świeżej kopii pakietu:

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

Przed tworzeniem DEST skrypt wymaga zewnętrznego pinu i weryfikuje wszystkie
członki OUTPUTS, symlinki/ścieżki, duplikaty i matches związane z manifestem.
DEST jest nowym podkatalogiem tmp. Standardowy tryb nie nadpisuje checkpointu;
zapisuje DEST/REPLAY_RESULT.json, FRESH_REPLAY_PASS i tę samą listę matches.

Nie przenosi się olean/cache/binariów. Replay odbudowuje sześć konsumowanych
modułów H3 i nowe moduły ZeroScalar, wykonuje C normal oraz ASan/UBSan,
literalny i source-normalized model, exact dyadic oracle, phase controls,
Sage certificate, source binding/ledger i toolchain. Bootstrap i source są
read-only wewnątrz jobów. Nie ma zależności od Dokumenty/H, starego W, USB
ani tymczasowego worktree prowadzącego.

ANALYTIC_PROOF.md/M0_COMPATIBILITY.md są przypiętymi tekstami dowodu/opisu.
Ich byte equality nie jest kernelowym sprawdzeniem całej treści. Raport
zachowuje mixed-proof scope: A/OF/lematy arytmetyczne kernelowe, pełna
source-add error composition oraz r/delta case analysis analityczne.
Ten zakres jest zapisany również w każdym REPLAY_RESULT.

17 modułów Lean (z audytami) odbudowano z -j1 -M2048 i8GiB address space.
Każdy job ma skończony wall/CPU limit. Sanitizer dostaje osobny FT1536_ASAN=1
tryb rezerwacji virtual shadow; controller nie może dziedziczyć twardego8GiB
limitu uniemożliwiającego ASan. Zwykłe child jobs narzucają8GiB osobno.
HOME/TMPDIR/DOT_SAGE/LEAN_PATH i wszystkie cache są pod świeżym DEST.

Pełne command/stdout/stderr receipts rehearsal są zachowane pod
artifacts/rehearsal/ z listą replay_evidence.json. Cwd/czasy są osobną
ewidencją, nie deterministic matches. artifacts/fresh_replay.json i wszystkie
95 matches należą do OUTPUTS. Nie tworzy się cyklu hashowania: receipt
rehearsal nie jest członkiem własnej listy matches.

Po freeze standardowy replay wymaga finalnego pinu i zapisuje tylko w swoim
DEST. Nie rozszerza lokalnego wyniku do H3_RANGE, Reach ani sampler law.

Lokalny kontroler końcowego uruchomienia:

```sh
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/post_freeze.py /ABSOLUTE/COPY/tmp/final_standard_001 EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
```

`post_freeze.py` uruchamia dokładnie protokół standard wewnątrz bwrap, z W
read-only i jedynym zapisem pod tmp, przy ukrytych Dokumenty i stages.
Zachowuje pełne streams, limity i command receipt `DEST/POST_FREEZE.json`,
sprawdzając ten sam końcowy manifest przed uruchomieniem i po nim.
Te post-freeze receipts należą do nowego DEST, nie do zamrożonego OUTPUTS.
