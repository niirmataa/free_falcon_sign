import Source3.NttForwardBranch211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSignedStore212
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open C99NatWord141 (word)
open KeygenZintCall (Exec)

def value (W : Nat → BitVec 32) (len : Nat) (p pi r2 rx : BitVec 32) := ZintSignedWhole209.resultWord W len p pi r2 rx
 def after (s : State) (t1 : ArrayPointer) (v : Nat) (W : Nat → BitVec 32) (len : Nat) (p pi r2 rx : BitVec 32) :=
  {s with heap:=Word32Memory176.write s.heap (elem t1 v) (value W len p pi r2 rx)}

theorem source (s : State) (pd t1 : ArrayPointer) (len v : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (db : s.arrays "x".toList=some pd) (tb : s.arrays "t1".toList=some t1) (lc : Cell s "slen".toList len)
    (vc : Cell s "v".toList v) (lb : len < 2^64) (vb : v < 2^64)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2) (rxc : Slot s "Rx" rx)
    (cap : pd.index+len ≤ pd.count) (data : ∀ i, i < len → Load32 s.heap (elem pd i) (W i))
    (allocated : Allocated s.heap (elem t1 v)) (width : t1.elementBytes=4) (writable : s.heap.writable t1.block=true) :
    Exec MakeFgAddPrimeShape194.modCall s ⟨after s t1 v W len p pi r2 rx,.normal⟩ ∧
      Load32 (after s t1 v W len p pi r2 rx).heap (elem t1 v) (value W len p pi r2 rx) ∧
      (∀ q old, Separate (elem t1 v) q → Load32 s.heap q old → Load32 (after s t1 v W len p pi r2 rx).heap q old) := by
  let entry:=ZintSignedCall209.entry s pd len p pi r2 rx
  have holds:=ZintSignedCall209.cells s pd len p pi r2 rx
  have fixed : ZintReduceLoop209.Fixed entry pd len W p pi r2 :=
    ⟨lb,holds.1,holds.2.1,holds.2.2.1,holds.2.2.2.1,holds.2.2.2.2.1,cap,data⟩
  obtain ⟨out,run,returned,heap,_,_⟩:=ZintSignedWhole209.source entry pd len W p pi r2 rx fixed holds.2.2.2.2.2
  have address : Pointer s "t1".toList (.var "v".toList) (elem t1 v) := by
    refine .add _ _ t1 _ (.uint64 (word v)) tb (.variable _ _ _ vc) ?_ ?_
    · rw [C99NatWord141.integer v vb]; omega
    · rw [C99NatWord141.integer v vb]
      exact .within t1 v (by have h:=allocated.2.2.1; change t1.index+v < t1.count at h; omega)
  have call : Exec MakeFgAddPrimeShape194.modCall s ⟨after s t1 v W len p pi r2 rx,.normal⟩ := by
    refine .call s .modSigned MakeFgAddPrimeShape194.modArgs (.store "t1".toList MakeFgAddPrimeShape194.varV) entry out
      (some (.uint32 (value W len p pi r2 rx))) _
      (ZintSignedCall209.binding "x" "slen" s pd len p pi r2 rx db lc pc ic rc rxc (by omega)) run returned ?_
    rw [heap]
    refine .store _ _ _ _ (elem t1 v) (.uint32 (value W len p pi r2 rx)) address ?_
    change C99MemoryReference.Store32 s.heap (elem t1 v) (BitVec.ofInt 32 ((value W len p pi r2 rx).toNat : Int)) _
    rw [ZintSubWord194.ofInt_word]
    exact Word32Memory176.source _ _ _ allocated width writable
  exact ⟨call,Word32Memory176.here _ _ _ allocated width writable,
    fun q old separate read => Word32Memory176.outside _ _ _ _ _ separate read⟩

end FT1536.Source3.ZintSignedStore212
