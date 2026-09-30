#!/usr/bin/env bash
# C_TASK_3_REFINE — ciagla obserwacja workerow (zapis migawek co 60s).
T=~/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_3_REFINE
LOG="$T/build/logs/observe.log"
echo "=== watcher start $(date -u +%FT%TZ)" >> "$LOG"
PREV=""
while true; do
  CUR=$(pgrep -af 'lean|sage|lake' | grep -v 'pgrep\|bash -c\|observe' | awk '{print $1, $NF}' | sort)
  LOAD=$(cut -d' ' -f1-3 /proc/loadavg)
  if [ "$CUR" != "$PREV" ]; then
    echo "--- $(date -u +%FT%TZ) load=$LOAD zmiana:" >> "$LOG"
    echo "${CUR:-brak procesow}" >> "$LOG"
    PREV="$CUR"
  fi
  sleep 60
done
