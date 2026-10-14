#!/usr/bin/env sage
# Bind the selected public fixture to the old S1 digest without rerunning C.
import hashlib,json
from pathlib import Path
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4];job=root/'.build/jobs/keygen_witness113_003'
manifest=job/'WITNESS113.json'
assert hashlib.sha256(manifest.read_bytes()).hexdigest()=='e1e65bb963528b3fd34231fd29c32bd3fe312692e6d8bc772281b97a6f391821'
record=json.loads(manifest.read_text());selected=Path(record['selected'])
key=(selected/'private.bin').read_bytes()+(selected/'public.bin').read_bytes()
h=ZZ(0xcbf29ce484222325)
for b in key:h=((h^^ZZ(b))*ZZ(0x100000001b3))%2^64
prior=repo/'proofs/ft1536/work/FT1536_FG_PROBE_P_ACCEPT_001/digests_meas1.txt'
lines=[line.split() for line in prior.read_text().splitlines()]
expected=next(v for k,v in lines if k==str(record['counter']))
assert format(int(h),'016x')==expected
Path('PRIOR113.json').write_text(json.dumps({'status':'MATCH_RETAINED_S1_PUBLIC_FIXTURE_DIGEST',
    'counter':record['counter'],'fnv1a':expected,'source_manifest_sha256':hashlib.sha256(manifest.read_bytes()).hexdigest(),
    'prior_digest_file_sha256':hashlib.sha256(prior.read_bytes()).hexdigest(),
    'native_keygen_calls':int(0),'kernel_source_witness':False},indent=2)+'\n')
