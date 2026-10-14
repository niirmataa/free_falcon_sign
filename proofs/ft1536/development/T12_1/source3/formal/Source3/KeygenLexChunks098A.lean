import Source3.KeygenLexCompose098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexChunks098A

open KeygenLexCompose098 (Prefix Chunk)
open KeygenZintCall (tokenize)
attribute [local cbv_opaque] KeygenZintCall.tokenize

def lines00 : List String := (KeygenBezoutText098.lines.drop 0).take 7
def raw00 : List B20.C.Token := (["for", "(", ";", ";", ")", "{", "int", "r", ";"] : List String).map String.toList

theorem equation00 : Prefix (lines00.flatMap String.toList) raw00 22 := by
  intro fuel tail
  exact KeygenLexPrefix098.compose fuel tail

theorem budget00 : 22 ≤ (lines00.flatMap String.toList).length := by decide +kernel
def chunk00 : Chunk := ⟨lines00, raw00, 22, equation00, budget00⟩

def lines01 : List String := (KeygenBezoutText098.lines.drop 7).take 4
def raw01 : List B20.C.Token := (["if", "(", "alen", ">=", "3", "||", "blen", ">=", "3", ")", "{", "size_t", "len", ";", "uint64_t", "a_hi", ",", "b_hi", ";", "uint32_t", "a_lo", ",", "b_lo", ";"] : List String).map String.toList

theorem equation01 : Prefix (lines01.flatMap String.toList) raw01 52 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw01]

theorem budget01 : 52 ≤ (lines01.flatMap String.toList).length := by decide +kernel
def chunk01 : Chunk := ⟨lines01, raw01, 52, equation01, budget01⟩

def lines02 : List String := (KeygenBezoutText098.lines.drop 11).take 4
def raw02 : List B20.C.Token := (["uint32_t", "uxa", ",", "uya", ",", "uxb", ",", "uyb", ";", "int", "i", ",", "r", ";", "len", "=", "alen", "<", "blen", "?", "blen", ":", "alen", ";"] : List String).map String.toList

theorem equation02 : Prefix (lines02.flatMap String.toList) raw02 51 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw02]

theorem budget02 : 51 ≤ (lines02.flatMap String.toList).length := by decide +kernel
def chunk02 : Chunk := ⟨lines02, raw02, 51, equation02, budget02⟩

def lines03 : List String := (KeygenBezoutText098.lines.drop 15).take 4
def raw03 : List B20.C.Token := ([] : List String).map String.toList

theorem equation03 : Prefix (lines03.flatMap String.toList) raw03 6 := by
  intro fuel tail
  have keep : tokenize [] (fuel + 6) (lines03.flatMap String.toList ++ tail) = tokenize [] fuel tail := by cbv
  rw [keep]
  cases tokenize [] fuel tail <;> rfl

theorem budget03 : 6 ≤ (lines03.flatMap String.toList).length := by decide +kernel
def chunk03 : Chunk := ⟨lines03, raw03, 6, equation03, budget03⟩

def lines04 : List String := (KeygenBezoutText098.lines.drop 19).take 4
def raw04 : List B20.C.Token := (["a_hi", "=", "(", "(", "uint64_t", ")", "a", "[", "len", "-", "1", "]", "<<", "31", ")", "|", "a", "[", "len", "-", "2", "]", ";", "b_hi", "=", "(", "(", "uint64_t", ")", "b", "[", "len", "-", "1", "]", "<<", "31", ")", "|", "b", "[", "len", "-", "2", "]", ";", "a_lo", "=", "a", "[", "0", "]", ";", "b_lo", "=", "b", "[", "0", "]", ";"] : List String).map String.toList

theorem equation04 : Prefix (lines04.flatMap String.toList) raw04 100 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw04]

theorem budget04 : 100 ≤ (lines04.flatMap String.toList).length := by decide +kernel
def chunk04 : Chunk := ⟨lines04, raw04, 100, equation04, budget04⟩

def lines05 : List String := (KeygenBezoutText098.lines.drop 23).take 4
def raw05 : List B20.C.Token := (["uxa", "=", "1", ";", "uxb", "=", "0", ";", "uya", "=", "0", ";", "uyb", "=", "1", ";"] : List String).map String.toList

theorem equation05 : Prefix (lines05.flatMap String.toList) raw05 40 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw05]

theorem budget05 : 40 ≤ (lines05.flatMap String.toList).length := by decide +kernel
def chunk05 : Chunk := ⟨lines05, raw05, 40, equation05, budget05⟩

def lines06 : List String := (KeygenBezoutText098.lines.drop 27).take 4
def raw06 : List B20.C.Token := (["for", "(", "i", "=", "0", ";", "i", "<", "31", ";", "i", "++", ")", "{", "uint32_t", "m", ";", "m", "=", "(", "uint32_t", ")", "1", "<<", "i", ";"] : List String).map String.toList

theorem equation06 : Prefix (lines06.flatMap String.toList) raw06 55 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw06]

theorem budget06 : 55 ≤ (lines06.flatMap String.toList).length := by decide +kernel
def chunk06 : Chunk := ⟨lines06, raw06, 55, equation06, budget06⟩

def lines07 : List String := (KeygenBezoutText098.lines.drop 31).take 4
def raw07 : List B20.C.Token := (["if", "(", "(", "a_lo", "&", "m", ")", "==", "0", ")", "{", "a_hi", ">>=", "1", ";", "b_lo", "<<=", "1", ";", "uya", "<<=", "1", ";"] : List String).map String.toList

theorem equation07 : Prefix (lines07.flatMap String.toList) raw07 58 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw07]

theorem budget07 : 58 ≤ (lines07.flatMap String.toList).length := by decide +kernel
def chunk07 : Chunk := ⟨lines07, raw07, 58, equation07, budget07⟩

def lines08 : List String := (KeygenBezoutText098.lines.drop 35).take 4
def raw08 : List B20.C.Token := (["uyb", "<<=", "1", ";", "}", "else", "if", "(", "(", "b_lo", "&", "m", ")", "==", "0", ")", "{", "b_hi", ">>=", "1", ";", "a_lo", "<<=", "1", ";"] : List String).map String.toList

theorem equation08 : Prefix (lines08.flatMap String.toList) raw08 62 := by
  intro fuel tail
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw08]

theorem budget08 : 62 ≤ (lines08.flatMap String.toList).length := by decide +kernel
def chunk08 : Chunk := ⟨lines08, raw08, 62, equation08, budget08⟩

end FT1536.Source3.KeygenLexChunks098A
