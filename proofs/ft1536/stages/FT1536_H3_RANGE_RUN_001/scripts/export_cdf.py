"""Independent header parser plus C dump binding, generates literal kernel bank checks."""
import hashlib,json,re
from pathlib import Path
W=Path.cwd();src=(W/'source/ft1536-adaptive-cdf-tables.h').read_text()
table=src.split('[FT_ADAPTIVE_CDF_TABLE_LEN][2] = {',1)[1]
words=[(int(a),int(b)) for a,b in re.findall(r'\{\s*(\d+)u,\s*(\d+)u\s*\}',table)]
assert len(words)==5*512 and all(0<=v<2**64 for r in words for v in r)
dump=(W/'artifacts/tables_C.txt').read_text().splitlines();at=0;banks=[];coeff=[]
for i in range(5):
    tag,lev,c=dump[at].split();assert tag=='bank' and int(lev)==i;coeff.append(int(c,16));at+=1
    cw=[tuple(int(x,16) for x in dump[at+j].split()) for j in range(512)];at+=512
    assert cw==words[512*i:512*(i+1)]
    banks.append([a*2**64+b for a,b in cw])
assert at==len(dump)
maxima=[sum(v>0 for v in b) for b in banks];assert maxima==[29,59,118,235,365]
text='import Proposal\nset_option maxRecDepth 8192\nset_option maxHeartbeats 3000000\nnamespace H3Range\n'
for i,b in enumerate(banks):
 text+=f'def bank{i} : List Nat := ['+','.join(map(str,b))+']\n'
 text+=f'theorem bank{i}_size : bank{i}.length=512 := by decide\n'
 text+=f'theorem bank{i}_max : nonzero bank{i}={maxima[i]} := by decide\n'
 text+=f'theorem bank{i}_support (r : Nat) : above r bank{i}≤{maxima[i]} := by have h:=scan_bound r bank{i};rw [bank{i}_max] at h;exact h\n'
 text+=f'#print axioms bank{i}_max\n#print axioms bank{i}_support\n'
text+='def bank (i : Fin 5) : List Nat := if i.val=0 then bank0 else if i.val=1 then bank1 else if i.val=2 then bank2 else if i.val=3 then bank3 else bank4\n'
text+='theorem all_bank_support (i : Fin 5) (r : Nat) : above r (bank i)≤365 := by\n  unfold bank\n  split\n  · have h:=bank0_support r;omega\n  · split\n    · have h:=bank1_support r;omega\n    · split\n      · have h:=bank2_support r;omega\n      · split\n        · have h:=bank3_support r;omega\n        · exact bank4_support r\n'
text+='#check @all_bank_support\n#print axioms all_bank_support\nend H3Range\n'
with (W/'formal/CDF.lean').open('x') as f:f.write(text)
out=dict(source_sha256=hashlib.sha256(src.encode()).hexdigest(),C_dump_sha256=hashlib.sha256((W/'artifacts/tables_C.txt').read_bytes()).hexdigest(),
 bank_length=512,banks=banks,coefficient_bits=coeff,maxima=maxima,all_rows_C_equal=True,formal_sha256=hashlib.sha256(text.encode()).hexdigest())
(W/'artifacts/cdf_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k!='banks'},indent=2))
