import VerifiedPatch020E5

namespace FT1536.S05.PairPatch020E5
open WordRAM020 WordCodec020E5 VerifiedPatch020E5

/-- The unchanged component is used only by the proof. Runtime code only
    adjusts the addresses of the existing store list. -/
def first {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n)
    {x y : A} (z : B) (p : Program (pack a x) (pack a y)) :
    Program (pack (pair a b) (x,z)) (pack (pair a b) (y,z)) :=
  ⟨WordJoin020E5.liftLeft n p.code,by rw [pack_pair,pack_pair,WordJoin020E5.apply_left,p.correct]⟩

def second {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n)
    (z : A) {x y : B} (p : Program (pack b x) (pack b y)) :
    Program (pack (pair a b) (z,x)) (pack (pair a b) (z,y)) :=
  ⟨WordJoin020E5.liftRight m p.code,by rw [pack_pair,pack_pair,WordJoin020E5.apply_right,p.correct]⟩

theorem first_length {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n)
    {x y : A} (z : B) (p : Program (pack a x) (pack a y)) :
    (first a b z p).code.length=p.code.length := by simp [first,WordJoin020E5.liftLeft]

theorem second_length {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n)
    (z : A) {x y : B} (p : Program (pack b x) (pack b y)) :
    (second a b z p).code.length=p.code.length := by simp [second,WordJoin020E5.liftRight]

theorem then_length {n : Nat} {a b c : ArrayBank020E4.Bank Word n} (p : Program a b) (q : Program b c) :
    (thenDo p q).code.length=p.code.length+q.code.length := List.length_append

end FT1536.S05.PairPatch020E5
