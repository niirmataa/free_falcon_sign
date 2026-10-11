import Source3.KeygenCodecDispatchBindingPart00
import Source3.KeygenCodecSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecDispatchBinding
open KeygenCodecSyntax KeygenCodecGrammar

def expectedHeader : Header := ⟨"falcon_encode_small".toList,[⟨"out".toList,.pointer .void,none⟩,⟨"max_out_len".toList,.size,none⟩,⟨"comp".toList,.i32,none⟩,⟨"q".toList,.u32,none⟩,⟨"x".toList,.pointer (.readonly .i16),none⟩,⟨"logn".toList,.u32,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["size_t","falcon_encode_small","(","void","*","out",",","size_t","max_out_len",",","int","comp",",","unsigned","q",",","const","int16_t","*","x",",","unsigned","logn",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node002
def allTokens : List B20.C.Token := ["size_t","falcon_encode_small","(","void","*","out",",","size_t","max_out_len",",","int","comp",",","unsigned","q",",","const","int16_t","*","x",",","unsigned","logn",")","{","switch","(","comp",")","{","case","0",":","return","compress_none","(","out",",","max_out_len",",","q",",","x",",","logn",")",";","case","1",":","return","compress_static","(","out",",","max_out_len",",","q",",","x",",","logn",")",";","default",":","return","0",";","}","}"].map String.toList
theorem lexical_source : tokens (KeygenCodecSource.dispatchLines.flatMap String.toList)=some allTokens := by decide
theorem complete_tokens_source : allTokens=signatureTokens++node002Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node002_source complete_tokens_source

end FT1536.Source3.KeygenCodecDispatchBinding
