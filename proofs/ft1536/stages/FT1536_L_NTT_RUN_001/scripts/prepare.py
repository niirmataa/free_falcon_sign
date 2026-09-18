import errno,hashlib,json,os,stat
from pathlib import Path
W=Path.cwd();DOC=W.parent;P=DOC/'FT1536_L_RHO_RUN_001'
def data(p):
    assert not any(x in {'.private','private_extraction'} for x in p.parts)
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [p,*p.parents]);assert stat.S_ISREG(p.lstat().st_mode)
    return p.read_bytes()
def sha(p):return hashlib.sha256(data(p)).hexdigest()
pins=[(DOC/'AGENTS.md','e5d9cc7b5120aad39da592f796eef44cc8a1c71bc6c43b311f48362d60fdd038'),
 (DOC/'FT1536_ZADANIE_ASTRA_L_NTT_2026-09-18.md','773591f1f5f9f838c6a0f6dccd56c5bf477234aee75d1009ff4bda8a7e45c4d3'),
 (DOC/'FT1536_PODSUMOWANIE_L_RHO_2026-09-18.md','a1fed7c8e428b4102447822b97c3717775e39c82a9da20291a72a50380857da5'),
 (W/'AGENTS.md','3f3632a6138025b6dcb3d884f5fe0425ba8b8f49e52aac988385b03e609dd83f'),
 (P/'REPORT.md','ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3'),
 (P/'OUTPUTS.sha256','d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687'),
 (P/'CANDIDATE.sha256','2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'),
 (P/'candidate.patch','cb7833fce99eb68e671928b71ea28536acfc5f440babfc7b035196050a2c6060'),
 (P/'formal/Rho.lean','daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8')]
for p,h in pins:assert sha(p)==h,p
denied=[]
for p in [P/'REPORT.md',P/'candidate/falcon-vrfy.c',DOC/'AGENTS.md',DOC/'FT1536_LV_STATIC_RUN_001/REPORT.md',DOC/'FT1536_LV_STATIC_ODBIOR_BLUE_001/DAYBREAK_REVIEW.md']:
    try:fd=os.open(p,os.O_WRONLY|os.O_CLOEXEC)
    except OSError as e:assert e.errno==errno.EROFS;denied.append(str(p))
    else:os.close(fd);raise RuntimeError('original input not protected read-only')
(W/'artifacts/sandbox_probe.txt').write_text('WRITE_IN_W_CONFIRMED\n')
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(W_write=True,originals_EROFS=denied,network='unshared',PID_namespace='unshared',no_original_bytes_written=True),indent=2)+'\n')
for name in ['source','inputs','inputs/context','inputs/public','formal','bin']:(W/name).mkdir()
records=[]
def take(p,rel,h):
    b=data(p);assert hashlib.sha256(b).hexdigest()==h
    with (W/rel).open('xb') as f:f.write(b)
    records.append(dict(path=str(p),sha256=h,copy=rel))
for i,(p,h) in enumerate(pins):take(p,'inputs/context/'+str(i)+'_'+p.name,h)
manifest=data(P/'CANDIDATE.sha256');(W/'inputs/source_hashes.sha256').write_bytes(manifest)
for line in manifest.decode().splitlines():
    h,n=line.split();take(P/'candidate'/n,'source/'+n,h)
assert sha(W/'source/falcon-vrfy.c')=='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
manifest_rows={rel:h for h,rel in (l.split(maxsplit=1) for l in data(P/'OUTPUTS.sha256').decode().splitlines())}
for rel,copy in [('RESULT.json','inputs/L_RHO_RESULT.json'),('artifacts/source_binding.json','inputs/L_RHO_SOURCE_BINDING.json'),
 ('inputs/key/canonical_public_h.txt','inputs/public/h.txt'),('inputs/key/canonical_public_key.bin','inputs/public/pk.bin'),
 ('inputs/witness/witness.json','inputs/public/witness.json')]:take(P/rel,copy,manifest_rows[rel])
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in records))
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n')
print(json.dumps(dict(source_files=17,consumed_inputs=len(records),sandbox='WRITE_ONLY_NEW_W_CONFIRMED',source_sha256=sha(W/'source/falcon-vrfy.c')),indent=2))
