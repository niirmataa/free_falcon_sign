import Source3.KeygenPublicSquare

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete q18433 addition chain is walked from the existing Body
   execution. The word algorithm below is not an alternative success rule:
   its equality with the observed return is a theorem about that Body. -/
namespace FT1536.Source3.KeygenPublicDivisionWords
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ModularReference (Expr Stmt GenEval GenExec)
open KeygenPublicScalar (Kind name Square)
open KeygenPublicSquare (Slot converted_word)
open KeygenPublicMontgomery (modulus inverse)

inductive Operand where
  | slot (n : String) | number (n : Nat)
  deriving DecidableEq, Repr
inductive Instruction where
  | mul (dst : String) (a b : Operand)
  | square (dst : String) (a : Operand)
  deriving DecidableEq, Repr
def firstNames : List String := ["y0","y1","y2","y3","y4","y5","y6","y7","y8","y9"]
def lastNames : List String := ["y10","y11","y12","y13","y14","y15","y16","y17","y18"]
def names : List String := ["x","y"]++firstNames++lastNames
def operand : Operand → Expr
  | .slot n => .scalar (.var n.toList)
  | .number n => .scalar (.literal .i32 n)
def word (env : String → BitVec 32) : Operand → BitVec 32
  | .slot n => env n | .number n => BitVec.ofNat 32 n
def target : Instruction → String | .mul n _ _ | .square n _ => n
def expression : Instruction → Expr
  | .mul _ a b => .call4 (name .mul) (operand a) (operand b) (operand (.number 18433)) (operand (.number 18431))
  | .square _ a => .call3 (name .square) (operand a) (operand (.number 18433)) (operand (.number 18431))
def result (env : String → BitVec 32) : Instruction → BitVec 32
  | .mul _ a b => KeygenPublicLeafWords.montgomery (word env a) (word env b) modulus inverse
  | .square _ a => KeygenPublicLeafWords.montgomery (word env a) (word env a) modulus inverse
def update (env : String → BitVec 32) (step : Instruction) : String → BitVec 32 :=
  fun n => if n=target step then result env step else env n
def run (steps : List Instruction) (env : String → BitVec 32) : String → BitVec 32 := steps.foldl update env
def statement (step : Instruction) : Stmt := .assign (target step).toList (expression step)
def chain : List Instruction → Stmt → Stmt
  | [],tail => tail | step::rest,tail => .seq (statement step) (chain rest tail)
def operandAllowed : Operand → Bool | .slot n => names.contains n | .number _ => true
def allowed : Instruction → Bool
  | .mul n a b => names.contains n && operandAllowed a && operandAllowed b
  | .square n a => names.contains n && operandAllowed a
def Ready (s : State) (env : String → BitVec 32) : Prop :=
  ∀ n, n∈names → s.locals n.toList=some (.uint32,none) ∨ Slot s n (env n)
def steps : List Instruction := [
  .mul "y0" (.slot "y") (.number 4564),.square "y1" (.slot "y0"),
  .mul "y2" (.slot "y1") (.slot "y0"),.square "y3" (.slot "y2"),
  .mul "y4" (.slot "y3") (.slot "y0"),.square "y5" (.slot "y4"),
  .square "y6" (.slot "y5"),.mul "y7" (.slot "y6") (.slot "y4"),
  .mul "y8" (.slot "y7") (.slot "y6"),.square "y9" (.slot "y8"),
  .square "y10" (.slot "y9"),.mul "y11" (.slot "y10") (.slot "y7"),
  .square "y12" (.slot "y11"),.square "y13" (.slot "y12"),
  .square "y14" (.slot "y13"),.square "y15" (.slot "y14"),
  .square "y16" (.slot "y15"),.square "y17" (.slot "y16"),
  .mul "y18" (.slot "y17") (.slot "y8")]
def finalStep : Instruction := .mul "x" (.slot "y18") (.slot "x")
def tail : Stmt := .seq (.ret (expression finalStep)) (.base .skip)
def code : Stmt := .seq (.base (.scalar (.declare .u32 (firstNames.map String.toList))))
  (.seq (.base (.scalar (.declare .u32 (lastNames.map String.toList)))) (chain steps tail))
def initial (x y : BitVec 32) : String → BitVec 32 := fun n => if n="x" then x else if n="y" then y else 0
def division (x y : BitVec 32) : BitVec 32 := result (run steps (initial x y)) finalStep
theorem source_code : KeygenPublicScalar.code .divT=code := by decide
theorem allowed_steps : steps.all allowed=true := by decide
theorem allowed_final : allowed finalStep=true := by decide

theorem operand_value (s : State) (env : String → BitVec 32) (a : Operand) (v : Value)
    (ready : Ready s env) (legal : operandAllowed a=true) (source : GenEval Square s (operand a) v) :
    KeygenPublicArguments.U32 v (word env a) := by
  cases a with
  | number n =>
      cases source
      cases ‹C99ArrayReference.scalar _ _ _›
      exact KeygenPublicArguments.u32_literal n
  | slot n =>
      have present : n∈names := List.contains_iff_mem.mp legal
      rcases ready n present with uninitialized | initialized
      · cases source
        cases ‹C99ArrayReference.scalar _ _ _› with
        | «variable» _ _ _ bound => simp [uninitialized] at bound
      · have equal := KeygenPublicSquare.variable_value Square s n (env n) v initialized source
        rw [equal]
        exact KeygenPublicArguments.u32_self _

theorem expression_value (s : State) (env : String → BitVec 32) (step : Instruction) (v : Value)
    (ready : Ready s env) (legal : allowed step=true) (source : GenEval Square s (expression step) v) :
    v=.uint32 (result env step) := by
  cases step with
  | mul n a b =>
      have ha : operandAllowed a=true := (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp legal).1).2
      have hb : operandAllowed b=true := (Bool.and_eq_true_iff.mp legal).2
      cases source with
      | call4 _ _ _ _ _ av bv qv iv _ first second third fourth invoked =>
          exact KeygenPublicArguments.source_mul_exact (word env a) (word env b) av bv qv iv v
            (operand_value s env a av ready ha first) (operand_value s env b bv ready hb second)
            (operand_value s env (.number 18433) qv ready rfl third)
            (operand_value s env (.number 18431) iv ready rfl fourth) (.square _ _ _ invoked)
  | square n a =>
      have ha : operandAllowed a=true := (Bool.and_eq_true_iff.mp legal).2
      cases source with
      | call3 _ _ _ _ av qv iv _ first second third invoked =>
          exact KeygenPublicSquare.source_square_arguments (word env a) av qv iv v
            (operand_value s env a av ready ha first)
            (operand_value s env (.number 18433) qv ready rfl second)
            (operand_value s env (.number 18431) iv ready rfl third) invoked

theorem step_ready (s : State) (env : String → BitVec 32) (step : Instruction) (out : Result)
    (ready : Ready s env) (legal : allowed step=true) (source : GenExec Square (statement step) s out) :
    out.flow=.normal ∧ Ready out.state (update env step) := by
  have targetAllowed : (target step)∈names := by
    cases step with
    | mul n a b => exact List.contains_iff_mem.mp ((Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp legal).1).1)
    | square n a => exact List.contains_iff_mem.mp (Bool.and_eq_true_iff.mp legal).1
  have incoming : ∃ old, s.locals (target step).toList=some (.uint32,old) := by
    rcases ready (target step) targetAllowed with declared | initialized
    · exact ⟨none,declared⟩
    · exact ⟨some (.uint32 (env (target step))),initialized⟩
  obtain ⟨previous,incomingSlot⟩ := incoming
  cases source with
  | assign _ _ _ ty old v slot evaluated =>
      have typeEqual : ty=.uint32 := congrArg Prod.fst (Option.some.inj (slot.symm.trans incomingSlot))
      subst ty
      have equal := expression_value s env step v ready legal evaluated
      subst v
      refine ⟨rfl,?_⟩
      intro n hn
      by_cases same : n=target step
      · right
        subst n
        simp [Slot,C99ArrayReference.bindValue,C99ScalarReference.set,update,converted_word]
      · rcases ready n hn with uninitialized | initialized
        · left
          simpa only [C99ArrayReference.bindValue,C99ScalarReference.set,show n.toList≠(target step).toList from
            fun h => same (String.toList_injective h),ite_false] using uninitialized
        · right
          simpa only [Slot,C99ArrayReference.bindValue,C99ScalarReference.set,update,same,ite_false,
            show n.toList≠(target step).toList from fun h => same (String.toList_injective h)] using initialized

theorem chain_execution (instructions : List Instruction) (finish : Stmt) (s : State)
    (env : String → BitVec 32) (out : Result) (ready : Ready s env)
    (legal : instructions.all allowed=true) (source : GenExec Square (chain instructions finish) s out) :
    ∃ last, Ready last (run instructions env) ∧ GenExec Square finish last out := by
  induction instructions generalizing s env with
  | nil => exact ⟨s,ready,source⟩
  | cons step rest ih =>
      have hs : allowed step=true := (Bool.and_eq_true_iff.mp legal).1
      have hr : rest.all allowed=true := (Bool.and_eq_true_iff.mp legal).2
      cases source with
      | seqNormal _ _ _ middle _ first remaining =>
          have after := (step_ready s env step ⟨middle,.normal⟩ ready hs first).2
          exact ih middle (update env step) after hr remaining
      | seqExit _ _ _ _ first exit => exact False.elim (exit (step_ready s env step out ready hs first).1)

theorem base_tail (calls : C99ModularReference.CallRelation) (head : C99ArrayReference.Stmt) (finish : Stmt)
    (s : State) (out : Result) (source : GenExec calls (.seq (.base head) finish) s out) :
    ∃ middle, C99ArrayReference.Exec FftLeafPrograms.program head s middle ∧ GenExec calls finish middle out := by
  cases source with
  | seqNormal _ _ _ middle _ first remaining => cases first; exact ⟨middle,‹_›,remaining⟩
  | seqExit _ _ _ _ first exit => cases first; exact False.elim (exit rfl)
theorem declared_locals (ns : List String) (s middle : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program (.scalar (.declare .u32 (ns.map String.toList))) s middle) :
    middle.locals=C99DeclarationCells.declareCells .uint32 (ns.map String.toList) s.locals := by
  cases source with
  | scalar _ env _ execution =>
      exact C99ScalarReference.Result.normal.inj (C99DeclarationCells.complete _ _ _ _ (.normal env) execution)
theorem ready_entry (x y : BitVec 32) (s : State)
    (slots : s.locals=C99DeclarationCells.declareCells .uint32 (lastNames.map String.toList)
      (C99DeclarationCells.declareCells .uint32 (firstNames.map String.toList)
        (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .divT) [.uint32 x,.uint32 y]).locals)) :
    Ready s (initial x y) := by
  intro n hn
  simp [names,firstNames,lastNames] at hn
  rcases hn with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
    rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  all_goals unfold Slot
  all_goals rw [slots]
  all_goals first
    | exact Or.inl rfl
    | (right; simp [initial,firstNames,lastNames,C99DeclarationCells.declareCells,
        KeygenPublicScalar.params,C99ModularReference.bindParams,C99ArrayReference.bindValue,
        C99ScalarReference.set,KeygenPublicScalar.empty,converted_word])

theorem ternary_body (args : List Value) (v : Value) (source : KeygenPublicScalar.Call (name .divT) args v) :
    KeygenPublicScalar.Body Square .divT args v := by
  generalize hn : name Kind.divT=n at source
  cases source with
  | ternary _ _ execution => exact execution
  | binary _ _ execution => simp [name] at hn
  | square _ _ _ square =>
      cases square with
      | leaf _ _ _ leaf =>
          cases leaf with
          | run kind _ _ allowed execution =>
              have equal := KeygenPublicAlgebra.name_injective hn
              subst kind
              simp [KeygenPublicScalar.IsLeaf] at allowed
      | square _ _ execution => simp [name] at hn

theorem source_exact (x y : BitVec 32) (v : Value)
    (source : KeygenPublicScalar.Call (name .divT) [.uint32 x,.uint32 y] v) : v=.uint32 (division x y) := by
  obtain ⟨out,execution,returned⟩ := (ternary_body _ v source).2
  rw [source_code] at execution
  obtain ⟨first,declared1,remaining1⟩ := base_tail _ _ _ _ out execution
  obtain ⟨second,declared2,remaining2⟩ := base_tail _ _ _ first out remaining1
  have h1 := declared_locals firstNames _ first declared1
  have h2 := declared_locals lastNames first second declared2
  have ready := ready_entry x y second (h2.trans (congrArg (C99DeclarationCells.declareCells .uint32
    (lastNames.map String.toList)) h1))
  obtain ⟨last,lastReady,finish⟩ := chain_execution steps tail second (initial x y) out ready allowed_steps remaining2
  obtain ⟨raw,flow,evaluated⟩ := KeygenPublicSquare.ret_expression Square _ last out finish
  have rawEqual := expression_value last (run steps (initial x y)) finalStep raw lastReady allowed_final evaluated
  obtain ⟨actual,actualFlow,equal⟩ := KeygenPublicLinear.return_value out.flow v returned
  have actualEqual : actual=raw := Option.some.inj (C99ProcedureReference.Flow.returned.inj (actualFlow.symm.trans flow))
  rw [actualEqual,rawEqual,converted_word] at equal
  exact equal

end FT1536.Source3.KeygenPublicDivisionWords
