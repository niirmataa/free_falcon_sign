import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';old=json.loads((I/'RAW/LEAF_MAP.json').read_text())['entries']
def normal(k,off):
 if k==1:return [off+2,off+3]
 n=2**k;return normal(k-1,off+n)+normal(k-1,off+n+k*2**(k-1))
def sampling(k,off):
 if k==0:return [off]
 n=2**k;return sampling(k-1,off+n+k*2**(k-1))+sampling(k-1,off+n)
positions=[i for b in range(2) for k in range(3) for i in normal(8,1536+b*8448+1536+k*2304)]
visits=[i for b in [1,0] for k in [2,1,0] for i in sampling(8,1536+b*8448+1536+k*2304)]
assert positions==[r['tree_index'] for r in old] and len(positions)==len(set(positions))==1536 and positions==sorted(positions)
assert visits==list(reversed(positions)) and all(0<=i<18432 for i in positions)
assert len(set(range(18432))-set(positions))==16896
rows=[dict(stable_index=i,tree_index=j,sk_index=6144+j,store='div(of(768),sqrt(stable[i]))') for i,j in enumerate(positions)]
consumers=[]
for i,j in enumerate(visits):
 for variant in ['paired_first','stored_second']:consumers.append(dict(call_ordinal=len(consumers),terminal_ordinal=i,tree_index=j,stable_index=1535-i,variant=variant))
out=dict(status='PASS_SOURCE_NORMALIZER_RAW_LEAF_BIJECTION_AND_SAMPLER_MAP',normalizer=rows,sigma_only_consumers=consumers,
 leaf_count=1536,scalar_width_uses=3072,tree_words=18432,basis_preserved_words=6144,internal_preserved_words=16896,
 raw_map_sha256=sha(I/'RAW/LEAF_MAP.json'),actual_source_spans=dict(normalizer=[963,1040],binary_sampler=[1617,1694],cubic_sampler=[1697,1782],top_sampler=[1784,1839]),
 scalar_order='Reverse physical leaf order; per stored leaf paired IW1I*S first, then stored S. Structural map only, not reachability/termination of sampler.',
 memory=dict(sk_words=24576,tmp_words=10752,stable_f=[0,1536],stable_g=[1536,3072],primary=[768,1536],reciprocal=[1536,2304],scratch=[2304,2560],tmp_high_water=3072,
  overlap='Primary overwrites dead f imaginary; reciprocal overwrites dead g prefix; scratch overwrites dead g suffix after root sum; live root input only0..767'),
 whole_sampler_execution_claimed=False)
(W/'artifacts/map_certificate.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:out[k] for k in ['status','leaf_count','scalar_width_uses','tree_words','basis_preserved_words','internal_preserved_words']},indent=2))
