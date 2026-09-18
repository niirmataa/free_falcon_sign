"""Deterministic controls and one full candidate on the pinned public h*."""
import ctypes as C
import hashlib
import json
from pathlib import Path
from model import N, Q, B, center, decode, encode, encode_raw, norm, product, four_squares

W = Path.cwd()
OUT = W / "artifacts"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def put(name, value):
    with (OUT/name).open("x") as f:
        json.dump(value, f, indent=2); f.write("\n")


class Oracle:
    def __init__(self, mode, pk):
        record = json.loads((OUT/("build-"+mode+".json")).read_text())
        path = W / record["binary"]
        assert sha(path) == record["binary_sha256"]
        self.lib = C.CDLL(str(path))
        self.u8, self.u16, self.i16 = C.c_uint8, C.c_uint16, C.c_int16
        P8, P16, PI16 = C.POINTER(self.u8), C.POINTER(self.u16), C.POINTER(self.i16)
        for name, args, ret in [
            ("lv_init", [P8,C.c_size_t], C.c_int),
            ("lv_eval", [P16,P8,C.c_size_t], C.c_int),
            ("lv_calls", [], C.c_int),
            ("lv_decode", [P8,C.c_size_t,PI16], C.c_size_t),
            ("lv_raw", [P16,PI16], C.c_int),
            ("lv_short", [PI16,PI16], C.c_int),
            ("lv_trace", [PI16,P16,P16,PI16,C.c_int], None),
        ]:
            fn = getattr(self.lib,name); fn.argtypes=args; fn.restype=ret
        self.observed = mode.startswith("observed")
        if self.observed:
            self.lib.lv_observed.argtypes=[PI16,PI16]
            self.lib.lv_observed.restype=None
            self.lib.lv_observed_reset.argtypes=[]
            self.lib.lv_observed_reset.restype=None
            self.lib.lv_observed_calls.argtypes=[]
            self.lib.lv_observed_calls.restype=C.c_int
        assert self.lib.lv_init((self.u8*len(pk)).from_buffer_copy(pk),len(pk)) == 1

    def trace(self, s, c, full_mod=0):
        stages=(self.u16*(5*N))(); first=(self.i16*N)()
        self.lib.lv_trace((self.i16*N)(*s), (self.u16*N)(*c), stages, first,full_mod)
        return [list(stages[k*N:(k+1)*N]) for k in range(5)],list(first)

    def eval(self, c, payload):
        s=(self.i16*N)(); a=(self.i16*N)(); b=(self.i16*N)()
        data=(self.u8*len(payload)).from_buffer_copy(payload)
        consumed=int(self.lib.lv_decode(data,len(payload),s))
        if self.observed: self.lib.lv_observed_reset()
        v=int(self.lib.lv_eval((self.u16*N)(*c),data,len(payload)))
        calls=int(self.lib.lv_calls())
        r=dict(verify=v,point_calls=calls,decoded_bytes=consumed,
               payload_bytes=len(payload))
        if calls:
            r["s"]=list(s)
            if self.observed:
                assert self.lib.lv_observed_calls()==1
                self.lib.lv_observed(a,b)
                r["actual_norm_first"]=list(a)
                r["actual_norm_second"]=list(b)
                assert list(b)==list(s)
                r["actual_norm"]=norm(list(a))+norm(list(b))
                trace,first=self.trace(list(s),c)
                assert first==list(a), "duplicated trace must equal actual arguments"
                r["stages"]=trace
            r["raw"]=int(self.lib.lv_raw((self.u16*N)(*c),s))
            assert r["raw"]==v
        return r


def main():
    assert C.sizeof(C.c_int)==4 and C.sizeof(C.c_long)==C.sizeof(C.c_size_t)==8
    for line in (W/"inputs/source_hashes.sha256").read_text().splitlines():
        digest,name=line.split(); assert sha(W/"reference"/name)==digest
    pk=(W/"inputs/key/canonical_public_key.bin").read_bytes()
    h=list(map(int,(W/"inputs/key/canonical_public_h.txt").read_text().split()))
    assert len(h)==N and all(0<=x<Q for x in h)
    assert sha(W/"inputs/key/canonical_public_h.txt")=="ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2"
    assert sha(W/"inputs/key/canonical_public_key.bin")=="57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f"
    assert pk[0]==0x8A and len(pk)==2881
    integer=int.from_bytes(pk[1:],"big")
    assert [(integer>>(15*(N-1-i)))&32767 for i in range(N)]==h
    observed=Oracle("observed-shared",pk); base=Oracle("base-shared",pk)
    controls=[]
    zero=[0]*N
    positive=[]
    for pos,value in [(0,0),(0,1),(1535,-1),(768,37)]:
        s=[0]*N; s[pos]=value
        first=[0]*N; first[0]=3; first[768]=-2
        positive.append((f"sparse_{pos}_{value}",s,first))
    positive.append(("dense",[(17*i+3)%5-2 for i in range(N)],
                     [(11*i+1)%7-3 for i in range(N)]))
    for label,s,first in positive:
        hs=product(h,s); c=[(x-y)%Q for x,y in zip(hs,first)]
        for mode in [0,1]:
            payload=encode(s,mode)
            assert decode(payload)==s
            r=observed.eval(c,payload); r2=base.eval(c,payload)
            assert r["verify"]==r2["verify"]==1
            assert r["actual_norm_first"]==first
            assert r["stages"][3]==hs
            assert r["actual_norm"]==norm(first)+norm(s)<B
            controls.append(dict(name=label,mode=mode,verify=1,norm=r["actual_norm"],
                                 payload_sha256=hashlib.sha256(payload).hexdigest()))
    print("POSITIVE_CONTROLS",len(controls),"PASS",flush=True)
    put("positive_controls.json",controls)

    # Norm boundaries through full Verify, not just an unrelated norm domain.
    boundaries=[]
    for target in [B-1,B,B+1]:
        s=[0]*N
        s[:24]=[9216]*24
        squares=four_squares(target-24*9216**2)
        s[24:28]=squares
        assert all(0<=x<=9216 for x in s) and norm(s)==target
        c=product(h,s)
        for mode in [0,1]:
            r=observed.eval(c,encode(s,mode))
            assert r["actual_norm_first"]==zero
            assert r["actual_norm"]==target and r["verify"]==int(target<B)
            boundaries.append(dict(target=target,mode=mode,verify=r["verify"],
                                   s_nonzero=[[i,x] for i,x in enumerate(s) if x]))
    put("norm_boundaries.json",boundaries)
    print("FULL_VERIFY_NORM_BOUNDARIES 6 PASS",flush=True)

    cases=[]
    values=[-9216,9216,-9217,9217,-18433,18433,-20000,-32767,32767,-32768]
    for value in values:
        s=[value]+[0]*(N-1)
        for mode in [0,1]:
            cases.append((f"value_{value}_mode_{mode}",encode(s,mode)))
    for sign,mag in [(0,32768),(1,32768),(0,65535),(1,65535),(1,0),(0,65536)]:
        cases.append((f"raw_sign_{sign}_mag_{mag}",encode_raw([(sign,mag)]+[(0,0)]*(N-1))))
    padded=bytearray(encode([9217]+[0]*(N-1))); padded[-1]|=1
    cases.append(("nonzero_padding",bytes(padded)))
    for header in [0xBA,0xCA,0xEA,0xA9,0x2A]:
        cases.append((f"header_{header:02x}",bytes([header])+encode(zero)[1:]))
    cases += [("extra_zero_byte",encode(zero)+b"\0"),
              ("truncated",encode(zero)[:-1]), ("short_header",b"\xaa\0")]
    decoder_records=[]
    for name,payload in cases:
        try:
            s=decode(payload); valid=True; reason=None
        except ValueError as e:
            s=None; valid=False; reason=str(e)
        r=observed.eval(zero,payload)
        assert (r["point_calls"]==1)==valid,(name,r,reason)
        if valid: assert s==r["s"]
        decoder_records.append(dict(name=name,model_accepts=valid,reason=reason,
                                    C_verify=r["verify"],point_calls=r["point_calls"],
                                    first=s[0] if s is not None else None,
                                    bytes=len(payload)))
    put("decoder_controls.json",decoder_records)
    print("DECODER_CONTROLS",len(decoder_records),"PASS",flush=True)

    # The first candidate is fully evaluated only after the controls above.
    s=[-20000]+[0]*(N-1)
    payload=encode(s,1)
    stages,_=observed.trace(s,zero)
    c=stages[3]
    assert all(0<=x<Q for x in c), "c must be in the lemma domain"
    r=observed.eval(c,payload); r2=base.eval(c,payload)
    hs=product(h,s)
    z1=[center(x-y) for x,y in zip(c,hs)]
    total=norm(z1)+norm(s)
    assert decode(payload)==r["s"]==s
    assert all((x+y-z)%Q==0 for x,y,z in zip(z1,hs,c))
    witness=dict(schema="FT1536_LV_STATIC_WITNESS_V1",N=N,q=Q,B=B,
                 phi="X^1536-X^768+1",h=h,c=c,s=s,z1=z1,
                 payload_hex=payload.hex(),payload_sha256=hashlib.sha256(payload).hexdigest(),
                 payload_bytes=len(payload),public_h_sha256=sha(W/"inputs/key/canonical_public_h.txt"),
                 public_key_sha256=sha(W/"inputs/key/canonical_public_key.bin"),
                 source_verify=r["verify"],base_verify=r2["verify"],source_raw=r["raw"],
                 point_calls=r["point_calls"],decoded_bytes=r["decoded_bytes"],
                 machine_first=r["actual_norm_first"],machine_second=r["actual_norm_second"],
                 machine_norm=r["actual_norm"],ext_norm=total,ext_first_norm=norm(z1),
                 second_norm=norm(s),correct_hs=hs,
                 stage_names=["preNTT","NTT","productNTT","inverseNTT","subtract"],
                 stages=r["stages"],
                 constructed_c="source inverseNTT product; explicit target, no HashToPoint preimage claimed")
    put("candidate.json",witness)
    print(json.dumps({k:witness[k] for k in ["source_verify","base_verify","machine_norm","ext_norm","payload_bytes","payload_sha256"]}),flush=True)
    assert r["verify"]==r2["verify"]==1 and r["actual_norm"]<B and total>=B, "not a full counterexample"
    assert r["actual_norm_first"]==zero
    with (OUT/"witness.bin").open("xb") as f:f.write(payload)
    with (OUT/"witness_c.txt").open("x") as f:f.write("".join(str(x)+"\n" for x in c))
    put("witness.json",witness)
    print("FULL_CANDIDATE_REQUIRED_PUBLIC_KEY: independent confirmation still required")


if __name__=="__main__": main()
