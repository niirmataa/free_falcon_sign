"""Pin and copy only selected public inputs; recursively select Complete's Lean sources."""
import errno,hashlib,json,os,re
from pathlib import Path
W=Path.cwd();A=W.parents[1];P=A/'stages/FT1536_L_NTT_FORWARD_RUN_001';R=A/'stages/FT1536_L_RHO_RUN_001';O=A/'stages/FT1536_LV_STATIC_RUN_001'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
pins={P/'REPORT.md':'ff172360348004527b7ef2a68c3f70967463619f039145d856f1969d69b866eb',
 P/'OUTPUTS.sha256':'32147f114b448a1e1c2659b45ed3e69bfac02c44164ac380001df39c98fb498e',
 P/'CLAIM.md':'1c678a241df99c4127228e4149bef1c6a40d994d42fcbe54e8fdfc40c342e59e',
 P/'formal/Complete.lean':'67b8fd4c52dfe47cd8ed91a87ff8d1e66fdf6cad0811a881ce643ba8849e2fc4',
 P/'formal/Product.lean':'28d37d8cf99d2a09dbd18af3e0be3c5f7b99d4b40ea764d68e29a957176e4906',
 P/'formal/Rho.lean':'3fc6f1106bde82d3c5657da11e2c2a781486163491adf5617e6d39db43f15fd2',
 P/'SOURCE_MODEL_BINDING.md':'2365680a7cf0a7c9efd3d0b116b39571bc98408fd20bca9815cd4e6704202535',
 P/'source/falcon-vrfy.c':'3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42',
 P/'source/falcon-enc.c':'0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05',
 P/'source/internal.h':'512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5',
 R/'CANDIDATE.sha256':'2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a',
 R/'REPORT.md':'ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3',
 R/'OUTPUTS.sha256':'d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687',
 O/'REPORT.md':'c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd',
 O/'OUTPUTS.sha256':'0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87'}
for p,h in pins.items():assert sha(p)==h,str(p)
probe=[]
for p,writable in [(W/'AGENTS.md',True),(P/'REPORT.md',False),(W.parents[3]/'AGENTS.md',False)]:
    try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert writable;value='writable_no_bytes_written'
    except OSError as e:assert not writable and e.errno==errno.EROFS;value='EROFS'
    probe.append(dict(path=str(p),result=value))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,probe=probe),indent=2)+'\n')
def manifest(base):
    d={}
    for row in (base/'OUTPUTS.sha256').read_text().splitlines():
        h,p=row.split('  ',1);assert p not in d and not Path(p).is_absolute() and '..' not in Path(p).parts;d[p]=h
    return d
pm,rm,om=manifest(P),manifest(R),manifest(O);records=[]
def cp(p,rel,h=None):
    assert p.is_file() and all(not q.is_symlink() for q in [p]+list(p.parents));data=p.read_bytes();digest=hashlib.sha256(data).hexdigest()
    assert h is None or h==digest,(p,h,digest)
    dst=W/rel;dst.parent.mkdir(parents=True,exist_ok=True)
    with dst.open('xb') as f:f.write(data)
    records.append(dict(path=str(p),copy=rel,sha256=digest))
for tag,base,man in [('PREV',P,pm),('RHO',R,rm),('OLD',O,om)]:
    for name in ['REPORT.md','RESULT.json','OUTPUTS.sha256']:
        cp(base/name,'inputs/'+tag+'/'+name,pins.get(base/name,man.get(name)))
for name in ['CLAIM.md','OBLIGATIONS.json','REUSED_RESULTS.md','INVARIANTS.md','SOURCE_MODEL_BINDING.md']:
    cp(P/name,'inputs/PREV/'+name,pm[name])
cp(P/'inputs/PREV/SOURCE_MODEL_BINDING.md','inputs/PREV/NTT_SOURCE_MODEL_BINDING.md',pm['inputs/PREV/SOURCE_MODEL_BINDING.md'])
cp(R/'CANDIDATE.sha256','inputs/source_hashes.sha256',pins[R/'CANDIDATE.sha256'])
for line in (R/'CANDIDATE.sha256').read_text().splitlines():
    h,name=line.split('  ',1);cp(P/'source'/name,'source/'+name,h)
mods=[];seen=set()
def lean(name):
    if name in seen:return
    rel='formal/'+name.replace('.','/')+'.lean';assert rel in pm,rel
    p=P/rel;assert sha(p)==pm[rel]
    for line in p.read_text().splitlines():
        if line.startswith('import '):
            for dep in line[7:].split():
                if dep!='Std':lean(dep)
    cp(p,rel,pm[rel]);seen.add(name);mods.append(name.replace('.','/'))
lean('Complete')
(W/'artifacts/inherited_modules.json').write_text(json.dumps(mods,indent=2)+'\n')
for name in ['check_lean.py','archive_attempt.py','replaylib.py','toolchain.py']:
    cp(P/'scripts'/name,'scripts/'+name,pm['scripts/'+name])
for rel in ['artifacts/decoder_controls.json','artifacts/norm_boundaries.json','artifacts/witness.bin','artifacts/witness_c.txt','artifacts/witness.json',
            'inputs/key/canonical_public_h.txt','inputs/key/canonical_public_key.bin','inputs/key/KEY_COMMITMENT.json','inputs/key/OUTPUTS.sha256']:
    cp(O/rel,'inputs/OLD/'+rel,om[rel])
for rel in sorted(rm):
    if rel.startswith('fixtures/'):
        cp(R/rel,'inputs/RHO/'+rel,rm[rel])
for name in ['FT1536_PROMPT_LV_STATIC_2026-09-17.md','FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md','FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md']:
    cp(A/'documents'/name,'inputs/context/'+name)
task=Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_V_BRIDGE_2026-09-19.md')
cp(task,'inputs/task.md','571aaab4ca8d1255bcb649b9e28fb5c3de60e98e9c30d4bb1fdef5a1a9bf4b65')
cp(W/'AGENTS.md','inputs/local_AGENTS.md');cp(W.parents[3]/'AGENTS.md','inputs/repo_AGENTS.md')
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n')
(W/'INPUTS.sha256').write_text(''.join(x['sha256']+'  '+x['path']+'\n' for x in records))
print(json.dumps(dict(pins_verified=len(pins),inputs=len(records),inherited_modules=len(mods),source_files=17,no_models_changed=True),indent=2))
