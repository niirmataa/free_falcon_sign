"""One-shot public state snapshot from an immutable Git commit; no proof runner."""
import argparse
import hashlib
import json
from pathlib import Path
import platform
import subprocess
import sys

BASE = '2959064e8132443649de50600b20bfc32ed618cb'
STAGE = 'FT1536_POST_M0_FREEZE_RUN_001'
W = Path(__file__).absolute().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--repo', required=True, type=Path)
args = parser.parse_args()
repo = args.repo.absolute()
sys.path.insert(0, str(repo/'proofs/ft1536/tools'))
import archive

archive.require(not (W/'OUTPUTS.sha256').exists(), 'Frozen snapshot must not be rewritten')
archive.require(BASE.encode() in archive.read(W/'REPORT.md'), 'Report base mismatch')
commands = []
def git(*argv):
    command = ['git', *argv]
    p = subprocess.run(command, cwd=repo, capture_output=True, timeout=60)
    commands.append(dict(argv=command, cwd=str(repo), exit_code=p.returncode,
                         stdout_sha256=archive.digest(p.stdout), stderr_sha256=archive.digest(p.stderr)))
    archive.require(p.returncode == 0, 'Git read failed: '+repr(command))
    return p.stdout
def blob(path):
    archive.checked_path(path)
    mode = git('ls-tree', BASE, '--', path).split(b' ', 1)[0]
    archive.require(mode in (b'100644', b'100755'), 'Non-regular Git input: '+path)
    return git('show', BASE+':'+path)
inputs = {}
bindings = []
def include(path):
    if path in inputs:
        return archive.read(W/'inputs'/path)
    data = blob(path)
    dest = W/'inputs'/path
    archive.put_once(dest, data)
    inputs[path] = archive.digest(data)
    bindings.append(dict(original='git:'+BASE+':'+path, copy='inputs/'+path,
                         sha256=inputs[path], bytes=len(data)))
    return data
def group_manifest(path):
    entries = archive.manifest(include(path))
    for name, expected in entries.items():
        data = include((Path(path).parent/name).as_posix())
        archive.require(archive.digest(data)==expected, 'Recorded receipt mismatch')

ids = [
    'FT1536_LV_STATIC_RUN_001','FT1536_LV_STATIC_ODBIOR_BLUE_001',
    'FT1536_L_RHO_RUN_001','FT1536_L_NTT_RUN_001','FT1536_L_NTT_GLOBAL_RUN_001',
    'FT1536_L_NTT_FORWARD_RUN_001','FT1536_L_V_BRIDGE_RUN_001','FT1536_M0_CONTRACT_RUN_001',
]
checkpoints = []
for name in ids:
    catpath = 'proofs/ft1536/catalog/'+name+'.json'
    record = json.loads(include(catpath))
    prefix = 'proofs/ft1536/stages/'+name+'/'
    outputs = include(prefix+'OUTPUTS.sha256')
    archive.require(archive.digest(outputs)==record['manifest_sha256'], 'Stage manifest pin')
    members = archive.manifest(outputs)
    for member in (record['report'], record['result_file']):
        archive.require(archive.digest(include(prefix+member))==members[member], 'Stage summary pin')
    checkpoints.append({key:record[key] for key in ('stage','claimed_status','manifest_sha256','report','report_sha256','output_entries','replay')})

for path in ['README.md','AGENTS.md','Makefile','tools/build_ft1536.py',
             'tests/ft1536/fpemu_smoke.c','tests/ft1536/verifier_regression.c',
             'provenance/FT1536_ACTIVE_BUILD.md','provenance/FT1536_S17.md',
             'proofs/ft1536/README.md','proofs/ft1536/history/2026-09-18-noreply-map.json']:
    include(path)
candidate = archive.manifest(include('provenance/ft1536-candidate.sha256'))
reference = archive.manifest(include('provenance/ft1536-s17.sha256'))
archive.require(len(candidate)==len(reference)==17, 'Source count')
source_checks = {}
for path, expected in candidate.items():
    data = include('Extra/c/'+path)
    archive.require(archive.digest(data)==expected, 'Active source differs from proof candidate')
    archived = blob('proofs/ft1536/stages/FT1536_L_V_BRIDGE_RUN_001/source/'+path)
    archive.require(data==archived, 'Candidate/archive difference')
    old = blob('proofs/ft1536/stages/FT1536_L_RHO_RUN_001/reference/'+path)
    archive.require(archive.digest(old)==reference[path], 'S17 reference changed')
    source_checks[path]=dict(active_sha256=expected, S17_sha256=reference[path], equal_to_S17=data==old)
archive.require([p for p,x in source_checks.items() if not x['equal_to_S17']]==['falcon-vrfy.c'], 'Unexpected S17 delta')

documents = [
    'FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md',
    'FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md',
    'FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md',
    'FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md',
    'FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md',
]
for name in documents:
    path='proofs/ft1536/documents/'+name
    data=include(path)
    rows=archive.manifest(include(path+'.sha256'))
    archive.require(rows=={name:archive.digest(data)}, 'Document pin')
for name in ('PROFILE.json','DECISIONS.md','GAME.md','RESOURCE_MODEL.md','HOP_LEDGER.json',
             'HOP_LEDGER.md','TARGET_TYPE.md','CAPACITY.md','H3_INTERFACE.md','SOURCE_MODEL_BINDING.md'):
    include('proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/'+name)
for folder in ('2026-09-18','2026-09-18-forward','2026-09-19-lv','2026-09-19-m0'):
    group_manifest('proofs/ft1536/validation/'+folder+'/VALIDATION.sha256')
    include('proofs/ft1536/validation/'+folder+'/README.md')
for folder in ('2026-09-19-s17','2026-09-19-candidate'):
    group_manifest('provenance/checks/'+folder+'/CHECKS.sha256')
    include('provenance/checks/'+folder+'/README.md')

nodes = [
    ('S17','HISTORICAL_REFERENCE_WITH_COUNTEREXAMPLE'),('RHO','PROVED_PINNED_MODEL'),
    ('NTT','PROVED_PINNED_MODEL'),('LV','PROVED_PINNED_MODEL'),('M0','CONTRACT_DEFINED'),
    ('T2C3','HISTORICALLY_ACCEPTED_FIXED_KEY'),('T5','HISTORICALLY_ACCEPTED_UNTRUNCATED_SUCCESSFUL_KEYS'),
    ('ANALYTIC_COMMON','PINNED_UNIVERSAL_INTERFACES'),('H3','OPEN_REACHABILITY'),
    ('SIGN_LAW','OPEN_JOINT_GEOMETRY'),('BYTES','OPEN_PRECAST_RETRY_FAILURES'),
    ('R5T','CONDITIONAL_ARGUMENT_NEW_FREEZE_REQUIRED'),('CHI2','OPEN_FULL_KERNEL_INSTANTIATION'),
    ('PUBLIC_SAMPLER','OPEN_ERROR_AND_RESOURCES'),('ROM','OPEN_PROGRAMMING'),
    ('RNG','OPEN_REDUCTION_AND_ASSUMPTIONS'),('MT','CRYPTOGRAPHIC_ASSUMPTION_REQUIRED'),
    ('M7','OPEN_COMPOSITION'),('WRAPPER','NOT_INTEGRATED'),('QROM','SEPARATE_FUTURE_TASK'),
]
edges = [('RHO','NTT'),('NTT','LV'),('M0','H3'),('H3','SIGN_LAW'),('SIGN_LAW','BYTES'),
         ('T5','R5T'),('ANALYTIC_COMMON','T2C3'),('ANALYTIC_COMMON','R5T'),('R5T','CHI2'),
         ('M0','CHI2'),('M0','WRAPPER'),('PUBLIC_SAMPLER','ROM'),('CHI2','ROM'),('LV','ROM'),
         ('BYTES','M7'),('ROM','M7'),('RNG','M7'),('MT','M7')]
state = dict(schema='FT1536_POST_M0_STATE_V1', checkpoint=STAGE, base_commit=BASE,
             base_tree=git('rev-parse',BASE+'^{tree}').decode().strip(),
             active_source_manifest_sha256='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a',
             active_build='Extra/c: exact L_RHO candidate; make FT1536',
             candidate_source_integrated=True, historical_flags_preserved=True,
             protocol_wrapper_integrated=False, security_reduction_proved=False,
             M0_contract='FT1536-M0-r40-static4096-parametric-v1',
             honest_payload_capacity=4096, nonce_bytes=40, proved_payload_bound=3160,
             adversary_payload_cap=None, concrete_security_level_selected=False,
             next_mathematical_interface='M0/H3_INTERFACE.md: emitted-key reachable center range',
             source_checks=source_checks)
products = {'STATE.json':state,'CHECKPOINTS.json':checkpoints,'INPUT_BINDINGS.json':bindings,
            'DEPENDENCIES.json':dict(nodes=[dict(id=n,status=s) for n,s in nodes],
                edges=[dict(source=a,target=b,kind='mathematical_or_interface_dependency_not_task_order') for a,b in edges],
                fixed_key_numerical_lift_to_R5T=False),
            'RESULT.json':dict(schema='FT1536_DOCUMENTARY_FREEZE_V1',status='RESEARCH_STATE_FROZEN_POST_M0',
                documentation_freeze=True,base_commit=BASE,research_checkpoints=len(checkpoints),
                candidate_source_integrated=True,protocol_wrapper_integrated=False,
                security_reduction_proved=False,owner_freeze_requested=True,owner_accepted=False,
                new_mathematical_claim=False,replay='none'),
            'BINDING_CHECKS.json':dict(status='PASS',git_inputs=len(inputs),source_files_checked=17,
                source_candidate_identity=True,only_S17_difference='falcon-vrfy.c',
                copied_receipts_verified=True,scope='Git-bound documentation snapshot, not new proof replay')}
for name,value in products.items(): archive.put_once(W/name,archive.json_bytes(value))
archive.put_once(W/'INPUTS.sha256',''.join(h+'  git:'+BASE+':'+p+'\n' for p,h in sorted(inputs.items())).encode())
archive.put_once(W/'TOOLCHAIN.txt',('Documentation snapshot builder\nPython: '+sys.version+'\nPlatform: '+platform.platform()+'\n'+git('--version').decode()).encode())
archive.put_once(W/'COMMANDS.log',''.join(json.dumps(r,sort_keys=True)+'\n' for r in commands).encode())
archive.put_once(W/'REPLAY.md',b'# Documentary checkpoint\n\nProtocol: none. Validate using archive.py verify FT1536_POST_M0_FREEZE_RUN_001.\nThe source inputs are Git-qualified and preserved locally; use INPUT_BINDINGS.json.\nThe builder refuses to rewrite a frozen directory. Computational replays belong\nto the original research checkpoints, whose exact pins are retained.\n')
archive.put_once(W/'OUTPUT_SCOPE.md',b'# Frozen scope\n\nAll regular files in this package except OUTPUTS.sha256 are covered.\nInputs are exact public Git blobs from the recorded base commit. Earlier\nmanifest copies retain their original bases and serve as provenance here.\nNo private keys, seeds, caches, binaries, local index or active research runs\nare copied. This checkpoint freezes documentation and state, not a new theorem.\n')
members=archive.regular_files(W)
archive.put_once(W/'OUTPUTS.sha256',''.join(archive.digest(archive.read(W/p))+'  '+p+'\n' for p in sorted(members)).encode())
print(json.dumps({'status':'RESEARCH_STATE_FROZEN_POST_M0','base_commit':BASE,
    'inputs':len(inputs),'outputs':len(members),'report_sha256':archive.digest(archive.read(W/'REPORT.md')),
    'outputs_sha256':archive.digest(archive.read(W/'OUTPUTS.sha256'))},indent=2))
