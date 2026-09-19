#!/usr/bin/env python3
"""Build the pinned L_RHO research candidate; retain source and execution receipts."""
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
MANIFEST = ROOT / 'provenance/ft1536-candidate.sha256'
MANIFEST_SHA = '2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
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
    require(sha(raw) == MANIFEST_SHA, 'Candidate manifest pin mismatch')
    files = {}
    for line in raw.decode().splitlines():
        digest, name = line.split()
        require(re.fullmatch(r'[a-zA-Z0-9_.-]+', name) is not None and name not in ('.', '..'), 'Unsafe source name')
        require(name not in files, 'Duplicate source entry')
        data = read(SOURCE / name)
        require(sha(data) == digest, 'Source differs from pinned FT1536 candidate: ' + name)
        files[name] = (digest, data)
    require(len(files) == 17, 'Expected the complete 17-file candidate source set')
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
        record = dict(schema='FT1536_CANDIDATE_BUILD_V1', profile='FT1536 / L_RHO candidate / FPEMU',
                      started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                      build_helper_sha256=sha(read(Path(__file__).absolute())),
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
                smoke = ROOT / 'tests/ft1536/fpemu_smoke.c'
                record['smoke_source_sha256'] = sha(read(smoke))
                smoke_binary = run / 'fpemu-smoke'
                command('build-fpemu-smoke', [gcc, *compiler_flags, '-I', str(source),
                        str(smoke), str(source / 'fpr-emulated.o'), '-lm', '-o', str(smoke_binary)])
                out, _ = command('fpemu-smoke', [str(smoke_binary)])
                record['fpemu_smoke'] = json.loads(out)
                _, usage = command('cli-usage', [str(source / 'falcon')], accepted=(1,))
                require(b'usage: falcon command' in usage, 'Unexpected CLI usage output')

                # Use actual norm arguments; the old S17 trace duplicated its old map.
                harness = ROOT / 'tests/ft1536/verifier_regression.c'
                record['verifier_harness_sha256'] = sha(read(harness))
                pinned = {
                    'inputs/key/canonical_public_key.bin': '57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f',
                    'artifacts/witness_c.txt': 'f715b6c92f574054a52230cbcc337d2b16f5260469788872eb59234d27d1f4fd',
                    'artifacts/witness.bin': '50468530f25ff63fe5680331d2f2591120a15aae0ba0f63f0b0364fc78289b74',
                }
                for path, expected in pinned.items():
                    require(sha(read(WITNESS / path)) == expected, 'Public fixture pin mismatch')
                regressions = {}
                for mode_name, observed in (('plain', 0), ('observed', 1)):
                    verifier = run / ('verify-' + mode_name)
                    command('build-verifier-' + mode_name, [gcc, *compiler_flags, '-DOBSERVE=' + str(observed), '-I', str(source),
                            str(harness), str(source / 'falcon-enc.c'), str(source / 'shake.c'), '-lm', '-o', str(verifier)])
                    out, _ = command('known-verifier-' + mode_name, [str(verifier), *(str(WITNESS / p) for p in pinned)])
                    regression = json.loads(out)
                    require(regression['verify'] == regression['raw'] == 0
                            and regression['loader'] == regression['point_calls'] == 1,
                            'Corrected candidate did not reject the historical witness')
                    require(regression['normalized_s0'] == 16866 and regression['s0'] == -20000
                            and regression['decoded_bytes'] == 1930 and regression['signed_s_unchanged'],
                            'Unexpected corrected normalization/decoder regression')
                    if observed:
                        require(regression['machine_norm'] == 43058711057 and regression['norm_calls'] == 2,
                                'Unexpected actual norm arguments')
                    regressions[mode_name] = regression
                record['known_counterexample_regression'] = regressions
                record['regression_scope'] = 'Corrected candidate rejects the historical S17 witness; finite regression, not the full proof'
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
