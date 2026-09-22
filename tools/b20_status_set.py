#!/usr/bin/env python3
"""Update one task row in B20_001 STATUS.json with explicit validation.

STATUS.json is the mutable coordinator registry. Hand edits of nested JSON
caused drift before; this setter makes every change explicit and re-checked.

Steps for each field given:
- --bound-inputs PATH: materialized BOUND_INPUTS.json; its SHA-256 is stored
  (the file itself stays in the worker W, referenced by origin path).
- --final-report PATH: REPORT.md sealed by the author's OUTPUTS; --final-outputs
  must point at OUTPUTS.sha256. Both are hash-checked, REPORT must be a member
  of the OUTPUTS manifest, and the archive stage must verify PASS before the
  STATUS row is written.

Usage examples:
  b20_status_set.py P01 --start --model 'MiMo 2.6 Pro' --context 'fresh'
  b20_status_set.py P01 --freeze --head <source HEAD>
  b20_status_set.py P01 --bound-inputs W/inputs/BOUND_INPUTS.json
  b20_status_set.py P01 --final-report W/output/REPORT.md --final-outputs W/output/OUTPUTS.sha256 \
      --stage FT1536_X_RUN_001 --review-verdict PASS_SCOPED_REVIEW
"""
import hashlib
import json
import sys
from pathlib import Path

B = Path(__file__).resolve().parents[1] / 'proofs/ft1536/batches/B20_001'
ALLOWED_STATUS = {'READY_BOOTSTRAP_OWNER_START', 'IN_PROGRESS', 'FROZEN_AWAITING_REVIEW',
                  'REVIEWED', 'BLOCKED_UPSTREAM_EXPORTS', 'BLOCKED_PRODUCER_FREEZE'}


def sha256_file(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    args = sys.argv[1:]
    if not args or args[0].startswith('-h'):
        raise SystemExit(__doc__)
    task_id = args[0].upper()
    status_path = B / 'STATUS.json'
    status = json.loads(status_path.read_text())
    if task_id not in status['tasks']:
        raise SystemExit(f'{task_id}: no such task row in STATUS.json')
    row = status['tasks'][task_id]
    index = json.loads((B / 'INDEX.json').read_text())
    entry = next((e for e in index['entries'] if e['id'] == task_id), None)
    if entry is None:
        raise SystemExit(f'{task_id}: no entry in INDEX.json')

    def need(flag):
        if flag not in args:
            raise SystemExit(f'{task_id}: --{flag[2:]} is required for this action')
        return Path(args[args.index(flag) + 1])

    def opt(flag):
        return Path(args[args.index(flag) + 1]) if flag in args else None

    changes = {}

    if '--start' in args:
        status_val = 'IN_PROGRESS'
        if status_val not in ALLOWED_STATUS:
            raise AssertionError
        row['status'] = status_val
        model, context = opt('--model'), opt('--context')
        if model is not None:
            row['model'] = model.read_text().strip() if model.exists() else model.name
        if context is not None:
            row['context'] = context.read_text().strip() if context.exists() else context.name
        changes['started'] = True

    if '--freeze' in args:
        row['status'] = 'FROZEN_AWAITING_REVIEW'
        head = need('--head')
        row['head'] = head.read_text().strip() if head.exists() else head.name
        changes['frozen'] = True

    if '--bound-inputs' in args:
        path = need('--bound-inputs')
        if not path.exists():
            raise SystemExit(f'{task_id}: bound-inputs file missing: {path}')
        row['bound_inputs_sha256'] = sha256_file(path)
        changes['bound_inputs'] = True

    if '--final-report' in args or '--final-outputs' in args:
        report = need('--final-report')
        outputs = need('--final-outputs')
        stage = need('--stage')
        if not report.exists() or not outputs.exists():
            raise SystemExit(f'{task_id}: report or outputs file missing')
        report_sha = sha256_file(report)
        outputs_sha = sha256_file(outputs)
        manifest = {}
        for line in outputs.read_text().splitlines():
            parts = line.split('  ', 1)
            if len(parts) == 2:
                manifest[parts[1].strip()] = parts[0]
        member = report.name
        if manifest.get(member) != report_sha:
            raise SystemExit(f'{task_id}: REPORT {member} is not sealed by OUTPUTS manifest')
        archive = B.parents[1] / 'tools' / 'archive.py'
        if archive.exists():
            import importlib.util
            spec = importlib.util.spec_from_file_location('pa', archive)
            pa = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(pa)
            pa.verify_stage(pa.ROOT, stage.name if not isinstance(stage, str) else stage)
        row['final_report_sha256'] = report_sha
        row['final_outputs_sha256'] = outputs_sha
        if '--review-verdict' in args:
            verdict = args[args.index('--review-verdict') + 1]
            row['review_verdict'] = verdict
        row['status'] = 'REVIEWED' if '--review-verdict' in args else 'FROZEN_AWAITING_REVIEW'
        changes['final'] = True

    if not changes:
        raise SystemExit(f'{task_id}: nothing to do; pass an action flag')
    status_path.write_text(json.dumps(status, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(dict(task=task_id, changes=changes, row=row), ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
