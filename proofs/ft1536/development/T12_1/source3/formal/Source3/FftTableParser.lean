import Source3.FftGlobalScalars

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftTableParser
open B20.C (Token)

inductive Table where
  | square | cubic
  deriving DecidableEq, Repr

def start : Table → Nat | .square => 1446 | .cubic => 2473
def rowCount : Table → Nat | .square => 1024 | .cubic => 2048
def chunkCount : Table → Nat | .square => 32 | .cubic => 64
def rows (table : Table) : List String := (Pinned.fprLines.drop (start table-1)).take (rowCount table)

def word (token : Token) : Option (BitVec 64) := do
  match ← CLogicParser.number token with
  | .literal .u64 n => pure (BitVec.ofNat 64 n)
  | _ => none
def pairTokens : List Token → Option (BitVec 64×BitVec 64)
  | [name,['('],real,[','],imag,[')']] | [name,['('],real,[','],imag,[')'],[',']] =>
      if name="FPC".toList then do pure (← word real,← word imag) else none
  | _ => none
def pair (line : String) : Option (BitVec 64×BitVec 64) :=
  (CLogicParser.tokenize (line.length+1) line.toList).bind pairTokens

def chunk (table : Table) (index : Nat) : List String := ((rows table).drop (32*index)).take 32
def parsedChunk (table : Table) (index : Nat) : Option (List (BitVec 64×BitVec 64)) := (chunk table index).mapM pair
def CheckedChunk (table : Table) (index : Nat) : Prop := (parsedChunk table index).map List.length=some 32
instance (table : Table) (index : Nat) : Decidable (CheckedChunk table index) :=
  inferInstanceAs (Decidable ((parsedChunk table index).map List.length=some 32))

theorem square_header : Pinned.fprLines[1444]?=some "static const fpr fpr_gm3_square[] = {\n" := by decide
theorem cubic_header : Pinned.fprLines[2471]?=some "static const fpr fpr_gm3_cubic[] = {\n" := by decide
theorem square_footer : Pinned.fprLines[2469]?=some "};\n" := by decide
theorem cubic_footer : Pinned.fprLines[4520]?=some "};\n" := by decide
theorem rows_length (table : Table) : (rows table).length=rowCount table := by cases table <;> decide

theorem checked_defined (table : Table) (index : Nat) (h : CheckedChunk table index) :
    ∃ values, parsedChunk table index=some values ∧ values.length=32 := by
  obtain ⟨values,parsed,length⟩ := Option.map_eq_some_iff.mp h
  exact ⟨values,parsed,length⟩

end FT1536.Source3.FftTableParser
