import CostRun020E4

namespace FT1536.S05.CostPipeline020E4
open CostRun020E4

def run {A B C : Type} (f : A → B → Run C) (a : Run A) (b : Run B) : Run C :=
  CostRun020E4.bind a (fun x => CostRun020E4.bind b (f x))

theorem value {A B C D : Type} (f : A → B → Run C) (g : A → B → D) (observe : C → D)
    (hf : ∀ x y,observe (f x y).value=g x y) (a : Run A) (b : Run B)
    (x : A) (y : B) (ha : a.value=x) (hb : b.value=y) :
    observe (run f a b).value=g x y := by
  simp only [run,CostRun020E4.bind_value,hf,ha,hb]

theorem bound {A B C : Type} (f : A → B → Run C) (a : Run A) (b : Run B)
    (t m u v z w : Nat) (ha : Bounded a t m) (hb : Bounded b u v)
    (hf : ∀ x y,Bounded (f x y) z w) : Bounded (run f a b) (t+(u+z)) (m+(v+w)) :=
  bind_bound a _ t m (u+z) (v+w) ha (fun x => bind_bound b (f x) u v z w hb (hf x))

end FT1536.S05.CostPipeline020E4
