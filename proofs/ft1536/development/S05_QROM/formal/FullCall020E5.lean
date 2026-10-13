import ParserMachine020E5
import BoundaryFill020E5
import CoreRun020E5
import ArrayDriver020E4
import PublicImage020E4

set_option maxRecDepth 8192
namespace FT1536.S05.FullCall020E5
open WordRAM020 ArrayBank020E4 ArenaTypes020E1 NodeFrames020E2 JointInterface019

def fromArena {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) : Option ArrayState020E4.State :=
  if a.sp.val=1 then
    (ArrayFrames020E4.push (ArrayFrames020E4.empty capacity (Frame.run (0 : Ptr cap)))
      (.run (ArenaStack020E1.peek (ArrayArena020E4.model a) 0))).bind
      (fun st => CoreRun020E5.execute a i fuel st s (zero cap none))
  else none

theorem fromArena_eq {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) :
    fromArena capacity a i fuel s=ArrayProgram020E4.fromArena capacity a i fuel s := by
  unfold fromArena ArrayProgram020E4.fromArena
  simp only [CoreRun020E5.execute_refines]

def parsed : Option (ArrayArena020E4.Arena 877) :=
  ParserMachine020E5.result (ParserMachine020E5.run PublicImage020E4.cells (ParserMachine020E5.start 877 877))

theorem parsed_eq : parsed=ArrayArena020E4.parse (ArenaProgram020E1.image PairProgram020.program) (ArrayArena020E4.empty 877) := by
  rw [parsed,ParserMachine020E5.start_result,PublicImage020E4.binding]

def actual (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : Option ArrayState020E4.State :=
  parsed.bind (fun a => fromArena BankProgram020E3.frameCapacity a i NodeProgram020E2.controlLimit s)

theorem actual_eq (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : actual i s=ArrayProgram020E4.actual i s := by
  simp only [actual,parsed_eq,fromArena_eq,ArrayProgram020E4.actual]

def observe (s : ArrayState020E4.State) : Bits outputSize := read (BoundaryFill020E5.output s.out)

theorem observe_eq (s : ArrayState020E4.State) : observe s=read s.out := congrArg read (BoundaryFill020E5.output_eq s.out)

def run (k : CostInput020E4.Key) (coins : Bits tapeSize) : Option (Bits outputSize) :=
  (actual (BoundaryFill020E5.inputs k coins) ArrayState020E4.initial).map observe

theorem run_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    run k coins=ArrayDriver020E4.run (CostInput020E4.key k) coins := by
  simp only [run,actual_eq,BoundaryFill020E5.inputs_eq,ArrayDriver020E4.run]
  exact congrArg (fun f => (ArrayProgram020E4.actual
    (ArrayState020E4.loadInput (InputLayout020.encode (CostInput020E4.key k) coins)) ArrayState020E4.initial).map f)
      (funext observe_eq)

theorem every_tape (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    run k coins=some (MachineLaw020D.code (CostInput020E4.key k) initial coins) :=
  (run_eq k coins).trans (ArrayDriver020E4.run_eq _ coins)

end FT1536.S05.FullCall020E5
