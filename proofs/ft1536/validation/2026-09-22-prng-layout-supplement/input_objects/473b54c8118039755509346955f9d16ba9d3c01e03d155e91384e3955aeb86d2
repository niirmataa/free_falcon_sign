# T02.1 — suplement sprostowawczy F1–F5 (RUN_003)

Autor projektu Niirmata; zachowaj Falcon Project / Thomas Pornin i licencje.
Jeden model wybrany i uruchomiony przez właściciela. Osobny W,bez subagentów/relay.
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_003
TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/FT1536_ZADANIE_T02_1_PRNG_LAYOUT_COUNTER_2026-09-22.md
TASK SHA=7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1
BASE=c90233c171265e050930958fb29bafa9338f81ff
IN=W/inputs/bootstrap
MANIFEST SHA=03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2
Poprzednik: ../FT1536_PRNG_LAYOUT_COUNTER_RUN_002 (FROZEN, OUTPUTS
8eda4cb98b754c5f20c8db2a34ff5055bffd535f626dc12d87b56c816406e5a7;
odbiór niezależny: CHANGES_REQUIRED, wyłącznie F1–F5 zakres/dokumentacja).
RUN_001/002 nietknięte. Ten W nanosi TYLKO sprostowania F1–F5 (teksty scope,
słowo „frame", liczby plików w REPLAY, klucze `*_max`, `task_id`); matematyka
(Sage/C/Lean, liczby 396/25408/406528/896/936) bez zmian.

Zakres jak RUN_002 (kernel Lean 28 thm + Sage exact + C). Lean4.34,j1/-M2048,
clean logs/types/terms/axioms,bez sorry/admit/native_decide/Lean.ofReduceBool/
aksjomatu celu/suppression.

Zapisy,HOME/TMPDIR/cache/olean/bin/logs/replaye tylko pod W,zakaz systemowego
/tmp,/tmp/opencode/tmpfs. Network-off,input RO,bounded single-worker,normal8GiB,
ASan osobno z shadow. Bez sieci/instalacji/Git/push,subagentów,relay,dudect.
Nie zmieniaj źródeł ani frozen RUN_001/002. Standard scripts/replay.py
ABSENT_DEST EXTERNAL_OUTPUTS_SHA,pełny manifest przed DEST,sealed
fresh_replay.json i child REPLAY_RESULT.json.

Rachunek: `sage model.sage` + `lean formal/CounterLayout.lean`; `.py` tylko
organizacja. Status docelowy: PRNG_LAYOUT_COUNTER_PROVED_FOR_PINNED_SOURCE_MODEL
(suplement); flagi jak RUN_002. Krótki odbiór suplementu wykona później inny
niezależny model właściciela.
