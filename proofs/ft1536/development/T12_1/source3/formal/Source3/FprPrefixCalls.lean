import Source3.FprOfThree
import Source3.C99LeafCalls

/- Fixed value-only source closure used by the certificate prefix. Function
   bodies and the global constant are pinned M0 code. Call judgments execute
   those bodies; no field prescribes an arithmetic result or a successful run.
   The two strata reflect the acyclic header call graph: of -> scaled, and
   inverse_of -> of/div. The caller's heap is not part of this pure closure. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprPrefixCalls
open B20.C C99ScalarReference

def negCode : CLogic.Function where
  name := "fpr_neg".toList
  result := .u64
  params := [(.u64,"x".toList)]
  body := [.update "x".toList .xor (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)),
           .ret (.var "x".toList)]
def subCode : CLogic.Function where
  name := "fpr_sub".toList
  result := .u64
  params := [(.u64,"x".toList),(.u64,"y".toList)]
  body := [.update "y".toList .xor (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)),
           .ret (.call2 "fpr_add".toList (.var "x".toList) (.var "y".toList))]
def sqrCode : CLogic.Function where
  name := "fpr_sqr".toList
  result := .u64
  params := [(.u64,"x".toList)]
  body := [.ret (.call2 "fpr_mul".toList (.var "x".toList) (.var "x".toList))]
def invCode : CLogic.Function where
  name := "fpr_inv".toList
  result := .u64
  params := [(.u64,"x".toList)]
  body := [.ret (.call2 "fpr_div".toList (.var "fpr_one".toList) (.var "x".toList))]
def inverseOfCode : CLogic.Function where
  name := "fpr_inverse_of".toList
  result := .u64
  params := [(.i64,"i".toList)]
  body := [.ret (.call2 "fpr_div".toList (.var "fpr_one".toList)
    (.call1 "fpr_of".toList (.var "i".toList)))]

def source (start count : Nat) : Option CLogic.Function :=
  CLogicParser.parseFunction (((Pinned.fprLines.drop start).take count).flatMap String.toList)
theorem neg_source : source 157 6=some negCode := by decide
theorem sub_source : source 150 6=some subCode := by decide
theorem sqr_source : source 182 5=some sqrCode := by decide
theorem inv_source : source 188 5=some invCode := by decide
theorem inverse_of_source : source 91 5=some inverseOfCode := by decide
theorem one_source : Pinned.fprLines[76]?=
    some "static const fpr fpr_one = 0x3ff0000000000000ULL;\n" := by decide

def withGlobals (env : C99ScalarReference.Env) : C99ScalarReference.Env := fun name =>
  match env name with
  | some cell => some cell
  | none => if name="fpr_one".toList then some (.uint64,some (.uint64 Run2.KeygenLeafGate.oneBits)) else none

inductive ValueCall (calls : CallRelation) (f : CLogic.Function) :
    List C99IntegerReference.Value → C99IntegerReference.Value → Prop where
  | call (args : List C99IntegerReference.Value) (env : C99ScalarReference.Env)
      (v : C99IntegerReference.Value)
      (bind : BindArgs (C99Frontend.headerFunction f).params args env)
      (body : C99ScalarReference.Exec calls (withGlobals env)
        (C99Frontend.scalars f.body) (.returned v)) :
      ValueCall calls f args (C99IntegerReference.convert (C99ValueBridge.type f.result) v.integer)

def baseCalls (name : B20.C.Name) (args : List C99IntegerReference.Value)
    (z : C99IntegerReference.Value) : Prop :=
  if name="fpr_scaled".toList then
    C99ScalarReference.FunctionExec C99Frontend.headerCalls FprScaledBinding.refFunction args z
  else C99Frontend.primitiveCall name args z

def ofCalls (name : B20.C.Name) (args : List C99IntegerReference.Value)
    (z : C99IntegerReference.Value) : Prop :=
  if name="fpr_of".toList then ValueCall baseCalls FprScaledAST.ofCode args z
  else baseCalls name args z

def lookup (name : B20.C.Name) : Option CLogic.Function :=
  if name="fpr_neg".toList then source 157 6
  else if name="fpr_sub".toList then source 150 6
  else if name="fpr_sqr".toList then source 182 5
  else if name="fpr_inv".toList then source 188 5
  else if name="fpr_inverse_of".toList then source 91 5
  else if name="fpr_half".toList then some StableBinary.halfProgram
  else if name="fpr_double".toList then some StableBinary.doubleProgram
  else none

def calls (name : B20.C.Name) (args : List C99IntegerReference.Value)
    (z : C99IntegerReference.Value) : Prop :=
  match lookup name with
  | some f => ValueCall ofCalls f args z
  | none => ofCalls name args z

theorem lookup_result (name : B20.C.Name) (f : CLogic.Function) (h : lookup name=some f) :
    f.result=.u64 := by
  unfold lookup at h
  rw [neg_source,sub_source,sqr_source,inv_source,inverse_of_source] at h
  split_ifs at h <;> cases h <;> rfl

theorem value_call_result (rc : CallRelation) (f : CLogic.Function)
    (args : List C99IntegerReference.Value) (v : C99IntegerReference.Value)
    (h : ValueCall rc f args v) : v.type=C99ValueBridge.type f.result := by
  cases h
  exact C99Typing.converted_type _ _

end FT1536.Source3.FprPrefixCalls
