import Source3.KeygenNttWordAlgebra

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenFirstPrime

def natural (token : B20.C.Token) : Option Nat := do
  match ← CLogicParser.number token with
  | .literal .i32 n => pure n
  | _ => none

def parsed : Option (Nat×Nat×Nat) := do
  let line ← Pinned.keygenLines[1369]?
  let tokens ← CLogicParser.tokenize (line.length+1) line.toList
  match tokens with
  | [['{'],p,[','],g,[','],s,['}'],[',']] => pure (← natural p,← natural g,← natural s)
  | _ => none

def generator : BitVec 32 := 1907584673
theorem table_header : Pinned.keygenLines[1368]?=some "static const small_prime PRIMES3[] = {\n" := by decide
theorem first_entry : parsed=some (KeygenNinv31.prime.toNat,generator.toNat,127999) := by decide

end FT1536.Source3.KeygenFirstPrime
