#!/usr/bin/env python3
"""Wait on a surviving process via pidfd, without spawning another worker."""
import json,os,select,sys
from pathlib import Path
from datetime import datetime,timezone
W=Path(__file__).resolve().parent.parent
pid=int(sys.argv[1]);job=sys.argv[2]
cmd=Path(f'/proc/{pid}/cmdline').read_bytes().replace(b'\0',b' ').decode()
assert 'run/job.py' in cmd and job in cmd,cmd
start=Path(f'/proc/{pid}/stat').read_text().split()[21]
fd=os.pidfd_open(pid)
ready,_,_=select.select([fd],[],[],1800)
os.close(fd)
assert ready,'existing process did not finish within reattachment wait'
J=W/'run'/job
receipt=J/'logs/sage.receipt.json'
summary=dict(pid=pid,pid_starttime_ticks=start,original_command=cmd,
    observed_exit=datetime.now(timezone.utc).isoformat(),wait_method='pidfd + blocking select',
    final_step_receipt_present=receipt.exists(),new_compute_worker_started=False)
if receipt.exists():summary['step_receipt']=json.loads(receipt.read_text())
result=J/'arb_radial_result.json'
if result.exists():summary['result']=json.loads(result.read_text())
(W/'run'/('REATTACH_'+job+'.json')).write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2),flush=True)
