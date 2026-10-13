import Source3.KeygenPublicEncodeCertified077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeCertifiedLoop077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077

theorem done (args : Args) (test : Expr) (body : Stmt) (s : State)
    (value : IV) (last : Locals) (calculation : Computes args s.heap s.buf test s.locals value last)
    (no : truth (.integer value)=false) : Checked args (.whileLoop test body) s (withLocals s last) .normal := by
  refine ⟨.whileDone args test body s (.integer value) last (computes_exists _ _ _ _ _ _ _ calculation) no,?_⟩
  intro after result source
  cases source with
  | whileDone test body s actualValue actualLocals evaluated actualNo =>
    obtain ⟨_,same⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualLocals
    exact ⟨rfl,rfl⟩
  | whileNext test body s middle after result actualValue actualLocals evaluated actualYes iteration rest =>
    obtain ⟨same,_⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; rw [no] at actualYes; cases actualYes
  | whileReturn test body s after ret actualValue actualLocals evaluated actualYes iteration =>
    obtain ⟨same,_⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; rw [no] at actualYes; cases actualYes
theorem next (args : Args) (test : Expr) (body : Stmt) (s m t : State) (flow : Flow)
    (value : IV) (last : Locals) (calculation : Computes args s.heap s.buf test s.locals value last)
    (yes : truth (.integer value)=true)
    (iteration : Checked args body (withLocals s last) m .normal)
    (rest : Checked args (.whileLoop test body) m t flow) : Checked args (.whileLoop test body) s t flow := by
  refine ⟨.whileNext args test body s m t flow (.integer value) last (computes_exists _ _ _ _ _ _ _ calculation) yes iteration.run rest.run,?_⟩
  intro after result source
  cases source with
  | whileDone test body s actualValue actualLocals evaluated actualNo =>
    obtain ⟨same,_⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; rw [yes] at actualNo; cases actualNo
  | whileNext test body s middle after result actualValue actualLocals evaluated actualYes actualIteration actualRest =>
    obtain ⟨same,endLocals⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; subst actualLocals
    obtain ⟨same,_⟩ := iteration.unique _ _ actualIteration
    subst middle
    exact rest.unique _ _ actualRest
  | whileReturn test body s after ret actualValue actualLocals evaluated actualYes actualIteration =>
    obtain ⟨same,endLocals⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; subst actualLocals
    cases (iteration.unique _ _ actualIteration).2
theorem return_exit (args : Args) (test : Expr) (body : Stmt) (s t : State) (ret : BitVec 64)
    (value : IV) (last : Locals) (calculation : Computes args s.heap s.buf test s.locals value last)
    (yes : truth (.integer value)=true)
    (iteration : Checked args body (withLocals s last) t (.returned ret)) :
    Checked args (.whileLoop test body) s t (.returned ret) := by
  refine ⟨.whileReturn args test body s t ret (.integer value) last (computes_exists _ _ _ _ _ _ _ calculation) yes iteration.run,?_⟩
  intro after result source
  cases source with
  | whileDone test body s actualValue actualLocals evaluated actualNo =>
    obtain ⟨same,_⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; rw [yes] at actualNo; cases actualNo
  | whileNext test body s middle after result actualValue actualLocals evaluated actualYes actualIteration actualRest =>
    obtain ⟨same,endLocals⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; subst actualLocals
    cases (iteration.unique _ _ actualIteration).2
  | whileReturn test body s after actualRet actualValue actualLocals evaluated actualYes actualIteration =>
    obtain ⟨same,endLocals⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; subst actualLocals
    exact iteration.unique _ _ actualIteration
theorem forLoop (args : Args) (initial : Stmt) (test : Option Expr) (increment body : Stmt)
    (s t : State) (flow : Flow)
    (expanded : Checked args (desugar initial test increment body) s t flow) :
    Checked args (.loop initial test increment body) s t flow := by
  refine ⟨.forLoop args initial test increment body s t flow expanded.run,?_⟩
  intro after result source
  cases source with
  | forLoop initial test increment body s after result actualExpanded => exact expanded.unique _ _ actualExpanded

end FT1536.Source3.KeygenPublicEncodeCertifiedLoop077
