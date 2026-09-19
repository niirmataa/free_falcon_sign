#!/usr/bin/env python3
"""Build the exact S17 profile out of tree; retain source and execution receipts."""
import argparse
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import signal
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).absolute().parents[1]
SOURCE = ROOT / 'Extra/c'
MANIFEST = ROOT / 'provenance/ft1536-s17.sha256'
MANIFEST_SHA = '03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589'
OUTPUT = ROOT / '.build/FT1536'
WITNESS = ROOT / 'proofs/ft1536/stages/FT1536_LV_STATIC_RUN_001'


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def safe(path):
    for part in [*path.parents, path]:
        require(not part.is_symlink(), 'Symlink is not a build input/output: ' + str(part))
    return path


def read(path):
    return safe(path).read_bytes()


def sha(data):
    return hashlib.sha256(data).hexdigest()


def write_json(path, value):
    safe(path).write_text(json.dumps(value, indent=2) + '\n', encoding='utf-8')


def verified_sources():
    raw = read(MANIFEST)
    require(sha(raw) == MANIFEST_SHA, 'S17 manifest pin mismatch')
    files = {}
    for line in raw.decode().splitlines():
        digest, name = line.split()
        require(re.fullmatch(r'[a-zA-Z0-9_.-]+', name) is not None and name not in ('.', '..'), 'Unsafe source name')
        require(name not in files, 'Duplicate source entry')
        data = read(SOURCE / name)
        require(sha(data) == digest, 'Source differs from selected S17: ' + name)
        files[name] = (digest, data)
    require(len(files) == 17, 'Expected the complete 17-file S17 source set')
    return files


def publish(source, destination):
    safe(destination)
    with tempfile.NamedTemporaryFile(dir=OUTPUT, prefix='publish-', delete=False) as stream:
        temporary = Path(stream.name)
        stream.write(read(source))
    temporary.chmod(0o755)
    temporary.replace(destination)


def execute(mode):
    files = verified_sources()
    if mode == 'verify':
        print(json.dumps({'source_files': len(files), 'source_manifest_sha256': MANIFEST_SHA, 'result': 'PASS'}, indent=2))
        return
    gcc = shutil.which('gcc')
    make = shutil.which('make')
    require(gcc and make, 'GCC and GNU Make are required')
    safe(OUTPUT).mkdir(parents=True, exist_ok=True)
    with safe(OUTPUT / 'build.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        run = Path(tempfile.mkdtemp(prefix='run-', dir=OUTPUT))
        source = run / 'source'
        source.mkdir()
        for name, (_, data) in files.items():
            (source / name).write_bytes(data)
        for name in ('logs', 'tmp', 'home'):
            (run / name).mkdir()
        env = dict(os.environ, TMPDIR=str(run / 'tmp'), HOME=str(run / 'home'),
                   LC_ALL='C', GIT_OPTIONAL_LOCKS='0')
        flags_line = next(line for line in files['Makefile'][1].decode().splitlines() if line.startswith('CFLAGS = '))
        flags = flags_line.split('=', 1)[1].strip() + ' -std=c99'
        record = dict(schema='FT1536_S17_BUILD_V1', profile='FT1536 / S17 / FPEMU',
                      started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                      source_manifest_sha256=MANIFEST_SHA,
                      source_files={name: digest for name, (digest, _) in files.items()},
                      cflags=flags, mode=mode, run=str(run.relative_to(ROOT)), commands=[], result='IN_PROGRESS')

        def command(label, argv, cwd=source, accepted=(0,)):
            start = time.monotonic()
            out_path = run / 'logs' / (label + '.stdout')
            err_path = run / 'logs' / (label + '.stderr')
            timed_out = False
            with out_path.open('xb') as out, err_path.open('xb') as err:
                process = subprocess.Popen(argv, cwd=cwd, env=env, stdout=out, stderr=err,
                                           start_new_session=True)
                try:
                    process.wait(timeout=600)
                except (subprocess.TimeoutExpired, KeyboardInterrupt) as error:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
                    timed_out = isinstance(error, subprocess.TimeoutExpired)
            result = dict(argv=argv, cwd=str(cwd), exit_code=process.returncode,
                          seconds=round(time.monotonic() - start, 3),
                          timed_out=timed_out, wall_limit_seconds=600,
                          stdout=str(out_path.relative_to(run)), stderr=str(err_path.relative_to(run)),
                          stdout_sha256=sha(read(out_path)), stderr_sha256=sha(read(err_path)))
            record['commands'].append(result)
            require(process.returncode in accepted, f'{label} failed: inspect {err_path}')
            return read(out_path), read(err_path)

        try:
            version, _ = command('gcc-version', [gcc, '--version'])
            target, _ = command('gcc-target', [gcc, '-dumpmachine'])
            record['compiler'] = version.decode().splitlines()[0]
            record['target'] = target.decode().strip()
            command('build', [make, '-j2', 'CC=' + gcc, 'LD=' + gcc, 'CFLAGS=' + flags])
            if mode == 'check':
                compiler_flags = shlex.split(flags)
                smoke = ROOT / 'tests/ft1536-s17/fpemu_smoke.c'
                smoke_binary = run / 'fpemu-smoke'
                command('build-fpemu-smoke', [gcc, *compiler_flags, '-I', str(source),
                        str(smoke), str(source / 'fpr-emulated.o'), '-lm', '-o', str(smoke_binary)])
                out, _ = command('fpemu-smoke', [str(smoke_binary)])
                record['fpemu_smoke'] = json.loads(out)
                _, usage = command('cli-usage', [str(source / 'falcon')], accepted=(1,))
                require(b'usage: falcon command' in usage, 'Unexpected CLI usage output')

                # Bind the historical public regression to this integrated source copy.
                harness_data = read(WITNESS / 'scripts/harness.c')
                require(sha(harness_data) == 'd9addfa1ddea67a2fa689b0963755758426cd3ae04df4115b39ff6877af4bd79', 'Harness pin mismatch')
                old_include = b'#include "../reference/falcon-vrfy.c"'
                require(harness_data.count(old_include) == 1, 'Unexpected harness include')
                harness = run / 'verify_s17.c'
                harness.write_bytes(harness_data.replace(old_include, b'#include "falcon-vrfy.c"', 1))
                verifier = run / 'verify-s17'
                command('build-verifier', [gcc, *compiler_flags, '-DLV_MAIN', '-I', str(source),
                        str(harness), str(source / 'falcon-enc.c'), str(source / 'shake.c'), '-lm', '-o', str(verifier)])
                pinned = {
                    'inputs/key/canonical_public_key.bin': '57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f',
                    'artifacts/witness_c.txt': 'f715b6c92f574054a52230cbcc337d2b16f5260469788872eb59234d27d1f4fd',
                    'artifacts/witness.bin': '50468530f25ff63fe5680331d2f2591120a15aae0ba0f63f0b0364fc78289b74',
                }
                for path, expected in pinned.items():
                    require(sha(read(WITNESS / path)) == expected, 'Public fixture pin mismatch')
                out, _ = command('known-verifier-regression', [str(verifier), *(str(WITNESS / p) for p in pinned)])
                regression = json.loads(out)
                require(regression['verify'] == regression['raw'] == regression['loader'] == regression['point_calls'] == 1,
                        'Unexpected original S17 verifier decision')
                require(regression['machine_norm'] == 400000000 and regression['preNTT0'] == 63969
                        and regression['s0'] == -20000, 'Unexpected original normalization regression')
                record['known_original_verifier_regression'] = regression
                record['regression_scope'] = 'Reproduces the known S17 counterexample; not a security proof'
            verified_sources()
            for name, (expected, _) in files.items():
                require(sha(read(source / name)) == expected, 'Build changed a source copy')
            publish(source / 'falcon', OUTPUT / 'ft1536')
            publish(source / 'test_falcon', OUTPUT / 'test_falcon')
            record['binaries'] = {name: sha(read(OUTPUT / name)) for name in ('ft1536', 'test_falcon')}
            record['result'] = 'PASS'
        except (OSError, ValueError, RuntimeError, subprocess.TimeoutExpired) as error:
            record['result'] = 'FAIL'
            record['error'] = str(error)
            raise
        finally:
            write_json(run / 'build.json', record)
            write_json(OUTPUT / 'latest.json', record)
            print(json.dumps({'result': record['result'], 'receipt': str(run / 'build.json'),
                              'profile': record['profile'], 'cli': str(OUTPUT / 'ft1536')}, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=('verify', 'build', 'check'))
    try:
        execute(parser.parse_args().mode)
    except (OSError, ValueError, RuntimeError, subprocess.TimeoutExpired) as error:
        print('FT1536: ' + str(error), file=sys.stderr)
        raise SystemExit(1)
