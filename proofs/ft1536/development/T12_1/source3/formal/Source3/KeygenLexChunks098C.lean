import Source3.KeygenLexCompose098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexChunks098C

open KeygenLexCompose098 (Prefix Chunk)
open KeygenZintCall (tokenize)
attribute [local cbv_opaque] KeygenZintCall.tokenize

def lines18 : List String := (KeygenBezoutText098.lines.drop 80).take 4
def raw18 : List B20.C.Token := (["}", "else", "if", "(", "uyb", "==", "0x80000000", ")", "{", "int32_t", "xb", ";", "if", "(", "uya", "!=", "0", "||", "uxa", "!=", "1", ")", "{"] : List String).map String.toList

theorem equation18 : Prefix (lines18.flatMap String.toList) raw18 53 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw18]

theorem budget18 : 53 ≤ (lines18.flatMap String.toList).length := by decide +kernel
def chunk18 : Chunk := ⟨lines18, raw18, 53, equation18, budget18⟩

def lines19 : List String := (KeygenBezoutText098.lines.drop 84).take 4
def raw19 : List B20.C.Token := (["return", "0", ";", "}", "xb", "=", "*", "(", "int32_t", "*", ")", "&", "uxb", ";", "if", "(", "zint_reduce", "(", "a", ",", "b", ",", "len", ",", "xb", ")", ")", "{"] : List String).map String.toList

theorem equation19 : Prefix (lines19.flatMap String.toList) raw19 58 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw19]

theorem budget19 : 58 ≤ (lines19.flatMap String.toList).length := by decide +kernel
def chunk19 : Chunk := ⟨lines19, raw19, 58, equation19, budget19⟩

def lines20 : List String := (KeygenBezoutText098.lines.drop 88).take 4
def raw20 : List B20.C.Token := (["xb", "=", "-", "xb", ";", "}", "zint_reduce_mod", "(", "u0", ",", "u1", ",", "y", ",", "ylen", ",", "y0i", ",", "xb", ")", ";", "zint_reduce_mod", "(", "v0", ",", "v1", ",", "x", ",", "xlen", ",", "x0i", ",", "xb", ")", ";"] : List String).map String.toList

theorem equation20 : Prefix (lines20.flatMap String.toList) raw20 69 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw20]

theorem budget20 : 69 ≤ (lines20.flatMap String.toList).length := by decide +kernel
def chunk20 : Chunk := ⟨lines20, raw20, 69, equation20, budget20⟩

def lines21 : List String := (KeygenBezoutText098.lines.drop 92).take 4
def raw21 : List B20.C.Token := (["}", "else", "{", "int32_t", "xa", ",", "xb", ",", "ya", ",", "yb", ";", "xa", "=", "*", "(", "int32_t", "*", ")", "&", "uxa", ";"] : List String).map String.toList

theorem equation21 : Prefix (lines21.flatMap String.toList) raw21 46 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw21]

theorem budget21 : 46 ≤ (lines21.flatMap String.toList).length := by decide +kernel
def chunk21 : Chunk := ⟨lines21, raw21, 46, equation21, budget21⟩

def lines22 : List String := (KeygenBezoutText098.lines.drop 96).take 4
def raw22 : List B20.C.Token := (["xb", "=", "*", "(", "int32_t", "*", ")", "&", "uxb", ";", "ya", "=", "*", "(", "int32_t", "*", ")", "&", "uya", ";", "yb", "=", "*", "(", "int32_t", "*", ")", "&", "uyb", ";"] : List String).map String.toList

theorem equation22 : Prefix (lines22.flatMap String.toList) raw22 55 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw22]

theorem budget22 : 55 ≤ (lines22.flatMap String.toList).length := by decide +kernel
def chunk22 : Chunk := ⟨lines22, raw22, 55, equation22, budget22⟩

def lines23 : List String := (KeygenBezoutText098.lines.drop 100).take 4
def raw23 : List B20.C.Token := (["r", "=", "zint_co_reduce", "(", "a", ",", "b", ",", "len", ",", "xa", ",", "xb", ",", "ya", ",", "yb", ")", ";", "if", "(", "(", "r", "&", "1", ")", "!=", "0", ")", "{", "xa", "=", "-", "xa", ";", "xb", "=", "-", "xb", ";"] : List String).map String.toList

theorem equation23 : Prefix (lines23.flatMap String.toList) raw23 80 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw23]

theorem budget23 : 80 ≤ (lines23.flatMap String.toList).length := by decide +kernel
def chunk23 : Chunk := ⟨lines23, raw23, 80, equation23, budget23⟩

def lines24 : List String := (KeygenBezoutText098.lines.drop 104).take 4
def raw24 : List B20.C.Token := (["}", "if", "(", "(", "r", "&", "2", ")", "!=", "0", ")", "{", "ya", "=", "-", "ya", ";", "yb", "=", "-", "yb", ";"] : List String).map String.toList

theorem equation24 : Prefix (lines24.flatMap String.toList) raw24 54 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw24]

theorem budget24 : 54 ≤ (lines24.flatMap String.toList).length := by decide +kernel
def chunk24 : Chunk := ⟨lines24, raw24, 54, equation24, budget24⟩

def lines25 : List String := (KeygenBezoutText098.lines.drop 108).take 4
def raw25 : List B20.C.Token := (["}", "zint_co_reduce_mod", "(", "u0", ",", "u1", ",", "y", ",", "ylen", ",", "y0i", ",", "xa", ",", "xb", ",", "ya", ",", "yb", ")", ";", "zint_co_reduce_mod", "(", "v0", ",", "v1", ",", "x", ",", "xlen", ",", "x0i", ","] : List String).map String.toList

theorem equation25 : Prefix (lines25.flatMap String.toList) raw25 66 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw25]

theorem budget25 : 66 ≤ (lines25.flatMap String.toList).length := by decide +kernel
def chunk25 : Chunk := ⟨lines25, raw25, 66, equation25, budget25⟩

def lines26 : List String := (KeygenBezoutText098.lines.drop 112).take 4
def raw26 : List B20.C.Token := (["xa", ",", "xb", ",", "ya", ",", "yb", ")", ";", "}", "alen", "=", "zint_exact_length", "(", "a", ",", "alen", ")", ";", "blen", "=", "zint_exact_length", "(", "b", ",", "blen", ")", ";"] : List String).map String.toList

theorem equation26 : Prefix (lines26.flatMap String.toList) raw26 55 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw26]

theorem budget26 : 55 ≤ (lines26.flatMap String.toList).length := by decide +kernel
def chunk26 : Chunk := ⟨lines26, raw26, 55, equation26, budget26⟩

end FT1536.Source3.KeygenLexChunks098C
