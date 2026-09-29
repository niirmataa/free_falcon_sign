import B20.C.ScalarParser
import B20.Fpr.ParsedPrograms
import B20.Pinned.Header
import B20.Pinned.ScalarSlices

set_option maxRecDepth 16384
set_option maxHeartbeats 8000000

namespace B20.Fpr.Parsed
open B20.C.Scalar
open B20.Pinned

def slice (start count : Nat) : List Char :=
  ((headerLines.drop start).take count).flatMap String.toList

theorem pack_slice : slice 38 17 = packChars := by
  have h : (headerLines.drop 38).take 17 = packLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem rint_slice : slice 97 18 = rintChars := by
  have h : (headerLines.drop 97).take 18 = rintLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem floor_slice : slice 116 19 = floorChars := by
  have h : (headerLines.drop 116).take 19 = floorLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem sub_slice : slice 152 6 = subChars := by
  have h : (headerLines.drop 152).take 6 = subLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem neg_slice : slice 159 6 = negChars := by
  have h : (headerLines.drop 159).take 6 = negLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem half_slice : slice 166 10 = halfChars := by
  have h : (headerLines.drop 166).take 10 = halfLines := by decide
  exact congrArg (List.flatMap String.toList) h
theorem double_slice : slice 177 6 = doubleChars := by
  have h : (headerLines.drop 177).take 6 = doubleLines := by decide
  exact congrArg (List.flatMap String.toList) h

theorem pack_lex : tokenize (packChars.length + 1) packChars = some packTokens := by decide
theorem rint_lex : tokenize (rintChars.length + 1) rintChars = some rintTokens := by decide
theorem floor_lex : tokenize (floorChars.length + 1) floorChars = some floorTokens := by decide
theorem sub_lex : tokenize (subChars.length + 1) subChars = some subTokens := by decide
theorem neg_lex : tokenize (negChars.length + 1) negChars = some negTokens := by decide
theorem half_lex : tokenize (halfChars.length + 1) halfChars = some halfTokens := by decide
theorem double_lex : tokenize (doubleChars.length + 1) doubleChars = some doubleTokens := by decide

theorem pack_syntax : parseFunctionTokens packTokens = some packProgram := by decide
theorem rint_syntax : parseFunctionTokens rintTokens = some rintProgram := by decide
theorem floor_syntax : parseFunctionTokens floorTokens = some floorProgram := by decide
theorem sub_syntax : parseFunctionTokens subTokens = some subProgram := by decide
theorem neg_syntax : parseFunctionTokens negTokens = some negProgram := by decide
theorem half_syntax : parseFunctionTokens halfTokens = some halfProgram := by decide
theorem double_syntax : parseFunctionTokens doubleTokens = some doubleProgram := by decide

theorem pack_parses : parseFunction (slice 38 17) = some packProgram := by
  rw [parseFunction, pack_slice, pack_lex]; exact pack_syntax
theorem rint_parses : parseFunction (slice 97 18) = some rintProgram := by
  rw [parseFunction, rint_slice, rint_lex]; exact rint_syntax
theorem floor_parses : parseFunction (slice 116 19) = some floorProgram := by
  rw [parseFunction, floor_slice, floor_lex]; exact floor_syntax
theorem sub_parses : parseFunction (slice 152 6) = some subProgram := by
  rw [parseFunction, sub_slice, sub_lex]; exact sub_syntax
theorem neg_parses : parseFunction (slice 159 6) = some negProgram := by
  rw [parseFunction, neg_slice, neg_lex]; exact neg_syntax
theorem half_parses : parseFunction (slice 166 10) = some halfProgram := by
  rw [parseFunction, half_slice, half_lex]; exact half_syntax
theorem double_parses : parseFunction (slice 177 6) = some doubleProgram := by
  rw [parseFunction, double_slice, double_lex]; exact double_syntax

#print axioms pack_parses
#print axioms rint_parses
#print axioms floor_parses
#print axioms sub_parses
#print axioms neg_parses
#print axioms half_parses
#print axioms double_parses

end B20.Fpr.Parsed
