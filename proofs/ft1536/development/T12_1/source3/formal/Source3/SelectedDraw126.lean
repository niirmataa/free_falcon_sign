import Source3.SelectedSamplerStart126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedDraw126
open C99CompactState115 (State reference)

/-- Bounded method test of the actual first source draw, including its
    complete SHAKE refill and temporary object's allocation/read/disposal.
    Successful definedness, rather than whole-state equality, is checked. -/
def result := KeygenRngCompute121.draw (KeygenSamplerContext.rng KeygenCallerData123.env.ctx)
  4096 7 SelectedSamplerStart126.firstRead

theorem defined : result.isSome=true := by decide +kernel

def output : State × BitVec 64 := result.get defined

theorem computed : KeygenRngCompute121.draw (KeygenSamplerContext.rng KeygenCallerData123.env.ctx)
    4096 7 SelectedSamplerStart126.firstRead=some output := SelectedInput124.option_get result defined

theorem source : KeygenRngSource.Call (KeygenSamplerContext.rng KeygenCallerData123.env.ctx)
    (reference SelectedSamplerStart126.firstRead) (reference output.1) output.2 :=
  KeygenRngCompute121.draw_sound _ 4096 7 SelectedSamplerStart126.firstRead output.1 output.2 computed

end FT1536.Source3.SelectedDraw126
