#!/usr/bin/env python3
"""Source-span/provenance ledgers. Strings below specify obligations, not proofs."""
from pathlib import Path
import hashlib
import json

W=Path(__file__).resolve().parents[1]
REPO=W.parents[3]
IN=W/'inputs/bootstrap'
SRC=IN/'T03/inputs/bootstrap/source'

def sha(p):
    with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()

def write(name,data):
    (W/name).write_text(json.dumps(data,indent=2,sort_keys=True)+'\n')

spans={
 'challenge':('falcon-sign.c',1874,1886),
 'targets':('falcon-sign.c',1887,1892),
 'terminal':('falcon-sign.c',1633,1650),
 'binary':('falcon-sign.c',1660,1693),
 'cubic':('falcon-sign.c',1717,1780),
 'root':('falcon-sign.c',1802,1838),
 'copies_suffix':('falcon-sign.c',1902,1912),
 'ifft':('falcon-sign.c',1914,1915),
 'rint_call':('falcon-sign.c',1931,1932),
 'complex_multiply':('falcon-fft.c',77,93),
 'complex_operands':('falcon-fft.c',1041,1057),
 'scale':('falcon-fft.c',1120,1128),
 'rint':('fpr-emulated.h',98,115),
 'half':('fpr-emulated.h',167,176),
}
bindings={}
for name,(file,first,last) in spans.items():
    p=SRC/file
    raw=b''.join(p.read_bytes().splitlines(keepends=True)[first-1:last])
    bindings[name]={'path':str(p.relative_to(W)),'sha256':sha(p),'lines':[first,last],
                    'slice_sha256':hashlib.sha256(raw).hexdigest(),
                    'kind':'byte/line binding, not a kernel parser/refinement theorem'}
write('artifacts/SOURCE_SPANS.json',bindings)

p02=REPO/'proofs/ft1536/work/B20_001/P02/output/formal/B20/Fpr/Domain.lean'
extra=W/'inputs/dependency_types'
extra.mkdir(exist_ok=True)
copy=extra/'P02_Domain.lean'
assert not copy.exists()
copy.write_bytes(p02.read_bytes());copy.chmod(0o444)
write('inputs/dependency_types/ORIGIN.json',{'origin':str(p02),'sha256':sha(copy),
      'scope':'unreviewed P02 missing-type evidence; not imported into Lean'})
(extra/'ORIGIN.json').chmod(0o444)

status=json.loads((W/'inputs/supplemental/B20_STATUS.json').read_text())
deps=[]
def dep(id,needed,producer,evidence,blocks):
    deps.append({'id':id,'needed_type':needed,'producer':producer,'evidence':[
       {'path':p,'sha256':sha(W/p)} for p in evidence], 'accepted_export_pin':None,
       'local_proof':None,'status':'OPEN_NOT_ASSUMED','blocks':blocks})
dep('P02_ARITH',
    'For every reached add/sub/mul/div/sqrt at pinned operands: defined literal C execution, finite result word w, and a proved real-value error inequality on its explicit finite/signed-zero/subnormal domain. P02 PrimObligation fn args res alone requires a callee implementation and execution; no instances for add/mul/div/sqrt and no real-error bridge are supplied.',
    'P02', ['inputs/dependency_types/P02_Domain.lean','inputs/supplemental/P02/output/NEXT_INTERFACE.md'],['B0_source','B1','B2','B3','B4','B5'])
dep('P02_REACHED_DOMAIN',
    'forall required H and every actual read before an instruction, OperandSnapshot(H,pc) satisfies the exact callee domain, pointer/frame/nonalias premises, finite and range predicates; raw signed zeros and subnormals retained.',
    'P02/P09', ['inputs/supplemental/P02/output/REPORT.md'],['B0_source','B1','B2','B3','B4','B5'])
dep('P06_REFERENCE',
    'B20.Reference.Z : OrderedReturns3072 -> RingPair, source_call_index_binding, exact_shadow_cancellation, integral_and_congruent for R=ZZ[X]/(X^1536-X^768+1), all required histories and the same ordered Y.',
    'P06',['inputs/bootstrap/planning/P06/INPUT_CONTRACT.json','inputs/supplemental/B20_STATUS.json'],['B0_source','B2','B4','B5'])
dep('INTEGER_DEFECT_TRANSPORT',
    'forall H, x_C=t0-Z0(Y)+kappa0+tau0 and y_C=t1-Z1(Y)+kappa1+tau1, where tau transports actual terminal old-target defects (including add_C1643), kappa includes all remaining downward split/update and upward merge/sub defects; prove joint bounds relative to THIS reference. H6P innovation reconstruction bounds do not instantiate this type.',
    'new local obligation/P08/P09',['inputs/bootstrap/T03/inputs/bootstrap/H6P/SOURCE_NOISE_MAP.md','inputs/bootstrap/T03/inputs/bootstrap/LEFT/ERROR_LEDGER.md'],['B0_bounds','B3','B4','B5'])
dep('P07_BASIS',
    'Uniform source-order stored FFT basis residuals for every emitted/same-STATIC normalized key, bound as complex modulus or correctly converted component errors, with immutable raw words, normalization and exact coefficient membership.',
    'P07',['inputs/bootstrap/planning/P07/INPUT_CONTRACT.json'],['B2','B5'])
dep('A2_INVERSE_AND_IFFT',
    'Kernel physical inverse evaluation map I with linearity, coefficient/A2 inequalities, exact evaluation inverse on Phi, and source iFFT_C1914/1915 error for the ACTUAL frequency inputs.',
    'P06/P10',['inputs/bootstrap/T03/inputs/bootstrap/POST/POSTPROCESSING_MAP.md'],['B0_coefficient','B1','B5'])
dep('P02_REAL_RINT',
    'forall reached finite word w and integer z, abs(val(w)-z)<1/2 -> literal int64 fpr_rint_C(w)=z, with proved execution/range and nearest-even +/-ties, signed-zero/subnormal valuation bridge.',
    'P02/P10',['inputs/supplemental/P02/output/NEXT_INTERFACE.md'],['B5'])
write('EXPORT_DEPENDENCIES.json',{'schema':'T03_RUN002_EXPORT_DEPENDENCIES_V1',
      'checked_status':{k:status['tasks'][k] for k in ['P02','V02','P06']},
      'P02_local_freeze_manifest_sha256':'4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01',
      'P02_local_freeze_reviewed':False,'dependencies':deps,
      'consumed_P02_or_P06_theorems':[],'owner_accepted':False})

spec=[
 ('A1','(Cw-C,0)',['challenge'],'TARGETS','B0/B5'),
 ('A2','(lambda*(det(Bw)-q),0)',['targets'],'ROOT+TARGETS','B2/B5'),
 ('A3','rho*Bw',['targets','scale','complex_multiply'],'TARGETS','B1/B5'),
 ('A4','-t*DeltaB',['targets'],'ROOT+TARGETS','B2/B5'),
 ('B','(t-Z(Y))*DeltaB',['root','binary','cubic','terminal'],'P06+P07','B2/B5'),
 ('C1','kappa*B',['root','binary','cubic'],'P08: integer-defect bridge OPEN','B3/B5'),
 ('C2','tau*B',['terminal'],'P09: old-target terminal transport OPEN','B4/B5'),
 ('C3','(kappa+tau)*DeltaB',['root','terminal'],'P07+P08+P09','B5'),
 ('D','F_C - (x_C,y_C)*Bw',['copies_suffix','complex_multiply','complex_operands'],'P02+POST','B1/B5'),
 ('E','val(pre_rint_C)-I(F_C)',['ifft'],'POST','B5')]
items=[]
for id,expr,refs,producer,consumer in spec:
    items.append({'id':id,'expression':expr,'source_bindings':{n:bindings[n] for n in refs},
      'frame':'real coefficient after I' if id=='E' else 'complex physical root; apply exact I for coefficient',
      'unit':'one coefficient of either1536-vector after the stated transport',
      'actual_operand_domain':'required emitted/same-STATIC normalized key; canonical c; completed positive-source-support H; finite literal read-time words, no future norm conditioning',
      'producer':producer,'consumer':consumer,'source_kernel_status':'OPEN',
      'algebra_proof':'formal/Ledger.lean: ledger_first/ledger_second (E outside I; use e=0 then add E)',
      'historical_numeric_bound_reused_as_new_source_bound':False})
write('LEDGER_TERM_BINDINGS.json',{'schema':'T03_RUN002_TEN_TERM_BINDINGS_V1','terms':items,
      'definitions':{'Bw':'[[w00,w01],[w10,w11]], signs already included',
       'B':'[[g,-f],[G,-F]] exact coefficient basis evaluated at a physical root',
       'DeltaB':'Bw-B','lambda':'Cw/q','t':'(lambda*w11,-lambda*w01)+rho',
       'Z':'same ordered3072 returns, independent reference placement (source kernel binding OPEN)',
       'kappa':'(x_C,y_C)-t+Z-tau; source transport/bound OPEN',
       'tau':'intended exact transport of terminal old-target defects; source bridge OPEN'},
      'arithmetic_sum_only_excluded':['A_total_refined','A_coarse_pinned_route','C1_formula_crosscheck','C1_alt_independent_boxes','C_failed_convolution_route','TOTAL_gap_bound'],
      'revision_note':'B is shadow-residual times DeltaB, permitting exact A4+B=-Z*DeltaB. This is a NEW exact algebraic ledger; old prose labels/numeric caps are not automatically transferred.',
      'complete_source_decomposition_proved':False})

rows=[]
for root in [W/'inputs']:
    for p in sorted(root.rglob('*')):
        assert not p.is_symlink(),p
        if p.is_file():rows.append(sha(p)+'  '+p.relative_to(W).as_posix()+'\n')
(W/'INPUTS.sha256').write_text(''.join(rows))
print('SOURCE_SPANS_AND_OPEN_DEPENDENCIES_RECORDED',len(items),'terms;',len(deps),'missing interfaces')
