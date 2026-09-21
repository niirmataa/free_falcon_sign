import json
from pathlib import Path
from fractions import Fraction as Q
from kernel_model import constants,entry,iteration,ber,Buffer,schedule
from dyadic import rn
from backend import of
from replaylib import sha
W=Path.cwd();D=W/'artifacts/mutations';D.mkdir(exist_ok=True);rows=[];T,coef,C=constants(W)
def record(name,a,b,noop=False,scope='MODEL_MUTATION_VS_PINNED_SOURCE_WORD_OR_TRACE'):
 a=json.loads(json.dumps(a));b=json.loads(json.dumps(b));assert (a==b)==noop,name
 p=D/(name+'.json');p.write_text(json.dumps(dict(name=name,baseline=a,mutated=b,equal=a==b,scope=scope),indent=2)+'\n');rows.append(dict(name=name,status='NOOP_PASS' if noop else 'DETECTED',path=p.relative_to(W).as_posix(),sha256=sha(p),scope=scope))
U=T[0][0];base=[sum(U<v for v in ts) for ts in T];record('noop_common_CDF',base,[sum(U<t for t in ts) for ts in T],True)
record('non_strict_CDF',base,[sum(U<=t for t in ts) for ts in T])
en=entry(W,0,rn(Q(4,3)));record('last_instead_first_bank',en['bank'],max(i for i,c in enumerate(coef) if en['dss']>=c))
record('independent_words_each_bank',base,[sum((U if j==0 else 0)<t for t in ts) for j,ts in enumerate(T)])
x=of(1);record('reuse_Bernoulli_word',ber(W,x,0,2**55-1)['accepted'],ber(W,x,0,0)['accepted'])
record('omit_saturation',str(Q(min(2**55+1,2**55),2**55)),str(Q(2**55+1,2**55)),scope='EXTENDED_VALID_COMPARATOR_RANGE; no claim this Z is source-reachable')
bc=json.loads((W/'artifacts/ber_cases.json').read_text());c=next(c for c in bc if c['e']>=64 and c['w0']==0 and c['w1']==0 and c['Z']>0);record('omit_cutoff',c['accepted'],1)
record('early_return_BerExp_reads',[8,8],[8],scope='First predicate false or cutoff; actual source still reads second U64')
record('ptr_off_by_one',dict(next=8,discard=9),dict(next=4095,discard=0),scope='actual ptr4087 cutoff versus >4087')
block=bytes((i*29+(i>>4))%256 for i in range(4096));record('big_endian',int.from_bytes(block[:8],'little'),int.from_bytes(block[:8],'big'))
record('omit_suffix_drop',schedule(4087)['discarded'],0)
# Exact finite sample-space countermodels to illicit conditioning/independence rules.
space=[(x,y) for x in range(2) for y in range(2)];unconditional=Q(sum(y==1 for x,y in space),len(space));conditioned=[(x,y) for x,y in space if y==0]
record('condition_on_unread_buffer',str(unconditional),str(Q(sum(y==1 for x,y in conditioned),len(conditioned))),scope='EXACT_TWO_BIT_IID_COUNTERMODEL_TO_BAD_CONDITIONING')
final=(W/'artifacts/fixtures/sampler_finite_stutter.expected').read_text().splitlines()[-1];assert 'HARNESS_EXHAUSTED NONE' in final
record('nonreturn_to_source_zero',final,final.replace('HARNESS_EXHAUSTED NONE','NORMAL_RETURN 0'),scope='bounded observation of all-zero continuation, whose k29/exponent>=64 proves repeated stutter for this local input')
try:Q(0)/Q(0)
except ZeroDivisionError:failure='ZeroDivisionError'
else:raise AssertionError('zero denominator unexpectedly normalized')
record('normalize_without_positive_A','requires proven A>0',failure,scope='ABSTRACT_ZERO_WEIGHT_KERNEL; not required source instance')
out=dict(status='PASS_EXECUTED_MUTATIONS_AND_FINITE_COUNTERMODELS',game='IID_BUFFER',mutations=rows,meaningful_mutations=len(rows)-1,noop=1,source_changed=False,required_domain_counterexample=False)
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],meaningful=out['meaningful_mutations'],noop=1),indent=2))
