import NodeProgram020E2
import PublicDriver020E

set_option maxRecDepth 8192
namespace FT1536.S05.NodeDriver020E2
open WordRAM020 JointInterface019 FT1536.Relation

/-- Same explicit input copies, public reset and output transfer as020E,
    with the parsed-node evaluator replacing execution of Code. -/
def run (h : Rq) (dirty : State) (tape : Bits tapeSize) : Option (Bits outputSize) :=
  (NodeProgram020E2.actual (PublicDriver020E.input h tape) (PublicDriver020E.reset dirty)).map
    (fun s => PublicDriver020E.transfer s.out)

theorem observe (i : Input) (c : Code) (s : State) (q : Option State)
    (hq : q=some (WordRAM020.run i c s).1) :
    q.map (fun t => PublicDriver020E.transfer t.out)=some (MachineStateBridge020D.result i c s) := by
  rw [hq]
  simp only [Option.map_some,PublicDriver020E.transfer_eq]
  rfl

theorem run_eq (h : Rq) (dirty : State) (tape : Bits tapeSize) :
    run h dirty tape=some (MachineLaw020D.code h initial tape) := by
  unfold run
  rw [PublicDriver020E.input_eq,PublicDriver020E.reset_eq]
  change (NodeProgram020E2.actual (InputLayout020.encode h tape) initial).map
    (fun s => PublicDriver020E.transfer s.out)=
    some (MachineStateBridge020D.result (InputLayout020.encode h tape) PairProgram020.program initial)
  exact observe _ _ _ _ (NodeProgram020E2.actual_correct _ _)

/-- The fallback is unreachable by run_eq, not an additional sampler failure. -/
def code (h : Rq) (dirty : State) (tape : Bits tapeSize) : Bits outputSize :=
  PublicDriver020E.totalize (fun _ => false) (run h dirty tape)

theorem code_eq (h : Rq) (dirty : State) (tape : Bits tapeSize) :
    code h dirty tape=MachineLaw020D.code h initial tape :=
  PublicDriver020E.totalize_eq _ _ _ (run_eq h dirty tape)

noncomputable def law (h : Rq) (dirty : State) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code h dirty)

theorem law_eq (h : Rq) (dirty : State) : law h dirty=MachineLaw020D.law h initial := by
  unfold law MachineLaw020D.law
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  exact funext (code_eq h dirty)

theorem same_driver (h : Rq) (dirty : State) (tape : Bits tapeSize) :
    run h dirty tape=PublicDriver020E.run h dirty tape := by
  rw [run_eq,PublicDriver020E.run_eq]

end FT1536.S05.NodeDriver020E2
