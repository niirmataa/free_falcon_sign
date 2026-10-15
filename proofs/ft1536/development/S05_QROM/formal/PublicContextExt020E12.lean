import PublicMaterialize020E12

namespace FT1536.S05.PublicContextExt020E12

theorem ext (a b : ProducerRawCore020E11.Context)
    (hp : a.parser=b.parser) (ht : a.tape=b.tape) (hr : a.rom=b.rom)
    (hd : a.publicData=b.publicData) (ho : a.output=b.output) (hf : a.fresh=b.fresh) : a=b := by
  cases a
  cases b
  cases hp
  cases ht
  cases hr
  cases hd
  cases ho
  cases hf
  rfl

end FT1536.S05.PublicContextExt020E12
