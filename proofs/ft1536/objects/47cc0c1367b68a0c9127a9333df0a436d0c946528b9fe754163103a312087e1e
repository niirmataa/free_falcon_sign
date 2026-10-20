import Source3.KeygenAttemptPin
import Source3.KeygenRootObjects

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Fixed scalar helper closure of falcon_compute_public. These are source
   word executions; modular division correctness is a later obligation. -/
namespace FT1536.Source3.KeygenPublicScalar
open C99ArrayReference (State Name)
open C99IntegerReference (Value Ty)
open C99ModularReference (Stmt Expr CallRelation)

def constants : List (Name×Nat) := [("Qb".toList,12289),("Q0Ib".toList,12287),
  ("Rb".toList,4091),("R2b".toList,10952),("Qt".toList,18433),("Q0It".toList,18431),
  ("Rt".toList,10237),("R2t".toList,4564),("TERNARY_LOGN_MAX".toList,11)]
def expand (tokens : List B20.C.Token) : List B20.C.Token := tokens.map (fun token =>
  match constants.find? (fun p => p.1==token) with | some (_,n) => (toString n).toList | none => token)
theorem constants_source : (KeygenAttemptPin.vrfyLines.drop 53).take 15 = [
  "#define Qb     12289\n","#define Q0Ib   12287\n","#define Rb      4091\n","#define R2b    10952\n","\n",
  "#define Qt     18433\n","#define Q0It   18431\n","#define Rt     10237\n","#define R2t     4564\n","\n",
  "#define MKN(logn, ter)   ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)))\n","\n",
  "#define TERNARY_LOGN_MAX   11\n","#define TERNARY_GM_SIZE    ((size_t)1 << TERNARY_LOGN_MAX)\n",
  "#define TERNARY_N_MAX      MKN(TERNARY_LOGN_MAX, 1)\n"] := by decide
inductive Kind where
  | conv | add | sub | half | mul | square | divB | divT | rev
  deriving DecidableEq, Repr
def all : List Kind := [.conv,.add,.sub,.half,.mul,.square,.divB,.divT,.rev]
def name : Kind → Name
  | .conv => "mq_conv_small".toList
  | .add => "mq_add".toList
  | .sub => "mq_sub".toList
  | .half => "mq_rshift1".toList
  | .mul => "mq_montymul".toList
  | .square => "mq_montysqr".toList
  | .divB => "mq_div_12289".toList
  | .divT => "mq_div_18433".toList
  | .rev => "rev10".toList
def range : Kind → Nat×Nat×Nat
  | .conv => (566,569,577)
  | .add => (582,585,597)
  | .sub => (602,605,614)
  | .half => (619,622,624)
  | .mul => (631,634,662)
  | .square => (667,670,671)
  | .divB => (676,679,737)
  | .divT => (742,745,803)
  | .rev => (805,808,817)
def params : Kind → List (Ty×Name)
  | .conv => [(.int32,"x".toList),(.uint32,"q".toList)]
  | .add | .sub => [(.uint32,"x".toList),(.uint32,"y".toList),(.uint32,"q".toList)]
  | .half => [(.uint32,"x".toList),(.uint32,"q".toList)]
  | .mul => [(.uint32,"x".toList),(.uint32,"y".toList),(.uint32,"q".toList),(.uint32,"q0i".toList)]
  | .square => [(.uint32,"x".toList),(.uint32,"q".toList),(.uint32,"q0i".toList)]
  | .divB | .divT => [(.uint32,"x".toList),(.uint32,"y".toList)]
  | .rev => [(.uint32,"x".toList)]
def lines (start count : Nat) : List String := (KeygenAttemptPin.vrfyLines.drop (start-1)).take count
def header (kind : Kind) : Option C99ProcedureParser.Header := do
  let ts ← C99ProcedureParser.tokens ((lines (range kind).1 ((range kind).2.1-(range kind).1)).flatMap String.toList)
  let ts := ts.filter (fun t => t != "static".toList && t != "inline".toList)
  let (h,rest) ← C99ProcedureParser.header ts
  if rest.isEmpty then pure h else none
def expectedHeader (kind : Kind) : C99ProcedureParser.Header :=
  ⟨name kind,(params kind).map (fun (ty,n) => ⟨.scalar ty n,none,false,false⟩),some .uint32⟩
def parsed (kind : Kind) : Option Stmt := do
  let ts ← C99ProcedureParser.tokens ((lines (range kind).2.1 ((range kind).2.2-(range kind).2.1)).flatMap String.toList++['}'])
  let (code,_,rest) ← C99ModularParser.body [] 256 (expand ts)
  if rest.isEmpty then pure code else none
def code (kind : Kind) : Stmt := (parsed kind).getD (.base .skip)
/- Check every expression call against the fixed stratum; scalar fallback
   is restricted to call-free C expressions and no array/store primitive. -/
def scalarOnly : CLogic.Expr → Bool
  | .call1 _ _ | .call2 _ _ _ | .call3 _ _ _ _ => false
  | .cast _ e | .neg e | .bitNot e | .lnot e => scalarOnly e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => scalarOnly a && scalarOnly b
  | _ => true
def exprOnly (allowed : List Name) : Expr → Bool
  | .scalar e => scalarOnly e
  | .load32 _ _ | .load16 _ _ => false
  | .call1 n a => allowed.contains n && exprOnly allowed a
  | .call2 n a b => allowed.contains n && exprOnly allowed a && exprOnly allowed b
  | .call3 n a b c => allowed.contains n && exprOnly allowed a && exprOnly allowed b && exprOnly allowed c
  | .call4 n a b c d => allowed.contains n && exprOnly allowed a && exprOnly allowed b && exprOnly allowed c && exprOnly allowed d
  | .call5 _ _ _ _ _ _ => false
def only (allowed : List Name) : Stmt → Bool
  | .base .skip | .base (.scalar (.declare _ _)) => true
  | .base (.scalar (.assign _ e)) | .base (.scalar (.update _ _ e)) => scalarOnly e
  | .assign _ e | .ret e => exprOnly allowed e
  | .seq a b => only allowed a && only allowed b
  | .scope _ b => only allowed b
  | .branch e a b | .loop e a b => scalarOnly e && only allowed a && only allowed b
  | _ => false
def callees : Kind → List Name
  | .square => [name .mul]
  | .divB | .divT => [name .mul,name .square]
  | _ => []
def audit (kind : Kind) : Bool := decide (header kind=some (expectedHeader kind)) &&
  decide ((parsed kind).map (only (callees kind))=some true) &&
  decide (KeygenAttemptPin.vrfyLines[(range kind).2.2-1]?=some "}\n")
theorem conv_audit : audit .conv=true := by decide
theorem add_audit : audit .add=true := by decide
theorem sub_audit : audit .sub=true := by decide
theorem half_audit : audit .half=true := by decide
theorem mul_audit : audit .mul=true := by decide
theorem square_audit : audit .square=true := by decide
theorem divB_audit : audit .divB=true := by decide
theorem divT_audit : audit .divT=true := by decide
theorem rev_audit : audit .rev=true := by decide
theorem all_audit (kind : Kind) : audit kind=true := by
  cases kind
  · exact conv_audit
  · exact add_audit
  · exact sub_audit
  · exact half_audit
  · exact mul_audit
  · exact square_audit
  · exact divB_audit
  · exact divT_audit
  · exact rev_audit
theorem parsed_source (kind : Kind) : parsed kind=some (code kind) := by
  have h := (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp (all_audit kind)).1).2
  have h' : (parsed kind).map (only (callees kind))=some true := of_decide_eq_true h
  cases hp : parsed kind with
  | none => simp only [hp,Option.map_none] at h'; cases h'
  | some p => simp only [code,hp,Option.getD_some]
def empty : State := ⟨⟨fun _ _ => none,fun _ => 0,fun _ => false⟩,fun _ => none,fun _ => none,fun _ => none,fun _ => none⟩
def Body (calls : CallRelation) (kind : Kind) (args : List Value) (v : Value) : Prop :=
  args.length=(params kind).length ∧ ∃ out, C99ModularReference.GenExec calls (code kind)
    (C99ModularReference.bindParams empty (params kind) args) out ∧
    C99ProcedureReference.ReturnValue (some .uint32) out.flow (some v)
def IsLeaf (kind : Kind) : Prop := kind∈[Kind.conv,.add,.sub,.half,.mul,.rev]
inductive Leaf : CallRelation where
  | run (kind : Kind) (args : List Value) (v : Value) (leaf : IsLeaf kind)
      (source : Body (fun _ _ _ => False) kind args v) : Leaf (name kind) args v
inductive Square : CallRelation where
  | leaf (n : Name) (args : List Value) (v : Value) (source : Leaf n args v) : Square n args v
  | square (args : List Value) (v : Value) (source : Body Leaf .square args v) : Square (name .square) args v
inductive Call : CallRelation where
  | square (n : Name) (args : List Value) (v : Value) (source : Square n args v) : Call n args v
  | binary (args : List Value) (v : Value) (source : Body Square .divB args v) : Call (name .divB) args v
  | ternary (args : List Value) (v : Value) (source : Body Square .divT args v) : Call (name .divT) args v

end FT1536.Source3.KeygenPublicScalar
