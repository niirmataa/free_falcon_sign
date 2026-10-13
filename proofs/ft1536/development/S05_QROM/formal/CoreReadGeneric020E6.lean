import CoreFieldPatch020E5
import ProducerWordLaws020E6

set_option maxRecDepth 8192
namespace FT1536.S05.CoreReadGeneric020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 CoreEncoding020E5 CoreFieldPatch020E5

section
variable {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)

def metaPtr (j : Fin 16) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.natAdd (outputSize*1) (Fin.natAdd (capacity*3) (Fin.natAdd (cap*2) j))))

theorem meta_read (q : CoreState020E5.Core cap capacity limit) (j : Fin 16) :
    read (CoreEncoding020E5.encode hc hf hl q) (metaPtr j)=(metaCodec cap capacity limit hc hf hl).encode (metadata q) j := by
  change read (pack (pair cg (c3 cap capacity limit hc hf hl))
    (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))) (metaPtr j)=_
  unfold metaPtr
  rw [pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,
    pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,
    pack_pair,WordJoin020E5.right_read,pack_read]

def valuePtr (j : Fin cap) (field : Fin 2) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.natAdd (outputSize*1) (Fin.natAdd (capacity*3)
    (Fin.castAdd 16 (finProdFinEquiv (j,field))))))

theorem value_read (q : CoreState020E5.Core cap capacity limit) (j : Fin cap) (field : Fin 2) :
    read (CoreEncoding020E5.encode hc hf hl q) (valuePtr j field)=BankStorage020E3.valueWords (read q.values j) field := by
  change read (pack (pair cg (c3 cap capacity limit hc hf hl))
    (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))) (valuePtr j field)=_
  unfold valuePtr
  rw [pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,
    pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,
    pack_pair,WordJoin020E5.left_read,ProducerWordLaws020E6.read_encoded_cell]

def framePtr (j : Fin capacity) (field : Fin 3) : Fin (payloadWords cap capacity) :=
  Fin.natAdd (32*1) (Fin.natAdd (ramSize*1) (Fin.natAdd (outputSize*1)
    (Fin.castAdd (cap*2+16) (finProdFinEquiv (j,field)))))

theorem frame_read (q : CoreState020E5.Core cap capacity limit) (j : Fin capacity) (field : Fin 3) :
    read (CoreEncoding020E5.encode hc hf hl q) (framePtr j field)=BankStorage020E3.frameWords (read q.frames.bank j) field := by
  change read (pack (pair cg (c3 cap capacity limit hc hf hl))
    (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))) (framePtr j field)=_
  unfold framePtr
  rw [pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,
    pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.left_read,
    ProducerWordLaws020E6.read_encoded_cell]
  rfl
end
end FT1536.S05.CoreReadGeneric020E6
