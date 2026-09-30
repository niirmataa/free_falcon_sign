import Source3.FprPrimitives

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprPrimitivesAudit
open FT1536.Source3.FprPrimitives

/- Public synthetic executions; computations here are diagnostics, not
   arithmetic-correctness proofs. The parser/evaluator run the pinned code. -/
#eval add 0x3ff0000000000000#64 0x4000000000000000#64
#eval mul 0x4000000000000000#64 0x4008000000000000#64
#eval div 0x4018000000000000#64 0x4000000000000000#64

private def addSignMutant : Option Function :=
  parseFunction ((((FprPinned.cLines.drop 447).take 107).set 66
    "\txu += yu;\n").flatMap String.toList)
private def mulNormalizeMutant : Option Function :=
  parseFunction ((((FprPinned.cLines.drop 679).take 95).set 56
    "\tzu = zv;\n").flatMap String.toList)

#eval call addSignMutant 0x4000000000000000#64 0xbff0000000000000#64
#eval add 0x4000000000000000#64 0xbff0000000000000#64
#eval call mulNormalizeMutant 0x3ff0000000000000#64 0x3ff0000000000000#64
#eval mul 0x3ff0000000000000#64 0x3ff0000000000000#64

/- Full kernel reduction of the add mutant exhausts the 6144 MiB step;
   preserve that failed log and retain its two separately executed outputs. -/
theorem add_sign_mutant_changes_source :
    FprPinned.cLines[513]? != some "\txu += yu;\n" := by decide

theorem mul_normalize_mutation_changes_word :
    call mulNormalizeMutant 0x3ff0000000000000#64 0x3ff0000000000000#64 =
      some 0x0008000000000000#64 ∧
    mul 0x3ff0000000000000#64 0x3ff0000000000000#64 =
      some 0x3ff0000000000000#64 := by
  constructor <;> decide
#eval div 0x0000000000000000#64 0x3ff0000000000000#64

private def divPrefix (n : Nat) : Option (B20.C.Scalar.State × Option B20.C.Val) := do
  let f ← divProgram
  let s ← B20.C.Scalar.bindArgs f.params
    [.u64 0x4018000000000000#64, .u64 0x4000000000000000#64]
  execBlock 256 f.result (f.body.take n) s

#eval divProgram.map (fun f => f.body.length)
#eval (List.range 22).map (fun n => (n, (divPrefix n).isSome))

/- Source mutation of the ulsh helper changes a public 1 << 32 call.
   Unlike a token-only check, the mutant is separately parsed and run. -/
private def shiftMutant : List Char :=
  (((Pinned.fprLines.drop 31).take 6).set 3
    "\tx ^= (x ^ (x << 31)) & -(uint64_t)(n >> 5);\n").flatMap String.toList

theorem ulsh_mutant_output : (FT1536.Source3.CLogicParser.parseFunction shiftMutant).bind
    (fun f => FT1536.Source3.CLogic.execute (fun _ _ => none) f
      [.u64 1,.i32 32]) = some (.u64 0x80000000) := by decide

theorem ulsh_source_output : ulsh.bind (fun f => FT1536.Source3.CLogic.execute (fun _ _ => none) f
      [.u64 1,.i32 32]) = some (.u64 0x100000000) := by decide

theorem detects_ulsh_mutant :
    (FT1536.Source3.CLogicParser.parseFunction shiftMutant).bind
      (fun f => FT1536.Source3.CLogic.execute (fun _ _ => none) f [.u64 1,.i32 32]) !=
    ulsh.bind (fun f => FT1536.Source3.CLogic.execute (fun _ _ => none) f [.u64 1,.i32 32]) := by
  rw [ulsh_mutant_output,ulsh_source_output]
  decide

/- The 54-step mutant is valid syntax but the output differs from the
   pinned 55-step implementation, on a defined 6/2 public input. -/
private def div54Program : Option Function :=
  parseFunction ((((FprPinned.cLines.drop 914).take 86).set 16
    "\tfor (i = 0; i < 54; i ++) {\n").flatMap String.toList)

#eval call div54Program 0x4018000000000000#64 0x4000000000000000#64
#eval div 0x4018000000000000#64 0x4000000000000000#64

theorem div_54_changes_word :
    call div54Program 0x4018000000000000#64 0x4000000000000000#64 =
      some 0x3ff8000000000000#64 ∧
    div 0x4018000000000000#64 0x4000000000000000#64 =
      some 0x4008000000000000#64 := by
  constructor <;> decide

#print axioms FT1536.Source3.FprPrimitivesAudit.ulsh_mutant_output
#print axioms FT1536.Source3.FprPrimitivesAudit.ulsh_source_output
#print axioms FT1536.Source3.FprPrimitivesAudit.detects_ulsh_mutant
#print axioms FT1536.Source3.FprPrimitivesAudit.div_54_changes_word
#print axioms FT1536.Source3.FprPrimitivesAudit.add_sign_mutant_changes_source
#print axioms FT1536.Source3.FprPrimitivesAudit.mul_normalize_mutation_changes_word

end FT1536.Source3.FprPrimitivesAudit
