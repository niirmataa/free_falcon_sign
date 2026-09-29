"""Separate labelled encoder/framing mutations; production source remains byte-identical."""
import difflib,hashlib,json,shlex
from pathlib import Path
W=Path.cwd();C=W/'checks';V=C/'variants';V.mkdir(exist_ok=True);(W/'bin').mkdir(exist_ok=True)
e=(W/'source/falcon-enc.c').read_text();h=(C/'capacity.c').read_text();start=e.index('static size_t\ncompress_static(');end=e.index('/* see falcon-internal.h */\nsize_t\nfalcon_encode_small',start)
body=e[start:end]
variants={'baseline':(e,'rlen == 40'),'noop':(e+'\n/* M0 no-op */\n','rlen == 40'),
 'terminator':(e[:start]+body.replace('while (ne -- >= 0)','while (ne -- > 0)')+e[end:],'rlen == 40'),
 'j7':(e[:start]+body.replace('j = 8;','j = 7;')+e[end:],'rlen == 40'),
 'framing':(e,'rlen >= 39')}
rows={}
for name,(ec,rule) in variants.items():
    if name in ['terminator','j7']:assert ec!=e
    (V/(name+'_enc.c')).write_text(ec)
    main=h.replace('ENC_SOURCE','"variants/'+name+'_enc.c"').replace('NONCE_RULE',rule)
    (C/(name+'_main.c')).write_text(main)
    diff=''.join(difflib.unified_diff(e.splitlines(True),ec.splitlines(True),fromfile='source/falcon-enc.c',tofile='checks/variants/'+name+'_enc.c'))
    (V/(name+'.patch')).write_text(diff)
    rows[name]=dict(encoder_sha256=hashlib.sha256(ec.encode()).hexdigest(),main_sha256=hashlib.sha256(main.encode()).hexdigest(),nonce_rule=rule)
line=next(x for x in (W/'source/Makefile').read_text().splitlines() if x.startswith('CFLAGS = '));flags=shlex.split(line.split('=',1)[1])
(W/'artifacts/compiler_flags.json').write_text(json.dumps(dict(source_line=line,argv=flags),indent=2)+'\n')
(W/'artifacts/control_binding.json').write_text(json.dumps(dict(source_encoder_sha256=hashlib.sha256(e.encode()).hexdigest(),variants=rows,
    no_KeyGen_or_Sign_execution=True,synthetic_vectors_only=True,framing_prototype_not_integrated=True),indent=2)+'\n')
print(json.dumps(dict(variants=list(variants),flags=flags),indent=2))
