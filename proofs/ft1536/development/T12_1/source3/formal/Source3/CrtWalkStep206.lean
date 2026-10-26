import Source3.CrtWalkFixed206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkStep206
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open CrtWalkIncrement206 (cell)
open CrtWalkFixed206 (Fixed Pending Written high lowWord highWord)

def output (s : State) (root : ArrayPointer) (v : Nat) (a b t p pi r2 c : BitVec 32) :=
  CrtCoefficient205.after s (cell root v) a b t p pi r2 c
 def next (s : State) (root : ArrayPointer) (v : Nat) (a b t p pi r2 c : BitVec 32) :=
  CrtWalkIncrement206.next (output s root v a b t p pi r2 c) root v

theorem next_locals (s : State) (root : ArrayPointer) (v : Nat) (a b t p pi r2 c : BitVec 32)
    (name : Name) (different : name≠"v".toList) :
    (next s root v a b t p pi r2 c).locals name=s.locals name :=
  (CrtWalkIncrement206.locals _ root v name different).trans
    (congrFun (CrtCoefficient205.restored_locals s (cell root v) a b t p pi r2 c) name)

theorem next_arrays (s : State) (root : ArrayPointer) (v : Nat) (a b t p pi r2 c : BitVec 32)
    (name : Name) (different : name≠"x".toList) :
    (next s root v a b t p pi r2 c).arrays name=s.arrays name :=
  CrtWalkIncrement206.arrays _ root v name different

theorem step {n : Nat} (s : State) (root tmp : ArrayPointer) (v : Nat)
    (av bv : Fin n → BitVec 32) (t p pi r2 c : BitVec 32)
    (fixed : Fixed s root tmp n t p pi r2 c) (slot : v < n)
    (vc : Cell s "v".toList v) (xb : s.arrays "x".toList=some (cell root v))
    (pending : Pending s root av bv v) (written : Written s root av bv t p pi r2 c v) :
    let a:=av ⟨v,slot⟩; let b:=bv ⟨v,slot⟩
    let mid:=output s root v a b t p pi r2 c
    let out:=next s root v a b t p pi r2 c
    KeygenZintCall.Exec CrtRoundShape205.coeff s ⟨mid,.normal⟩ ∧
      KeygenZintCall.Exec CrtRoundShape205.increment mid ⟨out,.normal⟩ ∧
      Fixed out root tmp n t p pi r2 c ∧ Cell out "v".toList (v+1) ∧
      out.arrays "x".toList=some (cell root (v+1)) ∧
      Pending out root av bv (v+1) ∧ Written out root av bv t p pi r2 c (v+1) ∧
      (∀ q old, Separate (cell root v) q → Separate (high root v) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have reads:=pending ⟨v,slot⟩ (Nat.le_refl v)
  have cap : (cell root v).index+1 < (cell root v).count := by
    have bound:=fixed.capacity
    change root.index+2*v+1 < root.count
    omega
  have image:=CrtCoefficientImage205.source s (cell root v) tmp (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c
    xb fixed.tmpBinding fixed.uCell fixed.pCell fixed.iCell fixed.rCell fixed.sCell reads.1 reads.2 fixed.tmpRead cap fixed.writable
  have vMid : Cell (output s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c) "v".toList v :=
    (congrFun image.2.1 "v".toList).trans vc
  have strideMid : Cell (output s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c) "xstride".toList 2 :=
    (congrFun image.2.1 "xstride".toList).trans fixed.strideCell
  have xMid : (output s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c).arrays "x".toList=some (cell root v) :=
    (congrFun image.2.2.1 "x".toList).trans xb
  have update:=CrtWalkIncrement206.source _ root v (by have bound:=fixed.nBound; omega) vMid strideMid xMid
    (by have bound:=fixed.capacity; omega)
  have keep (q : ArrayPointer) (old : BitVec 32) (lo : Separate (cell root v) q) (hi : Separate (high root v) q)
      (read : Load32 s.heap q old) :
      Load32 (next s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c).heap q old :=
    image.2.2.2.2.2 q old lo hi read
  have hl:=next_locals s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c
  have ha:=next_arrays s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c
  have afterFixed : Fixed (next s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c) root tmp n t p pi r2 c := by
    refine ⟨fixed.nBound,fixed.width,fixed.capacity,fixed.writable,?_,?_,?_,?_,?_,?_,?_,?_,?_,fixed.apart⟩
    · exact (ha "tmp".toList (by decide)).trans fixed.tmpBinding
    · exact (hl "u".toList (by decide)).trans fixed.uCell
    · exact (hl "p".toList (by decide)).trans fixed.pCell
    · exact (hl "p0i".toList (by decide)).trans fixed.iCell
    · exact (hl "R2".toList (by decide)).trans fixed.rCell
    · exact (hl "s".toList (by decide)).trans fixed.sCell
    · exact (hl "num".toList (by decide)).trans fixed.numCell
    · exact (hl "xstride".toList (by decide)).trans fixed.strideCell
    · exact keep tmp t (fixed.apart ⟨v,slot⟩).1 (fixed.apart ⟨v,slot⟩).2 fixed.tmpRead
  refine ⟨image.1,update,afterFixed,CrtWalkIncrement206.counter (output s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c) root v,CrtWalkIncrement206.pointer (output s root v (av ⟨v,slot⟩) (bv ⟨v,slot⟩) t p pi r2 c) root v,?_,?_,keep⟩
  · intro i remaining
    have sep:=CrtWalkFixed206.different root fixed.width v i.val (by omega)
    have old:=pending i (by omega)
    exact ⟨keep _ _ sep.1 sep.2.2.1 old.1,keep _ _ sep.2.1 sep.2.2.2 old.2⟩
  · intro i before
    by_cases equal : i.val=v
    · have key : i=⟨v,slot⟩ := Fin.ext equal
      subst key
      exact ⟨image.2.2.2.1,image.2.2.2.2.1⟩
    · have sep:=CrtWalkFixed206.different root fixed.width v i.val (by omega)
      have old:=written i (by omega)
      exact ⟨keep _ _ sep.1 sep.2.2.1 old.1,keep _ _ sep.2.1 sep.2.2.2 old.2⟩

end FT1536.Source3.CrtWalkStep206
