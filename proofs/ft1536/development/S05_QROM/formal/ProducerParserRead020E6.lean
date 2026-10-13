import ParserStore020E5
import ProducerWordLaws020E6

namespace FT1536.S05.ProducerParserRead020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ParserStore020E5 ArenaTypes020E1

section
variable {cap n : Nat} (hc : cap<2^511) (hn : n<2^511)

def nodePtr (j : Fin cap) (field : Fin 5) : Fin (Width cap) := Fin.castAdd 2 (Fin.castAdd (cap*1+2) (finProdFinEquiv (j,field)))

theorem node_read (q : ParserMachine020E5.State cap n) (j : Fin cap) (field : Fin 5) :
    read (ParserStore020E5.image hc hn q) (nodePtr j field)=ArenaWords020E1.nodeWords (read q.arena.bank j) field := by
  change read (pack (pair (ParserEncoding020E5.codec cap hc) (controls n hn)) (q.arena,(q.cursor,q.bad))) (nodePtr j field)=_
  unfold nodePtr
  rw [pack_pair,WordJoin020E5.left_read]
  change read (pack (pair (bank (ParserEncoding020E5.nodeCodec cap hc) cap) (ParserEncoding020E5.tailCodec cap hc))
    (q.arena.bank,(q.arena.stack,(q.arena.used,q.arena.sp)))) _=_
  rw [pack_pair,WordJoin020E5.left_read,ProducerWordLaws020E6.read_encoded_cell]
  rfl

def stackPtr (j : Fin cap) : Fin (Width cap) := Fin.castAdd 2 (Fin.natAdd (cap*5) (Fin.castAdd 2 (finProdFinEquiv (j,(0 : Fin 1)))))

theorem stack_read (q : ParserMachine020E5.State cap n) (j : Fin cap) :
    read (ParserStore020E5.image hc hn q) (stackPtr j)=word (read q.arena.stack j).val := by
  change read (pack (pair (ParserEncoding020E5.codec cap hc) (controls n hn)) (q.arena,(q.cursor,q.bad))) (stackPtr j)=_
  unfold stackPtr
  rw [pack_pair,WordJoin020E5.left_read]
  change read (pack (pair (bank (ParserEncoding020E5.nodeCodec cap hc) cap) (ParserEncoding020E5.tailCodec cap hc))
    (q.arena.bank,(q.arena.stack,(q.arena.used,q.arena.sp)))) _=_
  rw [pack_pair,WordJoin020E5.right_read,ParserEncoding020E5.tailCodec,pack_pair,WordJoin020E5.left_read,ProducerWordLaws020E6.read_encoded_cell]
  rfl

def usedPtr : Fin (Width cap) := Fin.castAdd 2 (Fin.natAdd (cap*5) (Fin.natAdd (cap*1) (Fin.castAdd 1 (0 : Fin 1))))
def spPtr : Fin (Width cap) := Fin.castAdd 2 (Fin.natAdd (cap*5) (Fin.natAdd (cap*1) (Fin.natAdd 1 (0 : Fin 1))))

theorem used_read (q : ParserMachine020E5.State cap n) :
    read (ParserStore020E5.image hc hn q) usedPtr=word q.arena.used.val := by
  change read (pack (pair (ParserEncoding020E5.codec cap hc) (controls n hn)) (q.arena,(q.cursor,q.bad))) usedPtr=_
  unfold usedPtr
  rw [pack_pair,WordJoin020E5.left_read]
  change read (pack (pair (bank (ParserEncoding020E5.nodeCodec cap hc) cap) (ParserEncoding020E5.tailCodec cap hc))
    (q.arena.bank,(q.arena.stack,(q.arena.used,q.arena.sp)))) _=_
  rw [pack_pair,WordJoin020E5.right_read,ParserEncoding020E5.tailCodec,pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.left_read,pack_read]
  rfl

theorem sp_read (q : ParserMachine020E5.State cap n) :
    read (ParserStore020E5.image hc hn q) spPtr=word q.arena.sp.val := by
  change read (pack (pair (ParserEncoding020E5.codec cap hc) (controls n hn)) (q.arena,(q.cursor,q.bad))) spPtr=_
  unfold spPtr
  rw [pack_pair,WordJoin020E5.left_read]
  change read (pack (pair (bank (ParserEncoding020E5.nodeCodec cap hc) cap) (ParserEncoding020E5.tailCodec cap hc))
    (q.arena.bank,(q.arena.stack,(q.arena.used,q.arena.sp)))) _=_
  rw [pack_pair,WordJoin020E5.right_read,ParserEncoding020E5.tailCodec,pack_pair,WordJoin020E5.right_read,pack_pair,WordJoin020E5.right_read,pack_read]
  rfl
end
end FT1536.S05.ProducerParserRead020E6
