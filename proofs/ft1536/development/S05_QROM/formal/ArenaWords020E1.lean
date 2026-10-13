import ArenaTypes020E1
import InputLayout020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ArenaWords020E1
open WordRAM020 ArenaTypes020E1

def ptrWord {cap : Nat} (p : Ptr cap) : Word := word (p.val:Int)

theorem ptr_word_exact {cap : Nat} (hc : cap<2^511) (p : Ptr cap) : (ptrWord p).toInt=p.val :=
  InputLayout020.nat_word_exact _ (by have := p.isLt;omega)

theorem ptr_word_injective {cap : Nat} (hc : cap<2^511) : Function.Injective (@ptrWord cap) := by
  intro a b h
  have he := congrArg (fun w : Word => w.toInt) h
  rw [ptr_word_exact hc a,ptr_word_exact hc b] at he
  apply Fin.ext
  exact_mod_cast he

/-- Five words: padded tag, payload and three child slots. Unused child slots
    are still represented; only active children enter the earlier-node invariant. -/
def nodeWords {cap : Nat} (n : Node cap) (j : Fin 5) : Word := match j.val with
  | 0 => word (n.cell.1.val:Int)
  | 1 => n.cell.2
  | 2 => ptrWord n.first
  | 3 => ptrWord n.second
  | _ => ptrWord n.third

theorem tag_exact (t : Fin 16) : (word (t.val:Int)).toInt=t.val :=
  InputLayout020.nat_word_exact _ (lt_trans t.isLt (by norm_num))

theorem node_words_injective {cap : Nat} (hc : cap<2^511) : Function.Injective (@nodeWords cap) := by
  intro a b h
  have ht := congrArg (fun w : Word => w.toInt) (congrFun h (0:Fin 5))
  change (word (a.cell.1.val:Int)).toInt=(word (b.cell.1.val:Int)).toInt at ht
  rw [tag_exact,tag_exact] at ht
  have htag : a.cell.1=b.cell.1 := Fin.ext (by exact_mod_cast ht)
  have hp : a.cell.2=b.cell.2 := congrFun h (1:Fin 5)
  have hcell : a.cell=b.cell := Prod.ext htag hp
  have h1 : a.first=b.first := ptr_word_injective hc (congrFun h (2:Fin 5))
  have h2 : a.second=b.second := ptr_word_injective hc (congrFun h (3:Fin 5))
  have h3 : a.third=b.third := ptr_word_injective hc (congrFun h (4:Fin 5))
  cases a;cases b
  simp_all

structure Packed (cap : Nat) where
  nodes : Fin cap → Fin 5 → Word
  stack : Fin cap → Word
  used : Word
  sp : Word

def pack {cap : Nat} (s : Arena cap) : Packed cap :=
  ⟨fun k => nodeWords (s.bank k),fun k => ptrWord (s.stack k),ptrWord s.used,ptrWord s.sp⟩

theorem pack_injective {cap : Nat} (hc : cap<2^511) : Function.Injective (@pack cap) := by
  intro a b h
  have hbank : a.bank=b.bank := by
    funext k
    exact node_words_injective hc (congrFun (congrArg Packed.nodes h) k)
  have hstack : a.stack=b.stack := by
    funext k
    exact ptr_word_injective hc (congrFun (congrArg Packed.stack h) k)
  have hu : a.used=b.used := ptr_word_injective hc (congrArg Packed.used h)
  have hs : a.sp=b.sp := ptr_word_injective hc (congrArg Packed.sp h)
  cases a;cases b
  simp_all

/-- Persistent encoded arena banks only. Input, scratch, recursive decoding,
    physical allocator and complete process peak/time are separate obligations. -/
def persistentWords (cap : Nat) : Nat := 5*cap+cap+2

theorem persistent_words877 : persistentWords 877=5264 := by decide +kernel

theorem actual_pack_injective : Function.Injective (@pack 877) := pack_injective (by norm_num)

end FT1536.S05.ArenaWords020E1
