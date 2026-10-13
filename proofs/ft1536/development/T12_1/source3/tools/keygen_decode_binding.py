#!/usr/bin/env python3
"""Organize the exact NONE decoder syntax without changing encoder inputs.
The new decoder parser retains the original tokens and adds only the source
hexadecimal literal0x8000. Lean checks every clause and whole-body partition.
Syntax/source binding is not an execution or round-trip theorem.
"""
from pathlib import Path
import hashlib,json,re,sys
import keygen_codec_binding as encoder

ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[4]
ENC_SHA=encoder.ENC_SHA

class Generator(encoder.Generator):
    def ty(self):
        if self.peek()=='const':
            self.pop()
            return '(.readonly '+self.ty()+')'
        return super().ty()
    def unary(self):
        if self.peek()=='0x8000':
            self.pop()
            return '(.number .i32 32768)'
        return super().unary()
    def statement(self):
        if self.peek()=='const':
            start=self.pos
            ty=self.ty();objects=[]
            while True:
                element=self.pointer(ty);name=self.pop()
                objects.append('⟨'+encoder.old.quoted(name)+','+element+',none⟩')
                if self.peek()!=',':break
                self.pop(',')
            self.pop(';')
            return self.emit('Statement','(.declare ['+','.join(objects)+'])',encoder.old.literal_tokens(self.ts[start:self.pos]),'by exact .simple _ _ (by rfl)')
        return super().statement()

def main():
    directory=(ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
    assert directory.is_relative_to(ROOT)
    directory.mkdir(parents=True,exist_ok=True)
    def write(name,contents):
        target=directory/(name+'.lean')
        assert not target.exists(),('Never overwrite generated evidence',target)
        target.write_text(contents)
    syntax=(ROOT/'formal/Source3/KeygenCodecSyntax.lean').read_text().replace('KeygenCodecSyntax','KeygenDecodeSyntax')
    syntax=syntax.replace('"compress_none"','"uncompress_none"').replace('"compress_static"','"uncompress_static"')
    syntax=syntax.replace('def numeral (token : Token) : Option Expr := do','def numeral (token : Token) : Option Expr := do\n  if token="0x8000".toList then return .number .i32 32768')
    syntax=syntax.replace('/- Codec-only grammar:', '/- Decoder grammar copied from the pinned encoder parser without editing it.\n   The only new numeric token is0x8000=32768; original tokens remain intact.\n   Syntax only; no operational decoder claim. Codec fragment:')
    syntax=syntax.replace('end FT1536.Source3.KeygenDecodeSyntax','theorem hexadecimal_value : numeral "0x8000".toList=some (.number .i32 (8*16^3)) := by decide +kernel\n\nend FT1536.Source3.KeygenDecodeSyntax')
    write('KeygenDecodeSyntax',syntax)
    grammar=(ROOT/'formal/Source3/KeygenCodecGrammar.lean').read_text().replace('KeygenCodec','KeygenDecode')
    write('KeygenDecodeGrammar',grammar)
    raw=(REPO/'Extra/c/falcon-enc.c').read_bytes();assert hashlib.sha256(raw).hexdigest()==ENC_SHA
    text=raw.decode();match=re.search(r'static size_t\nuncompress_none\(',text);assert match
    start=match.start();brace=text.index('{',match.end());depth=1;end=brace+1
    while depth:
        if text.startswith('/*',end):end=text.index('*/',end+2)+2;continue
        if text[end]=='{':depth+=1
        if text[end]=='}':depth-=1
        end+=1
    fragment=text[start:end]+'\n'
    stripped=re.sub(r'/\*.*?\*/|//[^\n]*',' ',fragment,flags=re.S)
    ts=re.findall(r'\w+|>>=|<<=|\+\+|--|>>|<<|&&|\|\||[+\-*^&|=!<>]=|[^\s\w]',stripped)
    g=Generator(ts);g.pos=ts.index('{')+1;body=g.body();g.pop('}');assert g.pos==len(ts)
    ns='KeygenDecodeNoneBinding'
    common='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+ns+'\nopen KeygenDecodeSyntax KeygenDecodeGrammar\n\n'
    parts=[]
    for offset in range(0,len(g.lines),120):
        part=ns+'Part'+str(len(parts)).zfill(2)
        content='import Source3.'+(parts[-1] if parts else 'KeygenDecodeGrammar')+'\n\n'+common
        content+='\n'.join(g.lines[offset:offset+120]).replace('KeygenCodecSyntax','KeygenDecodeSyntax')+'\nend FT1536.Source3.'+ns+'\n'
        write(part,content);parts.append(part)
    signature=ts[:ts.index('{')+1]
    params='[⟨"x".toList,.pointer .i16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"q".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩]'
    out='import Source3.'+parts[-1]+'\nimport Source3.KeygenDecodeSource\n\n'+common
    out+='def expectedHeader : Header := ⟨"uncompress_none".toList,'+params+',.size⟩\n'
    out+='def signatureTokens : List B20.C.Token := '+encoder.old.literal_tokens(signature)+'\n'
    out+='theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl\n'
    out+='def code : Stmt := .scope '+body+'\n'
    out+='def allTokens : List B20.C.Token := '+encoder.old.literal_tokens(ts)+'\n'
    out+='theorem lexical_source : tokens (KeygenDecodeSource.noneLines.flatMap String.toList)=some allTokens := by decide +kernel\n'
    out+='theorem complete_tokens_source : allTokens=signatureTokens++'+body+"Tokens++[['}']] := by rfl\n"
    out+='theorem source_bound : Whole allTokens expectedHeader code :=\n  .function _ _ _ _ _ signature_source '+body+'_source complete_tokens_source\n'
    out+='\nend FT1536.Source3.'+ns+'\n'
    write(ns,out)
    out='import Source3.KeygenDecodeSyntax\n\nnamespace FT1536.Source3.KeygenDecodeSource\n'
    out+='def sourceSha : String := '+json.dumps(ENC_SHA)+'\n'
    out+='def noneLines : List String := ['+','.join(json.dumps(line) for line in fragment.splitlines(keepends=True))+']\n'
    out+='end FT1536.Source3.KeygenDecodeSource\n'
    write('KeygenDecodeSource',out)
    print(json.dumps({'source_sha256':ENC_SHA,'parts':parts,'binding':ns,'nodes':g.counter,'syntax_only':True}))
if __name__=='__main__':main()
