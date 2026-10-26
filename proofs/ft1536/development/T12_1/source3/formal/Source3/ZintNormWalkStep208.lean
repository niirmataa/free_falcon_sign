import Source3.ZintNormWalkFixed208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWalkStep208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormWalkIncrement208 (row point next row_element)
open ZintNormWalkFixed208 (Fixed Pending Written resultWord)
open KeygenZintCall (Exec)

theorem step (s : State) (root tmp : ArrayPointer) (n len v : Nat) (rows : Nat → Nat → BitVec 32) (pv : Nat → BitVec 32)
    (fixed : Fixed s root tmp n len pv) (slot : v < n) (uc : Cell s "u".toList v)
    (xb : s.arrays "x".toList=some (row root len v)) (pending : Pending s root n len rows v)
    (written : Written s root len rows pv v) :
    ∃ mid out, Exec ZintNormWalk194.walkBody s ⟨mid,.normal⟩ ∧
      Exec ZintNormWalk194.walkInc mid ⟨out,.normal⟩ ∧ Fixed out root tmp n len pv ∧
      Cell out "u".toList (v+1) ∧ out.arrays "x".toList=some (row root len (v+1)) ∧
      Pending out root n len rows (v+1) ∧ Written out root len rows pv (v+1) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ j, j < len → Separate (point root len v j) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have reads : ∀ j, j < len → Load32 s.heap (elem (row root len v) j) (rows v j) := by
    intro j bound
    rw [row_element]
    exact pending v (Nat.le_refl v) slot j bound
  have apart : ∀ j k, j < len → k < len → Separate (elem (row root len v) j) (elem tmp k) := by
    intro j k jb kb
    rw [row_element]
    exact fixed.apart v j k slot jb kb
  obtain ⟨mid,call,image,callerLocals,callerArrays,callKeep⟩:=ZintNormCall207.source s (row root len v) tmp len (rows v) pv
    xb fixed.tmpBinding fixed.lenCell fixed.lenBound fixed.width
    (ZintNormWalkFixed208.row_capacity root n len v fixed.capacity slot) fixed.pCapacity fixed.writable reads fixed.pRead apart
  have body : Exec ZintNormWalk194.walkBody s ⟨mid,.normal⟩ :=
    .scope _ _ _ _ _ (.seqNormal _ _ _ _ _ call (ZintNormWord194.word_skip mid))
  have uMid : Cell mid "u".toList v := (congrFun callerLocals "u".toList).trans uc
  have strideMid : Cell mid "xstride".toList len := (congrFun callerLocals "xstride".toList).trans fixed.strideCell
  have xMid : mid.arrays "x".toList=some (row root len v) := (congrFun callerArrays "x".toList).trans xb
  have update:=ZintNormWalkIncrement208.source mid root len v (by have h:=fixed.nBound; omega) fixed.lenBound uMid strideMid xMid
    (ZintNormWalkFixed208.row_capacity root n len v fixed.capacity slot)
  have keep (q : ArrayPointer) (old : BitVec 32) (apart : ∀ j, j < len → Separate (point root len v j) q)
      (read : Load32 s.heap q old) : Load32 (next mid root len v).heap q old := by
    apply callKeep q old _ read
    intro j bound
    rw [row_element]
    exact apart j bound
  have hl (name : Name) (nu : name≠"u".toList) : (next mid root len v).locals name=s.locals name :=
    (ZintNormWalkIncrement208.locals mid root len v name nu).trans (congrFun callerLocals name)
  have ha (name : Name) (nx : name≠"x".toList) : (next mid root len v).arrays name=s.arrays name :=
    (ZintNormWalkIncrement208.arrays mid root len v name nx).trans (congrFun callerArrays name)
  have stable:=KeygenMemoryStability.zint _ _ _ call
  have afterFixed : Fixed (next mid root len v) root tmp n len pv := by
    refine ⟨fixed.nBound,fixed.lenBound,fixed.positive,fixed.width,fixed.capacity,?_,?_,?_,?_,?_,fixed.pCapacity,?_,fixed.apart⟩
    · change mid.heap.writable root.block=true
      rw [stable.writable]
      exact fixed.writable
    · exact (ha "tmp".toList (by decide)).trans fixed.tmpBinding
    · exact (hl "num".toList (by decide)).trans fixed.numCell
    · exact (hl "xlen".toList (by decide)).trans fixed.lenCell
    · exact (hl "xstride".toList (by decide)).trans fixed.strideCell
    · intro j bound
      exact keep _ _ (fun k kb => fixed.apart v k j slot kb bound) (fixed.pRead j bound)
  refine ⟨mid,next mid root len v,body,update,afterFixed,ZintNormWalkIncrement208.counter mid root len v,
    ZintNormWalkIncrement208.pointer mid root len v,?_,?_,hl,ha,keep⟩
  · intro i remaining before j bound
    apply keep _ _ _ (pending i (by omega) before j bound)
    intro k kb
    exact ZintNormWalkFixed208.different root len v i k j fixed.width kb bound (by omega)
  · intro i before j bound
    by_cases same : i=v
    · subst i
      have read:=image j bound
      rw [row_element] at read
      exact read
    · apply keep _ _ _ (written i (by omega) j bound)
      intro k kb
      exact ZintNormWalkFixed208.different root len v i k j fixed.width kb bound (by omega)

end FT1536.Source3.ZintNormWalkStep208
