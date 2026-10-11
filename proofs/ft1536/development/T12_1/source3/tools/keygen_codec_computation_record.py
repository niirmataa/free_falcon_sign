#!/usr/bin/env python3
"""Record mathematical context for the custom guarded Sage/C controls.
Version1 context record; primary argv/limits/snapshot provenance remains in
custom RECEIPTS/SOURCE_INPUTS. Do not claim v2 launch/input instrumentation.
"""
from pathlib import Path
import hashlib,json,subprocess
ROOT=Path(__file__).resolve().parents[1];REPO=ROOT.parents[4]
D=ROOT/'.build/jobs/keygen_codec_sage_064_011'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rel(p):return str(p.resolve().relative_to(REPO))
rec=json.loads((D/'RECEIPTS.json').read_text())[0]
result=json.loads((D/'CODEC_FRAME_CHECK.json').read_text())
assert rec['accepted'] and rec['exit_code']==0 and result['status']=='PASS_PUBLIC_SOURCE_CODEC_CONTROLS'
compiler=subprocess.check_output(['readelf','-p','.comment',str(D/'probe_normal')],text=True).strip()
outputs=[D/'CODEC_FRAME_CHECK.json',D/'RECEIPTS.json',D/'SOURCE_INPUTS.json']
manifest={'schema_version':1,'claim_id':'B1.07_064_PUBLIC_CODEC_SOURCE_CONTROLS',
 'repository':{'commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip(),'dirty':True},
 'command':rec['argv'],
 'environment':{'software':[{'name':'SageMath','version':'10.9'},
   {'name':'C compiler object provenance','version':compiler}],
   'hardware':'Local Linux x86_64; no performance claim'},
 'mathematics':{'assertion_tested':'The two concrete encoder branches/default return exact reference bytes/returns; guarded capacity/NULL paths preserve canaries and PUBLIC input arrays. Six source mutations are detected in normal and UBSan modes.',
   'coefficient_domain':'ZZ, exact integer/bit-string arithmetic; byte serialization converts final values to JSON integers.',
   'conventions':'Big-endian two-byte NONE; STATIC sign/low magnitude/unary terminator bits, j7/q12289 and j8/q18433; independent zero padding.',
   'inputs':[{'path':rel(REPO/'Extra/c/falcon-enc.c'),'sha256':sha(REPO/'Extra/c/falcon-enc.c')},
     {'path':rel(ROOT/'sage/check_keygen_codec_frames.sage'),'sha256':sha(ROOT/'sage/check_keygen_codec_frames.sage')}],
   'bounds':{'profiles':[[18433,10,1536],[12289,3,8]],'comp':[0,1,2],
     'public_coefficients':'(37*i+7) mod515 -257',
     'capacity_cases':'0,1,max(0,encodedLen-1),encodedLen,encodedLen+7 (duplicates removed); NULL with cap0',
     'cases_per_mode':32,'modes':['normal','ubsan'],'mutation_kinds':6},
   'non_claims':['No universal codec correctness or capacity-window theorem.',
     'No C-to-memory-projection adequacy or full KeyGen/security law proof.']},
 'randomness':{'used':False,'generator':'deterministic public arithmetic pattern','seed':None},
 'run':{'started_at':rec['start'],'runtime_seconds':rec['elapsed_s'],'exit_status':rec['exit_code']},
 'outputs':[{'path':rel(p),'sha256':sha(p)} for p in outputs],
 'checks':['64/64 baseline actual C executions pass exact reference checks.',
   '6/6 mutations detected in each of2 modes.',
   'Actual argv, isolation, resource caps and Sage source snapshot are in the hashed custom receipts.'],
 'result':'Implementation and finite assertion verified in the stated test range.',
 'residual_risks':['This v1 context record does not itself instrument before/after hashes of every compiler/header input; custom runner provenance has its documented scope.',
   'Finite tests do not establish the remaining universal source-composition obligations.']}
target=ROOT/'.build/levels_064/COMPUTATION_MANIFEST.json'
assert not target.exists();target.write_text(json.dumps(manifest,indent=2)+'\n')
print(rel(target),sha(target))
