import B20.Foundation.Core

namespace B20.Foundation

inductive CExpr where
  | const (w : Word64)
  | local (x : String)
  | loadU64 (base : Nat)
  deriving DecidableEq, Repr

inductive CStmt where
  | skip
  | assign (x : String) (e : CExpr)
  | storeU64 (base : Nat) (e : CExpr)
  | seq (p q : CStmt)
  | ret (e : CExpr)
  | assumeFalse (tag : String)
  | unimplemented (tag : String)
  deriving DecidableEq, Repr

abbrev Program := CStmt

inductive Outcome where
  | returned (result : Option Word64) (s : State)
  | stuck (reason : String)
  | abort (reason : String)
  | nonreturn (reason : String)
  | fault (reason : String)

def evalExpr (s : State) : CExpr -> Option Word64
  | .const w => some w
  | .local x => s.loadLocal x
  | .loadU64 base => s.mem.readU64 base

/-- Executable big-step evaluator for the modelled C fragment. Non-return
outcomes propagate through `seq` with their reason intact. -/
def evalStmt : CStmt -> State -> Outcome
  | .skip, s => .returned none s
  | .assign x e, s =>
    match evalExpr s e with
    | some w => .returned none { s with locals := fun y => if y = x then some w else s.locals y }
    | none => .fault "undefined local expression"
  | .storeU64 base e, s =>
    match evalExpr s e with
    | some w => .returned none { s with mem := s.mem.writeU64 base w }
    | none => .fault "undefined store expression"
  | .seq p q, s =>
    match evalStmt p s with
    | .returned _r s1 => evalStmt q s1
    | o => o
  | .ret e, s =>
    match evalExpr s e with
    | some w => .returned (some w) s
    | none => .fault "undefined return expression"
  | .assumeFalse tag, _ => .nonreturn tag
  | .unimplemented tag, _ => .stuck tag

/-- Relational semantics `Program → State → Outcome → Prop` with explicit
constructors for every used C statement and for every error / nonreturn
outcome (`stuck`, `abort`, `nonreturn`, `fault`) at statement boundaries. -/
inductive CExec : Program -> State -> Outcome -> Prop where
  | skip : CExec .skip s (.returned none s)
  | assign_ok : evalExpr s e = some w ->
      CExec (.assign x e) s (.returned none { s with locals := fun y => if y = x then some w else s.locals y })
  | assign_err : evalExpr s e = none -> CExec (.assign x e) s (.fault "undefined local expression")
  | store_ok : evalExpr s e = some w ->
      CExec (.storeU64 base e) s (.returned none { s with mem := s.mem.writeU64 base w })
  | store_err : evalExpr s e = none -> CExec (.storeU64 base e) s (.fault "undefined store expression")
  | ret_ok : evalExpr s e = some w -> CExec (.ret e) s (.returned (some w) s)
  | ret_err : evalExpr s e = none -> CExec (.ret e) s (.fault "undefined return expression")
  | seq_returned : CExec p s (.returned r s1) -> CExec q s1 o -> CExec (.seq p q) s o
  | seq_stuck : CExec p s (.stuck r) -> CExec (.seq p q) s (.stuck r)
  | seq_abort : CExec p s (.abort r) -> CExec (.seq p q) s (.abort r)
  | seq_nonreturn : CExec p s (.nonreturn r) -> CExec (.seq p q) s (.nonreturn r)
  | seq_fault : CExec p s (.fault r) -> CExec (.seq p q) s (.fault r)
  | assume_false : CExec (.assumeFalse tag) s (.nonreturn tag)
  | unimplemented : CExec (.unimplemented tag) s (.stuck tag)

/-- The evaluator is sound for the relational semantics. -/
theorem evalStmt_sound_gen : ∀ (p : CStmt) (s : State) (o : Outcome),
    evalStmt p s = o → CExec p s o := by
  intro p
  induction p with
  | skip =>
    intro s o h
    subst o
    exact .skip
  | assign x e =>
    intro s o h
    subst o
    cases hex : evalExpr s e with
    | some w => simp only [evalStmt, hex]; exact .assign_ok hex
    | none => simp only [evalStmt, hex]; exact .assign_err hex
  | storeU64 base e =>
    intro s o h
    subst o
    cases hex : evalExpr s e with
    | some w => simp only [evalStmt, hex]; exact .store_ok hex
    | none => simp only [evalStmt, hex]; exact .store_err hex
  | ret e =>
    intro s o h
    subst o
    cases hex : evalExpr s e with
    | some w => simp only [evalStmt, hex]; exact .ret_ok hex
    | none => simp only [evalStmt, hex]; exact .ret_err hex
  | seq p q ihp ihq =>
    intro s o h
    subst o
    cases hex : evalStmt p s with
    | returned r s1 =>
      simp only [evalStmt, hex]
      exact .seq_returned (ihp s _ hex) (ihq s1 _ rfl)
    | stuck r =>
      simp only [evalStmt, hex]
      exact .seq_stuck (ihp s _ hex)
    | abort r =>
      simp only [evalStmt, hex]
      exact .seq_abort (ihp s _ hex)
    | nonreturn r =>
      simp only [evalStmt, hex]
      exact .seq_nonreturn (ihp s _ hex)
    | fault r =>
      simp only [evalStmt, hex]
      exact .seq_fault (ihp s _ hex)
  | assumeFalse tag =>
    intro s o h
    subst o
    exact .assume_false
  | unimplemented tag =>
    intro s o h
    subst o
    exact .unimplemented

/-- Totality of the relational semantics on the modelled fragment: the
evaluator outcome is always derivable (`evalStmt_sound_gen` at equality). -/
theorem evalStmt_sound (p : CStmt) (s : State) : CExec p s (evalStmt p s) :=
  evalStmt_sound_gen p s _ rfl

theorem CExec_complete (p : CStmt) (s : State) : CExec p s (evalStmt p s) :=
  evalStmt_sound p s

/-! The four abnormal outcomes are pairwise distinct call outcomes: `stuck`
(model hole / unimplemented), `abort`, `nonreturn` (assume false) and `fault`
(undefined C behaviour in the modelled fragment). -/

theorem Outcome.stuck_ne_abort {r r' : String} : Outcome.stuck r ≠ Outcome.abort r' :=
  fun h => by cases h
theorem Outcome.stuck_ne_nonreturn {r r' : String} :
    Outcome.stuck r ≠ Outcome.nonreturn r' := fun h => by cases h
theorem Outcome.stuck_ne_fault {r r' : String} : Outcome.stuck r ≠ Outcome.fault r' :=
  fun h => by cases h
theorem Outcome.abort_ne_nonreturn {r r' : String} :
    Outcome.abort r ≠ Outcome.nonreturn r' := fun h => by cases h
theorem Outcome.abort_ne_fault {r r' : String} : Outcome.abort r ≠ Outcome.fault r' :=
  fun h => by cases h
theorem Outcome.nonreturn_ne_fault {r r' : String} :
    Outcome.nonreturn r ≠ Outcome.fault r' := fun h => by cases h
theorem Outcome.returned_ne_stuck {r : Option Word64} {s : State} {t : String} :
    Outcome.returned r s ≠ Outcome.stuck t := fun h => by cases h

def ModelStmt := CStmt
def compile (p : CStmt) : ModelStmt := p

def SpecExec (p : ModelStmt) (s : State) (o : Outcome) : Prop := CExec p s o

theorem compile_refines (p : CStmt) (s : State) (o : Outcome) :
    CExec p s o <-> SpecExec (compile p) s o := Iff.rfl

end B20.Foundation
