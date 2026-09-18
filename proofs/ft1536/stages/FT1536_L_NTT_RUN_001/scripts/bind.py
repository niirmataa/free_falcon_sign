import difflib,hashlib,json,re
from pathlib import Path
W=Path.cwd();p=W/'source/falcon-vrfy.c';raw=p.read_bytes();text=raw.decode()
assert hashlib.sha256(raw).hexdigest()=='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
for row in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,n=row.split();assert hashlib.sha256((W/'source'/n).read_bytes()).hexdigest()==h
spans={'constants':(59,68),'add':(582,597),'sub':(602,614),'half':(619,624),'mont':(631,662),
       'square':(667,671),'division':(743,803),'rev10':(805,817),'generator':(823,885),
       'forward':(979,1062),'inverse':(1067,1159),'dispatch_and_poly':(1161,1243)}
lines=text.splitlines(True);d=W/'inputs/slices';d.mkdir()
records=[]
for name,(lo,hi) in spans.items():
    b=''.join(lines[lo-1:hi]).encode();path=d/(name+'.c.txt');path.write_bytes(b)
    records.append(dict(name=name,lines=[lo,hi],path=str(path.relative_to(W)),sha256=hashlib.sha256(b).hexdigest()))
# The observer exports only the 1024 initialized entries used by this path.
inject='''/* TEST OBSERVER: tables from the real logn=10 generator, no replacement. */
static uint16_t ntto_gm[1024], ntto_igm[1024];
static unsigned ntto_calls, ntto_same = 1;
static void ntto_mkgm3(uint16_t *gm, uint16_t *igm, unsigned logn)
{
    size_t u;
    if (logn != 10) abort();
    mq_mkgm3(gm, igm, logn);
    if (ntto_calls != 0) {
        for (u = 0; u < 1024; u++)
            if (gm[u] != ntto_gm[u] || igm[u] != ntto_igm[u]) ntto_same = 0;
    }
    memcpy(ntto_gm, gm, sizeof ntto_gm);
    memcpy(ntto_igm, igm, sizeof ntto_igm);
    ntto_calls++;
}
#define mq_mkgm3 ntto_mkgm3

'''
anchor='/*\n * Compute NTT on a ring element, binary case.'
assert text.count(anchor)==1
od=W/'observed';od.mkdir();obs=text.replace(anchor,inject+anchor,1);assert obs.replace(inject,'',1)==text
(od/'falcon-vrfy.c').write_text(obs)
(od/'observation.patch').write_text(''.join(difflib.unified_diff(text.splitlines(True),obs.splitlines(True),fromfile='source/falcon-vrfy.c',tofile='observed/falcon-vrfy.c')))
mutations={}
mutations['wrong_R2']=text.replace('#define R2t     4564','#define R2t     4565',1)
needle='f[u] = (uint16_t)mq_montymul(f[u], R2t, Qt, Q0It);';assert text.count(needle)==1
mutations['missing_tomonty']=text.replace(needle,'f[u] = (uint16_t)mq_montymul(f[u], Rt, Qt, Q0It);',1)
assert text.count('x = mq_montymul(x, g4, Qt, Q0It);')==1
mutations['generator_step']=text.replace('x = mq_montymul(x, g4, Qt, Q0It);','x = mq_montymul(x, g2, Qt, Q0It);',1).replace('ix = mq_montymul(ix, ig4, Qt, Q0It);','ix = mq_montymul(ix, ig2, Qt, Q0It);',1)
needle='ni = logn <= 9 ? INVNQt[logn] : mq_div_18433(Rt, (uint32_t)n);';assert text.count(needle)==1
mutations['missing_inverse_scale']=text.replace(needle,'ni = logn <= 9 ? INVNQt[logn] : Rt;',1)
mutations['noop']=text+'\n/* Test no-op: no semantic changes. */\n'
hashes={}
for name,value in mutations.items():
    assert value!=text;path=W/'mutants'/name;path.mkdir(parents=True);(path/'falcon-vrfy.c').write_text(value)
    hashes[name]=hashlib.sha256(value.encode()).hexdigest()
out=dict(source_sha256=hashlib.sha256(raw).hexdigest(),slices=records,logn=10,uses_dynamic_tables=True,
         source_unchanged=True,observer_injection=inject,observer_sha256=hashlib.sha256(obs.encode()).hexdigest(),
         exported_table_indices=[0,1023],not_exported=[1024,2047],mutants=hashes)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['observer_injection','slices']},indent=2))
