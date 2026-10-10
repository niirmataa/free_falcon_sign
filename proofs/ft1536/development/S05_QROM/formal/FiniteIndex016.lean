import FiniteLaw016

/- Explicit transport of finite enumeration choices. Probabilities do not
   depend on how the same finite type is enumerated. -/
namespace FT1536.S05.FiniteIndex016

theorem uniform_map_irrel {A B : Type} (I J : Fintype A) [Nonempty A]
    [Fintype B] [DecidableEq B] (f : A → B) :
    (@Law.map A B I _ _ (@Law.uniform A I _) f)=
      (@Law.map A B J _ _ (@Law.uniform A J _) f) := by
  cases Subsingleton.elim I J
  rfl

#print axioms uniform_map_irrel
end FT1536.S05.FiniteIndex016
