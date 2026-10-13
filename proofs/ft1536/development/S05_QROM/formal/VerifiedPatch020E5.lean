import WordJoin020E5
import WordCodec020E5

namespace FT1536.S05.VerifiedPatch020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5

structure Program {n : Nat} (before after : Bank Word n) where
  code : List (WordPatch020E5.Write n)
  correct : WordPatch020E5.apply code before=after

def pack {A : Type} {n : Nat} (c : Codec A n) (a : A) : Bank Word n := load (c.encode a)

theorem pack_read {A : Type} {n : Nat} (c : Codec A n) (a : A) : read (pack c a)=c.encode a := read_load _

theorem append_apply {n : Nat} (xs ys : List (WordPatch020E5.Write n)) (a : Bank Word n) :
    WordPatch020E5.apply (xs++ys) a=WordPatch020E5.apply ys (WordPatch020E5.apply xs a) := by
  induction xs generalizing a with
  | nil => rfl
  | cons x xs ih => exact ih (write a x.1 x.2)

def identity {n : Nat} (a : Bank Word n) : Program a a := ⟨[],rfl⟩
def ofEq {n : Nat} {a b : Bank Word n} (h : a=b) : Program a b := ⟨[],h⟩
def thenDo {n : Nat} {a b c : Bank Word n} (p : Program a b) (q : Program b c) : Program a c :=
  ⟨p.code++q.code,by rw [append_apply,p.correct,q.correct]⟩

def overwrite {n : Nat} (a b : Bank Word n) : Program a b where
  code := List.ofFn (fun j : Fin n => (j,read b j))
  correct := by
    apply WordPatch020E5.realizes
    · intro x hx
      obtain ⟨j,rfl⟩ := List.mem_ofFn.mp hx
      rfl
    · intro j hj
      exfalso
      exact hj (j,read b j) (List.mem_ofFn.mpr ⟨j,rfl⟩) rfl

theorem overwrite_length {n : Nat} (a b : Bank Word n) : (overwrite a b).code.length=n := List.length_ofFn

def left {m n : Nat} {a b : Bank Word m} (p : Program a b) (c : Bank Word n) :
    Program (WordJoin020E5.join a c) (WordJoin020E5.join b c) :=
  ⟨WordJoin020E5.liftLeft n p.code,by rw [WordJoin020E5.apply_left,p.correct]⟩

def right {m n : Nat} (c : Bank Word m) {a b : Bank Word n} (p : Program a b) :
    Program (WordJoin020E5.join c a) (WordJoin020E5.join c b) :=
  ⟨WordJoin020E5.liftRight m p.code,by rw [WordJoin020E5.apply_right,p.correct]⟩

theorem pack_pair {A B : Type} {m n : Nat} (a : Codec A m) (b : Codec B n) (x : A) (y : B) :
    pack (pair a b) (x,y)=WordJoin020E5.join (pack a x) (pack b y) := by
  apply ArrayBank020E4.ext
  simp only [pack,read_load,WordJoin020E5.join,WordCodec020E5.pair]

theorem pack_bank {A : Type} {n w : Nat} (c : Codec A w) (a : Bank A n) :
    pack (bank c n) a=BankWordLayout020E5.encode c.encode a := load_read _

def cell {A : Type} {n w : Nat} (c : Codec A w) (a : Bank A n) (k : Fin n) (v : A) :
    Program (pack (bank c n) a) (pack (bank c n) (write a k v)) where
  code := List.ofFn (fun j : Fin w => (finProdFinEquiv (k,j),c.encode v j))
  correct := by
    apply WordPatch020E5.realizes
    · intro x hx
      obtain ⟨j,rfl⟩ := List.mem_ofFn.mp hx
      simp only [pack_bank,BankWordLayout020E5.updated_at,ite_true]
    · intro p hp
      obtain ⟨⟨r,j⟩,rfl⟩ := (finProdFinEquiv : Fin n × Fin w ≃ Fin (n*w)).surjective p
      by_cases h : r=k
      · subst r
        exfalso
        exact hp (finProdFinEquiv (k,j),c.encode v j) (List.mem_ofFn.mpr ⟨j,rfl⟩) rfl
      · simp only [pack_bank,BankWordLayout020E5.updated_at,h,ite_false]

theorem cell_length {A : Type} {n w : Nat} (c : Codec A w) (a : Bank A n) (k : Fin n) (v : A) :
    (cell c a k v).code.length=w := List.length_ofFn

end FT1536.S05.VerifiedPatch020E5
