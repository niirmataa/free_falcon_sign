import VectorLoopCore020C
import VectorValues020C

namespace FT1536.S05.VectorLoop020C
open WordRAM020 ReadSemantics020A CdfPrefix020A VectorPrefix020C VectorValues020C VectorLoopCore020C
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState values StandaloneRuntime019.pair

/-- The counted-loop step is FILLED by the actual pair theorem for every tape. -/
theorem vector_correct (h : Rq) (tape : Bits tapeSize) (n : Nat) (s : State)
    (hn : n<196) (h0 : s.reg 0=nw n) :
    let i := InputLayout020.encode h tape
    Good (values i n) (nw n) 1536 (exec i vectorCode s) ∧ Stable s (exec i vectorCode s) :=
  vector_from_steps (InputLayout020.encode h tape) (values (InputLayout020.encode h tape) n)
    (nw n) s h0 (fun k q hk hq => actual_step h tape n k q hn hk hq)

end FT1536.S05.VectorLoop020C
