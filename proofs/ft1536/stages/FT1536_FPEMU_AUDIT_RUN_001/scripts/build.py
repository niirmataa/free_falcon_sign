"""Fresh scalar build, exact Makefile flags, separate sanitizer profile."""
import sys
from common import W, flags, job, dump, sha

mode = sys.argv[1]
assert mode in ('normal', 'asan')
d = W/'bin'/mode
d.mkdir(parents=True, exist_ok=False)
extra = [] if mode == 'normal' else ['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g','-no-pie']
cc = '/usr/bin/gcc'
commands = [
    [cc, *flags(), *extra, 'checks/scalar.c','-lm','-o',f'bin/{mode}/scalar'],
    [cc, *flags(), *extra, 'inputs/bootstrap/checks/fpemu_smoke.c',
     'inputs/bootstrap/source/fpr-emulated.c','-lm','-o',f'bin/{mode}/smoke'],
]
for i, cmd in enumerate(commands):
    job(mode+'-compile-'+str(i), cmd)
p = job(mode+'-smoke',[f'bin/{mode}/smoke'])
(W/f'artifacts/{mode}_smoke.stdout').write_bytes(p.stdout)
dump(f'artifacts/{mode}_build.json',dict(flags=flags(), extra_flags=extra,
    compiler=cc, compiler_sha256=sha(cc), binaries={p.name:sha(p) for p in sorted(d.iterdir())},
    source_sha256={str(p.relative_to(W)):sha(p) for p in
        [W/'checks/scalar.c',W/'checks/wrappers.c',W/'inputs/bootstrap/source/fpr-emulated.c',
         W/'inputs/bootstrap/source/fpr-emulated.h']}))
print(mode+': fresh scalar/smoke build and 12 smoke checks PASS')
