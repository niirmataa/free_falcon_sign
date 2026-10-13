import FullCall020E5
import PublicData020E5
import IndexedParser020E5
import ArrayCertificate020E4

namespace FT1536.S05.ResidentCall020E5
open WordRAM020 ArrayBank020E4 JointInterface019 FT1536.Relation

/-- Every read-only table/code/key argument is part of d. Ideal tape draws
    remain the stated randomness primitive; their retained bank is explicit. -/
def inputs (d : PublicData020E5.Data) (coins : Bits tapeSize) : ArrayState020E4.Input :=
  ⟨BoundaryFill020E5.tape coins,PublicData020E5.filledROM d⟩

def parsed (d : PublicData020E5.Data) : Option (ArrayArena020E4.Arena 877) :=
  ParserMachine020E5.result (IndexedParser020E5.run d.code 877 (ParserMachine020E5.start 877 877))

def run (d : PublicData020E5.Data) (coins : Bits tapeSize) : Option (Bits outputSize) :=
  ((parsed d).bind (fun a => FullCall020E5.fromArena BankProgram020E3.frameCapacity a
    (inputs d coins) NodeProgram020E2.controlLimit ArrayState020E4.initial)).map FullCall020E5.observe

theorem inputs_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    inputs (PublicData020E5.prepared k) coins=BoundaryFill020E5.inputs k coins := by
  unfold inputs BoundaryFill020E5.inputs
  rw [PublicData020E5.filledROM_eq]

theorem parsed_eq (k : CostInput020E4.Key) : parsed (PublicData020E5.prepared k)=FullCall020E5.parsed := by
  unfold parsed
  rw [IndexedParser020E5.executes]
  change ParserMachine020E5.result (ParserMachine020E5.run (List.ofFn (read PublicData020E5.codeBank)) _)=_
  rw [PublicData020E5.code_eq]
  rfl

theorem run_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    run (PublicData020E5.prepared k) coins=FullCall020E5.run k coins := by
  simp only [run,parsed_eq,inputs_eq,FullCall020E5.run,FullCall020E5.actual]

theorem every_tape (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    run (PublicData020E5.prepared k) coins=some (MachineLaw020D.code (CostInput020E4.key k) initial coins) :=
  (run_eq k coins).trans (FullCall020E5.every_tape k coins)

def code (k : CostInput020E4.Key) (coins : Bits tapeSize) : Bits outputSize :=
  PublicDriver020E.totalize (fun _ => false) (run (PublicData020E5.prepared k) coins)

theorem code_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    code k coins=MachineLaw020D.code (CostInput020E4.key k) initial coins :=
  PublicDriver020E.totalize_eq _ _ _ (every_tape k coins)

noncomputable def law (h : Rq) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code (load h))

theorem law_eq (h : Rq) : law h=MachineLaw020D.law h initial := by
  unfold law MachineLaw020D.law
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  funext coins
  rw [code_eq,CostInput020E4.same_key]

theorem all_h_ac (h : Rq) : Divergence.AC (law h) (MachineCertificate020D.reference h) := by
  rw [law_eq]
  exact MachineCertificate020D.all_h_ac h initial

theorem certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) :
    Divergence.AC (law h) (MachineCertificate020D.reference h) ∧
      Divergence.second (law h) (MachineCertificate020D.reference h)≤1+1/2^47 := by
  rw [law_eq]
  exact MachineCertificate020D.public_initial h mass

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq) (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) :
    Divergence.AC (Divergence.joint mu law) (Divergence.joint mu MachineCertificate020D.reference) ∧
    Divergence.second (Divergence.joint mu law) (Divergence.joint mu MachineCertificate020D.reference)≤1+1/2^47 := by
  have he : law=fun h => MachineLaw020D.law h initial := funext law_eq
  rw [he]
  exact MachineCertificate020D.same_key_law domain mu cover mass (fun _ => initial)

end FT1536.S05.ResidentCall020E5
