import Source3.CrtPrimePrefix206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtRoundReady206
open C99ArrayReference (State Name bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (Slot64 set64)
open KeygenFullData127 (primes)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open CrtPrimePrefix206 (s1)
open CrtWalkIncrement206 (cell)
open CrtWalkFixed206 (Fixed Pending high)

structure Input (s : State) (root tmp : ArrayPointer) (n : Nat) (t : BitVec 32) : Prop where
  nBound : n < 2^64
  width : root.elementBytes=4
  capacity : root.index+2*n ≤ root.count
  writable : s.heap.writable root.block=true
  xxBinding : s.arrays "xx".toList=some root
  tmpBinding : s.arrays "tmp".toList=some tmp
  primesBinding : s.arrays "primes".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  uCell : Slot64 s "u" 1
  numCell : Cell s "num".toList n
  strideCell : Cell s "xstride".toList 2
  tmpRead : Load32 s.heap tmp t
  tmpCapacity : tmp.index+1 < tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  apart : ∀ i : Fin n, Word32Memory176.Separate (cell root i.val) tmp ∧ Word32Memory176.Separate (high root i.val) tmp
  highApart : ∀ i : Fin n, Word32Memory176.Separate (cell root i.val) (ZintAddMulWord205.next tmp) ∧
    Word32Memory176.Separate (high root i.val) (ZintAddMulWord205.next tmp)

def zero (s : State) := set64 (CrtPrimePrefix206.after s) "v" 0
 def entry (s : State) (root : ArrayPointer) := bindPointer (zero s) "x".toList root

theorem heap (s : State) (root : ArrayPointer) : (entry s root).heap=s.heap := rfl

theorem locals (s : State) (root : ArrayPointer) (name : Name) (absent : name∉CrtRoundShape205.localNames) :
    (entry s root).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (CrtPrimePrefix206.after s) "v".toList .uint64 (.uint64 0) name
    (fun eq => absent (eq ▸ (by decide)))).trans (CrtPrimePrefix206.outside s name absent)

theorem arrays (s : State) (root : ArrayPointer) (name : Name) (different : name≠"x".toList) :
    (entry s root).arrays name=s.arrays name := by
  simp only [entry,bindPointer,different,ite_false]
  rfl

theorem fixed (s : State) (root tmp : ArrayPointer) (n : Nat) (t : BitVec 32) (input : Input s root tmp n t) :
    Fixed (entry s root) root tmp n t p1 p0i1 r21 s1 := by
  refine ⟨input.nBound,input.width,input.capacity,input.writable,?_,?_,?_,?_,?_,?_,?_,?_,input.tmpRead,input.apart⟩
  · exact (arrays s root "tmp".toList (by decide)).trans input.tmpBinding
  · exact (locals s root "u".toList (by decide)).trans input.uCell
  · exact (CrtState205.keep64 (CrtPrimePrefix206.after s) "v" "p" 0 (by decide)).trans (CrtPrimePrefix206.pCell s)
  · exact (CrtState205.keep64 (CrtPrimePrefix206.after s) "v" "p0i" 0 (by decide)).trans (CrtPrimePrefix206.iCell s)
  · exact (CrtState205.keep64 (CrtPrimePrefix206.after s) "v" "R2" 0 (by decide)).trans (CrtPrimePrefix206.rCell s)
  · exact (CrtState205.keep64 (CrtPrimePrefix206.after s) "v" "s" 0 (by decide)).trans (CrtPrimePrefix206.sCell s)
  · exact (locals s root "num".toList (by decide)).trans input.numCell
  · exact (locals s root "xstride".toList (by decide)).trans input.strideCell

theorem counter (s : State) (root : ArrayPointer) : Cell (entry s root) "v".toList 0 := by
  change Cell (zero s) "v".toList 0
  exact CrtState205.cell64 _ _ _

theorem pointer (s : State) (root : ArrayPointer) : (entry s root).arrays "x".toList=some (cell root 0) := by
  change some root=some (cell root 0)
  rfl

theorem init_source (s : State) (root tmp : ArrayPointer) (n : Nat) (t : BitVec 32) (input : Input s root tmp n t) :
    KeygenZintCall.Exec CrtRoundShape205.walkInit (CrtPrimePrefix206.after s) ⟨entry s root,.normal⟩ := by
  have head : KeygenWordExec.Exec (.assign "v".toList (.scalar (.literal .i32 0))) (CrtPrimePrefix206.after s)
      ⟨zero s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.int32 0) (CrtPrimePrefix206.vDeclared s) (WordAtoms205.literal _ 0)
  have cap : root.index+0 ≤ root.count := by have bound:=input.capacity; omega
  have ptr : C99ArrayReference.Pointer (zero s) "xx".toList C99ProcedureParser.zero root :=
    .add _ _ root root (.uint64 0) input.xxBinding (.literal .uint64 0) (by decide) (.within root 0 cap)
  exact .seqNormal _ _ _ _ _ (.word _ _ _ head)
    (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ _ ptr))))

end FT1536.Source3.CrtRoundReady206
