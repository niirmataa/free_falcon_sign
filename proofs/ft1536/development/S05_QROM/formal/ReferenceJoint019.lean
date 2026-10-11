import JointInterface019
import FT1536.Model

/- The ideal full response law is shared: challenge plus reply, including
   every modeled failure. Source Sign equality is not asserted here. -/
namespace FT1536.S05.ReferenceJoint019
open FT1536.Relation FT1536.PublicSimulation JointInterface019
abbrev Reply := Option BoxVec
noncomputable def honestReply (h c : Rq) : Law Reply := signBody (SigmaMath.syndrome h) c
noncomputable def reference (h : Rq) : Law (Rq×Reply) := SigmaMath.freshHonest h

theorem reference_joint (h : Rq) :
    reference h=Divergence.joint (Law.uniform : Law Rq) (honestReply h) := rfl

theorem reference_mass (h c : Rq) (o : Reply) :
    (reference h).mass (c,o)=(Law.uniform : Law Rq).mass c*(honestReply h c).mass o := rfl

theorem reference_marginal (h : Rq) : marginal (reference h)=(Law.uniform : Law Rq) :=
  marginal_joint _ _

theorem reference_normalized (h : Rq) : ∑ z,(reference h).mass z=1 := (reference h).total

#print axioms reference_joint
#print axioms reference_mass
#print axioms reference_marginal
#print axioms reference_normalized
end FT1536.S05.ReferenceJoint019
