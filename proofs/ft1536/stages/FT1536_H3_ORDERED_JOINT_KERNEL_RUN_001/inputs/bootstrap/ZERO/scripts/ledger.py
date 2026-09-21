import hashlib,json
from pathlib import Path
W=Path.cwd()
def pin(p):return dict(path=p,sha256=hashlib.sha256((W/p).read_bytes()).hexdigest())
rows=[]
def row(i,claim,status,domain,evidence,next_need):
 rows.append(dict(id=i,claim=claim,status=status,domain=domain,evidence=[pin(p) for p in evidence],remaining_consumption=next_need))
row('FLOOR_ZERO','NumericCenter implies exponent<=1053 and source floor=floor(val)-eps0, including -0.','PROVED_KERNEL_WITH_C_TRANSLATION','All local finite64-bit words in NumericCenter; no NotNegZero premise.',
 ['formal/ValueDomain.lean','formal/SourceFloor.lean','scripts/fp_literal.py'],None)
row('C_INT_BRIDGE','long->int exact and s_C+z within int32 for all z in[-365,366].','PROVED_KERNEL_WITH_C_TRANSLATION','NumericCenter; successful nonfault proposal return, not sticky0.',
 ['formal/SourceFloor.lean','inputs/bootstrap/H3/formal/Proposal.lean'],None)
row('OF_EXACT','Source-normalized fpr_of on signed32 returns exact integer value; zero is +0.','PROVED_KERNEL_WITH_C_TRANSLATION','All i in[-2^31,2^31-1].',
 ['formal/BitErrors.lean','formal/PackOf.lean','ANALYTIC_PROOF.md'],None)
row('SUB_CENTER','r_C finite; |val(r_C)-(val(x)-s_C)|<=1/1048576.','PROVED_UNIVERSAL_ANALYTIC_WITH_KERNEL_INTEGER_LEMMAS','Every NumericCenter word, including zeros/subnormals/underflow.',
 ['ANALYTIC_PROOF.md','formal/BitErrors.lean','formal/LiteralAdd.lean','artifacts/error_certificate.json'],
 'Full source-add theorem is not kernelized: kernel consumers explicitly take this analytically proved source contract. No error bound is left unknown in the analytical theorem.')
row('SUB_RESIDUAL','res_C finite; absolute error versus val(x)-(s_C+z)<=1/1048576.','PROVED_UNIVERSAL_ANALYTIC_WITH_KERNEL_INTEGER_LEMMAS','Every NumericCenter and all z in[-365,366].',
 ['ANALYTIC_PROOF.md','formal/ErrorArithmetic.lean','formal/LiteralAdd.lean','artifacts/error_certificate.json'],
 'Same proof-layer distinction as SUB_CENTER; this is not an all-backend IEEE theorem.')
row('R_DELTA_DOMAIN','r_C and sub_C(1,r_C) are +0 or positive normal, values in[0,1]; endpoint1 not exclusive to -0.','PROVED_SOURCE_CASE_ANALYSIS_WITH_KERNEL_ENDPOINTS','All NumericCenter; no extra normality/zero assumption.',
 ['ANALYTIC_PROOF.md','formal/EndpointFacts.lean','formal/LiteralAdd.lean','artifacts/controls_normal.json'],None)
row('ORDERED_CONSUMPTION','rho in closed[0,1], exact residual<=366, machine residual<=366+2^-20; ordered zero-aware terminal bridge.','PROVED_MIXED_KERNEL_ANALYTIC','First NumericCenter, then returned residual, then next center. E_half/E_add explicit.',
 ['formal/ZeroRho.lean','formal/ErrorArithmetic.lean','ANALYTIC_PROOF.md'],
 'Resolve E_half/E_add and the next-center premise on appropriate global paths; do not apply closeness to sticky/fault0.')
row('GLOBAL_REACHABILITY_OPEN','Emitted-KeyGen/M0 Reach_call_C -> NumericCenter remains unproved; old CenterClass/floor-equality theorem unchanged.','OPEN_NOT_THIS_LOCAL_THEOREM','All emitted keys and actual histories, including pre-dss/norm-rejected attempts.',
 ['M0_COMPATIBILITY.md','inputs/bootstrap/M0/H3_INTERFACE.md','inputs/bootstrap/H3/REACHABILITY.md'],
 'Uniform emitted/loader/internal LDL/ordered bounds and actual backend error/domain transfer.')
row('SAMPLER_LAW_CONSUMPTION_OPEN','Zero-aware scalar-law comparison must account for endpoints, errors and changed shifted finite support.','OPEN_NOT_A_RANGE_COROLLARY','For -0 y in[-366,365], for +0 y in[-365,366].',
 ['M0_COMPATIBILITY.md','formal/EndpointFacts.lean'],
 'No automatic H3 arithmetic/H1R/FFO/R5T/M7 closure, no new small global loss or abort assigned.')
out=dict(schema='FT1536_H3_ZERO_SCALAR_ERROR_LEDGER_V1',status='H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL',rows=rows,
 errors=dict(E_r='1/1048576',E_res='1/1048576',universal_add_envelope='13*2^-24+2^-1021',E_half='OPEN_WHERE_NEEDED',E_add='OPEN_WHERE_NEEDED'),
 proof_layers=dict(A='kernel',OF='kernel normalized C model',B='universal analytical source proof + kernel integer lemmas',C='mixed kernel/analytical substitution'),
 source_add_error_fully_kernelized=False,H3_range_proved=False,global_reachability_proved=False,sampler_law_proved=False,
 baseline_source_integrated=True,source_changed=False,new_source_patch_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False,security_reduction_proved=False)
with (W/'ERROR_LEDGER.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
md=['# H3_ZERO_SCALAR — ledger lokalnych błędów i konsumpcji','',
 'A/OF mają dowody kernelowe na source-normalized modelach. B ma uniwersalny dowód analityczny po instrukcjach C, wsparty kernelowymi lematami bitowymi; nie udaje pełnego kernelowego fpr_add.','E_r=E_res=1/1048576. NumericCenter zawiera oba zera i subnormals.']
for r in rows:md+=['','## '+r['id']+' — '+r['status'],r['claim'],'**Domena:** '+r['domain'],
 '**Dalsza konsumpcja:** '+(r['remaining_consumption'] or 'Brak dodatkowej otwartej przesłanki tej lokalnej tezy.'),
 '**Dowody:** '+', '.join(e['path'] for e in r['evidence'])]
(W/'ERROR_LEDGER.md').write_text('\n\n'.join(md)+'\n')
(W/'OBLIGATIONS.json').write_text(json.dumps(dict(schema='FT1536_H3_ZERO_SCALAR_OBLIGATIONS_V1',local_status=out['status'],
 obligations=rows,local_A_B_C_open=[],optional_kernelization='Fully kernelize SOURCE_ADD_ERROR/R_DELTA_DOMAIN already proved analytically.',
 global_next_lemma='Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma) -> NumericCenter(mu)',
 H3_range_proved=False,global_reachability_proved=False,sampler_law_proved=False),indent=2)+'\n')
print(json.dumps(dict(rows=len(rows),status=out['status'],E_r='1/1048576',E_res='1/1048576',source_add_error_fully_kernelized=False),indent=2))
