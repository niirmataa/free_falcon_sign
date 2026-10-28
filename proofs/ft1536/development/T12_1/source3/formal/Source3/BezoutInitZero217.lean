import Source3.BezoutMemzero217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original initial u0/v0 memset statements at symbolic bounded lengths. -/
namespace FT1536.Source3.BezoutInitZero217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)

def var (s : String) : CLogic.Expr := .var s.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def countMinus : CLogic.Expr := .bin .mul (.bin .sub (var "ylen") (num 1)) (.literal .u64 4)
def countX : CLogic.Expr := .bin .mul (var "xlen") (.literal .u64 4)
def first : Stmt := .memzero "u0".toList (num 1) countMinus
def second : Stmt := .memzero "v0".toList C99ProcedureParser.zero countX
def tail : Stmt := match BezoutInitStore217.rest with | .seq _ (.seq _ rest) => rest | _ => KeygenZintCall.skip
def firstPtr := element Gp 1
def middle (s : State) (ny : Nat) : State := {s with heap:=BezoutMemzero217.zero s.heap firstPtr (4*(ny-1))}
def after (s : State) (nx ny : Nat) : State := {middle s ny with heap:=BezoutMemzero217.zero (middle s ny).heap Fp (4*nx)}

theorem shape : BezoutInitStore217.rest=.seq first (.seq second tail) := by decide

structure Input (s : State) (nx ny : Nat) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  nyPositive : 0<ny
  xlen : Cell s "xlen".toList nx
  ylen : Cell s "ylen".toList ny
  u0 : s.arrays "u0".toList=some Gp
  v0 : s.arrays "v0".toList=some Fp
  extent : 4*71680≤s.heap.size 31
  size : s.heap.size 31<2^64
  writable : s.heap.writable 31=true
  one : Load32 s.heap Gp 1

theorem minus_count (s : State) (ny : Nat) (bound : ny≤335) (positive : 0<ny) (cell : Cell s "ylen".toList ny) :
    C99ArrayReference.scalar s countMinus (.uint64 (word (4*(ny-1)))) := by
  have sub := ExactLengthOps217.sub_one ny (by omega) positive
  have mul := NttInverseFinalPass192.word_mul (ny-1) 4 (by omega) (by decide)
  have eq : (ny-1)*4=4*(ny-1) := by omega
  rw [eq] at mul
  exact .arithmetic .times _ _ _ _ _
    (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ cell) (.literal .int32 1) sub) (.literal .uint64 4) mul

theorem x_count (s : State) (nx : Nat) (bound : nx≤335) (cell : Cell s "xlen".toList nx) :
    C99ArrayReference.scalar s countX (.uint64 (word (4*nx))) := BezoutCopySource217.count_eval s "xlen" nx bound cell

theorem source (s : State) (nx ny : Nat) (h : Input s nx ny) :
    Exec first s ⟨middle s ny,.normal⟩ ∧ Exec second (middle s ny) ⟨after s nx ny,.normal⟩ ∧
    Load32 (after s nx ny).heap Gp 1 := by
  have ptr : C99ArrayReference.Pointer s "u0".toList (num 1) firstPtr :=
    .add _ _ Gp firstPtr (.int32 1) h.u0 (.literal .int32 1) (by decide) (.within Gp 1 (by decide))
  have countBound : 4*(ny-1)<2^64 := by have b:=h.nyBound; omega
  have range : firstPtr.offset+4*(ny-1)≤s.heap.size firstPtr.block := by
    change 4*336+4*(ny-1)≤s.heap.size 31
    have b:=h.nyBound; have e:=h.extent; omega
  have mem := BezoutMemzero217.source s.heap firstPtr (4*(ny-1)) range h.size h.writable
  have obj : firstPtr.offset+(word (4*(ny-1))).toNat≤firstPtr.base+firstPtr.elementBytes*firstPtr.count := by
    rw [C99NatWord141.to_nat _ countBound]
    change 4*336+4*(ny-1)≤4*71680
    have b:=h.nyBound; omega
  have actual : KeygenZintCall.Memzero s.heap firstPtr (word (4*(ny-1))).toNat (middle s ny).heap := by
    rw [C99NatWord141.to_nat _ countBound]; exact mem
  have firstRun : Exec first s ⟨middle s ny,.normal⟩ :=
    .memzero _ _ _ _ _ _ _ ptr (minus_count s ny h.nyBound h.nyPositive h.ylen) obj actual
  have oneMid : Load32 (middle s ny).heap Gp 1 := by
    apply BezoutMemzero217.outside s.heap firstPtr Gp (4*(ny-1)) 1 ?_ h.one
    right; left; change 0+4*335+4≤0+4*336; decide
  have xBound : 4*nx<2^64 := by have b:=h.nxBound; omega
  have vBinding : (middle s ny).arrays "v0".toList=some Fp := h.v0
  have pointer := RootBinding175.zero (middle s ny) "v0" Fp vBinding (by decide)
  have range2 : Fp.offset+4*nx≤(middle s ny).heap.size Fp.block := by
    change 4*0+4*nx≤s.heap.size 31
    have b:=h.nxBound; have e:=h.extent; omega
  have mem2 := BezoutMemzero217.source (middle s ny).heap Fp (4*nx) range2 h.size h.writable
  have obj2 : Fp.offset+(word (4*nx)).toNat≤Fp.base+Fp.elementBytes*Fp.count := by
    rw [C99NatWord141.to_nat _ xBound]
    change 4*0+4*nx≤4*71680
    have b:=h.nxBound; omega
  have actual2 : KeygenZintCall.Memzero (middle s ny).heap Fp (word (4*nx)).toNat (after s nx ny).heap := by
    rw [C99NatWord141.to_nat _ xBound]; exact mem2
  have secondRun : Exec second (middle s ny) ⟨after s nx ny,.normal⟩ :=
    .memzero _ _ _ _ _ _ _ pointer (x_count _ nx h.nxBound h.xlen) obj2 actual2
  have oneAfter : Load32 (after s nx ny).heap Gp 1 := by
    apply BezoutMemzero217.outside (middle s ny).heap Fp Gp (4*nx) 1 ?_ oneMid
    right; right; change 0+4*0+4*nx≤0+4*335; simpa only [Nat.mul_zero,Nat.zero_add] using Nat.mul_le_mul_left 4 h.nxBound
  exact ⟨firstRun,secondRun,oneAfter⟩

theorem continue_part (s : State) (nx ny : Nat) (h : Input s nx ny) (out : C99ProcedureReference.Result)
    (rest : Exec tail (after s nx ny) out) : Exec BezoutInitStore217.rest s out := by
  rw [shape]
  obtain ⟨firstRun,secondRun,_⟩:=source s nx ny h
  exact .seqNormal _ _ _ _ _ firstRun (.seqNormal _ _ _ _ _ secondRun rest)

end FT1536.Source3.BezoutInitZero217
