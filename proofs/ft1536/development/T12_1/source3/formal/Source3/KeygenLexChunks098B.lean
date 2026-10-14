import Source3.KeygenLexCompose098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexChunks098B

open KeygenLexCompose098 (Prefix Chunk)
open KeygenZintCall (tokenize)
attribute [local cbv_opaque] KeygenZintCall.tokenize

def lines09 : List String := (KeygenBezoutText098.lines.drop 39).take 4
def raw09 : List B20.C.Token := (["uxa", "<<=", "1", ";", "uxb", "<<=", "1", ";", "}", "else", "if", "(", "a_hi", ">", "b_hi", ")", "{", "a_hi", "-=", "b_hi", ";"] : List String).map String.toList

theorem equation09 : Prefix (lines09.flatMap String.toList) raw09 56 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw09]

theorem budget09 : 56 ≤ (lines09.flatMap String.toList).length := by decide +kernel
def chunk09 : Chunk := ⟨lines09, raw09, 56, equation09, budget09⟩

def lines10 : List String := (KeygenBezoutText098.lines.drop 43).take 4
def raw10 : List B20.C.Token := (["a_lo", "-=", "b_lo", ";", "uxa", "-=", "uya", ";", "uxb", "-=", "uyb", ";", "a_hi", ">>=", "1", ";"] : List String).map String.toList

theorem equation10 : Prefix (lines10.flatMap String.toList) raw10 48 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw10]

theorem budget10 : 48 ≤ (lines10.flatMap String.toList).length := by decide +kernel
def chunk10 : Chunk := ⟨lines10, raw10, 48, equation10, budget10⟩

def lines11 : List String := (KeygenBezoutText098.lines.drop 47).take 4
def raw11 : List B20.C.Token := (["b_lo", "<<=", "1", ";", "uya", "<<=", "1", ";", "uyb", "<<=", "1", ";", "}", "else", "{"] : List String).map String.toList

theorem equation11 : Prefix (lines11.flatMap String.toList) raw11 46 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw11]

theorem budget11 : 46 ≤ (lines11.flatMap String.toList).length := by decide +kernel
def chunk11 : Chunk := ⟨lines11, raw11, 46, equation11, budget11⟩

def lines12 : List String := (KeygenBezoutText098.lines.drop 51).take 4
def raw12 : List B20.C.Token := (["b_hi", "-=", "a_hi", ";", "b_lo", "-=", "a_lo", ";", "uya", "-=", "uxa", ";", "uyb", "-=", "uxb", ";"] : List String).map String.toList

theorem equation12 : Prefix (lines12.flatMap String.toList) raw12 48 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw12]

theorem budget12 : 48 ≤ (lines12.flatMap String.toList).length := by decide +kernel
def chunk12 : Chunk := ⟨lines12, raw12, 48, equation12, budget12⟩

def lines13 : List String := (KeygenBezoutText098.lines.drop 55).take 4
def raw13 : List B20.C.Token := (["b_hi", ">>=", "1", ";", "a_lo", "<<=", "1", ";", "uxa", "<<=", "1", ";", "uxb", "<<=", "1", ";"] : List String).map String.toList

theorem equation13 : Prefix (lines13.flatMap String.toList) raw13 48 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw13]

theorem budget13 : 48 ≤ (lines13.flatMap String.toList).length := by decide +kernel
def chunk13 : Chunk := ⟨lines13, raw13, 48, equation13, budget13⟩

def lines14 : List String := (KeygenBezoutText098.lines.drop 59).take 9
def raw14 : List B20.C.Token := (["}", "}"] : List String).map String.toList

theorem equation14 : Prefix (lines14.flatMap String.toList) raw14 17 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw14]

theorem budget14 : 17 ≤ (lines14.flatMap String.toList).length := by decide +kernel
def chunk14 : Chunk := ⟨lines14, raw14, 17, equation14, budget14⟩

def lines15 : List String := (KeygenBezoutText098.lines.drop 68).take 4
def raw15 : List B20.C.Token := (["if", "(", "uxa", "==", "0x80000000", ")", "{", "int32_t", "ya", ";", "if", "(", "uxb", "!=", "0", "||", "uyb", "!=", "1", ")", "{"] : List String).map String.toList

theorem equation15 : Prefix (lines15.flatMap String.toList) raw15 49 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw15]

theorem budget15 : 49 ≤ (lines15.flatMap String.toList).length := by decide +kernel
def chunk15 : Chunk := ⟨lines15, raw15, 49, equation15, budget15⟩

def lines16 : List String := (KeygenBezoutText098.lines.drop 72).take 4
def raw16 : List B20.C.Token := (["return", "0", ";", "}", "ya", "=", "*", "(", "int32_t", "*", ")", "&", "uya", ";", "if", "(", "zint_reduce", "(", "b", ",", "a", ",", "len", ",", "ya", ")", ")", "{"] : List String).map String.toList

theorem equation16 : Prefix (lines16.flatMap String.toList) raw16 58 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw16]

theorem budget16 : 58 ≤ (lines16.flatMap String.toList).length := by decide +kernel
def chunk16 : Chunk := ⟨lines16, raw16, 58, equation16, budget16⟩

def lines17 : List String := (KeygenBezoutText098.lines.drop 76).take 4
def raw17 : List B20.C.Token := (["ya", "=", "-", "ya", ";", "}", "zint_reduce_mod", "(", "u1", ",", "u0", ",", "y", ",", "ylen", ",", "y0i", ",", "ya", ")", ";", "zint_reduce_mod", "(", "v1", ",", "v0", ",", "x", ",", "xlen", ",", "x0i", ",", "ya", ")", ";"] : List String).map String.toList

theorem equation17 : Prefix (lines17.flatMap String.toList) raw17 69 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw17]

theorem budget17 : 69 ≤ (lines17.flatMap String.toList).length := by decide +kernel
def chunk17 : Chunk := ⟨lines17, raw17, 69, equation17, budget17⟩

end FT1536.Source3.KeygenLexChunks098B
