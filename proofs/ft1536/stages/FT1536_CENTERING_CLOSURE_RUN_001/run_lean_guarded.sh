#!/usr/bin/env bash
# Kontrolowany kompilat Lean (FT1536 CENTERING_CLOSURE):
# 1) sprawdza, czy inni workerzy właśnie kompilują (lean/sage/lake);
# 2) dopiero wtedy uruchamia lean z twardym timeoutem.
# Użycie: bash run_lean_guarded.sh <źródło.lean> [out.olean] [timeout_s]
set -u
W=~/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001
LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
B20=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01
UPSTREAM="$B20/bootstrap/mathlib4/.lake/build/lib/lean"
for p in plausible importGraph LeanSearchClient batteries aesop proofwidgets Qq; do
  UPSTREAM="$UPSTREAM:$B20/run/.lake/packages/$p/.lake/build/lib/lean"
done
UPSTREAM="$UPSTREAM:/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/lib/lean"
export LEAN_PATH="$W/run/check_lib:$UPSTREAM"
export HOME="$W/run/home" TMPDIR="$W/run/tmp"

SRC="${1:?źródło}"
OUT="${2:-$W/run/check_lib/guarded_tmp.olean}"
TMO="${3:-90}"
WAIT="${4:-0}"
LOG="${OUT%.olean}.log"

# --- kontrola obcych procesów ---
LOAD=$(cut -d' ' -f1 /proc/loadavg)
echo "load=$LOAD"
BUSY=$(pgrep -a lean 2>/dev/null | grep -v " $$" | head -3)
BUSY2=$(pgrep -a sage 2>/dev/null | head -3)
BUSY3=$(pgrep -a lake 2>/dev/null | head -3)
WAITED=0
while [ -n "$BUSY" ] || [ -n "$BUSY2" ] || [ -n "$BUSY3" ]; do
  if [ "$WAITED" -ge "$WAIT" ]; then
    echo "UWAGA: inni workerzy kompilują po ${WAIT}s czekania — NIE ruszam. Widoczne procesy:"
    echo "$BUSY"; echo "$BUSY2"; echo "$BUSY3"
    exit 42
  fi
  sleep 30
  WAITED=$((WAITED+30))
  BUSY=$(pgrep -a lean 2>/dev/null | grep -v " $$" | head -3)
  BUSY2=$(pgrep -a sage 2>/dev/null | head -3)
  BUSY3=$(pgrep -a lake 2>/dev/null | head -3)
done
[ "$WAITED" -gt 0 ] && echo "czekałem ${WAITED}s na wolne okno"

t0=$(date +%s)
timeout "$TMO" "$LEAN" -o "$OUT" "$SRC" > "$LOG" 2>&1
ec=$?
t1=$(date +%s)
echo "exit=$ec czas=$((t1-t0))s log=$LOG"
if [ $ec -eq 124 ]; then
  echo "TIMEOUT po ${TMO}s — proces ubity (kontrola procesów działa)."
fi
exit $ec
