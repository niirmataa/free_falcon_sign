"""RO package controller; only the pre-existing tmp parent may be written."""
import os,subprocess,sys
from pathlib import Path
W=Path(__file__).resolve().parents[1];D=Path(sys.argv[1]);assert D.is_absolute() and not D.exists() and D.parent.resolve().is_relative_to((W/'tmp').resolve())
box=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--unshare-pid','--ro-bind','/','/','--bind',str(D.parent),str(D.parent),'--proc','/proc','--dev','/dev','--chdir',str(W)]
for p in ['/home/footfalcon/Dokumenty','/home/footfalcon/free_falcon_sign/proofs/ft1536/stages']:
 if Path(p).is_dir():box+=['--tmpfs',p]
env=dict(os.environ);env['PYTHONDONTWRITEBYTECODE']='1';env['PYTHONOPTIMIZE']='0';env['GIT_OPTIONAL_LOCKS']='0'
p=subprocess.run(box+['--',sys.executable,'-B',str(W/'scripts/replay.py')]+sys.argv[1:],env=env,timeout=1800)
raise SystemExit(p.returncode)
