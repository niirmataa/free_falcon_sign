import Source3.SelectedBezoutUpperCombined217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original a/b upper zeroing after mlen selection. -/
namespace FT1536.Source3.BezoutABZero217
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open DeepestBezoutEntry217 (Gp)
open BezoutPointerSetup217 (a b)

def var (s : String) : CLogic.Expr := .var s.toList
def count (name : String) : CLogic.Expr := .bin .mul (.bin .sub (var "mlen") (var name)) (.literal .u64 4)
def first : Stmt := .memzero "a".toList (var "alen") (count "alen")
def second : Stmt := .memzero "b".toList (var "blen") (count "blen")
def middle (s : State) (nx ny : Nat) : State := {s with heap:=BezoutMemzero217.zero s.heap (element a nx) (4*(max nx ny-nx))}
def after (s : State) (nx ny : Nat) : State := {middle s nx ny with heap:=BezoutMemzero217.zero (middle s nx ny).heap (element b ny) (4*(max nx ny-ny))}

theorem shape : BezoutMlen217.tail=.seq first (.seq second ZintNormWord194.wskip) := by decide

structure Input (s : State) (nx ny : Nat) : Prop where
  nxBound : nx≤335
  nyBound : ny≤335
  alen : Cell s "alen".toList nx
  blen : Cell s "blen".toList ny
  mlen : Cell s "mlen".toList (max nx ny)
  aBinding : s.arrays "a".toList=some a
  bBinding : s.arrays "b".toList=some b
  extent : 4*71680≤s.heap.size 31
  size : s.heap.size 31<2^64
  writable : s.heap.writable 31=true
  one : Load32 s.heap Gp 1

theorem count_eval (s : State) (name : String) (n m : Nat) (le : n≤m) (bound : m≤335)
    (mlen : Cell s "mlen".toList m) (cell : Cell s name.toList n) :
    C99ArrayReference.scalar s (count name) (.uint64 (word (4*(m-n)))) := by
  have sub := BezoutUpperZeroOps217.sub m n le (by omega)
  have mul := NttInverseFinalPass192.word_mul (m-n) 4 (by omega) (by decide)
  have eq : (m-n)*4=4*(m-n) := by omega
  rw [eq] at mul
  exact .arithmetic .times _ _ _ _ _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ mlen) (.variable _ _ _ cell) sub)
    (.literal .uint64 4) mul

theorem source (s : State) (nx ny : Nat) (h : Input s nx ny) :
    Exec first s ⟨middle s nx ny,.normal⟩ ∧ Exec second (middle s nx ny) ⟨after s nx ny,.normal⟩ ∧
    Load32 (after s nx ny).heap Gp 1 := by
  have maxBound : max nx ny≤335 := (Nat.max_le).2 ⟨h.nxBound,h.nyBound⟩
  have nx64 : nx<2^64 := by have q:=h.nxBound; omega
  have ptrA : C99ArrayReference.Pointer s "a".toList (var "alen") (element a nx) :=
    .add _ _ a _ (.uint64 (word nx)) h.aBinding (.variable _ _ _ h.alen)
      (by rw [C99NatWord141.integer nx nx64]; omega)
      (by
        rw [C99NatWord141.integer nx nx64]
        change C99MemoryReference.PointerAdd a nx {a with index:=a.index+nx}
        exact .within a nx (by change 2010+nx≤71680; have q:=h.nxBound; omega))
  have countBound : 4*(max nx ny-nx)<2^64 := by omega
  have range : (element a nx).offset+4*(max nx ny-nx)≤s.heap.size 31 := by
    change 0+4*(2010+nx)+4*(max nx ny-nx)≤s.heap.size 31
    have e:=h.extent; have q:=Nat.le_max_left nx ny; omega
  have mem := BezoutMemzero217.source s.heap (element a nx) (4*(max nx ny-nx)) range h.size h.writable
  have object : (element a nx).offset+(word (4*(max nx ny-nx))).toNat≤(element a nx).base+(element a nx).elementBytes*(element a nx).count := by
    rw [C99NatWord141.to_nat _ countBound]
    change 0+4*(2010+nx)+4*(max nx ny-nx)≤0+4*71680
    have q:=Nat.le_max_left nx ny; omega
  have actual : KeygenZintCall.Memzero s.heap (element a nx) (word (4*(max nx ny-nx))).toNat (middle s nx ny).heap := by
    rw [C99NatWord141.to_nat _ countBound]; exact mem
  have runA : Exec first s ⟨middle s nx ny,.normal⟩ :=
    .memzero _ _ _ _ _ _ _ ptrA (count_eval s "alen" nx (max nx ny) (Nat.le_max_left _ _) maxBound h.mlen h.alen) object actual
  have oneMid : Load32 (middle s nx ny).heap Gp 1 := by
    apply BezoutMemzero217.outside s.heap (element a nx) Gp (4*(max nx ny-nx)) 1 ?_ h.one
    right; left; change 0+4*335+4≤0+4*(2010+nx); omega
  have ny64 : ny<2^64 := by have q:=h.nyBound; omega
  have ptrB : C99ArrayReference.Pointer (middle s nx ny) "b".toList (var "blen") (element b ny) :=
    .add _ _ b _ (.uint64 (word ny)) h.bBinding (.variable _ _ _ h.blen)
      (by rw [C99NatWord141.integer ny ny64]; omega)
      (by
        rw [C99NatWord141.integer ny ny64]
        change C99MemoryReference.PointerAdd b ny {b with index:=b.index+ny}
        exact .within b ny (by change 2345+ny≤71680; have q:=h.nyBound; omega))
  have countBound2 : 4*(max nx ny-ny)<2^64 := by omega
  have range2 : (element b ny).offset+4*(max nx ny-ny)≤(middle s nx ny).heap.size 31 := by
    change 0+4*(2345+ny)+4*(max nx ny-ny)≤s.heap.size 31
    have e:=h.extent; have q:=Nat.le_max_right nx ny; omega
  have mem2 := BezoutMemzero217.source (middle s nx ny).heap (element b ny) (4*(max nx ny-ny)) range2 h.size h.writable
  have object2 : (element b ny).offset+(word (4*(max nx ny-ny))).toNat≤(element b ny).base+(element b ny).elementBytes*(element b ny).count := by
    rw [C99NatWord141.to_nat _ countBound2]
    change 0+4*(2345+ny)+4*(max nx ny-ny)≤0+4*71680
    have q:=Nat.le_max_right nx ny; omega
  have actual2 : KeygenZintCall.Memzero (middle s nx ny).heap (element b ny) (word (4*(max nx ny-ny))).toNat (after s nx ny).heap := by
    rw [C99NatWord141.to_nat _ countBound2]; exact mem2
  have runB : Exec second (middle s nx ny) ⟨after s nx ny,.normal⟩ :=
    .memzero _ _ _ _ _ _ _ ptrB (count_eval _ "blen" ny (max nx ny) (Nat.le_max_right _ _) maxBound h.mlen h.blen) object2 actual2
  have oneAfter : Load32 (after s nx ny).heap Gp 1 := by
    apply BezoutMemzero217.outside (middle s nx ny).heap (element b ny) Gp (4*(max nx ny-ny)) 1 ?_ oneMid
    right; left; change 0+4*335+4≤0+4*(2345+ny); omega
  exact ⟨runA,runB,oneAfter⟩

end FT1536.Source3.BezoutABZero217
