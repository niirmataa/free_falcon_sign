import Source3.StepWalkBody195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Loop invariant of the additional-prime marches (MakeFgAddPrimeShape194.
   walkF "fs"/"gs"): stable source reads at the marched words, the exact
   pointer walk, the stable section words p/p0i/R2/Rx and slen = 1, and
   the t1 prefix of executed march words. The word family fv carries only
   the executed loads; each t1 cell holds the executed march word
   modSignedWord (fv i) pw p0w r2w rxw. -/
namespace FT1536.Source3.StepWalkFixed195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open ZintModSignedWord194 (modSignedWord)
open StepCopyBody190 (addr elem output next)

structure Fixed (s : State) (srcName : Name) (src t1 : ArrayPointer) (n : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32) : Prop where
  nBound : n<2^64
  srcWidth : src.elementBytes=4
  t1Width : t1.elementBytes=4
  srcCapacity : src.index+0+n*1≤src.count
  t1Capacity : t1.index+n≤t1.count
  t1Writable : s.heap.writable t1.block=true
  srcName_different : srcName≠"x".toList
  srcBinding : s.arrays srcName=some src
  t1Binding : s.arrays "t1".toList=some t1
  nCell : Cell s "n".toList n
  slenCell : Cell s "slen".toList 1
  pSlot : Slot s "p" pw
  p0iSlot : Slot s "p0i" p0w
  r2Slot : Slot s "R2" r2w
  rxSlot : Slot s "Rx" rxw
  t1Allocated : ∀ i : Fin n, Allocated s.heap (elem t1 i)
  t1Separate : ∀ v i : Fin n, Separate (elem t1 v) (addr src 0 i 1)
  prefixSeparate : ∀ i j : Fin n, i≠j → Separate (elem t1 i) (elem t1 j)
  loads : ∀ i : Fin n, Load32 s.heap (addr src 0 i 1) (fv i)

def PrefixImage (s : State) (t1 : ArrayPointer) {n : Nat} (fv : Fin n → BitVec 32)
    (pw p0w r2w rxw : BitVec 32) (v : Nat) : Prop :=
  ∀ i : Fin n, i.val<v → Load32 s.heap (elem t1 i) (modSignedWord (fv i) pw p0w r2w rxw)

/- Capacity facts of the marched pointer (StepWalkBody195.march_capacity
   and StepWalkBody195.march_capacity_next, u0 = 0, slen = 1) transfer
   verbatim from the copy-loop capacities. -/

/- The march step keeps the whole invariant. -/
theorem next_fixed (s : State) (srcName : Name) (src t1 : ArrayPointer) (n v : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw) (slot : v<n) :
    Fixed (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
      srcName src t1 n fv pw p0w r2w rxw := by
  refine ⟨fixed.nBound,fixed.srcWidth,fixed.t1Width,fixed.srcCapacity,fixed.t1Capacity,?_,?_,
    ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact fixed.t1Writable
  · exact fixed.srcName_different
  · rw [StepCopyFixed190.next_arrays s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      srcName fixed.srcName_different]
    exact fixed.srcBinding
  · rw [StepCopyFixed190.next_arrays s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "t1".toList (by decide)]
    exact fixed.t1Binding
  · exact StepCopyFixed190.next_cell s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "n".toList n (by decide) fixed.nCell
  · exact StepCopyFixed190.next_cell s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "slen".toList 1 (by decide) fixed.slenCell
  · show (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)).locals "p".toList=
      some (.uint32,some (.uint32 pw))
    rw [StepCopyFixed190.next_locals s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "p".toList (by decide)]
    exact fixed.pSlot
  · show (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)).locals "p0i".toList=
      some (.uint32,some (.uint32 p0w))
    rw [StepCopyFixed190.next_locals s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "p0i".toList (by decide)]
    exact fixed.p0iSlot
  · show (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)).locals "R2".toList=
      some (.uint32,some (.uint32 r2w))
    rw [StepCopyFixed190.next_locals s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "R2".toList (by decide)]
    exact fixed.r2Slot
  · show (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)).locals "Rx".toList=
      some (.uint32,some (.uint32 rxw))
    rw [StepCopyFixed190.next_locals s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      "Rx".toList (by decide)]
    exact fixed.rxSlot
  · intro i
    rw [StepCopyFixed190.next_heap]
    exact fixed.t1Allocated i
  · intro v' i
    exact fixed.t1Separate v' i
  · intro i j different
    exact fixed.prefixSeparate i j different
  · intro i
    rw [StepCopyFixed190.next_heap]
    exact Word32Memory176.outside s.heap (elem t1 v) (addr src 0 i 1)
      (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw) (fv i) (fixed.t1Separate ⟨v,slot⟩ i)
      (fixed.loads i)

/- The march step fills exactly the next t1 cell of the executed image. -/
theorem next_prefix (s : State) (srcName : Name) (src t1 : ArrayPointer) (n v : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw) (slot : v<n)
    (copied : PrefixImage s t1 fv pw p0w r2w rxw v) :
    PrefixImage (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
      t1 fv pw p0w r2w rxw (v+1) := by
  intro i bound
  rw [StepCopyFixed190.next_heap]
  by_cases same : i.val=v
  · have key : i=⟨v,slot⟩ := Fin.ext same
    subst key
    exact Word32Memory176.here s.heap (elem t1 v) (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
      (fixed.t1Allocated ⟨v,slot⟩) fixed.t1Width fixed.t1Writable
  · have different : (⟨v,slot⟩ : Fin n)≠i := fun equal =>
      same (congrArg Fin.val equal).symm
    exact Word32Memory176.outside s.heap (elem t1 v) (elem t1 i)
      (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw) (modSignedWord (fv i) pw p0w r2w rxw)
      (fixed.prefixSeparate ⟨v,slot⟩ i different) (copied i (by omega))

end FT1536.Source3.StepWalkFixed195
