import Source3.KeygenLexCompose098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexChunks098D

open KeygenLexCompose098 (Prefix Chunk)
open KeygenZintCall (tokenize)
attribute [local cbv_opaque] KeygenZintCall.tokenize

def lines27 : List String := (KeygenBezoutText098.lines.drop 116).take 4
def raw27 : List B20.C.Token := (["continue", ";", "}"] : List String).map String.toList

theorem equation27 : Prefix (lines27.flatMap String.toList) raw27 12 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw27]

theorem budget27 : 12 ≤ (lines27.flatMap String.toList).length := by decide +kernel
def chunk27 : Chunk := ⟨lines27, raw27, 12, equation27, budget27⟩

def lines28 : List String := (KeygenBezoutText098.lines.drop 120).take 4
def raw28 : List B20.C.Token := (["if", "(", "(", "a", "[", "0", "]", "&", "1", ")", "==", "0", ")", "{"] : List String).map String.toList

theorem equation28 : Prefix (lines28.flatMap String.toList) raw28 27 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw28]

theorem budget28 : 27 ≤ (lines28.flatMap String.toList).length := by decide +kernel
def chunk28 : Chunk := ⟨lines28, raw28, 27, equation28, budget28⟩

def lines29 : List String := (KeygenBezoutText098.lines.drop 124).take 4
def raw29 : List B20.C.Token := (["zint_rshift1", "(", "a", ",", "alen", ")", ";", "alen", "=", "zint_exact_length", "(", "a", ",", "alen", ")", ";", "zint_rshift1_mod", "(", "u0", ",", "y", ",", "ylen", ")", ";", "zint_rshift1_mod", "(", "v0", ",", "x", ",", "xlen", ")", ";"] : List String).map String.toList

theorem equation29 : Prefix (lines29.flatMap String.toList) raw29 58 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw29]

theorem budget29 : 58 ≤ (lines29.flatMap String.toList).length := by decide +kernel
def chunk29 : Chunk := ⟨lines29, raw29, 58, equation29, budget29⟩

def lines30 : List String := (KeygenBezoutText098.lines.drop 128).take 6
def raw30 : List B20.C.Token := (["continue", ";", "}"] : List String).map String.toList

theorem equation30 : Prefix (lines30.flatMap String.toList) raw30 15 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw30]

theorem budget30 : 15 ≤ (lines30.flatMap String.toList).length := by decide +kernel
def chunk30 : Chunk := ⟨lines30, raw30, 15, equation30, budget30⟩

def lines31 : List String := (KeygenBezoutText098.lines.drop 134).take 4
def raw31 : List B20.C.Token := (["if", "(", "(", "b", "[", "0", "]", "&", "1", ")", "==", "0", ")", "{", "zint_rshift1", "(", "b", ",", "blen", ")", ";", "blen", "=", "zint_exact_length", "(", "b", ",", "blen", ")", ";", "zint_rshift1_mod", "(", "u1", ",", "y", ",", "ylen", ")", ";"] : List String).map String.toList

theorem equation31 : Prefix (lines31.flatMap String.toList) raw31 66 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw31]

theorem budget31 : 66 ≤ (lines31.flatMap String.toList).length := by decide +kernel
def chunk31 : Chunk := ⟨lines31, raw31, 66, equation31, budget31⟩

def lines32 : List String := (KeygenBezoutText098.lines.drop 138).take 4
def raw32 : List B20.C.Token := (["zint_rshift1_mod", "(", "v1", ",", "x", ",", "xlen", ")", ";", "continue", ";", "}"] : List String).map String.toList

theorem equation32 : Prefix (lines32.flatMap String.toList) raw32 26 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw32]

theorem budget32 : 26 ≤ (lines32.flatMap String.toList).length := by decide +kernel
def chunk32 : Chunk := ⟨lines32, raw32, 26, equation32, budget32⟩

def lines33 : List String := (KeygenBezoutText098.lines.drop 142).take 4
def raw33 : List B20.C.Token := ([] : List String).map String.toList

theorem equation33 : Prefix (lines33.flatMap String.toList) raw33 4 := by
  intro fuel tail
  have keep : tokenize [] (fuel + 4) (lines33.flatMap String.toList ++ tail) = tokenize [] fuel tail := by cbv
  rw [keep]
  cases tokenize [] fuel tail <;> rfl

theorem budget33 : 4 ≤ (lines33.flatMap String.toList).length := by decide +kernel
def chunk33 : Chunk := ⟨lines33, raw33, 4, equation33, budget33⟩

def lines34 : List String := (KeygenBezoutText098.lines.drop 146).take 4
def raw34 : List B20.C.Token := (["if", "(", "alen", "<", "blen", ")", "{", "r", "=", "-", "1", ";", "}", "else", "if", "(", "alen", ">", "blen", ")", "{", "r", "=", "1", ";"] : List String).map String.toList

theorem equation34 : Prefix (lines34.flatMap String.toList) raw34 53 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw34]

theorem budget34 : 53 ≤ (lines34.flatMap String.toList).length := by decide +kernel
def chunk34 : Chunk := ⟨lines34, raw34, 53, equation34, budget34⟩

def lines35 : List String := (KeygenBezoutText098.lines.drop 150).take 10
def raw35 : List B20.C.Token := (["}", "else", "{", "r", "=", "zint_ucmp", "(", "a", ",", "b", ",", "alen", ")", ";", "if", "(", "r", "==", "0", ")", "{"] : List String).map String.toList

theorem equation35 : Prefix (lines35.flatMap String.toList) raw35 48 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw35]

theorem budget35 : 48 ≤ (lines35.flatMap String.toList).length := by decide +kernel
def chunk35 : Chunk := ⟨lines35, raw35, 48, equation35, budget35⟩

end FT1536.Source3.KeygenLexChunks098D
