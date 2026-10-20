import Source3.StablePositive

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.LeafRange
open B20.C CLogic KeygenHelpers

/- Checked object-like UINT64_C constant declarations for the pinned LP64
profile. The definitions are read from the actual source lines below. -/
def parseU64Macro (line : String) : Option (B20.C.Name × BitVec 64) :=
  match line.toList with
  | '#'::cs => do
      let ts ← CLogicParser.tokenize (cs.length+1) cs
      match ts with
      | directive::name::constructor::['(']::number::[')']::[] =>
          if directive="define".toList ∧ constructor="UINT64_C".toList then do
            match ← B20.C.Scalar.number number with
            | .literal _ n => pure (name,BitVec.ofNat 64 n)
            | _ => none
          else none
      | _ => none
  | _ => none

def lowerName : B20.C.Name := "FT1536_LEAF_MIN_BITS".toList
def upperName : B20.C.Name := "FT1536_LEAF_MAX_BITS".toList

theorem lower_macro_source : (Pinned.keygenLines[7443]?).bind parseU64Macro=
    some (lowerName,Run2.KeygenLeafGate.lowerBits) := by decide
theorem upper_macro_source : (Pinned.keygenLines[7444]?).bind parseU64Macro=
    some (upperName,Run2.KeygenLeafGate.upperBits) := by decide

def macros : Env := fun name =>
  if name=lowerName then some (.u64 Run2.KeygenLeafGate.lowerBits)
  else if name=upperName then some (.u64 Run2.KeygenLeafGate.upperBits)
  else none

def tail : List CLogic.Stmt := [
  .assign "valid".toList (.cast .u32 (.bin .xor (.literal .i32 1)
    (.cast .u32 (.bin .shr (.bin .sub (.var "bits".toList) (.var lowerName)) (.literal .i32 63))))),
  .update "valid".toList .band (.cast .u32 (.bin .xor (.literal .i32 1)
    (.cast .u32 (.bin .shr (.bin .sub (.var upperName) (.var "bits".toList)) (.literal .i32 63))))),
  .update "bad".toList .bor (.bin .xor (.var "valid".toList) (.literal .u32 1))]

def parseTail (chars : List Char) : Option (List CLogic.Stmt) := do
  let tokens ← CLogicParser.tokenize (chars.length+1) chars
  let (stmts,rest) ← CLogicParser.body 64 tokens
  if rest.isEmpty then pure stmts else none

theorem source_parses : parseTail (slice 7769 6)=some tail := by decide

def initial (w : BitVec 64) (bad : BitVec 32) : B20.C.Scalar.State where
  types name := if name="bits".toList then some .u64
    else if name="valid".toList ∨ name="bad".toList then some .u32 else none
  values name := if name="bits".toList then some (.u64 w)
    else if name="bad".toList then some (.u32 bad) else macros name

def runStmts (calls : B20.C.Scalar.Calls) : List CLogic.Stmt → B20.C.Scalar.State → Option B20.C.Scalar.State
  | [],s => some s
  | stmt::rest,s => do runStmts calls rest (← CLogic.step calls s stmt)

def runTail (calls : B20.C.Scalar.Calls) (code : List CLogic.Stmt) (w : BitVec 64) (bad : BitVec 32) :
    Option (BitVec 32 × BitVec 32) := do
  let st ← runStmts calls code (initial w bad)
  match ← st.values "valid".toList, ← st.values "bad".toList with
  | .u32 valid,.u32 flag => pure (valid,flag)
  | _,_ => none

theorem execute_tail (calls : B20.C.Scalar.Calls) (w : BitVec 64) (bad : BitVec 32) :
    runTail calls tail w bad=some (Run2.KeygenLeafGate.rangeValid w,
      bad ||| (Run2.KeygenLeafGate.rangeValid w ^^^ 1#32)) := by
  simp [runTail,runStmts,tail,initial,CLogic.step,CLogic.eval,
    B20.C.Scalar.assign,B20.C.update,macros,lowerName,upperName,
    B20.C.bin,B20.C.shift,B20.C.commonTy,B20.C.Val.ty,B20.C.cast,B20.C.literalValue,
    B20.C.bitsOp,Run2.KeygenLeafGate.rangeValid]

theorem source_refines (calls : B20.C.Scalar.Calls) (w : BitVec 64) (bad : BitVec 32) :
    (parseTail (slice 7769 6)).bind (fun code => runTail calls code w bad)=
      some (Run2.KeygenLeafGate.rangeValid w,bad ||| (Run2.KeygenLeafGate.rangeValid w ^^^ 1#32)) := by
  rw [source_parses,Option.bind_some,execute_tail]

end FT1536.Source3.LeafRange

#print FT1536.Source3.LeafRange.source_refines
#print axioms FT1536.Source3.LeafRange.lower_macro_source
#print axioms FT1536.Source3.LeafRange.upper_macro_source
#print axioms FT1536.Source3.LeafRange.source_refines
