#!/bin/sh
# run_lean.sh <root> <src:rel-do-root> <out.olean> [timeout_s]
# Strzeżona, seryjna kompilacja C_TASK_1_BINBIND.
# Zasady: grep sorry/admit/native_decide == 0 przed startem; brak obcych
# procesów lean/sage/lake; LEAN_PATH z własnym build/ NA PIERWSZYM miejscu;
# HOME/TMPDIR pod trwałym W; log 0 err/0 warn.
set -e
T=/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_1_BINBIND
W=/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001
ROOT="$1"
SRC="$2"
OUT="$3"
TMO="${4:-900}"
LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
B20=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01
UPSTREAM="$B20/bootstrap/mathlib4/.lake/build/lib/lean"
for p in plausible importGraph LeanSearchClient batteries aesop proofwidgets Qq; do
  UPSTREAM="$UPSTREAM:$B20/run/.lake/packages/$p/.lake/build/lib/lean"
done
UPSTREAM="$UPSTREAM:/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/lib/lean"
export LEAN_PATH="$T/build:$W/run/check_lib:$UPSTREAM"
export HOME="$T/build/home" TMPDIR="$T/build/tmp"
mkdir -p "$T/build/home" "$T/build/tmp"

# guard 1: zero sorry/admit/native_decide
for bad in sorry admit native_decide; do
  n=$(grep -cw "$bad" "$ROOT/$SRC" || true)
  if [ "$n" != "0" ]; then
    echo "GUARD_FAIL: $bad x$n w $ROOT/$SRC" >&2
    exit 2
  fi
done

# guard 2: brak obcych procesów lean/sage/lake — tryb czekania na wolne okno
# (protokół WORK_STATE: odpytanie co 30 s, maks. 40 tur = 20 min)
i=0
while pgrep -af 'bin/lean|bin/sage|lake' | grep -v 'run_lean.sh' | grep -v "pgrep" >/dev/null 2>&1; do
  i=$((i+1))
  if [ "$i" -gt 40 ]; then
    echo "GUARD_FAIL: obcy proces lean/sage/lake po 20 min czekania:" >&2
    pgrep -af 'bin/lean|bin/sage|lake' | grep -v 'run_lean.sh' >&2 || true
    exit 3
  fi
  echo "WAIT($i) na wolne okno Lean..." >&2
  sleep 30
done

mkdir -p "$(dirname "$OUT")"
LOG="$T/logs/$(echo "$SRC" | tr '/' '_').build.log"
echo "COMPILE $(date -u '+%Y-%m-%dT%H:%M:%SZ') root=$ROOT $SRC -> $OUT" > "$LOG"
cd "$ROOT"
timeout "$TMO" "$LEAN" -o "$OUT" "$SRC" >> "$LOG" 2>&1 || echo "EXIT=$? (timeout/error)" >> "$LOG"
# guard 3: log bez błędów i ostrzeżeń
if grep -qi 'warning\|error' "$LOG"; then
  echo "LOG_NOT_CLEAN: $LOG" >&2
  exit 4
fi
echo "OK $SRC" >> "$LOG"
exit 0
