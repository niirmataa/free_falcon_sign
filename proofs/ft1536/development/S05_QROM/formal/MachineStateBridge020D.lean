import WireFormat020D
import ReadSemantics020A

namespace FT1536.S05.MachineStateBridge020D
open WordRAM020 ReadSemantics020A JointInterface019 FT1536.Relation FT1536.PublicSimulation
attribute [local irreducible] exec List.ofFn

def result (i : Input) (c : Code) (s : State) : Bits outputSize := (exec i c s).out

theorem result_eq (i : Input) (c : Code) (s : State) (a : Rq × Option BoxVec)
    (he : List.ofFn (exec i c s).out=PairEncoding020.encode a) : result i c s=WireFormat020D.wire a :=
  WireFormat020D.of_list _ _ he

end FT1536.S05.MachineStateBridge020D
