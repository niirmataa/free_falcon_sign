#!/usr/bin/env python3
"""Organize source codec AST witnesses; Lean checks every atomic parse.
Read Extra/c only; preserve the caller grammar and all historical producers.
"""
from pathlib import Path
import hashlib,json,re,sys
import keygen_make_binding as old
ROOT=Path(__file__).resolve().parents[1];REPO=ROOT.parents[4]
ENC_SHA='0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05'
CALLEES={'compress_none':'none','compress_static':'static'}
_old_literal_tokens=old.literal_tokens
def literal_tokens(ts):
 flattened=[]
 for token in ts: flattened.extend(['-','-'] if token=='--' else [token])
 return _old_literal_tokens(flattened)
old.literal_tokens=literal_tokens
class Generator(old.Generator):
 def unary(self):
  token=self.pop()
  if token in ('++','--'):
   return '(.pre'+('Inc' if token=='++' else 'Dec')+' '+self.unary()+')'
  if token in ('-','~','!','*','&'):
   op={'-':'neg','~':'bitnot','!':'logicalNot','*':'dereference','&':'address'}[token]
   return '(.unary .'+op+' '+self.unary()+')'
  if token=='(':
   if self.peek() in old.TYPES:
    ty=self.pointer(self.ty());self.pop(')');return '(.cast '+ty+' '+self.unary()+')'
   e=self.expression();self.pop(')')
  elif re.fullmatch(r'\d+[UL]?',token):
   e='(.number .'+('u32' if token.endswith('U') else 'long' if token.endswith('L') else 'i32')+' '+token.rstrip('UL')+')'
  elif self.peek()=='(':
   destination=CALLEES[token];self.pop('(');args=[]
   if self.peek()!=')':
    while True:
     args.append(self.expression())
     if self.peek()!=',':break
     self.pop(',')
   self.pop(')');e='(.call .'+destination+' (argumentTree ['+','.join(args)+']))'
  else:e='(.variable '+old.quoted(token)+')'
  while True:
   if self.peek() in ('++','--'):
    token=self.pop();e='(.post'+('Inc' if token=='++' else 'Dec')+' '+e+')'
   elif self.peek()=='[':
    self.pop();index=self.expression();self.pop(']');e='(.index '+e+' '+index+')'
   else:return e
 def clause(self,ending):
  if self.peek()==ending:return '.skip'
  left=self.expression()
  if self.peek() in ('=','+=','-=','&=','|=','<<='):
   op={'=':'set','+=':'add','-=':'sub','&=':'band','|=':'bor','<<=':'shl'}[self.pop()]
   return '(.write '+left+' .'+op+' '+self.expression()+')'
  return '(.evaluate '+left+')'
 def statement(self):
  if self.peek()=='while':
   self.pop();self.pop('(');start=self.pos;test=self.expression();ts=self.ts[start:self.pos];self.pop(')');inner=self.statement()
   name='guard'+str(self.counter).zfill(3)
   self.lines+=['def '+name+' : Expr := '+test,
     'def '+name+'Tokens : List B20.C.Token := '+old.literal_tokens(ts),
     'theorem '+name+'_source : guard '+name+' '+name+'Tokens := by rfl','']
   return self.emit('Statement','(.whileLoop '+name+' '+inner+')',
     '["while".toList,[\'(\']]++'+name+'Tokens++[[\')\']]++'+inner+'Tokens',
     'by exact .whileLoop _ _ _ _ '+name+'_source '+inner+'_source')
  if self.peek()=='switch':
   self.pop();self.pop('(');start=self.pos;test=self.expression();ts=self.ts[start:self.pos];self.pop(')');self.pop('{');codes=[];parts=[]
   for label in ['0','1','default']:
    if label=='default':self.pop('default')
    else:self.pop('case');self.pop(label)
    self.pop(':');start=self.pos;self.pop('return');value=self.expression();self.pop(';');codes.append(value);parts.append(self.ts[start:self.pos])
   self.pop('}');name='switch'+str(self.counter).zfill(3)
   self.lines+=['def '+name+'Test : Expr := '+test,'def '+name+'TestTokens : List B20.C.Token := '+old.literal_tokens(ts)]
   for i,(value,tokens) in enumerate(zip(codes,parts)):
    self.lines+=['def '+name+'Value'+str(i)+' : Expr := '+value,'def '+name+'Tokens'+str(i)+' : List B20.C.Token := '+old.literal_tokens(tokens)]
   self.lines+=['theorem '+name+'_test : guard '+name+'Test '+name+'TestTokens := by rfl']
   for i in range(3):
    self.lines+=['theorem '+name+'_arm'+str(i)+' : KeygenCodecSyntax.simple '+name+'Tokens'+str(i)+'=some (.ret '+name+'Value'+str(i)+',[]) := by decide +kernel']
   return self.emit('Statement','(.switch '+name+'Test '+ ' '.join('(.ret '+name+'Value'+str(i)+')' for i in range(3))+')',
    '["switch".toList,[\'(\']]++'+name+'TestTokens++[[\')\'],[\'{\'],"case".toList,[\'0\'],[\':\']]++'+name+'Tokens0++["case".toList,[\'1\'],[\':\']]++'+name+'Tokens1++["default".toList,[\':\']]++'+name+'Tokens2++[[\'}\']]',
    'by exact Statement.switch '+name+'Test '+ ' '.join(name+'Value'+str(i) for i in range(3))+' '+name+'TestTokens '+ ' '.join(name+'Tokens'+str(i) for i in range(3))+' '+name+'_test '+ ' '.join(name+'_arm'+str(i) for i in range(3)))
  return super().statement()

def main():
 directory=(ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
 assert directory.is_relative_to(ROOT);directory.mkdir(parents=True,exist_ok=True)
 source=REPO/'Extra/c/falcon-enc.c';raw=source.read_bytes();assert hashlib.sha256(raw).hexdigest()==ENC_SHA
 text=raw.decode();regions={}
 for short,name in [('None','compress_none'),('Static','compress_static'),('Dispatch','falcon_encode_small')]:
  match=re.search(r'(?:static )?size_t\n'+name+r'\(',text);assert match
  start=match.start();brace=text.index('{',match.end());depth=1;end=brace+1
  while depth:
   if text.startswith('/*',end):end=text.index('*/',end+2)+2;continue
   if text[end]=='{':depth+=1
   if text[end]=='}':depth-=1
   end+=1
  fragment=text[start:end]+'\n';regions[short]=fragment
  stripped=re.sub(r'/\*.*?\*/|//[^\n]*',' ',fragment,flags=re.S)
  ts=re.findall(r'\w+|>>=|<<=|\+\+|--|>>|<<|&&|\|\||[+\-*^&|=!<>]=|[^\s\w]',stripped)
  ts=[{'FALCON_COMP_NONE':'0','FALCON_COMP_STATIC':'1'}.get(t,t) for t in ts]
  # Source lexer emits '--' as two '-' tokens; expression grammar retains
  # pre/post decrement as a distinct AST constructor.
  lexical=[]
  for t in ts:lexical.extend(['-','-'] if t=='--' else [t])
  g=Generator(ts);g.pos=ts.index('{')+1;body=g.body();g.pop('}');assert g.pos==len(ts)
  ns='KeygenCodec'+short+'Binding'
  common='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+ns+'\nopen KeygenCodecSyntax KeygenCodecGrammar\n\n'
  # Keep each source function's AST nodes in small serial pieces.
  parts=[]
  for offset in range(0,len(g.lines),120):
   part=ns+'Part'+str(len(parts)).zfill(2)
   content='import Source3.'+(parts[-1] if parts else 'KeygenCodecGrammar')+'\n\n'+common
   content+='\n'.join(g.lines[offset:offset+120])+'\nend FT1536.Source3.'+ns+'\n'
   if short=='Dispatch':
    proofs=[]
    for suffix in ['test','arm0','arm1','arm2']:
     match=re.search(r'^theorem switch000_'+suffix+r'[^\n]*\n',content,re.M);assert match
     proof=match.group(0);content=content[:match.start()]+content[match.end():]
     if suffix.startswith('arm'):
      proofs.append('run_cmd IO.FS.writeFile "../DISPATCH_PROGRESS.json" "'+suffix[-1]+'"\n')
     proofs.append(proof)
    marker='theorem node000_source'
    where=content.index(marker);content=content[:where]+''.join(proofs)+content[where:]
    content=content.replace(':= by exact Statement.switch switch000Test switch000Value0 switch000Value1 switch000Value2 switch000TestTokens switch000Tokens0 switch000Tokens1 switch000Tokens2 switch000_test switch000_arm0 switch000_arm1 switch000_arm2',
     ':= by\n  exact Statement.switch switch000Test switch000Value0 switch000Value1 switch000Value2\n    switch000TestTokens switch000Tokens0 switch000Tokens1 switch000Tokens2\n    switch000_test switch000_arm0 switch000_arm1 switch000_arm2')
   target=directory/(part+'.lean');assert not target.exists();target.write_text(content);parts.append(part)
  signature=lexical[:lexical.index('{')+1]
  params='[⟨"out".toList,.pointer .void,none⟩,⟨"max_out_len".toList,.size,none⟩,'+ ('⟨"comp".toList,.i32,none⟩,' if short=='Dispatch' else '')+'⟨"q".toList,.u32,none⟩,⟨"x".toList,.pointer (.readonly .i16),none⟩,⟨"logn".toList,.u32,none⟩]'
  out='import Source3.'+parts[-1]+'\nimport Source3.KeygenCodecSource\n\n'+common
  out+='def expectedHeader : Header := ⟨'+old.quoted(name)+','+params+',.size⟩\n'
  out+='def signatureTokens : List B20.C.Token := '+old.literal_tokens(signature)+'\n'
  out+='theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl\n'
  out+='def code : Stmt := .scope '+body+'\n'
  out+='def allTokens : List B20.C.Token := '+old.literal_tokens(lexical)+'\n'
  out+='theorem lexical_source : tokens (KeygenCodecSource.'+short.lower()+'Lines.flatMap String.toList)=some allTokens := by decide\n'
  out+='theorem complete_tokens_source : allTokens=signatureTokens++'+body+"Tokens++[['}']] := by rfl\n"
  out+='theorem source_bound : Whole allTokens expectedHeader code :=\n  .function _ _ _ _ _ signature_source '+body+'_source complete_tokens_source\n'
  out+='\nend FT1536.Source3.'+ns+'\n'
  target=directory/(ns+'.lean');assert not target.exists();target.write_text(out)
  print(short,parts,ns,g.counter)
 header=(REPO/'Extra/c/falcon.h').read_text();macros=[line+'\n' for line in header.splitlines() if re.fullmatch(r'#define FALCON_COMP_(?:NONE|STATIC)\s+[01]',line)]
 assert len(macros)==2
 out='import Source3.KeygenCodecSyntax\n\nnamespace FT1536.Source3.KeygenCodecSource\n'
 out+='def sourceSha : String := '+json.dumps(ENC_SHA)+'\n'
 for short,fragment in regions.items():out+='def '+short.lower()+'Lines : List String := ['+','.join(json.dumps(line) for line in fragment.splitlines(keepends=True))+']\n'
 out+='def macroLines : List String := ['+','.join(json.dumps(line) for line in macros)+']\n'
 out+='theorem macro_values : macroLines='+ '['+','.join(json.dumps(line) for line in macros)+'] := by rfl\n'
 out+='end FT1536.Source3.KeygenCodecSource\n'
 target=directory/'KeygenCodecSource.lean';assert not target.exists();target.write_text(out)
if __name__=='__main__':main()
