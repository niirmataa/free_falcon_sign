import difflib,json
from pathlib import Path
from replaylib import sha
W=Path.cwd();lines=(W/'source/falcon-sign.c').read_text().splitlines(True);rows=[]
slices={'context':(1321,1331),'helpers':(2606,2651),'cutoff':(2449,2454),'cdf':(2732,2781),'proposal_original':(2790,2829),'ber_original':(2468,2513),'sampler_original':(2840,2972),'entry':(2864,2866),'iteration':(2921,2944)}
for name,(a,b) in slices.items():
 p=W/'checks'/(name+'.inc');p.write_text(''.join(lines[a-1:b]));rows.append(dict(source='source/falcon-sign.c',first=a,last=b,copy=p.relative_to(W).as_posix(),sha256=sha(p),exact_bytes=True))
for name in ['proposal','ber','sampler']:
 p=W/'checks'/(name+'_original.inc');text=p.read_text();obs=text
 for old,new in [('ft_adaptive_proposal','observed_proposal'),('sampler_large','observed_sampler'),('BerExp','observed_BerExp'),('falcon_prng_get_u64','observed_u64'),('falcon_prng_get_u8','observed_u8')]:obs=obs.replace(old+'(',new+'(')
 if name=='ber':obs=obs.replace('\treturn b;', '\tprintf("BE %016" PRIx64 " %d %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %u %u %d\\n", x,s,r,fpr_expm_scaled(r),z,safe_s,over,b);\n\treturn b;')
 if name=='sampler':
  obs=obs.replace('\tdss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));', '\tdss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));\n\tprintf("ENTRY %d %016" PRIx64 " %016" PRIx64 "\\n",s,r,dss);')
  obs=obs.replace('\t\tif (observed_BerExp(p, x)) {','\t\tprintf("IT %d %d %u %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\\n",k,b,proposal_level,delta,gap,x);\n\t\tif (observed_BerExp(p, x)) {')
 dst=W/'checks'/(name+'_observer.inc');dst.write_text(obs);(W/'artifacts/diffs'/(name+'_observer.patch')).write_text(''.join(difflib.unified_diff(text.splitlines(True),obs.splitlines(True),fromfile=p.name,tofile=dst.name)))
out=dict(status='PASS_LITERAL_SCALAR_SLICES',source_sha256=sha(W/'source/falcon-sign.c'),header_sha256=sha(W/'source/fpr-emulated.h'),getters_header_sha256=sha(W/'source/internal.h'),slices=rows,refill_replacement='TEST public finite blocks, no actual PRNG/seed/init call',original_and_observer_compared=True,full_sign_or_do_sign_called=False,source_changed=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS_SOURCE_BINDING',len(rows))
