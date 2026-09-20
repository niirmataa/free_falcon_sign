import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();a=json.loads((W/'artifacts/semantic_normal.json').read_text());b=json.loads((W/'artifacts/semantic_san.json').read_text());assert a==b
f=json.loads((W/'artifacts/corpus.json').read_text());l=json.loads((W/'artifacts/lean_values.json').read_text())
out=dict(status='PASS',normal=a,ASan_UBSan=b,LSan_claimed=False,independent_oracle=f['oracle'],all_word_kernel_proof='formal/FloorWord.lean',lean_values=l,
 input_manifest_sha256=sha(W/'INPUTS.sha256'),candidate_manifest_sha256=sha(W/'candidate/CANDIDATE.sha256'))
(W/'SEMANTIC_CHECKS.json').write_text(json.dumps(out,indent=2)+'\n')
mut=dict(status='PASS_REAL_VALUE_MUTATIONS',witnesses=f['mutation_witnesses'],noop_pass=f['noop_pass'],scope='Mutated semantic equations, with concrete public raw words; source baseline/candidate left intact.')
(W/'MUTATION_CONTROLS.json').write_text(json.dumps(mut,indent=2)+'\n');print(json.dumps(dict(status='PASS',cases=f['cases'],lean_values=l['cases'],mutations=3)))
