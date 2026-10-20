import Source3.KeygenPublicFrame
import Source3.KeygenSamplerFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete fixed public-call graph, including both dispatch arms, dynamic
   M0 twiddle generation and all automatic uint16 arrays. -/
namespace FT1536.Source3.KeygenPublicSource
open C99ArrayReference (State Name Param Arg)
open C99ProcedureReference (Result)
open C99MemoryReference
open KeygenPublicExec (Stmt Function)
open B20.C (Token)

inductive Kind where
  | generate | forwardB | inverseB | forwardT | inverseT | forward | inverse | compute
  deriving DecidableEq, Repr
def all : List Kind := [.generate,.forwardB,.inverseB,.forwardT,.inverseT,.forward,.inverse,.compute]
def name : Kind → Name
  | .generate => "mq_mkgm3".toList
  | .forwardB => "mq_NTT_binary".toList
  | .inverseB => "mq_iNTT_binary".toList
  | .forwardT => "mq_NTT_ternary".toList
  | .inverseT => "mq_iNTT_ternary".toList
  | .forward => "mq_NTT".toList
  | .inverse => "mq_iNTT".toList
  | .compute => "falcon_compute_public".toList
def range : Kind → Nat×Nat×Nat
  | .generate => (823,826,885)
  | .forwardB => (890,893,918)
  | .inverseB => (923,926,974)
  | .forwardT => (979,982,1062)
  | .inverseT => (1067,1070,1159)
  | .forward => (1161,1164,1169)
  | .inverse => (1171,1174,1179)
  | .compute => (1521,1525,1547)
def params : Kind → List Param
  | .generate => [.pointer "gm".toList,.pointer "igm".toList,.scalar .uint32 "logn".toList]
  | .forward | .inverse => [.pointer "a".toList,.scalar .uint32 "logn".toList,.scalar .int32 "ternary".toList]
  | .compute => [.pointer "h".toList,.pointer "f".toList,.pointer "g".toList,
      .scalar .uint32 "logn".toList,.scalar .int32 "ternary".toList]
  | _ => [.pointer "a".toList,.scalar .uint32 "logn".toList]
def signed : Kind → List Name | .compute => ["f".toList,"g".toList] | _ => []
def result : Kind → Option C99IntegerReference.Ty | .compute => some .int32 | _ => none
structure Header where
  name : Name
  params : List Param
  signed : List Name
  result : Option C99IntegerReference.Ty
  deriving DecidableEq, Repr
def parameter : List Token → Option (Param×Bool×List Token)
  | ['c','o','n','s','t']::ty::['*']::name::rest =>
    if ty="int16_t".toList then pure (.pointer name,true,rest)
    else if ty="uint16_t".toList then pure (.pointer name,false,rest) else none
  | ['u','i','n','t','1','6','_','t']::['*']::['r','e','s','t','r','i','c','t']::name::rest
  | ['u','i','n','t','1','6','_','t']::['*']::name::rest => pure (.pointer name,false,rest)
  | ty::name::rest => do
    let t ← KeygenWordExpr.typeToken ty
    pure (.scalar (C99ValueBridge.type t) name,false,rest)
  | _ => none
def parameters : Nat → List Token → Option (List Param×List Name×List Token)
  | 0,_ => none
  | fuel+1,ts => do
    let (p,sgn,rest) ← parameter ts
    let signed := match p with | .pointer n => if sgn then [n] else [] | _ => []
    match rest with
    | [')']::rest => pure ([p],signed,rest)
    | [',']::rest => do
      let (tail,others,rest) ← parameters fuel rest
      pure (p::tail,signed++others,rest)
    | _ => none
def header (kind : Kind) : Option Header := do
  let ts ← KeygenZintTop.tokens ((KeygenPublicScalar.lines (range kind).1 ((range kind).2.1-(range kind).1)).flatMap String.toList)
  let ts := if ts.head?=some "static".toList then ts.drop 1 else ts
  match ts with
  | ret::name::['(']::rest => do
    let result ← if ret="void".toList then some none else
      (KeygenWordExpr.typeToken ret).map (fun ty => some (C99ValueBridge.type ty))
    let (ps,sgn,rest) ← parameters 16 rest
    if rest=[['{']] then pure ⟨name,ps,sgn,result⟩ else none
  | _ => none
def find (n : Name) : Option Kind := all.find? (fun k => name k==n)
def signatures (n : Name) : Option (List Param) := (find n).map params
def types (kind : Kind) : KeygenPublicParser.Types :=
  ((params kind).filterMap (fun p => match p with | .pointer n => some (n,2) | _ => none))++
  (["GMb","iGMb","GMt_square","GMt_cubic","iGMt_square","iGMt_cubic","INVNQt"].map (fun n => (n.toList,2)))
def parsed (kind : Kind) : Option Stmt := do
  let ts ← KeygenZintTop.tokens ((KeygenPublicScalar.lines (range kind).2.1 ((range kind).2.2-(range kind).2.1)).flatMap String.toList++['}'])
  let (code,_,rest) ← KeygenPublicParser.body signatures (types kind) 512 (KeygenPublicScalar.expand ts)
  if rest.isEmpty then pure code else none
def code (kind : Kind) : Stmt := (parsed kind).getD .skip
def function (kind : Kind) : Function := ⟨params kind,signed kind,result kind,code kind⟩
def program (n : Name) : Option Function := (find n).map function
def writable : Kind → List Name
  | .generate => ["gm".toList,"igm".toList]
  | .compute => ["h".toList]
  | _ => ["a".toList]
def permissions (n : Name) : List Name := ((find n).map writable).getD []
def audit (kind : Kind) : Bool := decide (header kind=some ⟨name kind,params kind,signed kind,result kind⟩) &&
  decide ((parsed kind).map (KeygenPublicFrame.only signatures permissions (writable kind))=some true) &&
  decide (KeygenAttemptPin.vrfyLines[(range kind).2.2-1]?=some "}\n")
theorem generate_audit : audit .generate=true := by decide
theorem forwardB_audit : audit .forwardB=true := by decide
theorem inverseB_audit : audit .inverseB=true := by decide
theorem forwardT_audit : audit .forwardT=true := by decide
theorem inverseT_audit : audit .inverseT=true := by decide
theorem forward_audit : audit .forward=true := by decide
theorem inverse_audit : audit .inverse=true := by decide
theorem public_audit : audit .compute=true := by decide
theorem all_audit (kind : Kind) : audit kind=true := by
  cases kind
  · exact generate_audit
  · exact forwardB_audit
  · exact inverseB_audit
  · exact forwardT_audit
  · exact inverseT_audit
  · exact forward_audit
  · exact inverse_audit
  · exact public_audit
theorem code_checked (kind : Kind) : parsed kind=some (code kind) ∧
    KeygenPublicFrame.only signatures permissions (writable kind) (code kind)=true := by
  have h := (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp (all_audit kind)).1).2
  have h' : (parsed kind).map (KeygenPublicFrame.only signatures permissions (writable kind))=some true := of_decide_eq_true h
  cases hp : parsed kind with
  | none => simp only [hp,Option.map_none] at h'; cases h'
  | some p =>
    have hc : code kind=p := by simp only [code,hp,Option.getD_some]
    exact ⟨by rw [hc],by rw [hc]; exact Option.some.inj (by simpa only [hp,Option.map_some] using h')⟩
theorem aligned : ∀ n f, program n=some f → signatures n=some f.params := by
  intro n f h
  unfold program at h
  cases hi : find n with
  | none => simp [hi] at h
  | some kind =>
    have he : function kind=f := Option.some.inj (by simpa only [hi,Option.map_some] using h)
    subst f
    simp only [signatures,hi,Option.map_some,function]
theorem closed : ∀ n f, program n=some f → KeygenPublicFrame.only signatures permissions (permissions n) f.body=true := by
  intro n f h
  unfold program at h
  cases hi : find n with
  | none => simp [hi] at h
  | some kind =>
    have he : function kind=f := Option.some.inj (by simpa only [hi,Option.map_some] using h)
    subst f
    simpa only [permissions,hi,Option.map_some,Option.getD_some,function] using (code_checked kind).2
def arguments : List Arg := [.pointer "h".toList C99ProcedureParser.zero,.pointer "f".toList C99ProcedureParser.zero,
  .pointer "g".toList C99ProcedureParser.zero,.scalar (.var "logn".toList),.scalar (.var "ter".toList)]
inductive Call (before : State) : State → C99IntegerReference.Value → Prop where
  | run (entry : State) (out : Result) (v : C99IntegerReference.Value)
      (binding : KeygenPublicWord.Bind before (params .compute) arguments entry)
      (source : KeygenPublicExec.Exec program (signed .compute) (code .compute) entry out)
      (returned : C99ProcedureReference.ReturnValue (result .compute) out.flow (some v)) :
      Call before {before with heap := out.state.heap} v
theorem caller_checked : C99PointerFootprint.arguments ["h".toList] (writable .compute) (params .compute) arguments=true := by decide
theorem frame (before after : State) (v : C99IntegerReference.Value) (source : Call before after v)
    (block : Nat) (outside : KeygenPublicFrame.Outside before ["h".toList] block)
    (tables : KeygenPublicFrame.Tables before block) (live : 0<before.heap.size block) :
    ShakeExtractFrame.SameBlock before.heap after.heap block := by
  cases source with
  | run entry out v binding source returned =>
    have oe := KeygenPublicFrame.bind before (params .compute) arguments entry binding ["h".toList]
      (writable .compute) caller_checked block outside tables
    have ht := KeygenPublicFrame.bind_tables _ _ _ _ binding
    have hh := KeygenPublicWord.bind_heap _ _ _ _ binding
    have keep := (KeygenPublicFrame.body program signatures permissions aligned closed (signed .compute) (code .compute)
      entry out source (writable .compute) (code_checked .compute).2 block oe
      (by simpa only [KeygenPublicFrame.Tables,ht] using tables) (by rw [hh]; exact live)).2.2
    rw [hh] at keep
    exact keep
theorem material (before after : State) (v : C99IntegerReference.Value) (source : Call before after v)
    (p : ArrayPointer) (outside : KeygenPublicFrame.Outside before ["h".toList] p.block)
    (tables : KeygenPublicFrame.Tables before p.block) (live : 0<before.heap.size p.block)
    (vector : Geometry.Vec) (represented : KeygenMaterial.Represents before.heap p vector) :
    KeygenMaterial.Represents after.heap p vector :=
  KeygenSamplerFrame.represents before.heap after.heap p vector (frame before after v source p.block outside tables live) represented

end FT1536.Source3.KeygenPublicSource
