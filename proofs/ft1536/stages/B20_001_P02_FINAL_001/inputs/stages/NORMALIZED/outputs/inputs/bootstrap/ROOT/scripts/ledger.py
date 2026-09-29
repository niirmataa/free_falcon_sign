import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();numeric=json.loads((W/'artifacts/numeric_certificate.json').read_text());audit=json.loads((W/'artifacts/formal_audit.json').read_text())
assert numeric['status']=='PASS_EXACT_COMPOSITION' and audit['all_final_logs_clean']
assert json.loads((W/'artifacts/controls_normal.json').read_text())==json.loads((W/'artifacts/controls_san.json').read_text())
status='H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL'
flags=dict(H3_range_proved=False,global_reachability_proved=False,full_internal_tree_proved=False,sampler_law_proved=False,security_reduction_proved=False,
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False)
spec=[
 ('EMITTED_BINDING','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Emitted same-key decoding implies caps/NTRU/mandatory Gate00_C; serializers and exact final modular check accounted.', ['EMITTED_BINDING.md','artifacts/emitted_certificate.json','artifacts/source_binding.json']),
 ('FFT_DOMAIN_ERROR','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','All N1536 coefficients/frequencies; epsilon_fg=2^-26, epsilon_FG=2^-15; new active-backend domains.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json','formal/RootDiv.lean']),
 ('ROOT_GRAM','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','BB* orientation, errors A<1/1024, C norm<1, J<1024; a/c/j correlations retained.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json','artifacts/emitted_certificate.json']),
 ('ROOT_DIVISOR','PROVED_SOURCE_ANALYTIC','All g00 real in[1/2,2^23), positive normal; legal div/reciprocal domain and matching gate/loader.', ['EMITTED_BINDING.md','ROOT_FRAME.md','ANALYTIC_PROOF.md']),
 ('ROOT_MULTIPLIER','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_DIVISION','Actual per-component div; norm L<2^25, norm error<2^14.', ['ANALYTIC_PROOF.md','formal/RootDiv.lean','formal/RootModel.lean']),
 ('SUBTRACTIVE_SCHUR','PROVED_SOURCE_ANALYTIC_WITH_EXACT_CERTIFICATE','Actual muladj/neg/add; 32<Re(D_C)<2^31, complex error<2^22 versus q²/A.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json','formal/RootBounds.lean']),
 ('IMAGINARY_ERROR','PROVED_SOURCE_ANALYTIC','g00/g11 imag raw+0 by stores; |Im D_C|<32, not assumed identical zero.', ['ANALYTIC_PROOF.md','artifacts/numeric_certificate.json']),
 ('ROOT_FRAME','PROVED_SOURCE_ANALYTIC_WITH_KERNEL_STORE_FRAME','Defined actual prefix to root preserves original g00/g10/g11. Earlier subtree numerical correctness remains separate.', ['ROOT_FRAME.md','formal/RootFrame.lean','artifacts/controls_normal.json']),
 ('RECURSIVE_TREE_OPEN','OPEN','Uniform source split_top/LDL_dim3/split_deep/internal-node positivity/errors with propagated imaginary terms.', ['NEXT_INTERFACE.md']),
 ('INITIAL_TARGETS_OPEN','OPEN','Source FFT3(c), basis products and inverse(q) target initialization.', ['NEXT_INTERFACE.md','inputs/bootstrap/H3/REACHABILITY.md']),
 ('ORDERED_REACH_OPEN','OPEN','Emitted/M0 ordered prefix -> NumericCenter, including pre-dss/norm-rejected attempts and fault branches.', ['NEXT_INTERFACE.md','inputs/bootstrap/M0/H3_INTERFACE.md'])]
rows=[]
for id,s,claim,files in spec:
 rows.append(dict(id=id,status=s,claim=claim,evidence=[dict(path=r,sha256=sha(W/r)) for r in files]))
out=dict(schema='H3_ROOT_BOUND_LEDGER_V1',status=status,rows=rows,constants=numeric['constants'],proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',full_root_theorem_kernelized=False,**flags)
root=dict(schema='H3_ROOT_CERTIFICATE_V1',status=status,required_support='All Emitted_C with source roundtrip of the same sk; proved superset P_key',
 P_key=['length1536 and ternary f,g','abs(F_i),abs(G_i)<=2047','fG-gF=18433 mod X^1536-X^768+1','actual mandatory Gate00_C, derived from Emitted'],
 unresolved_numerical_premises=[],api_model_premises=['GCC14.2/C99/Linux x86_64 LP64 active portable FPEMU','legal sizes, buffers, lifetimes and disjoint output/scratch allocations','operational defined successful Emitted_C; same bytes source decoding'],
 root_slice='of/FFT3; B=[[g,-f],[G,-F]]; source Gram; per-component div; muladj/neg/add',
 constants=numeric['constants'],fft_map=numeric['fft_map'],correlated_schur_envelope='|D_C-|det(Bhat)|²/a|<=256*2^-48*j, with a/c/j exact Gram of computed FFT values',
 proof_kind=out['proof_kind'],full_root_theorem_kernelized=False,C_compiler_kernel_refinement=False,
 evidence=[dict(path=r,sha256=sha(W/r)) for r in ['ANALYTIC_PROOF.md','EMITTED_BINDING.md','ROOT_FRAME.md','artifacts/numeric_certificate.json','artifacts/emitted_certificate.json','artifacts/formal_audit.json']],**flags)
ob=dict(schema='H3_ROOT_OBLIGATIONS_V1',local_status=status,local_root_open=[],obligations=rows[8:]+[dict(id='SAMPLER_LAW_OPEN',status='OPEN',claim='Separate distribution/acceptance interface; no automatic global loss or abort.')],
 optional_kernelization='Complete source-error/root/emitted composition currently proved analytically, not a completed kernel C theorem.',next_lemma_document='NEXT_INTERFACE.md',**flags)
for name,data in [('BOUND_LEDGER.json',out),('ROOT_CERTIFICATE.json',root),('OBLIGATIONS.json',ob)]:
 with (W/name).open('w') as f:json.dump(data,f,indent=2);f.write('\n')
lines=['# H3_ROOT_LDL — bound ledger','',status,'','| ID | Status | Claim |','|---|---|---|']
lines += ['| '+r['id']+' | '+r['status']+' | '+r['claim']+' |' for r in rows]
lines+=['','Full piny evidence i rational constants: BOUND_LEDGER.json / ROOT_CERTIFICATE.json.','Proof mixed analytic/kernel; full_root_theorem_kernelized=false.','Global Reach, internal tree, sampler law i security reduction pozostają false.']
(W/'BOUND_LEDGER.md').write_text('\n'.join(lines)+'\n');print(json.dumps(dict(status=status,rows=len(rows),constants=numeric['constants'],**flags),indent=2))
