"""Tests exercise immutable imports and their integrity boundary, not proof validity."""
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('proof_archive', Path(__file__).parents[1] / 'tools/archive.py')
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)


class ArchiveTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
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


if __name__ == '__main__':
    unittest.main()
