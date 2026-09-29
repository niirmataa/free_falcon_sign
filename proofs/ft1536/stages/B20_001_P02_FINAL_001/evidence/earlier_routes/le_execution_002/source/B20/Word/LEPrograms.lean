import B20.C.ByteParser
import B20.Pinned.Shake
import B20.Pinned.LittleEndian

set_option maxRecDepth 16384
set_option maxHeartbeats 8000000

namespace B20.Word.LE
open B20.C.Byte

def slice (lines : List String) (start count : Nat) : List Char :=
  ((lines.drop start).take count).flatMap String.toList

def loadTerm (i : Nat) : Expr :=
  if i = 0 then .toWord (.read "buf".toList 0)
  else .shl (.toWord (.read "buf".toList i)) (8*i)

def decodeExpr : Expr :=
  .bor (.bor (.bor (.bor (.bor (.bor (.bor (loadTerm 0) (loadTerm 1))
    (loadTerm 2)) (loadTerm 3)) (loadTerm 4)) (loadTerm 5)) (loadTerm 6)) (loadTerm 7)

def decProgram : Function := {
  returnsWord := true
  name := "dec64le".toList
  params := [.pointer true "data".toList]
  body := [.declarePointer "buf".toList true, .assignPointer "buf".toList "data".toList,
    .ret decodeExpr]
}

def storeTerm (i : Nat) : Expr :=
  .toByte (if i = 0 then .wordVar ['x'] else .shr (.wordVar ['x']) (8*i))

def encProgram : Function := {
  returnsWord := false
  name := "enc64le".toList
  params := [.pointer false "out".toList, .word ['x']]
  body := [.declarePointer "buf".toList false, .assignPointer "buf".toList "out".toList] ++
    (List.range 8).map (fun i => .store "buf".toList i (storeTerm i))
}

theorem dec_slice : slice B20.Pinned.shakeLines 56 15 = B20.Pinned.dec64leChars := by
  have h : (B20.Pinned.shakeLines.drop 56).take 15 = B20.Pinned.dec64leLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem enc_slice : slice B20.Pinned.shakeLines 75 15 = B20.Pinned.enc64leChars := by
  have h : (B20.Pinned.shakeLines.drop 75).take 15 = B20.Pinned.enc64leLines := by decide
  exact congrArg (List.flatMap String.toList) h

theorem dec_lex : B20.C.tokenize (B20.Pinned.dec64leChars.length + 1) B20.Pinned.dec64leChars =
    some B20.Pinned.dec64leTokens := by decide
theorem enc_lex : B20.C.tokenize (B20.Pinned.enc64leChars.length + 1) B20.Pinned.enc64leChars =
    some B20.Pinned.enc64leTokens := by decide

theorem dec_syntax : parseFunctionTokens B20.Pinned.dec64leTokens = some decProgram := by decide
theorem enc_syntax : parseFunctionTokens B20.Pinned.enc64leTokens = some encProgram := by decide

theorem dec_parses : parseFunction (slice B20.Pinned.shakeLines 56 15) = some decProgram := by
  rw [parseFunction, dec_slice, dec_lex]
  exact dec_syntax
theorem enc_parses : parseFunction (slice B20.Pinned.shakeLines 75 15) = some encProgram := by
  rw [parseFunction, enc_slice, enc_lex]
  exact enc_syntax

#print axioms dec_parses
#print axioms enc_parses

end B20.Word.LE
