import Source3.KeygenIntermediateTokensLift0
import Source3.KeygenIntermediateTokensLift1
import Source3.KeygenIntermediateTokensLift2
import Source3.KeygenIntermediateTokensLift3
import Source3.KeygenIntermediateTokensLift4
import Source3.KeygenIntermediateTokensLift5
import Source3.KeygenIntermediateCoverage

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenIntermediateLiftData
open KeygenIntermediateExec (Stmt chain only)
open C99ArrayReference (Name)
def writable : List Name := ["Fd","Gd","Ft","Gt","ft","gt","t1","x","y","k",
  "xs","ys","xd","yd","gm","igm","fx","gx","Fp","Gp","rt1","rt2","rt3","rt4","rt5",
  "primes","PRIMES2","PRIMES3"].map String.toList
def parsed : Nat → Option Stmt
  | 0 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensLift0.tokens
  | 1 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensLift1.tokens
  | 2 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensLift2.tokens
  | 3 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensLift3.tokens
  | 4 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensLift4.tokens
  | 5 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensLift5.tokens
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD .skip
def inner : Stmt := chain [part 0,part 1,part 2,part 3,part 4,part 5]
def locals : List Name := ["p","p0i","R2","v"].map String.toList
def pointers : List Name := ["gm","igm","fx","gx","Fp","Gp"].map String.toList
def initial : Stmt := .assign "u".toList (KeygenIntermediateParser.literal 0)
def condition : KeygenIntermediateCalls.Expr := .word (.cmp .lt (.scalar (.var "u".toList)) (.scalar (.var "llen".toList)))
def increment : Stmt := .scalar (.update "u".toList .add (.literal .i32 1))
def code : Stmt := .seq initial (.loop condition (.scope locals pointers inner) increment)
def lines := KeygenLevelNtt.region
theorem comments : KeygenZintTop.tokens ((lines 5916 7).flatMap String.toList)=some [] := by decide
theorem header : Pinned.keygenLines[5922]?=some "\tfor (u = 0; u < llen; u ++) {\n" := by decide
theorem close : Pinned.keygenLines[6117]?=some "\t}\n" := by decide
theorem header_grammar : KeygenIntermediateParser.statement 32
    (["for","(","u","=","0",";","u","<","llen",";","u","++",")","{","}"].map String.toList)=
    some (.seq initial (.loop condition (.scope [] [] .skip) increment),[]) := by decide
theorem partition : lines 5916 203=lines 5916 7 ++ lines 5923 1 ++ lines 5924 31 ++ lines 5955 6 ++
    lines 5961 42 ++ lines 6003 21 ++ lines 6024 87 ++ lines 6111 7 ++ lines 6118 1 := by decide
def declared (index : Nat) : List Name×List Name := if index=0 then (locals,pointers) else ([],[])
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
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
end FT1536.Source3.KeygenIntermediateLiftData
