#!/usr/bin/env python3
"""Bind frozen B20 work, then record an independently sealed review.

No import is needed to prepare a reviewer prompt. REVIEWED requires a paired
PASS_SCOPED_REVIEW and verified author/review stages with the same external pins.
Negative verdicts stay explicit; this tool checks evidence binding, not proofs.
See AGENTS.md for the work -> review -> stages -> main workflow.
"""
import argparse
import importlib.util
import json
import os
from pathlib import Path
import tempfile

REPO = Path(__file__).resolve().parents[1]
B = REPO / 'proofs/ft1536/batches/B20_001'
spec = importlib.util.spec_from_file_location('b20_archive', REPO / 'proofs/ft1536/tools/archive.py')
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)
require = archive.require
VERDICTS = ('PASS_SCOPED_REVIEW', 'CHANGES_REQUIRED', 'INTEGRITY_FAIL',
            'REPLAY_FAIL', 'EXECUTION_BLOCKED', 'BLOCKED')
STARTABLE = {'READY_BOOTSTRAP_OWNER_START', 'BLOCKED_UPSTREAM_EXPORTS',
             'BLOCKED_PRODUCER_FREEZE', *VERDICTS[1:]}


def entry_for(index, ident):
    entries = [e for e in index['entries'] if e['id'] == ident]
    require(len(entries) == 1, f'{ident}: expected one INDEX entry')
    return entries[0]


def inside(root, path):
    path = archive.no_symlinks(Path(path).absolute())
    archive.checked_path(str(path), absolute=True)
    require(path.is_relative_to(root), f'Path must be under {root}: {path}')
    return path


def source_binding(row):
    return {k: row[k] for k in ('final_report_sha256', 'final_outputs_sha256')}


def check_review(result, author, reviewer, row, verdict):
    require(author['role'] == 'author' and reviewer['role'] == 'reviewer'
            and author['paired'] == reviewer['id'] and reviewer['paired'] == author['id'],
            'Broken author/reviewer pairing in INDEX')
    require(result.get('review_id') == reviewer['task_id'], 'Wrong paired review ID')
    require(result.get('source_task') == author['task_id'], 'Review targets a different task')
    require(result.get('source_report_sha256') == row['final_report_sha256'], 'Review REPORT pin mismatch')
    require(result.get('source_outputs_sha256') == row['final_outputs_sha256'], 'Review OUTPUTS pin mismatch')
    require(result.get('verdict') == verdict, 'Verdict differs from sealed REVIEW_RESULT')
    require(isinstance(result.get('verdict_scope'), str) and result['verdict_scope'].strip(),
            'Review must declare its exact scope')


def check_stage(root, stage, entry, report_sha, outputs_sha, review=False):
    prefix = f'B20_001_{entry["id"]}_FINAL_'
    require(isinstance(stage, str) and stage.startswith(prefix) and stage[len(prefix):].isdigit(),
            f'Expected {prefix}<version>')
    archive.verify_stage(root, stage)
    record = archive.load_record(root, stage)
    require(record['report_sha256'] == report_sha and record['manifest_sha256'] == outputs_sha,
            'Verified stage does not match the bound report/manifest')
    manifest_name = 'REVIEW_OUTPUTS.sha256' if review else 'OUTPUTS.sha256'
    result_name = 'REVIEW_RESULT.json' if review else 'RESULT.json'
    require(record.get('manifest', 'OUTPUTS.sha256') == manifest_name
            and record['result_file'] == result_name, 'Wrong stage manifest/result kind')
    result = json.loads(archive.read(root / 'stages' / stage / result_name))
    if not review:
        require(result.get('task_id') == entry['task_id'], 'Stage RESULT task_id mismatch')
    return result


def verify_accepted_row(root, index, status, pid):
    """Used by checkpoint too: an arbitrary status string is not acceptance."""
    author = entry_for(index, pid)
    require(author['role'] == 'author', 'Expected an author row')
    reviewer = entry_for(index, author['paired'])
    row = status['tasks'][pid]
    vr = status['tasks'][reviewer['id']]
    require(row['status'] == 'REVIEWED' and row['review_verdict'] == 'PASS_SCOPED_REVIEW',
            'B20 checkpoint requires an accepted paired review')
    check_stage(root, row['stage'], author, row['final_report_sha256'], row['final_outputs_sha256'])
    result = check_stage(root, row['review_stage'], reviewer, row['review_report_sha256'],
                         row['review_outputs_sha256'], review=True)
    check_review(result, author, reviewer, row, 'PASS_SCOPED_REVIEW')
    require(vr['status'] == 'REVIEW_COMPLETE' and vr['review_verdict'] == row['review_verdict']
            and vr['stage'] == row['review_stage']
            and vr['final_report_sha256'] == row['review_report_sha256']
            and vr['final_outputs_sha256'] == row['review_outputs_sha256'], 'Paired V row mismatch')
    return row['stage'], row['review_stage']


def verify_frozen_row(root, entry, row):
    report = inside(root, row['final_report_path'])
    outputs = inside(root, row['final_outputs_path'])
    require(report.parent == outputs.parent, 'Report and manifest must share their bundle directory')
    review = entry['role'] == 'reviewer'
    require(outputs.name == ('REVIEW_OUTPUTS.sha256' if review else 'OUTPUTS.sha256'), 'Wrong manifest name')
    result = archive.verify_bundle(report.parent, outputs.name, row['final_outputs_sha256'],
                                   report.name, row['final_report_sha256'],
                                   'REVIEW_RESULT.json' if review else 'RESULT.json')
    require(result.get('review_id' if review else 'task_id') == entry['task_id'], 'Frozen result task ID mismatch')
    return result


def parser():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('task_id', type=str.upper)
    action = p.add_mutually_exclusive_group()
    action.add_argument('--start', action='store_true')
    action.add_argument('--freeze', action='store_true')
    action.add_argument('--final-report', type=Path)
    action.add_argument('--review-verdict', choices=VERDICTS)
    p.add_argument('--model')
    p.add_argument('--context')
    p.add_argument('--head')
    p.add_argument('--bound-inputs', type=Path)
    p.add_argument('--final-outputs', type=Path)
    p.add_argument('--report-sha')
    p.add_argument('--outputs-sha')
    p.add_argument('--stage')
    p.add_argument('--review-stage')
    p.add_argument('--review-report', type=Path)
    p.add_argument('--review-outputs', type=Path)
    p.add_argument('--review-report-sha')
    p.add_argument('--review-outputs-sha')
    return p


def update(args, batch=B):
    root = batch.parents[1]
    # The same lock is used by the importer/checkpointer; checks precede one atomic write.
    with archive.writer_lock(root):
        path = batch / 'STATUS.json'
        before = archive.read(path)
        status = json.loads(before)
        index = json.loads(archive.read(batch / 'INDEX.json'))
        entry = entry_for(index, args.task_id)
        row = status['tasks'][args.task_id]
        common = {'task_id', 'bound_inputs'}
        if args.start:
            allowed = common | {'start', 'model', 'context'}
            retry_review = (entry['role'] == 'reviewer' and row['status'] == 'REVIEW_COMPLETE'
                            and row.get('review_verdict') in VERDICTS[1:])
            require(row['status'] in STARTABLE or retry_review, 'Task is already active/frozen/reviewed')
            require(args.model and args.context, '--start requires literal --model and --context')
            if row.get('final_report_sha256'):
                history = row.setdefault('history', [])
                history.append({k: v for k, v in row.items() if k != 'history'})
                for k in list(row):
                    if k not in ('history', 'status'):
                        row[k] = None
            row.update(status='IN_PROGRESS', model=args.model, context=args.context)
        elif args.freeze:
            allowed = common | {'freeze', 'head'}
            require(row['status'] == 'IN_PROGRESS', 'Only an active task can freeze')
            require(args.head and archive.COMMIT_ID.fullmatch(args.head), 'Expected full source HEAD')
            row.update(status='FROZEN_AWAITING_REVIEW', head=args.head)
        elif args.final_report:
            allowed = common | {'final_report', 'final_outputs', 'report_sha', 'outputs_sha', 'head', 'stage'}
            require(row['status'] in ('IN_PROGRESS', 'FROZEN_AWAITING_REVIEW'), 'Start task before binding final output')
            require(args.final_outputs and args.report_sha and args.outputs_sha,
                    'Binding requires --final-outputs and external --report-sha/--outputs-sha')
            head = args.head or row.get('head')
            require(head and archive.COMMIT_ID.fullmatch(head), 'Expected full source HEAD')
            new = dict(final_report_path=str(inside(root, args.final_report)),
                       final_outputs_path=str(inside(root, args.final_outputs)),
                       final_report_sha256=args.report_sha, final_outputs_sha256=args.outputs_sha)
            if row.get('final_report_sha256'):
                require(source_binding(row) == source_binding(new), 'Frozen pins already bound; preserve history and start a new attempt')
            row.update(new)
            verify_frozen_row(root, entry, row)
            if args.stage:
                check_stage(root, args.stage, entry, args.report_sha, args.outputs_sha, entry['role'] == 'reviewer')
                row['stage'] = args.stage
            row.update(status='FROZEN_AWAITING_REVIEW', head=head)
        elif args.review_verdict:
            allowed = {'task_id', 'review_verdict', 'review_report', 'review_outputs',
                       'review_report_sha', 'review_outputs_sha', 'stage', 'review_stage'}
            require(entry['role'] == 'author' and row['status'] == 'FROZEN_AWAITING_REVIEW',
                    'Record verdict on a frozen author row')
            require(row.get('final_report_sha256') and row.get('final_outputs_sha256'), 'No final output bound')
            require(args.review_report and args.review_outputs and args.review_report_sha and args.review_outputs_sha,
                    'Verdict requires a sealed review and external review report/manifest pins')
            reviewer = entry_for(index, entry['paired'])
            rr, rm = inside(root, args.review_report), inside(root, args.review_outputs)
            require(rr.parent == rm.parent and rm.name == 'REVIEW_OUTPUTS.sha256', 'Wrong review bundle paths')
            result = archive.verify_bundle(rr.parent, rm.name, args.review_outputs_sha,
                                           rr.name, args.review_report_sha, 'REVIEW_RESULT.json')
            check_review(result, entry, reviewer, row, args.review_verdict)
            passed = args.review_verdict == 'PASS_SCOPED_REVIEW'
            if passed:
                require(args.stage and args.review_stage, 'Import accepted author/review bundles before setting REVIEWED')
                check_stage(root, args.stage, entry, row['final_report_sha256'], row['final_outputs_sha256'])
                archived = check_stage(root, args.review_stage, reviewer, args.review_report_sha,
                                       args.review_outputs_sha, review=True)
                check_review(archived, entry, reviewer, row, args.review_verdict)
            else:
                require(not args.stage and not args.review_stage, 'Negative review stays in W pending correction')
            row.update(review_verdict=args.review_verdict, review_report_path=str(rr),
                       review_outputs_path=str(rm), review_report_sha256=args.review_report_sha,
                       review_outputs_sha256=args.review_outputs_sha, review_scope=result['verdict_scope'],
                       status='REVIEWED' if passed else args.review_verdict)
            vr = status['tasks'][reviewer['id']]
            if vr.get('final_report_sha256') and vr['final_report_sha256'] != args.review_report_sha:
                vr.setdefault('history', []).append({k: v for k, v in vr.items() if k != 'history'})
            vr.update(status='REVIEW_COMPLETE', review_verdict=args.review_verdict,
                      final_report_path=str(rr), final_outputs_path=str(rm),
                      final_report_sha256=args.review_report_sha, final_outputs_sha256=args.review_outputs_sha)
            if passed:
                row.update(stage=args.stage, review_stage=args.review_stage)
                vr['stage'] = args.review_stage
                verify_accepted_row(root, index, status, args.task_id)
        else:
            allowed = common
            require(args.bound_inputs is not None, 'No action specified')
        require(all(k in allowed or v is None or v is False for k, v in vars(args).items()),
                'Options do not belong to the selected action')
        if args.bound_inputs:
            require(row['status'] not in ('REVIEWED', 'REVIEW_COMPLETE'), 'Accepted input binding is immutable')
            bound = inside(root, args.bound_inputs)
            raw = archive.checked_bytes(bound)
            require(isinstance(json.loads(raw), dict), 'BOUND_INPUTS must be a JSON object')
            if row['status'] == 'FROZEN_AWAITING_REVIEW' and row.get('bound_inputs_sha256'):
                require(row['bound_inputs_sha256'] == archive.digest(raw), 'Frozen input binding changed')
            row.update(bound_inputs_path=str(bound), bound_inputs_sha256=archive.digest(raw))
        require(archive.read(path) == before, 'STATUS changed during validation')
        with tempfile.NamedTemporaryFile(dir=root / 'work', prefix='b20-status-', delete=False) as tmp:
            temporary = Path(tmp.name)
            tmp.write(archive.json_bytes(status))
        try:
            os.replace(temporary, path)
        finally:
            temporary.unlink(missing_ok=True)
        return dict(task=args.task_id, row=row)


def main(argv=None):
    args = parser().parse_args(argv)
    print(json.dumps(update(args), ensure_ascii=False, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (archive.ArchiveError, OSError, ValueError, KeyError, TypeError) as error:
        raise SystemExit(f'b20_status_set: {error}')
