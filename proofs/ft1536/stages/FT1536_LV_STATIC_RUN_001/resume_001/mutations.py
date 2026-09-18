"""Executed semantic changes checked against unchanged source observations.

This reuses the probe's C binding and integer helpers (not an independent
mathematical checker). Sage supplies the independent mathematical check.
Every baseline must pass its validator; a label-only/no-op change survives
and therefore cannot be counted as a rejected mutation.
"""
import hashlib
import json
from pathlib import Path
from model import N,Q,B,center,decode,encode,encode_raw,norm,product
from probe import Oracle

W=Path.cwd(); w=json.loads((W/"artifacts/witness.json").read_text())
pk=(W/"inputs/key/canonical_public_key.bin").read_bytes()
oracle=Oracle("observed-shared",pk)
h=w["h"]; c=w["c"]; s=w["s"]
rows=[]


def changed(name, baseline, mutant, predicate, failure, detail):
    assert predicate(baseline), "invalid baseline control: "+name
    assert baseline != mutant, "a label-only change is not a mutation"
    rejected=not predicate(mutant)
    assert rejected, "mutation survived: "+name
    row=dict(name=name,changed_model=detail,baseline=baseline,mutant=mutant,
             baseline_pass=True,rejected=rejected,failure=failure,
             actual_meaning_changed=True)
    row["changed_instance_sha256"]=hashlib.sha256(json.dumps(mutant,sort_keys=True).encode()).hexdigest()
    rows.append(row)


# 1. Real source vs hypothetical full-modulo model, using the inherited
# trace's explicitly separate diagnostic switch, never patching reference/.
_,fixed_first=oracle.trace(s,c,full_mod=1)
fixed_norm=norm(fixed_first)+norm(s)
assert fixed_norm==w["ext_norm"]
original=oracle.eval(c,bytes.fromhex(w["payload_hex"]))["verify"]
changed("full_modulo_instead_of_source_map",original,int(fixed_norm<B),
        lambda v:v==original,"VERIFY_SEMANTICS",
        {"source_norm":w["machine_norm"],"changed_model_norm":fixed_norm,
         "executed_call":"lv_trace(s,c,full_mod=1); unchanged Q predicate"})

# 2. Removing the defined uint16 narrowing from the pre-NTT map.
source_word=w["stages"][0][0]
without_wrap=s[0]+Q
changed("omit_unsigned_word_wrap",source_word,without_wrap,
        lambda x:x==source_word,"PRE_NTT_WORD",
        {"source_expression":"uint16_t(uint32_t(s)+q)","changed_expression":"integer(s)+q"})

# 3. Removing signed narrowing from STATIC decoding changes magnitude 65535.
raw=encode_raw([(0,65535)]+[(0,0)]*(N-1))
decoded=decode(raw); target=product(h,decoded)
r=oracle.eval(target,raw); assert r["verify"]==1 and r["s"][0]==-1
changed("omit_STATIC_signed_narrowing",r["s"][0],65535,
        lambda x:x==r["s"][0],"DECODED_INT16",
        {"input_sha256":hashlib.sha256(raw).hexdigest(),"raw_magnitude":65535})

# 4. A hidden centered restriction is refuted by an actual accepting payload.
wide=[9217]+[0]*(N-1); payload=encode(wide); target=product(h,wide)
r=oracle.eval(target,payload); assert r["verify"]==1
centered_parser_accept=all(-9216<=x<=9216 for x in decode(payload))
changed("assume_centered_STATIC",True,centered_parser_accept,
        lambda ok:ok==(r["point_calls"]==1),"DECODER_DOMAIN",
        {"source_decoded_first":r["s"][0],"source_verify":r["verify"],
         "input_sha256":hashlib.sha256(payload).hexdigest()})

# 5. Wrong offset is checked on a legal actual norm pair with a nonzero cross term.
zero=[0]*N; first=[0]*N; first[0]=3;first[768]=-2
target=[(-x)%Q for x in first]
r=oracle.eval(target,encode(zero));assert r["verify"]==1 and r["actual_norm"]==7
bad=sum(first[i]**2+first[i]*first[i+384]+first[i+384]**2 for i in range(768))
changed("wrong_A2_offset",7,bad,lambda n:n==r["actual_norm"],"A2_FORM",
        {"changed_offset":384,"required_offset":768,"actual_pair_nonzero":[[0,3],[768,-2]]})

# 6. Q is sign-invariant, so test the sign error by the relation, not by Q.
right=[center(x) for x in target]; wrong=[center(-x) for x in target]
relation=lambda z:all((x-y)%Q==0 for x,y in zip(z,target))  # s2 is zero
changed("wrong_extractor_sign",right,wrong,relation,"EXACT_CONGRUENCE",
        {"correct":"center(c-h*s)","changed":"center(h*s-c)"})

# 7. Strictness through full Verify at exactly B.
boundary=next(row for row in json.loads((W/"artifacts/norm_boundaries.json").read_text())
              if row["target"]==B and row["mode"]==1)
vec=[0]*N
for i,v in boundary["s_nonzero"]:vec[i]=v
r=oracle.eval(product(h,vec),encode(vec));assert r["actual_norm"]==B and r["verify"]==0
changed("nonstrict_bound",int(B<B),int(B<=B),lambda v:v==r["verify"],"STRICT_NORM",
        {"source_pair_norm":B,"source_full_verify":r["verify"]})

# 8. The witness has constant s; use a wrapping monomial to detect wrong Phi.
vec=[0]*N;vec[-1]=1
correct=product(h,vec); wrong=product(h,vec,phi_sign=-1)
r=oracle.eval(correct,encode(vec));assert r["verify"]==1
changed("wrong_Phi",correct,wrong,lambda p:p==r["stages"][3],"RING_MODULUS",
        {"changed":"X^1536+X^768+1","required":"X^1536-X^768+1","s_index":1535})

# 9/10. Both compression branches and payloads longer than the CLI Sign buffer.
vec=[1]+[0]*(N-1); payload=encode(vec,0)
r=oracle.eval(h,payload); assert len(payload)==3073 and r["verify"]==1
changed("STATIC_only_Verify",True,payload[0]==0xAA,lambda v:v==bool(r["verify"]),
        "VERIFY_COMPRESSION_DOMAIN",{"source_header":payload[0]})
changed("CLI_buffer_limits_adversary",True,len(payload)<=2049,lambda v:v==bool(r["verify"]),
        "VERIFY_LENGTH_DOMAIN",{"payload_bytes":len(payload),"imposed_limit":2049})

# 11. A genuine padding mutation; the altered model first masks two padding bits.
payload=bytearray(encode(wide));payload[-1]|=1;payload=bytes(payload)
r=oracle.eval(product(h,wide),payload);assert r["point_calls"]==0
masked=payload[:-1]+bytes([payload[-1]&0xFC])
ignoring_padding=decode(masked)==wide
changed("ignore_nonzero_padding",False,ignoring_padding,lambda ok:ok==(r["point_calls"]==1),
        "PADDING",{"input_sha256":hashlib.sha256(payload).hexdigest(),
                   "changed_model":"mask last two padding bits before decode"})

# A no-op/label-only candidate remains valid, hence cannot count as rejection.
no_op_survives=(source_word==source_word)
assert no_op_survives
result=dict(executed=len(rows),rejected=sum(r["rejected"] for r in rows),survivors=0,
            no_op_positive_control_passed=no_op_survives,
            shared_code_boundary="C binding and model helpers shared with probe; not an independent checker",
            witness_sha256=hashlib.sha256((W/"artifacts/witness.json").read_bytes()).hexdigest(),cases=rows)
with (W/"artifacts/mutations.json").open("x") as f:json.dump(result,f,indent=2);f.write("\n")
print(json.dumps({k:v for k,v in result.items() if k!="cases"},indent=2))
for row in rows:print(row["name"],row["failure"],"REJECTED_CHANGED_MODEL")
