import PublicStartup020E12
import PublicPreparation020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicCoreCall020E12
open WordRAM020 ArrayBank020E4 JointInterface019 PublicStartupSpec020E12
attribute [local irreducible] PublicStartup020E12.start PublicPreparation020E12.context ProducerCoreExecution020E11.execute CoreRun020E5.execute ArrayExecute020E4.execute

def stack (root : Root) : ArrayFrames020E4.Stack (NodeFrames020E2.Frame 877) 28941 :=
  ⟨write (zero 28941 (.run (0 : Root))) (0 : Fin 28941) (.run root),1⟩

theorem push_eq (root : Root) :
    ArrayFrames020E4.push (ArrayFrames020E4.empty 28941 (NodeFrames020E2.Frame.run (0 : Root))) (.run root)=some (stack root) := by
  unfold ArrayFrames020E4.push ArrayFrames020E4.empty
  split
  · rfl
  · rename_i h;exact (h (by decide)).elim

def fromRoot (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) (root : Root) :
    Option (Option ArrayState020E4.State) :=
  (PublicStartup020E12.start root).bind (ProducerCoreExecution020E11.execute (PublicPreparation020E12.context d coins p))

theorem fromRoot_eq (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) (root : Root) :
    fromRoot d coins p root=some (ArrayExecute020E4.execute p.arena (ResidentCall020E5.inputs d coins) 1106642201817 (stack root) ArrayState020E4.initial) := by
  rw [fromRoot,PublicStartup020E12.correct,Option.bind_some,PublicPreparation020E12.context_eq,CoreStartup020E5.ready_start]
  have h := ProducerCoreExecution020E11.execute_refines (PublicPreparation020E12.witness d coins p) false
    ArrayState020E4.initial (stack root) (zero 877 none)
  rw [PublicPreparation020E12.inputs_eq] at h
  exact h

def fromArena (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) :
    Option (Option ArrayState020E4.State) :=
  if p.arena.sp.val=1 then fromRoot d coins p (ArenaStack020E1.peek (ArrayArena020E4.model p.arena) 0)
  else some none

theorem fromArena_push (a : ArrayArena020E4.Arena 877) (i : ArrayState020E4.Input) (fuel : Nat) (h : a.sp.val=1) :
    FullCall020E5.fromArena 28941 a i fuel ArrayState020E4.initial=
      CoreRun020E5.execute a i fuel (stack (ArenaStack020E1.peek (ArrayArena020E4.model a) 0)) ArrayState020E4.initial (zero 877 none) := by
  rw [FullCall020E5.fromArena,ite_eq_left h,push_eq,Option.bind_some]

theorem fromArena_eq (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) :
    fromArena d coins p=some (FullCall020E5.fromArena BankProgram020E3.frameCapacity p.arena
      (ResidentCall020E5.inputs d coins) NodeProgram020E2.controlLimit ArrayState020E4.initial) := by
  by_cases h : p.arena.sp.val=1
  · rw [fromArena,ite_eq_left h,fromRoot_eq]
    let root := ArenaStack020E1.peek (ArrayArena020E4.model p.arena) 0
    have hs := fromArena_push p.arena (ResidentCall020E5.inputs d coins) 1106642201817 h
    have he := CoreRun020E5.execute_refines p.arena (ResidentCall020E5.inputs d coins) 1106642201817 (stack root) ArrayState020E4.initial (zero 877 none)
    exact congrArg some (hs.trans he).symm
  · rw [fromArena,ite_eq_right h,FullCall020E5.fromArena,ite_eq_right h]

end FT1536.S05.PublicCoreCall020E12
