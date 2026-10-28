import Source3.BezoutUpperZeroOps217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original source upper-word zeroing for u and v. -/
namespace FT1536.Source3.BezoutUpperZero217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open DeepestBezoutEntry217 (Fp Gp)

def var (s : String) : CLogic.Expr := .var s.toList
def count (name : String) : CLogic.Expr := .bin .mul (.bin .sub (var "len") (var name)) (.literal .u64 4)
def first : Stmt := .memzero "u".toList (var "ylen") (count "ylen")
def second : Stmt := .memzero "v".toList (var "xlen") (count "xlen")
def tail : Stmt := match KeygenZintCall.bezoutPart 5 with | .seq _ (.seq _ rest) => rest | _ => KeygenZintCall.skip
def middle (s : State) (ny : Nat) : State := {s with heap:=BezoutMemzero217.zero s.heap (element Gp ny) (4*(335-ny))}
def after (s : State) (nx ny : Nat) : State := {middle s ny with heap:=BezoutMemzero217.zero (middle s ny).heap (element Fp nx) (4*(335-nx))}

theorem shape : KeygenZintCall.bezoutPart 5=.seq first (.seq second tail) := by decide

structure Input (s : State) (nx ny : Nat) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  nyPositive : 0<ny
  len : Cell s "len".toList 335
  xlen : Cell s "xlen".toList nx
  ylen : Cell s "ylen".toList ny
  u : s.arrays "u".toList=some Gp
  v : s.arrays "v".toList=some Fp
  extent : 4*71680≤s.heap.size 31
  size : s.heap.size 31<2^64
  writable : s.heap.writable 31=true
  one : Load32 s.heap Gp 1

theorem count_eval (s : State) (name : String) (n : Nat) (bound : n≤335)
    (len : Cell s "len".toList 335) (cell : Cell s name.toList n) :
    C99ArrayReference.scalar s (count name) (.uint64 (word (4*(335-n)))) := by
  have sub := BezoutUpperZeroOps217.sub 335 n bound (by decide)
  have mul := NttInverseFinalPass192.word_mul (335-n) 4 (by omega) (by decide)
  have eq : (335-n)*4=4*(335-n) := by omega
  rw [eq] at mul
  exact .arithmetic .times _ _ _ _ _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ len) (.variable _ _ _ cell) sub)
    (.literal .uint64 4) mul

theorem source (s : State) (nx ny : Nat) (h : Input s nx ny) :
    Exec first s ⟨middle s ny,.normal⟩ ∧ Exec second (middle s ny) ⟨after s nx ny,.normal⟩ ∧
    Load32 (after s nx ny).heap Gp 1 := by
  have nb : ny<2^64 := by have q:=h.nyBound; omega
  have ptrU : C99ArrayReference.Pointer s "u".toList (var "ylen") (element Gp ny) :=
    .add _ _ Gp _ (.uint64 (word ny)) h.u (.variable _ _ _ h.ylen)
      (by rw [C99NatWord141.integer ny nb]; omega)
      (by
        rw [C99NatWord141.integer ny nb]
        change C99MemoryReference.PointerAdd Gp ny {Gp with index:=Gp.index+ny}
        exact .within Gp ny (by change 335+ny≤71680; have q:=h.nyBound; omega))
  have countBound : 4*(335-ny)<2^64 := by omega
  have range : (element Gp ny).offset+4*(335-ny)≤s.heap.size 31 := by
    change 0+4*(335+ny)+4*(335-ny)≤s.heap.size 31
    have q:=h.nyBound; have e:=h.extent; omega
  have mem := BezoutMemzero217.source s.heap (element Gp ny) (4*(335-ny)) range h.size h.writable
  have object : (element Gp ny).offset+(word (4*(335-ny))).toNat≤(element Gp ny).base+(element Gp ny).elementBytes*(element Gp ny).count := by
    rw [C99NatWord141.to_nat _ countBound]
    change 0+4*(335+ny)+4*(335-ny)≤0+4*71680
    have q:=h.nyBound; omega
  have actual : KeygenZintCall.Memzero s.heap (element Gp ny) (word (4*(335-ny))).toNat (middle s ny).heap := by
    rw [C99NatWord141.to_nat _ countBound]; exact mem
  have runU : Exec first s ⟨middle s ny,.normal⟩ := .memzero _ _ _ _ _ _ _ ptrU (count_eval s "ylen" ny h.nyBound h.len h.ylen) object actual
  have oneMid : Load32 (middle s ny).heap Gp 1 := by
    apply BezoutMemzero217.outside s.heap (element Gp ny) Gp (4*(335-ny)) 1 ?_ h.one
    right; left; change 0+4*335+4≤0+4*(335+ny); have p:=h.nyPositive; omega
  have xb : nx<2^64 := by have q:=h.nxBound; omega
  have ptrV : C99ArrayReference.Pointer (middle s ny) "v".toList (var "xlen") (element Fp nx) :=
    .add _ _ Fp _ (.uint64 (word nx)) h.v (.variable _ _ _ h.xlen)
      (by rw [C99NatWord141.integer nx xb]; omega)
      (by
        rw [C99NatWord141.integer nx xb]
        change C99MemoryReference.PointerAdd Fp nx {Fp with index:=Fp.index+nx}
        exact .within Fp nx (by change 0+nx≤71680; have q:=h.nxBound; omega))
  have countBound2 : 4*(335-nx)<2^64 := by omega
  have range2 : (element Fp nx).offset+4*(335-nx)≤(middle s ny).heap.size 31 := by
    change 0+4*(0+nx)+4*(335-nx)≤s.heap.size 31
    have q:=h.nxBound; have e:=h.extent; omega
  have mem2 := BezoutMemzero217.source (middle s ny).heap (element Fp nx) (4*(335-nx)) range2 h.size h.writable
  have object2 : (element Fp nx).offset+(word (4*(335-nx))).toNat≤(element Fp nx).base+(element Fp nx).elementBytes*(element Fp nx).count := by
    rw [C99NatWord141.to_nat _ countBound2]
    change 0+4*(0+nx)+4*(335-nx)≤0+4*71680
    have q:=h.nxBound; omega
  have actual2 : KeygenZintCall.Memzero (middle s ny).heap (element Fp nx) (word (4*(335-nx))).toNat (after s nx ny).heap := by
    rw [C99NatWord141.to_nat _ countBound2]; exact mem2
  have runV : Exec second (middle s ny) ⟨after s nx ny,.normal⟩ := .memzero _ _ _ _ _ _ _ ptrV (count_eval _ "xlen" nx h.nxBound h.len h.xlen) object2 actual2
  have oneAfter : Load32 (after s nx ny).heap Gp 1 := by
    apply BezoutMemzero217.outside (middle s ny).heap (element Fp nx) Gp (4*(335-nx)) 1 ?_ oneMid
    right; right; change 0+4*(0+nx)+4*(335-nx)≤0+4*335; have q:=h.nxBound; omega
  exact ⟨runU,runV,oneAfter⟩

end FT1536.Source3.BezoutUpperZero217
