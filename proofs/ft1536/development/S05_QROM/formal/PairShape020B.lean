import CapDraw020B
import PairStores020B
import PairAdvance020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairShape020B
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A TrialCorrect020A
open PairArithmetic020B PairStores020B PairAdvance020B CapDraw020B
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState StandaloneRuntime019.pair StandaloneRuntime019.first

theorem pair_shape (i : Input) (s : State) :
    exec i PairProgram020.pair s=exec i advance (exec i stores (exec i draw s)) := by
  simp only [PairProgram020.pair,advance,stores,draw,capped,fallback,
    exec_seqs_cons,exec_seqs_nil]
  rfl

end FT1536.S05.PairShape020B
