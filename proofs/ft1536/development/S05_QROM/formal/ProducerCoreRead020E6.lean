import ProducerCoreView020E6
import ProducerWordLaws020E6
import CoreReadGeneric020E6

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerCoreRead020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 CoreEncoding020E5 CoreFieldPatch020E5 ProducerCoreView020E6

abbrev hc : 877<2^511 := by decide +kernel
abbrev hf : 28941<2^511 := by decide +kernel
abbrev hl : 1106642201817<2^511 := by decide +kernel

def metaPtr (j : Fin 16) : Fin 143922 :=
  Fin.natAdd 32 (Fin.natAdd 4608 (Fin.natAdd 50689 (Fin.natAdd 86823 (Fin.natAdd 1754 j))))

theorem metaPtr_val (j : Fin 16) : (metaPtr j).val=143906+j.val := by simp only [metaPtr,Fin.val_natAdd];omega

theorem meta_read (q : Core) (j : Fin 16) :
    read (CoreEncoding020E5.encode hc hf hl q) (metaPtr j)=(metaCodec 877 28941 1106642201817 hc hf hl).encode (metadata q) j :=
  CoreReadGeneric020E6.meta_read hc hf hl q j

def valuePtr (j : Fin 877) (field : Fin 2) : Fin 143922 :=
  Fin.natAdd 32 (Fin.natAdd 4608 (Fin.natAdd 50689 (Fin.natAdd 86823
    (Fin.castAdd 16 (finProdFinEquiv (j,field))))))

theorem valuePtr_val (j : Fin 877) (field : Fin 2) : (valuePtr j field).val=142152+2*j.val+field.val := by
  change 32+(4608+(50689+(86823+(field.val+2*j.val))))=142152+2*j.val+field.val
  omega

theorem value_read (q : Core) (j : Fin 877) (field : Fin 2) :
    read (CoreEncoding020E5.encode hc hf hl q) (valuePtr j field)=BankStorage020E3.valueWords (read q.values j) field :=
  CoreReadGeneric020E6.value_read hc hf hl q j field

def framePtr (j : Fin 28941) (field : Fin 3) : Fin 143922 :=
  Fin.natAdd 32 (Fin.natAdd 4608 (Fin.natAdd 50689
    (Fin.castAdd (1754+16) (finProdFinEquiv (j,field)))))

theorem framePtr_val (j : Fin 28941) (field : Fin 3) : (framePtr j field).val=55329+3*j.val+field.val := by
  change 32+(4608+(50689+(field.val+3*j.val)))=55329+3*j.val+field.val
  omega

theorem frame_read (q : Core) (j : Fin 28941) (field : Fin 3) :
    read (CoreEncoding020E5.encode hc hf hl q) (framePtr j field)=BankStorage020E3.frameWords (read q.frames.bank j) field :=
  CoreReadGeneric020E6.frame_read hc hf hl q j field

end FT1536.S05.ProducerCoreRead020E6
