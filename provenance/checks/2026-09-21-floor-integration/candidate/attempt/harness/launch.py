"""Launch the explicitly budgeted, sealed campaign as a bounded user service."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import time

from campaign import campaign_seconds, dump, required_disk_bytes, sha, snapshot, utc
from profiles import PROFILES


def launch(work, seconds=None):
    work = work.resolve()
    prep = json.loads((work/'PREPARATION.json').read_text())
    if prep['status'] not in ('PREFLIGHT_PASS','STATIC_READY_TIMING_DEFERRED') or (work/'LAUNCH.json').exists() or (work/'RUN.json').exists():
        raise RuntimeError('Not a fresh preflighted campaign')
    if (work/'PREFLIGHT_FAILURE.json').exists():
        raise RuntimeError('A prior launch preflight failed; inspect it before an explicit new preparation')
    prepared_seconds = campaign_seconds(prep['global_seconds'])
    if seconds is not None and campaign_seconds(seconds) != prepared_seconds:
        raise RuntimeError('Requested budget differs from prepared budget')
    seconds = prepared_seconds
    profile_name = prep.get('profile','baseline')
    profile = PROFILES[profile_name]
    if prep.get('source_profile') != profile or prep['source_manifest_sha256'] != profile['sha256']:
        raise RuntimeError('Source profile mismatch')
    for rel,digest in prep['sealed_files'].items():
        if sha(work/rel) != digest:
            raise RuntimeError('Changed preparation: '+rel)
    here = Path(__file__).resolve().parent
    for name in ('benchmark.c','targets.c','campaign.py','prepare.py','README.md','launch.py','profiles.py'):
        if sha(here/name) != sha(work/prep['harness']/name):
            raise RuntimeError('Current/preflight harness mismatch: '+name)
    repo = here.parents[2]
    for rel,digest in prep['sealed_files'].items():
        if rel.startswith('source/') and sha(repo/profile['source']/Path(rel).name) != digest:
            raise RuntimeError('Selected source changed: '+rel)
    if sha(repo/profile['manifest']) != profile['sha256']:
        raise RuntimeError('Selected manifest changed')
    dirty = subprocess.check_output(['git','-C',str(repo),'status','--porcelain'])
    if dirty:
        raise RuntimeError('Commit the reviewed preparation before launching')
    head = subprocess.check_output(['git','-C',str(repo),'rev-parse','HEAD']).decode().strip()
    fs = os.statvfs(work)
    required = required_disk_bytes(seconds)
    if fs.f_bavail * fs.f_frsize < required:
        raise RuntimeError('Insufficient free disk for the prepared campaign logs plus the reserve')
    unit = profile['unit']
    if prep['status']=='STATIC_READY_TIMING_DEFERRED':
        before = snapshot()
        if any(v=='Discharging' for k,v in before['files'].items() if '/power_supply/' in k and k.endswith('/status')):
            raise RuntimeError('Connect mains power before launch preflight')
        # This explicit launch starts fresh preflight only after the owner ends daytime jobs.
        command=['/usr/bin/timeout','--kill-after=5s','180s',sys.executable,'-B',str(here/'prepare.py'),
                  '--repo',str(repo),'--work',str(work),'--resume','--profile',profile_name,
                  '--seconds',str(seconds)]
        with (work/'launch-preflight.stdout').open('xb') as out,(work/'launch-preflight.stderr').open('xb') as err:
            p=subprocess.run(command,stdout=out,stderr=err,timeout=190)
        if p.returncode:
            dump(work/'PREFLIGHT_FAILURE.json',dict(utc=utc(),argv=command,exit_code=p.returncode,
                 long_campaign_started=False))
            raise RuntimeError('Launch preflight failed; long campaign was not started')
        prep=json.loads((work/'PREPARATION.json').read_text())
        if (prep['status']!='PREFLIGHT_PASS' or prep['source_profile']!=profile
                or campaign_seconds(prep['global_seconds'])!=seconds):
            raise RuntimeError('Fresh preflight did not pass')
        for rel,digest in prep['sealed_files'].items():
            if sha(work/rel)!=digest:
                raise RuntimeError('Fresh preparation changed: '+rel)
        if subprocess.check_output(['git','-C',str(repo),'status','--porcelain']):
            raise RuntimeError('Repository changed during launch preflight')
        if subprocess.check_output(['git','-C',str(repo),'rev-parse','HEAD']).decode().strip()!=head:
            raise RuntimeError('Harness commit changed during launch preflight')
    program = work/prep['harness']/'campaign.py'
    argv = ['systemd-run','--user','--service-type=exec','--unit='+unit,
            '--description=FT1536 '+profile_name+' dudect, bounded '+str(seconds)+'-second campaign',
            '--property=RuntimeMaxSec='+str(seconds),'--property=TimeoutStopSec=5s',
            '--property=KillMode=control-group','--property=LimitCORE=0',
            '--property=NoNewPrivileges=yes','--working-directory='+str(work),
            '--property=StandardOutput=append:'+str(work/'controller.stdout'),
            '--property=StandardError=append:'+str(work/'controller.stderr'),
            '/usr/bin/systemd-inhibit','--no-ask-password','--what=sleep:idle',
            '--mode=block','--who=FT1536-dudect','--why=Bounded '+str(seconds)+'-second FPEMU measurements',
            '/usr/bin/python3','-B',str(program),str(work),'--seconds',str(seconds),'--cpu',str(prep['cpu'])]
    before = snapshot()
    for p,val in before['files'].items():
        if p.endswith('/status') and val=='Discharging' and '/power_supply/' in p:
            raise RuntimeError('Connect mains power before the campaign')
    dump(work/'machine_launch.json',before)
    p = subprocess.run(argv,capture_output=True,text=True,timeout=30)
    info = dict(request_utc=utc(),unit=unit,argv=argv,exit_code=p.returncode,
                stdout=p.stdout,stderr=p.stderr,harness_git_commit=head,
                preparation_sha256=sha(work/'PREPARATION.json'),cpu=prep['cpu'],
                launcher_sha256=sha(Path(__file__)),profile=profile_name,
                source_manifest_sha256=profile['sha256'],budget_seconds=seconds,
                runtime_max_seconds=seconds,required_free_bytes=required)
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
    p.add_argument('--seconds',type=int,help='Require this exact prepared budget; otherwise use PREPARATION.json')
    args=p.parse_args()
    launch(args.work,args.seconds)
