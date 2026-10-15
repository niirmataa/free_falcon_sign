#!/usr/bin/env python3
"""Emit finite symbolic data-flow proofs; performs no mathematical word arithmetic."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
fields=[('aR','fAr'),('aI','fAi'),('bR','fBr'),('bI','fBi'),('cR','fCr'),('cI','fCi'),('qR','xr'),('qI','xi'),
        ('w2R','fpr_W2R'),('w2I','fpr_W2I'),('w4R','fpr_W4R'),('w4I','fpr_W4I')]
steps=[('mul',0,['fBr','fBi','xr','xi'],['fB0r','fB0i']),
 ('mul',1,['fB0r','fB0i','fpr_W2R','fpr_W2I'],['fB1r','fB1i']),
 ('mul',2,['fB0r','fB0i','fpr_W4R','fpr_W4I'],['fB2r','fB2i']),
 ('sqr',0,['xr','xi'],['xr','xi']),
 ('mul',3,['fCr','fCi','xr','xi'],['fC0r','fC0i']),
 ('mul',4,['fC0r','fC0i','fpr_W2R','fpr_W2I'],['fC1r','fC1i']),
 ('mul',5,['fC0r','fC0i','fpr_W4R','fpr_W4I'],['fC2r','fC2i']),
 ('add',0,['fB0r','fB0i','fC0r','fC0i'],['fB0r','fB0i']),
 ('add',1,['fB1r','fB1i','fC2r','fC2i'],['fB1r','fB1i']),
 ('add',2,['fB2r','fB2i','fC1r','fC1i'],['fB2r','fB2i'])]
options='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n'
q=lambda s:'"'+s+'".toList'
known={name:'x.'+field for field,name in fields}
model=['import Source3.FftTripleCalls145','import Source3.FftTripleAddCalls146','',options,
 'namespace FT1536.Source3.FftTripleWords147','', 'structure Inputs where']
model += ['  '+f+' : BitVec 64' for f,_ in fields]
model += ['']
for j,(kind,site,inputs,outputs) in enumerate(steps):
 if kind!='sqr':
  model += [f'def operands{j} (x : Inputs) : FftMulStates140.Words := ⟨'+','.join(known[n] for n in inputs)+'⟩']
  fn='FftMulStates140' if kind=='mul' else 'FftPairStates140'
  extra='' if kind=='mul' else ' .add'
  model += [f'def real{j} (x : Inputs) := {fn}.real{extra} (operands{j} x)',f'def imag{j} (x : Inputs) := {fn}.imag{extra} (operands{j} x)']
 else:
  model += [f'def real{j} (x : Inputs) := FpcSqrShape145.real ({known[inputs[0]]}) ({known[inputs[1]]})',
            f'def imag{j} (x : Inputs) := FpcSqrShape145.imag ({known[inputs[0]]}) ({known[inputs[1]]})']
 known[outputs[0]]=f'(real{j} x)';known[outputs[1]]=f'(imag{j} x)'
 model += ['']
model += ['def storeWords (x : Inputs) : Fin 3 → FftMulStates140.Words']
for i in range(3):
 model += [f'  | ⟨{i},_⟩ => ⟨x.aR,x.aI,{known[f"fB{i}r"]},{known[f"fB{i}i"]}⟩']
model += ['', 'end FT1536.Source3.FftTripleWords147','']
(ROOT/'formal/Source3/FftTripleWords147.lean').write_text('\n'.join(model))
lines=['import Source3.FftTripleWords147','import Source3.FftTripleArithmeticCells147','import Source3.FftTripleInputs147','',options,
 'namespace FT1536.Source3.FftTripleArithmetic147','open C99ArrayReference (State)','open FftTripleWords147',
 'open FftTripleDeclare147 (names)','', 'structure Entry (s : State) (x : Inputs) : Prop where',
 '  declared : C99Declared147.Declared s names']
lines += [f'  {field} : s.locals {q(name)}=some (.uint64,some (.uint64 x.{field}))' for field,name in fields]
lines += ['']
state=lambda k:'s' if k==0 else f'(state{k} s x)'
# Track literal register writers. Every generated equality is checked in Lean.
def cell(k,name):
 writer=None
 for j in range(k):
  if name in steps[j][3]:writer=j
 if writer is None:
  field=next(f for f,n in fields if n==name);proof='entry.'+field;start=0
 else:
  outs=steps[writer][3];part='real_cell' if name==outs[0] else 'imag_cell'
  proof=f'FftTripleArithmeticCells147.{part} {state(writer)} {q(outs[0])} {q(outs[1])} (real{writer} x) (imag{writer} x)'
  if part=='real_cell':proof+=' (by decide)'
  start=writer+1
 for j in range(start,k):
  outs=steps[j][3]
  proof=f'(FftTripleArithmeticCells147.outside {state(j)} {q(outs[0])} {q(outs[1])} (real{j} x) (imag{j} x) {q(name)} (by decide) (by decide)).trans ({proof})'
 return proof
for j,(kind,site,inputs,outs) in enumerate(steps):
 k=j+1;dr,di=outs;prev=state(j);cur=state(k)
 lines += [f'def state{k} (s : State) (x : Inputs) := FftTripleArithmeticCells147.two {prev} {q(dr)} {q(di)} (real{j} x) (imag{j} x)','',
  f'theorem declared{k} (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared {cur} names :=',
  f'  FftTripleArithmeticCells147.declared {prev} names {q(dr)} {q(di)} (real{j} x) (imag{j} x) '+('entry.declared' if j==0 else f'(declared{j} s x entry)'),'',
  f'theorem heap{k} (s : State) (x : Inputs) : {cur}.heap=s.heap :=',
  f'  (FftTripleArithmeticCells147.heap {prev} {q(dr)} {q(di)} (real{j} x) (imag{j} x))'+('' if j==0 else f'.trans (heap{j} s x)'),'',
 f'theorem frame{k} (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s {cur} :=',
  f'  C99ScopeFrame147.trans names s {prev} {cur} '+('(C99ScopeFrame147.refl names s)' if j==0 else f'(frame{j} s x)')+
  f'\n    (FftTripleArithmeticCells147.frame {prev} names {q(dr)} {q(di)} (real{j} x) (imag{j} x) (by decide +kernel) (by decide +kernel))','',
  f'theorem source{k} (s : State) (x : Inputs)'+(' (entry : Entry s x)' if kind!='add' else '')+' :',
  f'    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part {12+j}) {prev} ⟨{cur},.normal⟩ :=']
 if kind=='mul':
  lines += [f'  FftTripleCalls145.mul {site} {prev} (operands{j} x)']
  lines += ['    ('+cell(j,n)+')' for n in inputs]
  decl='entry.declared' if j==0 else f'declared{j} s x entry'
  lines += [f'    ({decl} {q(dr)} (by decide +kernel)) ({decl} {q(di)} (by decide +kernel))']
 elif kind=='sqr':
  lines += [f'  FftTripleCalls145.square {prev} x.qR x.qI', '    ('+cell(j,inputs[0])+')','    ('+cell(j,inputs[1])+')']
 else:
  lines += [f'  FftTripleAddCalls146.local_source {site} {prev} (operands{j} x)']
  lines += ['    ('+cell(j,n)+')' for n in inputs]
 lines += ['']
def chain(j):
 if j==10:return f'C99ProcedureReference.Exec.base .skip {state(10)} {state(10)} (.skip {state(10)})'
 rest='C99ProcedureParser.chain ['+','.join(f'FftTripleShape145.part {12+k}' for k in range(j+1,10))+']'
 source=f'source{j+1} s x'+(' entry' if steps[j][0]!='add' else '')
 return f'.seqNormal (FftTripleShape145.part {12+j}) ({rest}) {state(j)} {state(j+1)} ⟨{state(10)},.normal⟩ ({source}) ({chain(j+1)})'
lines += ['def code := C99ProcedureParser.chain ((FftTripleShape145.statements.drop 12).take 10)',
 'theorem shape : code=C99ProcedureParser.chain ['+','.join(f'FftTripleShape145.part {12+j}' for j in range(10))+'] := by rfl','',
 'theorem source (s : State) (x : Inputs) (entry : Entry s x) :',
 '    C99ProcedureReference.Exec KeygenSearchFft.program code s ⟨state10 s x,.normal⟩ := by',
 '  rw [shape]',
 '  exact '+chain(0),'',
 'theorem metadata (s : State) (x : Inputs) : (state10 s x).heap=s.heap ∧ (state10 s x).arrays=s.arrays ∧',
 '    (state10 s x).globals=s.globals ∧ (state10 s x).tables=s.tables := ⟨heap10 s x,(frame10 s x).arrays,(frame10 s x).globals,(frame10 s x).tables⟩','']
for label,name in [('aR','fAr'),('aI','fAi'),('b0R','fB0r'),('b0I','fB0i'),('b1R','fB1r'),('b1I','fB1i'),('b2R','fB2r'),('b2I','fB2i')]:
 lines += [f'theorem final_{label} (s : State) (x : Inputs)'+(' (entry : Entry s x)' if 'entry.' in cell(10,name) else '')+' :',
   f'    (state10 s x).locals {q(name)}=some (.uint64,some (.uint64 {known[name]})) :=', '  '+cell(10,name),'']
lines += ['end FT1536.Source3.FftTripleArithmetic147','']
(ROOT/'formal/Source3/FftTripleArithmetic147.lean').write_text('\n'.join(lines))
print('emitted FftTripleWords147 and FftTripleArithmetic147; no numerical arithmetic performed')
