import PublicCoreCount020E13
import PublicCallFailures020E12

namespace FT1536.S05.PublicCallCount020E13
open WordRAM020 ArrayBank020E4 JointInterface019 CoreCountTypes020E13
attribute [local irreducible] PublicPreparation020E12.parser PublicCoreCount020E13.fromArena
attribute [local irreducible] PublicCoreCall020E12.fromArena PublicCall020E12.observe

/-- Whole public execution, with structural counters for the inner raw core.
    Preparation, startup, final readout/copy are executed but UNPRICED here. -/
def fromParser (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) : Report (Option (Option (Bits outputSize))) :=
  if p.bad then ⟨some none,zero⟩ else
    map (Option.map (Option.map PublicCall020E12.observe)) (PublicCoreCount020E13.fromArena d coins p)

def run (d : PublicData020E5.Data) (coins : Bits tapeSize) :=
  fromParser d coins (PublicPreparation020E12.parser d)

theorem fromParser_value (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) :
    (fromParser d coins p).value=PublicCall020E12.fromParser d coins p := by
  simp only [fromParser,PublicCall020E12.fromParser]
  split
  · rfl
  · exact congrArg (Option.map (Option.map PublicCall020E12.observe)) (PublicCoreCount020E13.fromArena_value d coins p)

theorem value (d : PublicData020E5.Data) (coins : Bits tapeSize) :
    (run d coins).value=PublicCall020E12.run d coins := fromParser_value _ _ _

theorem fromParser_valid (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) : Valid (fromParser d coins p).counts ProducerCoreExecution020E11.budget := by
  unfold fromParser
  split
  · exact zero_valid _
  · exact PublicCoreCount020E13.fromArena_valid _ _ _

theorem valid (d : PublicData020E5.Data) (coins : Bits tapeSize) :
    Valid (run d coins).counts ProducerCoreExecution020E11.budget := fromParser_valid _ _ _

theorem every_tape (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    (run (PublicData020E5.prepared k) coins).value=
      some (some (MachineLaw020D.code (CostInput020E4.key k) initial coins)) :=
  (value _ coins).trans (PublicCall020E12.every_tape k coins)

theorem full_response (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    (run (PublicData020E5.prepared k) coins).value=
      some (some (WireFormat020D.wire ((StandaloneRuntime019.publicCode (CostInput020E4.key k)).code coins))) :=
  (value _ coins).trans (PublicCall020E12.full_response k coins)

/-- Every public Data and tape, not only valid prepared keys or successful
    samplings. The constants count structural events, not elementary time. -/
theorem core_bound (d : PublicData020E5.Data) (coins : Bits tapeSize) :
    (run d coins).counts.cycles≤14733*ProducerCoreExecution020E11.budget ∧
    (run d coins).counts.slots≤32*ProducerCoreExecution020E11.budget ∧
    (run d coins).counts.writes≤32*ProducerCoreExecution020E11.budget ∧
    (run d coins).counts.tests≤ProducerCoreExecution020E11.budget := CoreCountBounds020E13.bounded _ _ (valid d coins)

theorem parser_reject (d : PublicData020E5.Data) (coins : Bits tapeSize)
    (p : ParserMachine020E5.State 877 877) (h : p.bad=true) : fromParser d coins p=⟨some none,zero⟩ := by
  simp only [fromParser,h,ite_true]

end FT1536.S05.PublicCallCount020E13
