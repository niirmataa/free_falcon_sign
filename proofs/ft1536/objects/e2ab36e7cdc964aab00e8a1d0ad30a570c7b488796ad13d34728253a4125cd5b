import Source3.KeygenWordParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete bigint leaf bodies needed by deepest/CRT/Bezout. Their calls
   retain actual return values, limb loads/stores and unsigned post-decrement
   wrap on the last failed test. These are operational/frame results, not
   a theorem that the bigint arithmetic computes a Bezout solution. -/
namespace FT1536.Source3.KeygenZintLeaves
open C99ArrayReference (State Name Param Arg)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenWordExec

inductive Kind where
  | add | sub | mul | addMul | shift | reduce | compare
  deriving DecidableEq, Repr
def range : Kind → Nat×Nat×Nat
  | .add => (3323,3326,3338)
  | .sub => (3345,3348,3360)
  | .mul => (3366,3369,3381)
  | .addMul => (3440,3444,3459)
  | .shift => (3465,3468,3481)
  | .reduce => (3392,3396,3416)
  | .compare => (3516,3519,3532)
def name : Kind → Name
  | .add => "zint_add".toList
  | .sub => "zint_sub".toList
  | .mul => "zint_mul_small".toList
  | .addMul => "zint_add_mul_small".toList
  | .shift => "zint_rshift1".toList
  | .reduce => "zint_mod_small_unsigned".toList
  | .compare => "zint_ucmp".toList
def params : Kind → List Param
  | .add | .sub | .compare => [.pointer "a".toList,.pointer "b".toList,.scalar .uint64 "len".toList]
  | .mul => [.pointer "m".toList,.scalar .uint64 "mlen".toList,.scalar .uint32 "x".toList]
  | .addMul => [.pointer "x".toList,.pointer "y".toList,.scalar .uint64 "len".toList,.scalar .uint32 "s".toList]
  | .shift => [.pointer "d".toList,.scalar .uint64 "len".toList]
  | .reduce => [.pointer "d".toList,.scalar .uint64 "dlen".toList,
    .scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList,.scalar .uint32 "R2".toList]
def result : Kind → Option Ty
  | .addMul => none
  | .compare => some .int32
  | _ => some .uint32
def types (kind : Kind) : KeygenWordExpr.Types := (params kind).filterMap fun p =>
  match p with
  | .pointer n => some (n,4)
  | _ => none
def writable : Kind → List Name
  | .add | .sub => ["a".toList]
  | .mul => ["m".toList]
  | .addMul => ["x".toList]
  | .shift => ["d".toList]
  | .reduce | .compare => []
def parsed (kind : Kind) : Option Stmt :=
  KeygenWordParser.region (types kind) (range kind).2.1 ((range kind).2.2-(range kind).2.1)
def code (kind : Kind) : Stmt := (parsed kind).getD skip
def header (kind : Kind) : Option (Name×List Param×Option Ty) := do
  let lines := KeygenLevelNtt.region (range kind).1 ((range kind).2.1-(range kind).1)
  let tokens ← C99ProcedureParser.tokens (lines.flatMap String.toList)
  match tokens with
  | ['s','t','a','t','i','c']::ret::fn::['(']::rest => do
    let r ← if ret="void".toList then some none else
      (KeygenWordExpr.typeToken ret).map (fun t => some (C99ValueBridge.type t))
    let (ps,rest) ← C99ArrayParser.parameters 16 rest
    if rest=[['{']] && ps.all (fun p => p.pointee=none || p.pointee=some .u32) then
      pure (fn,ps.map C99ArrayParser.Parameter.value,r)
    else none
  | _ => none
def sourceAudit (kind : Kind) : Bool :=
  decide (header kind=some (name kind,params kind,result kind)) &&
  decide ((parsed kind).map (only (writable kind))=some true) &&
  decide (Pinned.keygenLines[(range kind).2.2-1]?=some "}\n")
theorem add_source : sourceAudit .add=true := by decide
theorem sub_source : sourceAudit .sub=true := by decide
theorem mul_source : sourceAudit .mul=true := by decide
theorem add_mul_source : sourceAudit .addMul=true := by decide
theorem shift_source : sourceAudit .shift=true := by decide
theorem reduce_source : sourceAudit .reduce=true := by decide
theorem compare_source : sourceAudit .compare=true := by decide
theorem sources (kind : Kind) : sourceAudit kind=true := by
  cases kind
  · exact add_source
  · exact sub_source
  · exact mul_source
  · exact add_mul_source
  · exact shift_source
  · exact reduce_source
  · exact compare_source
theorem header_source (kind : Kind) : header kind=some (name kind,params kind,result kind) :=
  of_decide_eq_true (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp (sources kind)).1).1
theorem parsed_audit (kind : Kind) : (parsed kind).map (only (writable kind))=some true :=
  of_decide_eq_true (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp (sources kind)).1).2
theorem parsed_source (kind : Kind) : parsed kind=some (code kind) := by
  have h := parsed_audit kind
  cases hp : parsed kind with
  | none => simp only [hp,Option.map_none] at h; cases h
  | some p => simp only [code,hp,Option.getD_some]
theorem code_checked (kind : Kind) : only (writable kind) (code kind)=true := by
  have h := parsed_audit kind
  rw [parsed_source] at h
  exact Option.some.inj h
inductive Call (kind : Kind) (before : State) (args : List Arg) : State → Option Value → Prop where
  | run (entry : State) (out : Result) (v : Option Value)
      (binding : C99ArrayReference.Bind before (params kind) args entry)
      (source : Exec (code kind) entry out)
      (returned : C99ProcedureReference.ReturnValue (result kind) out.flow v) :
      Call kind before args {before with heap := out.state.heap} v
theorem frame (kind : Kind) (before after : State) (args : List Arg) (v : Option Value)
    (source : Call kind before args after v) (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names (writable kind) (params kind) args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out v binding execution returned =>
    obtain ⟨ho,_⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding
      names (writable kind) allowed block offset outside tables
    have keep := (body_frame (code kind) entry out execution (writable kind)
      (code_checked kind) block offset ho).2.2
    rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at keep
    exact keep

end FT1536.Source3.KeygenZintLeaves
