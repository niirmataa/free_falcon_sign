import Source3.PublicConvertFrame158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicConvertInvariant158
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99NarrowReads (Load16)
open C99LoopScalar141 (Cell)
open Word16Memory158 (Represents element)
open PublicConvertBody158 (converted)

structure Fixed (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16) : Prop where
  wordBound : n<2^64
  fCapacity : f.index+n ≤ f.count
  gCapacity : g.index+n ≤ g.count
  tCapacity : t.index+n ≤ t.count
  hCapacity : h.index+n ≤ h.count
  tWidth : t.elementBytes=2
  hWidth : h.elementBytes=2
  fBinding : s.arrays "f".toList=some f
  gBinding : s.arrays "g".toList=some g
  tBinding : s.arrays "t".toList=some t
  hBinding : s.arrays "h".toList=some h
  nCell : Cell s "n".toList n
  qCell : s.locals "q".toList=some (.uint32,some (.uint32 18433))
  tAllocated : ∀ i : Fin n, Allocated s.heap (element t i)
  hAllocated : ∀ i : Fin n, Allocated s.heap (element h i)
  tWritable : s.heap.writable t.block=true
  hWritable : s.heap.writable h.block=true
  fImage : Represents s.heap f fv
  gImage : Represents s.heap g gv
  tf : t.block≠f.block
  tg : t.block≠g.block
  hf : h.block≠f.block
  hg : h.block≠g.block
  th : t.block≠h.block

def image {n : Nat} (input : Fin n → BitVec 16) : Fin n → BitVec 16 := fun i => converted (input i)
def PrefixImage (s : State) (p : ArrayPointer) {n : Nat} (values : Fin n → BitVec 16) (count : Nat) : Prop :=
  ∀ i, i.val<count → Load16 s.heap (element p i) (values i)
def middle (s : State) (t h : ArrayPointer) {n : Nat} (fv gv : Fin n → BitVec 16) (i : Fin n) :=
  PublicConvertBody158.output s (element t i) (element h i) (fv i) (gv i)
def next (s : State) (t h : ArrayPointer) {n : Nat} (fv gv : Fin n → BitVec 16) (i : Fin n) :=
  FftLocalCells140.put (middle s t h fv gv i) "u".toList (C99NatWord141.word (i.val+1))

theorem body_source (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (i : Fin n) (counter : Cell s "u".toList i.val) :
    KeygenPublicExec.Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.body s
      ⟨middle s t h fv gv i,.normal⟩ := by
  have bound:=fixed.wordBound
  have inside:=i.isLt
  apply PublicConvertBody158.source s (element f i) (element g i) (element t i) (element h i) (fv i) (gv i)
  · exact PublicNat158.address s _ f i.val (by omega) (by have c:=fixed.fCapacity; omega) fixed.fBinding counter
  · exact PublicNat158.address s _ g i.val (by omega) (by have c:=fixed.gCapacity; omega) fixed.gBinding counter
  · exact PublicNat158.address s _ t i.val (by omega) (by have c:=fixed.tCapacity; omega) fixed.tBinding counter
  · exact PublicNat158.address s _ h i.val (by omega) (by have c:=fixed.hCapacity; omega) fixed.hBinding counter
  · exact fixed.fImage i
  · exact fixed.gImage i
  · exact fixed.tAllocated i
  · exact fixed.hAllocated i
  · exact fixed.tWidth
  · exact fixed.hWidth
  · exact fixed.tWritable
  · exact fixed.hWritable
  · exact Or.inl fixed.tg
  · exact fixed.qCell

theorem next_fixed (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (i : Fin n) : Fixed (next s t h fv gv i) f g t h n fv gv := by
  refine ⟨fixed.wordBound,fixed.fCapacity,fixed.gCapacity,fixed.tCapacity,fixed.hCapacity,fixed.tWidth,fixed.hWidth,
    fixed.fBinding,fixed.gBinding,fixed.tBinding,fixed.hBinding,?_,?_,fixed.tAllocated,fixed.hAllocated,
    fixed.tWritable,fixed.hWritable,?_,?_,fixed.tf,fixed.tg,fixed.hf,fixed.hg,fixed.th⟩
  · exact (FftLocalCells140.outside _ "u".toList "n".toList _ (by decide)).trans fixed.nCell
  · exact (FftLocalCells140.outside _ "u".toList "q".toList _ (by decide)).trans fixed.qCell
  · intro j
    exact Word16Memory158.outside _ (element h i) (element f j) _ (fv j) (Or.inl fixed.hf)
      (Word16Memory158.outside s.heap (element t i) (element f j) _ (fv j) (Or.inl fixed.tf) (fixed.fImage j))
  · intro j
    exact Word16Memory158.outside _ (element h i) (element g j) _ (gv j) (Or.inl fixed.hg)
      (Word16Memory158.outside s.heap (element t i) (element g j) _ (gv j) (Or.inl fixed.tg) (fixed.gImage j))

theorem next_images (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (i : Fin n)
    (tImage : PrefixImage s t (image fv) i.val) (hImage : PrefixImage s h (image gv) i.val) :
    PrefixImage (next s t h fv gv i) t (image fv) (i.val+1) ∧
    PrefixImage (next s t h fv gv i) h (image gv) (i.val+1) := by
  constructor
  · intro j bound
    apply Word16Memory158.outside _ (element h i) (element t j) _ (converted (fv j)) (Or.inl (Ne.symm fixed.th))
    by_cases same : j=i
    · subst j
      exact Word16Memory158.here s.heap (element t i) (converted (fv i)) (fixed.tAllocated i) fixed.tWidth fixed.tWritable
    · have different : j.val≠i.val := fun eq => same (Fin.ext eq)
      exact Word16Memory158.outside s.heap (element t i) (element t j) _ (converted (fv j))
        (Word16Memory158.separate t fixed.tWidth i j (Ne.symm same)) (tImage j (by omega))
  · intro j bound
    by_cases same : j=i
    · subst j
      exact Word16Memory158.here _ (element h i) (converted (gv i)) (fixed.hAllocated i) fixed.hWidth fixed.hWritable
    · have different : j.val≠i.val := fun eq => same (Fin.ext eq)
      exact Word16Memory158.outside _ (element h i) (element h j) _ (converted (gv j))
        (Word16Memory158.separate h fixed.hWidth i j (Ne.symm same))
        (Word16Memory158.outside s.heap (element t i) (element h j) _ (converted (gv j)) (Or.inl fixed.th) (hImage j (by omega)))

end FT1536.Source3.PublicConvertInvariant158
