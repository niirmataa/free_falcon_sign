import Source3.ShakeExtractSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Generated source/token/initializer bindings. Every equality is kernel checked. -/
namespace FT1536.Source3.ShakeRcBinding
open ShakeExtractSource

def rcPair (i : Fin 12) : Option (List (BitVec 64)) :=
  (ShakeSource.sourceLines[39+i.val]?).bind (fun line =>
    (C99ProcedureParser.tokens line.toList).bind rcInitializer)

theorem bind_source (i : Fin 12) (line : String) (tokens : List B20.C.Token) (values : List (BitVec 64))
    (hl : ShakeSource.sourceLines[39+i.val]?=some line)
    (ht : C99ProcedureParser.tokens line.toList=some tokens)
    (hv : rcInitializer tokens=some values) : rcPair i=some values :=
  (congrArg (fun text : Option String => text.bind (fun s =>
    (C99ProcedureParser.tokens s.toList).bind rcInitializer)) hl).trans
    ((congrArg (fun ts : Option (List B20.C.Token) => ts.bind rcInitializer) ht).trans hv)

theorem line00 : ShakeSource.sourceLines[39]?=some "\t0x0000000000000001, 0x0000000000008082,\n" := by decide
theorem tokens00 : C99ProcedureParser.tokens "\t0x0000000000000001, 0x0000000000008082,\n".toList=
    some ["0x0000000000000001".toList,",".toList,"0x0000000000008082".toList,",".toList] := by decide
theorem values00 : rcInitializer ["0x0000000000000001".toList,",".toList,"0x0000000000008082".toList,",".toList]=some [0x0000000000000001,0x0000000000008082] := rfl
theorem list00 : (rc.drop 0).take 2=[0x0000000000000001,0x0000000000008082] := rfl
theorem pair00 : rcPair 0=some ((rc.drop 0).take 2) :=
  (bind_source 0 _ _ _ line00 tokens00 values00).trans (congrArg some list00.symm)

theorem line01 : ShakeSource.sourceLines[40]?=some "\t0x800000000000808A, 0x8000000080008000,\n" := by decide
theorem tokens01 : C99ProcedureParser.tokens "\t0x800000000000808A, 0x8000000080008000,\n".toList=
    some ["0x800000000000808A".toList,",".toList,"0x8000000080008000".toList,",".toList] := by decide
theorem values01 : rcInitializer ["0x800000000000808A".toList,",".toList,"0x8000000080008000".toList,",".toList]=some [0x800000000000808A,0x8000000080008000] := rfl
theorem list01 : (rc.drop 2).take 2=[0x800000000000808A,0x8000000080008000] := rfl
theorem pair01 : rcPair 1=some ((rc.drop 2).take 2) :=
  (bind_source 1 _ _ _ line01 tokens01 values01).trans (congrArg some list01.symm)

theorem line02 : ShakeSource.sourceLines[41]?=some "\t0x000000000000808B, 0x0000000080000001,\n" := by decide
theorem tokens02 : C99ProcedureParser.tokens "\t0x000000000000808B, 0x0000000080000001,\n".toList=
    some ["0x000000000000808B".toList,",".toList,"0x0000000080000001".toList,",".toList] := by decide
theorem values02 : rcInitializer ["0x000000000000808B".toList,",".toList,"0x0000000080000001".toList,",".toList]=some [0x000000000000808B,0x0000000080000001] := rfl
theorem list02 : (rc.drop 4).take 2=[0x000000000000808B,0x0000000080000001] := rfl
theorem pair02 : rcPair 2=some ((rc.drop 4).take 2) :=
  (bind_source 2 _ _ _ line02 tokens02 values02).trans (congrArg some list02.symm)

theorem line03 : ShakeSource.sourceLines[42]?=some "\t0x8000000080008081, 0x8000000000008009,\n" := by decide
theorem tokens03 : C99ProcedureParser.tokens "\t0x8000000080008081, 0x8000000000008009,\n".toList=
    some ["0x8000000080008081".toList,",".toList,"0x8000000000008009".toList,",".toList] := by decide
theorem values03 : rcInitializer ["0x8000000080008081".toList,",".toList,"0x8000000000008009".toList,",".toList]=some [0x8000000080008081,0x8000000000008009] := rfl
theorem list03 : (rc.drop 6).take 2=[0x8000000080008081,0x8000000000008009] := rfl
theorem pair03 : rcPair 3=some ((rc.drop 6).take 2) :=
  (bind_source 3 _ _ _ line03 tokens03 values03).trans (congrArg some list03.symm)

theorem line04 : ShakeSource.sourceLines[43]?=some "\t0x000000000000008A, 0x0000000000000088,\n" := by decide
theorem tokens04 : C99ProcedureParser.tokens "\t0x000000000000008A, 0x0000000000000088,\n".toList=
    some ["0x000000000000008A".toList,",".toList,"0x0000000000000088".toList,",".toList] := by decide
theorem values04 : rcInitializer ["0x000000000000008A".toList,",".toList,"0x0000000000000088".toList,",".toList]=some [0x000000000000008A,0x0000000000000088] := rfl
theorem list04 : (rc.drop 8).take 2=[0x000000000000008A,0x0000000000000088] := rfl
theorem pair04 : rcPair 4=some ((rc.drop 8).take 2) :=
  (bind_source 4 _ _ _ line04 tokens04 values04).trans (congrArg some list04.symm)

theorem line05 : ShakeSource.sourceLines[44]?=some "\t0x0000000080008009, 0x000000008000000A,\n" := by decide
theorem tokens05 : C99ProcedureParser.tokens "\t0x0000000080008009, 0x000000008000000A,\n".toList=
    some ["0x0000000080008009".toList,",".toList,"0x000000008000000A".toList,",".toList] := by decide
theorem values05 : rcInitializer ["0x0000000080008009".toList,",".toList,"0x000000008000000A".toList,",".toList]=some [0x0000000080008009,0x000000008000000A] := rfl
theorem list05 : (rc.drop 10).take 2=[0x0000000080008009,0x000000008000000A] := rfl
theorem pair05 : rcPair 5=some ((rc.drop 10).take 2) :=
  (bind_source 5 _ _ _ line05 tokens05 values05).trans (congrArg some list05.symm)

theorem line06 : ShakeSource.sourceLines[45]?=some "\t0x000000008000808B, 0x800000000000008B,\n" := by decide
theorem tokens06 : C99ProcedureParser.tokens "\t0x000000008000808B, 0x800000000000008B,\n".toList=
    some ["0x000000008000808B".toList,",".toList,"0x800000000000008B".toList,",".toList] := by decide
theorem values06 : rcInitializer ["0x000000008000808B".toList,",".toList,"0x800000000000008B".toList,",".toList]=some [0x000000008000808B,0x800000000000008B] := rfl
theorem list06 : (rc.drop 12).take 2=[0x000000008000808B,0x800000000000008B] := rfl
theorem pair06 : rcPair 6=some ((rc.drop 12).take 2) :=
  (bind_source 6 _ _ _ line06 tokens06 values06).trans (congrArg some list06.symm)

theorem line07 : ShakeSource.sourceLines[46]?=some "\t0x8000000000008089, 0x8000000000008003,\n" := by decide
theorem tokens07 : C99ProcedureParser.tokens "\t0x8000000000008089, 0x8000000000008003,\n".toList=
    some ["0x8000000000008089".toList,",".toList,"0x8000000000008003".toList,",".toList] := by decide
theorem values07 : rcInitializer ["0x8000000000008089".toList,",".toList,"0x8000000000008003".toList,",".toList]=some [0x8000000000008089,0x8000000000008003] := rfl
theorem list07 : (rc.drop 14).take 2=[0x8000000000008089,0x8000000000008003] := rfl
theorem pair07 : rcPair 7=some ((rc.drop 14).take 2) :=
  (bind_source 7 _ _ _ line07 tokens07 values07).trans (congrArg some list07.symm)

theorem line08 : ShakeSource.sourceLines[47]?=some "\t0x8000000000008002, 0x8000000000000080,\n" := by decide
theorem tokens08 : C99ProcedureParser.tokens "\t0x8000000000008002, 0x8000000000000080,\n".toList=
    some ["0x8000000000008002".toList,",".toList,"0x8000000000000080".toList,",".toList] := by decide
theorem values08 : rcInitializer ["0x8000000000008002".toList,",".toList,"0x8000000000000080".toList,",".toList]=some [0x8000000000008002,0x8000000000000080] := rfl
theorem list08 : (rc.drop 16).take 2=[0x8000000000008002,0x8000000000000080] := rfl
theorem pair08 : rcPair 8=some ((rc.drop 16).take 2) :=
  (bind_source 8 _ _ _ line08 tokens08 values08).trans (congrArg some list08.symm)

theorem line09 : ShakeSource.sourceLines[48]?=some "\t0x000000000000800A, 0x800000008000000A,\n" := by decide
theorem tokens09 : C99ProcedureParser.tokens "\t0x000000000000800A, 0x800000008000000A,\n".toList=
    some ["0x000000000000800A".toList,",".toList,"0x800000008000000A".toList,",".toList] := by decide
theorem values09 : rcInitializer ["0x000000000000800A".toList,",".toList,"0x800000008000000A".toList,",".toList]=some [0x000000000000800A,0x800000008000000A] := rfl
theorem list09 : (rc.drop 18).take 2=[0x000000000000800A,0x800000008000000A] := rfl
theorem pair09 : rcPair 9=some ((rc.drop 18).take 2) :=
  (bind_source 9 _ _ _ line09 tokens09 values09).trans (congrArg some list09.symm)

theorem line10 : ShakeSource.sourceLines[49]?=some "\t0x8000000080008081, 0x8000000000008080,\n" := by decide
theorem tokens10 : C99ProcedureParser.tokens "\t0x8000000080008081, 0x8000000000008080,\n".toList=
    some ["0x8000000080008081".toList,",".toList,"0x8000000000008080".toList,",".toList] := by decide
theorem values10 : rcInitializer ["0x8000000080008081".toList,",".toList,"0x8000000000008080".toList,",".toList]=some [0x8000000080008081,0x8000000000008080] := rfl
theorem list10 : (rc.drop 20).take 2=[0x8000000080008081,0x8000000000008080] := rfl
theorem pair10 : rcPair 10=some ((rc.drop 20).take 2) :=
  (bind_source 10 _ _ _ line10 tokens10 values10).trans (congrArg some list10.symm)

theorem line11 : ShakeSource.sourceLines[50]?=some "\t0x0000000080000001, 0x8000000080008008\n" := by decide
theorem tokens11 : C99ProcedureParser.tokens "\t0x0000000080000001, 0x8000000080008008\n".toList=
    some ["0x0000000080000001".toList,",".toList,"0x8000000080008008".toList] := by decide
theorem values11 : rcInitializer ["0x0000000080000001".toList,",".toList,"0x8000000080008008".toList]=some [0x0000000080000001,0x8000000080008008] := rfl
theorem list11 : (rc.drop 22).take 2=[0x0000000080000001,0x8000000080008008] := rfl
theorem pair11 : rcPair 11=some ((rc.drop 22).take 2) :=
  (bind_source 11 _ _ _ line11 tokens11 values11).trans (congrArg some list11.symm)

theorem rc_pairs (i : Fin 12) : rcPair i=some ((rc.drop (2*i.val)).take 2) := by
  fin_cases i
  · exact pair00
  · exact pair01
  · exact pair02
  · exact pair03
  · exact pair04
  · exact pair05
  · exact pair06
  · exact pair07
  · exact pair08
  · exact pair09
  · exact pair10
  · exact pair11
end FT1536.Source3.ShakeRcBinding
