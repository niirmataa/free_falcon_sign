import Source3.StepProductFixed203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Induction for the original pair-product loop, on the exact source
   statements; the written image is only the executed loads and the two
   nested Montgomery multiplications. -/
namespace FT1536.Source3.StepProductAllKeep203
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value output next)
open StepProductFixed203 (Fixed Image)
open KeygenMakeFgSource (Exec)

theorem guard (s : State) (v n : Nat) (vBound : v<2^64) (nBound : n<2^64)
    (vCell : Cell s "v".toList v) (nCell : Cell s "hn".toList n) :
    C99ArrayReference.scalar s MakeFgProductShape191.productCondition
      (C99ScalarReference.boolean (decide (v<n))) :=
  C99LoopScalar141.less s MakeFgProductShape191.varV MakeFgProductShape191.varHn v n vBound nBound
    (C99LoopScalar141.read s "v".toList v vCell) (C99LoopScalar141.read s "hn".toList n nCell)

theorem source_reads (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) (v : Nat) (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv) (slot : v<n) :
    Load32 s.heap (elem t1 (2*v)) (fv (2*v)) ∧
      Load32 s.heap (elem t1 (2*v+1)) (fv (2*v+1)) ∧ t1.index+(2*v+1)<t1.count := by
  have lower : 2*v<2*n := by omega
  have upper : 2*v+1<2*n := by omega
  refine ⟨fixed.src ⟨2*v,lower⟩,fixed.src ⟨2*v+1,upper⟩,?_⟩
  have base := (StepProductFixed203.load_allocated (fixed.src ⟨2*v+1,upper⟩)).2.2.1
  simpa [StepCopyBody190.elem] using base

theorem remaining (count v : Nat) (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr fd u0 v tlen))
    (image : Image s fd u0 tlen n p p0i r2 fv v) (finish : v+count=n) :
    ∃ after, Exec MakeFgProductShape191.productLoop s ⟨after,.normal⟩ ∧
      Fixed after fd t1 u0 tlen n p p0i r2 fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fd u0 n tlen) ∧
      Image after fd u0 tlen n p p0i r2 fv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin n, Word32Memory176.Separate (addr fd u0 i.val tlen) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have false : C99ArrayReference.scalar s MakeFgProductShape191.productCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepProductAllKeep203.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,vCell,xBinding,image,
      fun _ _ => rfl,fun _ _ => rfl,fun _ _ _ h => h⟩
  | succ count ih =>
    have slot : v<n := by omega
    have nonzero : (C99ScalarReference.boolean (decide (v<n))).integer≠0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    obtain ⟨read0,read1,t1Capacity⟩ := source_reads s fd t1 u0 tlen n p p0i r2 fv v fixed slot
    have body : Exec MakeFgProductShape191.productBody s
        ⟨output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i),.normal⟩ :=
      StepProductBody191.body_source s fd t1 u0 tlen v p p0i r2 (fv (2*v)) (fv (2*v+1))
        (by have := fixed.nBound; omega) (by have := fixed.nWide; omega)
        (StepProductFixed203.product_capacity s fd u0 tlen v (fixed.fdAllocated ⟨v,slot⟩))
        t1Capacity fixed.fdWidth fixed.fdWritable fixed.t1Binding xBinding vCell
        fixed.pCell fixed.iCell fixed.r2Cell read0 read1 (fixed.fdAllocated ⟨v,slot⟩)
    have bodyFixed : Fixed (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        fd t1 u0 tlen n p p0i r2 fv :=
      StepProductFixed203.output_fixed s fd t1 u0 tlen n p p0i r2 fv v
        (value (fv (2*v)) (fv (2*v+1)) r2 p p0i) fixed slot
    have bodyImage : Image (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        fd u0 tlen n p p0i r2 fv (v+1) :=
      StepProductFixed203.output_prefix s fd t1 u0 tlen n p p0i r2 fv v fixed slot image
    have update : Exec MakeFgProductShape191.productInc
        (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        ⟨next (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v,.normal⟩ :=
      StepProductBody191.inc_source
        (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v
        (by have := fixed.nBound; omega) fixed.tlenBound
        (StepProductFixed203.product_capacity_next fd u0 tlen n v fixed.fdCapacity slot)
        vCell fixed.tlenCell xBinding
    set tail : State := next (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
      fd u0 tlen v with tailEq
    have tailFixed : Fixed tail fd t1 u0 tlen n p p0i r2 fv := by
      rw [tailEq]
      exact StepProductFixed203.next_fixed _ fd t1 u0 tlen n p p0i r2 fv v bodyFixed
    have tailV : Cell tail "v".toList (v+1) := by
      rw [tailEq]
      exact StepProductFixed203.next_v _ fd u0 tlen v
    have tailX : tail.arrays "x".toList=some (addr fd u0 (v+1) tlen) := by
      rw [tailEq]
      exact StepProductFixed203.next_x _ fd u0 tlen v
    have tailImage : Image tail fd u0 tlen n p p0i r2 fv (v+1) := by
      rw [tailEq]
      exact StepProductFixed203.next_prefix _ fd u0 tlen n p p0i r2 fv v bodyImage
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalImage,finalLocals,finalArrays,finalKeep⟩ :=
      ih (v+1) tail tailFixed tailV tailX tailImage (by omega)
    refine ⟨after,?_,finalFixed,finalV,finalX,finalImage,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s
        (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) tail
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepProductAllKeep203.guard s v n (by have := fixed.nBound; omega) fixed.nBound
        vCell fixed.nCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact (StepProductFixed203.next_locals
          (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v name
          different)
      exact (finalLocals name different).trans first
    · intro name different
      have first : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (StepProductFixed203.next_arrays
          (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v name
          different)
      exact (finalArrays name different).trans first
    · intro q separate w loaded
      apply finalKeep q separate w
      rw [tailEq,StepProductFixed203.next_heap,StepProductFixed203.output_heap]
      exact Word32Memory176.outside s.heap (addr fd u0 v tlen) q
        (value (fv (2*v)) (fv (2*v+1)) r2 p p0i) w (separate ⟨v,slot⟩) loaded


theorem source (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv)
    (vCell : Cell s "v".toList 0) (xBinding : s.arrays "x".toList=some (addr fd u0 0 tlen))
    (image : Image s fd u0 tlen n p p0i r2 fv 0) :
    ∃ after, Exec MakeFgProductShape191.productLoop s ⟨after,.normal⟩ ∧
      Fixed after fd t1 u0 tlen n p p0i r2 fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fd u0 n tlen) ∧
      Image after fd u0 tlen n p p0i r2 fv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin n, Word32Memory176.Separate (addr fd u0 i.val tlen) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) :=
  remaining n 0 s fd t1 u0 tlen n p p0i r2 fv fixed vCell xBinding image (by omega)

end FT1536.Source3.StepProductAllKeep203
