import Source3.NinthStepExtraInvariant217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NinthStepExtraIteration217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (addr)
open NinthStepLayout217 (fd gd)
open NinthStepExtraLoopBase217
open NinthStepExtraInvariant217 (Active ExtraRow)
open NinthStepInvariant217 (putTables)
open NinthStepExtraInner217 (Earlier)

theorem source (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32) (u : Nat)
    (active : Active s F G RF RG tables u) (lower : 166 ≤ u) (slot : u<335) :
    ∃ (mid : State) (gvs : Fin 2 → BitVec 32),
      Exec MakeFgAddPrimeShape194.aBody s ⟨scopedState s mid,.normal⟩ ∧
      Exec MakeFgAddPrimeShape194.aInc (scopedState s mid) ⟨counter s mid (u+1),.normal⟩ ∧
      Active (counter s mid (u+1)) F G RF RG (putTables tables u gvs) (u+1) := by
  have input : CrtPrimePrefix214.Input s u (extraRow u) :=
    ⟨by omega,active.outer.uCell,extraRow_value u slot,active.outer.primesBinding,active.object⟩
  obtain ⟨mid,gvs,inner,basic,fdImage,gdImage,_,_,keep⟩:=
    NinthStepExtraInner217.source s u (extraRow u) RF RG active.outer input slot
      active.revBinding active.revSource active.fData active.gData
  have objectMid:=object_keep active.object inner
  have revMid:=rev_keep active.revSource inner
  have revBMid:=revB_keep active.revBinding inner
  refine ⟨mid,gvs,scope_source s mid inner,incrementK s mid u slot basic.uCell,?_⟩
  refine ⟨outer_counter basic s (u+1),?_,?_,?_,?_,?_,?_,?_⟩
  · rw [counter_heap]; exact objectMid
  · exact revBMid
  · rw [counter_heap]; exact revMid
  · intro i bound; rw [counter_heap]
    exact fs_keep_u keep active.fData slot i bound
  · intro i bound; rw [counter_heap]
    exact gs_keep_u keep active.gData slot i bound
  · constructor
    · intro k kb i bound
      rw [counter_heap]
      exact keep (addr fd k i.val 335) _ (earlier_col .f u k slot (by omega) (by omega) i.val i.isLt) (active.first.f k kb i bound)
    · intro k kb i bound
      rw [counter_heap]
      exact keep (addr gd k i.val 335) _ (earlier_col .g u k slot (by omega) (by omega) i.val i.isLt) (active.first.g k kb i bound)
  · intro k kl earlier kb
    by_cases same : k=u
    · subst k
      refine ⟨?_,?_⟩
      · intro i bound; rw [counter_heap]
        simpa only [putTables,ite_true] using fdImage i bound
      · intro i bound; rw [counter_heap]
        simpa only [putTables,ite_true] using gdImage i bound
    · have old:=active.written k kl (by omega) kb
      have tableEq : putTables tables u gvs k=tables k := by simp only [putTables,same,ite_false]
      refine ⟨?_,?_⟩
      · intro i bound; rw [counter_heap,tableEq]
        exact image_keep (u:=u) (k:=k) (side:=.f) keep old.f (by omega) slot kb i bound
      · intro i bound; rw [counter_heap,tableEq]
        exact image_keep (u:=u) (k:=k) (side:=.g) keep old.g (by omega) slot kb i bound

end FT1536.Source3.NinthStepExtraIteration217
