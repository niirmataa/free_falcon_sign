import Source3.KeygenCodecStaticBindingPart04
import Source3.KeygenCodecSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBinding
open KeygenCodecSyntax KeygenCodecGrammar

def expectedHeader : Header := ⟨"compress_static".toList,[⟨"out".toList,.pointer .void,none⟩,⟨"max_out_len".toList,.size,none⟩,⟨"q".toList,.u32,none⟩,⟨"x".toList,.pointer (.readonly .i16),none⟩,⟨"logn".toList,.u32,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["static","size_t","compress_static","(","void","*","out",",","size_t","max_out_len",",","unsigned","q",",","const","int16_t","*","x",",","unsigned","logn",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node134
def allTokens : List B20.C.Token := ["static","size_t","compress_static","(","void","*","out",",","size_t","max_out_len",",","unsigned","q",",","const","int16_t","*","x",",","unsigned","logn",")","{","unsigned","char","*","buf",";","size_t","n",",","u",";","unsigned","acc",",","mask",";","int","acc_len",",","j",";","if","(","q","==","12289",")","{","n","=","(","size_t",")","1","<<","logn",";","j","=","7",";","}","else","{","n","=","(","size_t",")","3","<<","(","logn","-","1",")",";","j","=","8",";","}","mask","=","(","1U","<<","j",")","-","1U",";","buf","=","out",";","u","=","0",";","acc","=","0",";","acc_len","=","0",";","while","(","n",">","0",")","{","int","w",";","unsigned","lo",";","int","ne",";","w","=","*","x","++",";","n","-","-",";","if","(","w","<","0",")","{","w","=","-","w",";","lo","=","1U","<<","j",";","}","else","{","lo","=","0",";","}","lo","|=","w","&","mask",";","ne","=","w",">>","j",";","acc","=","(","acc","<<","(","j","+","1",")",")","|","lo",";","acc_len","+=","j","+","1",";","while","(","acc_len",">=","8",")","{","acc_len","-=","8",";","if","(","buf","!=","NULL",")","{","if","(","u",">=","max_out_len",")","{","return","0",";","}","buf","[","u","]","=","(","unsigned","char",")","(","acc",">>","acc_len",")",";","}","u","++",";","}","while","(","ne","-","-",">=","0",")","{","acc","<<=","1",";","acc","+=","(","(","unsigned",")","ne",">>","15",")","&","1",";","if","(","++","acc_len","==","8",")","{","if","(","buf","!=","NULL",")","{","if","(","u",">=","max_out_len",")","{","return","0",";","}","buf","[","u","]","=","(","unsigned","char",")","acc",";","}","u","++",";","acc_len","=","0",";","}","}","}","if","(","acc_len",">","0",")","{","if","(","buf","!=","NULL",")","{","if","(","u",">=","max_out_len",")","{","return","0",";","}","buf","[","u","]","=","(","unsigned","char",")","(","acc","<<","(","8","-","acc_len",")",")",";","}","u","++",";","}","return","u",";","}"].map String.toList
theorem lexical_source : tokens (KeygenCodecSource.staticLines.flatMap String.toList)=some allTokens := by decide
theorem complete_tokens_source : allTokens=signatureTokens++node134Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node134_source complete_tokens_source

end FT1536.Source3.KeygenCodecStaticBinding
