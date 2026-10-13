import CoreStartup020E5
import ParserStore020E5
import ZeroCodec020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.StartupImage020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ArenaTypes020E1 CoreState020E5 CoreEncoding020E5

theorem pack_zero {A : Type} {n : Nat} (c : Codec A n) (a : A) (h : ∀ j,c.encode a j=0) :
    pack c a=zero n (0 : Word) := by
  apply ArrayBank020E4.ext
  funext j
  rw [pack_read,zero,read_load]
  exact h j

theorem empty_node_zero (cap : Nat) (hc : cap<2^511) : ∀ j,(ParserEncoding020E5.nodeCodec cap hc).encode (emptyNode cap) j=0 := by
  intro j
  fin_cases j <;> rfl

theorem empty_frame_zero (cap : Nat) (hc : cap<2^511) : ∀ j,(frameCodec cap hc).encode (.run (0 : Ptr cap)) j=0 := by
  intro j
  fin_cases j <;> rfl

theorem meta_zero (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) :
    ∀ j,(metaCodec cap capacity limit hc hf hl).encode (.check,(0,(0,(0,(.none,false))))) j=0 := by
  intro j
  fin_cases j <;> rfl

theorem core_zero (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) :
    CoreEncoding020E5.encode hc hf hl (CoreStartup020E5.blank cap capacity limit)=zero (payloadWords cap capacity) (0 : Word) := by
  change pack (pair (bank wordCodec 32) (pair (bank wordCodec ramSize) (pair (bank boolCodec outputSize)
    (pair (bank (frameCodec cap hc) capacity) (pair (bank CoreFieldPatch020E5.valueCodec cap)
      (metaCodec cap capacity limit hc hf hl))))))
    (zero 32 (0 : Word),(zero ramSize (0 : Word),(zero outputSize false,
      (zero capacity (.run (0 : Ptr cap)),(zero cap none,(.check,(0,(0,(0,(.none,false))))))))))=_
  simp only [pack_pair]
  rw [ZeroCodec020E5.bank_zero wordCodec 32 0 (by intro j;rfl),
    ZeroCodec020E5.bank_zero wordCodec ramSize 0 (by intro j;rfl),
    ZeroCodec020E5.bank_zero boolCodec outputSize false (by intro j;rfl),
    ZeroCodec020E5.bank_zero (frameCodec cap hc) capacity (.run (0 : Ptr cap)) (empty_frame_zero cap hc),
    ZeroCodec020E5.bank_zero CoreFieldPatch020E5.valueCodec cap none (by intro j;rfl),
    pack_zero _ _ (meta_zero cap capacity limit hc hf hl)]
  simp only [ZeroCodec020E5.join_zero]
  rfl

theorem parser_zero (cap n : Nat) (hc : cap<2^511) (hn : n<2^511) :
    ParserStore020E5.image hc hn (ParserMachine020E5.start cap n)=zero (ParserStore020E5.Width cap) (0 : Word) := by
  change pack (pair (ParserEncoding020E5.codec cap hc) (ParserStore020E5.controls n hn)) (ArrayArena020E4.empty cap,(0,false))=_
  rw [pack_pair]
  have ha : ParserEncoding020E5.image hc (ArrayArena020E4.empty cap)=zero (cap*5+(cap*1+(1+1))) (0 : Word) := by
    change pack (pair (bank (ParserEncoding020E5.nodeCodec cap hc) cap) (ParserEncoding020E5.tailCodec cap hc))
      (zero cap (emptyNode cap),(zero cap (0 : Ptr cap),((0 : Ptr cap),(0 : Ptr cap))))=_
    simp only [ParserEncoding020E5.tailCodec,pack_pair]
    rw [ZeroCodec020E5.bank_zero (ParserEncoding020E5.nodeCodec cap hc) cap (emptyNode cap) (empty_node_zero cap hc),
      ZeroCodec020E5.bank_zero (finCodec (cap+1) (by omega)) cap 0 (by intro j;rfl),
      pack_zero (finCodec (cap+1) (by omega)) 0 (by intro j;rfl)]
    simp only [ZeroCodec020E5.join_zero]
  rw [show pack (ParserEncoding020E5.codec cap hc) (ArrayArena020E4.empty cap)=zero _ (0 : Word) from ha]
  rw [pack_zero (ParserStore020E5.controls n hn) (0,false) (by intro j;fin_cases j <;> rfl),ZeroCodec020E5.join_zero]

theorem zero_cells (n : Nat) : (zero n (0 : Word)).cells=Array.replicate n (0 : Word) := by
  apply Array.ext
  · simp only [zero,load,Array.size_ofFn,Array.size_replicate]
  · intro j hj hj'
    simp only [zero,load,Array.getElem_ofFn,Array.getElem_replicate]

end FT1536.S05.StartupImage020E5
