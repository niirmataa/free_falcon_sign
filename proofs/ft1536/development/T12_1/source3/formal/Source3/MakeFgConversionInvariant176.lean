import Source3.MakeFgConversionFrame176
import Source3.MakeFgNat176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgConversionInvariant176
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99MemoryReference (Load32)
open C99LoopScalar141 (Cell)
open Word16Memory158 (element)
open MakeFgConversionBody176 (word)

structure Fixed (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16) : Prop where
  wordBound : n<2^64
  fCapacity : f.index+n ≤ f.count
  gCapacity : g.index+n ≤ g.count
  tCapacity : t.index+n ≤ t.count
  hCapacity : h.index+n ≤ h.count
  tWidth : t.elementBytes=4
  hWidth : h.elementBytes=4
  fBinding : s.arrays "f".toList=some f
  gBinding : s.arrays "g".toList=some g
  tBinding : s.arrays "ft".toList=some t
  hBinding : s.arrays "gt".toList=some h
  nCell : Cell s "n".toList n
  qCell : s.locals "p0".toList=some (.uint32,some (.uint32 KeygenNinv31.prime))
  tAllocated : ∀ i : Fin n, Allocated s.heap (element t i)
  hAllocated : ∀ i : Fin n, Allocated s.heap (element h i)
  tWritable : s.heap.writable t.block=true
  hWritable : s.heap.writable h.block=true
  fImage : Word16Memory158.Represents s.heap f fv
  gImage : Word16Memory158.Represents s.heap g gv
  tf : t.block≠f.block
  tg : t.block≠g.block
  hf : h.block≠f.block
  hg : h.block≠g.block
  th : ∀ i j : Fin n, Word32Memory176.Separate (element t i) (element h j)

def image {n : Nat} (input : Fin n → BitVec 16) : Fin n → BitVec 32 := fun i => word (input i)
def PrefixImage (s : State) (p : ArrayPointer) {n : Nat} (values : Fin n → BitVec 32) (count : Nat) : Prop :=
  ∀ i, i.val<count → Load32 s.heap (element p i) (values i)
def middle (s : State) (t h : ArrayPointer) {n : Nat} (fv gv : Fin n → BitVec 16) (i : Fin n) :=
  MakeFgConversionBody176.output s (element t i) (element h i) (fv i) (gv i)
def next (s : State) (t h : ArrayPointer) {n : Nat} (fv gv : Fin n → BitVec 16) (i : Fin n) :=
  FftLocalCells140.put (middle s t h fv gv i) "u".toList (C99NatWord141.word (i.val+1))

theorem body_source (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (i : Fin n) (counter : Cell s "u".toList i.val) :
    KeygenMakeFgSource.Exec MakeFgConversionShape176.body s
      ⟨middle s t h fv gv i,.normal⟩ := by
  have bound:=fixed.wordBound
  have inside:=i.isLt
  apply MakeFgConversionBody176.source s (element f i) (element g i) (element t i) (element h i) (fv i) (gv i)
  · exact MakeFgNat176.address s _ f i.val (by omega) (by have c:=fixed.fCapacity; omega) fixed.fBinding counter
  · exact MakeFgNat176.address s _ g i.val (by omega) (by have c:=fixed.gCapacity; omega) fixed.gBinding counter
  · exact MakeFgNat176.address s _ t i.val (by omega) (by have c:=fixed.tCapacity; omega) fixed.tBinding counter
  · exact MakeFgNat176.address s _ h i.val (by omega) (by have c:=fixed.hCapacity; omega) fixed.hBinding counter
  · exact fixed.fImage i
  · exact fixed.gImage i
  · exact fixed.tAllocated i
  · exact fixed.hAllocated i
  · exact fixed.tWidth
  · exact fixed.hWidth
  · exact fixed.tWritable
  · exact fixed.hWritable
  · exact fixed.tg
  · exact fixed.qCell

theorem next_fixed (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (i : Fin n) : Fixed (next s t h fv gv i) f g t h n fv gv := by
  refine ⟨fixed.wordBound,fixed.fCapacity,fixed.gCapacity,fixed.tCapacity,fixed.hCapacity,fixed.tWidth,fixed.hWidth,
    fixed.fBinding,fixed.gBinding,fixed.tBinding,fixed.hBinding,?_,?_,fixed.tAllocated,fixed.hAllocated,
    fixed.tWritable,fixed.hWritable,?_,?_,fixed.tf,fixed.tg,fixed.hf,fixed.hg,fixed.th⟩
  · exact (FftLocalCells140.outside _ "u".toList "n".toList _ (by decide)).trans fixed.nCell
  · exact (FftLocalCells140.outside _ "u".toList "p0".toList _ (by decide)).trans fixed.qCell
  · intro j
    exact Word32Memory176.outside16 _ (element h i) (element f j) _ (fv j) fixed.hf
      (Word32Memory176.outside16 s.heap (element t i) (element f j) _ (fv j) fixed.tf (fixed.fImage j))
  · intro j
    exact Word32Memory176.outside16 _ (element h i) (element g j) _ (gv j) fixed.hg
      (Word32Memory176.outside16 s.heap (element t i) (element g j) _ (gv j) fixed.tg (fixed.gImage j))

theorem separate_symm {p q : ArrayPointer} (separate : Word32Memory176.Separate p q) :
    Word32Memory176.Separate q p := by
  unfold Word32Memory176.Separate at *
  omega

theorem next_images (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (i : Fin n)
    (tImage : PrefixImage s t (image fv) i.val) (hImage : PrefixImage s h (image gv) i.val) :
    PrefixImage (next s t h fv gv i) t (image fv) (i.val+1) ∧
    PrefixImage (next s t h fv gv i) h (image gv) (i.val+1) := by
  constructor
  · intro j bound
    apply Word32Memory176.outside _ (element h i) (element t j) _ (word (fv j)) (separate_symm (fixed.th j i))
    by_cases same : j=i
    · subst j
      exact Word32Memory176.here s.heap (element t i) (word (fv i)) (fixed.tAllocated i) fixed.tWidth fixed.tWritable
    · have different : j.val≠i.val := fun eq => same (Fin.ext eq)
      exact Word32Memory176.outside s.heap (element t i) (element t j) _ (word (fv j))
        (Word32Memory176.separate t fixed.tWidth i j (Ne.symm same)) (tImage j (by omega))
  · intro j bound
    by_cases same : j=i
    · subst j
      exact Word32Memory176.here _ (element h i) (word (gv i)) (fixed.hAllocated i) fixed.hWidth fixed.hWritable
    · have different : j.val≠i.val := fun eq => same (Fin.ext eq)
      exact Word32Memory176.outside _ (element h i) (element h j) _ (word (gv j))
        (Word32Memory176.separate h fixed.hWidth i j (Ne.symm same))
        (Word32Memory176.outside s.heap (element t i) (element h j) _ (word (gv j)) (fixed.th i j) (hImage j (by omega)))

end FT1536.Source3.MakeFgConversionInvariant176
