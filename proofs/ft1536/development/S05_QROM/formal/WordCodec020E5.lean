import BankWordLayout020E5
import BankStorage020E3

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.WordCodec020E5
open WordRAM020

structure Codec (A : Type) (n : Nat) where
  encode : A → Fin n → Word
  injective : Function.Injective encode

def unit : Codec Unit 0 := ⟨fun _ _ => 0,by intro a b h;cases a;cases b;rfl⟩
def wordCodec : Codec Word 1 := ⟨fun w _ => w,by intro a b h;exact congrFun h 0⟩
def boolWord (b : Bool) : Word := if b then 1 else 0

def boolCodec : Codec Bool 1 := ⟨fun b _ => boolWord b,by
  intro a b h
  have he := congrFun h 0
  cases a <;> cases b <;> first | rfl | cases he⟩

def finCodec (n : Nat) (hn : n≤2^511) : Codec (Fin n) 1 := ⟨fun k _ => word k.val,by
  intro a b h
  have he := congrArg (fun w : Word => w.toInt) (congrFun h 0)
  have ha := InputLayout020.nat_word_exact a.val (lt_of_lt_of_le a.isLt hn)
  have hb := InputLayout020.nat_word_exact b.val (lt_of_lt_of_le b.isLt hn)
  rw [ha,hb] at he
  exact Fin.ext (by exact_mod_cast he)⟩

def pair {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n) : Codec (A × B) (m+n) where
  encode x := Fin.addCases (a.encode x.1) (b.encode x.2)
  injective := by
    intro x y h
    apply Prod.ext
    · apply a.injective
      funext j
      simpa only [Fin.addCases_left] using congrFun h (Fin.castAdd n j)
    · apply b.injective
      funext j
      simpa only [Fin.addCases_right] using congrFun h (Fin.natAdd m j)

/-- Tagged sum, conservatively reserving both payload slots. -/
def sumEncode {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n) : A ⊕ B → Fin (1+(m+n)) → Word
  | .inl x => Fin.addCases (fun _ => 0) (Fin.addCases (a.encode x) (fun _ => 0))
  | .inr y => Fin.addCases (fun _ => 1) (Fin.addCases (fun _ => 0) (b.encode y))

def sum {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n) : Codec (A ⊕ B) (1+(m+n)) where
  encode := sumEncode a b
  injective := by
    intro x y h
    cases x with
    | inl x =>
      cases y with
      | inl y =>
        apply congrArg Sum.inl
        apply a.injective
        funext j
        simpa only [sumEncode,Fin.addCases_left,Fin.addCases_right] using congrFun h (Fin.natAdd 1 (Fin.castAdd n j))
      | inr y => have he := congrFun h (0 : Fin (1+(m+n)));change (0 : Word)=1 at he;cases he
    | inr x =>
      cases y with
      | inl y => have he := congrFun h (0 : Fin (1+(m+n)));change (1 : Word)=0 at he;cases he
      | inr y =>
        apply congrArg Sum.inr
        apply b.injective
        funext j
        simpa only [sumEncode,Fin.addCases_right] using congrFun h (Fin.natAdd 1 (Fin.natAdd m j))

def contramap {A B : Type} {n : Nat} (c : Codec B n) (f : A → B) (hf : Function.Injective f) : Codec A n :=
  ⟨fun a => c.encode (f a),fun _ _ h => hf (c.injective h)⟩

def bank {A : Type} {w : Nat} (c : Codec A w) (n : Nat) : Codec (ArrayBank020E4.Bank A n) (n*w) :=
  ⟨fun a => ArrayBank020E4.read (BankWordLayout020E5.encode c.encode a),by
    intro a b h
    apply BankWordLayout020E5.injective c.encode c.injective
    exact ArrayBank020E4.ext _ _ h⟩

end FT1536.S05.WordCodec020E5
