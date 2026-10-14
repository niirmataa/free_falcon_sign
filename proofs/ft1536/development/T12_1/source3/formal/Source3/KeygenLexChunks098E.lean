import Source3.KeygenLexCompose098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexChunks098E

open KeygenLexCompose098 (Prefix Chunk)
open KeygenZintCall (tokenize)
attribute [local cbv_opaque] KeygenZintCall.tokenize

def lines36 : List String := (KeygenBezoutText098.lines.drop 160).take 4
def raw36 : List B20.C.Token := (["return", "alen", "==", "1", "&&", "a", "[", "0", "]", "==", "1", ";", "}", "}"] : List String).map String.toList

theorem equation36 : Prefix (lines36.flatMap String.toList) raw36 34 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw36]

theorem budget36 : 34 ≤ (lines36.flatMap String.toList).length := by decide +kernel
def chunk36 : Chunk := ⟨lines36, raw36, 34, equation36, budget36⟩

def lines37 : List String := (KeygenBezoutText098.lines.drop 164).take 9
def raw37 : List B20.C.Token := ([] : List String).map String.toList

theorem equation37 : Prefix (lines37.flatMap String.toList) raw37 4 := by
  intro fuel tail
  have keep : tokenize [] (fuel + 4) (lines37.flatMap String.toList ++ tail) = tokenize [] fuel tail := by cbv
  rw [keep]
  cases tokenize [] fuel tail <;> rfl

theorem budget37 : 4 ≤ (lines37.flatMap String.toList).length := by decide +kernel
def chunk37 : Chunk := ⟨lines37, raw37, 4, equation37, budget37⟩

def lines38 : List String := (KeygenBezoutText098.lines.drop 173).take 4
def raw38 : List B20.C.Token := (["if", "(", "r", ">", "0", ")", "{", "zint_sub", "(", "a", ",", "b", ",", "alen", ")", ";", "alen", "=", "zint_exact_length", "(", "a", ",", "alen", ")", ";", "zint_sub_mod", "(", "u0", ",", "u1", ",", "y", ",", "ylen", ")", ";"] : List String).map String.toList

theorem equation38 : Prefix (lines38.flatMap String.toList) raw38 63 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw38]

theorem budget38 : 63 ≤ (lines38.flatMap String.toList).length := by decide +kernel
def chunk38 : Chunk := ⟨lines38, raw38, 63, equation38, budget38⟩

def lines39 : List String := (KeygenBezoutText098.lines.drop 177).take 4
def raw39 : List B20.C.Token := (["zint_sub_mod", "(", "v0", ",", "v1", ",", "x", ",", "xlen", ")", ";", "}", "else", "{", "zint_sub", "(", "b", ",", "a", ",", "blen", ")", ";", "blen", "=", "zint_exact_length", "(", "b", ",", "blen", ")", ";"] : List String).map String.toList

theorem equation39 : Prefix (lines39.flatMap String.toList) raw39 57 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw39]

theorem budget39 : 57 ≤ (lines39.flatMap String.toList).length := by decide +kernel
def chunk39 : Chunk := ⟨lines39, raw39, 57, equation39, budget39⟩

def lines40 : List String := (KeygenBezoutText098.lines.drop 181).take 4
def raw40 : List B20.C.Token := (["zint_sub_mod", "(", "u1", ",", "u0", ",", "y", ",", "ylen", ")", ";", "zint_sub_mod", "(", "v1", ",", "v0", ",", "x", ",", "xlen", ")", ";", "}", "}"] : List String).map String.toList

theorem equation40 : Prefix (lines40.flatMap String.toList) raw40 43 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw40]

theorem budget40 : 43 ≤ (lines40.flatMap String.toList).length := by decide +kernel
def chunk40 : Chunk := ⟨lines40, raw40, 43, equation40, budget40⟩

end FT1536.Source3.KeygenLexChunks098E
