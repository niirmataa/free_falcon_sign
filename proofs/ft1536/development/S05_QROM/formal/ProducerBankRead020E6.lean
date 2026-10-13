import CoreReadGeneric020E6
import ProducerCoreView020E6

namespace FT1536.S05.ProducerBankRead020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 CoreEncoding020E5 CoreFieldPatch020E5
section
variable {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)

def regPtr (j : Fin 32) : Fin (payloadWords cap capacity) :=
  Fin.castAdd (ramSize*1+(outputSize*1+(capacity*3+(cap*2+16)))) (finProdFinEquiv (j,(0 : Fin 1)))

theorem reg_read (q : CoreState020E5.Core cap capacity limit) (j : Fin 32) :
    read (CoreEncoding020E5.encode hc hf hl q) (regPtr j)=read q.state.reg j := by
  change read (pack (pair cg (c3 cap capacity limit hc hf hl))
    (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))) (regPtr j)=_
  unfold regPtr
  rw [pack_pair,WordJoin020E5.left_read,ProducerWordLaws020E6.read_encoded_cell]
  rfl

def ramPtr (j : Fin ramSize) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.castAdd (outputSize*1+(capacity*3+(cap*2+16))) (finProdFinEquiv (j,(0 : Fin 1))))

theorem ram_read (q : CoreState020E5.Core cap capacity limit) (j : Fin ramSize) :
    read (CoreEncoding020E5.encode hc hf hl q) (ramPtr j)=read q.state.ram j := by
  change read (pack (pair cg (c3 cap capacity limit hc hf hl))
    (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))) (ramPtr j)=_
  unfold ramPtr
  rw [pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.left_read,ProducerWordLaws020E6.read_encoded_cell]
  rfl

def outPtr (j : Fin outputSize) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.castAdd (capacity*3+(cap*2+16)) (finProdFinEquiv (j,(0 : Fin 1)))))

theorem out_read (q : CoreState020E5.Core cap capacity limit) (j : Fin outputSize) :
    read (CoreEncoding020E5.encode hc hf hl q) (outPtr j)=boolWord (read q.state.out j) := by
  change read (pack (pair cg (c3 cap capacity limit hc hf hl))
    (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))) (outPtr j)=_
  unfold outPtr
  rw [pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.left_read,
    ProducerWordLaws020E6.read_encoded_cell]
  rfl
end
end FT1536.S05.ProducerBankRead020E6
