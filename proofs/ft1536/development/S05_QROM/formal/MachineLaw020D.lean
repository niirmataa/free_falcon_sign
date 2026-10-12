import ProgramRefinement020D
import MachineStateBridge020D
import ObservationMoment019

set_option maxRecDepth 8192
namespace FT1536.S05.MachineLaw020D
open WordRAM020 ReadSemantics020A JointInterface019 FT1536.Relation FT1536.PublicSimulation
attribute [local irreducible] exec List.ofFn

/-- Actual020 machine output. Clients use public initial; the equality and
    law transport below cover every incoming state. -/
def code (h : Rq) (s : State) (tape : Bits tapeSize) : Bits outputSize :=
  MachineStateBridge020D.result (InputLayout020.encode h tape) PairProgram020.program s

theorem code_eq (h : Rq) (s : State) (tape : Bits tapeSize) :
    code h s tape=WireFormat020D.wire ((StandaloneRuntime019.publicCode h).code tape) :=
  MachineStateBridge020D.result_eq _ _ _ _ (ProgramRefinement020D.program_correct h tape s).1

noncomputable def law (h : Rq) (s : State) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code h s)

theorem law_eq (h : Rq) (s : State) :
    law h s=(pairLaw (StandaloneRuntime019.publicCode h)).map WireFormat020D.wire := by
  unfold law pairLaw
  rw [map_map]
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  funext tape
  exact code_eq h s tape

/-- Classical lossless encoding of BOTH full laws. This is neither a quantum
    composition theorem nor a replacement of the honest reference law. -/
theorem certificate_transport (h : Rq) (s : State) (p : Law (Rq × Option BoxVec)) (e : ℝ)
    (base : Certificate (StandaloneRuntime019.publicCode h) p e) :
    Divergence.AC (law h s) (p.map WireFormat020D.wire) ∧
      Divergence.second (law h s) (p.map WireFormat020D.wire)≤1+e := by
  rw [law_eq]
  exact ObservationMoment019.full_observation _ _ e base.1 base.2 WireFormat020D.wire

theorem all_states_same_law (h : Rq) (s t : State) : law h s=law h t :=
  (law_eq h s).trans (law_eq h t).symm

end FT1536.S05.MachineLaw020D
