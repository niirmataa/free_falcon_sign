#!/usr/bin/env bash
# C_TASK_3_REFINE — strzezone uruchomienie sage (tryb: sage <plik>.sage).
# Uzycie: bash run_sage_guarded.sh <plik.sage> [timeout_s] [wait_s]
set -u
T=~/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_3_REFINE
export HOME="$T/home" TMPDIR="$T/tmp"
SRC="${1:?plik.sage}"
TMO="${2:-300}"
WAIT="${3:-1800}"
mkdir -p "$T/build/logs"
LOG="$T/build/logs/$(basename "${SRC%.sage}").sage.log"

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
timeout "$TMO" sage "$SRC" > "$LOG" 2>&1
ec=$?
t1=$(date +%s)
echo "exit=$ec czas=$((t1-t0))s log=$LOG"
tail -3 "$LOG"
exit $ec
