import ArrayProgram020E4
import NodeDriver020E2

set_option maxRecDepth 8192
namespace FT1536.S05.ArrayDriver020E4
open WordRAM020 JointInterface019 FT1536.Relation

def run (h : Rq) (tape : Bits tapeSize) : Option (Bits outputSize) :=
  (ArrayProgram020E4.actual (ArrayState020E4.loadInput (InputLayout020.encode h tape)) ArrayState020E4.initial).map
    (fun s => ArrayBank020E4.read s.out)

theorem observe (q : Option ArrayState020E4.State) (i : Input) (c : Code) (s : State)
    (hq : q.map ArrayState020E4.model=some (WordRAM020.run i c s).1) :
    q.map (fun t => ArrayBank020E4.read t.out)=some (MachineStateBridge020D.result i c s) := by
  have h := NodeDriver020E2.observe i c s (q.map ArrayState020E4.model) hq
  simp only [Option.map_map,PublicDriver020E.transfer_eq,Function.comp_def,ArrayState020E4.model] at h
  exact h

theorem run_eq (h : Rq) (tape : Bits tapeSize) :
    run h tape=some (MachineLaw020D.code h initial tape) := by
  apply observe
  rw [ArrayProgram020E4.actual_eq,ArrayState020E4.input_load,ArrayState020E4.initial_eq,BankProgram020E3.actual_correct]

def code (h : Rq) (tape : Bits tapeSize) : Bits outputSize :=
  PublicDriver020E.totalize (fun _ => false) (run h tape)

theorem code_eq (h : Rq) (tape : Bits tapeSize) : code h tape=MachineLaw020D.code h initial tape :=
  PublicDriver020E.totalize_eq _ _ _ (run_eq h tape)

noncomputable def law (h : Rq) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code h)

theorem law_eq (h : Rq) : law h=MachineLaw020D.law h initial := by
  unfold law MachineLaw020D.law
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  exact funext (code_eq h)

end FT1536.S05.ArrayDriver020E4
