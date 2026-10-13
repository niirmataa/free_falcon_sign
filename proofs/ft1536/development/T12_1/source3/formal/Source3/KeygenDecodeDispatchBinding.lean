import Source3.KeygenDecodeDispatchBindingPart00
import Source3.KeygenDecodeDispatchSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeDispatchBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def expectedHeader : Header := ⟨"falcon_decode_small".toList,[⟨"x".toList,.pointer .i16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"comp".toList,.i32,none⟩,⟨"q".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["size_t","falcon_decode_small","(","int16_t","*","x",",","unsigned","logn",",","int","comp",",","unsigned","q",",","const","void","*","data",",","size_t","len",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node002
def allTokens : List B20.C.Token := ["size_t","falcon_decode_small","(","int16_t","*","x",",","unsigned","logn",",","int","comp",",","unsigned","q",",","const","void","*","data",",","size_t","len",")","{","switch","(","comp",")","{","case","0",":","return","uncompress_none","(","x",",","logn",",","q",",","data",",","len",")",";","case","1",":","return","uncompress_static","(","x",",","logn",",","q",",","data",",","len",")",";","default",":","return","0",";","}","}"].map String.toList
theorem lexical_source : tokens (KeygenDecodeDispatchSource.lines.flatMap String.toList)=some allTokens := by decide +kernel
theorem complete_tokens_source : allTokens=signatureTokens++node002Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node002_source complete_tokens_source
end FT1536.Source3.KeygenDecodeDispatchBinding
