#!/usr/bin/env python3
"""Local command logger; no shell, all child caches and temporaries under W."""
import sys, os, subprocess, json, datetime, time, hashlib
from pathlib import Path
W = Path(__file__).resolve().parents[1]
env = dict(os.environ)
env.update(TMPDIR=str(W/'tmp'), TMP=str(W/'tmp'), TEMP=str(W/'tmp'),
           XDG_CACHE_HOME=str(W/'cache'), DOT_SAGE=str(W/'cache'/'sage'),
           PYTHONPYCACHEPREFIX=str(W/'cache'/'pycache'), MPLCONFIGDIR=str(W/'cache'/'mpl'),
           GIT_OPTIONAL_LOCKS='0')
argv = sys.argv[1:]
start = datetime.datetime.now(datetime.timezone.utc).isoformat()
tag = start.replace(':','').replace('.','')
t = time.monotonic()
p = subprocess.run(argv, cwd=W, env=env, capture_output=True)
for name, data in [('stdout',p.stdout),('stderr',p.stderr)]:
    (W/'logs'/f'{tag}.{name}').write_bytes(data)
record = dict(start_utc=start, cwd=str(W), argv=argv, exit_code=p.returncode,
              elapsed_seconds=time.monotonic()-t, stdout=f'logs/{tag}.stdout',
              stderr=f'logs/{tag}.stderr', cache_environment={k:env[k] for k in
              ['TMPDIR','XDG_CACHE_HOME','DOT_SAGE','PYTHONPYCACHEPREFIX','MPLCONFIGDIR','GIT_OPTIONAL_LOCKS']})
with (W/'COMMANDS.log').open('a') as f: f.write(json.dumps(record)+'\n')
sys.stdout.buffer.write(p.stdout)
sys.stderr.buffer.write(p.stderr)
sys.exit(p.returncode)
