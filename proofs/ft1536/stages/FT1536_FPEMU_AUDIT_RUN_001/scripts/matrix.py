"""Pinned, machine-readable inventory of contracts, evidence and consumers."""
import hashlib
import json
from common import W, S, B, sha, dump

arith=json.loads((W/'artifacts/normal_arithmetic.json').read_text())
calls=json.loads((W/'artifacts/active_calls.json').read_text())
rows=[]
def row(name,file,lo,hi,domain,semantics,proof,ops,consumers,open_item,timing='STATIC_REVIEW_ONLY'):
    p=S/file;lines=p.read_bytes().splitlines(keepends=True)
    names=name.split('/')
    cs=[dict(file=f,line=r['line'],function=r['function']) for f,rr in calls.items() for r in rr
        if r['function'] in names]
    rows.append(dict(primitive=name,source=dict(path='source/'+file,first_line=lo,last_line=hi,
        sha256=sha(p),span_sha256=hashlib.sha256(b''.join(lines[lo-1:hi])).hexdigest()),
        domain=domain,semantics=semantics,proof=proof,active_preprocessed_calls=cs,
        consumers=consumers,tests={op:arith['operation_counts'].get(op,0) for op in ops},
        sanitizer='same public corpus; ASan+UBSan PASS' if ops else 'no new dynamic test for this row',
        timing=timing,open_obligations=open_item))

z='ZERO: NumericCenter = finite and -2147483283 <= val(x) < 2147483282'
root='ROOT: finite |x|,|y| <= 2^100; U=2^-48, eta=2^-900'
row('FPR','fpr-emulated.h',39,55,'s=0/1; m=0 or 2^54<=m<2^55; int exponent arithmetic in range; no overflow exponent',
    'RN ties-even via 0xC8; e<-1076 flush; no general IEEE overflow/subnormal pack',
    ['ZERO/BitErrors.round_error','ZERO/PackOf.pack_normal_value: base<=1054; 2^52<=q<=2^53',
     'ROOT/ANALYTIC_PROOF.md:47-51 extends base bound analytically'],['pack'],
    'scaled/add/mul/div/sqrt, hence ZERO/ROOT/NODE3','General source-to-compiler refinement is not kernelized.')
row('FPR_NORM64','fpr-emulated.c',14,54,'0<=m<2^64; e adjustments must fit int',
    'six fixed masked shifts, m normalized to [2^63,2^64), or zero; zero subtracts63',
    ['ZERO/BitErrors.normalizer_bounds','ZERO/BitErrors.normalizer_for_add: 0<T<2^57'],['norm'],
    'scaled/add; ZERO.OF_EXACT and SOURCE_ADD_ERROR','Proof on Nat transducer plus explicit C mask binding.')
for name,lo,hi,op in [('fpr_ursh',18,23,'ursh'),('fpr_irsh',25,30,'irsh'),('fpr_ulsh',32,37,'ulsh')]:
    row(name,'fpr-emulated.h',lo,hi,'n=0..63; uint64/signed64; GCC arithmetic signed right shift',
        'mathematical shift; left shift modulo2^64; high/low32 decomposition',
        ['ZERO/SOURCE_MODEL_BINDING.md:19-39; no standalone universal C theorem'],[op],
        'add/rint/floor/trunc', 'n outside0..63 is not a supported shift contract.')
row('fpr_scaled','fpr-emulated.c',150,204,'i!=INT64_MIN; bounded sc and output exponent; OF_EXACT covers only signed32/sc0',
    'normalize integer, sticky shrink and FPR; zero -> +0',
    ['ZERO/PackOf.OF_EXACT restricted to signed32 and sc0'],['scaled'],
    'KeyGen poly_big_to_fp (zint_get_top), binary iFFT; fpr_of',
    'INT64_MIN absolute-value overflows at line171; no call made. Unbounded sc can overflow int. Wider KeyGen caller proof open.')
row('fpr_of','fpr-emulated.h',86,90,'signed32 exact theorem; signed64 excluding INT64_MIN sampled',
    'fpr_scaled(i,0); round integers too wide for53 bits',
    ['ZERO/PackOf.OF_EXACT: -2^31<=i<=2^31-1'],['of'],
    'FFT/KeyGen/Sign and ZERO/ROOT/NODE3', 'Do not replace the source domain by all int64 including INT64_MIN.')
row('fpr_add','fpr-emulated.c',448,554,root+'; ZERO exponent fields<=1054',
    'signed-magnitude swap, sticky alignment, add/sub unsigned mantissas, normalize/pack; exponent0 decoded at half subnormal value',
    ['ZERO/ANALYTIC_PROOF.md:29-135 SOURCE_ADD_ERROR <2^-20',
     'ZERO/BitErrors sticky/normalizer/round lemmas','ROOT/ANALYTIC_PROOF.md:29-52 U*(|x|+|y|)+eta'],['add'],
    'FFT, KeyGen, Sign; ZERO residuals, ROOT Gram/LDL, NODE3 split/LDL',
    'Universal composition is analytic, not full Lean C theorem; no counterexample to those envelopes found.')
row('fpr_sub','fpr-emulated.h',151,156,z+'; '+root,
    'sign flip second word, then actual add; signed zeros retained',
    ['ZERO/LiteralAdd.SUB_CENTER_CONTRACT, SUB_RESIDUAL_CONTRACT, R_DELTA_DOMAIN are definitions',
     'ZERO/LiteralAdd.CONSUME_SUB_RESIDUAL takes analytic_contract',
     'ZERO/ANALYTIC_PROOF.md:149-222 discharges error/domain analytically'],['sub'],
    'MACHINE_RESIDUAL_366, MACHINE_CENTER_INTERVAL, ORDERED_ZERO_TERMINAL; ROOT/NODE3',
    'NumericCenter reachability for the next source call remains open.')
row('fpr_neg','fpr-emulated.h',158,163,'all64-bit words; value negation on finite words',
    'XOR sign, including both zeros',[],['neg'],'FFT conjugation and all LDLs','No standalone full C proof; trivial exact bit action checked.')
row('fpr_mul/fpr_sqr','fpr-emulated.c',680,774,root,
    'exact53x53 limb25 product then sticky/pack; exponent0 operand -> signed zero; sqr wrapper h183-187',
    ['ROOT/ANALYTIC_PROOF.md:54-72 U*|xy|+eta; limb bounds',
     'ROOT/RootModel.mulC is executable normalized model, not theorem of total RN'],['mul','sqr'],
    'ROOT/Node3 certificates; Sign dss/residual/acceptance; KeyGen FFT/Babai',
    'Gradual underflow is absent but eta accounts for it under cap2^100. Outside caps no such envelope.')
row('fpr_div','fpr-emulated.c',915,1000,'finite |x|<=2^100; ROOT y positive [1/2,2^23]; NODE3 y positive [1/16,2^35]',
    '55 restoring steps, sticky/pack; exponent0 numerator -> +0 even -0; nonzero denominator assumed',
    ['ROOT/RootDiv.loop55 assumes 2^52<=u,v<2^53; invariant/remainder, not full numeric div theorem',
     'ROOT/ANALYTIC_PROOF.md:74-95','NODE3/ANALYTIC_PROOF.md:29-63',
     'NODE3/NodeInverse.expanded_div_exponent: ex1..1123,ey1019..1058,w0/1'],['div'],
    'Root direct component divisions; LDL_dim3; open NODE2 divisions; sampler dss',
    'Each new caller must prove its denominator domain before consumption.')
row('fpr_inv/fpr_inverse_of','fpr-emulated.h',86,96,'nonzero normal divisor in claimed envelope; inverse_of integer conversion must be legal',
    'div(1,x) / div(1,of(i)); fpr_inv definition h189-193',
    ['NODE3/NodeInverse.inverse3_bits','NODE3/NodeInverse.inverse3_units'],['inv','inverse_of'],
    'FFT3 scale1/3 and inverse FFT1/(N/2), Sign dss',
    'kappa=0x3fd5555555555555 = 1/3-1/(3*2^54), never ideal1/3.')
row('fpr_sqrt','fpr-emulated.c',1182,1257,'normal x>=0 or zero; subnormal inputs are flushed; negatives/NaN excluded',
    '54 fixed restoring-square-root steps, then sticky and pack; zero -> +0',
    ['H3/REPORT.md:122-125 endpoint diagnostics only; no universal sqrt proof in supplied projection'],['sqrt'],
    'KeyGen bounds and leaf normalization; Sign ffLDL widths',
    '4,316 exact sqrt RN comparisons are finite; general source sqrt proof and all caller domains open.')
row('fpr_half','fpr-emulated.h',165,174,'exact halving for encoded exponent>=2 and finite; zeros canonicalized; exponent1 edge differs',
    'subtract exponent bit; minnormal ->0 (known), other exponent1 can produce subnormal with incorrect value',
    ['H3/REPORT.md:62-73 known edge','ZERO/ANALYTIC_PROOF.md:217-220 leaves E_half open'],['half'],
    'FFT3 inner split, terminal r0+half(r1), KeyGen/Sign leaf checks; NODE2/lower tree',
    'Prove local normal/zero or suitable absolute error bound; ROOT/NODE3 do not prove the whole half domain.')
row('fpr_double','fpr-emulated.h',176,181,'exact for normal encoded exponent1..2045, and zeros; arbitrary subnormal/overflow outside',
    'increment exponent for nonzero encoded exponent',
    ['ROOT/ANALYTIC_PROOF.md:71-72; NODE3/ANALYTIC_PROOF.md:34-35 only FPC_SQR unit-twiddle use'],['double'],
    'FPC_SQR and KeyGen norm; inactive log_emu',
    'Small-twiddle proof cannot be silently used as universal doubling proof.')
row('fpr_floor','fpr-emulated.h',117,133,z+'; wider integer-result domain sampled |x|<2^63',
    'source floor=math floor-eps0; floor(-0)=-1; GCC -O inserts exponent<1022 branch',
    ['ZERO/SourceFloor.FLOOR_ZERO','ZERO/SourceFloor.C_INT_BRIDGE (z=-365..366)',
     'H3/Floor.floor_refinement excludes negative zero'],['floor'],
    'sampler_large:2864 and BerExp:2481; H3 range/zero-aware interface',
    'Arithmetic theorem does not certify constant trace or reachability.', 'TIMING_EVIDENCE: operand-dependent branch in original Sign TU')
for name,lo,hi,op in [('fpr_rint',98,115,'rint'),('fpr_trunc',135,149,'trunc')]:
    row(name,'fpr-emulated.h',lo,hi,'finite |x|<2^63 with representable integer result',
        'nearest-even integer' if op=='rint' else 'truncate toward zero',
        ['No general universal theorem supplied; ZERO floor proof is not a rint/trunc theorem'],[op],
        'rint: KeyGen Babai and Sign pre-cast; trunc: fpr_expm_scaled',
        'Prove caller conversion ranges and source refinement for open Sign-law/Babai consumers.')
row('fpr_lt/fpr_max','fpr-emulated.h',195,212,'finite numeric compare except mixed signed-zero pair; max value remains correct on both zeros',
    'signed-word ordering corrected when both signs negative; lt(-0,+0)=1 contradicts internal.h:281-282',
    ['No supplied numeric compare theorem covering mixed zeros'],['lt','max'],
    'Gate00 compares with +1/2; adaptive selector compares positive dss with positive coefficients; fpr_max has no active source caller',
    'F01: narrow/correct generic contract; actual active comparisons never compare two zeros. No ZERO/ROOT/NODE3 lemma overturned.')
row('fpr_mul_high_u64','fpr-emulated.h',251,268,'all uint64 pairs',
    'floor(x*y/2^64), 32-bit limb decomposition',
    ['H3 Comparator proves different unsigned comparators; not this multiply',
     'Referenced exponential proof not present in bootstrap'],['high'],
    'fpr_expm_scaled -> BerExp -> H3_LIKELIHOOD source instantiation',
    '20,480 independent big-integer products; no new whole-domain kernel proof.')
row('fpr_expm_scaled','fpr-emulated.h',230,282,'0<=r<=binary64(log2); caller reduction domain required',
    'fixed13-coefficient high-word recurrence; output approximates exp(-r)*2^63 with ccs1',
    ['Header references rational whole-domain proof; proof/receipt not supplied in this projection'],['expm'],
    'BerExp:2507; H3_LIKELIHOOD/H4_DSS/source acceptance-law',
    'F06: obtain exact version-bound whole-domain certificate, including reduction and trunc/high multiplication. RBF257 sampled max error<3562 integer units.')
row('fpr_exp_small','fpr-emulated.h',214,229,'|x|<=binary64(log2); generic internal.h precision>=50bits',
    'rational polynomial exp approximation',[],['exp_small'],
    'No preprocessed active source caller',
    '514 RBF points meet relative2^-50; no universal theorem; inactive in FT1536.')
row('fpr_log_emu','fpr-emulated.h',284,327,'positive normal x; special Gaussian use x=(a+1)/2^32',
    '32-term odd reciprocal polynomial with exponent decomposition',[],['log'],
    'fpr_gauss only; TRUE_TERNARY_SECRET=1 removes active call',
    '257 RBF diagnostics, no active-profile mathematical dependency.')
row('fpr_sin_poly/fpr_cos_poly/fpr_sincos_tick','fpr-emulated.h',288,400,
    'sincos b uint32; reduced |t|<=pi/4; direct polynomials need same domain',
    'fixed Horner polynomials, quadrant switch',[],['sincos'],
    'fpr_gauss only, inactive in active profile',
    '257 RBF trig diagnostics; switch depends on b, irrelevant to current active-profile CT claim.')
row('fpr_gauss','fpr-emulated.h',402,412,'public uint32 a,b; finite sigma with safe output scale',
    'Box-Muller-like pair from log/sqrt/sincos',[],[],
    'falcon-keygen.c:7895-7929 compiled out by TRUE_TERNARY_SECRET=1',
    'No new direct gauss test or universal theorem; not an active key-law assumption.')
row('FFT_tables_and_constants','fpr-emulated.h',63,4525,'FFT3 indices derived from public sizes logn<=10 and valid layout',
    'raw binary64 constants; tables h418-4523',
    ['ROOT/ANALYTIC_PROOF.md:97-135; NODE3/ANALYTIC_PROOF.md:65-115'],[],
    'FFT3/LDL root and all descendants; 8192 stored words match exact decimal RN; 1022 used-range pairs independently checked with RBF256',
    'Remaining full FFT/layout/composition proof remains historical; table-value check is not whole FFT proof.')
row('adaptive_CDF_constants','ft1536-adaptive-cdf-tables.h',15,2605,'5 positive binary64 coefficients,512 entries per bank',
    'coefficients {1/10,1/40,1/160,1/640,1/1536} rounded once; thresholds are integers',
    ['H3/REPORT.md:75-81 and formal Proposal/CDF exact support (29,59,118,235,365)'],[],
    'ft_adaptive_proposal:2813-2821; H3 integer support',
    'No new universal probability-table proof or full CDF rerun; supplied H3 support proof rebuilt.')
row('inactive_ARM','fpr-emulated.c',56,1178,'FALCON_ASM_CORTEXM4=1 only; actual=0',
    'Separate assembly alternatives for all5 external primitives',[],[],
    'No active caller in LP64 build','Not compiled, not executed, no result transferred from portable C.')
row('reference_fpr_double','fpr-double.h',32,258,'inactive FPR_IMPL reference',
    'Host-double reference only; not the arithmetic oracle',[],[],
    'Only decimal table provenance used in this audit','No host-double based proof claim.')

dump('AUDIT_MATRIX.json',dict(schema='FT1536_FPEMU_AUDIT_MATRIX_V1',source_manifest_sha256=sha(B/'CANDIDATE.sha256'),
    rows=rows,common_timing_note='No statistical timing campaign; see TIMING_REVIEW.md. Pure-core static observations are not universal CT proofs.',
    historical_coverage={'ZERO':'reported1160 in-domain controls,70 exclusions','ROOT':'reported334 scalar raw mul/div controls',
                         'NODE3':'reported176 expanded-div pairs and all256 slots of2 branches','active_smoke':'12 only'},
    evidence_receipts=['artifacts/normal_arithmetic.json','artifacts/asan_arithmetic.json','artifacts/formal_rebuild.json',
                       'artifacts/rigorous.json','artifacts/active_calls.json','artifacts/production_asm.json']))
md=['# Macierz audytu FPEMU','',
    'Pełne source/call-site piny, listy testów i przesłanki są w `AUDIT_MATRIX.json`. Ścieżki źródeł i dowodów poniżej są względem `inputs/bootstrap`. Liczby testów dotyczą obu zgodnych trybów normal/ASan+UBSan, nie dowodu uniwersalnego.','',
    '| Prymityw | Source span | Dziedzina i semantyka | Dowód i konsumenci | Nowe kontrole | Otwarte obowiązki |',
    '|---|---|---|---|---|---|']
for r in rows:
    s=r['source']
    cells=[r['primitive'],f"{s['path']}:{s['first_line']}-{s['last_line']}",r['domain']+'; '+r['semantics'],
           '; '.join(r['proof'])+'; '+r['consumers'],', '.join(f'{k}={v}' for k,v in r['tests'].items()) or 'kontrola statyczna / patrz JSON',r['open_obligations']]
    md.append('| '+' | '.join(c.replace('|','\\|').replace('\n',' ') for c in cells)+' |')
(W/'AUDIT_MATRIX.md').write_text('\n'.join(md)+'\n')
print('PASS: audit matrix',len(rows),'rows; exact source/span hashes and active call sites')
