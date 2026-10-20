import Source3.KeygenMakeReadySampling
import Source3.KeygenCallerSuccess

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-checked nonwrites to enclosing scalar cells. Fixed calls restore
   caller cells by their operational rules. This is not a callee/frame oracle;
   the checks below traverse the SAME bound norm/GS bodies. -/
namespace FT1536.Source3.KeygenMakeLocalFrame
open C99ArrayReference (State Name)
open C99ProcedureReference (Result Destination)
open KeygenSearchContext (Context)

def scalarKeep (n : Name) : CLogic.Stmt → Bool
  | .declare _ names => !names.contains n
  | .assign dst _ | .update dst _ _ => n != dst
  | .ret _ => false
def arrayKeep (n : Name) : C99ArrayReference.Stmt → Bool
  | .scalar code => scalarKeep n code
  | .assign dst _ => n != dst
  | .seq a b | .branch _ a b => arrayKeep n a && arrayKeep n b
  | .scope _ _ body | .while _ body => arrayKeep n body
  | _ => true
def receiveKeep (n : Name) : Destination → Bool
  | .discard => true
  | .assign dst | .update dst _ => n != dst
def procedureKeep (n : Name) : C99ProcedureReference.Stmt → Bool
  | .base code => arrayKeep n code
  | .seq a b | .branch _ a b | .loop _ a b => procedureKeep n a && procedureKeep n b
  | .scope _ _ body => procedureKeep n body
  | .call _ _ dst => receiveKeep n dst
  | _ => true
def searchKeep (n : Name) : KeygenSearchExec.Stmt → Bool
  | .procedure code => procedureKeep n code
  | .logn dst | .assign dst _ => n != dst
  | .seq a b | .branch _ a b | .loop _ a b => searchKeep n a && searchKeep n b
  | .scope _ _ body => searchKeep n body
  | _ => true

theorem declared (ty : C99IntegerReference.Ty) (ns : List Name) (env : C99ScalarReference.Env)
    (n : Name) (outside : n∉ns) : C99DeclarationCells.declareCells ty ns env n=env n := by
  induction ns generalizing env with
  | nil => rfl
  | cons name rest ih =>
    have distinct : n≠name := fun h => outside (by simp [h])
    rw [C99DeclarationCells.declareCells,ih _ (fun h => outside (by simp [h]))]
    simp only [C99ScalarReference.set,distinct,ite_false]
theorem scalar (code : CLogic.Stmt) (before after : C99ScalarReference.Env) (n : Name)
    (checked : scalarKeep n code=true)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls before (C99Frontend.scalar code) (.normal after)) :
    after n=before n := by
  cases code with
  | declare ty ns =>
    have equal := C99ScalarReference.Result.normal.inj
      (C99DeclarationCells.complete _ _ ns before (.normal after) source)
    subst after
    apply declared
    intro member
    have present := List.contains_iff_mem.mpr member
    change (!ns.contains n)=true at checked
    rw [present] at checked
    cases checked
  | assign dst rhs | update dst op rhs =>
    cases source
    have distinct : n≠dst := by simpa only [scalarKeep,bne_iff_ne] using checked
    simp only [C99ScalarReference.set,distinct,ite_false]
  | ret e => cases checked
theorem restored (before after : State) (locals pointers : List Name) (n : Name)
    (same : after.locals n=before.locals n) :
    (C99ArrayReference.restoreScope before after locals pointers).locals n=before.locals n := by
  simp only [C99ArrayReference.restoreScope,C99ScalarReference.restore,same,ite_self]
theorem array (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt)
    (before after : State) (source : C99ArrayReference.Exec program code before after)
    (n : Name) (checked : arrayKeep n code=true) : after.locals n=before.locals n := by
  induction source with
  | scalar before env code execution => exact scalar code before.locals env n checked execution
  | assign before dst e ty old v binding value =>
    have distinct : n≠dst := by simpa only [arrayKeep,bne_iff_ne] using checked
    simp only [C99ArrayReference.bindValue,C99ScalarReference.set,distinct,ite_false]
  | seq a b before middle after first second ih1 ih2 =>
    exact (ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1)
  | scope locals pointers body before after inner ih => exact restored _ _ _ _ n (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 => exact (ih2 checked).trans (ih1 checked)
  | skip | declarePtr | bindPtr | store64 | store32 | copy | whileFalse | call => rfl
theorem receive (dst : Destination) (before after : State) (value : Option C99IntegerReference.Value)
    (source : C99ProcedureReference.Receive dst before value after) (n : Name) (checked : receiveKeep n dst=true) :
    after.locals n=before.locals n := by
  cases source with
  | discard => rfl
  | assign s name v ty old declared | update s name op old v result ty declared operation =>
    have distinct : n≠name := by simpa only [receiveKeep,bne_iff_ne] using checked
    simp only [C99ArrayReference.bindValue,C99ScalarReference.set,distinct,ite_false]
theorem procedure (program : C99ProcedureReference.Program) (code : C99ProcedureReference.Stmt)
    (before : State) (out : Result) (source : C99ProcedureReference.Exec program code before out)
    (n : Name) (checked : procedureKeep n code=true) : out.state.locals n=before.locals n := by
  induction source with
  | base code before after body => exact array _ _ _ _ body n checked
  | seqNormal a b before middle out head tail ih1 ih2 =>
    exact (ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1)
  | seqExit _ _ _ _ head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out source ih => exact restored _ _ _ _ n (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3
  | loopContinue condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact (ih3 checked).trans ((ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1))
  | loopBreak _ _ _ _ _ _ _ _ _ ih | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | call name args dst f before entry after out returned lookup binding body conversion rec ih =>
    exact receive dst _ after returned rec n checked
  | returnVoid | returnValue | breakLoop | continueLoop | loopFalse => rfl
theorem search (ctx : Context) (code : KeygenSearchExec.Stmt) (before : State) (out : Result)
    (source : KeygenSearchExec.Exec ctx code before out) (n : Name) (checked : searchKeep n code=true) :
    out.state.locals n=before.locals n := by
  induction source with
  | procedure code before out source => exact procedure _ _ _ _ source n checked
  | logn dst before ty old word binding source | assign dst e before ty old v binding value =>
    have distinct : n≠dst := by simpa only [searchKeep,bne_iff_ne] using checked
    simp only [C99ArrayReference.bindValue,C99ScalarReference.set,distinct,ite_false]
  | small args before after source => cases source; rfl
  | seqNormal a b before middle out head tail ih1 ih2 =>
    exact (ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1)
  | seqExit _ _ _ _ head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out source ih => exact restored _ _ _ _ n (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact (ih3 checked).trans ((ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | pointer | store32 | store64 | move | loopFalse => rfl

def fixed : List Name := ["local_attempts","logn","ter","n","comp"].map String.toList
theorem checked_bodies : ∀ n∈fixed,
    searchKeep n KeygenAttemptNorm.boundCode=true ∧ searchKeep n KeygenNormFrame.code=true ∧
    searchKeep n KeygenAttemptNorm.headCode=true ∧ searchKeep n KeygenAttemptNorm.tailCode=true := by decide +kernel
theorem raw (ctx : Context) (before : State) (out : Result) (source : KeygenNormFrame.Exec ctx before out)
    (n : Name) (checked : searchKeep n KeygenNormFrame.code=true) : out.state.locals n=before.locals n := by
  cases source with
  | run ready out computation gate =>
    have keep := search ctx _ before ⟨ready,.normal⟩ computation n checked
    cases gate <;> exact keep
theorem gs (ctx : Context) (before : State) (out : Result) (source : KeygenAttemptNorm.GS ctx before out)
    (n : Name) (head : searchKeep n KeygenAttemptNorm.headCode=true)
    (tail : searchKeep n KeygenAttemptNorm.tailCode=true) : out.state.locals n=before.locals n := by
  cases source with
  | run initial first second ready out headSource scale1 scale2 tailSource gate =>
    have a := search ctx _ before ⟨initial,.normal⟩ headSource n head
    have b := congrFun (KeygenAttemptFft.slots _ _ _ scale1).1 n
    have c := congrFun (KeygenAttemptFft.slots _ _ _ scale2).1 n
    have d := search ctx _ second ⟨ready,.normal⟩ tailSource n tail
    cases gate <;> exact d.trans (c.trans (b.trans a))
theorem norm (ctx : Context) (before : State) (out : Result) (source : KeygenAttemptNorm.Exec ctx before out)
    (n : Name) (member : n∈fixed) : out.state.locals n=before.locals n := by
  obtain ⟨hb,hr,hh,ht⟩ := checked_bodies n member
  cases source with
  | rawRejected bounded out initial source rejected =>
    exact (raw ctx bounded out source n hr).trans (search ctx _ before ⟨bounded,.normal⟩ initial n hb)
  | gs bounded middle out initial source gram =>
    exact (gs ctx middle out gram n hh ht).trans
      ((raw ctx bounded ⟨middle,.normal⟩ source n hr).trans (search ctx _ before ⟨bounded,.normal⟩ initial n hb))
theorem resultants (before : State) (out : Result) (source : KeygenResultantGate.Exec before out) :
    out.state.locals=before.locals := by
  cases source with
  | firstReject after v first zero => cases first; rfl
  | secondReject middle after x y first nonzero second zero
  | accepted middle after x y first nonzero second last => cases first; cases second; rfl
theorem ternary (ctx : Context) (before : State) (out : Result) (source : KeygenCallerPrefix.Ternary ctx before out)
    (n : Name) (member : n∈fixed) : out.state.locals n=before.locals n := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    rw [resultants _ _ gate,KeygenMakeSampling.sampler_locals _ _ _ _ second,KeygenMakeSampling.sampler_locals _ _ _ _ first]
  | norm middle sampled res out first second gate normed =>
    exact (norm ctx res out normed n member).trans (by
      rw [resultants _ _ gate,KeygenMakeSampling.sampler_locals _ _ _ _ second,KeygenMakeSampling.sampler_locals _ _ _ _ first])

end FT1536.Source3.KeygenMakeLocalFrame
