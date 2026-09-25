"""Tests exercise immutable imports and their integrity boundary, not proof validity."""
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('proof_archive', Path(__file__).parents[1] / 'tools/archive.py')
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)


class ArchiveTests(unittest.TestCase):
    def setUp(self):
        temporary_root = Path(__file__).resolve().parents[1] / 'work/tool-tests'
        temporary_root.mkdir(parents=True, exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=temporary_root)
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.root = self.base / 'repository'
        self.source = self.base / 'FT1536_TEST_RUN_001'
        self.source.mkdir()
        self.payload = b'public mathematical input\r\n'
        self.members = {
            'REPORT.md': b'# Partial proof\r\n',
            'RESULT.json': b'{"result":"PARTIAL_PROOF"}\n',
            'inputs/public.txt': self.payload,
            'INPUTS.sha256': (archive.digest(self.payload) + '  /unavailable/original/public.txt\n').encode(),
            'artifacts/COMMANDS.frozen.log': b'{"event":"finished"}\n',
        }
        self.write_fixture()
        (self.source / 'COMMANDS.log').write_bytes(self.members['artifacts/COMMANDS.frozen.log'] + b'live tail\n')
        (self.source / 'unfrozen-cache.txt').write_text('must not be imported')

    def write_fixture(self):
        for name, data in self.members.items():
            path = self.source / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        raw = ''.join(archive.digest(data) + '  ' + name + '\n' for name, data in sorted(self.members.items())).encode()
        (self.source / 'OUTPUTS.sha256').write_bytes(raw)
        self.pin = archive.digest(raw)
        self.report_pin = archive.digest(self.members['REPORT.md'])

    def import_fixture(self):
        return archive.import_stage(self.root, self.source, self.pin, self.report_pin)

    def test_import_is_portable_and_preserves_exact_bytes(self):
        result = self.import_fixture()
        self.assertEqual(result['output_entries'], len(self.members))
        snapshot = self.root / 'stages' / self.source.name
        self.assertEqual((snapshot / 'REPORT.md').read_bytes(), self.members['REPORT.md'])
        self.assertFalse((snapshot / 'unfrozen-cache.txt').exists())
        self.assertFalse((snapshot / 'COMMANDS.log').exists())
        shutil.rmtree(self.source)
        checked = archive.verify_stage(self.root, 'FT1536_TEST_RUN_001')
        self.assertEqual(checked['claimed_status'], 'PARTIAL_PROOF')
        self.assertEqual(checked['input_entries'], 1)

    def test_external_anchor_and_corruption_are_rejected(self):
        with self.assertRaises(archive.ArchiveError):
            archive.import_stage(self.root, self.source, '0' * 64, self.report_pin)
        self.assertFalse((self.root / 'stages' / self.source.name).exists())
        self.import_fixture()
        (self.root / 'stages' / self.source.name / 'REPORT.md').write_text('changed')
        with self.assertRaises(archive.ArchiveError):
            archive.verify_stage(self.root, self.source.name)

    def test_unsafe_and_duplicate_manifest_paths(self):
        sha = '0' * 64
        for name in ('../escape', '/absolute', 'a/../b', './file', 'a//b', '.private/key'):
            with self.subTest(name=name), self.assertRaises(archive.ArchiveError):
                archive.manifest((sha + '  ' + name + '\n').encode())
        with self.assertRaises(archive.ArchiveError):
            archive.manifest((sha + '  a\n' + sha + '  a\n').encode())

    def test_replay_seed_manifest_name_is_exactly_exempted(self):
        # Owner decision 2026-09-25: REPLAY_SEED.sha256 is the public replay-input
        # hash manifest of frozen T12.1 packages. Only the literal file name is
        # exempt; every other seed-like name keeps failing the sensitive filter.
        sha = '0' * 64
        archive.checked_path('REPLAY_SEED.sha256')
        archive.checked_path('outputs/REPLAY_SEED.sha256')
        for name in ('REPLAY_SEED.txt', 'replay_seed.sha256', 'MY_SEED.sha256',
                     'seed', 'REPLAY_SEED', 'REPLAY_SEED.sha256.bak'):
            with self.subTest(name=name), self.assertRaises(archive.ArchiveError):
                archive.checked_path(name)
        self.members['REPLAY_SEED.sha256'] = (sha + '  inputs/public.txt\n').encode()
        self.write_fixture()
        self.import_fixture()
        checked = archive.verify_stage(self.root, self.source.name)
        self.assertEqual(checked['output_entries'], len(self.members))

    def test_symlink_member_is_rejected(self):
        path = self.source / 'inputs/public.txt'
        path.unlink()
        other = self.base / 'public.txt'
        other.write_bytes(self.payload)
        path.symlink_to(other)
        with self.assertRaises(archive.ArchiveError):
            self.import_fixture()

    def test_existing_checkpoint_cannot_change_pins(self):
        self.import_fixture()
        self.assertTrue(self.import_fixture()['already_imported'])
        self.members['REPORT.md'] = b'a different result\n'
        self.write_fixture()
        with self.assertRaises(archive.ArchiveError):
            self.import_fixture()

    def test_objects_and_unregistered_snapshot_members_are_verified(self):
        self.import_fixture()
        obj = self.root / 'objects' / archive.digest(self.payload)
        obj.write_bytes(b'corrupt')
        with self.assertRaises(archive.ArchiveError):
            archive.verify_stage(self.root, self.source.name)
        obj.write_bytes(self.payload)
        extra = self.root / 'stages' / self.source.name / 'unexpected.txt'
        extra.write_text('extra')
        with self.assertRaises(archive.ArchiveError):
            archive.verify_stage(self.root, self.source.name)

    def test_document_copies_and_sidecars(self):
        path = self.base / 'TASK.md'
        path.write_bytes(b'task\r\n')
        archive.add_document(self.root, path, archive.digest(path.read_bytes()))
        self.assertEqual(archive.verify_documents(self.root), 1)
        (self.root / 'documents/unregistered.md').write_text('extra')
        with self.assertRaises(archive.ArchiveError):
            archive.verify_documents(self.root)

    def test_replay_success_label_does_not_replace_semantic_comparison(self):
        base = self.base / 'baseline'
        child = self.base / 'child'
        base.mkdir(); child.mkdir()
        for folder in (base, child):
            (folder / 'result.txt').write_bytes(b'exact result\n')
        sha = archive.digest(b'exact result\n')
        historical = {'matches': [{'path': 'result.txt', 'sha256': sha}]}
        reproduced = {'status': 'PASS', 'files': [{'path': 'result.txt', 'sha256': sha}]}
        self.assertEqual(archive.check_replay_result(base, child, historical, reproduced), 1)
        (child / 'result.txt').write_bytes(b'wrong result\n')
        with self.assertRaises(archive.ArchiveError):
            archive.check_replay_result(base, child, historical, reproduced)
        with self.assertRaises(archive.ArchiveError):
            archive.check_replay_result(base, child, historical, {'status': 'PASS', 'files': []})

    def test_explicit_sealed_receipt_preserves_the_package_and_recipe(self):
        receipt = 'artifacts/rehearsal/REPLAY_RESULT.json'
        sha = archive.digest(self.payload)
        self.members['scripts/replay.py'] = b'# public replay entry\n'
        self.members[receipt] = archive.json_bytes({'status': 'PASS_FRESH_REPLAY', 'matches': [
            {'path': 'inputs/public.txt', 'expected': sha, 'actual': sha, 'match': True}]})
        self.write_fixture()
        result = archive.import_stage(self.root, self.source, self.pin, self.report_pin,
                                      replay='standard', replay_receipt=receipt)
        self.assertEqual(result['integrity'], 'PASS')
        self.assertEqual(archive.load_record(self.root, self.source.name)['replay_receipt'], receipt)
        self.assertEqual((self.root/'stages'/self.source.name/receipt).read_bytes(), self.members[receipt])
        self.assertTrue(archive.import_stage(self.root, self.source, self.pin, self.report_pin,
                                            replay='standard', replay_receipt=receipt)['already_imported'])
        with self.assertRaises(archive.ArchiveError):
            archive.import_stage(self.root, self.source, self.pin, self.report_pin, replay='standard')

    def test_unsealed_or_escaping_receipts_are_rejected(self):
        self.members['scripts/replay.py'] = b'# public replay entry\n'
        self.write_fixture()
        for path in ('../receipt.json', '/receipt.json', 'artifacts/not-sealed.json'):
            with self.subTest(path=path), self.assertRaises(archive.ArchiveError):
                archive.import_stage(self.root, self.source, self.pin, self.report_pin,
                                     replay='standard', replay_receipt=path)
            self.assertFalse((self.root/'stages'/self.source.name).exists())

    def test_comparison_rows_cannot_hide_mismatch_or_conflicting_hash(self):
        sha = archive.digest(self.payload)
        row = {'path': 'inputs/public.txt', 'expected': sha, 'actual': sha, 'match': True}
        self.assertEqual(archive.semantic_rows({'matches': [row]}), {'inputs/public.txt': sha})
        for change in ({'actual': '0'*64}, {'match': False}, {'match': 1},
                       {'sha256': '0'*64}, {'expected': None, 'actual': None}):
            with self.subTest(change=change), self.assertRaises(archive.ArchiveError):
                archive.semantic_rows({'matches': [dict(row, **change)]})

    def test_bootstrap_seals_manifest_and_origins(self):
        source = self.base / 'bseed'
        source.mkdir()
        (source / 'a.txt').write_bytes(b'A\n')
        sub = source / 'd'
        sub.mkdir()
        (sub / 'b.json').write_bytes(b'{}\n')
        plan = self.base / 'plan.json'
        plan.write_text(json.dumps([
            {'copy': 'd/b.json', 'path': str(sub / 'b.json')},
            {'copy': 'a.txt', 'path': str(source / 'a.txt'), 'original': 'git:dead:Extra/a.txt'},
        ]))
        target = self.base / 'bootstrap-out'
        result = archive.bootstrap(self.root, target, plan)
        self.assertEqual(result['files'], 2)
        manifest_rows = archive.manifest((target / 'MANIFEST.sha256').read_bytes())
        self.assertEqual(manifest_rows['a.txt'], archive.digest(b'A\n'))
        self.assertEqual(manifest_rows['d/b.json'], archive.digest(b'{}\n'))
        origins = json.loads((target / 'ORIGINS.json').read_bytes())
        self.assertEqual(origins['files'][0]['original'], 'git:dead:Extra/a.txt')
        (target / 'a.txt').write_bytes(b'corrupted')
        with self.assertRaises(archive.ArchiveError):
            archive.bootstrap(self.root, target, plan)

    def test_task_init_writes_bound_agents_file(self):
        doc = self.root / 'documents' / 'T.md'
        doc.parent.mkdir(parents=True, exist_ok=True)
        doc.write_bytes(b'task body\n')
        meta = self.root / 'documents' / 'T.md.sha256'
        sha = archive.digest(b'task body\n')
        meta.write_bytes((sha + '  T.md\n').encode())
        result = archive.task_init(self.root, 'FT1536_TEST_TASK_RUN_001',
                                   base='a' * 40, task_doc=doc)
        text = (self.root / 'work/FT1536_TEST_TASK_RUN_001/AGENTS.md').read_text()
        self.assertIn('TASK SHA=' + sha, text)
        self.assertIn('BASE=' + 'a' * 40, text)
        self.assertEqual(result['task_sha'], sha)
        with self.assertRaises(archive.ArchiveError):
            archive.task_init(self.root, 'FT1536_TEST_TASK_RUN_001')
        with self.assertRaises(archive.ArchiveError):
            archive.task_init(self.root, 'FT1536_TEST_TASK_RUN_002', base='nothex')
        (self.root / 'documents/T.md').write_bytes(b'changed after pinning\n')
        with self.assertRaises(archive.ArchiveError):
            archive.task_init(self.root, 'FT1536_TEST_TASK_RUN_003', task_doc=doc)
        self.assertFalse((self.root / 'work/FT1536_TEST_TASK_RUN_003').exists())

    def test_checkpoint_commits_input_closure_and_preserves_other_staging(self):
        self.import_fixture()
        repo = self.base
        subprocess.run(['git', 'init', '-q', '-b', 'main'], cwd=repo, check=True)
        subprocess.run(['git', '-C', repo, 'config', 'user.email', 't@example.com'], check=True)
        subprocess.run(['git', '-C', repo, 'config', 'user.name', 't'], check=True)
        # --only does not limit the initial commit, so establish HEAD first.
        subprocess.run(['git', '-C', repo, 'commit', '--allow-empty', '-q', '-m', 'init'],
                       check=True)
        (repo / '.gitignore').write_text('*.log\nobjects/\n')
        (repo / 'unrelated.txt').write_text('owner staged content\n')
        subprocess.run(['git', '-C', repo, 'add', 'unrelated.txt'], check=True)
        archive.checkpoint(self.root, 'FT1536_TEST_RUN_001', repo=repo)
        head_tree = subprocess.check_output(
            ['git', '-C', repo, 'show', '--name-only', '--format=', 'HEAD'], text=True).split()
        rel = os.path.relpath(self.root, repo)
        catalog_path = f'{rel}/catalog/FT1536_TEST_RUN_001.json'
        self.assertIn(catalog_path, head_tree)
        stage_prefix = f'{rel}/stages/FT1536_TEST_RUN_001/'
        object_path = f'{rel}/objects/{archive.digest(self.payload)}'
        self.assertTrue(all(p in (catalog_path, object_path) or p.startswith(stage_prefix)
                            for p in head_tree), sorted(head_tree))
        self.assertIn(stage_prefix + 'OUTPUTS.sha256', head_tree)
        self.assertIn(stage_prefix + 'artifacts/COMMANDS.frozen.log', head_tree)
        self.assertIn(object_path, head_tree)
        self.assertEqual(subprocess.check_output(
            ['git', '-C', repo, 'diff', '--cached', '--name-only'], text=True), 'unrelated.txt\n')
        self.assertEqual(subprocess.check_output(
            ['git', '-C', repo, 'log', '-1', '--format=%an <%ae>;%cn <%ce>'], text=True).strip(),
            'niirmataa <245027293+niirmataa@users.noreply.github.com>;'
            'niirmataa <245027293+niirmataa@users.noreply.github.com>')
        clone = self.base / 'clean-clone'
        subprocess.run(['git', 'clone', '-q', '--no-hardlinks', str(repo), str(clone)], check=True)
        archive.verify_stage(clone / rel, 'FT1536_TEST_RUN_001')
        second = archive.checkpoint(self.root, 'FT1536_TEST_RUN_001', repo=repo)
        self.assertEqual(second['action'], 'nothing-to-commit')
        subprocess.run(['git', '-C', repo, 'switch', '-q', '-c', 'other-branch'], check=True)
        with self.assertRaises(archive.ArchiveError):
            archive.checkpoint(self.root, 'FT1536_TEST_RUN_001', repo=repo)

    def test_native_review_manifest_import_preserves_original_pins(self):
        self.members.pop('REPORT.md')
        self.members.pop('RESULT.json')
        self.members['REVIEW.md'] = b'# Independent scoped review\n'
        self.members['REVIEW_RESULT.json'] = b'{"verdict":"PASS_SCOPED_REVIEW"}\n'
        for name, data in self.members.items():
            (self.source / name).write_bytes(data)
        raw = ''.join(archive.digest(data) + '  ' + name + '\n'
                      for name, data in sorted(self.members.items())).encode()
        (self.source / 'REVIEW_OUTPUTS.sha256').write_bytes(raw)
        result = archive.import_stage(self.root, self.source, archive.digest(raw),
                                      archive.digest(self.members['REVIEW.md']),
                                      report='REVIEW.md', result_file='REVIEW_RESULT.json',
                                      stage='FT1536_TEST_REVIEW_001', manifest_name='REVIEW_OUTPUTS.sha256')
        self.assertEqual(result['claimed_status'], 'PASS_SCOPED_REVIEW')
        stage = self.root / 'stages/FT1536_TEST_REVIEW_001'
        self.assertEqual((stage / 'REVIEW_OUTPUTS.sha256').read_bytes(), raw)
        self.assertFalse((stage / 'OUTPUTS.sha256').exists())
        archive.verify_stage(self.root, 'FT1536_TEST_REVIEW_001')

    def test_handoff_blob_matches_catalog_pins(self):
        self.import_fixture()
        blob = archive.handoff(self.root, 'FT1536_TEST_RUN_001')
        self.assertIn('OUTPUTS_SHA256=' + self.pin, blob)
        self.assertIn('REPORT_SHA256=' + self.report_pin, blob)
        self.assertIn('STATUS=PARTIAL_PROOF', blob)

    def test_catalog_views_are_regenerable(self):
        self.import_fixture()
        view = archive.list_stages(self.root, 'FT1536_TEST_RUN_001')
        self.assertEqual(view[0]['stage'], 'FT1536_TEST_RUN_001')
        self.assertEqual(view[0]['status'], 'PARTIAL_PROOF')
        self.assertEqual(view[0]['manifest_sha256'], self.pin)
        table = archive.markdown_table(self.root, 'FT1536_TEST_RUN_001')
        self.assertIn('| FT1536_TEST_RUN_001 | PARTIAL_PROOF | none |', table)
        self.assertIn(self.pin[:12], table)


if __name__ == '__main__':
    unittest.main()
