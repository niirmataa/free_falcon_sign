#!/usr/bin/env bash
# C_TASK_3_REFINE — strzezony kompilat Lean (zapisy WYLACZNIE w tym folderze).
# 1) czeka na wolne okno (brak lean/sage/lake u innych workerow);
# 2) uruchamia lean seryjnie (-j1) z twardym timeoutem, log do build/logs/.
# Uzycie: bash run_guarded.sh <zrodlo.lean> <out.olean> [timeout_s] [wait_s]
set -u
T=~/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_3_REFINE
W=~/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001
LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
B20=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01
UPSTREAM="$B20/bootstrap/mathlib4/.lake/build/lib/lean"
for p in plausible importGraph LeanSearchClient batteries aesop proofwidgets Qq; do
  UPSTREAM="$UPSTREAM:$B20/run/.lake/packages/$p/.lake/build/lib/lean"
done
UPSTREAM="$UPSTREAM:/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/lib/lean"
export LEAN_PATH="$T/build:$W/run/check_lib:$UPSTREAM"
export HOME="$T/home" TMPDIR="$T/tmp"

SRC="${1:?zrodlo}"
OUT="${2:?out.olean}"
TMO="${3:-300}"
WAIT="${4:-1800}"
mkdir -p "$(dirname "$OUT")" "$T/build/logs"
LOG="$T/build/logs/$(basename "${OUT%.olean}").log"

self=$$
busy() {
  pgrep -a lean 2>/dev/null | grep -v " $self " | grep -v 'run_guarded' | head -3
  pgrep -a sage 2>/dev/null | grep -v " $self " | head -3
  pgrep -a lake 2>/dev/null | grep -v " $self " | head -3
}
echo "load=$(cut -d' ' -f1 /proc/loadavg)"
B=$(busy)
WAITED=0
while [ -n "$B" ]; do
  if [ "$WAITED" -ge "$WAIT" ]; then
    echo "UWAGA: obcy workerzy kompiluja po ${WAIT}s — NIE ruszam. Procesy:"
    echo "$B"
    exit 42
  fi
  sleep 30
  WAITED=$((WAITED+30))
  B=$(busy)
done
[ "$WAITED" -gt 0 ] && echo "czekalem ${WAITED}s na wolne okno"

t0=$(date +%s)
timeout "$TMO" "$LEAN" -j1 -M6144 -o "$OUT" "$SRC" > "$LOG" 2>&1
ec=$?
t1=$(date +%s)
echo "exit=$ec czas=$((t1-t0))s log=$LOG"
if [ $ec -eq 124 ]; then
  echo "TIMEOUT po ${TMO}s — proces ubity."
fi
exit $ec
