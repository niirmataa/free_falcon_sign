import Source3.KeygenProperModular096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ModularArity096
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ModularReference

instance arityDecidable (name : C99ArrayReference.Name) (count : Nat) : Decidable (KeygenProperModular096.Arity name count) := by
  unfold KeygenProperModular096.Arity
  infer_instance

def arity (name : C99ArrayReference.Name) (count : Nat) : Bool := decide (KeygenProperModular096.Arity name count)

def checkedExpr : Expr → Bool
  | .scalar _ | .load32 _ _ | .load16 _ _ => true
  | .call1 name a => arity name 1 && checkedExpr a
  | .call2 name a b => arity name 2 && checkedExpr a && checkedExpr b
  | .call3 name a b c => arity name 3 && checkedExpr a && checkedExpr b && checkedExpr c
  | .call4 name a b c d => arity name 4 && checkedExpr a && checkedExpr b && checkedExpr c && checkedExpr d
  | .call5 name a b c d e => arity name 5 && checkedExpr a && checkedExpr b && checkedExpr c && checkedExpr d && checkedExpr e

def checkedCode : Stmt → Bool
  | .base _ | .retVoid => true
  | .assign _ e | .store32 _ _ e | .storeRev _ _ _ _ e | .ret e => checkedExpr e
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ body => checkedCode body

theorem call (name : C99ArrayReference.Name) (args : List Value) (out : Value)
    (checked : arity name args.length = true) (source : ModCall name args out) :
    KeygenProperModular096.Call name args out := ⟨source, of_decide_eq_true checked⟩

theorem expression_lift (s : State) (e : Expr) (v : Value) (checked : checkedExpr e = true)
    (source : GenEval ModCall s e v) : GenEval KeygenProperModular096.Call s e v := by
  induction source with
  | scalar e v source => exact .scalar e v source
  | load32 name index p word address read => exact .load32 name index p word address read
  | load16 name index p word address read => exact .load16 name index p word address read
  | call1 name a x out arg source ih =>
      obtain ⟨hc, ha⟩ := Bool.and_eq_true_iff.mp checked
      exact .call1 name a x out (ih ha) (call name [x] out hc source)
  | call2 name a b x y out first second source ih1 ih2 =>
      obtain ⟨hab, hb⟩ := Bool.and_eq_true_iff.mp checked
      obtain ⟨hc, ha⟩ := Bool.and_eq_true_iff.mp hab
      exact .call2 name a b x y out (ih1 ha) (ih2 hb) (call name [x, y] out hc source)
  | call3 name a b c x y z out first second third source ih1 ih2 ih3 =>
      have facts : arity name 3 = true ∧ checkedExpr a = true ∧ checkedExpr b = true ∧ checkedExpr c = true := by
        simpa only [checkedExpr, Bool.and_eq_true, and_assoc] using checked
      exact .call3 name a b c x y z out (ih1 facts.2.1) (ih2 facts.2.2.1) (ih3 facts.2.2.2)
        (call name [x, y, z] out facts.1 source)
  | call4 name a b c d x y z t out first second third fourth source ih1 ih2 ih3 ih4 =>
      have facts : arity name 4 = true ∧ checkedExpr a = true ∧ checkedExpr b = true ∧ checkedExpr c = true ∧ checkedExpr d = true := by
        simpa only [checkedExpr, Bool.and_eq_true, and_assoc] using checked
      exact .call4 name a b c d x y z t out (ih1 facts.2.1) (ih2 facts.2.2.1) (ih3 facts.2.2.2.1) (ih4 facts.2.2.2.2)
        (call name [x, y, z, t] out facts.1 source)
  | call5 name a b c d e x y z t u out first second third fourth fifth source ih1 ih2 ih3 ih4 ih5 =>
      have facts : arity name 5 = true ∧ checkedExpr a = true ∧ checkedExpr b = true ∧ checkedExpr c = true ∧ checkedExpr d = true ∧ checkedExpr e = true := by
        simpa only [checkedExpr, Bool.and_eq_true, and_assoc] using checked
      exact .call5 name a b c d e x y z t u out (ih1 facts.2.1) (ih2 facts.2.2.1) (ih3 facts.2.2.2.1)
        (ih4 facts.2.2.2.2.1) (ih5 facts.2.2.2.2.2) (call name [x, y, z, t, u] out facts.1 source)

theorem execution_lift (code : Stmt) (before : State) (out : Result) (checked : checkedCode code = true)
    (source : GenExec ModCall code before out) : GenExec KeygenProperModular096.Call code before out := by
  induction source with
  | base code before after source => exact .base code before after source
  | assign name e before ty old v declared value => exact .assign name e before ty old v declared (expression_lift before e v checked value)
  | store32 name index e before after p v address value write =>
      exact .store32 name index e before after p v address (expression_lift before e v checked value) write
  | storeRev name table base index e before after p q bv word v baseValue tableAddress tableRead address value write =>
      exact .storeRev name table base index e before after p q bv word v baseValue tableAddress tableRead address
        (expression_lift before e v checked value) write
  | seqNormal a b before middle out head tail ih1 ih2 =>
      obtain ⟨ha, hb⟩ := Bool.and_eq_true_iff.mp checked
      exact .seqNormal a b before middle out (ih1 ha) (ih2 hb)
  | seqExit a b before out head exit ih => exact .seqExit a b before out (ih (Bool.and_eq_true_iff.mp checked).1) exit
  | scope locals body before out inner ih => exact .scope locals body before out (ih checked)
  | branchTrue c yes no before out v guard nonzero body ih => exact .branchTrue c yes no before out v guard nonzero (ih (Bool.and_eq_true_iff.mp checked).1)
  | branchFalse c yes no before out v guard zero body ih => exact .branchFalse c yes no before out v guard zero (ih (Bool.and_eq_true_iff.mp checked).2)
  | loopFalse c body increment before v guard zero => exact .loopFalse c body increment before v guard zero
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨ha, hb⟩ := Bool.and_eq_true_iff.mp checked
      exact .loopNormal c body increment before middle next out v guard nonzero (ih1 ha) (ih2 hb) (ih3 checked)
  | loopReturn c body increment before after v value guard nonzero iteration ih =>
      exact .loopReturn c body increment before after v value guard nonzero (ih (Bool.and_eq_true_iff.mp checked).1)
  | ret e before v value => exact .ret e before v (expression_lift before e v checked value)
  | retVoid => exact .retVoid _

theorem expression_unique (s : State) (e : Expr) (a b : Value) (checked : checkedExpr e = true)
    (first : Eval s e a) (second : Eval s e b) : a = b :=
  C99ModularDeterminism095.expression KeygenProperModular096.Call KeygenProperModular096.calls s e a b
    (expression_lift s e a checked first) (expression_lift s e b checked second)

theorem execution_unique (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b :=
  C99ModularDeterminism095.execution KeygenProperModular096.Call KeygenProperModular096.calls code before a b
    (execution_lift code before a checked first) (execution_lift code before b checked second)

end FT1536.Source3.C99ModularArity096
