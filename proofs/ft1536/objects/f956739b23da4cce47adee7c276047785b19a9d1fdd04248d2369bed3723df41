"""Compiler/source-flow receipts; bounded public tool discovery, no timing claim."""
import json
import os
from pathlib import Path
import platform
import re
import shutil
from common import W, B, S, flags, job, dump, sha

def main():
    (W/'bin/static').mkdir(parents=True,exist_ok=False)
    versions = {}
    tools = {'gcc':'/usr/bin/gcc','python':'/usr/bin/python3','bwrap':'/usr/bin/bwrap',
             'objdump':'/usr/bin/objdump','sage':'/home/footfalcon/.local/bin/sage',
             'lean':'/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'}
    for name,path in tools.items():
        p = job(name+'-version',[path,'--version'])
        versions[name] = dict(path=path,sha256=sha(path),version=p.stdout.decode())
    assert '14.2.0' in versions['gcc']['version']
    assert '10.9' in versions['sage']['version']
    assert '4.34.0' in versions['lean']['version']
    cpu = Path('/proc/cpuinfo').read_text()
    mounts = Path('/proc/self/mountinfo').read_text()
    (W/'logs/cpuinfo.txt').write_text(cpu)
    (W/'logs/mountinfo.txt').write_text(mounts)
    mountrows = [ln.split() for ln in mounts.splitlines()]
    assert any(v[4]==str(B) and 'ro' in v[5].split(',') for v in mountrows)
    assert any(v[4]==str(W) and 'rw' in v[5].split(',') for v in mountrows)
    assert any(v[4]=='/' and 'ro' in v[5].split(',') for v in mountrows)
    net = sorted(p.name for p in Path('/sys/class/net').iterdir())
    # /proc/net is namespace-local; no external connection is attempted.
    route = Path('/proc/net/route').read_text()
    assert len(route.splitlines()) == 1
    receipt = dict(versions=versions,flags=flags(),platform=platform.platform(),
                   machine=platform.machine(),affinity=sorted(os.sched_getaffinity(0)),
                   cpu_model=next(ln.split(':',1)[1].strip() for ln in cpu.splitlines() if ln.startswith('model name')),
                   loadavg=Path('/proc/loadavg').read_text().strip(),
                   network_route=route,network_interfaces=net,
                   sandbox_checks='root RO, bootstrap RO, W RW, network route empty',
                   concurrent_work='NODE2 may run independently; no process/working-directory inspection')
    dump('artifacts/platform.json',receipt)
    (W/'TOOLCHAIN.txt').write_text('\n'.join(f'{k}: {v["path"]}\n{v["version"]}SHA256 {v["sha256"]}' for k,v in versions.items())+
        '\nABI: Linux x86_64 LP64; GCC arithmetic signed right shift; C99.\nFLAGS: '+repr(flags())+'\n')

    availability = {n:shutil.which(n) for n in ('dudect','ctgrind','valgrind','taskset')}
    # These roots were checked by directory listing. No private tree is traversed.
    roots = [Path('/home/footfalcon/free_falcon_sign/tests'),
             Path('/home/footfalcon/free_falcon_sign/.build'),
             Path('/media/footfalcon/16AA-3188/FALCON_FPEMU_ternary_clean_648e3b9/tools')]
    found=[]
    for root in roots:
        if not root.is_dir() or root.is_symlink(): continue
        for here,dirs,files in os.walk(root,followlinks=False):
            dirs[:] = sorted(d for d in dirs if not d.startswith('.') and 'private' not in d.lower()
                              and not (Path(here)/d).is_symlink())
            for name in sorted(files):
                if ('dudect' in name.lower() or 'ctgrind' in name.lower()) and not (Path(here)/name).is_symlink():
                    found.append(str(Path(here)/name))
    dump('artifacts/timing_tools.json',dict(installed=availability,public_roots=[str(r) for r in roots],
        public_filename_matches=found,network_or_install=False,
        historical_data_read=False,status='NOT_RUN',
        reason='No version-matched audit harness established; parallel-session measurement conditions not controlled.'))

    calls = {}
    for name in ('falcon-keygen.c','falcon-fft.c','falcon-sign.c','falcon-vrfy.c'):
        p=job('preprocess-'+name,['/usr/bin/gcc',*flags(),'-E','inputs/bootstrap/source/'+name])
        (W/'bin/static'/name.replace('.c','.i')).write_bytes(p.stdout)
        rows=[]; file=''; line=0
        for ln in p.stdout.decode().splitlines():
            m=re.match(r'# (\d+) "([^"]+)"',ln)
            if m: line=int(m[1]);file=m[2];continue
            if file.endswith('/'+name):
                for fn in sorted(set(re.findall(r'\b(fpr_\w+)\s*\(',ln))):
                    rows.append(dict(line=line,function=fn))
            line+=1
        calls[name]=rows
    dump('artifacts/active_calls.json',calls)
    compile_cmd=['/usr/bin/gcc',*flags(),'-c','checks/wrappers.c','-o','bin/static/wrappers.o']
    job('assembly-object',compile_cmd)
    p=job('disassembly',['/usr/bin/objdump','-dr','bin/static/wrappers.o'])
    (W/'artifacts/disassembly.txt').write_bytes(p.stdout)
    symbols={}; current=None
    for ln in p.stdout.decode().splitlines():
        m=re.match(r'^[0-9a-f]+ <([^>]+)>:',ln)
        if m: current=m[1];symbols[current]=[]
        elif current and re.search(r'\b(j[a-z]+|cmov[a-z]+|callq?|idiv|divq?)\b',ln):
            symbols[current].append(ln.strip())
    dump('artifacts/assembly_control_flow.json',dict(object_sha256=sha(W/'bin/static/wrappers.o'),
         source_sha256=sha(W/'checks/wrappers.c'),symbols=symbols))
    print('PASS: pinned toolchain, sandbox mounts/network, active call map and GCC -O disassembly; timing NOT_RUN')

if __name__=='__main__': main()
