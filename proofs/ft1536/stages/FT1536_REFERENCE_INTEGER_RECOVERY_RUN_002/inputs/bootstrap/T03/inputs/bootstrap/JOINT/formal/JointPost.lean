import JointResource
import SourceBytes
import RintRefinement
namespace OrderedJoint
inductive Tagged (A : Type) | live : A→Tagged A | exit : Nat→List Int→Int→Tagged A
def push {A B : Type} (f : A→B) : Tagged A→Tagged B
  | .live a=>.live (f a)
  | .exit i h y=>.exit i h y
theorem exit_preserved {A B : Type} (f : A→B) (i : Nat) (h : List Int) (y : Int) :
    push f (.exit i h y)=.exit i h y := by rfl
def bad {A : Type} (f : A→(Fin 1536→Int)×(Fin 1536→Int)) : Tagged A→Prop
  | .live a=>Postprocess.BadPrecast (f a).1 (f a).2
  | .exit _ _ _=>False
theorem joint_bad_exact {A : Type} (f : A→(Fin 1536→Int)×(Fin 1536→Int)) (a : A) :
    bad f (.live a)↔¬Postprocess.Safe16 (f a).1 (f a).2 := by rfl
theorem exit_not_bad {A : Type} (f : A→(Fin 1536→Int)×(Fin 1536→Int)) (i : Nat) (h : List Int) (y : Int) :
    ¬bad f (.exit i h y) := by simp [bad]
theorem event_variance (q d : Int) : (d*(1-q))^2*q+(-d*q)^2*(1-q)=d^2*q*(1-q) := by grind
theorem marginal_transfer (p q loss : Int) (h : -loss≤p-q ∧ p-q≤loss) : p≤q+loss := by omega
end OrderedJoint
