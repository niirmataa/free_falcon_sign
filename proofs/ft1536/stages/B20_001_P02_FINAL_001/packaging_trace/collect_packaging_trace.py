#!/usr/bin/env python3
"""Retain controller sources/logs and initial audit-root failure in sealed output."""
from pathlib import Path
import hashlib,shutil,json
W=Path(__file__).resolve().parents[1];R=W/'run';O=W/'output/packaging_trace'
assert not O.exists()
O.mkdir()
for p in sorted(R.iterdir()):
    if p.is_file() and (p.suffix in ('.py','.stdout','.stderr','.exit','.json','.lean')):
        shutil.copyfile(p,O/p.name)
for n in ('probe_audit_001','probe_audit_002'):
    dest=O/n;dest.mkdir()
    for p in (R/n).iterdir():
        if p.is_file() and p.name not in ('AuditTermsFull.olean',):shutil.copyfile(p,dest/p.name)
    assert (dest/'stderr').is_file() and (dest/'stdout').is_file()
assert b'must be contained in root directory' in (O/'probe_audit_001/stderr').read_bytes()
assert (O/'probe_audit_002/stderr').read_bytes()==b''
assert (O/'fresh_001.controller.exit').read_text().strip()=='0'
assert (O/'fresh_002.controller.exit').read_text().strip()=='0'
assert (O/'fresh_003.controller.exit').read_text().strip()=='0'
print('PACKAGING_TRACE_READY',sum(p.is_file() for p in O.rglob('*')))
