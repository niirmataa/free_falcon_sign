#!/usr/bin/env python3
"""Observe the packaging process which survived a harness restart."""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import select
import sys

W = Path(__file__).resolve().parent.parent
pid = int(sys.argv[1])
result = {'pid': pid, 'new_compute_worker_started': False,
          'method': 'pidfd and blocking select; no polling', 'controller_exit_code': None}
try:
    proc = Path('/proc') / str(pid)
    argv = proc.joinpath('cmdline').read_bytes().replace(b'\0', b' ').decode()
    if 'run/final_package.py' not in argv or proc.joinpath('cwd').resolve() != W:
        raise RuntimeError('PID no longer identifies this preparation')
    result.update(original_command=argv, pid_starttime_ticks=proc.joinpath('stat').read_text().split()[21])
    fd = os.pidfd_open(pid)
    ready, _, _ = select.select([fd], [], [], 1800)
    os.close(fd)
    if not ready:
        raise RuntimeError('preparation still active after observation deadline')
    result['observed_process_exit'] = True
except FileNotFoundError:
    result['observed_process_exit'] = False
    result['process_already_absent_at_attach'] = True
result['utc'] = datetime.now(timezone.utc).isoformat()
receipt = W / 'run/RESUME_A3_20260929/PACKAGE_PREPARATION.json'
result['preparation_receipt_present'] = receipt.exists()
if receipt.exists():
    result['preparation_receipt'] = json.loads(receipt.read_text())
path = W / 'run/RESUME_A3_20260929/RESTART_PREPARATION.json'
path.write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result, indent=2), flush=True)
