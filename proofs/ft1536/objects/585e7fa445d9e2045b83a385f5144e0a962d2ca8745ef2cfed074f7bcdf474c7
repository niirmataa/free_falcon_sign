#!/usr/bin/env python3
"""Build supplementary diagnostic #print with fresh P02 oleans; preserve raw logs."""
from pathlib import Path
import hashlib,json,os,subprocess,datetime,sys
W=Path(__file__).resolve().parents[1];O=W/'output';run=W/'run';name=sys.argv[1]
dest=run/name;assert not dest.exists();dest.mkdir()
source=O/'formal/AuditTermsFull.lean'
if not source.exists():source=run/'AuditTermsFull.lean' # initial trial, not final claim
assert source.is_file()
prior=json.loads((run/'fresh_001/receipt.json').read_text())
env=prior['environment'].copy()
env['LEAN_PATH']=str(run/'fresh_001/build')+':'+':'.join(prior['environment']['LEAN_PATH'].split(':')[1:])
argv=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--ro-bind','/','/','--proc','/proc',
      '--dev-bind','/dev','/dev','--bind',str(dest),str(dest),'--ro-bind',str(O),str(O),
      '/usr/bin/prlimit','--as=8589934592','--','/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean',
      '-j1','-M2048','--root='+str(O/'formal'),'-o',str(dest/'AuditTermsFull.olean'),str(source)]
with (dest/'stdout').open('wb') as so,(dest/'stderr').open('wb') as se:
    p=subprocess.run(argv,env=env,stdout=so,stderr=se,timeout=1800)
text=(dest/'stdout').read_text();err=(dest/'stderr').read_text()
assert p.returncode==0 and not err and 'warning:' not in text
assert '⋯' not in text and '\n...\n' not in text
result={'schema':'P02_SUPPLEMENTAL_PRINTED_TERMS_V1','source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
        'source':str(source.relative_to(W)),'fresh_dependency_receipt_sha256':hashlib.sha256((run/'fresh_001/receipt.json').read_bytes()).hexdigest(),
        'argv':argv,'exit_code':p.returncode,'stdout_sha256':hashlib.sha256((dest/'stdout').read_bytes()).hexdigest(),
        'stderr_sha256':hashlib.sha256((dest/'stderr').read_bytes()).hexdigest(),
        'omission_glyphs':text.count('⋯'),'proof_term_prints':text.count('theorem '),'axioms_origin':'predecessor/AXIOMS.json',
        'scope':'only diagnostic printed terms with fresh import; does not alter 34 BUILD_PLAN or mathematical exports'}
(dest/'receipt.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print('SUPPLEMENTAL_TERMS_FULL',result['proof_term_prints'],'source',result['source'],flush=True)
