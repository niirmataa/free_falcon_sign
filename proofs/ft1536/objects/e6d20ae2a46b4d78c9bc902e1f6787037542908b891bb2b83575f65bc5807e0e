import Source3.KeygenMakeSyntax

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded lexical pieces; each literal is checked in the kernel
   against the complete corresponding active source region. No lexer oracle. -/
namespace FT1536.Source3.KeygenMakeTokens
open B20.C (Token)

def piece00 : List Token := [
  "int","falcon_keygen_make","(","falcon_keygen","*","fk",",","int","comp",",","void","*",
  "privkey",",","size_t","*","privkey_len",",","void","*","pubkey",",","size_t","*",
  "pubkey_len",")","{","unsigned","logn",",","ter",";","size_t","n",",","u",
  ";","int16_t","f","[","3072","]",",","g","[","3072","]",",",
  "F","[","3072","]",",","G","[","3072","]",";","uint16_t","h",
  "[","3072","]",";","size_t","klen",",","skoff",";","unsigned","char","*",
  "skbuf",";","int16_t","*","ske","[","4","]",";","int","i",";",
  "uint64_t","local_attempts",";","local_attempts","=","0",";","logn","=","fk","-",">",
  "logn",";","ter","=","fk","-",">","ternary",";","n","=","MKN",
  "(","logn",",","ter",")",";","if","(","!","rng_ready","(","fk",
  ")",")","{","return","0",";","}","for","(",";",";",")",
  "{"].map String.toList
theorem piece00_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 0).flatMap String.toList)=some piece00 := by decide

def piece01 : List Token := [
  "if","(","ter",")","{","local_attempts","++",";","if","(","local_attempts",">",
  "3000000",")","{","return","0",";","}"].map String.toList
theorem piece01_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 1).flatMap String.toList)=some piece01 := by decide

def piece02 : List Token := [
  "fpr","*","rt1",",","*","rt2",",","*","rt3",";","fpr","norm",
  ",","bound",";","rt1","=","(","fpr","*",")","fk","-",">",
  "tmp",";","rt2","=","rt1","+","n",";","rt3","=","rt2","+",
  "n",";","sample_true_ternary_secret","(","fk",",","f",",","n",")",";","sample_true_ternary_secret",
  "(","fk",",","g",",","n",")",";"].map String.toList
theorem piece02_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 2).flatMap String.toList)=some piece02 := by decide

def piece03 : List Token := [
  "if","(","mod2_res_ternary","(","f",",","logn",")","==","0",")","{",
  "continue",";","}","if","(","mod2_res_ternary","(","g",",","logn",")","==",
  "0",")","{","continue",";","}"].map String.toList
theorem piece03_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 3).flatMap String.toList)=some piece03 := by decide

def piece04 : List Token := [
  "bound","=","fpr_div","(","fpr_of","(","73732L","*","(","long",")","n",
  ")",",","fpr_sqrt","(","fpr_of","(","8",")",")",")",";","bound",
  "=","fpr_div","(","fpr_mul","(","bound",",","fpr_of","(","1250",")",")",
  ",","fpr_of","(","100",")",")",";"].map String.toList
theorem piece04_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 4).flatMap String.toList)=some piece04 := by decide

def piece05 : List Token := [
  "poly_small_to_fp","(","rt1",",","f",",","logn",",","1",")",";","poly_small_to_fp",
  "(","rt2",",","g",",","logn",",","1",")",";","falcon_FFT3","(",
  "rt1",",","logn",",","1",")",";","falcon_FFT3","(","rt2",",","logn",
  ",","1",")",";","norm","=","fpr_of","(","0",")",";","for",
  "(","u","=","0",";","u","<","n",";","u","++",")",
  "{","norm","=","fpr_add","(","norm",",","fpr_sqr","(","rt1","[","u",
  "]",")",")",";","norm","=","fpr_add","(","norm",",","fpr_sqr","(",
  "rt2","[","u","]",")",")",";","}","norm","=","fpr_double","(",
  "norm",")",";","if","(","!","fpr_lt","(","norm",",","bound",")",
  ")","{","continue",";","}"].map String.toList
theorem piece05_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 5).flatMap String.toList)=some piece05 := by decide

def piece06 : List Token := [
  "falcon_poly_invnorm2_fft3","(","rt3",",","rt1",",","rt2",",","logn",",","1",")",
  ";","falcon_poly_adj_fft3","(","rt1",",","logn",",","1",")",";","falcon_poly_adj_fft3","(",
  "rt2",",","logn",",","1",")",";","falcon_poly_mulconst_fft3","(","rt1",",","fpr_of",
  "(","18433",")",",","logn",",","1",")",";","falcon_poly_mulconst_fft3","(","rt2",
  ",","fpr_of","(","18433",")",",","logn",",","1",")",";","falcon_poly_mul_autoadj_fft3",
  "(","rt1",",","rt3",",","logn",",","1",")",";","falcon_poly_mul_autoadj_fft3","(",
  "rt2",",","rt3",",","logn",",","1",")",";","norm","=","fpr_of",
  "(","0",")",";","for","(","u","=","0",";","u","<",
  "n",";","u","++",")","{","norm","=","fpr_add","(","norm",",",
  "fpr_sqr","(","rt1","[","u","]",")",")",";","norm","=","fpr_add",
  "(","norm",",","fpr_sqr","(","rt2","[","u","]",")",")",";",
  "}","norm","=","fpr_double","(","norm",")",";","if","(","!","fpr_lt",
  "(","norm",",","bound",")",")","{","continue",";","}"].map String.toList
theorem piece06_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 6).flatMap String.toList)=some piece06 := by decide

def piece07 : List Token := [
  "}","else","{","fpr","*","rt1",",","*","rt2",",","*","rt3",
  ";","fpr","bnorm",";","uint32_t","normf",",","normg",",","norm",";","poly_small_mkgauss",
  "(","fk",",","f",",","logn",")",";","poly_small_mkgauss","(","fk",",",
  "g",",","logn",")",";","normf","=","poly_small_sqnorm","(","f",",","logn",
  ",","ter",")",";","normg","=","poly_small_sqnorm","(","g",",","logn",",",
  "ter",")",";","norm","=","(","normf","+","normg",")","|","-",
  "(","(","normf","|","normg",")",">>","31",")",";","if","(",
  "norm",">=","16823",")","{","continue",";","}","rt1","=","(","fpr",
  "*",")","fk","-",">","tmp",";","rt2","=","rt1","+","n",
  ";","rt3","=","rt2","+","n",";","poly_small_to_fp","(","rt1",",","f",
  ",","logn",",","0",")",";","poly_small_to_fp","(","rt2",",","g",",",
  "logn",",","0",")",";","falcon_FFT","(","rt1",",","logn",")",";",
  "falcon_FFT","(","rt2",",","logn",")",";","falcon_poly_invnorm2_fft","(","rt3",",","rt1",
  ",","rt2",",","logn",")",";","falcon_poly_adj_fft","(","rt1",",","logn",")",
  ";","falcon_poly_adj_fft","(","rt2",",","logn",")",";","falcon_poly_mulconst_fft","(","rt1",",",
  "fpr_of","(","12289",")",",","logn",")",";","falcon_poly_mulconst_fft","(","rt2",",",
  "fpr_of","(","12289",")",",","logn",")",";","falcon_poly_mul_autoadj_fft","(","rt1",",",
  "rt3",",","logn",")",";","falcon_poly_mul_autoadj_fft","(","rt2",",","rt3",",","logn",
  ")",";","falcon_iFFT","(","rt1",",","logn",")",";","falcon_iFFT","(","rt2",
  ",","logn",")",";","bnorm","=","fpr_of","(","0",")",";","for",
  "(","u","=","0",";","u","<","n",";","u","++",")",
  "{","bnorm","=","fpr_add","(","bnorm",",","fpr_sqr","(","rt1","[","u",
  "]",")",")",";","bnorm","=","fpr_add","(","bnorm",",","fpr_sqr","(",
  "rt2","[","u","]",")",")",";","}","if","(","!","fpr_lt",
  "(","bnorm",",","fpr_div","(","fpr_of","(","168224121",")",",","fpr_of","(",
  "10000",")",")",")",")","{","continue",";","}","}"].map String.toList
theorem piece07_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 7).flatMap String.toList)=some piece07 := by decide

def piece08 : List Token := [
  "if","(","!","falcon_compute_public","(","h",",","f",",","g",",","logn",
  ",","ter",")",")","{","continue",";","}"].map String.toList
theorem piece08_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 8).flatMap String.toList)=some piece08 := by decide

def piece09 : List Token := [
  "if","(","!","solve_NTRU","(","fk",",","F",",","G",",","f",
  ",","g",")",")","{","continue",";","}"].map String.toList
theorem piece09_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 9).flatMap String.toList)=some piece09 := by decide

def piece10 : List Token := [
  "if","(","ter","&&","logn","==","10","&&","n","==","1536",")",
  "{","if","(","!","ft_keygen_leaf_certificate","(","(","fpr","*",")","fk","-",
  ">","tmp",",","f",",","g",",","F",",","G",",","logn",
  ",","ter",")",")","{","continue",";","}","}"].map String.toList
theorem piece10_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 10).flatMap String.toList)=some piece10 := by decide

def piece11 : List Token := [
  "break",";","}"].map String.toList
theorem piece11_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 11).flatMap String.toList)=some piece11 := by decide

def piece12 : List Token := [
  "klen","=","*","privkey_len",";","skbuf","=","privkey",";","if","(","klen",
  "<","1",")","{","return","0",";","}","skbuf","[","0","]",
  "=","(","ter","<<","7",")","+","(","comp","<<","5",")",
  "+","logn",";","skoff","=","1",";","ske","[","0","]","=",
  "f",";","ske","[","1","]","=","g",";","ske","[","2",
  "]","=","F",";","ske","[","3","]","=","G",";","for",
  "(","i","=","0",";","i","<","4",";","i","++",")",
  "{","size_t","elen",";","elen","=","falcon_encode_small","(","skbuf","+","skoff",",",
  "klen","-","skoff",",","comp",",","ter","?","18433",":","12289",",",
  "ske","[","i","]",",","logn",")",";","if","(","elen","==",
  "0",")","{","return","0",";","}","skoff","+=","elen",";","}",
  "*","privkey_len","=","skoff",";","klen","=","*","pubkey_len",";","if","(",
  "klen","<","1",")","{","return","0",";","}","(","(","unsigned",
  "char","*",")","pubkey",")","[","0","]","=","(","ter","<<",
  "7",")","+","logn",";","if","(","ter",")","{","klen","=",
  "falcon_encode_18433","(","(","unsigned","char","*",")","pubkey","+","1",",","klen",
  "-","1",",","h",",","logn",")",";","}","else","{","klen",
  "=","falcon_encode_12289","(","(","unsigned","char","*",")","pubkey","+","1",",",
  "klen","-","1",",","h",",","logn",")",";","}","if","(",
  "klen","==","0",")","{","return","0",";","}","*","pubkey_len","=",
  "klen","+","1",";","return","1",";","}"].map String.toList
theorem piece12_source : KeygenMakeSyntax.tokens
    ((KeygenMakePreprocess.visible 12).flatMap String.toList)=some piece12 := by decide

def all : List Token := piece00++piece01++piece02++piece03++piece04++piece05++piece06++piece07++piece08++piece09++piece10++piece11++piece12
def pieces : List (List Token) := [piece00,piece01,piece02,piece03,piece04,piece05,piece06,piece07,piece08,piece09,piece10,piece11,piece12]
theorem all_pieces : all=pieces.flatten := by simp [all,pieces,List.append_assoc]

end FT1536.Source3.KeygenMakeTokens
