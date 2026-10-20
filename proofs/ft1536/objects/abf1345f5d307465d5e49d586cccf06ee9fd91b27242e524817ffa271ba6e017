import Source3.KeygenReadyFast
import Source3.KeygenCapExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Contiguous7805--7838 prefix on the already-ready RNG path. The declaration
   snapshots are chronological, including scalar/pointer declarations BETWEEN
   h and ske. An allocation-only projection is proved, never assumed. This
   path does not claim coverage of rng_ready's other source branches. -/
namespace FT1536.Source3.KeygenMakePrologue
open C99ArrayReference (State Name bindValue bindPointer)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenMakeObjects (enter)

def middle (s : State) : State :=
  {C99DeclarationStatements.effect .u64 ["klen".toList,"skoff".toList] s with
    arrays := fun n => if n="skbuf".toList then none else s.arrays n}
def tailDeclared (s : State) : State := C99DeclarationStatements.effect .u64 ["local_attempts".toList]
  (C99DeclarationStatements.effect .i32 ["i".toList] s)
def a0 (s : State) : State := KeygenCallerInit.scalarDeclared s
def a1 (s : State) (blocks : Fin 6 → Nat) : State := enter (a0 s) blocks 0
def a2 (s : State) (blocks : Fin 6 → Nat) : State := enter (a1 s blocks) blocks 1
def a3 (s : State) (blocks : Fin 6 → Nat) : State := enter (a2 s blocks) blocks 2
def a4 (s : State) (blocks : Fin 6 → Nat) : State := enter (a3 s blocks) blocks 3
def a5 (s : State) (blocks : Fin 6 → Nat) : State := enter (a4 s blocks) blocks 4
def a6 (s : State) (blocks : Fin 6 → Nat) : State := enter (middle (a5 s blocks)) blocks 5
def declared (s : State) (blocks : Fin 6 → Nat) : State := tailDeclared (a6 s blocks)
def projectionStart (s : State) : State := tailDeclared (middle (a0 s))
def b1 (s : State) (blocks : Fin 6 → Nat) : State := enter (projectionStart s) blocks 0
def b2 (s : State) (blocks : Fin 6 → Nat) : State := enter (b1 s blocks) blocks 1
def b3 (s : State) (blocks : Fin 6 → Nat) : State := enter (b2 s blocks) blocks 2
def b4 (s : State) (blocks : Fin 6 → Nat) : State := enter (b3 s blocks) blocks 3
def b5 (s : State) (blocks : Fin 6 → Nat) : State := enter (b4 s blocks) blocks 4
def b6 (s : State) (blocks : Fin 6 → Nat) : State := enter (b5 s blocks) blocks 5

theorem prefix_tokens_source :
    (KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7804).take 34)).bind
      (fun lines => C99ProcedureParser.tokens (lines.flatMap String.toList)) =
    C99ProcedureParser.tokens ("unsigned logn, ter; size_t n, u; " ++
      "int16_t f[3072], g[3072], F[3072], G[3072]; uint16_t h[3072]; " ++
      "size_t klen, skoff; unsigned char *skbuf; int16_t *ske[4]; " ++
      "int i; uint64_t local_attempts; local_attempts = 0; " ++
      "logn = fk->logn; ter = fk->ternary; n = MKN(logn, ter); " ++
      "if (!rng_ready(fk)) { return 0; }").toList := by decide
theorem middle_enter (s : State) (blocks : Fin 6 → Nat) (slot : Fin 6) :
    middle (enter s blocks slot)=enter (middle s) blocks slot := by
  have different : KeygenMakeObjects.name slot≠"skbuf".toList := by fin_cases slot <;> decide
  have arrays : (middle (enter s blocks slot)).arrays=(enter (middle s) blocks slot).arrays := by
    funext n
    change (if n="skbuf".toList then none else
      if n=KeygenMakeObjects.name slot then some (KeygenMakeObjects.pointer blocks slot) else s.arrays n) =
      (if n=KeygenMakeObjects.name slot then some (KeygenMakeObjects.pointer blocks slot) else
      if n="skbuf".toList then none else s.arrays n)
    by_cases h : n="skbuf".toList
    · subst n; simp only [ite_eq_right (Ne.symm different)]
    · simp only [ite_eq_right h]
  calc
    middle (enter s blocks slot) =
      {enter (middle s) blocks slot with arrays := (middle (enter s blocks slot)).arrays} := rfl
    _ = enter (middle s) blocks slot := by rw [arrays]
theorem tail_enter (s : State) (blocks : Fin 6 → Nat) (slot : Fin 6) :
    tailDeclared (enter s blocks slot)=enter (tailDeclared s) blocks slot := rfl
theorem projection_equal (s : State) (blocks : Fin 6 → Nat) : declared s blocks=b6 s blocks := by
  simp only [declared,a6,a5,a4,a3,a2,a1,middle_enter,tail_enter,
    b6,b5,b4,b3,b2,b1,projectionStart]

inductive Declarations (before : State) (blocks : Fin 6 → Nat) : State → Prop where
  | run
      (f : KeygenRngSource.Fresh (a0 before).heap (blocks 0))
      (g : KeygenRngSource.Fresh (a1 before blocks).heap (blocks 1))
      (bigF : KeygenRngSource.Fresh (a2 before blocks).heap (blocks 2))
      (bigG : KeygenRngSource.Fresh (a3 before blocks).heap (blocks 3))
      (h : KeygenRngSource.Fresh (a4 before blocks).heap (blocks 4))
      (ske : KeygenRngSource.Fresh (middle (a5 before blocks)).heap (blocks 5)) :
      Declarations before blocks (declared before blocks)
theorem allocation_projection (before after : State) (blocks : Fin 6 → Nat)
    (source : Declarations before blocks after) : KeygenMakeObjects.Exec 0 (projectionStart before) blocks after := by
  cases source with
  | run f g bigF bigG h ske =>
    rw [projection_equal]
    have eq1 : (b1 before blocks).heap=(a1 before blocks).heap := rfl
    have eq2 : (b2 before blocks).heap=(a2 before blocks).heap := by
      change KeygenMakeObjects.allocated (b1 before blocks).heap _ _=KeygenMakeObjects.allocated (a1 before blocks).heap _ _
      rw [eq1]
    have eq3 : (b3 before blocks).heap=(a3 before blocks).heap := by
      change KeygenMakeObjects.allocated (b2 before blocks).heap _ _=KeygenMakeObjects.allocated (a2 before blocks).heap _ _
      rw [eq2]
    have eq4 : (b4 before blocks).heap=(a4 before blocks).heap := by
      change KeygenMakeObjects.allocated (b3 before blocks).heap _ _=KeygenMakeObjects.allocated (a3 before blocks).heap _ _
      rw [eq3]
    have eq5 : (b5 before blocks).heap=(middle (a5 before blocks)).heap := by
      change KeygenMakeObjects.allocated (b4 before blocks).heap _ _=KeygenMakeObjects.allocated (a4 before blocks).heap _ _
      rw [eq4]
    have last : KeygenMakeObjects.Exec 5 (b5 before blocks) blocks (b6 before blocks) :=
      .next 5 (by decide) _ _ blocks (eq5.symm ▸ ske) (.done _ blocks)
    have fourth : KeygenMakeObjects.Exec 4 (b4 before blocks) blocks (b6 before blocks) :=
      .next 4 (by decide) _ _ blocks (eq4.symm ▸ h) last
    have third : KeygenMakeObjects.Exec 3 (b3 before blocks) blocks (b6 before blocks) :=
      .next 3 (by decide) _ _ blocks (eq3.symm ▸ bigG) fourth
    have second : KeygenMakeObjects.Exec 2 (b2 before blocks) blocks (b6 before blocks) :=
      .next 2 (by decide) _ _ blocks (eq2.symm ▸ bigF) third
    have first : KeygenMakeObjects.Exec 1 (b1 before blocks) blocks (b6 before blocks) :=
      .next 1 (by decide) _ _ blocks (eq1.symm ▸ g) second
    exact .next 0 (by decide) _ _ blocks f first
theorem projection_original (ctx : Context) (before : State) (primes rev : ArrayPointer)
    (source : KeygenMakeEntry.Original ctx before primes rev) :
    KeygenMakeEntry.Original ctx (projectionStart before) primes rev := by
  refine ⟨?_,source.objectLegal,source.profile,source.table,source.primeObject,source.revBinding,
    source.revSource,source.scratch,source.contextScratch,source.contextTables,source.staticLive⟩
  change (if "fk".toList="skbuf".toList then none else before.arrays "fk".toList)=some ctx.object
  rw [ite_eq_right (by decide)]
  exact source.context
theorem initial (ctx : Context) (before after : State) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (blocks : Fin 6 → Nat)
    (source : Declarations before blocks after) :
    KeygenCallerEntry.Initial ctx after (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev :=
  KeygenMakeEntry.initial ctx (projectionStart before) after primes rev
    (projection_original ctx before primes rev original) blocks (allocation_projection before after blocks source)

def countCode : C99ProcedureReference.Stmt := .base (.assign "local_attempts".toList (.scalar (.literal .i32 0)))
def counted (s : State) : State := bindValue s "local_attempts".toList .uint64 (.int32 0)
theorem count_declared (s : State) (blocks : Fin 6 → Nat) :
    (declared s blocks).locals "local_attempts".toList=some (.uint64,none) := by
  simp [declared,tailDeclared,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,
    C99ValueBridge.type,C99ScalarReference.set]
theorem count_result (s : State) (blocks : Fin 6 → Nat) (out : C99ProcedureReference.Result)
    (source : C99ProcedureReference.Exec (fun _ => none) countCode (declared s blocks) out) :
    out=⟨counted (declared s blocks),.normal⟩ := by
  cases source with
  | base code before after body =>
    cases body with
    | assign before n e ty old v binding value =>
      have type : ty=.uint64 := congrArg Prod.fst (Option.some.inj (binding.symm.trans (count_declared s blocks)))
      subst ty
      cases value with
      | scalar e v evaluated => cases evaluated; rfl
def logged (s : State) (w : BitVec 32) : State := bindValue s "logn".toList .uint32 (.uint32 w)
def ternary (s : State) (logn ter : BitVec 32) : State := bindValue (logged s logn) "ter".toList .uint32 (.uint32 ter)
def sized (s : State) : State := bindValue (ternary s 10 1) "n".toList .uint64 (.uint64 1536)
inductive Dimensions (ctx : Context) (before : State) : State → Prop where
  | run (logn ter : BitVec 32) (n : C99IntegerReference.Value)
      (first : KeygenSearchContext.ReadLogn ctx before logn)
      (second : KeygenSearchContext.ReadTernary ctx (logged before logn) ter)
      (size : C99ArrayReference.scalar (ternary before logn ter) KeygenCallerInit.sizeExpr n) :
      Dimensions ctx before (bindValue (ternary before logn ter) "n".toList .uint64 n)
theorem dimensions_result (ctx : Context) (before after : State)
    (profile : KeygenSearchContext.M0 before.heap ctx) (source : Dimensions ctx before after) : after=sized before := by
  cases source with
  | run logn ter n first second size =>
    have hl := KeygenSearchContext.logn_m0 ctx before logn profile first
    subst logn
    have ht := KeygenSearchContext.ternary_m0 ctx (logged before 10) ter profile second
    subst ter
    have hn := KeygenSmallBounds.mkn_value (ternary before 10 1) n ⟨rfl,rfl⟩ size
    simp only [bindValue,sized]
    rw [hn]
    rfl
def ready (s : State) (blocks : Fin 6 → Nat) : State := sized (counted (declared s blocks))
theorem ready_count (s : State) (blocks : Fin 6 → Nat) : KeygenCapWords.Count (ready s blocks) 0 := by
  simp [KeygenCapWords.Count,ready,sized,ternary,logged,counted,bindValue,C99ScalarReference.set]
  rfl
theorem ready_initial (ctx : Context) (s : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (h : KeygenCallerEntry.Initial ctx (declared s blocks) (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev) :
    KeygenCallerEntry.Initial ctx (ready s blocks) (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev := by
  exact ⟨h.context,h.inputs,h.publicPointer,h.profile,h.table,h.primeObject,h.revBinding,h.revSource,
    h.scratch,h.allocated,h.width,h.scratchSeparate,h.distinct,h.contextSeparate,h.contextScratch,
    h.contextTables,h.inputTables,h.publicSeparate,h.publicContext,h.staticLive⟩

inductive AlreadyReadyPrefix (ctx : Context) (before : State) (blocks : Fin 6 → Nat) : State → Prop where
  | run (objects initialized dimensioned after : State) (v : C99IntegerReference.Value)
      (declarations : Declarations before blocks objects)
      (counter : C99ProcedureReference.Exec (fun _ => none) countCode objects ⟨initialized,.normal⟩)
      (dimensions : Dimensions ctx initialized dimensioned)
      (rng : KeygenReadyFast.Call ctx dimensioned after v) (normal : v.integer≠0) :
      AlreadyReadyPrefix ctx before blocks after
theorem prefix_result (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (source : AlreadyReadyPrefix ctx before blocks after) :
    after=ready before blocks ∧ KeygenCapWords.Count after 0 ∧
    KeygenCallerEntry.Initial ctx after (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev := by
  cases source with
  | run objects initialized dimensioned after v declarations counter dimensions rng normal =>
    have objectLegal := initial ctx before objects primes rev original blocks declarations
    have objectsEq : objects=declared before blocks := by cases declarations; rfl
    subst objects
    have initializedEq : initialized=counted (declared before blocks) :=
      congrArg C99ProcedureReference.Result.state (count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have dimensionsEq := dimensions_result ctx (counted (declared before blocks)) dimensioned objectLegal.profile dimensions
    subst dimensioned
    have afterEq := (KeygenReadyFast.call_result ctx _ after v rng).1
    subst after
    exact ⟨rfl,ready_count before blocks,ready_initial ctx before blocks primes rev objectLegal⟩

end FT1536.Source3.KeygenMakePrologue
