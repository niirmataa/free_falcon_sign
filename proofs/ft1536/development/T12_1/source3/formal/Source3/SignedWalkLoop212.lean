import Source3.SignedWalkStep212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SignedWalkLoop212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr output next)
open SignedWalkFixed212 (Fixed Image words)
open KeygenMakeFgSource (Exec)

theorem guard (s : State) (v n : Nat) (vb : v < 2^64) (nb : n < 2^64)
    (vc : Cell s "v".toList v) (nc : Cell s "n".toList n) :
    C99ArrayReference.scalar s (.cmp .lt MakeFgAddPrimeShape194.varV MakeFgAddPrimeShape194.varN)
      (C99ScalarReference.boolean (decide (v < n))) :=
  C99LoopScalar141.less s _ _ v n vb nb (.variable _ _ _ vc) (.variable _ _ _ nc)

theorem remaining (count v : Nat) (s : State) (src t1 : ArrayPointer) (n len : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (fixed : Fixed s src t1 n len W p pi r2 rx) (vc : Cell s "v".toList v)
    (xb : s.arrays "x".toList=some (addr src 0 v len)) (image : Image s t1 len W p pi r2 rx v) (finish : v+count=n) :
    ∃ out, Exec MakeFgAddPrimeShape194.walkLoop s ⟨out,.normal⟩ ∧ Fixed out src t1 n len W p pi r2 rx ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (addr src 0 n len) ∧ Image out t1 len W p pi r2 rx n ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < n → Separate (elem t1 i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  induction count generalizing v s with
  | zero =>
    have eq : v=n := by omega
    subst v
    have test : C99ArrayReference.scalar s (.cmp .lt MakeFgAddPrimeShape194.varV MakeFgAddPrimeShape194.varN) (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard s n n fixed.nBound fixed.nBound vc fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),fixed,vc,xb,image,fun _ _ => rfl,fun _ _ => rfl,fun _ _ _ read => read⟩
  | succ count ih =>
    have slot : v < n := by omega
    obtain ⟨body,update,nextFixed,nextV,nextX,nextImage,nextLocals,nextArrays,keep⟩:=
      SignedWalkStep212.source s src t1 n len v W p pi r2 rx fixed slot vc xb image
    obtain ⟨out,rest,finalFixed,finalV,finalX,finalImage,finalLocals,finalArrays,finalKeep⟩:=
      ih (v+1) (next s src t1 0 len v (words W len v p pi r2 rx)) nextFixed nextV nextX nextImage (by omega)
    refine ⟨out,?_,finalFixed,finalV,finalX,finalImage,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s (output s t1 v (words W len v p pi r2 rx)) (next s src t1 0 len v (words W len v p pi r2 rx))
        ⟨out,.normal⟩ (C99ScalarReference.boolean (decide (v < n))) ?_ ?_ body update rest
      · exact guard s v n (by have h:=fixed.nBound; omega) fixed.nBound vc fixed.nCell
      · simp [slot,C99ScalarReference.boolean,Value.integer]
    · intro name different
      exact (finalLocals name different).trans (nextLocals name different)
    · intro name different
      exact (finalArrays name different).trans (nextArrays name different)
    · intro q old apart read
      exact finalKeep q old apart (keep q old (apart v slot) read)

theorem source (s : State) (src t1 : ArrayPointer) (n len : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (fixed : Fixed s src t1 n len W p pi r2 rx) (vc : Cell s "v".toList 0)
    (xb : s.arrays "x".toList=some (addr src 0 0 len)) :
    ∃ out, Exec MakeFgAddPrimeShape194.walkLoop s ⟨out,.normal⟩ ∧ Fixed out src t1 n len W p pi r2 rx ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (addr src 0 n len) ∧ Image out t1 len W p pi r2 rx n ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < n → Separate (elem t1 i) q) → Load32 s.heap q old → Load32 out.heap q old) :=
  remaining n 0 s src t1 n len W p pi r2 rx fixed vc xb (fun i h => by omega) (by omega)

end FT1536.Source3.SignedWalkLoop212
