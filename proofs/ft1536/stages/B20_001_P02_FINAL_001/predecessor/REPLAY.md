# P02 — REPLAY (jak odtworzyć wynik)

## Wymagania

Lean4.34.0, Mathlib4@5ed2965… (shared bootstrap P01), SageMath10.9, gcc.
Sieć wyłączona (bwrap --unshare-net wbudowane w job.py).

## Procedura (fresh replay, pełna)

```sh
cd /home/footfalcon/free_falcon_sign
python3 -B proofs/ft1536/work/B20_001/P02/run/job.py REPLAY_NAME replay
```

Tryb replay: (1) nowy DEST z RO-snapshota źródeł + hash przed/po,
(2) toolchain gate (9 repo, piny), (3) regeneracja transportu
(embed_source/embed_le/embed_scalar + check_transport — byte-exact),
(4) kontrole: controls.py(word), le_controls.py, scalar_controls.py(normal
w tym 5 mutantów), (5) 34 moduły Lean (BUILD_PLAN) w kolejności, każdy
jako osobny krok z własnym stdout/stderr i limitem 1800s.

## Ostatni replay (przed freeze)

`run/replay_001`: 42/42 kroków exit 0 (7 gate/transport/controls + 34 Lean
+ finalny audyt), źródła unchanged, producenci wyczyszczeni przed krokiem.

## Osobne ASan (tryb asan; TASK §6 wyjątek od limitu 8GiB dla shadow mapy)

```sh
python3 -B .../job.py NAME asan /usr/bin/python3 -B "{source}/tools/controls.py" asan
python3 -B .../job.py NAME asan /usr/bin/python3 -B "{source}/tools/le_controls.py" asan
python3 -B .../job.py NAME asan /usr/bin/python3 -B "{source}/tools/scalar_controls.py" asan
```

Ostatnie: `run/word_asan_002` (12288 cases), `run/le_asan_002` (3072),
`run/scalar_asan_001` (19721 in + 21352 obs) — wszystkie exit 0.

## Skan eksportów

```sh
python3 -B .../job.py freeze_scan lean <32 moduły BUILD_PLAN> ProbeFreezeScan.lean
```

`#check @name` + `#print axioms name` dla 489 nazw; wyniki: FORMAL_EXPORTS.json
(pełne typy) i AXIOMS.json.
