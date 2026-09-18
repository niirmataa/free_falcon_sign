"""Validate cross-artifact bindings and, optionally, original read-only inputs."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import stat

parser=argparse.ArgumentParser()
parser.add_argument("--originals",action="store_true")
parser.add_argument("--out",default="artifacts/verification.json")
args=parser.parse_args()
W=Path.cwd()


def read(p):
    assert not any(s in {".private","private_extraction"} for s in p.parts)
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [p,*p.parents]),p
    assert stat.S_ISREG(p.lstat().st_mode),p
    return p.read_bytes()


def sha(p):return hashlib.sha256(read(p)).hexdigest()
def load(name):return json.loads(read(W/name))


mf=read(W/"inputs/source_hashes.sha256")
assert hashlib.sha256(mf).hexdigest()=="03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589"
source={}
for line in mf.decode().splitlines():
    digest,name=line.split();assert sha(W/"reference"/name)==digest;source[name]=digest
assert len(source)==17
w=load("artifacts/witness.json"); wh=sha(W/"artifacts/witness.json")
assert wh=="2b9ea42771316eaef3cc394462b51f6a4df4e5b6e08630c5eaab0ca052da603b"
assert sha(W/"artifacts/witness.bin")==w["payload_sha256"]
assert read(W/"artifacts/witness.bin")==bytes.fromhex(w["payload_hex"])
assert list(map(int,read(W/"artifacts/witness_c.txt").split()))==w["c"]
assert [8670*x%18433 for x in w["h"]]==w["c"]
assert [(10237*x+9216)%18433-9216 for x in w["h"]]==w["z1"]
assert w["s"]==[-20000]+[0]*1535
assert w["source_verify"]==w["base_verify"]==w["source_raw"]==1
assert w["machine_norm"]==400000000<2093922385<=w["ext_norm"]==43058711057

support=load("inputs/key/KEY_COMMITMENT.json")
assert support["bindings"]["public_encoded_sha256"]==sha(W/"inputs/key/canonical_public_key.bin")==w["public_key_sha256"]
assert support["bindings"]["source_manifest_sha256"]==hashlib.sha256(mf).hexdigest()
assert sha(W/"inputs/key/canonical_public_h.txt")==w["public_h_sha256"]
assert list(map(int,read(W/"inputs/key/canonical_public_h.txt").split()))==w["h"]
attempt=load("inputs/resume_001/KEYGEN_ATTEMPT.json")
assert attempt["keygen_exit_code"]==0 and attempt["status"]=="KEYGEN_GENERATED_AND_VALIDATED"
assert sha(W/"inputs/resume_001/KEYGEN_ATTEMPT.json")=="e357d32d0aa91e6b80af2a83674965fbad776699c6c6f999fa71376ec52a7370"

for mode in ["base-shared","observed-shared","base-normal","base-sanitize"]:
    b=load("artifacts/build-"+mode+".json")
    assert b["exit_code"]==0 and sha(W/b["binary"])==b["binary_sha256"]
    for path,digest in b["sources"].items():assert sha(W/path)==digest
for mode in ["normal","sanitize"]:
    r=load("artifacts/c-replay-"+mode+".json")
    assert r["exit_code"]==0 and r["stderr"]=="" and r["witness_sha256"]==wh
    result=json.loads(r["stdout"])
    assert result["verify"]==result["raw"]==result["loader"]==result["point_calls"]==1
    assert result["machine_norm"]==400000000
sage=load("artifacts/sage_check.json")
assert sage["witness_sha256"]==wh and sage["exact_congruence"]
assert sage["ext_norm"]==43058711057 and not sage["Ext0_short"]
assert sage["source_product_equals_GF_product_of_preNTT_words"] is True
mut=load("artifacts/mutations.json")
assert mut["executed"]==mut["rejected"]==11 and mut["survivors"]==0
assert all(r["baseline"]!=r["mutant"] and r["rejected"] for r in mut["cases"])

text=read(W/"formal/WitnessBlocks.lean").decode()
binding=load("artifacts/lean_blocks_binding.json")
assert binding["witness_sha256"]==wh and binding["lean_sha256"]==sha(W/"formal/WitnessBlocks.lean")
blocks=re.findall(r"def block_(\d+) : List \(Int × Int\) := \[([^\n]*)\]",text)
assert [int(i) for i,_ in blocks]==list(range(12))
pairs=[]
for k,body in blocks:
    part=[(int(a),int(b)) for a,b in re.findall(r"\((-?\d+), (-?\d+)\)",body)]
    assert len(part)==64;pairs.extend(part)
assert pairs==list(zip(w["z1"][:768],w["z1"][768:]))
assert hashlib.sha256(json.dumps(pairs,separators=(",",":")).encode()).hexdigest()==binding["ordered_pairs_sha256"]
assert "p.1*p.1 + p.1*p.2 + p.2*p.2" in text
assert " ++ ".join("block_"+str(i) for i in range(12)) in text
assert not re.search(r"\b(sorry|admit|axiom|unsafe|native_decide)\b",text)
names=re.findall(r"^theorem (\w+)",text,re.M)
assert len(names)==26
commands=[json.loads(line) for line in read(W/"COMMANDS.log").splitlines()]
receipt=next(r for r in reversed(commands) if r.get("argv",[])[-1:]==["formal/WitnessBlocks.lean"] and r.get("exit_code")==0)
stdout=read(W/receipt["stdout"]).decode()
assert read(W/receipt["stderr"])==b""
for name in names:assert "'"+name+"' " in stdout
axioms=set()
for listed in re.findall(r"depends on axioms: \[([^]]*)\]",stdout):
    axioms.update(x.strip() for x in listed.split(",") if x.strip())
assert axioms <= {"propext"}
for r in commands:
    if r.get("stream_sha256"):
        for stream,digest in r["stream_sha256"].items():assert sha(W/r[stream])==digest

original_count=0; inherited_count=0
if args.originals:
    for manifest in ["INPUTS.sha256","resume_001/EXTRA_INPUTS.sha256"]:
        for line in read(W/manifest).decode().splitlines():
            digest,path=line.split(maxsplit=1);assert sha(Path(path))==digest,path;original_count+=1
    for row in load("inputs/provenance.json")["files"]:
        assert sha(W/row["copy"])==row["sha256"]
    inherited=load("resume_001/INHERITED_STATE.json")
    current=read(W/"COMMANDS.log")
    old=read(W/"resume_001/snapshot/COMMANDS.log")
    assert current.startswith(old)
    assert hashlib.sha256(b"".join(current.splitlines(keepends=True)[:5])).hexdigest()=="7fd844fb21a9a549632d3bc307293948e11d4f3f6049dd26d6aa10b7c3591fc7"
    for row in inherited["inherited_files"]:
        if row["path"]=="COMMANDS.log":continue
        assert sha(W/row["path"])==row["sha256"],row["path"]
        inherited_count+=1

result=dict(status="BINDINGS_VERIFIED",witness_sha256=wh,reference_files=17,
            original_inputs_checked=original_count,inherited_files_unchanged=inherited_count,
            formal_file="formal/WitnessBlocks.lean",formal_sha256=binding["lean_sha256"],
            literal_A2_pairs_checked=768,theorems_checked=26,axioms=sorted(axioms),
            lean_receipt=receipt["stdout"],
            mathematical_result="COUNTEREXAMPLE_REQUIRED_DOMAIN",
            C_semantics_formalized=False)
with (W/args.out).open("x") as f:json.dump(result,f,indent=2);f.write("\n")
print(json.dumps(result,indent=2))
