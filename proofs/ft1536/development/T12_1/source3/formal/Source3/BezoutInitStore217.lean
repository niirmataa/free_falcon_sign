import Source3.SelectedBezoutInitCopies217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source initialization after the first two copies: alen/blen and u0[0]. -/
namespace FT1536.Source3.BezoutInitStore217
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec Stmt)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open DeepestBezoutEntry217 (Gp)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)

def var (n : String) : CLogic.Expr := .var n.toList
def assign (dst src : String) : Stmt := .word (.assign dst.toList (.scalar (var src)))
def store : Stmt := .word (.store "u0".toList (.literal .i32 0) (.scalar (.literal .i32 1)))
def rest : Stmt := match BezoutInitCopies217.tail with | .seq _ (.seq _ (.seq _ tail)) => tail | _ => KeygenZintCall.skip
def code : Stmt := .seq (assign "alen" "xlen") (.seq (assign "blen" "ylen") (.seq store ZintNormWord194.wskip))
def withA (s : State) (nx : Nat) := bindValue s "alen".toList .uint64 (.uint64 (word nx))
def withB (s : State) (nx ny : Nat) := bindValue (withA s nx) "blen".toList .uint64 (.uint64 (word ny))
def after (s : State) (nx ny : Nat) : State := {withB s nx ny with heap:=Word32Memory176.write s.heap Gp 1}

theorem shape : BezoutInitCopies217.tail=.seq (assign "alen" "xlen") (.seq (assign "blen" "ylen") (.seq store rest)) := by decide

structure Input (s : State) (nx ny : Nat) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  xlen : Cell s "xlen".toList nx
  ylen : Cell s "ylen".toList ny
  aDecl : s.locals "alen".toList=some (.uint64,none)
  bDecl : s.locals "blen".toList=some (.uint64,none)
  u0Binding : s.arrays "u0".toList=some Gp
  u0Allocated : Allocated s.heap Gp
  writable : s.heap.writable Gp.block=true

theorem source (s : State) (nx ny : Nat) (h : Input s nx ny) :
    Exec code s ⟨after s nx ny,.normal⟩ ∧
    Cell (after s nx ny) "alen".toList nx ∧ Cell (after s nx ny) "blen".toList ny ∧
    Load32 (after s nx ny).heap Gp 1 := by
  have first : Exec (assign "alen" "xlen") s ⟨withA s nx,.normal⟩ :=
    .word _ _ _ (.assign _ _ _ .uint64 none (.uint64 (word nx)) h.aDecl (.scalar _ _ (.variable _ _ _ h.xlen)))
  have ylen : Cell (withA s nx) "ylen".toList ny :=
    (SelectedStepAddPrime195.locals_keep _ "alen".toList .uint64 _ "ylen".toList (by decide)).trans h.ylen
  have bDecl : (withA s nx).locals "blen".toList=some (.uint64,none) :=
    (SelectedStepAddPrime195.locals_keep _ "alen".toList .uint64 _ "blen".toList (by decide)).trans h.bDecl
  have second : Exec (assign "blen" "ylen") (withA s nx) ⟨withB s nx ny,.normal⟩ :=
    .word _ _ _ (.assign _ _ _ .uint64 none (.uint64 (word ny)) bDecl (.scalar _ _ (.variable _ _ _ ylen)))
  have pointer : C99ArrayReference.Pointer (withB s nx ny) "u0".toList (.literal .i32 0) Gp :=
    NttInverseFinalPass192.zero_i32 _ "u0".toList Gp h.u0Binding (by decide)
  have write := Word32Memory176.source s.heap Gp 1 h.u0Allocated rfl h.writable
  have third : Exec store (withB s nx ny) ⟨after s nx ny,.normal⟩ :=
    .word _ _ _ (.store _ _ _ _ _ _ (.int32 1) pointer (.scalar _ _ (.literal .int32 1)) write)
  have ac : Cell (after s nx ny) "alen".toList nx := by
    change Cell (withB s nx ny) "alen".toList nx
    exact (SelectedStepAddPrime195.locals_keep (withA s nx) "blen".toList .uint64 (.uint64 (word ny)) "alen".toList (by decide)).trans
      (KeygenMkgm3RowInit.set64_slot s "alen" nx (by have q:=h.nxBound; omega))
  have bc : Cell (after s nx ny) "blen".toList ny := by
    change Cell (withB s nx ny) "blen".toList ny
    exact KeygenMkgm3RowInit.set64_slot (withA s nx) "blen" ny (by have q:=h.nyBound; omega)
  have read : Load32 (after s nx ny).heap Gp 1 := Word32Memory176.here _ _ _ h.u0Allocated rfl h.writable
  exact ⟨.seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second (.seqNormal _ _ _ _ _ third (ZintNormWord194.word_skip _))),ac,bc,read⟩

theorem keep_data (s : State) (nx ny n : Nat) (root : ArrayPointer) (W : Nat → BitVec 32)
    (data : Data s root n W) (apart : ∀ i<n, Separate Gp (elem root i)) :
    Data (after s nx ny) root n W := by
  intro i bound
  exact Word32Memory176.outside s.heap Gp (elem root i) 1 (W i) (apart i bound) (data i bound)

end FT1536.Source3.BezoutInitStore217
