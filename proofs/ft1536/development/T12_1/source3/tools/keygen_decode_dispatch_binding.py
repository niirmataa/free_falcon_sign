#!/usr/bin/env python3
"""Bind the complete live pinned falcon_decode_small dispatcher without editing predecessors."""
from pathlib import Path
import hashlib,json,re,sys
import keygen_codec_binding as encoder
ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[4]

def main():
 directory=(ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
 assert directory.is_relative_to(ROOT);directory.mkdir(parents=True,exist_ok=True)
 raw=(REPO/'Extra/c/falcon-enc.c').read_bytes();assert hashlib.sha256(raw).hexdigest()==encoder.ENC_SHA
 text=raw.decode();match=re.search(r'size_t\nfalcon_decode_small\(',text);assert match
 start=match.start();brace=text.index('{',match.end());end=brace+1;depth=1
 while depth:
  if text.startswith('/*',end):end=text.index('*/',end+2)+2;continue
  if text[end]=='{':depth+=1
  if text[end]=='}':depth-=1
  end+=1
 fragment=text[start:end]+'\n'
 stripped=re.sub(r'/\*.*?\*/|//[^\n]*',' ',fragment,flags=re.S)
 ts=re.findall(r'\w+|>>=|<<=|\+\+|--|>>|<<|&&|\|\||[+\-*^&|=!<>]=|[^\s\w]',stripped)
 ts=[{'FALCON_COMP_NONE':'0','FALCON_COMP_STATIC':'1'}.get(t,t) for t in ts]
 oldTable=encoder.CALLEES
 try:
  encoder.CALLEES={'uncompress_none':'none','uncompress_static':'static'}
  g=encoder.Generator(ts);g.pos=ts.index('{')+1;body=g.body();g.pop('}');assert g.pos==len(ts)
 finally:encoder.CALLEES=oldTable
 def write(name,source):
  p=directory/(name+'.lean');assert not p.exists();p.write_text(source)
 ns='KeygenDecodeDispatchBinding'
 common='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+ns+'\nopen KeygenDecodeSyntax KeygenDecodeGrammar\n\n'
 part=ns+'Part00'
 write(part,'import Source3.KeygenDecodeGrammar\n\n'+common+'\n'.join(g.lines).replace('KeygenCodecSyntax','KeygenDecodeSyntax')+'\nend FT1536.Source3.'+ns+'\n')
 signature=ts[:ts.index('{')+1]
 params='[⟨"x".toList,.pointer .i16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"comp".toList,.i32,none⟩,⟨"q".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩]'
 out='import Source3.'+part+'\nimport Source3.KeygenDecodeDispatchSource\n\n'+common
 out+='def expectedHeader : Header := ⟨"falcon_decode_small".toList,'+params+',.size⟩\n'
 out+='def signatureTokens : List B20.C.Token := '+encoder.old.literal_tokens(signature)+'\n'
 out+='theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl\n'
 out+='def code : Stmt := .scope '+body+'\n'
 out+='def allTokens : List B20.C.Token := '+encoder.old.literal_tokens(ts)+'\n'
 out+='theorem lexical_source : tokens (KeygenDecodeDispatchSource.lines.flatMap String.toList)=some allTokens := by decide +kernel\n'
 out+='theorem complete_tokens_source : allTokens=signatureTokens++'+body+"Tokens++[['}']] := by rfl\n"
 out+='theorem source_bound : Whole allTokens expectedHeader code :=\n  .function _ _ _ _ _ signature_source '+body+'_source complete_tokens_source\n'
 out+='end FT1536.Source3.'+ns+'\n';write(ns,out)
 out='import Source3.KeygenDecodeSyntax\n\nnamespace FT1536.Source3.KeygenDecodeDispatchSource\n'
 out+='def sourceSha : String := '+json.dumps(encoder.ENC_SHA)+'\n'
 out+='def lines : List String := ['+','.join(json.dumps(line) for line in fragment.splitlines(keepends=True))+']\n'
 out+='end FT1536.Source3.KeygenDecodeDispatchSource\n';write('KeygenDecodeDispatchSource',out)
 print(json.dumps({'binding':ns,'nodes':g.counter,'source_sha256':encoder.ENC_SHA,'all_runtime_switch_arms_retained':True}))
if __name__=='__main__':main()
