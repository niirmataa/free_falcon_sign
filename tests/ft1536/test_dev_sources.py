"""Source handoff must preserve active W and reuse exact archived bytes."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


REPO = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location('dev_sources', REPO / 'tools/ft1536_dev_sources.py')
DEV = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DEV)


class SourceHandoffTests(unittest.TestCase):
    def setUp(self):
        runtime = REPO / '.build/test-dev-sources'
        runtime.mkdir(parents=True, exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=runtime)
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.origin = self.repo / DEV.ORIGINS['source3']
        self.dest = self.repo / DEV.DEVELOPMENT / 'source3'
        (self.origin / 'run/formal').mkdir(parents=True)
        self.fresh = self.origin / 'run/formal/New.lean'
        self.fresh.write_text('def newValue := 3\n')
        self.shared = self.origin / 'run/formal/Shared.lean'
        self.shared.write_text('def sharedValue := 7\n')
        self.stage = self.repo / 'proofs/ft1536/stages/EXAMPLE/formal/Shared.lean'
        self.stage.parent.mkdir(parents=True)
        self.stage.write_bytes(self.shared.read_bytes())
        data = self.shared.read_bytes()
        oid = hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()
        self.patches = [
            patch.object(DEV, 'REPO', self.repo),
            patch.object(DEV, 'stage_index', return_value={oid: [self.stage.relative_to(self.repo).as_posix()]}),
            patch.object(DEV.subprocess, 'check_output', side_effect=lambda argv, **kw:
                         b'sha1\n' if '--show-object-format' in argv else b'1' * 40 + b'\n'),
        ]
        for p in self.patches:
            p.start()
            self.addCleanup(p.stop)

    def test_capture_preserves_origin_and_omits_stage_duplicates(self):
        before = {p: p.read_bytes() for p in (self.fresh, self.shared, self.stage)}
        result = DEV.capture('source3')
        self.assertEqual(result['copied'], 1)
        self.assertEqual(result['referenced_from_stages'], 1)
        self.assertEqual((self.dest / 'formal/New.lean').read_bytes(), before[self.fresh])
        self.assertFalse((self.dest / 'formal/Shared.lean').exists())
        for p, data in before.items():
            self.assertEqual(p.read_bytes(), data)
        with self.assertRaisesRegex(ValueError, 'no overwrite'):
            DEV.capture('source3')

    def test_late_worker_writes_are_reported_without_merging(self):
        DEV.capture('source3')
        saved = (self.dest / 'formal/New.lean').read_bytes()
        self.fresh.write_text('def newValue := 4\n')
        (self.origin / 'run/formal/Later.lean').write_text('def laterValue := 8\n')
        changes = DEV.pending('source3')['changes_after_snapshot']
        self.assertEqual({r['status'] for r in changes}, {'NEW_IN_ORIGINAL_W', 'CHANGED_IN_ORIGINAL_W'})
        self.assertEqual((self.dest / 'formal/New.lean').read_bytes(), saved)
        self.assertFalse((self.dest / 'formal/Later.lean').exists())

    def test_materialize_checks_archived_hash_and_prefers_new_local_version(self):
        DEV.capture('source3')
        own = self.dest / 'formal/Shared.lean'
        own.write_text('def sharedValue := 9\n')
        original = self.stage.read_bytes()
        DEV.materialize('source3')
        self.assertEqual((self.dest / '.build/formal/Shared.lean').read_bytes(), own.read_bytes())
        self.assertEqual(self.stage.read_bytes(), original)
        with self.assertRaisesRegex(ValueError, 'exists'):
            DEV.materialize('source3')

    def test_large_source_is_pinned_without_copy(self):
        with patch.object(DEV, 'LIMIT', 8):
            result = DEV.capture('source3')
        self.assertEqual(result['copied'], 0)
        self.assertEqual(result['large_untracked'], 2)
        baseline = json.loads((self.dest / 'BASELINE.json').read_text())
        self.assertEqual(len(baseline['large_untracked']), 2)
        self.assertFalse((self.dest / 'formal').exists())

    def test_worker_change_during_capture_aborts_before_destination(self):
        real = DEV.digest
        calls = 0

        def changing(path):
            nonlocal calls
            calls += 1
            if calls == 3:
                self.fresh.write_text('def newValue := 99\n')
            return real(path)

        with patch.object(DEV, 'digest', side_effect=changing):
            with self.assertRaisesRegex(ValueError, 'source changed during capture'):
                DEV.capture('source3')
        self.assertFalse(self.dest.exists())


if __name__ == '__main__':
    unittest.main()
