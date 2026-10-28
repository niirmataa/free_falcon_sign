import Source3.DeepestBezoutReject217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Conditional source consequence; the selected Boolean itself is not assumed. -/
namespace FT1536.Source3.SelectedBezoutReject217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open SelectedBezoutGuard217 (state bad)

noncomputable def rootAfter (rebuilt : State) : State := {SelectedDeepestEntry175.caller with heap:=rebuilt.heap}

theorem consequence (made rebuilt : State) (F G : Nat → BitVec 32)
    (part2 : KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩)
    (crt : KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩)
    (binding : C99ArrayReference.Bind rebuilt (KeygenZintCall.params .bezout) DeepestBezoutEntry217.args (DeepestBezoutEntry217.entry rebuilt))
    (pre : KeygenZintCall.Exec SelectedBezoutPrefix217.prefixCode (DeepestBezoutEntry217.entry rebuilt) ⟨BezoutPointerSetup217.after rebuilt,.normal⟩)
    (lengths : KeygenZintCall.Exec (KeygenZintCall.bezoutPart 2) (BezoutPointerSetup217.after rebuilt) ⟨state rebuilt F G,.normal⟩)
    (guard : KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G)
      ⟨state rebuilt F G,if bad F G then .returned (some (.int32 0)) else .normal⟩)
    (badCase : bad F G=true) :
    KeygenDeepestSource.Call env.ctx SelectedDeepestEntry175.caller (rootAfter rebuilt) (.int32 0) ∧
    KeygenRootSearch.Exec env.ctx SelectedRootStart175.entry ⟨rootAfter rebuilt,.returned (some (.int32 0))⟩ := by
  obtain ⟨p,decl,ptr⟩:=BezoutEarlyReturn217.split_prefix _ _ pre
  have guardReturn : KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G)
      ⟨state rebuilt F G,.returned (some (.int32 0))⟩ := by simpa only [badCase,ite_true] using guard
  have bezout := BezoutEarlyReturn217.source _ _ _ _ decl ptr lengths guardReturn
  have heap : (state rebuilt F G).heap=rebuilt.heap := by
    change (BezoutPointerSetup217.after rebuilt).heap=rebuilt.heap
    exact BezoutPointerSetup217.heap rebuilt
  have rest := DeepestBezoutReject217.source rebuilt (state rebuilt F G) binding bezout heap
  have part3 : KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 3) made ⟨rebuilt,.returned (some (.int32 0))⟩ := by
    rw [DeepestCrtSource217.shape]
    exact .seqNormal _ _ _ _ _ crt rest
  have tail : KeygenDeepestSource.Exec env.ctx (SelectedDeepestPrefix175.remaining) made ⟨rebuilt,.returned (some (.int32 0))⟩ :=
    .seqExit _ _ _ _ part3 (by intro impossible; cases impossible)
  have whole : KeygenDeepestSource.Exec env.ctx KeygenDeepestSource.code SelectedDeepestEntry175.entry ⟨rebuilt,.returned (some (.int32 0))⟩ :=
    .seqNormal _ _ _ _ _ (DeepestDeclarations175.source env.ctx SelectedDeepestEntry175.entry)
      (.seqNormal _ _ _ _ _ SelectedDeepestConfig175.source (.seqNormal _ _ _ _ _ part2 tail))
  have deepest : KeygenDeepestSource.Call env.ctx SelectedDeepestEntry175.caller (rootAfter rebuilt) (.int32 0) :=
    .run SelectedDeepestEntry175.entry ⟨rebuilt,.returned (some (.int32 0))⟩ (.int32 0)
      SelectedDeepestEntry175.binding whole (.value .int32 _)
  have reject : KeygenRootSearch.Gate env.ctx .deepest SelectedRootStart175.ready ⟨rootAfter rebuilt,.returned (some (.int32 0))⟩ :=
    .reject _ (.int32 0) deepest rfl
  exact ⟨deepest,.deepestRejected _ _ SelectedRootStart175.source reject⟩

end FT1536.Source3.SelectedBezoutReject217
