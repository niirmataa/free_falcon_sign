import hashlib,json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
spans=[('shifts','fpr-emulated.h',18,37),('pack','fpr-emulated.h',39,55),('of_wrapper','fpr-emulated.h',86,90),
 ('floor','fpr-emulated.h',117,133),('sub_neg','fpr-emulated.h',151,163),('norm64','fpr-emulated.c',14,54),
 ('scaled','fpr-emulated.c',150,204),('add','fpr-emulated.c',448,556),('scalar','falcon-sign.c',2840,2972),
 ('terminal','falcon-sign.c',1616,1649)]
rows=[]
for n,s,a,b in spans:
 data=(W/'source'/s).read_bytes();part=b''.join(data.splitlines(keepends=True)[a-1:b]);rel='inputs/slices/'+n+'.txt'
 (W/rel).parent.mkdir(exist_ok=True);(W/rel).write_bytes(part)
 rows.append(dict(id=n,source='source/'+s,source_sha256=hashlib.sha256(data).hexdigest(),lines=[a,b],slice=rel,slice_sha256=hashlib.sha256(part).hexdigest()))
out=dict(candidate_manifest_sha256=sha('inputs/bootstrap/CANDIDATE.sha256'),spans=rows,
 literal_python_model_sha256=sha('scripts/fp_literal.py'),
 normalized_kernel_models={n:sha('formal/'+n+'.lean') for n in ['ValueDomain','SourceFloor','ZeroRho','BitErrors','PackOf','ErrorArithmetic','EndpointFacts','LiteralAdd']},
 analytical_proof_sha256=sha('ANALYTIC_PROOF.md'),C_unchanged=True,source_backend='active portable C FPEMU, no ARM/no fpr-double',
 normalized_equations=['uint64 shifts and masks -> rawMant/sourceFloor with exact0/1 conditional selects','FPR_NORM64 six masks -> nstep threshold32,16,8,4,2,1','alignment/shrink OR masks -> sticky','FPR rounding -> roundMant table0xC8','clamped pack -> signed zero, otherwise packNormal'],
 proof_scope=dict(A='kernel plus explicit C integer translation',OF='kernel source-normalized transducer plus literal C binding',
  B='universal analytical source branch proof with kernel integer lemmas and exact class certificate; not fully kernelized fpr_add',
  C='kernel exact rho/residual and typed consumer; analytical source-error substitution E=2^-20'),
 no_unknown_error_assumption_in_analytic_contract=True,fully_kernelized_source_add_error=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(spans=len(rows),C_unchanged=True,fully_kernelized_source_add_error=False),indent=2))
