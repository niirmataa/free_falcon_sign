import BoundedStack020E3
import NodeFrames020E2
import ValueBank020E3
import ArenaWords020E1

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.BankStorage020E3
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 BoundedStack020E3

def valueWords : Option Word → Fin 2 → Word
  | none,_ => 0
  | some w,k => if k.val=0 then 1 else w

theorem value_injective : Function.Injective valueWords := by
  intro a b h
  cases a with
  | none =>
    cases b with
    | none => rfl
    | some w => have ht := congrFun h (0 : Fin 2);change (0 : Word)=1 at ht;cases ht
  | some w =>
    cases b with
    | none => have ht := congrFun h (0 : Fin 2);change (1 : Word)=0 at ht;cases ht
    | some z => exact congrArg some (congrFun h (1 : Fin 2))

def frameWords {cap : Nat} : Frame cap → Fin 3 → Word
  | .run p,k => match k.val with | 0 => 0 | 1 => ArenaWords020E1.ptrWord p | _ => 0
  | .again p n,k => match k.val with | 0 => 1 | 1 => ArenaWords020E1.ptrWord p | _ => word (n.val:Int)

theorem count_exact (n : Count) : (word (n.val:Int)).toInt=n.val :=
  InputLayout020.nat_word_exact n.val n.isLt

theorem frame_injective {cap : Nat} (hcap : cap<2^511) : Function.Injective (@frameWords cap) := by
  intro a b h
  cases a with
  | run p =>
    cases b with
    | run q => exact congrArg Frame.run (ArenaWords020E1.ptr_word_injective hcap (congrFun h (1 : Fin 3)))
    | again q n => have ht := congrFun h (0 : Fin 3);change (0 : Word)=1 at ht;cases ht
  | again p n =>
    cases b with
    | run q => have ht := congrFun h (0 : Fin 3);change (1 : Word)=0 at ht;cases ht
    | again q m =>
      have hp : p=q := ArenaWords020E1.ptr_word_injective hcap (congrFun h (1 : Fin 3))
      have hn := congrArg (fun w : Word => w.toInt) (congrFun h (2 : Fin 3))
      change (word (n.val:Int)).toInt=(word (m.val:Int)).toInt at hn
      rw [count_exact,count_exact] at hn
      have he : n=m := Fin.ext (by exact_mod_cast hn)
      rw [hp,he]

def packValues {cap : Nat} (v : ValueBank020E3.Values cap) : Fin cap → Fin 2 → Word :=
  fun j => valueWords (v j)

theorem values_injective {cap : Nat} : Function.Injective (@packValues cap) := by
  intro a b h
  funext j
  exact value_injective (congrFun h j)

def packFrames {cap capacity : Nat} (st : Stack (Frame cap) capacity) :
    (Fin capacity → Fin 3 → Word) × Word :=
  (fun j => frameWords (st.bank j),ArenaWords020E1.ptrWord st.sp)

theorem frames_injective {cap capacity : Nat} (hc : cap<2^511) (hs : capacity<2^511) :
    Function.Injective (@packFrames cap capacity) := by
  intro a b h
  have hb : a.bank=b.bank := by
    funext j
    exact frame_injective hc (congrFun (congrArg Prod.fst h) j)
  have hp : a.sp=b.sp := ArenaWords020E1.ptr_word_injective hs (congrArg Prod.snd h)
  cases a;cases b;simp_all

/-- Encoded persistent control/value banks only. Code arena, core state,
    scan indices, temporary prefixes and physical runtime peak are separate. -/
def bankWords (nodes frames : Nat) : Nat := 2*nodes+3*frames+1

theorem actual_bank_words : bankWords 877 28941=88578 := by decide +kernel

theorem actual_frames_injective : Function.Injective (@packFrames 877 28941) :=
  frames_injective (by norm_num) (by norm_num)

end FT1536.S05.BankStorage020E3
