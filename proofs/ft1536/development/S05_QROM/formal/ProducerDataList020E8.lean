import ProducerControlList020E8

namespace FT1536.S05.ProducerDataList020E8
open WordRAM020 CoreEncoding020E5 CoreState020E5 CoreFieldPatch020E5 NodeFrames020E2

def valuePointer {cap capacity : Nat} (j : Fin cap) (f : Fin 2) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.natAdd (outputSize*1)
    (Fin.natAdd (capacity*3) (Fin.castAdd 16 (finProdFinEquiv (j,f))))))

def framePointer {cap capacity : Nat} (j : Fin capacity) (f : Fin 3) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.natAdd (outputSize*1)
    (Fin.castAdd (cap*2+16) (finProdFinEquiv (j,f)))))

theorem values_code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (j : Fin cap) (v : Option Word) :
    (CoreFieldPatch020E5.values hc hf hl q j v).code=
      List.ofFn (fun f : Fin 2 => (valuePointer (cap:=cap) (capacity:=capacity) j f,BankStorage020E3.valueWords v f)) := by
  unfold payloadWords
  simp only [CoreFieldPatch020E5.values,PairPatch020E5.first,PairPatch020E5.second,
    WordJoin020E5.liftLeft,WordJoin020E5.liftRight,VerifiedPatch020E5.cell,List.map_ofFn,Function.comp_def]
  rfl

theorem frames_code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (j : Fin capacity) (v : Frame cap) :
    (CoreFieldPatch020E5.frames hc hf hl q j v).code=
      List.ofFn (fun f : Fin 3 => (framePointer (cap:=cap) (capacity:=capacity) j f,BankStorage020E3.frameWords v f)) := by
  unfold payloadWords
  simp only [CoreFieldPatch020E5.frames,PairPatch020E5.first,PairPatch020E5.second,
    WordJoin020E5.liftLeft,WordJoin020E5.liftRight,VerifiedPatch020E5.cell,List.map_ofFn,Function.comp_def]
  rfl

end FT1536.S05.ProducerDataList020E8
