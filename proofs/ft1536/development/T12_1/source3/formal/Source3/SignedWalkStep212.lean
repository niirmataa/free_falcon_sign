import Source3.SignedWalkFixed212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SignedWalkStep212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr output next)
open SignedWalkFixed212 (Fixed Image words source_address)
open KeygenMakeFgSource (Exec)

theorem source (s : State) (src t1 : ArrayPointer) (n len v : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (fixed : Fixed s src t1 n len W p pi r2 rx) (slot : v < n) (vc : Cell s "v".toList v)
    (xb : s.arrays "x".toList=some (addr src 0 v len)) (image : Image s t1 len W p pi r2 rx v) :
    let val:=words W len v p pi r2 rx
    let mid:=output s t1 v val; let out:=next s src t1 0 len v val
    Exec MakeFgAddPrimeShape194.walkBody s ⟨mid,.normal⟩ ∧ Exec MakeFgAddPrimeShape194.walkInc mid ⟨out,.normal⟩ ∧
      Fixed out src t1 n len W p pi r2 rx ∧ Cell out "v".toList (v+1) ∧
      out.arrays "x".toList=some (addr src 0 (v+1) len) ∧ Image out t1 len W p pi r2 rx (v+1) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Separate (elem t1 v) q → Load32 s.heap q old → Load32 out.heap q old) := by
  have cap : (addr src 0 v len).index+len ≤ (addr src 0 v len).count := by
    have order : (v+1)*len ≤ n*len := Nat.mul_le_mul_right len (by omega)
    rw [Nat.add_mul,Nat.one_mul] at order
    change src.index+0+v*len+len ≤ src.count
    have bound:=fixed.srcCapacity
    omega
  have data : ∀ j, j < len → Load32 s.heap (elem (addr src 0 v len) j) (W (v*len+j)) := by
    intro j bound
    rw [source_address]
    exact fixed.data _ (ZintNormWalkFlat208.index_bound n len v j slot bound)
  have call:=ZintSignedStore212.source s (addr src 0 v len) t1 len v (fun j => W (v*len+j)) p pi r2 rx xb fixed.t1Binding fixed.lenCell vc
    fixed.lenBound (by have bound:=fixed.nBound; omega) fixed.pCell fixed.iCell fixed.r2Cell fixed.rxCell cap data (fixed.allocated v slot) fixed.width fixed.writable
  have body : Exec MakeFgAddPrimeShape194.walkBody s ⟨output s t1 v (words W len v p pi r2 rx),.normal⟩ :=
    .scope _ _ _ _ _ (.seqNormal _ _ _ _ _ (.zint _ _ _ call.1) (MakeFgDeclarations176.array_source .skip _ _ (.skip _)))
  have update:=StepCopyBody190.inc_source s src t1 0 len v (words W len v p pi r2 rx) (by have b:=fixed.nBound; omega) fixed.lenBound
    cap vc fixed.lenCell xb
  have hl:=StepCopyFixed203.next_locals s src t1 0 len v (words W len v p pi r2 rx)
  have ha:=StepCopyFixed203.next_arrays s src t1 0 len v (words W len v p pi r2 rx)
  have keep (q : ArrayPointer) (old : BitVec 32) (separate : Separate (elem t1 v) q) (read : Load32 s.heap q old) :
      Load32 (next s src t1 0 len v (words W len v p pi r2 rx)).heap q old := call.2.2 q old separate read
  have afterFixed : Fixed (next s src t1 0 len v (words W len v p pi r2 rx)) src t1 n len W p pi r2 rx := by
    refine ⟨fixed.nBound,fixed.lenBound,?_,?_,?_,?_,?_,?_,?_,fixed.srcCapacity,fixed.dstCapacity,fixed.width,fixed.writable,fixed.allocated,?_,fixed.apart⟩
    · exact (hl "n".toList (by decide)).trans fixed.nCell
    · exact (hl "slen".toList (by decide)).trans fixed.lenCell
    · exact (hl "p".toList (by decide)).trans fixed.pCell
    · exact (hl "p0i".toList (by decide)).trans fixed.iCell
    · exact (hl "R2".toList (by decide)).trans fixed.r2Cell
    · exact (hl "Rx".toList (by decide)).trans fixed.rxCell
    · exact (ha "t1".toList (by decide)).trans fixed.t1Binding
    · intro i bound
      exact keep _ _ (fixed.apart v i slot bound) (fixed.data i bound)
  refine ⟨body,update,afterFixed,StepCopyLoop190.next_v s src t1 0 len v (words W len v p pi r2 rx),StepCopyFixed190.next_x s src t1 0 len v (words W len v p pi r2 rx),?_,hl,ha,keep⟩
  intro i bound
  by_cases same : i=v
  · subst i
    exact call.2.1
  · exact keep _ _ (StepCopyFixed203.elem_separate t1 fixed.width v i (by omega)) (image i (by omega))

end FT1536.Source3.SignedWalkStep212
