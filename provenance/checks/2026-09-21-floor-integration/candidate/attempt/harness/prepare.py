"""Pin and build an explicit source profile; optionally defer timing until night."""
import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shlex
import shutil
import struct
import subprocess
import sys
import time
import urllib.request
from fractions import Fraction

from campaign import (CASES, MAX_CAMPAIGN_SECONDS, campaign_seconds, child_environment,
                      choose_cpu, dump, order_for, replay_check, run_trial, sha, snapshot, utc)
from profiles import PROFILES, floor_assembly_ok

UPSTREAM = 'dc269651fb2567e46755cfb2a13d3875592968b5'
BLOBS = {'src/dudect.h': 'ff8cfce31e2d958e5408b19bad0f46841fc1a4a6',
         'LICENSE': '8869bf6ee9134f230f6219537e3b82db4a9371e6',
         'README.md': '67bbe9538048c1f4be84e7decb1f355bf47e130b'}
UPSTREAM_SHA256 = {
    'src/dudect.h': '3fb3b2bd7f9e17ae34b7c92518c1311c67342c56facc80da925d85f121b649da',
    'LICENSE': 'ee7cd5d500ab72e03a6c8aefe69c6311d698c83e732b19d152a6fa38fd521720',
    'README.md': '5e94b47c43db9bd42777dfdb95489081b32b163f6fe8389a92ea7bd683de3048',
}
MASK = (1 << 64)-1


def bits(x):
    return struct.unpack('<Q', struct.pack('<d', x))[0]


def value(x):
    return struct.unpack('<d', struct.pack('<Q', x))[0]


def fixture_oracle(case, lines, coefficients):
    count = [0, 0]
    known_zero_issue = 0
    for line in lines.splitlines():
        cl, sx, sy, so = line.split()
        c = int(cl); x, y, actual = (int(s, 16) for s in (sx, sy, so))
        count[c] += 1
        a, b = value(x), value(y)
        if case != 13 and not (math.isfinite(a) and math.isfinite(b)):
            raise RuntimeError('Nonfinite fixture')
        if case in (0,2,3,4):
            assert -1 < a < 1
            if case == 0: assert .25 <= a < .5
            if case == 4: assert ((x >> 52) & 2047) == 1021+c
            expected = math.floor(a) & MASK
        elif case == 1:
            expected = 1
            for _ in range(256 if c else 8): expected = (expected * 6364136223846793005 + 1) & MASK
        elif case == 5:
            assert 1 <= a < 2 and b == (a if c==0 else -a)
            expected = bits(a+b)
        elif case == 6:
            assert a == b and (a*a >= 2) == bool(c)
            expected = bits(a*b)
        elif case == 7:
            assert 1 <= a < 2 and b == (2**35 if c else 1/16)
            expected = bits(a/b)
        elif case == 8:
            assert 1 <= a < 4 and ((x>>52)&2047) == 1023+c
            expected = bits(math.sqrt(a))
        elif case == 9:
            assert a-math.floor(a) == (.25 if c else .5)
            expected = round(a) & MASK
        elif case == 10:
            assert 0 <= a <= value(0x3fe62e42fefa39ef)
            # Independent wide-integer high product, not the C limb routine.
            z = int(Fraction(a) * 2**63) * 2
            expected = coefficients[0]
            for coef in coefficients[1:]: expected = (coef - ((z*expected)>>64)) & MASK
        elif case == 11:
            assert x == ((1+c)<<52) | 1
            # NODE2 finite-word half semantics; deliberately not IEEE RN half.
            e = (x >> 52) & 2047
            expected = (x & (1<<63 | (1<<52)-1)) | ((e-1)<<52) if e else 0
        elif case == 12:
            assert x == (0 if c else 1<<63) and y == 0
            expected = 1-c
            known_zero_issue += expected
        elif case == 13:
            assert (x == 0) == (c == 0) and x <= 2**31
            expected = bits(float(x))
        else:
            raise ValueError(case)
        if actual != expected:
            raise RuntimeError(f'{CASES[case]}: {sx} {sy}: {so} != {expected:016x}')
    if count != [1024,1024]: raise RuntimeError('Fixture counts')
    return dict(case=CASES[case], per_class=count, status='SCOPED_FIXTURE_ORACLE_MATCH',
                known_numeric_signed_zero_mismatches=known_zero_issue)


def prepare(repo, work, resume, profile_name='baseline', defer_timing=False,
            seconds=MAX_CAMPAIGN_SECONDS):
    if not __debug__:
        raise RuntimeError('Assertions must remain enabled for fixture checks')
    seconds = campaign_seconds(seconds)
    profile = PROFILES[profile_name]
    if sys.byteorder != 'little' or os.uname().machine != 'x86_64':
        raise RuntimeError('Protocol requires little-endian x86_64')
    if work.exists() and not resume: raise RuntimeError('Work already exists; explicit --resume retains attempts')
    if (work/'RUN.json').exists(): raise RuntimeError('Campaign is already frozen/running')
    work.mkdir(parents=False, exist_ok=resume)
    attempt_root = work/'attempts'; attempt_root.mkdir(exist_ok=True)
    attempt = attempt_root/f'{len(list(attempt_root.iterdir())):03d}'
    attempt.mkdir()
    code = attempt/'harness'; code.mkdir()
    for p in Path(__file__).resolve().parent.iterdir():
        if p.is_file(): shutil.copyfile(p, code/p.name)
    logs = attempt/'logs'; logs.mkdir()
    build = attempt/'build'; build.mkdir()
    def job(tag, argv, timeout=120):
        argv = list(map(str, argv)); start = time.monotonic()
        p = subprocess.run(argv, cwd=work, env=child_environment(work), capture_output=True, timeout=timeout)
        (logs/(tag+'.stdout')).write_bytes(p.stdout)
        (logs/(tag+'.stderr')).write_bytes(p.stderr)
        dump(logs/(tag+'.json'), dict(argv=argv, cwd=str(work), exit_code=p.returncode,
             elapsed_seconds=time.monotonic()-start, stdout_sha256=sha(logs/(tag+'.stdout')),
             stderr_sha256=sha(logs/(tag+'.stderr'))))
        if p.returncode: raise RuntimeError(f'{tag}: exit{p.returncode}; see {logs}')
        return p.stdout.decode()
    manifest = repo/profile['manifest']
    if sha(manifest) != profile['sha256']: raise RuntimeError('Source manifest pin')
    source = work/'source'; source.mkdir(exist_ok=True)
    for line in manifest.read_text().splitlines():
        digest, name = line.split()
        original = repo/profile['source']/name
        if sha(original) != digest: raise RuntimeError('Source differs: '+name)
        dest = source/name
        if dest.exists():
            if sha(dest) != digest: raise RuntimeError('Copied source changed')
        else:
            shutil.copyfile(original,dest); dest.chmod(0o444)
    vendor = work/'vendor'; vendor.mkdir(exist_ok=True)
    origins = {}
    for name, blob in BLOBS.items():
        url = f'https://raw.githubusercontent.com/oreparaz/dudect/{UPSTREAM}/{name}'
        dest = vendor/Path(name).name
        if dest.exists(): data = dest.read_bytes()
        else:
            archived = repo/'provenance/checks/2026-09-20-dudect-preflight/vendor'/Path(name).name
            if archived.is_file():
                data = archived.read_bytes()
            else:
                with urllib.request.urlopen(url, timeout=30) as response: data = response.read()
        actual = hashlib.sha1(f'blob {len(data)}\0'.encode()+data).hexdigest()
        if actual != blob or hashlib.sha256(data).hexdigest() != UPSTREAM_SHA256[name]:
            raise RuntimeError('Upstream Git blob/SHA-256 pin: '+name)
        if not dest.exists(): dest.write_bytes(data); dest.chmod(0o444)
        origins[name] = dict(url=url, commit=UPSTREAM, git_blob=blob, sha256=sha(dest), size=len(data))
    dump(attempt/'upstream.json', origins)
    (attempt/'source.sha256').write_bytes(manifest.read_bytes())
    dump(attempt/'machine_before.json', snapshot())
    for tag, args in [('compiler',['gcc','--version']), ('kernel',['uname','-a']),
                      ('lscpu',['lscpu']), ('processes',['ps','-eo','pid,comm,pcpu,psr','--sort=-pcpu'])]: job(tag,args)
    if '14.2.0-19' not in (logs/'compiler.stdout').read_text():
        raise RuntimeError('Pinned build requires GCC Debian14.2.0-19')
    (attempt/'cpuinfo.txt').write_text(Path('/proc/cpuinfo').read_text())
    line = next(s for s in (source/'Makefile').read_text().splitlines() if s.startswith('CFLAGS = '))
    flags = shlex.split(line.split(' = ',1)[1]) + ['-std=c99','-I'+str(source)]
    for name, path in [('fpr-emulated',source/'fpr-emulated.c'), ('targets',code/'targets.c'), ('benchmark',code/'benchmark.c')]:
        job('compile-'+name, ['gcc',*flags,'-I'+str(vendor),'-c',path,'-o',build/(name+'.o')])
    binary = build/'dudect-ft1536'
    job('link',['gcc',*(build/(name+'.o') for name in ('benchmark','targets','fpr-emulated')),'-lm','-o',binary])
    job('disassembly',['objdump','-d',binary])
    # Retain an original production TU, without executing key loading or signing.
    job('production-sign',['gcc',*flags,'-S',source/'falcon-sign.c','-o',build/'falcon-sign.s'])
    target_asm = job('target-floor',['objdump','-d','--disassemble=target_floor',binary])
    if not floor_assembly_ok(target_asm, profile):
        raise RuntimeError('Floor assembly does not match the selected source profile')
    coefficients_text = (source/'fpr-emulated.h').read_text().split('fpr_expm_p63_coefficients[13] = {')[1].split('};')[0]
    coefficients = [int(s,16) for s in re.findall(r'0x([0-9A-Fa-f]+)',coefficients_text)]
    assert len(coefficients)==13
    oracle = []
    for c in range(len(CASES)):
        out = job('fixtures-'+CASES[c],[binary,'--fixtures',str(c),order_for(-1,c)])
        oracle.append(fixture_oracle(c,out,coefficients))
    dump(attempt/'fixture_oracles.json',oracle)
    cpu = None
    checks = []
    if not defer_timing:
        cpu, utilization = choose_cpu()
        dump(attempt/'cpu_selection.json',dict(cpu=cpu,busy_fraction_five_seconds=utilization,exclusive_reservation=False))
        floor_cases = (2,) if profile['floor_branch_expected'] else (2,3,4)
        for c in (1,0,*floor_cases):
            folder = attempt/('preflight-'+CASES[c])
            expected_signal = c==1 or (c in floor_cases and profile['floor_branch_expected'])
            row = run_trial(work,binary,folder,c,order_for(-1,c),30,cpu,batch_limit=0 if expected_signal else 22)
            expected_status = 'LEAKAGE_FOUND' if expected_signal else 'NO_LEAKAGE_EVIDENCE_YET'
            if not row['raw_complete'] or row['status']!=expected_status:
                raise RuntimeError('Preflight control/profile failed; all measurements retained')
            if not expected_signal and min(row['result']['n'])<1000000:
                raise RuntimeError('Insufficient preflight class counts')
            checks.append(dict(case=CASES[c],status=row['status'],n=row['result']['n'],
                               raw_replay=replay_check(binary,folder)))
        folder=attempt/'preflight-timebox'
        row=run_trial(work,binary,folder,0,order_for(-2,0),0.5,cpu)
        if not row['raw_complete'] or row['seconds']>3.5 or row['status']!='NO_LEAKAGE_EVIDENCE_YET':
            raise RuntimeError('Timebox/negative-control/cleanup failure')
        for name,digest in row['files'].items():
            if sha(folder/name)!=digest: raise RuntimeError('Streaming receipt hash mismatch')
        checks.append(dict(case='timebox',status=row['status'],seconds=row['seconds'],
                           raw_replay=replay_check(binary,folder)))
    # Truncated raw headers/frames must fail, never appear as a successful replay.
    bad_records = [b'',b'FTDUD01\n'+b'\0'*4,
                   b'FTDUD01\n'+struct.pack('<QQQ',100000,1,0)+b'\0'*17]
    for i,data in enumerate(bad_records):
        p=subprocess.run([str(binary),'--replay'],input=data,capture_output=True,timeout=10)
        (logs/f'truncated-{i}.stdout').write_bytes(p.stdout)
        (logs/f'truncated-{i}.stderr').write_bytes(p.stderr)
        if p.returncode!=2: raise RuntimeError('Truncated replay accepted')
    dump(attempt/'truncated_replay_checks.json',dict(rejected=len(bad_records),expected_exit_code=2))
    sealed = {str(p.relative_to(work)):sha(p) for p in [*source.iterdir(),*vendor.iterdir(),
              *code.iterdir(),binary,build/'targets.o',build/'fpr-emulated.o',build/'benchmark.o'] if p.is_file()}
    info=dict(status='STATIC_READY_TIMING_DEFERRED' if defer_timing else 'PREFLIGHT_PASS',
              utc=utc(),cpu=cpu,binary=str(binary.relative_to(work)),profile=profile_name,source_profile=profile,
              harness=str(code.relative_to(work)),baseline_git_commit=job('baseline-head',['git','-C',repo,'rev-parse','HEAD']).strip(),
              source_manifest_sha256=profile['sha256'],upstream=origins,cflags=flags,checks=checks,sealed_files=sealed,
              measurement_profile='EXPLORATORY_SHARED_HOST; affinity, recorded governor/turbo; no exclusive CPU claim',
               case_names=CASES,rounds=3,batch_size=100000,global_seconds=seconds,
              log_rate_limit_bytes_per_second=2*2**20)
    dump(work/'PREPARATION.json',info)
    dump(attempt/'PREPARATION.json',info)
    print(json.dumps({k:info[k] for k in ('status','cpu','binary','harness','global_seconds','checks')},indent=2))


if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('--repo',type=Path,required=True)
    p.add_argument('--work',type=Path,required=True)
    p.add_argument('--resume',action='store_true')
    p.add_argument('--profile',choices=sorted(PROFILES),default='baseline')
    p.add_argument('--defer-timing',action='store_true',help='Build/check now; select CPU and run timing preflight at launch')
    p.add_argument('--seconds',type=int,default=MAX_CAMPAIGN_SECONDS,help='Campaign budget, integer seconds up to28800')
    a=p.parse_args()
    prepare(a.repo.resolve(),a.work.resolve(),a.resume,a.profile,a.defer_timing,a.seconds)
