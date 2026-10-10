import Source3.KeygenMakeEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The ALREADY seeded-and-flipped source path of rng_ready. This is a
   checked path, not the complete RNG-readiness contract. The other paths
   require source injection/flip/system-seed bindings and remain explicit. -/
namespace FT1536.Source3.KeygenReadyFast
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenSearchContext (Context)

inductive Flag where | seeded | flipped
  deriving DecidableEq, Repr
def offset : Flag → Nat | .seeded => 424 | .flipped => 428
def field (ctx : Context) (flag : Flag) : ArrayPointer := KeygenSearchContext.field ctx (offset flag) 4
inductive Read (ctx : Context) (s : State) (flag : Flag) : BitVec 32 → Prop where
  | load (w : BitVec 32) (bound : KeygenSearchContext.Bound s ctx)
      (legal : KeygenSearchContext.ObjectLegal s.heap ctx) (bytes : Load32 s.heap (field ctx flag) w) : Read ctx s flag w

theorem complete_body_source : (Pinned.keygenLines.drop 5272).take 14 = [
    "\tif (!fk->seeded) {\n", "\t\tunsigned char tmp[32];\n", "\n",
    "\t\tif (!falcon_get_seed(tmp, sizeof tmp)) {\n", "\t\t\treturn 0;\n", "\t\t}\n",
    "\t\tfalcon_keygen_set_seed(fk, tmp, sizeof tmp, 0);\n", "\t\tfk->seeded = 1;\n", "\t}\n",
    "\tif (!fk->flipped) {\n", "\t\tshake_flip(&fk->rng);\n", "\t\tfk->flipped = 1;\n", "\t}\n",
    "\treturn 1;\n"] := by decide
theorem signature_source : (Pinned.keygenLines.drop 5269).take 3 =
    ["static int\n","rng_ready(falcon_keygen *fk)\n","{\n"] := by decide
theorem caller_source : (Pinned.keygenLines.drop 7835).take 3 =
    ["\tif (!rng_ready(fk)) {\n","\t\treturn 0;\n","\t}\n"] := by decide
def returnedOne : C99ProcedureReference.Stmt := .ret (some (.scalar (.literal .i32 1)))
def NotTest (s : State) (w : BitVec 32) (v : Value) : Prop :=
  C99ScalarReference.Eval (fun _ _ _ => False)
    (C99ScalarReference.set s.locals "$member".toList (.int32,some (.int32 w)))
    (.logicalNot (.variable "$member".toList)) v

/- No flag truth or return value is supplied as a postcondition: these are
   the two actual signed member loads, false ! guards and source return. -/
inductive Body (ctx : Context) (before : State) : C99ProcedureReference.Result → Prop where
  | run (seeded flipped : BitVec 32) (a b : Value) (out : C99ProcedureReference.Result)
      (first : Read ctx before .seeded seeded) (firstGuard : NotTest before seeded a) (skipSeed : a.integer=0)
      (second : Read ctx before .flipped flipped) (secondGuard : NotTest before flipped b) (skipFlip : b.integer=0)
      (returned : C99ProcedureReference.Exec (fun _ => none) returnedOne before out) : Body ctx before out
theorem not_test (s : State) (w : BitVec 32) (v : Value) (source : NotTest s w v) :
    v=C99ScalarReference.boolean (decide ((Value.int32 w).integer=0)) := by
  cases source with
  | logicalNot e x value =>
    have exactValue : x=Value.int32 w := by
      cases value with
      | «variable» n ty old binding =>
        have stored : C99ScalarReference.set s.locals "$member".toList (.int32,some (.int32 w))
            "$member".toList=some (.int32,some (.int32 w)) := by simp [C99ScalarReference.set]
        have equal := Option.some.inj (binding.symm.trans stored)
        exact Option.some.inj (congrArg Prod.snd equal)
    subst x
    rfl
theorem skipped_nonzero (s : State) (w : BitVec 32) (v : Value)
    (source : NotTest s w v) (zero : v.integer=0) : (Value.int32 w).integer≠0 := by
  intro equal
  rw [not_test s w v source] at zero
  rw [show decide ((Value.int32 w).integer=0)=true from decide_eq_true equal] at zero
  change (1#32).toInt=0 at zero
  norm_num at zero
theorem result (ctx : Context) (before : State) (out : C99ProcedureReference.Result)
    (source : Body ctx before out) : out=⟨before,.returned (some (.int32 1))⟩ := by
  cases source with
  | run seeded flipped a b out first firstGuard skipSeed second secondGuard skipFlip returned =>
    cases returned with
    | returnValue s e v value => cases value with | scalar e v evaluated => cases evaluated; rfl
theorem flags (ctx : Context) (before : State) (out : C99ProcedureReference.Result)
    (source : Body ctx before out) : ∃ seeded flipped : BitVec 32,
    Load32 before.heap (field ctx .seeded) seeded ∧ Load32 before.heap (field ctx .flipped) flipped ∧
    (Value.int32 seeded).integer≠0 ∧ (Value.int32 flipped).integer≠0 := by
  cases source with
  | run seeded flipped a b out first firstGuard skipSeed second secondGuard skipFlip returned =>
    cases first with
    | load bound legal bytes =>
      cases second with
      | load bound' legal' bytes' =>
        exact ⟨seeded,flipped,bytes,bytes',skipped_nonzero before seeded a firstGuard skipSeed,
          skipped_nonzero before flipped b secondGuard skipFlip⟩
inductive Call (ctx : Context) (before : State) : State → Value → Prop where
  | run (out : C99ProcedureReference.Result) (v : Value)
      (actual : C99ArrayReference.Pointer before "fk".toList C99ProcedureParser.zero ctx.object)
      (body : Body ctx before out)
      (conversion : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
      Call ctx before {before with heap := out.state.heap} v
theorem call_result (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v) :
    after=before ∧ v=.int32 1 := by
  cases source with
  | run out v actual body conversion =>
    rw [result ctx before out body] at conversion
    cases conversion
    exact ⟨by rw [result ctx before out body],rfl⟩

end FT1536.Source3.KeygenReadyFast
