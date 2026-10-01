import Source3.C99NarrowAnnotation
import Source3.FftProcedureFrames
import Source3.SmallintsConversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.SmallintsProgram
open C99ArrayReference (Name State)
open C99ProcedureReference (Stmt Function Exec Result)

def sourceBody : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop 7431).take 5).flatMap String.toList++['}']
  let ts ← C99ProcedureParser.tokens chars
  let (code,_,rest) ← C99ProcedureParser.body FftProcedurePrograms.signatures ["r".toList,"t".toList] 256 ts
  if rest.isEmpty then pure (C99NarrowAnnotation.statement "t".toList true code) else none

def skip : Stmt := .base .skip
def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)
def increment : Stmt := .base (.scalar (.update "u".toList .add (.literal .i32 1)))
def store : C99ArrayReference.Stmt := .store64 "r".toList (.var "u".toList)
  (.call1 "fpr_of".toList (.load16 true "t".toList (.var "u".toList)))
def iteration : Stmt := .scope [] [] (.seq (.base store) skip)
def loop : Stmt := .loop condition iteration increment
def initialCounter : Stmt := .base (.scalar (.assign "u".toList (.literal .i32 0)))
def body : Stmt := .seq (.base (.scalar (.declare .u64 ["n".toList,"u".toList])))
  (.seq (.base (.assign "n".toList (.scalar (C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList)))))
    (.seq (.seq initialCounter loop) skip))
def function : Function :=
  ⟨[.pointer "r".toList,.pointer "t".toList,.scalar .uint32 "logn".toList,.scalar .uint32 "ter".toList],none,body⟩

theorem source_header : (Pinned.keygenLines.drop 7428).take 3 =
    ["static void\n","smallints_to_fpr_keygen(fpr *r, const int16_t *t, unsigned logn, unsigned ter)\n","{\n"] := by decide
theorem source_body : sourceBody=some body := by decide
theorem checked_writes : C99ProcedureFootprint.only FftProcedureFrames.interfaces
    FftProcedureFrames.permissions ["r".toList] body=true := by decide

theorem source_frame (before : State) (result : Result)
    (source : Exec FftProcedurePrograms.program body before result) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before ["r".toList] block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    result.state.heap.bytes block offset=before.heap.bytes block offset :=
  (C99ProcedureFootprint.body_frame FftProcedurePrograms.program FftProcedureFrames.interfaces
    FftProcedureFrames.permissions FftProcedureFrames.aligned FftProcedureFrames.closed body before result
    source ["r".toList] checked_writes block offset outside tables).2.2

end FT1536.Source3.SmallintsProgram
