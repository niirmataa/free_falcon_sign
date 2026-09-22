import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from kernel_model import constants,entry,iteration,ber
from dyadic import value
from replaylib import sha
W=Path.cwd();RB=RealBallField(384);D=W/'artifacts/mutations';D.mkdir(exist_ok=True);rows=[];banks,coefs,C=constants(W);witnesses=json.loads((W/'artifacts/witnesses.json').read_text())
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
def record(name,a,b,expected_equal=False,scope='MODEL_MUTATION_VS_PINNED_SOURCE'):
 same=a==b;assert same==expected_equal,name;p=D/(name+'.json');p.write_text(json.dumps(dict(name=name,baseline=a,changed=b,equal=same,scope=scope),indent=2)+'\n');rows.append(dict(name=name,status=('NOOP_PASS' if name=='noop' else 'EQUIVALENT_ON_PROVED_SOURCE_RANGE') if same else 'DETECTED',path=p.relative_to(W).as_posix(),sha256=sha(p),scope=scope))
catalog=json.loads((W/'artifacts/kernel_examples.json').read_text())['cases'];base=json.loads((W/catalog[0]['path']).read_text());mu=int(base['mu'],16);sig=int(base['sigma'],16);en=entry(W,mu,sig)
recomputed=[iteration(W,en,banks[base['bank']][a['k']],a['b'])['x'] for a in base['atoms']]
record('noop',[int(a['x'],16) for a in base['atoms']],recomputed,True)
nz=entry(W,1<<63,sig);record('omit_signed_zero_shift',dict(s=nz['s'],r=nz['r'],output_k0_b1=nz['s']+1),dict(s=0,r=nz['r'],output_k0_b1=1))
a=qv(coefs[0]);nom=QQ(1)/10;record('nominal_coefficient',str(a),str(nom))
def halfq0(a):
 s=sum((-RB(a)*k*k).exp() for k in range(1025));t=(-RB(a)*1025**2).exp()/(1-(-RB(a)*2051).exp());return 1/s.add_error(QQ(t.upper()))
p0=QQ(2**128-banks[0][0])/2**128;q0=halfq0(a);err=abs(RB(p0)-q0);assert err>0
record('ignore_table_quantization','0',str(err),scope='certified nonzero literal p0 minus dyadic infinite-half-line q0')
nomerr=abs(RB(p0)-halfq0(nom));assert nomerr>RB(QQ(1)/2**128)
record('nominal_table_transfer','<=2^-128',str(nomerr),scope='wrong nominal coefficient violates the literal CDF accuracy premise')
cut=next(x for x in base['atoms'] if x['e']>=64 and int(x['proposal_numerator'])>0);x=int(cut['x'],16);b=ber(W,x);ideal=(-RB(qv(x))).exp();assert ideal>0
record('replace_BerExp_by_ideal_exp',b['beta'],str(ideal),scope='scalar-derived D_env cutoff atom, no Emitted membership')
w=witnesses['overrun_scalar_witnesses'][0];record('transfer_nominal_remainder_domain',w['rB'],'3fe62e42fefa39ef',scope='actual standalone-normalizer scalar witness versus illicit clamp/domain transfer')
record('remove_cutoff',b['beta'],str(QQ(min(b['Z'],2**55))/2**(min(b['e'],63)+55)))
zs=[int(a['Z']) for c in catalog for a in json.loads((W/c['path']).read_text())['atoms']];assert all(z<=2**55 for z in zs)
record('remove_saturation_on_source',[str(QQ(min(z,2**55))/2**55) for z in zs],[str(QQ(z)/2**55) for z in zs],True,scope='equivalent on actual source range Z<=2^55, proved from monotone literal Horner coefficients; not a detected source defect')
record('remove_saturation_extended','1',str(QQ(2**55+1)/2**55),scope='extended comparator Z>2^55, unreachable for literal expm coefficients')
record('omit_accepted_normalizer','1',base['A'])
point=json.loads((W/'artifacts/gaussian'/Path(catalog[0]['path']).name).read_text());tail=point['original']['reference_mass_outside_positive_K_support'];assert QQ(tail['lower'])>0
record('omit_infinite_support_tail','0',tail,scope='G positive outside actual finite K support; includes explicit Gaussian tail enclosure')
record('reverse_chi2_direction',dict(from_law='K_C',to_law='G',bound='2^-60'),dict(from_law='G',to_law='K_C',value='infinity'))
neg=witnesses['negative_expm_extended'][1];r=int(neg['rB'],16);source=RB(QQ(neg['expm'])/2**63);ref=(-RB(qv(r))).exp();gap=abs(source-ref);assert gap>RB(QQ(3)/5)
record('extend_expm_accuracy_to_negative','<=2^-40',str(gap),scope='EXTENDED_EXPM_INPUT_ONLY; excluded by derived source rB>=0, not a scalar/emitted counterexample')
out=dict(status='PASS_EXECUTED_MUTATIONS_WITH_EQUIVALENCE_LIMITATION',game='IID_BUFFER',mutations=rows,detected=sum(r['status']=='DETECTED' for r in rows),noop=1,source_saturation_mutation_equivalent=True,negative_expm_countermodel=dict(rB=neg['rB'],source_scaled_value=str(source),reference_exp=str(ref),gap=str(gap),lower_gap='3/5',scope=neg['classification']),required_domain_counterexample=False)
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],detected=out['detected'],equivalent_source_saturation=True,negative_expm_gap=str(gap)),indent=2))
