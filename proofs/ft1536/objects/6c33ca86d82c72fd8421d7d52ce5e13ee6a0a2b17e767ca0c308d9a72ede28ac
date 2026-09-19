import PublicKey
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global

def decodeSmall (comp : Nat) (d : Bytes) : Option (List Int × Nat) :=
  match comp with | 0 => decodeNone d | 1 => decodeStatic d | _ => none
def decodeSmallCode (comp : Nat) (d : Bytes) : Nat :=
  match decodeSmall comp d with | none => 0 | some (_,n) => n
theorem small_spec (comp : Nat) (d : Bytes) (vs : List Int) (n : Nat) (h : decodeSmall comp d=some (vs,n)) :
    vs.length=1536 ∧ (∀ x, x∈vs → FT1536.InInt16 x) ∧ 0<n ∧ n≤d.length := by
  cases comp with
  | zero =>
    have hs:=DECODE_NONE d vs n h
    exact ⟨hs.1,hs.2.1,by omega,hs.2.2.2⟩
  | succ c =>
    cases c with
    | zero =>
      have hs:=DECODE_STATIC d vs n h
      exact ⟨hs.1,hs.2.1,by omega,hs.2.2.2⟩
    | succ c => cases h
theorem decoder_return_guard (comp : Nat) (d : Bytes) (hlen : 0<d.length) :
    decodeSmallCode comp d=d.length ↔ ∃ vs, decodeSmall comp d=some (vs,d.length) := by
  unfold decodeSmallCode
  cases hd : decodeSmall comp d with
  | none => simp;omega
  | some pair =>
    rcases pair with ⟨vs,n⟩
    simp

def signature (b : Bytes) : Option (List Int) :=
  if b.length≤2 then none else
    match b with
    | [] => none
    | fb::d =>
      if (fb.val/16)%2≠0 then none else
      if fb.val%16≠10 then none else
      if fb.val/128≠1 then none else
      match decodeSmall ((fb.val/32)%4) d with
      | none => none
      | some (vs,n) => if n≠d.length then none else some vs

theorem header_exact : ∀ fb : Byte,
    ((fb.val/16)%2=0 ∧ fb.val%16=10 ∧ fb.val/128=1 ∧ (fb.val/32)%4≤1) ↔
      fb.val=138 ∨ fb.val=170 := by decide
theorem pk_header_exact : ∀ fb : Byte,
    ((fb.val/16)%8=0 ∧ fb.val%16=10 ∧ fb.val/128=1) ↔ fb.val=138 := by decide

theorem SIGNATURE_DECODE (b : Bytes) (vs : List Int) (h : signature b=some vs) :
    2<b.length ∧ vs.length=1536 ∧ (∀ x, x∈vs → FT1536.InInt16 x) := by
  unfold signature at h
  split at h
  · cases h
  · rename_i hlen
    cases b with
    | nil => cases h
    | cons fb d =>
      dsimp only at h
      split at h
      · cases h
      · split at h
        · cases h
        · split at h
          · cases h
          · cases hd : decodeSmall ((fb.val/32)%4) d with
            | none => simp only [hd] at h;cases h
            | some pair =>
              rcases pair with ⟨xs,n⟩
              simp only [hd] at h
              split at h
              · cases h
              · cases h
                have hs:=small_spec _ d vs n hd
                exact ⟨by omega,hs.1,hs.2.1⟩

def verifyContext (ctx : Option FTContext) (c : Vec) (b : Bytes) : Int :=
  match ctx with
  | none => -2
  | some key => match signature b with
    | none => -1
    | some xs => if rawVerify key.prepared c (listVec xs) then 1 else 0
def V_CAND (h c : Vec) (b : Bytes) : Int := verifyContext (some ⟨h,prepareKey h⟩) c b
def V_KEY_BYTES (pk : Bytes) (c : Vec) (b : Bytes) : Int := verifyContext (loadFT pk) c b
def decodeS (b : Bytes) : Option Vec := (signature b).map listVec
def Ext0 (h c : Vec) (b : Bytes) : Option (Vec × Vec) := (decodeS b).map (Ext0Words h c)
def LegalBytes (b : Bytes) : Prop := b.length<18446744073709551616
def APIBounds (b : Bytes) : Prop := ∀ i, i<b.length → i+1<18446744073709551616
theorem api_bounds (b : Bytes) (hb : LegalBytes b) : APIBounds b := by
  intro i hi; unfold LegalBytes at hb;omega

theorem context_accept (ctx : FTContext) (c : Vec) (b : Bytes) (h : verifyContext (some ctx) c b=1) :
    ∃ vs, signature b=some vs ∧ rawVerify ctx.prepared c (listVec vs)=true := by
  dsimp only [verifyContext] at h
  cases hs : signature b with
  | none => simp only [hs] at h;cases h
  | some vs =>
    simp only [hs] at h
    cases hr : rawVerify ctx.prepared c (listVec vs)
    · simp only [hr,↓reduceIte,Bool.false_eq_true] at h;cases h
    · exact ⟨vs,rfl,hr⟩

theorem L_V_BYTES (h c : Vec) (hh : CanonVec h) (hc : CanonVec c) (b : Bytes) (legal : LegalBytes b)
    (accept : V_CAND h c b=1) :
    APIBounds b ∧ ∃ s z, decodeS b=some s ∧ Ext0 h c b=some z ∧ z=Ext0Words h c s ∧
      SignedVec s ∧ SignedVec z.1 ∧ Congruent h c z ∧ Q z.1 z.2<2093922385 := by
  obtain ⟨vs,hdec,hraw⟩:=context_accept ⟨h,prepareKey h⟩ c b accept
  have hd:=SIGNATURE_DECODE b vs hdec
  have hs : SignedVec (listVec vs) := listVec_property FT1536.InInt16 vs hd.2.1 hd.2.2
  have hr:=RAW_VERIFIER_SOUND h c (listVec vs) hh hc hs hraw
  refine ⟨api_bounds b legal,listVec vs,Ext0Words h c (listVec vs),?_,?_,rfl,hs,hr.1,hr.2⟩
  · simp only [decodeS,hdec,Option.map_some]
  · simp only [Ext0,decodeS,hdec,Option.map_some]

theorem L_V_LOADED (pk b : Bytes) (c : Vec) (hc : CanonVec c) (pkLegal : LegalBytes pk)
    (sigLegal : LegalBytes b) (accept : V_KEY_BYTES pk c b=1) :
    APIBounds pk ∧ APIBounds b ∧ ∃ h s z, CanonVec h ∧ decodeS b=some s ∧ Ext0 h c b=some z ∧
      z=Ext0Words h c s ∧ SignedVec s ∧ SignedVec z.1 ∧ Congruent h c z ∧ Q z.1 z.2<2093922385 := by
  unfold V_KEY_BYTES at accept
  cases hp : loadFT pk with
  | none => simp only [hp,verifyContext] at accept;cases accept
  | some key =>
    rw [hp] at accept
    have hk:=PK_PREPARATION pk key hp
    obtain ⟨vs,hdec,hraw⟩:=context_accept key c b accept
    have hd:=SIGNATURE_DECODE b vs hdec
    have hs : SignedVec (listVec vs) := listVec_property FT1536.InInt16 vs hd.2.1 hd.2.2
    rw [hk.2] at hraw
    have hr:=RAW_VERIFIER_SOUND key.polynomial c (listVec vs) hk.1 hc hs hraw
    refine ⟨api_bounds pk pkLegal,api_bounds b sigLegal,key.polynomial,listVec vs,
      Ext0Words key.polynomial c (listVec vs),hk.1,?_,?_,rfl,hs,hr.1,hr.2⟩
    · simp only [decodeS,hdec,Option.map_some]
    · simp only [Ext0,decodeS,hdec,Option.map_some]

#check @SIGNATURE_DECODE
#check @L_V_BYTES
#check @L_V_LOADED
#print L_V_BYTES
#print L_V_LOADED
#print axioms small_spec
#print axioms decoder_return_guard
#print axioms header_exact
#print axioms pk_header_exact
#print axioms SIGNATURE_DECODE
#print axioms api_bounds
#print axioms context_accept
#print axioms L_V_BYTES
#print axioms L_V_LOADED
end FT1536Bridge
