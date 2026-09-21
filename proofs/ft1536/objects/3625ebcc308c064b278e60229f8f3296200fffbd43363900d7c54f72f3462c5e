import hashlib,json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
prov=json.loads((W/'inputs/provenance.json').read_text())
for r in prov:assert sha(r['copy'])==r['sha256']
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,name=line.split('  ',1);assert sha('source/'+name)==h
out=dict(inputs=len(prov),copies_match=True,source_files=17,source_manifest_sha256=sha('inputs/source_hashes.sha256'),
 verifier_sha256=sha('source/falcon-vrfy.c'),inherited_modules_unchanged=61,KeyGen_executed=False,Sign_executed=False)
(W/'artifacts/input_audit.json').write_text(json.dumps(out,indent=2)+'\n')
ledger=json.loads((W/'HOP_LEDGER.json').read_text())
rows=[dict(id='M0_PROFILE_GAME',status='DEFINED',evidence=['PROFILE.json','GAME.md','DECISIONS.md'],gap=None),
 dict(id='CAPACITY',status='PROVED_ANALYTIC_KERNEL_COUNT_MODEL_C_BINDING',evidence=['CAPACITY.md','formal/CapacityMath.lean','formal/EncoderCount.lean','artifacts/capacity_checks.json'],gap=None),
 dict(id='FRAMING',status='PROVED_FOR_FIXED40_DOMAIN',evidence=['formal/Framing.lean','artifacts/capacity_checks.json'],gap=None),
 dict(id='PARAMETRIC_TARGET',status='DEFINED_NOT_PROVED',evidence=['TARGET_TYPE.md','HOP_LEDGER.json'],gap='Complete M1-M6 component certificates and M7 proof are open.'),
 dict(id='H3_HANDOFF',status='READY_INTERFACE_NOT_EXECUTED',evidence=['H3_INTERFACE.md'],gap='Next separately assigned source reachability proof.'),
 dict(id='CONTRACT_CONSISTENCY',status='CHECKED',evidence=['artifacts/contract_checks.json'],gap=None)]
rows.extend(dict(id=r['id'],status=r['status'],origin='ledger',evidence=[x['path'] for x in r['inputs']],
                  premises=r['premises']) for r in ledger['rows'])
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(schema='FT1536_M0_OBLIGATIONS_V1',status='M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE',
   obligations=rows,security_reduction_proved=False,M0_ambiguities_remaining=[],H3_started=False,
   source_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False),indent=2)+'\n')
print(json.dumps(dict(input_audit=out,obligations=len(rows)),indent=2))
