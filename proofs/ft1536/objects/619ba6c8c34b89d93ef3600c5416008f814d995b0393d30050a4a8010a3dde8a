import Source3.KeygenIntermediateLiftData
import Source3.KeygenIntermediateTokensReduce0
import Source3.KeygenIntermediateTokensReduce1
import Source3.KeygenIntermediateTokensReduce2
import Source3.KeygenIntermediateTokensReduce3
import Source3.KeygenIntermediateTokensReduce4
import Source3.KeygenIntermediateTokensReduce5

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenIntermediateReduceData
open KeygenIntermediateExec (Stmt chain only)
open C99ArrayReference (Name)
def writable := KeygenIntermediateLiftData.writable
def parsed : Nat → Option Stmt
  | 0 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensReduce0.tokens
  | 1 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensReduce1.tokens
  | 2 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensReduce2.tokens
  | 3 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensReduce3.tokens
  | 4 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensReduce4.tokens
  | 5 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensReduce5.tokens
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD .skip
def inner : Stmt := chain [part 0,part 1,part 2,part 3,part 4,part 5]
def locals : List Name := ["maxbl_F","maxbl_G","scale_FG","scale_k","max_kx"].map String.toList
def condition := KeygenIntermediateParser.literal 1
def code : Stmt := .seq .skip (.loop condition (.scope locals [] inner) .skip)
def lines := KeygenLevelNtt.region
theorem header : Pinned.keygenLines[6220]?=some "\tfor (;;) {\n" := by decide
theorem close : Pinned.keygenLines[6352]?=some "\t}\n" := by decide
theorem header_grammar : KeygenIntermediateParser.statement 32
    (["for","(",";",";",")","{","}"].map String.toList)=
    some (.seq .skip (.loop condition (.scope [] [] .skip) .skip),[]) := by decide
theorem partition : lines 6221 133=lines 6221 1 ++ lines 6222 30 ++ lines 6252 22 ++ lines 6274 24 ++
    lines 6298 17 ++ lines 6315 19 ++ lines 6334 19 ++ lines 6353 1 := by decide
def declared (index : Nat) : List Name×List Name := if index=0 then (locals,[]) else ([],[])
def audit (index : Nat) : Option Bool := (parsed index).map (fun code =>
  only writable code && (decide (KeygenIntermediateParser.declarations code=declared index) &&
    KeygenIntermediateCoverage.statement code))
theorem parsed_part (index : Nat) (h : audit index=some true) : parsed index=some (part index) := by
  cases hp : parsed index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (index : Nat) (h : audit index=some true) : only writable (part index)=true := by
  have hp := parsed_part index h
  simp only [audit,hp,Option.map_some,Option.some.injEq] at h
  exact (Bool.and_eq_true_iff.mp h).1
theorem part_declared (index : Nat) (h : audit index=some true) :
    KeygenIntermediateParser.declarations (part index)=declared index := by
  have hp := parsed_part index h
  simp only [audit,hp,Option.map_some,Option.some.injEq] at h
  exact of_decide_eq_true (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp h).2).1
theorem part_covered (index : Nat) (h : audit index=some true) :
    KeygenIntermediateCoverage.statement (part index)=true := by
  have hp := parsed_part index h
  simp only [audit,hp,Option.map_some,Option.some.injEq] at h
  exact (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp h).2).2
end FT1536.Source3.KeygenIntermediateReduceData
