import Source3.KeygenDecodeStaticBindingPart04
import Source3.KeygenDecodeStaticSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticBinding
open KeygenDecodeSyntax KeygenDecodeGrammar

def expectedHeader : Header := ⟨"uncompress_static".toList,[⟨"x".toList,.pointer .i16,none⟩,⟨"logn".toList,.u32,none⟩,⟨"q".toList,.u32,none⟩,⟨"data".toList,.pointer (.readonly .void),none⟩,⟨"len".toList,.size,none⟩],.size⟩
def signatureTokens : List B20.C.Token := ["static","size_t","uncompress_static","(","int16_t","*","x",",","unsigned","logn",",","unsigned","q",",","const","void","*","data",",","size_t","len",")","{"].map String.toList
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node124
def allTokens : List B20.C.Token := ["static","size_t","uncompress_static","(","int16_t","*","x",",","unsigned","logn",",","unsigned","q",",","const","void","*","data",",","size_t","len",")","{","const","unsigned","char","*","buf",";","size_t","n",",","u",",","v",";","unsigned","db",",","mask",";","unsigned","db_len",",","j",";","if","(","q","==","12289",")","{","n","=","(","size_t",")","1","<<","logn",";","j","=","7",";","}","else","{","n","=","(","size_t",")","3","<<","(","logn","-","1",")",";","j","=","8",";","}","mask","=","(","1U","<<","j",")","-","1U",";","buf","=","data",";","u","=","0",";","v","=","0",";","db","=","0",";","db_len","=","0",";","for","(",";",";",")","{","unsigned","sign",";","unsigned","lo",";","unsigned","ne",";","while","(","db_len","<=","j",")","{","if","(","v",">=","len",")","{","return","0",";","}","db","=","(","db","<<","8",")","+","buf","[","v","++","]",";","db_len","+=","8",";","}","sign","=","(","db",">>","(","db_len","-","1",")",")","&","1",";","db_len","-=","j","+","1",";","lo","=","(","db",">>","db_len",")","&","mask",";","for","(","ne","=","0",";",";","ne","++",")","{","unsigned","bit",";","if","(","db_len","==","0",")","{","if","(","v",">=","len",")","{","return","0",";","}","db","=","buf","[","v","++","]",";","db_len","=","8",";","}","db_len","-","-",";","bit","=","(","db",">>","db_len",")","&","1",";","if","(","bit",")","{","break",";","}","}","if","(","ne",">","255",")","{","return","0",";","}","lo","+=","(","ne","<<","j",")",";","if","(","sign",")","{","x","[","u","]","=","-","(","int16_t",")","lo",";","}","else","{","x","[","u","]","=","(","int16_t",")","lo",";","}","if","(","++","u",">=","n",")","{","if","(","(","db","&","(","(","1U","<<","db_len",")","-","1U",")",")","!=","0",")","{","return","0",";","}","return","v",";","}","}","}"].map String.toList
theorem lexical_source : tokens (KeygenDecodeStaticSource.lines.flatMap String.toList)=some allTokens := by decide +kernel
theorem complete_tokens_source : allTokens=signatureTokens++node124Tokens++[['}']] := by rfl
theorem source_bound : Whole allTokens expectedHeader code :=
  .function _ _ _ _ _ signature_source node124_source complete_tokens_source

end FT1536.Source3.KeygenDecodeStaticBinding
