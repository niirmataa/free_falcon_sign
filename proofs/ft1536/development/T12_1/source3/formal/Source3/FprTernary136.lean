import Source3.FprBoundCalls135

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprTernary136
open B20.C (Val)
open C99ValueBridge (value)

def negative : BitVec 64 := 0xbff0000000000000
def positive : BitVec 64 := 0x3ff0000000000000

theorem negative_computed : FprBoundCalls135.ofModel (.i32 (BitVec.ofInt 32 (-1)))=some (.u64 negative) := by decide +kernel
theorem zero_computed : FprBoundCalls135.ofModel (.i32 0)=some (.u64 0) := by decide +kernel
theorem positive_computed : FprBoundCalls135.ofModel (.i32 1)=some (.u64 positive) := by decide +kernel

theorem of_source (arg : Val) (word : BitVec 64)
    (computed : FprBoundCalls135.ofModel arg=some (.u64 word)) :
    FprPrefixCalls.calls "fpr_of".toList [value arg] (.uint64 word) := by
  have source := FprBoundCalls135.of_source arg word computed
  exact (FprScalarClosure132.unchanged "fpr_of".toList [value arg] (.uint64 word) (by decide +kernel)).mp source

def calls (name : B20.C.Name) (args : List Val) : Option Val :=
  if name="fpr_of".toList then
    if args=[.i32 (BitVec.ofInt 32 (-1))] then some (.u64 negative)
    else if args=[.i32 0] then some (.u64 0)
    else if args=[.i32 1] then some (.u64 positive)
    else none
  else none

theorem sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls := by
  intro name args out computed
  unfold calls at computed
  split_ifs at computed with named neg zero pos
  · subst name args
    have same := Option.some.inj computed
    subst out
    exact of_source _ _ negative_computed
  · subst name args
    have same := Option.some.inj computed
    subst out
    exact of_source _ _ zero_computed
  · subst name args
    have same := Option.some.inj computed
    subst out
    exact of_source _ _ positive_computed

end FT1536.Source3.FprTernary136
