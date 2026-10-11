import PairCompose020B
import PairCoordinate020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairCorrect020B
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A TrialCorrect020A
open PairArithmetic020B PairStores020B PairAdvance020B CapDraw020B
open PairShape020B PairCompose020B PairCoordinate020B
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState StandaloneRuntime019.pair StandaloneRuntime019.first

/-- Result-name boundary: keeps concrete table evaluation out of unification.
    The equality premise is discharged by reflexivity in pair_correct below. -/
theorem pair_of_result (h : Rq) (tape : Bits tapeSize) (n : Nat) (p : Fin 1536)
    (s : State) (a : Int) (hn : n<196)
    (ha : 0≤a ∧ a≤(p.val:Int)*(3*65535^2))
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p.val) (h16 : s.reg 16=word a)
    (z : StandaloneRuntime019.Block)
    (hz : z=StandaloneRuntime019.pair StandaloneRuntime019.tables
      (coins (InputLayout020.encode h tape) n p.val)) :
    PairPost s (exec (InputLayout020.encode h tape) PairProgram020.pair s) p a
      ((z.1.val:Int)-65535) ((z.2.val:Int)-65535) := by
  have d := draw_correct h tape n p.val s hn p.isLt h0 h1
  have dz : ((exec (InputLayout020.encode h tape) draw s).reg 13,
      (exec (InputLayout020.encode h tape) draw s).reg 14)=encoded z :=
    d.1.trans (congrArg encoded hz.symm)
  have ex : (exec (InputLayout020.encode h tape) draw s).reg 13=word ((z.1.val:Int)-65535) :=
    congrArg Prod.fst dz
  have ey : (exec (InputLayout020.encode h tape) draw s).reg 14=word ((z.2.val:Int)-65535) :=
    congrArg Prod.snd dz
  exact compose (InputLayout020.encode h tape) s p a ((z.1.val:Int)-65535) ((z.2.val:Int)-65535)
    ha (coordinate_bound z.1) (coordinate_bound z.2) ex ey
    ((d.2.2 1 (by decide) (by decide)).trans h1)
    ((d.2.2 16 (by decide) (by decide)).trans h16) d.2.1 d.2.2

/-- FILLED whole-pair postcondition, including cap exhaustion and every tape.
    Only valid indices and the incoming exact accumulator invariant are inputs. -/
theorem pair_correct (h : Rq) (tape : Bits tapeSize) (n : Nat) (p : Fin 1536)
    (s : State) (a : Int) (hn : n<196)
    (ha : 0≤a ∧ a≤(p.val:Int)*(3*65535^2))
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p.val) (h16 : s.reg 16=word a) :
    let i := InputLayout020.encode h tape
    let z := StandaloneRuntime019.pair StandaloneRuntime019.tables (coins i n p.val)
    PairPost s (exec i PairProgram020.pair s) p a ((z.1.val:Int)-65535) ((z.2.val:Int)-65535) :=
  pair_of_result h tape n p s a hn ha h0 h1 h16 _ rfl

end FT1536.S05.PairCorrect020B
