import Source3.KeygenSearchFft
import Source3.SmallintsProgram
import Source3.KeygenSmallSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Remaining non-recursive search calls: actual signed small-to-fpr loads
   and the complete FPEMU rint body. The latter is word execution only;
   this module does not assume or prove a real-rounding error bound. -/
namespace FT1536.Source3.KeygenSearchLeaves
open C99ArrayReference (State Name)
open C99ProcedureReference (Stmt Result)
open C99MemoryReference
open C99IntegerReference (Value)

def smallBody : Stmt := C99ProcedureParser.chain [
  .base (.scalar (.declare .u64 ["n".toList,"u".toList])),
  .base (.assign "n".toList (.scalar (C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList)))),
  .seq (.base (.scalar (.assign "u".toList (.literal .i32 0))))
    (.loop SmallintsProgram.condition
      (.scope [] [] (C99ProcedureParser.chain [
        .base (.store64 "x".toList (.var "u".toList)
          (.call1 "fpr_of".toList (.load16 true "f".toList (.var "u".toList))))]))
      SmallintsProgram.increment)]
def smallParsed : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop 5357).take 6).flatMap String.toList++['}']
  let tokens ← C99ProcedureParser.tokens chars
  let (code,_,rest) ← C99ProcedureParser.body KeygenSearchFft.signatures ["x".toList,"f".toList] 256 tokens
  if rest.isEmpty then pure (C99NarrowAnnotation.statement "f".toList true code) else none
def smallParams : List C99ArrayReference.Param := [
  .pointer "x".toList,.pointer "f".toList,.scalar .uint32 "logn".toList,.scalar .uint32 "ter".toList]

theorem small_header : (Pinned.keygenLines.drop 5354).take 3=
  ["static void\n","poly_small_to_fp(fpr *x, const int16_t *f, unsigned logn, unsigned ter)\n","{\n"] := by decide
theorem small_source : smallParsed=some smallBody := by decide
theorem small_writes : C99ProcedureFootprint.only KeygenSearchFft.interfaces
    KeygenSearchFft.permissions ["x".toList] smallBody=true := by decide

inductive SmallCall (before : State) (args : List C99ArrayReference.Arg) : State → Prop where
  | run (entry : State) (out : Result) (binding : C99ArrayReference.Bind before smallParams args entry)
      (body : C99ProcedureReference.Exec KeygenSearchFft.program smallBody entry out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      SmallCall before args {before with heap := out.state.heap}

theorem small_frame (before after : State) (args : List C99ArrayReference.Arg)
    (source : SmallCall before args after) (names : List Name) (block offset : Nat)
    (checked : C99PointerFootprint.arguments names ["x".toList] smallParams args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out binding body returned =>
    obtain ⟨outEntry,tablesEntry⟩ := C99PointerFootprint.bind_outside before smallParams args entry
      binding names ["x".toList] checked block offset outside tables
    have keep := KeygenSearchFft.body_frame smallBody entry out body ["x".toList] small_writes
      block offset outEntry (by simpa only [C99PointerFootprint.TablesOutside,tablesEntry] using tables)
    rw [C99ArrayReference.bind_heap before smallParams args entry binding] at keep
    exact keep.2.2

def rintBody : Option CLogic.Function := FprPrefixCalls.source 97 18
def rintCode : CLogic.Function := {
  name := "fpr_rint".toList
  result := .i64
  params := [(.u64,"x".toList)]
  body := [
    .declare .u64 ["m".toList,"d".toList],.declare .i32 ["e".toList],
    .declare .u32 ["s".toList,"dd".toList,"f".toList],
    .assign "m".toList (.bin .band (.bin .bor (.bin .shl (.var "x".toList) (.literal .i32 10))
      (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 62)))
      (.bin .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)) (.literal .i32 1))),
    .assign "e".toList (.bin .sub (.literal .i32 1085)
      (.bin .band (.cast .i32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 0x7FF))),
    .update "m".toList .band (.neg (.cast .u64 (.bin .shr
      (.cast .u32 (.bin .sub (.var "e".toList) (.literal .i32 64))) (.literal .i32 31)))),
    .update "e".toList .band (.literal .i32 63),
    .assign "d".toList (.call2 "fpr_ulsh".toList (.var "m".toList)
      (.bin .sub (.literal .i32 63) (.var "e".toList))),
    .assign "dd".toList (.bin .bor (.cast .u32 (.var "d".toList))
      (.bin .band (.cast .u32 (.bin .shr (.var "d".toList) (.literal .i32 32))) (.literal .i32 0x1FFFFFFF))),
    .assign "f".toList (.bin .bor (.cast .u32 (.bin .shr (.var "d".toList) (.literal .i32 61)))
      (.bin .shr (.bin .bor (.var "dd".toList) (.neg (.var "dd".toList))) (.literal .i32 31))),
    .assign "m".toList (.bin .add (.call2 "fpr_ursh".toList (.var "m".toList) (.var "e".toList))
      (.cast .u64 (.bin .band (.bin .shr (.literal .u32 0xC8) (.var "f".toList)) (.literal .u32 1)))),
    .assign "s".toList (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 63))),
    .ret (.bin .add (.bin .xor (.cast .i64 (.var "m".toList)) (.neg (.cast .i64 (.var "s".toList))))
      (.cast .i64 (.var "s".toList)))] }

theorem rint_source : rintBody=some rintCode := by decide
def Rint (args : List Value) (out : Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.headerCalls (C99Frontend.headerFunction rintCode) args out

end FT1536.Source3.KeygenSearchLeaves
