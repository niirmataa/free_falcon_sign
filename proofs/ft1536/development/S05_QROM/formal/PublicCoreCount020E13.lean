import CoreResultCount020E13
import CountedFlow020E13
import PublicCoreCall020E12

namespace FT1536.S05.PublicCoreCount020E13
open WordRAM020 ArrayBank020E4 JointInterface019 PublicStartupSpec020E12 CoreCountTypes020E13
attribute [local irreducible] PublicStartup020E12.start PublicPreparation020E12.context
attribute [local irreducible] CoreResultCount020E13.execute ProducerCoreExecution020E11.execute

/-- Instrumentation of the inner raw core in the full public call. Startup
    still executes normally but is intentionally not included in these counts. -/
def fromRoot (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) (root : Root) : Report (Option (Option ArrayState020E4.State)) :=
  CountedFlow020E13.optionBind (PublicStartup020E12.start root)
    (CoreResultCount020E13.execute (PublicPreparation020E12.context d coins p))

theorem fromRoot_value (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) (root : Root) :
    (fromRoot d coins p root).value=PublicCoreCall020E12.fromRoot d coins p root :=
  CountedFlow020E13.optionBind_refines (PublicStartup020E12.start root)
    (CoreResultCount020E13.execute (PublicPreparation020E12.context d coins p))
    (ProducerCoreExecution020E11.execute (PublicPreparation020E12.context d coins p))
    (CoreResultCount020E13.execute_value _)

theorem fromRoot_valid (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) (root : Root) :
    Valid (fromRoot d coins p root).counts ProducerCoreExecution020E11.budget :=
  CountedFlow020E13.optionBind_valid (PublicStartup020E12.start root)
    (CoreResultCount020E13.execute (PublicPreparation020E12.context d coins p))
    ProducerCoreExecution020E11.budget (CoreResultCount020E13.execute_valid _)

def fromArena (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) : Report (Option (Option ArrayState020E4.State)) :=
  if p.arena.sp.val=1 then fromRoot d coins p (ArenaStack020E1.peek (ArrayArena020E4.model p.arena) 0)
  else ⟨some none,zero⟩

theorem fromArena_value (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) :
    (fromArena d coins p).value=PublicCoreCall020E12.fromArena d coins p := by
  have he := CountedFlow020E13.select_value (decide (p.arena.sp.val=1))
    (fromRoot d coins p (ArenaStack020E1.peek (ArrayArena020E4.model p.arena) 0))
    (⟨some none,zero⟩ : Report (Option (Option ArrayState020E4.State)))
  simp only [decide_eq_true_eq,fromRoot_value] at he
  exact he

theorem fromArena_valid (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) : Valid (fromArena d coins p).counts ProducerCoreExecution020E11.budget := by
  have h := CountedFlow020E13.select_valid (decide (p.arena.sp.val=1))
    (fromRoot d coins p (ArenaStack020E1.peek (ArrayArena020E4.model p.arena) 0))
    (⟨some none,zero⟩ : Report (Option (Option ArrayState020E4.State)))
    ProducerCoreExecution020E11.budget (fromRoot_valid _ _ _ _) (zero_valid _)
  simpa only [fromArena,decide_eq_true_eq] using h

end FT1536.S05.PublicCoreCount020E13
