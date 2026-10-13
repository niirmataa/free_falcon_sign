import Source3.KeygenPublicEncodeBinding077Part02
import Source3.KeygenPublicEncodeSource077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeBinding077
open KeygenCodecSyntax KeygenCodecGrammar

def expectedHeader : Header := ⟨"falcon_encode_18433".toList,[⟨"out".toList,.pointer .void,none⟩,⟨"max_out_len".toList,.size,none⟩,⟨"x".toList,.pointer (.readonly .u16),none⟩,⟨"logn".toList,.u32,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["size_t","falcon_encode_18433","(","void","*","out",",","size_t","max_out_len",",","const","uint16_t","*","x",",","unsigned","logn",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node070
def allTokens : List B20.C.Token := ["size_t","falcon_encode_18433","(","void","*","out",",","size_t","max_out_len",",","const","uint16_t","*","x",",","unsigned","logn",")","{","unsigned","char","*","buf",";","size_t","n",",","u",";","uint32_t","acc",";","int","acc_len",";","n","=","(","size_t",")","3","<<","(","logn","-","1",")",";","buf","=","out",";","u","=","0",";","acc","=","0",";","acc_len","=","0",";","while","(","n",">","0",")","{","acc","=","(","acc","<<","15",")","|","(","*","x","++",")",";","n","-","-",";","acc_len","+=","15",";","while","(","acc_len",">=","8",")","{","acc_len","-=","8",";","if","(","out","!=","NULL",")","{","if","(","u",">=","max_out_len",")","{","return","0",";","}","buf","[","u","]","=","(","unsigned","char",")","(","acc",">>","acc_len",")",";","}","u","++",";","acc","&=","(","1U","<<","acc_len",")","-","1U",";","}","}","if","(","acc_len",">","0",")","{","if","(","out","!=","NULL",")","{","if","(","u",">=","max_out_len",")","{","return","0",";","}","buf","[","u","]","=","(","unsigned","char",")","(","acc","<<","(","8","-","acc_len",")",")",";","}","u","++",";","}","return","u",";","}"].map String.toList
theorem lexical_source : tokens (KeygenPublicEncodeSource077.lines.flatMap String.toList)=some allTokens := by decide +kernel
theorem complete_tokens_source : allTokens=signatureTokens++node070Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node070_source complete_tokens_source
end FT1536.Source3.KeygenPublicEncodeBinding077
