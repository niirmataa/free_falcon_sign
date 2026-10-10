import Source3.KeygenMakeBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete active M0 caller source closure. The AST and every named seam are
   kernel equalities, not an assumed list of gates or a callee postcondition.
   Binary syntax is retained. Codec BODIES and whole-caller execution are not
   supplied by this syntax module. -/
namespace FT1536.Source3.KeygenMakeProgram
open KeygenMakeSyntax

def code : Stmt := KeygenMakeBinding.code
theorem source_bound : KeygenMakeGrammar.Whole KeygenMakeTokens.all expectedHeader code :=
  KeygenMakeBinding.source_bound
def statements : Stmt → List Stmt
  | .skip => [] | .seq a b => statements a++statements b
  | .scope inner => statements inner | other => [other]
def outer : List Stmt := statements code
def get (xs : List Stmt) (i : Nat) : Stmt := xs[i]?.getD .skip
def attempt : Stmt := match get outer 14 with | .loop _ _ _ body => body | _ => .skip
def attemptParts : List Stmt := statements attempt
def ternary : Stmt := match get attemptParts 0 with | .branch _ yes _ => yes | _ => .skip
def binary : Stmt := match get attemptParts 0 with | .branch _ _ no => no | _ => .skip
def ternaryParts : List Stmt := statements ternary
def encoding : List Stmt := outer.drop 15
def number (n : Nat) : Expr := .number .i32 n
def varExpr (n : String) : Expr := .variable n.toList
def called (destination : Callee) (args : List Expr) : Expr := .call destination (argumentTree args)
def continuing : Stmt := .scope (.seq .continueLoop .skip)
def failCall (destination : Callee) (args : List Expr) : Stmt :=
  .branch (.unary .logicalNot (called destination args)) continuing .skip
def publicArgs : List Expr := [varExpr "h",varExpr "f",varExpr "g",varExpr "logn",varExpr "ter"]
def solveArgs : List Expr := [varExpr "fk",varExpr "F",varExpr "G",varExpr "f",varExpr "g"]
def certificateArgs : List Expr := [.cast (.pointer .fpr) (.member (varExpr "fk") "tmp".toList),
  varExpr "f",varExpr "g",varExpr "F",varExpr "G",varExpr "logn",varExpr "ter"]
def profileTest : Expr := .binary .land
  (.binary .land (varExpr "ter") (.binary .eq (varExpr "logn") (number 10)))
  (.binary .eq (varExpr "n") (number 1536))
def certificateGate : Stmt := .branch profileTest
  (.scope (.seq (failCall .certificate certificateArgs) .skip)) .skip
def expectedTail : List Stmt := [failCall .computePublic publicArgs,
  failCall .solve solveArgs,certificateGate,.breakLoop]
def attemptedLoop : Stmt := .loop .skip none .skip attempt
theorem outer_shape : outer.length=33 ∧ get outer 14=attemptedLoop := by decide +kernel
theorem dispatch_shape : attemptParts.length=5 ∧ get attemptParts 0=
    .branch (varExpr "ter") ternary binary := by decide +kernel
theorem actual_attempt_tail : attemptParts.drop 1=expectedTail := by decide +kernel
theorem actual_ternary_length : ternaryParts.length=32 := by decide +kernel
theorem actual_encoder_tail_length : encoding.length=18 := by decide +kernel

def declared : Stmt → List Object | .declare objects => objects | _ => []
def automaticObjects : List Object := (outer.flatMap declared).filter (fun o => o.count.isSome)
def expectedObjects : List Object :=
  [⟨"f".toList,.i16,some 3072⟩,⟨"g".toList,.i16,some 3072⟩,
   ⟨"F".toList,.i16,some 3072⟩,⟨"G".toList,.i16,some 3072⟩,
   ⟨"h".toList,.u16,some 3072⟩,⟨"ske".toList,.pointer .i16,some 4⟩]
def objectWidth : Ty → Nat | .i16 | .u16 => 2 | .pointer _ => 8 | _ => 0
def extent (object : Object) : Nat := objectWidth object.type*(object.count.getD 0)
theorem automatic_objects_source : automaticObjects=expectedObjects := by decide +kernel
theorem automatic_extents : automaticObjects.map extent=[6144,6144,6144,6144,6144,32] := by decide +kernel
def expectedCounter : Stmt := .write (varExpr "local_attempts") .set (number 0)
def expectedLogn : Stmt := .write (varExpr "logn") .set (.member (varExpr "fk") "logn".toList)
def expectedTer : Stmt := .write (varExpr "ter") .set (.member (varExpr "fk") "ternary".toList)
def expectedN : Stmt := .write (varExpr "n") .set (called .mkn [varExpr "logn",varExpr "ter"])
def readyGate : Stmt := .branch (.unary .logicalNot (called .ready [varExpr "fk"]))
  (.scope (.seq (.ret (number 0)) .skip)) .skip
theorem prefix_assignment_source : (outer.drop 9).take 5=
    [expectedCounter,expectedLogn,expectedTer,expectedN,readyGate] := by decide +kernel
def capIncrement : Stmt := .increment (varExpr "local_attempts")
def capTest : Expr := .binary .gt (varExpr "local_attempts") (number 3000000)
def capReturn : Stmt := .branch capTest (.scope (.seq (.ret (number 0)) .skip)) .skip
theorem cap_source : ternaryParts.take 2=[capIncrement,capReturn] := by decide +kernel
def sampled (name : String) : Stmt := .evaluate (called .sample [varExpr "fk",varExpr name,varExpr "n"])
theorem sampling_source : (ternaryParts.drop 7).take 2=[sampled "f",sampled "g"] := by decide +kernel
def resultant (name : String) : Stmt := .branch
  (.binary .eq (called .resultant [varExpr name,varExpr "logn"]) (number 0)) continuing .skip
theorem resultants_source : (ternaryParts.drop 9).take 2=[resultant "f",resultant "g"] := by decide +kernel
def normGate : Stmt := failCall .lt [varExpr "norm",varExpr "bound"]
theorem both_norm_gates_source : get ternaryParts 20=normGate ∧ get ternaryParts 31=normGate := by decide +kernel
def secretCall : Expr := called .encodeSmall [
  .binary .add (varExpr "skbuf") (varExpr "skoff"),
  .binary .sub (varExpr "klen") (varExpr "skoff"),varExpr "comp",
  .conditional (varExpr "ter") (number 18433) (number 12289),
  .index (varExpr "ske") (varExpr "i"),varExpr "logn"]
def secretIteration : Stmt := .scope (.seq (.declare [⟨"elen".toList,.size,none⟩])
  (.seq (.write (varExpr "elen") .set secretCall)
    (.seq (.branch (.binary .eq (varExpr "elen") (number 0))
      (.scope (.seq (.ret (number 0)) .skip)) .skip)
      (.seq (.write (varExpr "skoff") .add (varExpr "elen")) .skip))))
def secretLoop : Stmt := .loop (.write (varExpr "i") .set (number 0))
  (some (.binary .lt (varExpr "i") (number 4))) (.increment (varExpr "i")) secretIteration
theorem actual_four_segment_loop : get encoding 9=secretLoop := by decide +kernel
def publicCall (kind : Callee) : Expr := called kind [
  .binary .add (.cast (.pointer .byte) (varExpr "pubkey")) (number 1),
  .binary .sub (varExpr "klen") (number 1),varExpr "h",varExpr "logn"]
def publicDispatch : Stmt := .branch (varExpr "ter")
  (.scope (.seq (.write (varExpr "klen") .set (publicCall .encodeT)) .skip))
  (.scope (.seq (.write (varExpr "klen") .set (publicCall .encodeB)) .skip))
theorem actual_public_dispatch : get encoding 14=publicDispatch := by decide +kernel
def capacityTest : Expr := .binary .lt (varExpr "klen") (number 1)
def capacityReturn : Stmt := .branch capacityTest (.scope (.seq (.ret (number 0)) .skip)) .skip
theorem post_acceptance_capacity_tests : get encoding 2=capacityReturn ∧ get encoding 12=capacityReturn := by decide +kernel
theorem final_return_source : get encoding 17=.ret (number 1) := by decide +kernel

/- Negative syntax controls: foreign destinations, wrong arities, trailing
   bytes and an unsupported statement cannot be discarded as whitespace. -/
theorem foreign_call_rejected : parse "int f(int i) { arbitrary(i); }".toList=none := by decide +kernel
theorem wrong_ready_arity_rejected : parse "int f(int i) { rng_ready(i, i); }".toList=none := by decide +kernel
theorem trailing_tokens_rejected : parse "int f(int i) { return 1; } return 0;".toList=none := by decide +kernel
theorem unsupported_statement_rejected : parse "int f(int i) { goto done; }".toList=none := by decide +kernel
def signedLongExpr : Option (Expr × List B20.C.Token) :=
  (tokens "73732L * (long)n".toList).bind (expression 24 0)
def expectedSignedLong : Expr := .binary .mul (.number .long 73732) (.cast .long (varExpr "n"))
theorem signed_long_retained : signedLongExpr=some (expectedSignedLong,[]) := by decide +kernel

end FT1536.Source3.KeygenMakeProgram
