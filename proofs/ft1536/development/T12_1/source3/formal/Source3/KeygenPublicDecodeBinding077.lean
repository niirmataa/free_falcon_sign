import Source3.KeygenPublicDecodeBinding077Part02
import Source3.KeygenPublicDecodeSource077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeBinding077
open KeygenDecodeSyntax KeygenDecodeGrammar

def expectedHeader : Header := ⟨"falcon_decode_18433".toList,[⟨"x".toList,.pointer .u16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["size_t","falcon_decode_18433","(","uint16_t","*","x",",","unsigned","logn",",","const","void","*","data",",","size_t","len",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node062
def allTokens : List B20.C.Token := ["size_t","falcon_decode_18433","(","uint16_t","*","x",",","unsigned","logn",",","const","void","*","data",",","size_t","len",")","{","const","unsigned","char","*","buf",";","size_t","n",",","u",";","uint32_t","acc",";","int","acc_len",";","n","=","(","size_t",")","3","<<","(","logn","-","1",")",";","buf","=","data",";","u","=","0",";","acc","=","0",";","acc_len","=","0",";","while","(","n",">","0",")","{","if","(","u",">=","len",")","{","return","0",";","}","acc","=","(","acc","<<","8",")","|","buf","[","u","++","]",";","acc_len","+=","8",";","if","(","acc_len",">=","15",")","{","uint32_t","w",";","acc_len","-=","15",";","w","=","acc",">>","acc_len",";","if","(","w",">=","18433",")","{","return","0",";","}","*","x","++","=","(","uint16_t",")","w",";","n","-","-",";","acc","&=","(","1U","<<","acc_len",")","-","1U",";","}","}","if","(","acc","!=","0",")","{","return","0",";","}","return","len",";","}"].map String.toList
theorem lexical_source : tokens (KeygenPublicDecodeSource077.lines.flatMap String.toList)=some allTokens := by decide +kernel
theorem complete_tokens_source : allTokens=signatureTokens++node062Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node062_source complete_tokens_source
end FT1536.Source3.KeygenPublicDecodeBinding077
