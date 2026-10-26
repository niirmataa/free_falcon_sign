import Source3.CrtMulCall213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCoefficientState214
open C99ArrayReference (State Name)
open CrtState205 (set32)
open CrtRoundShape205 (coeffNames)

def quotient (W : Nat → BitVec 32) (n : Nat) (p pi r2 : BitVec 32) := ZintReduceWhole209.resultWord W n p pi r2
 def correctionWord (W : Nat → BitVec 32) (n : Nat) (p pi r2 c : BitVec 32) :=
  KeygenModpWord.montgomery c (KeygenModpAddSub.result .sub (W n) (quotient W n p pi r2) p) p pi
 def words (W T : Nat → BitVec 32) (n : Nat) (p pi r2 c : BitVec 32) :=
  ZintAddMulWhole213.words W T (correctionWord W n p pi r2 c) n
 def declared (s : State) := CrtCoefficient205.declared s
 def withXp (s : State) (W : Nat → BitVec 32) (n : Nat) := set32 (declared s) "xp" (W n)
 def withXq (s : State) (W : Nat → BitVec 32) (n : Nat) (p pi r2 : BitVec 32) := set32 (withXp s W n) "xq" (quotient W n p pi r2)
 def beforeWrite (s : State) (W : Nat → BitVec 32) (n : Nat) (p pi r2 c : BitVec 32) :=
  set32 (withXq s W n p pi r2) "xr" (correctionWord W n p pi r2 c)

theorem declared_outside (s : State) (name : Name) (absent : name∉coeffNames) :
    (declared s).locals name=s.locals name := CrtCoefficient205.declared_outside s name absent

theorem before_outside (s : State) (W : Nat → BitVec 32) (n : Nat) (p pi r2 c : BitVec 32) (name : Name) (absent : name∉coeffNames) :
    (beforeWrite s W n p pi r2 c).locals name=s.locals name := by
  have ne (key : Name) (member : key∈coeffNames) : name≠key := by intro eq; apply absent; rw [eq]; exact member
  exact (SelectedStepAddPrime195.locals_keep (withXq s W n p pi r2) "xr".toList .uint32 (.uint32 (correctionWord W n p pi r2 c)) name (ne _ (by decide))).trans
    ((SelectedStepAddPrime195.locals_keep (withXp s W n) "xq".toList .uint32 (.uint32 (quotient W n p pi r2)) name (ne _ (by decide))).trans
      ((SelectedStepAddPrime195.locals_keep (declared s) "xp".toList .uint32 (.uint32 (W n)) name (ne _ (by decide))).trans (declared_outside s name absent)))

end FT1536.Source3.CrtCoefficientState214
