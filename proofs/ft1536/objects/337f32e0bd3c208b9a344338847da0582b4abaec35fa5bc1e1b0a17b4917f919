import Source3.FprScaledAST
import Source3.C99AddMulSound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprScaledBinding
open B20.C C99Typing C99StateBridge C99ValueBridge

theorem scaled_source : FprPrimitives.parseFunction (FprPrimitives.cslice 150 55)=some FprScaledAST.scaledCode := by rfl
theorem of_source : CLogicParser.parseFunction (FprPrimitives.hslice 86 5)=some FprScaledAST.ofCode := by rfl
theorem norm_source : FprPrimitives.normStatements ['m'] ['e']=some FprScaledAST.normCode := by rfl
theorem m0_selection : FprPinned.cLines[147]?=some "#else // yyyASM_CORTEXM4+0\n" ∧
    FprPinned.cLines[205]?=some "#endif // yyyASM_CORTEXM4-\n" := by decide

def prelude := (FprUnsignedPrefixes.scalars (FprScaledAST.scaledCode.body.take 8)).getD []
def tail := (FprUnsignedPrefixes.scalars (FprScaledAST.scaledCode.body.drop 9)).getD []
def paramTypes : Types := fun n => if n=['i'] then some .i64 else if n=['s','c'] then some .i32 else none
def preTypes : Types := fun n => if n=['m'] then some .u64 else if n=['t'] then some .u32 else
  if n=['e'] then some .i32 else if n=['s'] then some .i32 else paramTypes n
def normTypes : Types := fun n => if n=['n','t'] then some .u32 else preTypes n

theorem params_checked : C99ParametersBridge.paramTypes FprScaledAST.scaledCode.params=some paramTypes := by rfl
theorem pre_checked : checkBody C99HeaderSignature.signature paramTypes prelude=some preTypes := by rfl
theorem norm_checked : checkBody C99HeaderSignature.signature preTypes FprScaledAST.normCode=some normTypes := by rfl
theorem tail_checked : (checkBody C99HeaderSignature.signature preTypes tail).isSome := by decide
theorem pre_no_return : ∀ e, CLogic.Stmt.ret e∉prelude := by
  intro e; simp [prelude,FprUnsignedPrefixes.scalars,FprScaledAST.scaledCode]
theorem norm_no_return : ∀ e, CLogic.Stmt.ret e∉FprScaledAST.normCode := by intro e; simp [FprScaledAST.normCode]
theorem shape : FprScaledAST.scaledCode.body=prelude.map FprPrimitives.Instr.scalar ++
    [.norm ['m'] ['e']] ++ tail.map FprPrimitives.Instr.scalar := by rfl

def refBody : C99ScalarReference.Stmt := C99PrefixBridge.withTail prelude
  (.seq (.block (FprPrimitives.scalarDecls FprScaledAST.normCode) (C99Frontend.scalars FprScaledAST.normCode))
    (C99Frontend.scalars tail))
def refFunction : C99ScalarReference.Function :=
  ⟨FprScaledAST.scaledCode.params.map (fun (t,n) => (type t,n)),.uint64,refBody⟩

theorem lowering : C99Frontend.function FprScaledAST.scaledCode=some refFunction := by
  unfold C99Frontend.function
  rw [shape,List.append_assoc,C99PrefixBridge.lower_with_tail]
  simp [C99Frontend.lowerBody,norm_source,C99ScalarToFpr.lower_scalars,refFunction,refBody]
  rfl

theorem clean_types (s out : B20.C.Scalar.State) (hs : s.types=preTypes) (ho : out.types=normTypes) :
    (FprPrimitives.leaveBlock s out (FprPrimitives.scalarDecls FprScaledAST.normCode)).types=preTypes := by
  funext n
  by_cases hn : n=['n','t']
  · subst n
    simpa [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprScaledAST.normCode] using congrFun hs ['n','t']
  · simp [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprScaledAST.normCode,hn,ho,normTypes]

end FT1536.Source3.FprScaledBinding

#print axioms FT1536.Source3.FprScaledBinding.scaled_source
#print axioms FT1536.Source3.FprScaledBinding.norm_source
#print axioms FT1536.Source3.FprScaledBinding.lowering
