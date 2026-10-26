import Source3.SecondExtraPrime212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SignedWalkFixed212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem addr output next)
open Word32Memory176 (Separate)

def words (W : Nat → BitVec 32) (len v : Nat) (p pi r2 rx : BitVec 32) :=
  ZintSignedStore212.value (fun j => W (v*len+j)) len p pi r2 rx

structure Fixed (s : State) (src t1 : ArrayPointer) (n len : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32) : Prop where
  nBound : n < 2^64
  lenBound : len < 2^64
  nCell : Cell s "n".toList n
  lenCell : Cell s "slen".toList len
  pCell : Slot s "p" p
  iCell : Slot s "p0i" pi
  r2Cell : Slot s "R2" r2
  rxCell : Slot s "Rx" rx
  t1Binding : s.arrays "t1".toList=some t1
  srcCapacity : src.index+n*len ≤ src.count
  dstCapacity : t1.index+n ≤ t1.count
  width : t1.elementBytes=4
  writable : s.heap.writable t1.block=true
  allocated : ∀ i, i < n → Allocated s.heap (elem t1 i)
  data : ∀ i, i < n*len → Load32 s.heap (elem src i) (W i)
  apart : ∀ v i, v < n → i < n*len → Separate (elem t1 v) (elem src i)

 def Image (s : State) (t1 : ArrayPointer) (len : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32) (v : Nat) : Prop :=
  ∀ i, i < v → Load32 s.heap (elem t1 i) (words W len i p pi r2 rx)

 theorem source_address (src : ArrayPointer) (len v j : Nat) : elem (addr src 0 v len) j=elem src (v*len+j) := by
  exact congrArg (fun k : Nat => (⟨src.block,src.base,src.count,src.elementBytes,k⟩ : ArrayPointer))
    (show src.index+0+v*len+j=src.index+(v*len+j) by omega)

end FT1536.Source3.SignedWalkFixed212
