import FT1536.PublicCode
import FT1536.Relation

namespace FT1536.SigmaMath
open PublicSimulation

abbrev Nonce := Fin (2^320)
abbrev Message := List (Fin 256)
noncomputable instance nonceFintype : Fintype Nonce := Fintype.ofFinite Nonce
noncomputable instance rqFintype : Fintype FT1536.Relation.Rq :=
  Fintype.ofFinite FT1536.Relation.Rq

noncomputable def syndrome (h : FT1536.Relation.Rq) (z : BoxPair) : FT1536.Relation.Rq :=
  FT1536.Relation.A h (decode z)

noncomputable def freshHonest (h : FT1536.Relation.Rq) := honestJoint (syndrome h)
noncomputable def freshPublic (h : FT1536.Relation.Rq) := publicJoint (syndrome h)

/- Exact E0 coefficient-valued finite-box-G16 law against a fixed oracle
function. The query's message is fixed before the uniform nonce is drawn. -/
noncomputable def sign (h : FT1536.Relation.Rq)
    (H : Nonce → Message → FT1536.Relation.Rq) (m : Message) :
    Law (MathSign.Observation Nonce BoxVec) :=
  Law.uniform.bind fun r => (signBody (syndrome h) (H r m)).map fun o => some (r,o)

theorem sign_normalized (h : FT1536.Relation.Rq)
    (H : Nonce → Message → FT1536.Relation.Rq) (m : Message) :
    ∑ o, (sign h H m).mass o = 1 := (sign h H m).total

/- The public key law is a marginal of one joint law, never a uniform key law.
This declaration does not identify it with successful source KeyGen. -/
noncomputable def muH {SK : Type} [Fintype SK]
    (muKey : Law (SK × FT1536.Relation.Rq)) : Law FT1536.Relation.Rq := muKey.map Prod.snd

theorem key_marginal_normalized {SK : Type} [Fintype SK]
    (muKey : Law (SK × FT1536.Relation.Rq)) : ∑ h, (muH muKey).mass h = 1 := (muH muKey).total

end FT1536.SigmaMath
