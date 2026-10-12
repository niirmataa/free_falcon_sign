import PairCorrect020B
import PairToVector020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.VectorValues020C
open WordRAM020 ReadSemantics020A PairProgram020 CdfPrefix020A
open PairCorrect020B PairCoordinate020B PairToVector020C VectorPrefix020C PairCompose020B
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState StandaloneRuntime019.pair

def decoded (z : StandaloneRuntime019.Block) : Int × Int :=
  ((z.1.val:Int)-65535,(z.2.val:Int)-65535)

/-- Specification aliases only; execution remains the original020 interpreter. -/
noncomputable def blocks (i : Input) (n p : Nat) : StandaloneRuntime019.Block :=
  StandaloneRuntime019.pair StandaloneRuntime019.tables (CapDraw020B.coins i n p)
noncomputable def values (i : Input) (n : Nat) : Values := fun p => decoded (blocks i n p)

theorem decoded_bounds (z : StandaloneRuntime019.Block) :
    (-65535≤(decoded z).1 ∧ (decoded z).1≤65535) ∧
    (-65535≤(decoded z).2 ∧ (decoded z).2≤65535) :=
  ⟨coordinate_bound z.1,coordinate_bound z.2⟩

theorem values_bounded (i : Input) (n : Nat) : Bounded (values i n) := by
  intro p _
  exact decoded_bounds (blocks i n p)

/-- Named-result boundary. Both equations will be filled in the actual step. -/
theorem step_of_result (h : Rq) (tape : Bits tapeSize) (n k : Nat)
    (v : Values) (s : State) (hn : n<196) (hk : k<1536) (hv : Bounded v)
    (good : Good v (nw n) k s) (z : StandaloneRuntime019.Block)
    (hz : z=StandaloneRuntime019.pair StandaloneRuntime019.tables
      (CapDraw020B.coins (InputLayout020.encode h tape) n k))
    (vz : v k=decoded z) :
    Good v (nw n) (k+1) (exec (InputLayout020.encode h tape) PairProgram020.pair s) ∧
      Stable s (exec (InputLayout020.encode h tape) PairProgram020.pair s) := by
  have post := pair_of_result h tape n ⟨k,hk⟩ s (total v k) hn
    (total_bound v hv k (by omega)) good.1 good.2.1 good.2.2.1 z hz
  have typed : PairPost s (exec (InputLayout020.encode h tape) PairProgram020.pair s)
      ⟨k,hk⟩ (total v k) (v k).1 (v k).2 := by
    rw [vz]
    exact post
  exact extend v (nw n) ⟨k,hk⟩ s _ good typed

theorem actual_step (h : Rq) (tape : Bits tapeSize) (n k : Nat) (s : State)
    (hn : n<196) (hk : k<1536)
    (good : Good (values (InputLayout020.encode h tape) n) (nw n) k s) :
    Good (values (InputLayout020.encode h tape) n) (nw n) (k+1)
      (exec (InputLayout020.encode h tape) PairProgram020.pair s) ∧
    Stable s (exec (InputLayout020.encode h tape) PairProgram020.pair s) :=
  step_of_result h tape n k _ s hn hk (values_bounded _ n) good
    (blocks (InputLayout020.encode h tape) n k) rfl rfl

end FT1536.S05.VectorValues020C
