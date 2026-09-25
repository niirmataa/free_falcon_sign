#!/usr/bin/env bash
# Odłączony kompilat BlockTheta (przeżywa restart sesji).
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
LOG="$W/CENTERING_CLOSURE/logs/v8_full.log"
t0=$(date +%s)
timeout 900 "$LEAN" -o "$W/run/check_lib/BlockTheta.olean" \
  "$W/CENTERING_CLOSURE/formal/BlockTheta.lean" > "$LOG" 2>&1
ec=$?
t1=$(date +%s)
{
  echo "exit=$ec czas=$((t1-t0))s data=$(date)"
  if [ $ec -eq 0 ]; then echo "STATUS=CLEAN"; fi
} >> "$LOG"
