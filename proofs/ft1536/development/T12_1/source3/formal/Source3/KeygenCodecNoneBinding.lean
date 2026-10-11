import Source3.KeygenCodecNoneBindingPart01
import Source3.KeygenCodecSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneBinding
open KeygenCodecSyntax KeygenCodecGrammar

def expectedHeader : Header := ⟨"compress_none".toList,[⟨"out".toList,.pointer .void,none⟩,⟨"max_out_len".toList,.size,none⟩,⟨"q".toList,.u32,none⟩,⟨"x".toList,.pointer (.readonly .i16),none⟩,⟨"logn".toList,.u32,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["static","size_t","compress_none","(","void","*","out",",","size_t","max_out_len",",","unsigned","q",",","const","int16_t","*","x",",","unsigned","logn",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node042
def allTokens : List B20.C.Token := ["static","size_t","compress_none","(","void","*","out",",","size_t","max_out_len",",","unsigned","q",",","const","int16_t","*","x",",","unsigned","logn",")","{","size_t","len",",","u",";","unsigned","char","*","buf",";","if","(","q","==","12289",")","{","len","=","(","size_t",")","2","<<","logn",";","}","else","{","len","=","(","size_t",")","3","<<","logn",";","}","if","(","out","==","NULL",")","{","return","len",";","}","if","(","max_out_len","<","len",")","{","return","0",";","}","buf","=","out",";","for","(","u","=","0",";","u","<","len",";","u","+=","2",")","{","unsigned","w",";","w","=","*","x","++",";","buf","[","u","+","0","]","=","(","unsigned","char",")","(","w",">>","8",")",";","buf","[","u","+","1","]","=","(","unsigned","char",")","w",";","}","return","len",";","}"].map String.toList
theorem lexical_source : tokens (KeygenCodecSource.noneLines.flatMap String.toList)=some allTokens := by decide
theorem complete_tokens_source : allTokens=signatureTokens++node042Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node042_source complete_tokens_source

end FT1536.Source3.KeygenCodecNoneBinding
