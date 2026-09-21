"""Generate reversible observation-only and explicitly labelled mutant copies."""
import difflib,hashlib,json
from pathlib import Path
W=Path.cwd();V=W/'checks/variants';V.mkdir(exist_ok=True)
v=(W/'source/falcon-vrfy.c').read_text();e=(W/'source/falcon-enc.c').read_text();h=(W/'checks/harness.c').read_text()
anchor='\t\t\treturn s < bound;';assert e.count(anchor)==1
obs=e.replace(anchor,'\t\t\t/* LV_OBSERVER */ obs_capture(s,bound,s1,s2);\n'+anchor)
assert ''.join(x for x in obs.splitlines(True) if '/* LV_OBSERVER */' not in x)==e
variants={'plain':(v,e),'observer':(v,obs),'noop':(v+'\n/* LV_NOOP */\n',obs),
 'center':(v.replace('q & -(((q >> 1) - (uint32_t)w) >> 31)','q & -((((q >> 1) - 1U) - (uint32_t)w) >> 31)'),obs),
 'offset':(v,obs.replace('s1[u + hn]','s1[u + hn - 1]')),
 'cross':(v,obs.replace('s += (int32_t)s1[u] * (int32_t)s1[u + hn];','s -= (int32_t)s1[u] * (int32_t)s1[u + hn];')),
 'bound':(v,obs.replace('return s < bound;','return s <= bound;')),
 'narrow':(v,obs.replace('x[u] = -(int16_t)lo;','x[u] = -(int16_t)(lo > 32767 ? 32767 : lo);').replace('x[u] = (int16_t)lo;','x[u] = (int16_t)(lo > 32767 ? 32767 : lo);'))}
rows={}
for name,(vc,ec) in variants.items():
    if name not in ['plain','observer','noop']:assert (vc,ec)!=(v,obs)
    vr=V/(name+'_vrfy.c');en=V/(name+'_enc.c');vr.write_text(vc);en.write_text(ec)
    line=next(x.strip() for x in vc.splitlines() if 'w -= (int32_t)(q &' in x)
    main=h.replace('VRFY_SOURCE','"variants/'+name+'_vrfy.c"').replace('ENC_SOURCE','"variants/'+name+'_enc.c"').replace('CENTER_STATEMENT',line)
    (W/'checks'/(name+'_main.c')).write_text(main)
    patch=''.join(difflib.unified_diff(v.splitlines(True),vc.splitlines(True),fromfile='source/falcon-vrfy.c',tofile=vr.relative_to(W).as_posix()))
    patch+=''.join(difflib.unified_diff(e.splitlines(True),ec.splitlines(True),fromfile='source/falcon-enc.c',tofile=en.relative_to(W).as_posix()))
    (V/(name+'.patch')).write_text(patch)
    rows[name]=dict(vrfy_sha256=hashlib.sha256(vc.encode()).hexdigest(),enc_sha256=hashlib.sha256(ec.encode()).hexdigest(),
       main_sha256=hashlib.sha256(main.encode()).hexdigest())
(W/'artifacts/native_binding.json').write_text(json.dumps(dict(variants=rows,observer_removal_restores_enc=True,
    explicit_c_hook='harness macro falcon_hash_to_point -> explicit_point; common domain specialization in plain and observer',
    plain='No norm or center observer; real falcon_vrfy_verify, decoder, loader and raw decisions still execute.',
    center_helper='Exact selected source w-= statement copied into isolated scalar harness.',
    sanitizer='Separate ASan/UBSan jobs need unlimited virtual address space for shadow reservation; CPU/wall limits remain finite.'),indent=2)+'\n')
print(json.dumps(dict(variants=list(variants),observer_reversible=True),indent=2))
