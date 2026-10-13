import Source3.KeygenDecodeNoneBindingPart02
import Source3.KeygenDecodeSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeNoneBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def expectedHeader : Header := ⟨"uncompress_none".toList,[⟨"x".toList,.pointer .i16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"q".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["static","size_t","uncompress_none","(","int16_t","*","x",",","unsigned","logn",",","unsigned","q",",","const","void","*","data",",","size_t","len",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node054
def allTokens : List B20.C.Token := ["static","size_t","uncompress_none","(","int16_t","*","x",",","unsigned","logn",",","unsigned","q",",","const","void","*","data",",","size_t","len",")","{","size_t","n",",","u",";","const","unsigned","char","*","buf",";","uint32_t","hq",",","tq",";","if","(","q","==","12289",")","{","n","=","(","size_t",")","1","<<","logn",";","}","else","{","n","=","(","size_t",")","3","<<","(","logn","-","1",")",";","}","if","(","len","<","(","n","<<","1",")",")","{","return","0",";","}","hq","=","q",">>","1",";","tq","=","hq","+","q","+","1",";","buf","=","data",";","for","(","u","=","0",";","u","<","n",";","u","++",")","{","uint32_t","w",";","long","y",";","w","=","(","(","uint32_t",")","buf","[","(","u","<<","1",")","+","0","]","<<","8",")","|","(","uint32_t",")","buf","[","(","u","<<","1",")","+","1","]",";","w","|=","-","(","w","&","0x8000",")",";","w","+=","q",";","if","(","!","(","(","(","hq","-","w",")","&","(","w","-","tq",")",")",">>","31",")",")","{","return","0",";","}","y","=","(","long",")","w","-","(","long",")","q",";","x","[","u","]","=","(","int16_t",")","y",";","}","return","n","<<","1",";","}"].map String.toList
theorem lexical_source : tokens (KeygenDecodeSource.noneLines.flatMap String.toList)=some allTokens := by decide +kernel
theorem complete_tokens_source : allTokens=signatureTokens++node054Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node054_source complete_tokens_source

end FT1536.Source3.KeygenDecodeNoneBinding
