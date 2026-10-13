import ParserDecision020E5
import CoreEncoding020E5
import PairPatch020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ParserEncoding020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ArenaTypes020E1

def nodeCodec (cap : Nat) (hc : cap<2^511) : Codec (Node cap) 5 :=
  ⟨ArenaWords020E1.nodeWords,ArenaWords020E1.node_words_injective hc⟩

abbrev Fields (cap : Nat) := Bank (Node cap) cap × (Bank (Ptr cap) cap × (Ptr cap × Ptr cap))

def fields {cap : Nat} (a : ArrayArena020E4.Arena cap) : Fields cap := (a.bank,(a.stack,(a.used,a.sp)))
def ofFields {cap : Nat} (f : Fields cap) : ArrayArena020E4.Arena cap := ⟨f.1,f.2.1,f.2.2.1,f.2.2.2⟩

theorem fields_injective {cap : Nat} : Function.Injective (@fields cap) := by
  intro a b h
  exact congrArg ofFields h

def tailCodec (cap : Nat) (hc : cap<2^511) :=
  pair (bank (finCodec (cap+1) (by omega)) cap)
    (pair (finCodec (cap+1) (by omega)) (finCodec (cap+1) (by omega)))

def codec (cap : Nat) (hc : cap<2^511) : Codec (ArrayArena020E4.Arena cap) (cap*5+(cap*1+(1+1))) :=
  contramap (pair (bank (nodeCodec cap hc) cap) (tailCodec cap hc)) fields fields_injective

def image {cap : Nat} (hc : cap<2^511) (a : ArrayArena020E4.Arena cap) := pack (codec cap hc) a

def nodes {cap : Nat} (hc : cap<2^511) (a : ArrayArena020E4.Arena cap) (j : Fin cap) (v : Node cap) :
    Program (image hc a) (image hc {a with bank:=write a.bank j v}) :=
  PairPatch020E5.first (bank (nodeCodec cap hc) cap) (tailCodec cap hc) (a.stack,(a.used,a.sp))
    (cell (nodeCodec cap hc) a.bank j v)

def stack {cap : Nat} (hc : cap<2^511) (a : ArrayArena020E4.Arena cap) (j : Fin cap) (v : Ptr cap) :
    Program (image hc a) (image hc {a with stack:=write a.stack j v}) :=
  PairPatch020E5.second (bank (nodeCodec cap hc) cap) (tailCodec cap hc) a.bank
    (PairPatch020E5.first (bank (finCodec (cap+1) (by omega)) cap)
      (pair (finCodec (cap+1) (by omega)) (finCodec (cap+1) (by omega))) (a.used,a.sp)
      (cell (finCodec (cap+1) (by omega)) a.stack j v))

def pointers {cap : Nat} (hc : cap<2^511) (a : ArrayArena020E4.Arena cap) (u s : Ptr cap) :
    Program (image hc a) (image hc {a with used:=u,sp:=s}) :=
  PairPatch020E5.second (bank (nodeCodec cap hc) cap) (tailCodec cap hc) a.bank
    (PairPatch020E5.second (bank (finCodec (cap+1) (by omega)) cap)
      (pair (finCodec (cap+1) (by omega)) (finCodec (cap+1) (by omega))) a.stack
      (overwrite (pack (pair (finCodec (cap+1) (by omega)) (finCodec (cap+1) (by omega))) (a.used,a.sp))
        (pack (pair (finCodec (cap+1) (by omega)) (finCodec (cap+1) (by omega))) (u,s))))

def commit {cap : Nat} (hc : cap<2^511) (a : ArrayArena020E4.Arena cap) (c : ParserDecision020E5.Change cap) :
    Program (image hc a) (image hc (ParserDecision020E5.apply a c)) :=
  thenDo (nodes hc a c.nodeSite c.node)
    (thenDo (stack hc {a with bank:=write a.bank c.nodeSite c.node} c.stackSite c.pushed)
      (pointers hc {a with bank:=write a.bank c.nodeSite c.node,stack:=write a.stack c.stackSite c.pushed} c.used c.sp))

theorem commit_length {cap : Nat} (hc : cap<2^511) (a : ArrayArena020E4.Arena cap) (c : ParserDecision020E5.Change cap) :
    (commit hc a c).code.length=8 := by
  simp only [commit,thenDo,nodes,stack,pointers,PairPatch020E5.first,PairPatch020E5.second,
    WordJoin020E5.liftLeft,WordJoin020E5.liftRight,cell,overwrite]
  simp only [List.length_append,List.length_map,List.length_ofFn]

end FT1536.S05.ParserEncoding020E5
