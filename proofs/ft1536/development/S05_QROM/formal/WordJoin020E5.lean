import WordPatch020E5

namespace FT1536.S05.WordJoin020E5
open WordRAM020 ArrayBank020E4

def join {m n : Nat} (a : Bank Word m) (b : Bank Word n) : Bank Word (m+n) :=
  load (Fin.addCases (read a) (read b))

theorem left_read {m n : Nat} (a : Bank Word m) (b : Bank Word n) (j : Fin m) :
    read (join a b) (Fin.castAdd n j)=read a j := by simp only [join,read_load,Fin.addCases_left]

theorem right_read {m n : Nat} (a : Bank Word m) (b : Bank Word n) (j : Fin n) :
    read (join a b) (Fin.natAdd m j)=read b j := by simp only [join,read_load,Fin.addCases_right]

theorem left_write {m n : Nat} (a : Bank Word m) (b : Bank Word n) (j : Fin m) (v : Word) :
    write (join a b) (Fin.castAdd n j) v=join (write a j v) b := by
  apply ArrayBank020E4.ext
  funext k
  refine Fin.addCases ?_ ?_ k
  · intro x
    rw [read_write,left_read,read_write]
    by_cases h : x=j
    · subst x;simp
    · simp [Function.update,h,Fin.castAdd_inj,left_read]
  · intro x
    rw [read_write,right_read]
    have hn : Fin.natAdd m x≠Fin.castAdd n j := by intro e;have hv:=congrArg Fin.val e;dsimp at hv;have := j.isLt;omega
    rw [Function.update_of_ne hn,right_read]

theorem right_write {m n : Nat} (a : Bank Word m) (b : Bank Word n) (j : Fin n) (v : Word) :
    write (join a b) (Fin.natAdd m j) v=join a (write b j v) := by
  apply ArrayBank020E4.ext
  funext k
  refine Fin.addCases ?_ ?_ k
  · intro x
    rw [read_write,left_read]
    have hn : Fin.castAdd n x≠Fin.natAdd m j := by intro e;have hv:=congrArg Fin.val e;dsimp at hv;have := x.isLt;omega
    rw [Function.update_of_ne hn,left_read]
  · intro x
    rw [read_write,right_read,read_write]
    by_cases h : x=j
    · subst x;simp
    · simp [Function.update,h,Fin.natAdd_inj,right_read]

def liftLeft {m : Nat} (n : Nat) (xs : List (WordPatch020E5.Write m)) : List (WordPatch020E5.Write (m+n)) :=
  xs.map (fun x => (Fin.castAdd n x.1,x.2))
def liftRight (m : Nat) {n : Nat} (xs : List (WordPatch020E5.Write n)) : List (WordPatch020E5.Write (m+n)) :=
  xs.map (fun x => (Fin.natAdd m x.1,x.2))

theorem apply_left {m n : Nat} (xs : List (WordPatch020E5.Write m)) (a : Bank Word m) (b : Bank Word n) :
    WordPatch020E5.apply (liftLeft n xs) (join a b)=join (WordPatch020E5.apply xs a) b := by
  induction xs generalizing a with
  | nil => rfl
  | cons x xs ih =>
    simp only [liftLeft,List.map_cons,WordPatch020E5.apply,left_write]
    exact ih (write a x.1 x.2)

theorem apply_right {m n : Nat} (xs : List (WordPatch020E5.Write n)) (a : Bank Word m) (b : Bank Word n) :
    WordPatch020E5.apply (liftRight m xs) (join a b)=join a (WordPatch020E5.apply xs b) := by
  induction xs generalizing b with
  | nil => rfl
  | cons x xs ih =>
    simp only [liftRight,List.map_cons,WordPatch020E5.apply,right_write]
    exact ih (write b x.1 x.2)

end FT1536.S05.WordJoin020E5
