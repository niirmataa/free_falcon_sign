"""Shared receipt/command logging for the T02.1 package (organization only).

Mathematical and binding checks live in the authoritative .sage files; this
module only runs commands, stores hashes/logs and appends COMMANDS.log records.
"""
import json,subprocess
from pathlib import Path
from replaylib import sha
W=Path(__file__).absolute().parents[1]
LOGS=W/'logs'
COMMANDS=W/'COMMANDS.log'
def write_logs(name,stdout,stderr):
 LOGS.mkdir(exist_ok=True)
 so=LOGS/(name+'.stdout');se=LOGS/(name+'.stderr')
 so.write_bytes(stdout);se.write_bytes(stderr)
 return so,se
def append_command(rec):
 with COMMANDS.open('a') as f:
  f.write(json.dumps(rec,sort_keys=True)+'\n')
def run_logged(name,argv,cwd=None,env=None,timeout=1800,preexec=None,input=None):
 cwd=Path(cwd) if cwd is not None else W
 timed_out=False
 try:
  p=subprocess.run([str(a) for a in argv],cwd=str(cwd),env=env,input=input,capture_output=True,timeout=timeout,preexec_fn=preexec)
  code,so,se=p.returncode,p.stdout,p.stderr
 except subprocess.TimeoutExpired as e:
  timed_out=True;code=None;so=e.stdout or b'';se=e.stderr or b''
 so_p,se_p=write_logs(name,so,se)
 rec=dict(name=name,argv=[str(a) for a in argv],cwd=str(cwd),exit_code=code,timeout=timed_out,stdout_bytes=len(so),stderr_bytes=len(se),stdout_sha256=sha(so_p),stderr_sha256=sha(se_p))
 append_command(rec)
 if timed_out:raise RuntimeError('command timed out: '+name)
 return rec,so,se
