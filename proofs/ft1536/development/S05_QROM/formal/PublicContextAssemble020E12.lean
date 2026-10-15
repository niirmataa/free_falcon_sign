import PublicContextExt020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicContextAssemble020E12
open WordRAM020 ArrayBank020E4 WordCodec020E5 PublicMaterialize020E12

def assemble (d : PublicData020E5.Data) (t : FillMachine020E5.State Bool tapeSize)
    (r : FillMachine020E5.State Word romSize) (p : ParserMachine020E5.State 877 877)
    (o : FillMachine020E5.State Bool outputSize) : ProducerRawCore020E11.Context :=
  ⟨materialize (ParserStore020E5.codec 877 877 (by norm_num) (by norm_num)) p,
    materialize (FillStore020E5.codec (n:=tapeSize) boolCodec (by norm_num [tapeSize])) t,
    materialize (FillStore020E5.codec (n:=romSize) wordCodec (by norm_num [romSize])) r,
    materialize PublicData020E5.codec d,
    materialize (FillStore020E5.codec (n:=outputSize) boolCodec (by norm_num [outputSize])) o,
    materialize boolCodec false⟩

attribute [local irreducible] PublicMaterialize020E12.materialize VerifiedPatch020E5.pack BoundaryFill020E5.fill FillMachine020E5.run

theorem correct (d : PublicData020E5.Data) (t : FillMachine020E5.State Bool tapeSize)
    (r : FillMachine020E5.State Word romSize) (p : ParserMachine020E5.State 877 877)
    (o : FillMachine020E5.State Bool outputSize) (q : ProducerRawCore020E11.Core) :
    assemble d t r p o=ProducerRawCore020E11.ofData ⟨d,t,r,p,q,o⟩ false := by
  apply PublicContextExt020E12.ext
  · exact materialize_eq (ParserStore020E5.codec 877 877 (by norm_num) (by norm_num)) p
  · exact materialize_eq (FillStore020E5.codec (n:=tapeSize) boolCodec (by norm_num [tapeSize])) t
  · exact materialize_eq (FillStore020E5.codec (n:=romSize) wordCodec (by norm_num [romSize])) r
  · exact materialize_eq PublicData020E5.codec d
  · exact materialize_eq (FillStore020E5.codec (n:=outputSize) boolCodec (by norm_num [outputSize])) o
  · exact materialize_eq boolCodec false

end FT1536.S05.PublicContextAssemble020E12
