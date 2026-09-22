"""Regression checks for B20 provenance/status and the accepted-pair workflow."""
import contextlib
import importlib.util
import io
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[3]


def load(name, file):
    spec = importlib.util.spec_from_file_location(name, file)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


setter = load('test_b20_setter', REPO / 'tools/b20_status_set.py')
prompt = load('test_b20_prompt', REPO / 'tools/b20_review_prompt.py')
archive = setter.archive


class B20ToolsTests(unittest.TestCase):
    def setUp(self):
        durable = REPO / 'proofs/ft1536/work/tool-tests'
        durable.mkdir(parents=True, exist_ok=True)
        temp = tempfile.TemporaryDirectory(dir=durable)
        self.addCleanup(temp.cleanup)
        self.base = Path(temp.name)
        self.repo = self.base / 'repo'
        self.root = self.repo / 'proofs/ft1536'
        self.batch = self.root / 'batches/B20_001'
        self.batch.mkdir(parents=True)
        self.head = 'a' * 40
        self.author_id = 'B20_001_P01_FORMAL_FOUNDATIONS'
        self.reviewer_id = 'B20_001_V01_FORMAL_FOUNDATIONS'
        self.author_stage = 'B20_001_P01_FINAL_001'
        self.review_stage = 'B20_001_V01_FINAL_001'
        self.entries = []
        for ident, role, paired, task_id, sub in (
                ('P01', 'author', 'V01', self.author_id, 'tasks/P01/TASK.md'),
                ('V01', 'reviewer', 'P01', self.reviewer_id, 'reviews/V01/REVIEW_TASK.md')):
            path = self.batch / sub
            path.parent.mkdir(parents=True)
            path.write_text(f'# {ident} formal contract\n')
            self.entries.append(dict(id=ident, role=role, paired=paired, task_id=task_id,
                                     document=sub, document_sha256=archive.digest(path.read_bytes()),
                                     title='Foundations', roadmap='T02',
                                     workspace=str(self.root / 'work/B20_001' / ident)))
        self.index = dict(entries=self.entries, revision=2, source_base_commit=self.head, checkout=str(self.repo))
        (self.batch / 'INDEX.json').write_bytes(archive.json_bytes(self.index))
        (self.batch / 'PACKAGE.sha256').write_text(''.join(
            e['document_sha256'] + '  ' + e['document'] + '\n' for e in self.entries))
        status = {'tasks': {e['id']: dict(status='READY_BOOTSTRAP_OWNER_START' if e['id'] == 'P01'
                                        else 'BLOCKED_PRODUCER_FREEZE', model=None, context=None, head=None,
                                        final_report_sha256=None, final_outputs_sha256=None, review_verdict=None)
                            for e in self.entries}}
        (self.batch / 'STATUS.json').write_bytes(archive.json_bytes(status))
        self.author = self.bundle('author', {'task_id': self.author_id, 'status': 'PARTIAL_PROOF'})
        self.review = self.make_review()
        self.addCleanup(patch.stopall)
        patch.object(prompt, 'B', self.batch).start()
        patch.object(prompt, 'REPO', self.repo).start()

    def bundle(self, name, result, review=False):
        folder = self.root / 'work' / name
        folder.mkdir(parents=True)
        report = 'REVIEW.md' if review else 'REPORT.md'
        result_file = 'REVIEW_RESULT.json' if review else 'RESULT.json'
        manifest = 'REVIEW_OUTPUTS.sha256' if review else 'OUTPUTS.sha256'
        payload = b'public input\n'
        members = {report: ('# ' + name + '\n').encode(), result_file: archive.json_bytes(result),
                   'public.txt': payload, 'run.log': b'genuine fixture log\n',
                   'INPUTS.sha256': (archive.digest(payload) + '  /unavailable/public.txt\n').encode()}
        for n, data in members.items():
            (folder / n).write_bytes(data)
        raw = ''.join(archive.digest(data) + '  ' + n + '\n' for n, data in sorted(members.items())).encode()
        (folder / manifest).write_bytes(raw)
        return dict(folder=folder, report=folder / report, outputs=folder / manifest,
                    report_sha=archive.digest(members[report]), outputs_sha=archive.digest(raw))

    def make_review(self, name='review', **changes):
        result = dict(review_id=self.reviewer_id, source_task=self.author_id,
                      source_report_sha256=self.author['report_sha'],
                      source_outputs_sha256=self.author['outputs_sha'], verdict='PASS_SCOPED_REVIEW',
                      verdict_scope='Reviewed partial result; goal remains open')
        result.update(changes)
        return self.bundle(name, result, review=True)

    def call(self, *argv):
        return setter.update(setter.parser().parse_args(argv), self.batch)

    def status(self):
        return json.loads((self.batch / 'STATUS.json').read_text())

    def start_and_bind(self):
        self.call('P01', '--start', '--model', 'opencode/mimo-v2.6-pro', '--context', 'fresh / independent')
        return self.call('P01', '--final-report', str(self.author['report']),
                         '--final-outputs', str(self.author['outputs']), '--head', self.head,
                         '--report-sha', self.author['report_sha'], '--outputs-sha', self.author['outputs_sha'])

    def verdict_args(self, verdict='PASS_SCOPED_REVIEW', bundle=None, stages=True):
        b = bundle or self.review
        args = ['P01', '--review-verdict', verdict, '--review-report', str(b['report']),
                '--review-outputs', str(b['outputs']), '--review-report-sha', b['report_sha'],
                '--review-outputs-sha', b['outputs_sha']]
        if stages:
            args += ['--stage', self.author_stage, '--review-stage', self.review_stage]
        return args

    def import_pair(self):
        a, v = self.author, self.review
        archive.import_stage(self.root, a['folder'], a['outputs_sha'], a['report_sha'], stage=self.author_stage)
        archive.import_stage(self.root, v['folder'], v['outputs_sha'], v['report_sha'], stage=self.review_stage,
                             report='REVIEW.md', result_file='REVIEW_RESULT.json', manifest_name='REVIEW_OUTPUTS.sha256')

    def rejects_without_status_change(self, *args):
        before = (self.batch / 'STATUS.json').read_bytes()
        with self.assertRaises((archive.ArchiveError, OSError, KeyError)):
            self.call(*args)
        self.assertEqual(before, (self.batch / 'STATUS.json').read_bytes())

    def test_frozen_handoff_and_prompt_need_no_import(self):
        row = self.start_and_bind()['row']
        self.assertEqual(row['model'], 'opencode/mimo-v2.6-pro')
        self.assertEqual(row['context'], 'fresh / independent')
        self.assertEqual(row['status'], 'FROZEN_AWAITING_REVIEW')
        self.assertFalse((self.root / 'stages').exists())
        args = prompt.load_pair('V01')
        text = prompt.render(*args)
        self.assertIn('proofs/ft1536/batches/B20_001/reviews/V01/REVIEW_TASK.md', text)
        self.assertIn('TASK_SHA256=' + self.entries[1]['document_sha256'], text)
        self.assertIn(self.author['outputs_sha'], text)
        self.assertNotIn('DO_WYPEŁNIENIA_Z_HANDOFFU', text)
        self.assertIn('"source_task": "' + self.author_id + '"', text)

    def test_binding_requires_pins_and_checks_all_members(self):
        self.call('P01', '--start', '--model', 'a/b', '--context', 'fresh')
        self.rejects_without_status_change('P01', '--final-report', str(self.author['report']))
        (self.author['folder'] / 'public.txt').write_text('corrupted\n')
        self.rejects_without_status_change('P01', '--final-report', str(self.author['report']),
                                          '--final-outputs', str(self.author['outputs']), '--head', self.head,
                                          '--report-sha', self.author['report_sha'], '--outputs-sha', self.author['outputs_sha'])

    def test_review_result_pin_and_pair_mismatch_are_rejected_atomically(self):
        self.start_and_bind()
        self.import_pair()
        args = self.verdict_args()
        args[args.index('--review-outputs-sha') + 1] = 'f' * 64
        self.rejects_without_status_change(*args)
        index = json.loads((self.batch / 'INDEX.json').read_text())
        index['entries'][1]['paired'] = 'P02'
        (self.batch / 'INDEX.json').write_bytes(archive.json_bytes(index))
        self.rejects_without_status_change(*self.verdict_args())

    def test_existing_unrelated_stage_does_not_validate_final_pins(self):
        self.start_and_bind()
        different = self.bundle('unrelated', {'task_id': self.author_id, 'status': 'PARTIAL_PROOF'})
        archive.import_stage(self.root, different['folder'], different['outputs_sha'], different['report_sha'],
                             stage=self.author_stage)
        self.rejects_without_status_change('P01', '--final-report', str(self.author['report']),
                                          '--final-outputs', str(self.author['outputs']), '--stage', self.author_stage,
                                          '--report-sha', self.author['report_sha'], '--outputs-sha', self.author['outputs_sha'])

    def test_reviewed_requires_bound_review_and_matching_stage_pair(self):
        self.start_and_bind()
        self.rejects_without_status_change('P01', '--review-verdict', 'PASS_SCOPED_REVIEW')
        self.rejects_without_status_change(*self.verdict_args(stages=False))
        self.rejects_without_status_change(*self.verdict_args())
        self.import_pair()
        self.call(*self.verdict_args())
        status = self.status()
        self.assertEqual(status['tasks']['P01']['status'], 'REVIEWED')
        self.assertEqual(status['tasks']['V01']['status'], 'REVIEW_COMPLETE')
        self.assertEqual(setter.verify_accepted_row(self.root, self.index, status, 'P01'),
                         (self.author_stage, self.review_stage))
        (self.root / 'stages' / self.review_stage / 'REVIEW_RESULT.json').write_text('{}')
        with self.assertRaises(archive.ArchiveError):
            setter.verify_accepted_row(self.root, self.index, status, 'P01')

    def test_wrong_review_subject_and_forged_verdict_are_rejected(self):
        self.start_and_bind()
        self.import_pair()
        cases = [{'review_id': 'B20_001_V02_OTHER'}, {'source_task': 'B20_001_P02_OTHER'},
                 {'source_outputs_sha256': '0' * 64}, {'source_report_sha256': '1' * 64},
                 {'verdict': 'CHANGES_REQUIRED'}, {'verdict_scope': ''}]
        for i, fields in enumerate(cases):
            with self.subTest(fields=fields):
                bad = self.make_review('bad' + str(i), **fields)
                self.rejects_without_status_change(*self.verdict_args(bundle=bad))

    def test_negative_verdicts_never_become_reviewed_or_require_import(self):
        self.start_and_bind()
        frozen = (self.batch / 'STATUS.json').read_bytes()
        for verdict in setter.VERDICTS[1:]:
            with self.subTest(verdict=verdict):
                (self.batch / 'STATUS.json').write_bytes(frozen)
                review = self.make_review(verdict, verdict=verdict)
                self.call(*self.verdict_args(verdict, review, stages=False))
                self.assertEqual(self.status()['tasks']['P01']['status'], verdict)
                self.assertFalse((self.root / 'stages').exists())
        self.call('P01', '--start', '--model', 'next/model', '--context', 'new correction')
        row = self.status()['tasks']['P01']
        self.assertIsNone(row['final_report_sha256'])
        self.assertEqual(row['history'][-1]['review_verdict'], 'BLOCKED')

    def test_prompt_rechecks_task_and_protects_existing_files(self):
        self.start_and_bind()
        text = prompt.render(*prompt.load_pair('V01'))
        out = self.root / 'work/prompts/V01.md'
        prompt.save_prompt(out, text)
        prompt.save_prompt(out, text)
        out.write_text('owner edited this prompt')
        with self.assertRaises(prompt.archive.ArchiveError):
            prompt.save_prompt(out, text)
        self.assertEqual(out.read_text(), 'owner edited this prompt')
        task = self.batch / self.entries[1]['document']
        task.write_text('changed after pinning')
        with self.assertRaises(prompt.archive.ArchiveError):
            prompt.render(*prompt.load_pair('V01'))

    def test_cli_rejects_contradictory_actions_and_unknown_verdict(self):
        for args in (['P01', '--start', '--review-verdict', 'PASS_SCOPED_REVIEW'],
                     ['P01', '--review-verdict', 'PASS_MADE_UP']):
            with contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
                setter.parser().parse_args(args)

    def test_prompt_output_cannot_escape_work_directory(self):
        escaped = self.root / 'work/../../../escaped.md'
        with self.assertRaises(prompt.archive.ArchiveError):
            prompt.save_prompt(escaped, 'must not be written')
        self.assertFalse(escaped.exists())

    def test_checkpoint_requires_accepted_pair_and_carries_journal_and_status(self):
        for rel in ('tools/b20_status_set.py', 'proofs/ft1536/tools/archive.py'):
            target = self.repo / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(REPO / rel, target)
        log = self.repo / 'docs/onboarding/COORDINATOR_LOG.md'
        log.parent.mkdir(parents=True)
        log.write_text('# Coordinator log\n')
        subprocess.run(['git', 'init', '-q', '-b', 'main', str(self.repo)], check=True)
        subprocess.run(['git', '-C', str(self.repo), 'add', '--', 'tools', 'proofs/ft1536/tools',
                        'proofs/ft1536/batches', 'docs'], check=True)
        subprocess.run(['git', '-C', str(self.repo), '-c', 'user.name=test', '-c', 'user.email=test@example.com',
                        'commit', '-q', '-m', 'baseline'], check=True)
        self.start_and_bind()
        self.import_pair()
        with self.assertRaises(archive.ArchiveError):
            archive.checkpoint(self.root, self.author_stage, repo=self.repo, with_stages=[self.review_stage])
        self.call(*self.verdict_args())
        with self.assertRaises(archive.ArchiveError):
            archive.checkpoint(self.root, self.author_stage, repo=self.repo)
        with self.assertRaises(archive.ArchiveError):
            archive.checkpoint(self.root, self.author_stage, repo=self.repo, with_stages=[self.review_stage])
        log.write_text(log.read_text() + '2026-09-23T00:00:00Z / archive checkpoint / pair bound / next P02\n')
        result = archive.checkpoint(self.root, self.author_stage, repo=self.repo, with_stages=[self.review_stage])
        self.assertEqual(result['action'], 'committed')
        names = subprocess.check_output(['git', '-C', str(self.repo), 'show', '--format=', '--name-only', 'HEAD'], text=True)
        self.assertIn('docs/onboarding/COORDINATOR_LOG.md', names)
        self.assertIn('proofs/ft1536/batches/B20_001/STATUS.json', names)
        clone = self.base / 'clone'
        subprocess.run(['git', 'clone', '-q', '--no-hardlinks', str(self.repo), str(clone)], check=True)
        clean_root = clone / 'proofs/ft1536'
        archive.verify_stage(clean_root, self.author_stage)
        archive.verify_stage(clean_root, self.review_stage)
        self.assertEqual(archive.checkpoint(self.root, self.author_stage, repo=self.repo,
                                           with_stages=[self.review_stage])['action'], 'nothing-to-commit')


if __name__ == '__main__':
    unittest.main()
