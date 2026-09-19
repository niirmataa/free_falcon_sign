"""Launch the sealed eight-hour campaign as a bounded user service."""
import argparse
import json
from pathlib import Path
import subprocess
import time

from campaign import dump, sha, snapshot, utc


def launch(work):
    work = work.resolve()
    prep = json.loads((work/'PREPARATION.json').read_text())
    if prep['status'] != 'PREFLIGHT_PASS' or (work/'LAUNCH.json').exists() or (work/'RUN.json').exists():
        raise RuntimeError('Not a fresh preflighted campaign')
    for rel,digest in prep['sealed_files'].items():
        if sha(work/rel) != digest:
            raise RuntimeError('Changed preparation: '+rel)
    here = Path(__file__).resolve().parent
    for name in ('benchmark.c','targets.c','campaign.py','prepare.py','README.md','launch.py'):
        if sha(here/name) != sha(work/prep['harness']/name):
            raise RuntimeError('Current/preflight harness mismatch: '+name)
    repo = here.parents[2]
    for rel,digest in prep['sealed_files'].items():
        if rel.startswith('source/') and sha(repo/'Extra/c'/Path(rel).name) != digest:
            raise RuntimeError('Active production source changed: '+rel)
    dirty = subprocess.check_output(['git','-C',str(repo),'status','--porcelain'])
    if dirty:
        raise RuntimeError('Commit the reviewed preparation before launching')
    head = subprocess.check_output(['git','-C',str(repo),'rev-parse','HEAD']).decode().strip()
    unit = 'ft1536-dudect-run-001.service'
    program = work/prep['harness']/'campaign.py'
    argv = ['systemd-run','--user','--service-type=exec','--unit='+unit,
            '--description=FT1536 baseline dudect, bounded eight-hour campaign',
            '--property=RuntimeMaxSec=28800','--property=TimeoutStopSec=5s',
            '--property=KillMode=control-group','--property=LimitCORE=0',
            '--property=NoNewPrivileges=yes','--working-directory='+str(work),
            '--property=StandardOutput=append:'+str(work/'controller.stdout'),
            '--property=StandardError=append:'+str(work/'controller.stderr'),
            '/usr/bin/systemd-inhibit','--no-ask-password','--what=sleep:idle',
            '--mode=block','--who=FT1536-dudect','--why=Bounded eight-hour FPEMU measurements',
            '/usr/bin/python3','-B',str(program),str(work),'--seconds','28800','--cpu',str(prep['cpu'])]
    before = snapshot()
    for p,val in before['files'].items():
        if p.endswith('/status') and val=='Discharging' and '/power_supply/' in p:
            raise RuntimeError('Connect mains power before the eight-hour campaign')
    dump(work/'machine_launch.json',before)
    p = subprocess.run(argv,capture_output=True,text=True,timeout=30)
    info = dict(request_utc=utc(),unit=unit,argv=argv,exit_code=p.returncode,
                stdout=p.stdout,stderr=p.stderr,harness_git_commit=head,
                preparation_sha256=sha(work/'PREPARATION.json'),cpu=prep['cpu'],
                launcher_sha256=sha(Path(__file__)))
    dump(work/'LAUNCH.json',info)
    if p.returncode:
        raise RuntimeError('systemd launch failed; see LAUNCH.json')
    for _ in range(30):
        if (work/'RUN.json').exists(): break
        time.sleep(0.2)
    show = subprocess.run(['systemctl','--user','show',unit,
        '--property=ActiveState,SubState,MainPID,ExecMainPID,ExecMainStartTimestamp,RuntimeMaxUSec,TimeoutStopUSec,KillMode,InvocationID'],
        capture_output=True,text=True,timeout=10)
    (work/'service-start.txt').write_text(show.stdout+show.stderr)
    if not (work/'RUN.json').exists():
        raise RuntimeError('Service did not initialize; inspect controller.stderr and service-start.txt')
    print(json.dumps(dict(unit=unit,service=show.stdout,run=json.loads((work/'RUN.json').read_text()),
                         work=str(work)),indent=2))


if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('work',type=Path)
    launch(p.parse_args().work)
