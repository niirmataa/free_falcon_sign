"""Pinned-region instruction/taint inventory, including all original Sign floor sites."""
import json,re
from pathlib import Path
from replaylib import sha
W=Path.cwd();A=W/'artifacts/asm/portable_001';B=W/'artifacts/benchmark_build'
def opbase(op):
 if op in ['salq','sall','sal']:return 'shl'
 for root in ['movabs','mov','and','xor','or','sub','add','shr','sar','shl','btr','bts','test','lea','neg']:
  if op==root or op in [root+s for s in ['b','w','l','q']]:return root
 return op
def canonical(op,args):
 regs=re.findall(r'%[a-zA-Z0-9]+',args);imms=[int(s,0) for s in re.findall(r'\$(-?(?:0x[0-9a-fA-F]+|[0-9]+))',args)]
 return opbase(op),regs,imms
def parse_dis(p):
 functions={};name=None
 for line in p.read_text().splitlines():
  f=re.match(r'^[0-9a-f]+ <([^>]+)>:',line)
  if f:name=f[1];functions[name]=[];continue
  m=re.match(r'^\s*([0-9a-f]+):\s+((?:[0-9a-f]{2}\s+)+)\s*([a-z][a-z0-9]*)\s*(.*)',line)
  if m and name:
   functions[name].append(dict(address=int(m[1],16),bytes=''.join(m[2].split()),op=m[3],args=m[4].split('#')[0].strip(),line=line))
 return functions
def asm_blocks(variant):
 lines=(A/(variant+'_sign.s')).read_text().splitlines();blocks=[];fun=None;i=0
 while i<len(lines):
  m=re.match(r'\s*\.type\s+(\w+),\s*@function',lines[i])
  if m:fun=m[1]
  if f'# {variant}/source/fpr-emulated.h:124:' in lines[i]:
   start=i;buf=[]
   while i<len(lines) and not (i>start and lines[i].startswith(f'# {variant}/source/falcon-sign.c:')):
    s=lines[i].split('#')[0].strip()
    if s and not s.startswith('.') and not s.endswith(':'):
     a=s.split(None,1);buf.append((a[0],a[1] if len(a)>1 else ''))
    i+=1
   blocks.append(dict(function=fun,first_line=start+1,last_line=i,instructions=buf));continue
  i+=1
 return blocks
def reg(r):
 r=r.lstrip('%')
 legacy={'eax':'rax','ax':'rax','al':'rax','ah':'rax','ebx':'rbx','bx':'rbx','bl':'rbx','bh':'rbx','ecx':'rcx','cx':'rcx','cl':'rcx','ch':'rcx','edx':'rdx','dx':'rdx','dl':'rdx','dh':'rdx','esi':'rsi','si':'rsi','sil':'rsi','edi':'rdi','di':'rdi','dil':'rdi','ebp':'rbp','bp':'rbp','bpl':'rbp','esp':'rsp','sp':'rsp','spl':'rsp'}
 return legacy.get(r,re.sub(r'^(r[0-9]+)[dwb]$',r'\1',r))
def review(ins,input_reg,scope):
 tainted={reg(input_reg)};flags=False;rows=[];branches=[];mem=[];latency=[]
 allowed={'mov','movabs','shr','sar','shl','and','or','xor','sub','add','neg','btr','bts','lea','test','cmove','ret'}
 for x in ins:
  op=opbase(x['op']);args=x['args'];regs=re.findall(r'%[a-zA-Z0-9]+',args);uses={reg(r) for r in regs}
  if op.startswith('j') or op.startswith('call'):
   branches.append(dict(address=x['address'],op=op,tainted_flags=flags,args=args))
  if op in ['div','idiv'] or op.startswith(('div','idiv')):latency.append(x['address'])
  if '(' in args and op!='lea':mem.append(dict(address=x['address'],args=args,tainted_address=bool(uses&tainted)))
  row=dict(**x,tainted_inputs=sorted(uses&tainted),flags_tainted_before=flags)
  if op in ['mov','movabs','lea']:
   if regs:
    dest=reg(regs[-1]);src={reg(r) for r in regs[:-1]};tainted.discard(dest)
    if src&set(row['tainted_inputs']):tainted.add(dest)
  elif op=='test':flags=bool(uses&tainted)
  elif op=='cmove':
   if regs and (flags or uses&tainted):tainted.add(reg(regs[-1]))
  elif op in allowed and op!='ret':
   if regs:
    dest=reg(regs[-1]);secret=bool(uses&tainted)
    if op=='xor' and len(regs)==2 and regs[0]==regs[1]:secret=False
    tainted.discard(dest)
    if secret:tainted.add(dest)
    flags=secret
  row.update(tainted_after=sorted(tainted),flags_tainted_after=flags);rows.append(row)
 if scope=='candidate':
  assert not branches and not mem and not latency
  assert all(opbase(x['op']) in allowed for x in ins)
  assert 'rsp' not in tainted
 return dict(instructions=rows,conditional_or_indirect_transfers=branches,memory_operands=mem,integer_divisions=latency,
  argument='Only register arithmetic/logical operations and register-source cmov; lea is arithmetic, not a load; fixed ret target belongs to public call frame.',all_instruction_classes_reviewed=True)
led=[]
for variant in ['baseline','candidate']:
 wrapper=parse_dis(A/(variant+'_wrapper.dis'))['floor_wrapper']
 led.append(dict(variant=variant,site='floor_wrapper',input_register='rdi',disassembly_sha256=sha(A/(variant+'_wrapper.dis')),**review(wrapper,'rdi',variant)))
 funcs=parse_dis(A/(variant+'_sign.dis'));blocks=asm_blocks(variant);assert len(blocks)==3 and {x['function'] for x in blocks}=={'BerExp','sampler','sampler_large'}
 for block in blocks:
  seq=[canonical(*x) for x in block['instructions']];whole=funcs[block['function']];norm=[canonical(x['op'],x['args']) for x in whole]
  hits=[i for i in range(len(norm)-len(seq)+1) if norm[i:i+len(seq)]==seq];assert len(hits)==1,(variant,block['function'],hits)
  ins=whole[hits[0]:hits[0]+len(seq)];inp=re.findall(r'%\w+',block['instructions'][0][1])[0]
  led.append(dict(variant=variant,site=block['function'],asm_first_line=block['first_line'],asm_last_line=block['last_line'],
   code_start=ins[0]['address'],code_end=ins[-1]['address']+len(ins[-1]['bytes'])//2,region_bytes_sha256=__import__('hashlib').sha256(bytes.fromhex(''.join(x['bytes'] for x in ins))).hexdigest(),
   input_register=inp,**review(ins,inp,variant)))
 target=parse_dis(B/(variant+'.dis'))['target_floor'];led.append(dict(variant=variant,site='official_timing_target_floor',input_register='rdi',**review(target,'rdi',variant)))
assert all(any(x['op']=='js' for x in r['conditional_or_indirect_transfers']) for r in led if r['variant']=='baseline')
candidate=[r for r in led if r['variant']=='candidate'];assert len(candidate)==5
calls=[]
for name in ['falcon-sign.c','falcon-keygen.c','falcon-fft.c','fpr-emulated.c']:
 for i,line in enumerate((W/'baseline/source'/name).read_text().splitlines(),1):
  if 'fpr_floor(' in line:calls.append(dict(file=name,line=i,text=line.strip()))
assert [r['line'] for r in calls]==[2481,2542,2864]
out=dict(status='PASS_PINNED_FLOOR_FIXED_CONTROL_AND_MEMORY_TRACE',floor_sites=calls,regions=led,candidate_regions=5,
 baseline_branch_condition='encoded exponent<1022, from sign flag of e-1022',candidate_header_sha256=sha(W/'candidate/source/fpr-emulated.h'),
 source_changed_only_floor=True,compiler_barrier_used=False,microarchitecture_latency_proof=False,whole_caller_or_Sign_CT_claimed=False,
 scope='Reviewed scalar floor operation in these exact GCC14.2 -O objects/binary. Callers retain their own branches, loops and effects.')
(W/'artifacts/assembly_ledger.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='regions'},indent=2))
