"""Bounded, single-worker dudect campaign. Only public scalar fixtures."""
import argparse
import datetime as dt
import gzip
import hashlib
import itertools
import json
import os
from pathlib import Path
import select
import signal
import struct
import subprocess
import sys
import time

CASES = [
    'negative_floor', 'positive_loop', 'floor_fixed_positive', 'floor_fixed_negative',
    'floor_random_signed', 'add_cancellation', 'mul_carry', 'div_denominator_bounds',
    'sqrt_exponent_parity', 'rint_ties', 'expm_endpoints', 'half_boundary',
    'lt_signed_zero', 'scaled_zero',
]
STOP = False
LOG_BYTES_PER_SECOND = 2 * 2**20


class HashingWriter:
    """Hash compressed bytes as written, avoiding a huge end-of-trial reread."""
    def __init__(self, file):
        self.file = file
        self.digest = hashlib.sha256()
        self.total = 0

    def write(self, data):
        count = self.file.write(data)
        if count != len(data):
            raise OSError('Short compressed write')
        self.digest.update(data)
        self.total += count
        return count

    def flush(self):
        self.file.flush()


def sha(path):
    with Path(path).open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def utc():
    return dt.datetime.now(dt.timezone.utc).isoformat()


def dump(path, obj):
    path = Path(path)
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(obj, indent=2, sort_keys=True, allow_nan=False) + '\n')
    tmp.replace(path)


def read_optional(path):
    try:
        return Path(path).read_text().strip()
    except OSError as e:
        return 'UNAVAILABLE: ' + str(e)


def snapshot():
    paths = ['/proc/loadavg', '/proc/stat', '/proc/pressure/cpu', '/proc/uptime',
             '/sys/devices/system/cpu/intel_pstate/no_turbo',
             '/sys/devices/system/cpu/intel_pstate/status',
             '/sys/devices/system/cpu/isolated']
    for cpu in sorted(cpu_times()):
        p = f'/sys/devices/system/cpu/cpu{cpu}'
        paths += [p + '/topology/thread_siblings_list']
        paths += [p + '/cpufreq/' + k for k in ('scaling_governor', 'scaling_cur_freq',
                   'scaling_min_freq', 'scaling_max_freq', 'energy_performance_preference')]
    paths += [str(p) for p in Path('/sys/class/power_supply').glob('*/*')
              if p.name in ('type', 'online', 'status', 'capacity')]
    paths += [str(p) for p in Path('/sys/class/thermal').glob('thermal_zone*/temp')]
    return dict(utc=utc(), monotonic=time.monotonic(), affinity=sorted(os.sched_getaffinity(0)),
                files={p: read_optional(p) for p in paths})


def cpu_times():
    result = {}
    for line in Path('/proc/stat').read_text().splitlines():
        words = line.split()
        if words and words[0].startswith('cpu') and words[0][3:].isdigit():
            values = list(map(int, words[1:9]))
            result[int(words[0][3:])] = (sum(values), values[3] + values[4])
    return result


def choose_cpu():
    candidates = [c for c in sorted(os.sched_getaffinity(0))
                  if read_optional(f'/sys/devices/system/cpu/cpu{c}/topology/thread_siblings_list') == str(c)]
    if not candidates:
        raise RuntimeError('No available non-SMT core; choose a documented reservation manually')
    first = cpu_times()
    time.sleep(5)
    last = cpu_times()
    busy = {c: 1 - (last[c][1]-first[c][1])/max(1, last[c][0]-first[c][0]) for c in candidates}
    return min(candidates, key=lambda c: (busy[c], -c)), busy


def child_environment(work):
    return dict(PATH='/usr/bin:/bin', LANG='C', LC_ALL='C', TZ='UTC',
                HOME=str(work), TMPDIR=str(work), OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1')


def order_for(round_number, case_id):
    text = f'FT1536-public-dudect-v1/{round_number}/{case_id}'.encode()
    return hashlib.sha256(text).hexdigest()[:16]


def run_trial(work, binary, folder, case_id, order, seconds, cpu, batch_limit=0):
    """Parent compresses each complete batch while the worker waits for ACK."""
    folder.mkdir(parents=True, exist_ok=False)
    before = snapshot()
    dump(folder/'machine_before.json', before)
    raw_r, raw_w = os.pipe()
    argv = ['taskset', '-c', str(cpu), str(binary), '--run', str(case_id), order,
            str(seconds), str(raw_w), str(batch_limit)]
    start = time.monotonic()
    deadline = start + seconds + 3  # bounded collection of the last completed batch
    frames = 0
    last_batch = None
    reason = None
    result = None
    live = dict(status='RUNNING', case=CASES[case_id], cpu=cpu, start_utc=utc(), budget_seconds=seconds)
    dump(folder/'status.json', live)
    with (folder/'stdout.txt').open('wb') as out, (folder/'stderr.txt').open('wb') as err:
        p = subprocess.Popen(argv, stdin=subprocess.PIPE, stdout=out, stderr=err,
                             pass_fds=(raw_w,), start_new_session=True,
                             cwd=work, env=child_environment(work))
        os.close(raw_w)
        live['pid'] = p.pid
        dump(folder/'status.json', live)
        dump(work/'ACTIVE.json', dict(folder=str(folder), **live))
        buffer = bytearray()
        eof = False
        compressed_file = (folder/'timings.bin.gz').open('wb')
        writer = HashingWriter(compressed_file)
        compressed = gzip.GzipFile(filename='', mode='wb', fileobj=writer, compresslevel=1, mtime=0)
        stdout_reader = (folder/'stdout.txt').open('rb')
        stdout_digest = hashlib.sha256()
        stdout_bytes = 0
        pending_header = b''
        try:
            def receive(n):
                nonlocal eof
                batch_deadline = min(deadline, time.monotonic() + 120)
                while len(buffer) < n and not eof:
                    if STOP or (work/'STOP').exists():
                        raise InterruptedError('STOP_REQUESTED')
                    if time.monotonic() >= batch_deadline:
                        raise TimeoutError('BATCH_OR_TRIAL_DEADLINE')
                    ready, _, _ = select.select([raw_r], [], [], 0.2)
                    if ready:
                        chunk = os.read(raw_r, 1 << 20)
                        if chunk:
                            buffer.extend(chunk)
                        else:
                            eof = True
                if len(buffer) < n:
                    return None
                answer = bytes(buffer[:n])
                del buffer[:n]
                return answer

            magic = receive(8)
            if magic != b'FTDUD01\n':
                raise RuntimeError('Missing raw header')
            compressed.write(magic)
            while True:
                header = receive(24)
                if header is None:
                    if buffer:
                        raise RuntimeError('Truncated raw frame header')
                    break
                n, sequence, _public_state = struct.unpack('<QQQ', header)
                if n != 100000 or sequence != frames + 1:
                    raise RuntimeError('Invalid frame')
                pending_header = header
                payload = receive(n * 9)
                if payload is None:
                    raise RuntimeError('Truncated raw frame payload')
                compressed.write(header)
                compressed.write(payload)
                compressed.flush()
                pending_header = b''
                frames += 1
                for line in stdout_reader:
                    stdout_digest.update(line)
                    stdout_bytes += len(line)
                    if line.startswith(b'FT1536_BATCH '):
                        last_batch = json.loads(line.split(b' ', 1)[1])
                if last_batch is None or last_batch['batch'] != sequence:
                    raise RuntimeError('Statistics/raw synchronization')
                live.update(frames=frames, n=last_batch['n'], max_t=last_batch['max_t'],
                            dudect_state=last_batch['state'], updated_utc=utc())
                if frames % 100 == 0:
                    dump(folder/'machine_latest.json', snapshot())
                    if os.statvfs(work).f_bavail * os.statvfs(work).f_frsize < 16 * 2**30:
                        raise RuntimeError('FREE_DISK_BELOW_16_GIB')
                dump(folder/'status.json', live)
                # No compression or telemetry runs concurrently with the timed batch.
                # Retain every trace, with a prespecified total log-rate budget.
                pause = (writer.total + stdout_bytes)/LOG_BYTES_PER_SECOND - (time.monotonic()-start)
                if pause > 0:
                    time.sleep(pause)
                p.stdin.write(b'A')
                p.stdin.flush()
        except (OSError, RuntimeError, TimeoutError, InterruptedError) as e:
            reason = str(e)
            if pending_header or buffer:
                (folder/'partial_frame.bin').write_bytes(pending_header + buffer)
            if p.poll() is None:
                os.killpg(p.pid, signal.SIGTERM)
        finally:
            compressed.close()
            compressed_file.close()
            p.stdin.close()
            os.close(raw_r)
            try:
                code = p.wait(timeout=3)
            except subprocess.TimeoutExpired:
                os.killpg(p.pid, signal.SIGKILL)
                code = p.wait()
                reason = reason or 'CHILD_DID_NOT_EXIT'
            for line in stdout_reader:
                stdout_digest.update(line)
                stdout_bytes += len(line)
                if line.startswith(b'FT1536_RESULT '):
                    result = json.loads(line.split(b' ', 1)[1])
            stdout_reader.close()
    complete = (reason is None and code in (0, 10) and result is not None
                and result['batches'] == frames and not result['stopped'])
    status = ('LEAKAGE_FOUND' if code == 10 else 'NO_LEAKAGE_EVIDENCE_YET') if complete else 'INCONCLUSIVE'
    row = dict(status=status, argv=argv, cpu=cpu, case_id=case_id, case=CASES[case_id],
               public_order=order, start_utc=live['start_utc'], end_utc=utc(), seconds=time.monotonic()-start,
               budget_seconds=seconds, exit_code=code, reason=reason, frames=frames,
               raw_complete=complete, result=result, last_batch=last_batch,
               compressed_bytes=writer.total, stdout_bytes=stdout_bytes,
               log_rate_limit_bytes_per_second=LOG_BYTES_PER_SECOND,
               files={'stdout.txt': stdout_digest.hexdigest(), 'stderr.txt': sha(folder/'stderr.txt'),
                      'timings.bin.gz': writer.digest.hexdigest()})
    dump(folder/'machine_after.json', snapshot())
    dump(folder/'receipt.json', row)
    dump(folder/'status.json', {k: v for k, v in row.items() if k != 'last_batch'})
    return row


def replay_check(binary, folder):
    """All per-batch t states must exactly match recalculation of the raw data."""
    with (folder/'replay.stdout').open('wb') as out, (folder/'replay.stderr').open('wb') as err:
        p = subprocess.Popen([str(binary), '--replay'], stdin=subprocess.PIPE, stdout=out, stderr=err)
        try:
            with gzip.open(folder/'timings.bin.gz', 'rb') as f:
                while chunk := f.read(1 << 20):
                    p.stdin.write(chunk)
        finally:
            p.stdin.close()
        code = p.wait(timeout=30)
    def states(path):
        with path.open() as f:
            for s in f:
                if s.startswith('FT1536_BATCH '):
                    yield json.loads(s.split(' ', 1)[1])
    batches = 0
    for a,b in itertools.zip_longest(states(folder/'stdout.txt'), states(folder/'replay.stdout')):
        if a is None or b is None or a != b:
            raise RuntimeError('Raw/statistics replay mismatch: ' + str(folder))
        batches += 1
    if code or not batches:
        raise RuntimeError('Raw/statistics replay failed: ' + str(folder))
    return dict(status='PASS', batches=batches, raw_sha256=sha(folder/'timings.bin.gz'),
                replay_stdout_sha256=sha(folder/'replay.stdout'))


def stop_handler(_sig, _frame):
    global STOP
    STOP = True


def run_campaign(work, seconds, cpu):
    prep = json.loads((work/'PREPARATION.json').read_text())
    for rel, digest in prep['sealed_files'].items():
        if sha(work/rel) != digest:
            raise RuntimeError('Changed preparation: ' + rel)
    if (work/'RUN.json').exists() or (work/'STOP').exists():
        raise RuntimeError('Campaign already started or STOP present; use a fresh run')
    if cpu != prep['cpu'] or not 0 < seconds <= 28800:
        raise RuntimeError('CPU/budget not preflighted')
    for sig in (signal.SIGTERM, signal.SIGINT):
        signal.signal(sig, stop_handler)
    start = time.monotonic()
    deadline = start + seconds - 15
    binary = work/prep['binary']
    run = dict(status='RUNNING', start_utc=utc(), pid=os.getpid(), cpu=cpu, budget_seconds=seconds,
               deadline_utc=(dt.datetime.now(dt.timezone.utc)+dt.timedelta(seconds=seconds)).isoformat(),
               preparation_sha256=sha(work/'PREPARATION.json'), host_exclusive=False,
               controls=[], trials=[], completed_rounds=0)
    dump(work/'RUN.json', run)
    schedule = [(r, c) for r in range(3) for c in (list(range(2,14))[r*4:] + list(range(2,14))[:r*4])]
    error = None
    try:
        for r in range(3):
            for c in (1, 0):
                if STOP or (work/'STOP').exists() or time.monotonic() > deadline-5:
                    raise InterruptedError('STOP_OR_GLOBAL_DEADLINE')
                row = run_trial(work, binary, work/f'campaign/round-{r}/control-{CASES[c]}',
                                c, order_for(r,c), min(30, deadline-time.monotonic()-3), cpu)
                run['controls'].append(dict(folder=f'campaign/round-{r}/control-{CASES[c]}',
                    status=row['status'], case=row['case'], n=row['result']['n'] if row['result'] else None))
                dump(work/'RUN.json', run)
                if not row['raw_complete'] or (c == 1 and row['status'] != 'LEAKAGE_FOUND'):
                    raise RuntimeError('POSITIVE_CONTROL_OR_EXECUTION_FAILED')
            for rr, c in [pair for pair in schedule if pair[0] == r]:
                if STOP or (work/'STOP').exists() or time.monotonic() > deadline-5:
                    raise InterruptedError('STOP_OR_GLOBAL_DEADLINE')
                # Reserve controls for later rounds; redistribute early-stop savings.
                remaining_trials = len(schedule) - len(run['trials'])
                reserve = (2-r)*66
                budget = max(1, (deadline-time.monotonic()-reserve)/remaining_trials - 3)
                row = run_trial(work, binary, work/f'campaign/round-{r}/{CASES[c]}',
                                c, order_for(rr,c), budget, cpu)
                run['trials'].append(dict(folder=f'campaign/round-{r}/{CASES[c]}', status=row['status'],
                    case=row['case'], round=r, n=row['result']['n'] if row['result'] else None,
                    max_t=row['last_batch']['max_t'] if row['last_batch'] else None))
                dump(work/'RUN.json', run)
                if not row['raw_complete']:
                    raise RuntimeError('INCOMPLETE_TRIAL: ' + str(row['reason']))
            run['completed_rounds'] = r+1
        run['status'] = 'COMPLETED_SCHEDULE'
    except (Exception, KeyboardInterrupt) as e:
        error = str(e)
        run['status'] = 'INTERRUPTED' if STOP or isinstance(e, InterruptedError) else 'INCONCLUSIVE'
    run.update(end_utc=utc(), elapsed_seconds=time.monotonic()-start, reason=error)
    bad_negative = [c for c in run['controls'] if c['case']=='negative_floor'
                    and (c['status']!='NO_LEAKAGE_EVIDENCE_YET' or not c['n'] or min(c['n'])<1000000)]
    run['negative_controls_acceptable'] = not bad_negative and len(run['controls']) == 6
    run['interpretation'] = ('EXPLORATORY_SHARED_HOST: inspect controls and all replications; '
                             'NO_LEAKAGE_EVIDENCE_YET is not CT proof, F02 branch remains present')
    dump(work/'RUN.json', run)
    dump(work/'RESULT.json', run)
    dump(work/'machine_final.json', snapshot())
    with (work/'REPORT.md').open('w') as f:
        f.write('# FT1536 baseline dudect — campaign result\n\n')
        f.write(f"Status: **{run['status']}**; start {run['start_utc']}; end {run['end_utc']}.\n\n")
        f.write(run['interpretation'] + '\n\n')
        f.write(f"Negative controls acceptable: {run['negative_controls_acceptable']}. Reason: {error}.\n\n")
        f.write('| Round | Target | Result | n0 / n1 | max abs(t) |\n|---|---|---|---|---|\n')
        for row in run['trials']:
            f.write(f"| {row['round']} | {row['case']} | {row['status']} | {row['n']} | {row['max_t']} |\n")
        f.write('\nAll trials, controls, raw times and stdout/stderr are retained in campaign/.\n')
    return 0 if run['status']=='COMPLETED_SCHEDULE' else 2


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('work', type=Path)
    parser.add_argument('--seconds', type=float, default=28800)
    parser.add_argument('--cpu', type=int)
    parser.add_argument('--replay-trial', type=Path)
    args = parser.parse_args()
    if args.replay_trial:
        prep = json.loads((args.work/'PREPARATION.json').read_text())
        print(json.dumps(replay_check(args.work/prep['binary'], args.replay_trial), indent=2))
        raise SystemExit(0)
    raise SystemExit(run_campaign(args.work.resolve(), args.seconds, args.cpu))
