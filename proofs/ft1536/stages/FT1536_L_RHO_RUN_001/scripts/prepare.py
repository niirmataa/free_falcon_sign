import errno, hashlib, json, os, stat, subprocess
from pathlib import Path
W=Path.cwd(); DOC=W.parent; R=DOC/"FT1536_LV_STATIC_RUN_001"; D=DOC/"FT1536_LV_STATIC_ODBIOR_BLUE_001"
H=Path("/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon")
def read(p):
    assert not any(s in {".private","private_extraction"} for s in p.parts)
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [p,*p.parents])
    assert stat.S_ISREG(p.lstat().st_mode);return p.read_bytes()
def sha(p):return hashlib.sha256(read(p)).hexdigest()
pins=[(DOC/"AGENTS.md","e5d9cc7b5120aad39da592f796eef44cc8a1c71bc6c43b311f48362d60fdd038"),
 (DOC/"FT1536_PRZEKAZANIE_ASTRA_PO_BLUE_2026-09-18.md","a47fc84b0b366e4cbc12e01adc5ad08fa5de8164a46c25a463aec4a7b54c3643"),
 (DOC/"FT1536_ZADANIE_ASTRA_L_RHO_2026-09-18.md","a88b1eff755e813f3b072d0bcf17c5fee19fb5e4eb5fe0a67e57f7bfb32c3341"),
 (W/"AGENTS.md","b88f6b83a70b749d9c47272e9ee10f299c2fb7135df4d1adbbcbad1309b64958"),
 (R/"REPORT.md","c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd"),
 (R/"OUTPUTS.sha256","0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87"),
 (D/"DAYBREAK_REVIEW.md","d9f9559ffe29b84504a7ff58da88b419b0070b24fc101665bc49459605ef24cc"),
 (D/"DAYBREAK_RESULT.json","fb28cfd25053a109414b620c4f89d22820e05c68b1845f215ac0852545b09aab"),
 (D/"OUTPUTS.sha256","281d10aa5071b13a05c6178380909f55743da33469330a6d7463dd5517424771"),
 (D/"inputs/source_hashes.sha256","03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589")]
for p,h in pins:assert sha(p)==h,p
# Non-destructive capability test: O_WRONLY without O_TRUNC, never write.
denied=[]
for p in [R/"REPORT.md",D/"DAYBREAK_REVIEW.md",H/"build/falcon-vrfy.c",DOC/"AGENTS.md"]:
    try:fd=os.open(p,os.O_WRONLY|os.O_CLOEXEC)
    except OSError as e:assert e.errno==errno.EROFS,(p,e);denied.append(str(p))
    else:os.close(fd);raise RuntimeError("sandbox did not make original input read-only")
(W/"artifacts/sandbox_write_probe.txt").write_text("W_WRITE_CONFIRMED\n")
(W/"artifacts/sandbox.json").write_text(json.dumps({"W_write":True,"originals_O_WRONLY_denied_EROFS":denied,"network":"unshared","note":"no bytes written to originals"},indent=2)+"\n")
manifest=read(D/"inputs/source_hashes.sha256")
g=subprocess.check_output(["git","show","d641ab1037c2fa1dd4a22c258854d79d67b9b46b:evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256"],cwd=H)
assert g==manifest
for name in ["reference","candidate","inputs","inputs/context","inputs/key","inputs/witness","formal","bin"]:(W/name).mkdir()
records=[]
def copy(p,rel,expected):
    data=read(p);assert hashlib.sha256(data).hexdigest()==expected
    with (W/rel).open("xb") as f:f.write(data)
    records.append({"path":str(p),"sha256":expected,"copy":rel})
for i,(p,h) in enumerate(pins):copy(p,"inputs/context/"+str(i)+"_"+p.name,h)
(W/"inputs/source_hashes.sha256").write_bytes(manifest)
for line in manifest.decode().splitlines():
    h,n=line.split();assert sha(H/"build"/n)==h
    copy(R/"reference"/n,"reference/"+n,h)
    with (W/"candidate"/n).open("xb") as f:f.write(read(W/"reference"/n))
rm={rel:h for h,rel in (l.split(maxsplit=1) for l in read(R/"OUTPUTS.sha256").decode().splitlines())}
for rel,target in [("inputs/key/canonical_public_key.bin","inputs/key/canonical_public_key.bin"),
 ("inputs/key/canonical_public_h.txt","inputs/key/canonical_public_h.txt"),
 ("inputs/key/KEY_COMMITMENT.json","inputs/key/KEY_COMMITMENT.json"),
 ("inputs/resume_001/KEYGEN_ATTEMPT.json","inputs/key/KEYGEN_ATTEMPT.json"),
 ("artifacts/witness.bin","inputs/witness/witness.bin"),("artifacts/witness_c.txt","inputs/witness/witness_c.txt"),
 ("artifacts/witness.json","inputs/witness/witness.json")]:copy(R/rel,target,rm[rel])
(W/"INPUTS.sha256").write_text("".join(r["sha256"]+"  "+r["path"]+"\n" for r in records))
(W/"inputs/provenance.json").write_text(json.dumps(records,indent=2)+"\n")
print(json.dumps({"pins":len(pins),"reference_sources":17,"copied_inputs":len(records),"sandbox":"WRITE_ONLY_W_CONFIRMED"}))
