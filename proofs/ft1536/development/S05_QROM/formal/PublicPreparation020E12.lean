import PublicContextAssemble020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicPreparation020E12
open WordRAM020 ArrayBank020E4 WordCodec020E5 PublicMaterialize020E12 JointInterface019
attribute [local irreducible] PublicMaterialize020E12.filled IndexedParser020E5.run

/-- Concrete finite fill loops reading the ideal tape and resident public data. -/
def tape (coins : Bits tapeSize) := filled coins false
def rom (d : PublicData020E5.Data) := filled (PublicData020E5.romCell d) (0 : Word)
def parser (d : PublicData020E5.Data) := IndexedParser020E5.run d.code 877 (ParserMachine020E5.start 877 877)
def outputBlank : FillMachine020E5.State Bool outputSize := FillMachine020E5.start (zero outputSize false)

/-- Operational construction of every port from its concrete preparation state.
    The core and its secret/history-free public reset are not supplied here. -/
def context (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) : ProducerRawCore020E11.Context :=
  PublicContextAssemble020E12.assemble d (tape coins) (rom d) p outputBlank

/-- Comparison object only, never passed to the runtime core. -/
def witness (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) : BoundaryPayload020E5.Data :=
  ⟨d,tape coins,rom d,p,CoreStartup020E5.blank 877 28941 1106642201817,outputBlank⟩

theorem context_eq (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) :
    context d coins p=ProducerRawCore020E11.ofData (witness d coins p) false := by
  exact PublicContextAssemble020E12.correct d (tape coins) (rom d) p outputBlank (CoreStartup020E5.blank 877 28941 1106642201817)

theorem inputs_eq (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) :
    ProducerSlotLayout020E7.input (witness d coins p)=ResidentCall020E5.inputs d coins := by
  have ht : (tape coins).bank=BoundaryFill020E5.tape coins :=
    (filled_bank coins false).trans (BoundaryFill020E5.tape_eq coins).symm
  have hr : (rom d).bank=PublicData020E5.filledROM d :=
    (filled_bank (PublicData020E5.romCell d) (0 : Word)).trans (BoundaryFill020E5.fill_eq _ _).symm
  change (⟨(tape coins).bank,(rom d).bank⟩ : ArrayState020E4.Input)=⟨_,_⟩
  rw [ht,hr]

theorem tape_complete (coins : Bits tapeSize) : (tape coins).cursor.val=tapeSize := filled_cursor coins false

theorem rom_complete (d : PublicData020E5.Data) : (rom d).cursor.val=romSize := filled_cursor (PublicData020E5.romCell d) (0 : Word)

theorem parser_complete (d : PublicData020E5.Data) : (parser d).cursor.val=877 :=
  IndexedParser020E5.done d.code 877 (ParserMachine020E5.start 877 877) (by exact le_rfl)

theorem parsed_eq (d : PublicData020E5.Data) : ParserMachine020E5.result (parser d)=ResidentCall020E5.parsed d := rfl

end FT1536.S05.PublicPreparation020E12
