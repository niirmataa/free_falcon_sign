import ProducerMetaWords020E8

namespace FT1536.S05.ProducerControlList020E8
open WordRAM020 CoreEncoding020E5

def pointer {cap capacity : Nat} (j : Fin 16) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.natAdd (outputSize*1)
    (Fin.natAdd (capacity*3) (Fin.natAdd (cap*2) j))))

theorem code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (m : Meta cap capacity limit) :
    ControlStore020E5.code hc hf hl m=List.ofFn (fun j : Fin 16 => (pointer j,(metaCodec cap capacity limit hc hf hl).encode m j)) := by
  unfold payloadWords
  simp only [ControlStore020E5.code,WordJoin020E5.liftRight,List.map_ofFn,Function.comp_def]
  rfl

end FT1536.S05.ProducerControlList020E8
