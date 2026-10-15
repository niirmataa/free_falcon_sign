import Source3.GeneratedSqrt132
import Source3.FprSqrtCompute132
import Source3.C99ScalarCallsDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprSqrtEight132

def input : BitVec 64 := 0x4020000000000000
def output : BitVec 64 := 0x4006a09e667f3bcd

theorem computed : FprSqrtCompute132.execute GeneratedSqrt132.code 55 (.u64 input)=some (.u64 output) := by
  decide +kernel

def SourceCall (args : List C99IntegerReference.Value) (out : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.headerCalls
    (FprSqrtSyntax132.lower GeneratedSqrt132.code) args out

theorem source : SourceCall [.uint64 input] (.uint64 output) :=
  FprSqrtCompute132.execute_sound GeneratedSqrt132.code 55 (.u64 input) (.u64 output) computed

theorem unique (args : List C99IntegerReference.Value) (a b : C99IntegerReference.Value)
    (first : SourceCall args a) (second : SourceCall args b) : a=b :=
  C99ScalarDeterminism089.function_unique C99Frontend.headerCalls
    C99ScalarCallsDeterminism089.header_calls _ args a b first second

theorem exact (out : C99IntegerReference.Value) (execution : SourceCall [.uint64 input] out) :
    out=.uint64 output := unique _ _ _ execution source

end FT1536.Source3.FprSqrtEight132
