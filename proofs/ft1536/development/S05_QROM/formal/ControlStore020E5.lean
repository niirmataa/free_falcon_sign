import CoreFieldPatch020E5

namespace FT1536.S05.ControlStore020E5
open WordRAM020 CoreEncoding020E5 CoreState020E5 CoreFieldPatch020E5

/-- Emitted control stores depend only on the sixteen-word scalar payload,
    never on a materialized successor bank or a duplicate Core. -/
def code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (m : Meta cap capacity limit) : List (WordPatch020E5.Write (payloadWords cap capacity)) :=
  WordJoin020E5.liftRight (32*1) (WordJoin020E5.liftRight (ramSize*1)
    (WordJoin020E5.liftRight (outputSize*1) (WordJoin020E5.liftRight (capacity*3)
      (WordJoin020E5.liftRight (cap*2)
        (List.ofFn (fun j : Fin 16 => (j,(metaCodec cap capacity limit hc hf hl).encode m j)))))))

theorem control_code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (m : Meta cap capacity limit) :
    (CoreFieldPatch020E5.control hc hf hl q m).code=code hc hf hl m := by
  unfold payloadWords
  simp only [CoreFieldPatch020E5.control,PairPatch020E5.second,VerifiedPatch020E5.overwrite,
    VerifiedPatch020E5.pack,ArrayBank020E4.read_load,code]

theorem length {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (m : Meta cap capacity limit) : (code hc hf hl m).length=16 := by
  unfold payloadWords
  simp only [code,WordJoin020E5.liftRight,List.length_map,List.length_ofFn]

end FT1536.S05.ControlStore020E5
