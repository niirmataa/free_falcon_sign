import Norm64
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global
open FT1536Composition (product subtract)
open FT1536Forward (rhoVec)

-- Raw receives the already prepared public-key buffer, not polynomial h.
def prepareKey (h : Vec) : Vec := toMontC (forwardC h)
def rawBefore (H c s : Vec) : Vec :=
  subtractC (inverseC (montPointC (forwardC (rhoVec s)) H)) c
def rawFirst (H c s : Vec) : Vec := centerLoop (rawBefore H c s)
def rawVerify (H c s : Vec) : Bool := isShort (rawFirst H c s) s
def Ext0Words (h c s : Vec) : Vec × Vec :=
  ((fun i => FT1536.center (c i-product h s i)),s)
def Congruent (h c : Vec) (z : Vec × Vec) : Prop :=
  ∀ i, (z.1 i+product h z.2 i-c i)%18433=0

theorem raw_before_eq (h c s : Vec) (hh : CanonVec h) (hc : CanonVec c) (hs : SignedVec s) :
    rawBefore (prepareKey h) c s=subtract (product h s) c := by
  have hntt:=FT1536Forward.L_NTT_rho h s c hh hs hc
  exact congrArg Prod.snd hntt

theorem raw_signed (H c s : Vec) : SignedVec (rawFirst H c s) := by
  intro i
  exact s16_range _
theorem extract_signed (h c s : Vec) : SignedVec (Ext0Words h c s).1 := by
  intro i
  have hr:=center_range (c i-product h s i)
  change -32768≤FT1536.center (c i-product h s i) ∧ FT1536.center (c i-product h s i)≤32767
  omega

theorem SIGN_BRIDGE (h c s : Vec) (hh : CanonVec h) (hc : CanonVec c) (hs : SignedVec s) :
    rawFirst (prepareKey h) c s=negVec (Ext0Words h c s).1 := by
  have hbefore:=raw_before_eq h c s hh hc hs
  have hr : CanonVec (rawBefore (prepareKey h) c s) := by rw [hbefore];exact FT1536Forward.subtract_range _ _
  unfold rawFirst
  rw [center_loop_correct _ hr,hbefore]
  funext i
  change FT1536.center ((product h s i-c i)%18433)= -FT1536.center (c i-product h s i)
  rw [center_mod]
  have he : product h s i-c i= -(c i-product h s i) := by omega
  rw [he,FT1536.center_antisymmetric]

theorem extract_congruence (h c s : Vec) : Congruent h c (Ext0Words h c s) := by
  intro i
  have h:=center_congruence (c i-product h s i)
  change (FT1536.center (c i-product h s i)+product h s i-c i)%18433=0
  omega

theorem RAW_VERIFIER_SOUND (h c s : Vec) (hh : CanonVec h) (hc : CanonVec c) (hs : SignedVec s)
    (accept : rawVerify (prepareKey h) c s=true) :
    SignedVec (Ext0Words h c s).1 ∧ Congruent h c (Ext0Words h c s) ∧
    Q (Ext0Words h c s).1 (Ext0Words h c s).2<2093922385 := by
  have hn:=(STRICT_B (rawFirst (prepareKey h) c s) s (raw_signed _ _ _) hs).mp accept
  rw [SIGN_BRIDGE h c s hh hc hs] at hn
  refine ⟨extract_signed h c s,extract_congruence h c s,?_⟩
  simpa only [Q,Q0_neg] using hn

theorem raw_reject_at_bound (H c s : Vec) (hs : SignedVec s)
    (he : Q (rawFirst H c s) s=2093922385) : rawVerify H c s=false := by
  have h:=(STRICT_B (rawFirst H c s) s (raw_signed _ _ _) hs)
  unfold rawVerify
  cases hret : isShort (rawFirst H c s) s
  · rfl
  · have bad:=h.mp hret
    omega

#check @RAW_VERIFIER_SOUND
#print RAW_VERIFIER_SOUND
#print axioms raw_before_eq
#print axioms raw_signed
#print axioms extract_signed
#print axioms SIGN_BRIDGE
#print axioms extract_congruence
#print axioms RAW_VERIFIER_SOUND
#print axioms raw_reject_at_bound
end FT1536Bridge
