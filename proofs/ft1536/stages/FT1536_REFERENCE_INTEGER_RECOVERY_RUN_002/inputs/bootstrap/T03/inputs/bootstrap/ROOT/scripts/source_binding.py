import difflib,json,re
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73')
spans={'falcon-sign.c':[(496,530),(597,752),(1047,1057),(1065,1145),(1159,1268),(3150,3277)],
 'falcon-keygen.c':[(1364,1374),(2473,2598),(2911,3137),(4493,4508),(4753,4781),(7338,7397),(7430,7437),(7549,7777),(8094,8187)],
 'falcon-fft.c':[(52,108),(755,850),(1015,1116),(1260,1271)],'fpr-emulated.c':[(14,54),(150,204),(448,556),(680,776),(915,1002)],'fpr-emulated.h':[(18,55),(86,90),(151,193)]}
folder=W/'inputs/slices';folder.mkdir(exist_ok=True);rows=[]
for name,windows in spans.items():
 src=W/'source'/name;assert sha(src)==sha(I/'source'/name);lines=src.read_text().splitlines()
 for a,b in windows:
  p=folder/f'{name}_{a}_{b}.txt';p.write_text('\n'.join(f'{i+1}: {lines[i]}' for i in range(a-1,b))+'\n')
  rows.append(dict(source='source/'+name,source_sha256=sha(src),first=a,last=b,copy=str(p.relative_to(W)),sha256=sha(p)))
# Literal instruction-order correspondence, retaining original pinned functions.
def body(text,name):
 at=text.index('\n'+name+'(');start=text.index('{',at);depth=1;end=start+1
 while depth:
  depth += (text[end]=='{')-(text[end]=='}');end+=1
 return text[start:end]
def tokens(s):return re.findall(r'[A-Za-z_][A-Za-z_0-9]*|\d+|[^\s]',re.sub(r'/\*.*?\*/','',s,flags=re.S))
sign=(W/'source/falcon-sign.c').read_text();key=(W/'source/falcon-keygen.c').read_text()
pairs=[]
for n in ['LDL_dim2_fft3','LDL_dim3_fft3','ffLDL_inner_fft3','ffLDL_depth1_fft3','ffLDL_fft3','smallints_to_fpr']:
 a=body(sign,n);b=body(key,n+'_keygen').replace('_keygen','');assert tokens(a)==tokens(b),n
 pairs.append(n)
diff=''.join(difflib.unified_diff((I/'legacy/T5/inputs/a1/scripts/audit_fft_twiddles.sage').read_text().splitlines(True),(W/'scripts/certificate.py').read_text().splitlines(True),fromfile='legacy/audit_fft_twiddles.sage',tofile='scripts/certificate.py'))
(W/'artifacts/diffs/twiddle_and_new_certificate.patch').write_text(diff)
out=dict(status='PASS_SOURCE_BYTE_AND_INSTRUCTION_BINDING',source_files=17,spans=rows,keygen_signer_token_identical_functions=pairs,
 literal_models={r:sha(W/r) for r in ['scripts/backend.py','scripts/fp_literal.py','scripts/root_model.py','formal/RootModel.lean']},
 analytical_proofs={r:sha(W/r) for r in ['ANALYTIC_PROOF.md','EMITTED_BINDING.md','ROOT_FRAME.md']},
 full_C_compiler_refinement=False,full_kernel_root_error_proof=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='spans'},indent=2))
