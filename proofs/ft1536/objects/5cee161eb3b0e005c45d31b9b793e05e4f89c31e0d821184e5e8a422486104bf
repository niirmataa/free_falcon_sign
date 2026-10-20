import Source3.KeygenRngProgram
import Source3.KeygenSamplerContext

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Full, finite operational readiness derivations. Every private source
   callee has its fixed body; only system read observations are external.
   No flag truth, desired heap frame or successful seed is an input. -/
namespace FT1536.Source3.KeygenRngReference
open C99MemoryReference
open C99ArrayReference (State Name bindPointer)
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenReadyFast (Flag field)
open KeygenRngProgram

def memberEnv (s : State) (w : BitVec 32) : C99ScalarReference.Env :=
  C99ScalarReference.set s.locals "$member".toList (.int32,some (.int32 w))
def memberExpr (negated : Bool) : C99ScalarReference.Expr :=
  if negated then .logicalNot (.variable "$member".toList) else .variable "$member".toList
inductive FlagTest (ctx : Context) (s : State) (f : Flag) (negated : Bool) : Value → Prop where
  | load (word : BitVec 32) (v : Value) (read : KeygenReadyFast.Read ctx s f word)
      (evaluated : C99ScalarReference.Eval (fun _ _ _ => False) (memberEnv s word) (memberExpr negated) v) :
      FlagTest ctx s f negated v
def params : List C99ArrayReference.Param := [.pointer "fk".toList,.pointer "seed".toList,
  .scalar .uint64 "len".toList,.scalar .int32 "replace".toList]
def arguments (data : Name) (length replace : CLogic.Expr) : List C99ArrayReference.Arg := [
  .pointer "fk".toList (num 0),.pointer data (num 0),.scalar length,.scalar replace]
def readyParams : List C99ArrayReference.Param := [.pointer "fk".toList]
def readyArguments : List C99ArrayReference.Arg := [.pointer "fk".toList (num 0)]
def entered (s : State) (block : Nat) : State := bindPointer
  {s with heap := KeygenMakeObjects.allocated s.heap block 32} "tmp".toList ⟨block,0,32,1,0⟩
def closed (before : State) (result : Result) (block : Nat) : Result :=
  ⟨{result.state with
      heap := KeygenRngSource.disposed before.heap result.state.heap block
      arrays := fun name => if name="tmp".toList then before.arrays name else result.state.arrays name},result.flow⟩
def returned (s : State) (value : Option Nat) : Result :=
  ⟨s,.returned (value.map (fun n => C99IntegerReference.convert .int32 n))⟩
inductive Exec (ctx : Context) : Stmt → State → List KeygenEntropySource.Event → Result → Prop where
  | skip (s : State) : Exec ctx .skip s [] ⟨s,.normal⟩
  | init (before after : State) (capacity : CLogic.Expr) (v : Value)
      (resolved : KeygenSamplerContext.Resolve ctx before) (value : C99ArrayReference.scalar before capacity v)
      (source : ShakeSeedReference.Init (KeygenSamplerContext.rng ctx) before v after) :
      Exec ctx (.init capacity) before [] ⟨after,.normal⟩
  | inject (before after : State) (name : Name) (length : CLogic.Expr) (p : ArrayPointer) (v : Value)
      (resolved : KeygenSamplerContext.Resolve ctx before)
      (data : C99ArrayReference.Pointer before name (num 0) p) (len : C99ArrayReference.scalar before length v)
      (source : ShakeSeedReference.Inject (KeygenSamplerContext.rng ctx) before p v after) :
      Exec ctx (.inject name length) before [] ⟨after,.normal⟩
  | extractTmp (before after : State) (p : ArrayPointer) (resolved : KeygenSamplerContext.Resolve ctx before)
      (data : C99ArrayReference.Pointer before "tmp".toList (num 0) p)
      (source : ShakeExtractFrame.Call (KeygenSamplerContext.rng ctx) before p (.uint64 32) after) :
      Exec ctx .extractTmp before [] ⟨after,.normal⟩
  | flip (before after : State) (resolved : KeygenSamplerContext.Resolve ctx before)
      (source : ShakeSeedReference.Flip (KeygenSamplerContext.rng ctx) before after) : Exec ctx .flip before [] ⟨after,.normal⟩
  | setSeed (before entry : State) (name : Name) (length replace : CLogic.Expr)
      (events : List KeygenEntropySource.Event) (out : Result)
      (binding : C99ArrayReference.Bind before params (arguments name length replace) entry)
      (body : Exec ctx setSeedCode entry events out)
      (conversion : C99ProcedureReference.ReturnValue none out.flow none) :
      Exec ctx (.setSeed name length replace) before events ⟨{before with heap := out.state.heap},.normal⟩
  | storeFlag (before : State) (flag : Flag) (value : CLogic.Expr) (v : Value) (heap : Memory)
      (binding : KeygenSearchContext.Bound before ctx) (evaluated : C99ArrayReference.scalar before value v)
      (write : Store32 before.heap (field ctx flag) (BitVec.ofInt 32 v.integer) heap) :
      Exec ctx (.storeFlag flag value) before [] ⟨{before with heap := heap},.normal⟩
  | branchScalarTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State)
      (events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (source : Exec ctx yes before events out) : Exec ctx (.branchScalar condition yes no) before events out
  | branchScalarFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State)
      (events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0)
      (source : Exec ctx no before events out) : Exec ctx (.branchScalar condition yes no) before events out
  | branchFlagTrue (f : Flag) (negated : Bool) (yes no : Stmt) (before : State)
      (events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (guard : FlagTest ctx before f negated v) (nonzero : v.integer≠0)
      (source : Exec ctx yes before events out) : Exec ctx (.branchFlag f negated yes no) before events out
  | branchFlagFalse (f : Flag) (negated : Bool) (yes no : Stmt) (before : State)
      (events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (guard : FlagTest ctx before f negated v) (zero : v.integer=0)
      (source : Exec ctx no before events out) : Exec ctx (.branchFlag f negated yes no) before events out
  | branchEntropyTrue (yes no : Stmt) (before seeded : State) (p : ArrayPointer) (word : BitVec 32)
      (entropy events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (data : C99ArrayReference.Pointer before "tmp".toList (num 0) p)
      (call : KeygenEntropySource.Call before p (.uint64 32) entropy seeded (.int32 word))
      (guard : KeygenReadyFast.NotTest seeded word v) (nonzero : v.integer≠0)
      (source : Exec ctx yes seeded events out) : Exec ctx (.branchEntropy yes no) before (entropy++events) out
  | branchEntropyFalse (yes no : Stmt) (before seeded : State) (p : ArrayPointer) (word : BitVec 32)
      (entropy events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (data : C99ArrayReference.Pointer before "tmp".toList (num 0) p)
      (call : KeygenEntropySource.Call before p (.uint64 32) entropy seeded (.int32 word))
      (guard : KeygenReadyFast.NotTest seeded word v) (zero : v.integer=0)
      (source : Exec ctx no seeded events out) : Exec ctx (.branchEntropy yes no) before (entropy++events) out
  | ret (s : State) (value : Option Nat) : Exec ctx (.ret value) s [] (returned s value)
  | seqNormal (a b : Stmt) (before middle : State) (events1 events2 : List KeygenEntropySource.Event) (out : Result)
      (first : Exec ctx a before events1 ⟨middle,.normal⟩) (second : Exec ctx b middle events2 out) :
      Exec ctx (.seq a b) before (events1++events2) out
  | seqExit (a b : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
      (first : Exec ctx a before events out) (exit : out.flow≠.normal) : Exec ctx (.seq a b) before events out
  | scope (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
      (source : Exec ctx code before events out) : Exec ctx (.scope code) before events out
  | auto32 (code : Stmt) (before : State) (block : Nat) (events : List KeygenEntropySource.Event) (out : Result)
      (fresh : KeygenRngSource.Fresh before.heap block) (source : Exec ctx code (entered before block) events out) :
      Exec ctx (.auto32 code) before events (closed before out block)
inductive Call (ctx : Context) (before : State) : List KeygenEntropySource.Event → State → Value → Prop where
  | run (entry : State) (events : List KeygenEntropySource.Event) (out : Result) (v : Value)
      (binding : C99ArrayReference.Bind before readyParams readyArguments entry)
      (body : Exec ctx readyCode entry events out)
      (conversion : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
      Call ctx before events {before with heap := out.state.heap} v

theorem slots (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx code before events out) :
    out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧
    out.state.globals=before.globals ∧ out.state.tables=before.tables := by
  induction source with
  | skip | storeFlag | ret | setSeed => exact ⟨rfl,rfl,rfl,rfl⟩
  | init _ _ _ _ _ _ source => exact ShakeSeedReference.init_slots _ _ _ _ source
  | inject _ _ _ _ _ _ _ _ _ source => exact ShakeSeedReference.inject_slots _ _ _ _ _ source
  | extractTmp before after p resolved data source => cases source; exact ⟨rfl,rfl,rfl,rfl⟩
  | flip before after resolved source => exact ShakeSeedReference.flip_slots _ _ _ source
  | branchScalarTrue _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchScalarFalse _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchFlagTrue _ _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchFlagFalse _ _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | seqExit _ _ _ _ _ _ _ ih => exact ih
  | scope _ _ _ _ _ ih => exact ih
  | branchEntropyTrue _ _ before seeded p word entropy events out v data call guard nonzero source ih =>
    have keep := KeygenEntropySource.call_slots _ _ _ _ _ _ call
    exact ⟨ih.1.trans keep.1,ih.2.1.trans keep.2.1,ih.2.2.1.trans keep.2.2.1,ih.2.2.2.trans keep.2.2.2⟩
  | branchEntropyFalse _ _ before seeded p word entropy events out v data call guard zero source ih =>
    have keep := KeygenEntropySource.call_slots _ _ _ _ _ _ call
    exact ⟨ih.1.trans keep.1,ih.2.1.trans keep.2.1,ih.2.2.1.trans keep.2.2.1,ih.2.2.2.trans keep.2.2.2⟩
  | seqNormal _ _ _ _ _ _ _ _ _ ih1 ih2 => exact ⟨ih2.1.trans ih1.1,ih2.2.1.trans ih1.2.1,
      ih2.2.2.1.trans ih1.2.2.1,ih2.2.2.2.trans ih1.2.2.2⟩
  | auto32 code before block events out fresh source ih =>
    refine ⟨ih.1,?_,ih.2.2.1,ih.2.2.2⟩
    funext name
    by_cases equal : name="tmp".toList
    · simp only [closed,equal,ite_true]
    · simpa only [closed,equal,ite_false,entered,bindPointer] using congrFun ih.2.1 name
theorem call_slots (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (source : Call ctx before events after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.globals=before.globals ∧ after.tables=before.tables := by
  cases source; exact ⟨rfl,rfl,rfl,rfl⟩

end FT1536.Source3.KeygenRngReference
