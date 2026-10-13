import FillStore020E5

namespace FT1536.S05.WordTrace020E5
open WordRAM020 ArrayBank020E4 WordPatch020E5 WordJoin020E5

theorem append {n : Nat} {a b c : Bank Word n} {xs ys : List (Bank Word n)}
    (h : Stores a xs b) (g : Stores b ys c) : Stores a (xs++ys) c := by
  induction h with
  | nil a => exact g
  | cons j v tail ih => exact .cons j v (ih g)

theorem right {m n : Nat} (a : Bank Word m) {b c : Bank Word n} {hist : List (Bank Word n)}
    (h : Stores b hist c) : Stores (join a b) (hist.map (join a)) (join a c) := by
  induction h with
  | nil b => exact .nil _
  | @cons b c hist j v tail ih =>
    rw [←right_write] at ih
    simpa only [List.map_cons,right_write] using (Stores.cons (Fin.natAdd m j) v ih)

theorem left {m n : Nat} (b : Bank Word n) {a c : Bank Word m} {hist : List (Bank Word m)}
    (h : Stores a hist c) : Stores (join a b) (hist.map (fun q => join q b)) (join c b) := by
  induction h with
  | nil a => exact .nil _
  | @cons a c hist j v tail ih =>
    rw [←left_write] at ih
    simpa only [List.map_cons,left_write] using (Stores.cons (Fin.castAdd n j) v ih)

theorem fill {A : Type} {n w : Nat} (c : WordCodec020E5.Codec A w) (hn : n<2^511)
    (f : Fin n → A) (fuel : Nat) (q : FillMachine020E5.State A n) :
    ∃ hist,Stores (FillStore020E5.image c hn q) hist (FillStore020E5.image c hn (FillMachine020E5.run f fuel q)) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    obtain ⟨front,hf,_⟩ := has_trace (FillStore020E5.code c f q) (FillStore020E5.image c hn q)
    rw [FillStore020E5.realizes] at hf
    obtain ⟨tail,ht⟩ := ih (FillMachine020E5.step f q)
    exact ⟨front++tail,append hf ht⟩

end FT1536.S05.WordTrace020E5
