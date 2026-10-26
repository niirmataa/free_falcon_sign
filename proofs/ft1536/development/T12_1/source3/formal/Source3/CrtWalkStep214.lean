import Source3.CrtWalkFixed214

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkStep214
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open CrtWalkIncrement214 (row point next row_element)
open CrtWalkFixed214 (Fixed Pending Written)
open KeygenZintCall (Exec)

theorem step (s : State) (root tmp : ArrayPointer) (n len stride v : Nat) (rows : Nat → Nat → BitVec 32) (T : Nat → BitVec 32)
    (p pi r2 c : BitVec 32) (fixed : Fixed s root tmp n len stride T p pi r2 c) (slot : v < n) (vc : Cell s "v".toList v)
    (xb : s.arrays "x".toList=some (row root stride v)) (pending : Pending s root n len stride rows v)
    (written : Written s root len stride rows T p pi r2 c v) :
    ∃ mid out, Exec CrtRoundShape205.coeff s ⟨mid,.normal⟩ ∧
      Exec CrtRoundShape205.increment mid ⟨out,.normal⟩ ∧ Fixed out root tmp n len stride T p pi r2 c ∧
      Cell out "v".toList (v+1) ∧ out.arrays "x".toList=some (row root stride (v+1)) ∧
      Pending out root n len stride rows (v+1) ∧ Written out root len stride rows T p pi r2 c (v+1) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ j, j ≤ len → Separate (point root stride v j) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have reads : ∀ j, j ≤ len → Load32 s.heap (elem (row root stride v) j) (rows v j) := by
    intro j bound; rw [row_element]; exact pending v (Nat.le_refl v) slot j bound
  have apart : ∀ j k, j < len → k < len → Separate (elem (row root stride v) j) (elem tmp k) := by
    intro j k jb kb; rw [row_element]; exact fixed.apart v j k slot (by omega) kb
  obtain ⟨mid,body,image,callerLocals,callerArrays,callKeep⟩:=CrtCoefficient214.source s (row root stride v) tmp len (rows v) T p pi r2 c
    xb fixed.tmpBinding fixed.uCell fixed.pCell fixed.iCell fixed.rCell fixed.sCell fixed.lenBound
    (CrtWalkFixed214.row_capacity root n len stride v fixed.capacity slot fixed.room) fixed.tmpCapacity fixed.width reads fixed.tmpRead apart fixed.writable
  have vMid : Cell mid "v".toList v := (congrFun callerLocals _).trans vc
  have strideMid : Cell mid "xstride".toList stride := (congrFun callerLocals _).trans fixed.strideCell
  have xMid : mid.arrays "x".toList=some (row root stride v) := (congrFun callerArrays _).trans xb
  have update:=CrtWalkIncrement214.source mid root stride v (by have h:=fixed.nBound; omega) fixed.strideBound vMid strideMid xMid
    (ZintNormWalkFixed208.row_capacity root n stride v fixed.capacity slot)
  have keep (q : ArrayPointer) (old : BitVec 32) (apart : ∀ j, j ≤ len → Separate (point root stride v j) q)
      (read : Load32 s.heap q old) : Load32 (next mid root stride v).heap q old := by
    apply callKeep q old _ read
    intro j bound; rw [row_element]; exact apart j bound
  have hl (name : Name) (nv : name≠"v".toList) : (next mid root stride v).locals name=s.locals name :=
    (CrtWalkIncrement214.locals mid root stride v name nv).trans (congrFun callerLocals name)
  have ha (name : Name) (nx : name≠"x".toList) : (next mid root stride v).arrays name=s.arrays name :=
    (CrtWalkIncrement214.arrays mid root stride v name nx).trans (congrFun callerArrays name)
  have stable:=KeygenMemoryStability.zint _ _ _ body
  have writableEq : mid.heap.writable=s.heap.writable := stable.writable
  have afterFixed : Fixed (next mid root stride v) root tmp n len stride T p pi r2 c := by
    refine ⟨fixed.nBound,fixed.lenBound,fixed.strideBound,fixed.room,fixed.width,fixed.capacity,?_,?_,?_,?_,?_,?_,?_,?_,?_,fixed.tmpCapacity,?_,fixed.apart⟩
    · change mid.heap.writable root.block=true; rw [writableEq]; exact fixed.writable
    · exact (ha _ (by decide)).trans fixed.tmpBinding
    · exact (hl _ (by decide)).trans fixed.numCell
    · exact (hl _ (by decide)).trans fixed.uCell
    · exact (hl _ (by decide)).trans fixed.strideCell
    · exact (hl _ (by decide)).trans fixed.pCell
    · exact (hl _ (by decide)).trans fixed.iCell
    · exact (hl _ (by decide)).trans fixed.rCell
    · exact (hl _ (by decide)).trans fixed.sCell
    · intro j bound
      exact keep _ _ (fun k kb => fixed.apart v k j slot kb bound) (fixed.tmpRead j bound)
  refine ⟨mid,next mid root stride v,body,update,afterFixed,CrtWalkIncrement214.counter mid root stride v,
    CrtWalkIncrement214.pointer mid root stride v,?_,?_,hl,ha,keep⟩
  · intro i remaining before j bound
    apply keep _ _ _ (pending i (by omega) before j bound)
    intro k kb
    exact CrtWalkFixed214.different root len stride v i k j fixed.width fixed.room kb bound (by omega)
  · intro i before j bound
    by_cases same : i=v
    · subst i
      have read:=image j (by omega)
      rw [row_element] at read
      exact read
    · apply keep _ _ _ (written i (by omega) j bound)
      intro k kb
      exact CrtWalkFixed214.different root len stride v i k j fixed.width fixed.room kb bound (by omega)

end FT1536.Source3.CrtWalkStep214
