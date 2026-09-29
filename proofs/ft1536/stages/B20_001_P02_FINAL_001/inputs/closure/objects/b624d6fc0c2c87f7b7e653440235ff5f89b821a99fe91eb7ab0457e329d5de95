"""Pin M0 inputs and copy only required public source objects, not prior cache."""
import errno,hashlib,json,os
from pathlib import Path
W=Path.cwd();A=W.parents[1];P=A/'stages/FT1536_L_V_BRIDGE_RUN_001';R=A/'stages/FT1536_L_RHO_RUN_001';D=A/'documents'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
pins={P/'REPORT.md':'81702fa89ee516f162a37db86e2abb03ae0bb57a49a5723ed63eab5a17a69296',
 P/'OUTPUTS.sha256':'13fa5a9f706a962434c8ac479212af5ef33d91e1ececd6c948d68ed42871a74e',
 P/'CLAIM.md':'e10be7abe58c970bec0a97cb11de9f1c6e3ee021321dffc4111eec86fc342575',
 P/'formal/Norm64.lean':'d25a61941a86864cc9d34400e86d948124529b1e6765b0676c97cf41b4f92d5a',
 P/'formal/VerifyBytes.lean':'6c33ca86d82c72fd8421d7d52ce5e13ee6a0a2b17e767ca0c308d9a72ede28ac',
 P/'source/falcon-vrfy.c':'3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42',
 P/'source/falcon-sign.c':'eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8',
 P/'source/falcon-enc.c':'0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05',
 P/'source/falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
 P/'source/falcon.h':'657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519',
 P/'source/tool.c':'920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890',
 P/'source/Makefile':'25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049',
 R/'CANDIDATE.sha256':'2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a',
 D/'FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md':'b299acc13ec1bd1b2d5d9906fb403bbd9c35e8db1483eb9671247540731266a1',
 D/'FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md':'5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e'}
for p,h in pins.items():assert sha(p)==h,str(p)
probe=[]
for p,allowed in [(W/'AGENTS.md',True),(P/'REPORT.md',False),(W.parents[3]/'AGENTS.md',False)]:
    try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert allowed;value='writable_no_bytes_written'
    except OSError as e:assert not allowed and e.errno==errno.EROFS;value='EROFS'
    probe.append(dict(path=str(p),result=value))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,probes=probe),indent=2)+'\n')
pm={}
for line in (P/'OUTPUTS.sha256').read_text().splitlines():
    h,rel=line.split('  ',1);assert rel not in pm and '..' not in Path(rel).parts and not Path(rel).is_absolute();pm[rel]=h
records=[]
def cp(p,rel,h=None):
    assert p.is_file() and all(not q.is_symlink() for q in [p]+list(p.parents));data=p.read_bytes();digest=hashlib.sha256(data).hexdigest()
    assert h is None or digest==h,(p,h,digest)
    dest=W/rel;dest.parent.mkdir(parents=True,exist_ok=True)
    with dest.open('xb') as f:f.write(data)
    records.append(dict(path=str(p),copy=rel,sha256=digest))
for name in ['REPORT.md','CLAIM.md','RESULT.json','OBLIGATIONS.json','REUSED_RESULTS.md','SOURCE_MODEL_BINDING.md']:
    cp(P/name,'inputs/PREV/'+name,pm[name])
cp(P/'OUTPUTS.sha256','inputs/PREV/OUTPUTS.sha256',pins[P/'OUTPUTS.sha256'])
cp(P/'formal/VerifyBytes.lean','inputs/PREV/VerifyBytes.lean',pins[P/'formal/VerifyBytes.lean'])
cp(R/'CANDIDATE.sha256','inputs/source_hashes.sha256',pins[R/'CANDIDATE.sha256'])
for line in (R/'CANDIDATE.sha256').read_text().splitlines():
    h,name=line.split('  ',1);cp(P/'source'/name,'source/'+name,h)
mods=[];seen=set()
def lean(name):
    if name in seen:return
    rel='formal/'+name.replace('.','/')+'.lean';p=P/rel;assert sha(p)==pm[rel]
    for line in p.read_text().splitlines():
        if line.startswith('import '):
            for dep in line[7:].split():
                if dep!='Std':lean(dep)
    cp(p,rel,pm[rel]);seen.add(name);mods.append(name.replace('.','/'))
lean('Norm64')
(W/'artifacts/inherited_modules.json').write_text(json.dumps(mods,indent=2)+'\n')
for name in ['check_lean.py','archive_attempt.py','replaylib.py','toolchain.py']:cp(P/'scripts'/name,'scripts/'+name,pm['scripts/'+name])
for name in ['FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md','FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md','FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md']:
    cp(D/name,'inputs/context/'+name,pins.get(D/name))
task=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_M0_CONTRACT_2026-09-19.md')
cp(task,'inputs/task.md','a1556c02ab1bb89ce2f1b61d309e946bc15057a7c3c6bb4c173b0d560fe94956')
cp(W/'AGENTS.md','inputs/local_AGENTS.md');cp(W.parents[3]/'AGENTS.md','inputs/repo_AGENTS.md')
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n')
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in records))
print(json.dumps(dict(pins=len(pins),inputs=len(records),inherited_modules=len(mods),source_files=17,models_unchanged=True),indent=2))
