import Source3.KeygenDecodeStaticAssignments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Compositional construction and inversion of real STATIC executions.
   Each certificate contains an actual execution AND uniqueness. It is an
   internal proof device; no whole-codec certificate is an entry premise. -/
namespace FT1536.Source3.KeygenDecodeStaticCertified
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation

structure Checked (args : Args) (code : Stmt) (s t : State) (flow : Flow) : Prop where
  run : Exec args code s t flow
  unique : ∀ after result, Exec args code s after result → after=t ∧ result=flow

theorem skip (args : Args) (s : State) : Checked args .skip s s .normal := by
  refine ⟨.skip args s,?_⟩
  intro after result source; cases source; exact ⟨rfl,rfl⟩

theorem breakLoop (args : Args) (s : State) : Checked args .breakLoop s s .broken := by
  refine ⟨.breakLoop args s,?_⟩
  intro after result source; cases source; exact ⟨rfl,rfl⟩

theorem declare (args : Args) (s : State) (objects : List Object) (locals : Locals)
    (declarations : declareLocals objects s.locals=some locals) :
    Checked args (.declare objects) s (declared s objects locals) .normal := by
  refine ⟨.declare args s objects locals declarations,?_⟩
  intro after result source
  cases source with
  | declare s objects actualLocals actualDeclarations =>
    have same := Option.some.inj (actualDeclarations.symm.trans declarations)
    subst actualLocals
    exact ⟨rfl,rfl⟩

theorem bind (args : Args) (s : State) :
    Checked args (.write (.variable "buf".toList) .set (.variable "data".toList))
      s {s with buf := some args.data} .normal := by
  refine ⟨.bind args s,?_⟩
  intro after result source
  cases source with
  | bind => exact ⟨rfl,rfl⟩
  | scalar s name op rhs ty old value result locals notBuf notData declared evaluated assigned => exact (notBuf rfl).elim

theorem assign (args : Args) (s : State) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV) (last : Locals)
    (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
    (cell : s.locals.scalars name=some (ty,old))
    (calculation : Computes args s.heap s.buf rhs s.locals v last) :
    Checked args (.write (.variable name) .set rhs) s
      (withLocals s (localSet last name ty (some (C99IntegerReference.convert ty v.integer)))) .normal :=
  ⟨KeygenDecodeStaticAssignments.assign_exists args s name ty old rhs v last notBuf notData cell calculation,
    fun after result source => KeygenDecodeStaticAssignments.assign_set args s after result name ty old rhs v last notBuf cell calculation source⟩

theorem compound (args : Args) (s : State) (name : Name)
    (ty : C99IntegerReference.Ty) (old : IV) (op : Assign) (binary : Op) (rhs : Expr)
    (value result : IV) (last : Locals)
    (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
    (cell : s.locals.scalars name=some (ty,some old)) (operator : assignOp op=some binary)
    (calculation : Computes args s.heap s.buf rhs s.locals value last)
    (operation : BinaryOp binary (.integer old) (.integer value) (.integer result)) :
    Checked args (.write (.variable name) op rhs) s
      (withLocals s (localSet last name ty (some (C99IntegerReference.convert ty result.integer)))) .normal :=
  ⟨KeygenDecodeStaticAssignments.compound_exists args s name ty old op binary rhs value result last notBuf notData cell operator calculation operation,
    fun after flow source => KeygenDecodeStaticAssignments.compound args s after flow name ty old op binary rhs value result last cell operator calculation operation source⟩

theorem evaluate (args : Args) (s : State) (e : Expr) (v : IV) (last : Locals)
    (calculation : Computes args s.heap s.buf e s.locals v last) :
    Checked args (.evaluate e) s (withLocals s last) .normal := by
  refine ⟨.evaluate args s e (.integer v) last (computes_exists _ _ _ _ _ _ _ calculation),?_⟩
  intro after result source
  cases source with
  | evaluate s e actualValue actualLocals evaluated =>
    obtain ⟨_,same⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualLocals
    exact ⟨rfl,rfl⟩

theorem ret (args : Args) (s : State) (e : Expr) (v : IV) (last : Locals)
    (calculation : Computes args s.heap s.buf e s.locals v last) :
    Checked args (.ret e) s (withLocals s last) (.returned (BitVec.ofInt 64 v.integer)) := by
  refine ⟨.ret args s e v last (computes_exists _ _ _ _ _ _ _ calculation),?_⟩
  intro after result source
  cases source with
  | ret s e actualValue actualLocals evaluated =>
    obtain ⟨same,lastEq⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    cases same; subst actualLocals
    exact ⟨rfl,rfl⟩

theorem seq (args : Args) (a b : Stmt) (s m t : State) (flow : Flow)
    (first : Checked args a s m .normal) (second : Checked args b m t flow) :
    Checked args (.seq a b) s t flow := by
  refine ⟨.seq args a b s m t flow first.run second.run,?_⟩
  intro after result source
  cases source with
  | seq a b s middle after result actualFirst actualSecond =>
    obtain ⟨same,_⟩ := first.unique _ _ actualFirst
    subst middle
    exact second.unique _ _ actualSecond
  | seqReturn a b s after ret actualFirst => cases (first.unique _ _ actualFirst).2
  | seqBreak a b s after actualFirst => cases (first.unique _ _ actualFirst).2

theorem seq_break (args : Args) (a b : Stmt) (s t : State)
    (first : Checked args a s t .broken) : Checked args (.seq a b) s t .broken := by
  refine ⟨.seqBreak args a b s t first.run,?_⟩
  intro after result source
  cases source with
  | seq a b s middle after result actualFirst actualSecond => cases (first.unique _ _ actualFirst).2
  | seqReturn a b s after ret actualFirst => cases (first.unique _ _ actualFirst).2
  | seqBreak a b s after actualFirst => exact first.unique _ _ actualFirst

theorem seq_return (args : Args) (a b : Stmt) (s t : State) (value : BitVec 64)
    (first : Checked args a s t (.returned value)) : Checked args (.seq a b) s t (.returned value) := by
  refine ⟨.seqReturn args a b s t value first.run,?_⟩
  intro after result source
  cases source with
  | seq a b s middle after result actualFirst actualSecond => cases (first.unique _ _ actualFirst).2
  | seqReturn a b s after ret actualFirst => exact first.unique _ _ actualFirst
  | seqBreak a b s after actualFirst => cases (first.unique _ _ actualFirst).2

theorem scope (args : Args) (code : Stmt) (s t : State) (flow : Flow)
    (noShadow : hasBuf (scopeObjects code)=true → s.buf=none)
    (inside : Checked args code s t flow) : Checked args (.scope code) s (scopeExit code s t) flow := by
  refine ⟨.scope args code s t flow noShadow inside.run,?_⟩
  intro after result source
  cases source with
  | scope a s actual result noBufShadow actualInside =>
    obtain ⟨same,last⟩ := inside.unique _ _ actualInside
    subst actual
    exact ⟨rfl,last⟩

theorem branch_true (args : Args) (test : Expr) (a b : Stmt) (s t : State) (flow : Flow)
    (value : IV) (last : Locals) (calculation : Computes args s.heap s.buf test s.locals value last)
    (yes : truth (.integer value)=true) (selected : Checked args a (withLocals s last) t flow) :
    Checked args (.branch test a b) s t flow := by
  refine ⟨.branchTrue args test a b s t flow (.integer value) last (computes_exists _ _ _ _ _ _ _ calculation) yes selected.run,?_⟩
  intro after result source
  cases source with
  | branchTrue test a b s after result actualValue actualLocals evaluated actualYes actualSelected =>
    obtain ⟨same,endLocals⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; subst actualLocals
    exact selected.unique _ _ actualSelected
  | branchFalse test a b s after result actualValue actualLocals evaluated actualNo actualSelected =>
    obtain ⟨same,_⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue
    rw [yes] at actualNo
    cases actualNo

theorem branch_false (args : Args) (test : Expr) (a b : Stmt) (s t : State) (flow : Flow)
    (value : IV) (last : Locals) (calculation : Computes args s.heap s.buf test s.locals value last)
    (no : truth (.integer value)=false) (selected : Checked args b (withLocals s last) t flow) :
    Checked args (.branch test a b) s t flow := by
  refine ⟨.branchFalse args test a b s t flow (.integer value) last (computes_exists _ _ _ _ _ _ _ calculation) no selected.run,?_⟩
  intro after result source
  cases source with
  | branchFalse test a b s after result actualValue actualLocals evaluated actualNo actualSelected =>
    obtain ⟨same,endLocals⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue; subst actualLocals
    exact selected.unique _ _ actualSelected
  | branchTrue test a b s after result actualValue actualLocals evaluated actualYes actualSelected =>
    obtain ⟨same,_⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
    subst actualValue
    rw [no] at actualYes
    cases actualYes

end FT1536.Source3.KeygenDecodeStaticCertified
