import os, stat, hashlib, json, subprocess
from pathlib import Path
W=Path.cwd()
H=Path('/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon')
DOC=W.parent
G='d641ab1037c2fa1dd4a22c258854d79d67b9b46b'
M='evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256'
records=[]
def safe(p):
    for a in reversed([p,*p.parents]):
        assert not stat.S_ISLNK(a.lstat().st_mode), str(a)
    assert p.is_file(), str(p)
def take(p, rel, expected=None):
    safe(p); b=p.read_bytes(); h=hashlib.sha256(b).hexdigest()
    if expected: assert h==expected, (str(p),h,expected)
    records.append({'path':str(p),'sha256':h,'copy':rel})
    (W/rel).parent.mkdir(parents=True,exist_ok=True); (W/rel).write_bytes(b)
    return b
safe(H/'.git'/'HEAD')
r=subprocess.run(['git','-C',str(H),'show',G+':'+M],capture_output=True,check=True)
assert hashlib.sha256(r.stdout).hexdigest()=='03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589'
(W/'inputs'/'source_hashes.sha256').write_bytes(r.stdout)
files=[]
for line in r.stdout.decode().splitlines():
    h,name=line.split(); name=name.removeprefix('*')
    p=H/'build'/name; safe(p)
    assert hashlib.sha256(p.read_bytes()).hexdigest()==h,(name,'mismatch')
    files.append((h,name))
assert len(files)==17
print('S17 VERIFIED 17/17 before copying or compiling')
for h,name in files: take(H/'build'/name,'reference/'+name,h)
for name, expected in [
 ('FT1536_CODEX_START_2026-09-17.md',None),
 ('FT1536_PROMPT_LV_STATIC_2026-09-17.md',None),
 ('FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md','5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e')]:
    take(DOC/name,'inputs/'+name,expected)
K=H/'evidence/candidates/framework_d641/T2C3-CANONICAL-KEYGEN-001-20260819-a1'
for name,h in [
 ('canonical_public_key.bin','57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f'),
 ('canonical_public_h.txt','ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2'),
 ('KEY_COMMITMENT.json','014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523'),
 ('OUTPUTS.sha256','51107bef5786b102d1b6a2ac8d35926fe7d47eeb9cfd3dd7d647cb679bbc5d15')]: take(K/name,'inputs/key/'+name,h)
take(H/'evidence/candidates/framework_d641/T5-KEY-QUANTIFIER-DECOMPOSITION-001-20260822-a2/inputs/a1/KEYGEN_LAW.md', 'inputs/KEYGEN_LAW.md','6ddab78425cf23a086d60bc63cadd9e534ea713966b764b64fb31177603ae174')
take(H/'paper/tasks/S20-R4-MT-ISIS-FORMULATION-001-20260826-a1/assumption_mtisis.tex','inputs/assumption_mtisis.tex','684335cfbedcd80e46177847344b4ab779050dca2261687dde2c3c739235ee32')
(W/'inputs/provenance.json').write_text(json.dumps({'git_commit':G,'git_manifest_path':M,'git_manifest_sha256':hashlib.sha256(r.stdout).hexdigest(),'files':records},indent=2)+'\n')
(W/'INPUTS.sha256').write_text(''.join(f"{r['sha256']}  {r['path']}\n" for r in records))
print(json.dumps({'source_files':len(files),'input_files':len(records),'all_pins_match':True}))
