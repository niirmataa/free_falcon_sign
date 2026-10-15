import PublicCoreCall020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicCall020E12
open WordRAM020 ArrayBank020E4 JointInterface019
attribute [local irreducible] PublicMaterialize020E12.filled IndexedParser020E5.run PublicCoreCall020E12.fromArena

def observe (s : ArrayState020E4.State) : Bits outputSize :=
  read (PublicMaterialize020E12.filled (read s.out) false).bank

theorem observe_eq (s : ArrayState020E4.State) : observe s=FullCall020E5.observe s := by
  have h := (PublicMaterialize020E12.filled_bank (read s.out) false).trans (load_read s.out)
  exact (congrArg read h).trans (FullCall020E5.observe_eq s).symm

/-- Outer none reports a startup/core consumer failure. Parser/root/core model
    rejection is retained as some none; the two outcomes are not identified. -/
def fromParser (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) :
    Option (Option (Bits outputSize)) :=
  if p.bad then some none else (PublicCoreCall020E12.fromArena d coins p).map (fun r => r.map observe)

def run (d : PublicData020E5.Data) (coins : Bits tapeSize) : Option (Option (Bits outputSize)) :=
  fromParser d coins (PublicPreparation020E12.parser d)

theorem fromParser_eq (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) :
    fromParser d coins p=some (((ParserMachine020E5.result p).bind (fun a => FullCall020E5.fromArena BankProgram020E3.frameCapacity a
      (ResidentCall020E5.inputs d coins) NodeProgram020E2.controlLimit ArrayState020E4.initial)).map FullCall020E5.observe) := by
  cases hb : p.bad
  · simp only [fromParser,hb,Bool.false_eq_true,ite_false,PublicCoreCall020E12.fromArena_eq,Option.map_some,
      ParserMachine020E5.result,Option.bind_some]
    exact congrArg (fun f => some ((FullCall020E5.fromArena BankProgram020E3.frameCapacity p.arena
      (ResidentCall020E5.inputs d coins) NodeProgram020E2.controlLimit ArrayState020E4.initial).map f)) (funext observe_eq)
  · simp only [fromParser,hb,ite_true,ParserMachine020E5.result,Option.bind_none,Option.map_none]

theorem run_eq (d : PublicData020E5.Data) (coins : Bits tapeSize) :
    run d coins=some (ResidentCall020E5.run d coins) :=
  fromParser_eq d coins (PublicPreparation020E12.parser d)

theorem every_tape (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    run (PublicData020E5.prepared k) coins=some (some (MachineLaw020D.code (CostInput020E4.key k) initial coins)) :=
  (run_eq _ coins).trans (congrArg some (ResidentCall020E5.every_tape k coins))

theorem full_response (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    run (PublicData020E5.prepared k) coins=some (some (WireFormat020D.wire ((StandaloneRuntime019.publicCode (CostInput020E4.key k)).code coins))) :=
  (every_tape k coins).trans (congrArg (fun v => some (some v)) (MachineLaw020D.code_eq _ initial coins))

end FT1536.S05.PublicCall020E12
