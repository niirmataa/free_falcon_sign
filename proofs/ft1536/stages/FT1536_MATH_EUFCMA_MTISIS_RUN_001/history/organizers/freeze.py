#!/usr/bin/env python3
"""Final integrity checks and immutable manifest; no mathematical computations."""
import hashlib
import json
from pathlib import Path
import re
import sys
from datetime import datetime, timezone

W=Path(__file__).resolve().parent.parent
O=W/'output'
def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1048576),b''): h.update(b)
    return h.hexdigest()
def verify(manifest):
    count=0
    for line in manifest.read_text().splitlines():
        h,name=line.split(maxsplit=1);name=name.lstrip('*')
        p=O/name
        assert not p.is_symlink() and p.resolve().is_relative_to(O)
        assert sha(p)==h,('MISMATCH',name)
        count+=1
    return count
assert sha(O/'REPLAY_SEED.sha256')=='a5ff7f1a2f34dd0735b35c1b84afb915773c226e797f16b0b767bea777b4b707'
seed_count=verify(O/'REPLAY_SEED.sha256')
inputs_count=verify(O/'INPUTS.sha256')
for p in O.rglob('*.json'):json.loads(p.read_text())
semantic=json.loads((O/'SEMANTIC_FILES.json').read_text())
for item in semantic['files']:assert sha(O/item['path'])==item['sha256']
replay=json.loads((O/'replay/REPLAY_RESULT.json').read_text())
assert replay['status']=='PASS' and replay['exports_audited']==101
for rec in replay['receipts']:
    for kind in ['stdout','stderr']:assert sha(O/'replay'/rec[kind])==rec[kind+'_sha256']
    if rec['name'].startswith('FT1536_') or rec['name']=='Audit':
        module=rec['name'].replace('FT1536_','FT1536/')+'.lean' if rec['name']!='Audit' else 'Audit.lean'
        assert sha(O/'formal'/module)==rec['source_sha256']
sage=json.loads((O/'SAGE_RUNS.json').read_text())
for run in sage['runs']:
    assert sha(O/run['source_in_bundle'])==run['source_sha256']
    for kind in ['stdout','stderr']:assert sha(O/run[kind])==run[kind+'_sha256']
guards=json.loads((O/'replay/guard_controls/RESULT.json').read_text())
assert len(guards['tests'])==4 and all(t['pass_control'] for t in guards['tests'])
required='REPORT.md RESULT.json CLAIM.md MODEL.md GOAL_SPEC.md GOAL_SPEC.json FORMAL_EXPORTS.json ASSUMPTIONS.json BRIDGE_LEDGER.md RESOURCE_BOUND.md RESOURCE_BOUND.json NEXT_INTERFACE.md AXIOMS.json INPUTS.sha256 EXECUTION_RECEIPTS.json SAGE_RUNS.json COMMANDS.log FAILED_ROUTES.md REPLAY.md SEMANTIC_FILES.json OUTPUT_SCOPE.md HANDOFF.md'.split()
assert all((O/name).is_file() for name in required)
# Nested bootstrap stage manifests are members too; exclude only the top-level self.
files=[p for p in sorted(O.rglob('*')) if p.is_file() and p!=O/'OUTPUTS.sha256']
assert not any(p.is_symlink() for p in O.rglob('*'))
(O/'OUTPUTS.sha256').write_text(''.join(f'{sha(p)}  {p.relative_to(O)}\n' for p in files))
count=verify(O/'OUTPUTS.sha256')
pins=dict(task_id='FT1536_MATH_EUFCMA_MTISIS_RUN_001',status='PARTIAL_PROOF',
    frozen_at=datetime.now(timezone.utc).isoformat(),report_sha256=sha(O/'REPORT.md'),
    outputs_sha256=sha(O/'OUTPUTS.sha256'),replay_seed_sha256=sha(O/'REPLAY_SEED.sha256'),
    inputs_sha256=sha(O/'INPUTS.sha256'),members=count,bootstrap_and_pin_files=inputs_count,
    replay_seed_members=seed_count,bundle_bytes=sum(p.stat().st_size for p in files))
(W/'FINAL_PINS.json').write_text(json.dumps(pins,indent=2)+'\n')
(W/'HANDOFF.md').write_text(f'''# FT1536 T12.1 — zamrożony handoff autora

Status: **PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW**.
Model: GPT-6 Astra Fast (`openai/gpt-6-astra-fast`), świeży kontekst.
Sesja: ses_f33dcb1cbffe1cK536p26REYAg.

Pakiet: `{O}`

- REPORT SHA256: `{pins['report_sha256']}`
- OUTPUTS SHA256: `{pins['outputs_sha256']}`
- INPUTS SHA256: `{pins['inputs_sha256']}`
- REPLAY_SEED SHA256: `{pins['replay_seed_sha256']}`
- TASK SHA256: `0fe2ad810e476e44e6cc3a1bca0bcc409004810cfe4b5424523ba914ac9e0cc3`
- Bootstrap MANIFEST SHA256: `a1fe3416478599c3f19200cdfeedc80e98a1291678dd1c871b3f6e6511d28b15`
- BASE: `c5faaeb6395c8238724494e8000eb6df55e65baf`
- HEAD: `ba1c576ea680e4d8cf6bebbdc9e356bbf64f20c1`, main.

101 twierdzeń,15 modułów, transitive axioms tylko standardowe.
Fresh replay19/19, produkty3/3, replay guards4/4. Manifest obejmuje{count} plików.
Własne joby obliczeniowe zakończone. Bez zmian Git/push/innych W.

Ocena: zamknięto prawo retry, istotny rachunek kierunkowego chi²/Phi i
operacyjne przypisanie/ekstrakcję celu. Zachowano kontrprzykład centrowania.
Pełny lemat warunkowy EUF-CMA NIE jest zamknięty: brakuje interpretera gry,
identyfikacji praw warunkowych i certified bit-cost. Efektywny publiczny
sampler i małe błędy także OPEN. MODEL/NEXT_INTERFACE określają węższą
Sigma_math i dalszy obowiązek. Kolejny krok: niezależny scoped review,
potem koordynator importuje zaakceptowane eksporty i commituje na main.

Do niezależnego replayu użyć tools/replay.py, NOWEGO trwałego DEST oraz
zewnętrznego pinu OUTPUTS powyżej. Nie uruchamiać ponownie pracy w output/.
''')
for p in files+[O/'OUTPUTS.sha256']:p.chmod(0o444)
for p in sorted((p for p in O.rglob('*') if p.is_dir()),key=lambda p:len(p.parts),reverse=True):p.chmod(0o555)
O.chmod(0o555)
print(json.dumps(pins,indent=2))
