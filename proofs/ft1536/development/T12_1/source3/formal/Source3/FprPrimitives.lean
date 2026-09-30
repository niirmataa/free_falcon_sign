import Source3.StableBinary
import Source3.FprCSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprPrimitives
open FT1536.Source3 B20.C

def hslice (line count : Nat) : List Char :=
  ((Pinned.fprLines.drop (line-1)).take count).flatMap String.toList
def cslice (line count : Nat) : List Char :=
  ((FprPinned.cLines.drop (line-1)).take count).flatMap String.toList

def ursh := CLogicParser.parseFunction (hslice 18 6)
def ulsh := CLogicParser.parseFunction (hslice 32 6)
def pack := CLogicParser.parseFunction (hslice 39 17)

theorem header_word_typedef :
    Pinned.fprLines[15]? = some "typedef uint64_t fpr;\n" := by decide

theorem ursh_parsed : ursh.isSome := by decide
theorem ulsh_parsed : ulsh.isSome := by decide
theorem pack_parsed : pack.isSome := by decide

def headerCalls : B20.C.Scalar.Calls := fun name args =>
  if name = "fpr_ursh".toList then do CLogic.execute (fun _ _ => none) (← ursh) args
  else if name = "fpr_ulsh".toList then do CLogic.execute (fun _ _ => none) (← ulsh) args
  else if name = "FPR".toList then do CLogic.execute (fun _ _ => none) (← pack) args
  else none

/- Function body uses the P02 typed expression parser for ordinary scalar
   statements. Only the actual C `for` and preprocessor macro-call syntaxes
   need extra constructors; an unrecognized token rejects the *whole* body. -/
inductive Instr where
  | scalar (stmt : CLogic.Stmt)
  | norm (mant exponent : Name)
  | forInc (index : Name) (limit : Nat) (body : List Instr)

structure Function where
  name : Name
  result : Ty
  params : List (Ty × Name)
  body : List Instr

def macroChars : List Char :=
  (((FprPinned.cLines.drop 21).take 32).flatMap String.toList).filter (· != '\\')

def substitute (mant exponent : Name) : List Token → List Token
  | ['('] :: ['m'] :: [')'] :: ts => mant :: substitute mant exponent ts
  | ['('] :: ['e'] :: [')'] :: ts => exponent :: substitute mant exponent ts
  | t :: ts => t :: substitute mant exponent ts
  | [] => []

def scalarBody : Nat → List Token → Option (List CLogic.Stmt)
  | 0, _ => none
  | _+1, [] => some []
  | fuel+1, ts => do
      let (stmt, rest) ← CLogicParser.statement ts
      let tail ← scalarBody fuel rest
      pure (stmt :: tail)

def normStatements (mant exponent : Name) : Option (List CLogic.Stmt) := do
  if FprPinned.cLines[20]? != some "#define FPR_NORM64(m, e)   do { \\\n" ||
     FprPinned.cLines[53]? != some "\t} while (0)\n" then none else do
  let tokens ← CLogicParser.tokenize (macroChars.length+1) macroChars
  scalarBody 64 (substitute mant exponent tokens)

/- The #define wrapper is checked, not silently replaced by a new body.
   Lines 22--53 become the statements after parameter substitution. -/
theorem macro_wrapper :
    FprPinned.cLines[20]? = some "#define FPR_NORM64(m, e)   do { \\\n" ∧
    FprPinned.cLines[53]? = some "\t} while (0)\n" := by decide

theorem norm_parsed : (normStatements "xu".toList "ex".toList).isSome := by decide

def numberLimit (token : Token) : Option Nat := do
  match ← B20.C.Scalar.number token with
  | .literal .i32 n => some n
  | _ => none

def parseBody : Nat → List Token → Option (List Instr × List Token)
  | 0, _ => none
  | _+1, ['}'] :: ts => some ([],ts)
  | fuel+1, ['f','o','r'] :: ['('] :: idx :: ['='] :: ['0'] :: [';'] ::
      idx2 :: ['<'] :: bound :: [';'] :: idx3 :: ['+'] :: ['+'] :: [')'] :: ['{'] :: ts => do
      if idx != idx2 || idx != idx3 then none else do
        let n ← numberLimit bound
        let (inside,rest) ← parseBody fuel ts
        let (following,tail) ← parseBody fuel rest
        pure (.forInc idx n inside :: following,tail)
  | fuel+1, ['F','P','R','_','N','O','R','M','6','4'] :: ['('] :: mant :: [','] :: exp :: [')'] :: [';'] :: ts => do
      let (following,tail) ← parseBody fuel ts
      pure (.norm mant exp :: following,tail)
  | fuel+1, ts => do
      let (stmt,rest) ← CLogicParser.statement ts
      let (following,tail) ← parseBody fuel rest
      pure (.scalar stmt :: following,tail)

def parseTokens : List Token → Option Function
  | ty :: name :: ['('] :: ts => do
      let result ← B20.C.Scalar.typeToken ty
      let (ps,rest) ← B20.C.Scalar.params 16 ts
      match rest with
      | ['{'] :: body => do
          let (stmts,rest) ← parseBody 128 body
          if rest.isEmpty then some ⟨name,result,ps,stmts⟩ else none
      | _ => none
  | _ => none

def parseFunction (chars : List Char) : Option Function := do
  parseTokens (← CLogicParser.tokenize (chars.length+1) chars)

def namedBinary (wanted : Name) (p : Option Function) : Option Function := do
  let f ← p
  if f.name != wanted || f.result != .u64 ||
      f.params != [(.u64,"x".toList),(.u64,"y".toList)] then none else some f

def m0Active : Bool :=
  Pinned.fprLines[15]? == some "typedef uint64_t fpr;\n" &&
  FprPinned.cLines[7]? == some "#ifndef FALCON_ASM_CORTEXM4\n" &&
  FprPinned.cLines[8]? == some "#define FALCON_ASM_CORTEXM4 0\n" &&
  FprPinned.cLines[207]? == some "#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1\n" &&
  FprPinned.cLines[445]? == some "#else // yyyASM_CORTEXM4+0\n" &&
  FprPinned.cLines[555]? == some "#endif // yyyASM_CORTEXM4-\n" &&
  FprPinned.cLines[557]? == some "#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1\n" &&
  FprPinned.cLines[677]? == some "#else // yyyASM_CORTEXM4+0\n" &&
  FprPinned.cLines[775]? == some "#endif // yyyASM_CORTEXM4-\n" &&
  FprPinned.cLines[777]? == some "#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1\n" &&
  FprPinned.cLines[912]? == some "#else // yyyASM_CORTEXM4+0\n" &&
  FprPinned.cLines[1001]? == some "#endif // yyyASM_CORTEXM4-\n"

theorem m0_active : m0Active = true := by decide

def addProgram := if m0Active then namedBinary "fpr_add".toList (parseFunction (cslice 448 107)) else none
def mulProgram := if m0Active then namedBinary "fpr_mul".toList (parseFunction (cslice 680 95)) else none
def divProgram := if m0Active then namedBinary "fpr_div".toList (parseFunction (cslice 915 86)) else none

theorem add_parsed : addProgram.isSome := by decide
theorem mul_parsed : mulProgram.isSome := by decide
theorem div_parsed : divProgram.isSome := by decide

theorem div_55_source_guard :
    FprPinned.cLines[930]? = some "\tfor (i = 0; i < 55; i ++) {\n" := by decide

theorem div_54_mutant_differs :
    FprPinned.cLines[930]? ≠ some "\tfor (i = 0; i < 54; i ++) {\n" := by decide

/- Value-only C99/LP64 scalar semantics: B20.C.bin rejects signed
   overflow and invalid shifts; a local declaration cannot address caller
   memory. The forInc evaluator explicitly checks the 55 true guards and
   the final false guard, rather than treating 55 as an opaque call. -/
def execScalar (s : B20.C.Scalar.State) (stmt : CLogic.Stmt) : Option B20.C.Scalar.State :=
  CLogic.step headerCalls s stmt

def execScalars : List CLogic.Stmt → B20.C.Scalar.State → Option B20.C.Scalar.State
  | [], s => some s
  | stmt :: tail,s => do execScalars tail (← execScalar s stmt)

def scalarDecls : List CLogic.Stmt → List Name
  | [] => []
  | .declare _ names :: tail => names ++ scalarDecls tail
  | _ :: tail => scalarDecls tail

def blockDecls : List Instr → List Name
  | [] => []
  | .scalar (.declare _ names) :: tail => names ++ blockDecls tail
  | _ :: tail => blockDecls tail

/- C block lifetime: a declaration in the body of a for-loop is fresh on
   every iteration. The scalar interpreter stores locals in a typed map, so
   leaving the block restores their previous bindings (normally `none`). -/
def leaveBlock (before after : B20.C.Scalar.State) (names : List Name) : B20.C.Scalar.State :=
  ⟨fun name => if names.contains name then before.types name else after.types name,
   fun name => if names.contains name then before.values name else after.values name⟩

def inc (name : Name) (s : B20.C.Scalar.State) : Option B20.C.Scalar.State := do
  B20.C.Scalar.assign s name (← B20.C.bin .add (← s.values name) (.i32 1))

def guard (name : Name) (bound : Nat) (s : B20.C.Scalar.State) : Option Bool := do
  let v ← s.values name
  pure (CLogic.truth (CLogic.compare .lt v (.i32 (BitVec.ofNat 32 bound))))

def execBlock : Nat → Ty → List Instr → B20.C.Scalar.State → Option (B20.C.Scalar.State × Option Val)
  | 0, _, _, _ => none
  | _+1, _, [],s => some (s,none)
  | _+1, result, .scalar (.ret e) :: _,s => do
      let v ← CLogic.eval headerCalls s.values 32 e
      some (s,some (B20.C.cast result v))
  | fuel+1, result, .scalar stmt :: rest,s => do
      execBlock fuel result rest (← execScalar s stmt)
  | fuel+1, result, .norm mant exp :: rest,s => do
      let body ← normStatements mant exp
      let next ← execScalars body s
      execBlock fuel result rest (leaveBlock s next (scalarDecls body))
  | fuel+1, result, .forInc name n body :: rest,s => do
      let s ← B20.C.Scalar.assign s name (.i32 0)
      let s ← (List.range n).foldlM (fun acc _ => do
        if !(← guard name n acc) then none else do
          let (next, v) ← execBlock fuel result body acc
          if v.isSome then none else inc name (leaveBlock acc next (blockDecls body))) s
      if (← guard name n s) then none else execBlock fuel result rest s

def execute (f : Function) (args : List Val) : Option Val := do
  let s ← B20.C.Scalar.bindArgs f.params args
  let (_, out) ← execBlock 256 f.result f.body s
  out

def call (p : Option Function) (x y : BitVec 64) : Option (BitVec 64) := do
  match ← execute (← p) [.u64 x,.u64 y] with
  | .u64 w => some w
  | _ => none

def add := call addProgram
def mul := call mulProgram
def div := call divProgram

/- A callee's evaluator has no heap argument. Its only state contains its
   own typed local variables; the source functions' ASTs have no pointer
   parameters, dereferences, stores, globals or external memory calls. -/
def callerCall (p : Option Function) (x y : BitVec 64) (m : α) : Option (BitVec 64 × α) :=
  (call p x y).map (·,m)

theorem caller_frame (p : Option Function) (x y z : BitVec 64) (m m' : α)
    (h : callerCall p x y m=some (z,m')) : m'=m := by
  unfold callerCall at h
  cases hc : call p x y with
  | none => simp [hc] at h
  | some w =>
      simp only [hc, Option.map_some, Option.some.injEq, Prod.mk.injEq] at h
      exact h.2.symm

theorem source_add_caller_frame (x y z : BitVec 64) (m m' : α)
    (h : callerCall addProgram x y m=some (z,m')) : m'=m := caller_frame addProgram x y z m m' h
theorem source_mul_caller_frame (x y z : BitVec 64) (m m' : α)
    (h : callerCall mulProgram x y m=some (z,m')) : m'=m := caller_frame mulProgram x y z m m' h
theorem source_div_caller_frame (x y z : BitVec 64) (m m' : α)
    (h : callerCall divProgram x y m=some (z,m')) : m'=m := caller_frame divProgram x y z m m' h

end FT1536.Source3.FprPrimitives

#check @FT1536.Source3.FprPrimitives.add
#check @FT1536.Source3.FprPrimitives.mul
#check @FT1536.Source3.FprPrimitives.div
#print axioms FT1536.Source3.FprPrimitives.add_parsed
#print axioms FT1536.Source3.FprPrimitives.mul_parsed
#print axioms FT1536.Source3.FprPrimitives.div_parsed
#print axioms FT1536.Source3.FprPrimitives.norm_parsed
#print axioms FT1536.Source3.FprPrimitives.macro_wrapper
#print axioms FT1536.Source3.FprPrimitives.m0_active
#print axioms FT1536.Source3.FprPrimitives.caller_frame
#print axioms FT1536.Source3.FprPrimitives.source_add_caller_frame
#print axioms FT1536.Source3.FprPrimitives.source_mul_caller_frame
#print axioms FT1536.Source3.FprPrimitives.source_div_caller_frame
