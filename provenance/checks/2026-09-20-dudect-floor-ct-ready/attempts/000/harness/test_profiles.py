"""No physical measurements: source routing, real ASM distinction and start gate."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from campaign import run_campaign
from profiles import FLOOR_STAGE, PROFILES, floor_assembly_ok

REPO = Path(__file__).resolve().parents[3]


class ProfileChecks(unittest.TestCase):
    def test_exact_distinct_source_pins(self):
        manifests = {}
        for name, profile in PROFILES.items():
            raw = (REPO/profile['manifest']).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), profile['sha256'])
            rows = {p:h for h,p in (line.split('  ',1) for line in raw.decode().splitlines())}
            self.assertEqual(len(rows),17)
            for p,h in rows.items():
                self.assertEqual(hashlib.sha256((REPO/profile['source']/p).read_bytes()).hexdigest(),h)
            manifests[name] = rows
        self.assertEqual([p for p in manifests['baseline'] if manifests['baseline'][p]!=manifests['floor-ct'][p]],['fpr-emulated.h'])
        self.assertNotEqual(PROFILES['baseline']['unit'],PROFILES['floor-ct']['unit'])

    def test_real_floor_regions_and_mutation(self):
        asm = REPO/FLOOR_STAGE/'artifacts/asm/portable_001'
        old = (asm/'baseline_wrapper.dis').read_text()
        new = (asm/'candidate_wrapper.dis').read_text()
        self.assertTrue(floor_assembly_ok(old,PROFILES['baseline']))
        self.assertFalse(floor_assembly_ok(old,PROFILES['floor-ct']))
        self.assertTrue(floor_assembly_ok(new,PROFILES['floor-ct']))
        self.assertFalse(floor_assembly_ok(new,PROFILES['baseline']))
        self.assertFalse(floor_assembly_ok(new+'\nffff: 74 00 je 10001\n',PROFILES['floor-ct']))
        self.assertFalse(floor_assembly_ok('',PROFILES['floor-ct']))

    def test_deferred_preparation_cannot_start_measurements(self):
        with tempfile.TemporaryDirectory(prefix='ft1536-profile-check-') as path:
            work = Path(path)
            (work/'PREPARATION.json').write_text(json.dumps({'status':'STATIC_READY_TIMING_DEFERRED'}))
            with self.assertRaisesRegex(RuntimeError,'preflight is required'):
                run_campaign(work,28800,9)
            self.assertFalse((work/'RUN.json').exists())


if __name__ == '__main__':
    unittest.main()
