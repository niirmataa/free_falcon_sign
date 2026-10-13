import CopyBank020E
import ControlStack020E
import MachineLaw020D

set_option maxRecDepth 8192
namespace FT1536.S05.PublicDriver020E
open WordRAM020 JointInterface019 FT1536.Relation

/-- Materialize the complete tape and public image in separate banks. -/
def input (h : Rq) (tape : Bits tapeSize) : Input :=
  ⟨CopyBank020E.fill tape (fun _ => false) tapeSize,
   CopyBank020E.fill (InputLayout020.image h) (fun _ => 0) romSize⟩

/-- Public reset, with no dependence on a previous private machine state. -/
def reset (dirty : State) : State :=
  ⟨CopyBank020E.fill (fun _ => 0) dirty.reg 32,
   CopyBank020E.fill (fun _ => 0) dirty.ram ramSize,
   CopyBank020E.fill (fun _ => false) dirty.out outputSize,false⟩

def transfer (out : Bits outputSize) : Bits outputSize :=
  CopyBank020E.fill out (fun _ => false) outputSize

theorem input_eq (h : Rq) (tape : Bits tapeSize) : input h tape=InputLayout020.encode h tape := by
  simp only [input,CopyBank020E.complete]
  rfl

theorem reset_eq (dirty : State) : reset dirty=initial := by
  simp only [reset,CopyBank020E.complete]
  rfl

theorem transfer_eq (out : Bits outputSize) : transfer out=out := CopyBank020E.complete _ _

def execute (i : Input) (c : Code) (s : State) : Option (Bits outputSize) :=
  (ControlStack020E.execute i (ControlStack020E.work c) [c] s).map (fun r => transfer r.out)

theorem execute_eq (i : Input) (c : Code) (s : State) :
    execute i c s=some (MachineStateBridge020D.result i c s) := by
  unfold execute
  rw [ControlStack020E.singleton]
  simp only [Option.map_some,transfer_eq]
  rfl

def run (h : Rq) (dirty : State) (tape : Bits tapeSize) : Option (Bits outputSize) :=
  execute (input h tape) PairProgram020.program (reset dirty)

theorem run_eq (h : Rq) (dirty : State) (tape : Bits tapeSize) :
    run h dirty tape=some (MachineLaw020D.code h initial tape) := by
  unfold run
  rw [input_eq,reset_eq,execute_eq]
  rfl

def totalize {A : Type} (fallback : A) (out : Option A) : A := out.getD fallback

theorem totalize_eq {A : Type} (fallback a : A) (out : Option A) (he : out=some a) :
    totalize fallback out=a := by rw [he];rfl

/-- Option fallback is unreachable by run_eq; the executable driver code
    is total on every tape and starts from the public reset. -/
def code (h : Rq) (dirty : State) (tape : Bits tapeSize) : Bits outputSize :=
  totalize (fun _ => false) (run h dirty tape)

theorem code_eq (h : Rq) (dirty : State) (tape : Bits tapeSize) :
    code h dirty tape=MachineLaw020D.code h initial tape :=
  totalize_eq _ _ _ (run_eq h dirty tape)

noncomputable def law (h : Rq) (dirty : State) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code h dirty)

theorem law_eq (h : Rq) (dirty : State) : law h dirty=MachineLaw020D.law h initial := by
  unfold law MachineLaw020D.law
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  exact funext (code_eq h dirty)

/-- Transfer prices only. Evaluator/control compilation, physical allocation
    and input-image source costs must still be added before a total claim. -/
def phasePrice (t r a m o : Nat) : Nat := CopyBank020E.price t t +
  CopyBank020E.price r r + CopyBank020E.price a a +
  CopyBank020E.price m m + 2*CopyBank020E.price o o + 1

theorem phase_price (t r a m o : Nat) : phasePrice t r a m o=8*(t+r+a+m+2*o)+25 := by
  simp only [phasePrice,CopyBank020E.complete_price]
  omega

def transferPrice : Nat := phasePrice tapeSize romSize 32 ramSize outputSize

theorem transfer_price : transferPrice=8*(tapeSize+romSize+32+ramSize+2*outputSize)+25 :=
  phase_price tapeSize romSize 32 ramSize outputSize

end FT1536.S05.PublicDriver020E
