#!/usr/bin/env python3
"""Bind complete public18433 encoder/decoder from pinned LIVE Extra/c only."""
from pathlib import Path
import hashlib,json,re,sys
import keygen_codec_binding as encoder
from keygen_decode_binding import Generator
ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[4]

def main():
 directory=(ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
 assert directory.is_relative_to(ROOT);directory.mkdir(parents=True,exist_ok=True)
 raw=(REPO/'Extra/c/falcon-enc.c').read_bytes();assert hashlib.sha256(raw).hexdigest()==encoder.ENC_SHA
 text=raw.decode()
 def write(name,value):
  p=directory/(name+'.lean');assert not p.exists();p.write_text(value)
 for short,function,syntax,grammar,params in [
  ('Encode','falcon_encode_18433','KeygenCodecSyntax','KeygenCodecGrammar','[⟨"out".toList,.pointer .void,none⟩,⟨"max_out_len".toList,.size,none⟩,⟨"x".toList,.pointer (.readonly .u16),none⟩,⟨"logn".toList,.u32,none⟩]'),
  ('Decode','falcon_decode_18433','KeygenDecodeSyntax','KeygenDecodeGrammar','[⟨"x".toList,.pointer .u16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩]')]:
  match=re.search(r'size_t\n'+function+r'\(',text);assert match
  start=match.start();brace=text.index('{',match.end());end=brace+1;depth=1
  while depth:
   if text.startswith('/*',end):end=text.index('*/',end+2)+2;continue
   if text[end]=='{':depth+=1
   if text[end]=='}':depth-=1
   end+=1
  fragment=text[start:end]+'\n';stripped=re.sub(r'/\*.*?\*/|//[^\n]*',' ',fragment,flags=re.S)
  ts=re.findall(r'\w+|>>=|<<=|\+\+|--|>>|<<|&&|\|\||[+\-*^&|=!<>]=|[^\s\w]',stripped)
  g=Generator(ts);g.pos=ts.index('{')+1;body=g.body();g.pop('}');assert g.pos==len(ts)
  ns='KeygenPublic'+short+'Binding077';sourceNs='KeygenPublic'+short+'Source077'
  common='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+ns+'\nopen '+syntax+' '+grammar+'\n\n'
  parts=[]
  for offset in range(0,len(g.lines),120):
   part=ns+'Part'+str(len(parts)).zfill(2)
   value='import Source3.'+(parts[-1] if parts else grammar)+'\n\n'+common
   value+='\n'.join(g.lines[offset:offset+120]).replace('KeygenCodecSyntax',syntax)+'\nend FT1536.Source3.'+ns+'\n'
   write(part,value);parts.append(part)
  signature=ts[:ts.index('{')+1]
  value='import Source3.'+parts[-1]+'\nimport Source3.'+sourceNs+'\n\n'+common
  value+='def expectedHeader : Header := ⟨'+encoder.old.quoted(function)+','+params+',.size⟩\n'
  value+='def signatureTokens : List B20.C.Token := '+encoder.old.literal_tokens(signature)+'\n'
  value+='theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl\n'
  value+='def code : Stmt := .scope '+body+'\n'
  value+='def allTokens : List B20.C.Token := '+encoder.old.literal_tokens(ts)+'\n'
  value+='theorem lexical_source : tokens ('+sourceNs+'.lines.flatMap String.toList)=some allTokens := by decide +kernel\n'
  value+='theorem complete_tokens_source : allTokens=signatureTokens++'+body+"Tokens++[['}']] := by rfl\n"
  value+='theorem source_bound : Whole allTokens expectedHeader code :=\n  .function _ _ _ _ _ signature_source '+body+'_source complete_tokens_source\n'
  value+='end FT1536.Source3.'+ns+'\n';write(ns,value)
  value='import Source3.'+syntax+'\n\nnamespace FT1536.Source3.'+sourceNs+'\n'
  value+='def sourceSha : String := '+json.dumps(encoder.ENC_SHA)+'\n'
  value+='def lines : List String := ['+','.join(json.dumps(line) for line in fragment.splitlines(keepends=True))+']\n'
  value+='end FT1536.Source3.'+sourceNs+'\n';write(sourceNs,value)
  print(json.dumps({'function':function,'parts':parts,'binding':ns,'nodes':g.counter,'source_sha256':encoder.ENC_SHA,'syntax_only':True}))
if __name__=='__main__':main()
