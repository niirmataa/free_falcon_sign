import Source3.GsInvNormBody154
import Source3.C99PointerNat141
import Source3.C99LoopScalar141
import Source3.C99WordBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormInvariant154
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Load64 Allocated)
open C99WordBuffer140 (element Represents)
open C99LoopScalar141 (Cell)

def low {n hn : Nat} (length : 2*hn ≤ n) (i : Fin hn) : Fin n := ⟨i.val,by have h:=i.isLt; omega⟩
def high {n hn : Nat} (length : 2*hn ≤ n) (i : Fin hn) : Fin n := ⟨i.val+hn,by have h:=i.isLt; omega⟩
def sample {n hn : Nat} (length : 2*hn ≤ n) (f g : Fin n → BitVec 64) (i : Fin hn) : FftMulStates140.Words :=
  ⟨f (low length i),f (high length i),g (low length i),g (high length i)⟩
def result {n hn : Nat} (length : 2*hn ≤ n) (f g : Fin n → BitVec 64) (i : Fin hn) : BitVec 64 :=
  GsInvNormShape154.value (sample length f g i)

structure Fixed (s : State) (a b d : ArrayPointer) (n hn : Nat) (f g : Fin n → BitVec 64) : Prop where
  length : 2*hn ≤ n
  wordBound : n<2^64
  capacityA : a.index+n ≤ a.count
  capacityB : b.index+n ≤ b.count
  capacityD : d.index+hn ≤ d.count
  widthD : d.elementBytes=8
  bindingA : s.arrays "a".toList=some a
  bindingB : s.arrays "b".toList=some b
  bindingD : s.arrays "d".toList=some d
  hnCell : Cell s "hn".toList hn
  allocatedD : ∀ i : Fin hn, Allocated s.heap (element d i)
  writableD : s.heap.writable d.block=true
  first : Represents s.heap a f
  second : Represents s.heap b g
  separateA : ∀ (i : Fin hn) (j : Fin n), C99WordRead140.Separate (element d i) (element a j)
  separateB : ∀ (i : Fin hn) (j : Fin n), C99WordRead140.Separate (element d i) (element b j)

theorem addresses (s : State) (base : ArrayPointer) (n hn u : Nat) (name : C99ArrayReference.Name)
    (length : 2*hn ≤ n) (bound : n<2^64) (capacity : base.index+n ≤ base.count)
    (binding : s.arrays name=some base) (hnCell : Cell s "hn".toList hn)
    (uCell : Cell s "u".toList u) (range : u<hn) :
    Pointer s name FftFirstShape149.index0 {base with index := base.index+u} ∧
    Pointer s name FftFirstShape149.index1 {base with index := base.index+(u+hn)} := by
  exact ⟨C99PointerNat141.source s _ _ base u (by omega) (by omega) binding
      (C99LoopScalar141.read s "u".toList u uCell),
    C99PointerNat141.source s _ _ base (u+hn) (by omega) (by omega) binding
      (C99LoopScalar141.add s _ _ u hn (by omega) (by omega)
        (C99LoopScalar141.read s "u".toList u uCell) (C99LoopScalar141.read s "hn".toList hn hnCell))⟩

def pointers {n hn : Nat} (length : 2*hn ≤ n) (a b : ArrayPointer) (i : Fin hn) : Fin 4 → ArrayPointer
  | ⟨0,_⟩ => element a (low length i) | ⟨1,_⟩ => element a (high length i)
  | ⟨2,_⟩ => element b (low length i) | ⟨3,_⟩ => element b (high length i)

theorem body_source (s : State) (a b d : ArrayPointer) (n hn : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s a b d n hn f g) (i : Fin hn) (uCell : Cell s "u".toList i.val) :
    C99ProcedureReference.Exec KeygenSearchFft.program GsInvNormShape154.body s
      ⟨GsInvNormBody154.output s (element d i) (sample fixed.length f g i),.normal⟩ := by
  have ar := addresses s a n hn i.val "a".toList fixed.length fixed.wordBound fixed.capacityA fixed.bindingA fixed.hnCell uCell i.isLt
  have br := addresses s b n hn i.val "b".toList fixed.length fixed.wordBound fixed.capacityB fixed.bindingB fixed.hnCell uCell i.isLt
  have length:=fixed.length
  have bound:=fixed.wordBound
  have capacity:=fixed.capacityD
  have inside:=i.isLt
  apply GsInvNormBody154.source s (sample fixed.length f g i) (pointers fixed.length a b i) (element d i)
  · intro j
    fin_cases j
    · exact ar.1
    · exact ar.2
    · exact br.1
    · exact br.2
  · intro j
    fin_cases j
    · exact fixed.first (low fixed.length i)
    · exact fixed.first (high fixed.length i)
    · exact fixed.second (low fixed.length i)
    · exact fixed.second (high fixed.length i)
  · exact C99PointerNat141.source s _ _ d i.val (by omega) (by omega) fixed.bindingD
      (C99LoopScalar141.read s "u".toList i.val uCell)
  · exact fixed.allocatedD i
  · exact fixed.widthD
  · exact fixed.writableD

def next (s : State) (d : ArrayPointer) {n hn : Nat} (length : 2*hn ≤ n)
    (f g : Fin n → BitVec 64) (i : Fin hn) : State :=
  FftLocalCells140.put (GsInvNormBody154.output s (element d i) (sample length f g i))
    "u".toList (C99NatWord141.word (i.val+1))

theorem next_fixed (s : State) (a b d : ArrayPointer) (n hn : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s a b d n hn f g) (i : Fin hn) :
    Fixed (next s d fixed.length f g i) a b d n hn f g := by
  refine ⟨fixed.length,fixed.wordBound,fixed.capacityA,fixed.capacityB,fixed.capacityD,fixed.widthD,
    fixed.bindingA,fixed.bindingB,fixed.bindingD,?_,fixed.allocatedD,fixed.writableD,?_,?_,fixed.separateA,fixed.separateB⟩
  · exact (FftLocalCells140.outside _ "u".toList "hn".toList _ (by decide)).trans fixed.hnCell
  · intro j
    exact C99WordRead140.outside s.heap (element d i) (element a j) (result fixed.length f g i) (f j)
      (fixed.separateA i j) (fixed.first j)
  · intro j
    exact C99WordRead140.outside s.heap (element d i) (element b j) (result fixed.length f g i) (g j)
      (fixed.separateB i j) (fixed.second j)

def PrefixImage (s : State) (d : ArrayPointer) {hn : Nat} (values : Fin hn → BitVec 64) (u : Nat) : Prop :=
  ∀ i, i.val<u → Load64 s.heap (element d i) (values i)

theorem next_image (s : State) (a b d : ArrayPointer) (n hn : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s a b d n hn f g) (i : Fin hn)
    (before : PrefixImage s d (result fixed.length f g) i.val) :
    PrefixImage (next s d fixed.length f g i) d (result fixed.length f g) (i.val+1) := by
  intro j bound
  by_cases same : j=i
  · subst j
    exact C99WordRead140.here s.heap (element d i) (result fixed.length f g i)
      (fixed.allocatedD i) fixed.widthD fixed.writableD
  · have different : j.val≠i.val := fun eq => same (Fin.ext eq)
    exact C99WordRead140.outside s.heap (element d i) (element d j)
      (result fixed.length f g i) (result fixed.length f g j)
      (C99WordBuffer140.separate d fixed.widthD i j (Ne.symm same)) (before j (by omega))

end FT1536.Source3.GsInvNormInvariant154
