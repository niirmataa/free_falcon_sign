import PublicCall020E12

set_option maxRecDepth 8192
namespace FT1536.S05.PublicCallLaw020E12
open WordRAM020 JointInterface019 FT1536.Relation FT1536.PublicSimulation
attribute [local irreducible] PublicDriver020E.totalize PublicCall020E12.run

/-- Both fallback layers are unreachable on the prepared public program, by
    every_tape. Full sampler failures remain encoded in the returned response. -/
def code (k : CostInput020E4.Key) (coins : Bits tapeSize) : Bits outputSize :=
  PublicDriver020E.totalize (fun _ => false) ((PublicCall020E12.run (PublicData020E5.prepared k) coins).join)

theorem code_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    code k coins=MachineLaw020D.code (CostInput020E4.key k) initial coins :=
  PublicDriver020E.totalize_eq (fun _ => false) _ _ (congrArg Option.join (PublicCall020E12.every_tape k coins))

attribute [local irreducible] code

noncomputable def law (h : Rq) : Law (Bits outputSize) :=
  (Law.uniform : Law (Bits tapeSize)).map (code (ArrayBank020E4.load h))

theorem law_eq (h : Rq) : law h=MachineLaw020D.law h initial := by
  unfold law MachineLaw020D.law
  apply congrArg (fun f => (Law.uniform : Law (Bits tapeSize)).map f)
  funext coins
  rw [code_eq,CostInput020E4.same_key]

theorem full_law (h : Rq) :
    law h=(pairLaw (StandaloneRuntime019.publicCode h)).map WireFormat020D.wire :=
  (law_eq h).trans (MachineLaw020D.law_eq h initial)

/-- Same legacy reference, with its full lossless response encoding. -/
theorem all_h_ac (h : Rq) : Divergence.AC (law h) (MachineCertificate020D.reference h) := by
  rw [law_eq]
  exact MachineCertificate020D.all_h_ac h initial

/-- The original M is retained verbatim; no coverage or moment improvement. -/
theorem certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) :
    Divergence.AC (law h) (MachineCertificate020D.reference h) ∧
      Divergence.second (law h) (MachineCertificate020D.reference h)≤1+1/2^47 := by
  rw [law_eq]
  exact MachineCertificate020D.public_initial h mass

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) :
    Divergence.AC (Divergence.joint mu law) (Divergence.joint mu MachineCertificate020D.reference) ∧
      Divergence.second (Divergence.joint mu law) (Divergence.joint mu MachineCertificate020D.reference)≤1+1/2^47 := by
  have he : law=fun h => MachineLaw020D.law h initial := funext law_eq
  rw [he]
  exact MachineCertificate020D.same_key_law domain mu cover mass (fun _ => initial)

end FT1536.S05.PublicCallLaw020E12
