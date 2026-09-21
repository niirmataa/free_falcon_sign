"""Exercise duration propagation through the real launcher without timing or systemd."""
import contextlib
import io
import json
from pathlib import Path
import subprocess
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from campaign import required_disk_bytes, run_campaign
import launch
import prepare
from profiles import PROFILES


def temporary_work():
    root=Path(__file__).resolve().parents[3]/'proofs/ft1536/work/dudect-tests'
    root.mkdir(parents=True,exist_ok=True)
    return tempfile.TemporaryDirectory(prefix='ft1536-duration-',dir=root)


class DurationChecks(unittest.TestCase):
    def simulate_launch(self, seconds, requested=None, fresh_seconds=None, disk_delta=0):
        with temporary_work() as directory:
            work=Path(directory)
            prep=dict(status='STATIC_READY_TIMING_DEFERRED',profile='floor-ct',
                      source_profile=PROFILES['floor-ct'],source_manifest_sha256=PROFILES['floor-ct']['sha256'],
                      global_seconds=seconds,sealed_files={},harness='attempts/000/harness',cpu=None)
            (work/'PREPARATION.json').write_text(json.dumps(prep))
            calls=[]

            def execute(argv, **_kwargs):
                calls.append(argv)
                if argv[0]=='/usr/bin/timeout':
                    fresh=dict(prep,status='PREFLIGHT_PASS',cpu=9,
                               global_seconds=seconds if fresh_seconds is None else fresh_seconds)
                    (work/'PREPARATION.json').write_text(json.dumps(fresh))
                elif argv[0]=='systemd-run':
                    (work/'RUN.json').write_text(json.dumps(dict(status='RUNNING',budget_seconds=seconds,cpu=9)))
                elif argv[:3]!=['systemctl','--user','show']:
                    self.fail('Unexpected subprocess: '+repr(argv))
                return subprocess.CompletedProcess(argv,0,stdout='',stderr='')

            def git(argv):
                if argv[-2:]==['status','--porcelain']:return b''
                if argv[-2:]==['rev-parse','HEAD']:return b'c'*40+b'\n'
                self.fail('Unexpected git query: '+repr(argv))

            error=None
            def digest(path):
                return PROFILES['floor-ct']['sha256'] if str(path).endswith(PROFILES['floor-ct']['manifest']) else 'f'*64

            with (patch.object(launch,'sha',side_effect=digest),
                  patch.object(launch,'snapshot',return_value={'files':{}}),
                  patch.object(launch.os,'statvfs',return_value=SimpleNamespace(
                      f_bavail=required_disk_bytes(seconds)+disk_delta,f_frsize=1)),
                  patch.object(launch.subprocess,'check_output',side_effect=git),
                  patch.object(launch.subprocess,'run',side_effect=execute),
                  contextlib.redirect_stdout(io.StringIO())):
                try:launch.launch(work,requested)
                except RuntimeError as exception:error=str(exception)
            receipt=json.loads((work/'LAUNCH.json').read_text()) if (work/'LAUNCH.json').exists() else None
            return error,calls,receipt,(work/'RUN.json').exists()

    def test_six_eight_and_ten_hour_budget_propagation(self):
        for seconds in (21600,28800,36000):
            with self.subTest(seconds=seconds):
                error,calls,receipt,running=self.simulate_launch(seconds,requested=seconds)
                self.assertIsNone(error)
                self.assertTrue(running)
                preflight=next(c for c in calls if c[0]=='/usr/bin/timeout')
                service=next(c for c in calls if c[0]=='systemd-run')
                self.assertEqual(preflight[preflight.index('--seconds')+1],str(seconds))
                self.assertEqual(service[service.index('--seconds')+1],str(seconds))
                self.assertIn('--property=RuntimeMaxSec='+str(seconds),service)
                self.assertIn('--property=TimeoutStopSec=5s',service)
                self.assertEqual(receipt['budget_seconds'],seconds)
                self.assertEqual(receipt['runtime_max_seconds'],seconds)
                self.assertEqual(receipt['required_free_bytes'],required_disk_bytes(seconds))

    def test_requested_budget_mismatch_stops_before_preflight(self):
        error,calls,receipt,running=self.simulate_launch(21600,requested=36000)
        self.assertIn('differs from prepared',error)
        self.assertEqual(calls,[])
        self.assertIsNone(receipt)
        self.assertFalse(running)

    def test_fresh_preflight_cannot_silently_restore_eight_hours(self):
        for seconds in (21600,36000):
            with self.subTest(seconds=seconds):
                error,calls,receipt,running=self.simulate_launch(seconds,requested=seconds,fresh_seconds=28800)
                self.assertIn('Fresh preflight did not pass',error)
                self.assertFalse(any(c[0]=='systemd-run' for c in calls))
                self.assertIsNone(receipt)
                self.assertFalse(running)

    def test_disk_boundary_prevents_measurements(self):
        for seconds,expected in ((21600,63552094208),(36000,93751083008)):
            with self.subTest(seconds=seconds):
                self.assertEqual(required_disk_bytes(seconds),expected)
                error,calls,receipt,running=self.simulate_launch(seconds,disk_delta=-1)
                self.assertIn('Insufficient free disk',error)
                self.assertEqual(calls,[])
                self.assertIsNone(receipt)
                self.assertFalse(running)

    def test_direct_campaign_requires_prepared_budget(self):
        with temporary_work() as directory:
            work=Path(directory)
            (work/'PREPARATION.json').write_text(json.dumps(dict(
                status='PREFLIGHT_PASS',cpu=9,global_seconds=21600,sealed_files={})))
            with self.assertRaisesRegex(RuntimeError,'budget not preflighted'):
                run_campaign(work,28800,9)
            self.assertFalse((work/'RUN.json').exists())

    def test_invalid_preparation_budget_is_rejected_before_filesystem_access(self):
        for seconds in (0,-1,36001,36000.5,True):
            with self.subTest(seconds=seconds), self.assertRaisesRegex(RuntimeError,'integer seconds'):
                prepare.prepare(None,None,False,seconds=seconds)


if __name__=='__main__':
    unittest.main()
