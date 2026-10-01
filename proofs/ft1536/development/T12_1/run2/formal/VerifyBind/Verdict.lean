import Run2.VerifierInputs
import VerifyBind.ByteCodec

/-!
# Rung B3 — the byte-level verdict is the formal verifier

The byte-level verification outcome of the pinned FT1536 profile
(`falcon-vrfy.c:1283-1518` set_public_key + verify) through the REUSE chain
(`Run2.FileVerifier.decision`, the file/bit verify program) equals
`FT1536.Relation.Verify` of the decoded objects (A3 becomes a theorem).

Modeling boundary (recorded in `notes/VERIFY_BIND_WORK_STATE.md`):
key-material decoding is rung B1 (HERS) and enters as the `keyDecoder`
parameter; the hash-to-point map `falcon_hash_to_point` over the injected
stream enters as `hashTo`; the C int16 casts are `wrap16` (A5).
-/

namespace FT1536.VerifyBind
open FT1536.Run2 FT1536.Run2.BitArithmetic FT1536.Run2.FileArithmetic
  FT1536.Run2.FileVerifier FT1536.Run2.PolynomialReference

theorem getElem?_int16 (xs : List ℤ) (n : ℕ) (h : ∀ x ∈ xs, int16 x) :
    int16 ((xs[n]?.getD 0)) := by
  rcases hn : xs[n]? with - | x
  · have h1 : (((none : Option ℤ)).getD 0) = 0 := rfl
    rw [h1]
    dsimp only [int16]
    norm_num
  · have hx : x ∈ xs := List.mem_of_getElem? hn
    have h1 : ((some x).getD 0) = x := rfl
    rw [h1]
    exact h x hx

theorem sigVector_some {b : Bytes} {xs : List ℤ} (h : decodeSig b = some xs) :
    sigVector b = some (toVec xs) :=
  (sigVector_eq b).trans ((congrArg (fun o => o.map toVec) h).trans rfl)

theorem sigVector_none {b : Bytes} (h : decodeSig b = none) : sigVector b = none :=
  (sigVector_eq b).trans ((congrArg (fun o => o.map toVec) h).trans rfl)

/-- Word-file view of a decoded signature: one 16-bit sign-magnitude word
per coefficient, as consumed by the file/bit verify program. -/
def wordsOfVec (s : FT1536.Geometry.Vec) : List SignedWord :=
  List.ofFn fun r : Fin 1536 => encodeSigned (flatInt s r) 16

theorem wordsOfVec_represents (s : FT1536.Geometry.Vec)
    (h : ∀ r : Fin 1536, (flatInt s r).natAbs < 2^16) :
    SignedRepresents (wordsOfVec s) s := by
  intro i
  rw [loadSigned_correct]
  change signedValue (((List.ofFn _)[exponent i]?.getD zeroSigned))=_
  rw [getD_ofFn _ ⟨exponent i,exponent_lt i⟩,encodeSigned_correct _ _ (h _),flatInt_exponent]

theorem flatInt_toVec (xs : List ℤ) (r : Fin 1536) :
    flatInt (toVec xs) r = (xs[r.val]?.getD 0) := by
  by_cases hr : r.val < 768
  · simp [flatInt, hr, toVec]
  · simp [flatInt, hr, toVec]
    have h2 : r.val - 768 + 768 = r.val := by omega
    simp only [h2]

theorem wordsOfVec_bound (xs : List ℤ) (h : ∀ x ∈ xs, int16 x) :
    ∀ r : Fin 1536, (flatInt (toVec xs) r).natAbs < 2^16 := by
  intro r
  rw [flatInt_toVec xs r]
  have h2 := getElem?_int16 xs r.val h
  dsimp only [int16] at h2
  omega

theorem wordsOfVec_represents_int16 (xs : List ℤ) (h : ∀ x ∈ xs, int16 x) :
    SignedRepresents (wordsOfVec (toVec xs)) (toVec xs) :=
  wordsOfVec_represents (toVec xs) (wordsOfVec_bound xs h)

/-! ### The byte-level verdict -/

/-- Verification outcome of `falcon_vrfy_verify` (`falcon.h:127-136`):
1 valid, 0 invalid, -1 signature decoding error; the "public key not set"
outcome (-2) is `malformedKey`, reached when the key decoder rejects. -/
inductive Outcome where
  | valid
  | invalid
  | malformedSig
  | malformedKey

/-- Return codes of the C verifier (`falcon.h:131-133`). -/
def Outcome.code : Outcome → ℤ
  | .valid => 1
  | .invalid => 0
  | .malformedSig => -1
  | .malformedKey => -2

def Outcome.accepts : Outcome → Bool
  | .valid => true
  | _ => false

/-- Verdict of the decoded layer: a rejected signature decode is a modeled
outcome; otherwise the file/bit verify program decides. -/
def verdictCore (h c : FT1536.Relation.Rq) (sig : Option (List ℤ)) : Outcome :=
  match sig with
  | none => Outcome.malformedSig
  | some xs =>
    if decision (fieldEncoding h) (fieldEncoding c) (wordsOfVec (toVec xs))
    then Outcome.valid else Outcome.invalid

theorem verdictCore_none (h c : FT1536.Relation.Rq) :
    verdictCore h c none = Outcome.malformedSig := rfl

theorem verdictCore_valid_iff (h c : FT1536.Relation.Rq) (xs : List ℤ) :
    verdictCore h c (some xs) = Outcome.valid ↔
      decision (fieldEncoding h) (fieldEncoding c) (wordsOfVec (toVec xs)) = true := by
  by_cases hc : decision (fieldEncoding h) (fieldEncoding c) (wordsOfVec (toVec xs)) = true
  · simp [verdictCore, hc]
  · simp [verdictCore, hc]

theorem verdictCore_invalid_iff (h c : FT1536.Relation.Rq) (xs : List ℤ) :
    verdictCore h c (some xs) = Outcome.invalid ↔
      ¬ decision (fieldEncoding h) (fieldEncoding c) (wordsOfVec (toVec xs)) = true := by
  by_cases hc : decision (fieldEncoding h) (fieldEncoding c) (wordsOfVec (toVec xs)) = true
  · simp [verdictCore, hc]
  · simp [verdictCore, hc]

/-- Byte-level verdict of the pinned profile: decode the key material
(consumed from rung B1), decode the signature, then run the file/bit verify
program on the decoded objects. -/
def verdict (keyDecoder : Bytes → Option FT1536.Relation.Rq) (hashTo : Bytes → FT1536.Relation.Rq)
    (pkBytes msg sigBytes : Bytes) : Outcome :=
  match keyDecoder pkBytes with
  | none => Outcome.malformedKey
  | some h => verdictCore h (hashTo msg) (decodeSig sigBytes)

theorem verdict_eq (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes) :
    verdict keyDecoder hashTo pkBytes msg sigBytes =
      (match keyDecoder pkBytes with
       | none => Outcome.malformedKey
       | some h => verdictCore h (hashTo msg) (decodeSig sigBytes)) := rfl

theorem verdict_key_none (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes)
    (hk : keyDecoder pkBytes = none) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedKey := by
  rw [verdict_eq, hk]

theorem verdict_key_some_sig_none (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes) (h : FT1536.Relation.Rq)
    (hk : keyDecoder pkBytes = some h) (hd : decodeSig sigBytes = none) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedSig := by
  rw [verdict_eq, hk]
  show verdictCore h (hashTo msg) (decodeSig sigBytes) = Outcome.malformedSig
  rw [hd, verdictCore_none]

theorem verdict_valid_iff_core (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes)
    (h : FT1536.Relation.Rq) (xs : List ℤ)
    (hk : keyDecoder pkBytes = some h) (hd : decodeSig sigBytes = some xs) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.valid ↔
      decision (fieldEncoding h) (fieldEncoding (hashTo msg)) (wordsOfVec (toVec xs)) = true := by
  rw [verdict_eq, hk]
  show verdictCore h (hashTo msg) (decodeSig sigBytes) = Outcome.valid ↔
    decision (fieldEncoding h) (fieldEncoding (hashTo msg)) (wordsOfVec (toVec xs)) = true
  rw [hd]
  exact verdictCore_valid_iff h (hashTo msg) xs

theorem verdict_invalid_iff_core (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes)
    (h : FT1536.Relation.Rq) (xs : List ℤ)
    (hk : keyDecoder pkBytes = some h) (hd : decodeSig sigBytes = some xs) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.invalid ↔
      ¬ decision (fieldEncoding h) (fieldEncoding (hashTo msg)) (wordsOfVec (toVec xs)) = true := by
  rw [verdict_eq, hk]
  show verdictCore h (hashTo msg) (decodeSig sigBytes) = Outcome.invalid ↔
    ¬ decision (fieldEncoding h) (fieldEncoding (hashTo msg)) (wordsOfVec (toVec xs)) = true
  rw [hd]
  exact verdictCore_invalid_iff h (hashTo msg) xs

theorem verdict_valid_iff (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.valid ↔
      ∃ h s, keyDecoder pkBytes = some h ∧ sigVector sigBytes = some s ∧
        FT1536.Relation.Verify h (hashTo msg) s := by
  rcases hk : keyDecoder pkBytes with - | h
  · constructor
    · intro hh
      rw [verdict_key_none keyDecoder hashTo pkBytes msg sigBytes hk] at hh
      cases hh
    · intro hh
      obtain ⟨h', s, hk', _, _⟩ := hh
      cases hk'
  · rcases hd : decodeSig sigBytes with - | xs
    · constructor
      · intro hh
        rw [verdict_key_some_sig_none keyDecoder hashTo pkBytes msg sigBytes h hk hd] at hh
        cases hh
      · intro hh
        obtain ⟨h', s, _, hs, _⟩ := hh
        rw [sigVector_none hd] at hs
        cases hs
    · have hvec : sigVector sigBytes = some (toVec xs) := sigVector_some hd
      have hdec : decision (fieldEncoding h) (fieldEncoding (hashTo msg))
          (wordsOfVec (toVec xs)) = true ↔
          FT1536.Relation.Verify h (hashTo msg) (toVec xs) :=
        decision_correct _ _ _ h (hashTo msg) (toVec xs)
          (fieldEncoding_length h) (fieldEncoding_represents h)
          (fieldEncoding_represents (hashTo msg))
          (wordsOfVec_represents_int16 xs (decodeSig_mem_int16 hd))
      rw [verdict_valid_iff_core keyDecoder hashTo pkBytes msg sigBytes h xs hk hd]
      constructor
      · intro hcond
        exact ⟨h, toVec xs, rfl, hvec, hdec.mp hcond⟩
      · intro hh
        obtain ⟨h', s, hk', hs', hv⟩ := hh
        cases hk'
        rw [sigVector_some hd] at hs'
        cases hs'
        exact hdec.mpr hv

/-- Malformed coverage: decoder rejection is a modeled outcome — never a
silent success. -/
theorem verdict_valid_decodes (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes)
    (h : verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.valid) :
    keyDecoder pkBytes ≠ none ∧ sigVector sigBytes ≠ none := by
  rcases hk : keyDecoder pkBytes with - | hh
  · rw [verdict_key_none keyDecoder hashTo pkBytes msg sigBytes hk] at h
    cases h
  · rcases hd : decodeSig sigBytes with - | xs
    · rw [verdict_key_some_sig_none keyDecoder hashTo pkBytes msg sigBytes hh hk hd] at h
      cases h
    · have hn1 : (some hh : Option FT1536.Relation.Rq) ≠ none := by
        intro hh2
        cases hh2
      have hn2 : sigVector sigBytes ≠ none := by
        rw [sigVector_some hd]
        intro hh2
        cases hh2
      exact ⟨hn1, hn2⟩

theorem malformed_key (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes)
    (hk : keyDecoder pkBytes = none) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedKey :=
  verdict_key_none keyDecoder hashTo pkBytes msg sigBytes hk

theorem malformed_sig (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes)
    (hk : keyDecoder pkBytes ≠ none) (hd : decodeSig sigBytes = none) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedSig := by
  rcases hk2 : keyDecoder pkBytes with - | h
  · exact absurd hk2 hk
  · exact verdict_key_some_sig_none keyDecoder hashTo pkBytes msg sigBytes h hk2 hd

/-- Verdict totality: every byte input triple falls in exactly one of the
modeled outcomes — there is no third world. -/
theorem verdict_total (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes) :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.valid ∨
      verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.invalid ∨
      verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedSig ∨
      verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedKey := by
  rcases hk : keyDecoder pkBytes with - | h
  · right
    right
    right
    exact verdict_key_none keyDecoder hashTo pkBytes msg sigBytes hk
  · rcases hd : decodeSig sigBytes with - | xs
    · right
      right
      left
      exact verdict_key_some_sig_none keyDecoder hashTo pkBytes msg sigBytes h hk hd
    · by_cases hcond : decision (fieldEncoding h) (fieldEncoding (hashTo msg))
        (wordsOfVec (toVec xs)) = true
      · left
        rw [verdict_valid_iff_core keyDecoder hashTo pkBytes msg sigBytes h xs hk hd]
        exact hcond
      · right
        left
        rw [verdict_invalid_iff_core keyDecoder hashTo pkBytes msg sigBytes h xs hk hd]
        exact hcond

/-- Decoder totality at the verdict: every byte input yields either the
decoded objects or a modeled reject — no third outcome. -/
theorem decoded_or_rejected (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (hashTo : Bytes → FT1536.Relation.Rq) (pkBytes msg sigBytes : Bytes) :
    (∃ h s, keyDecoder pkBytes = some h ∧ sigVector sigBytes = some s) ∨
      verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedSig ∨
      verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.malformedKey := by
  rcases hk : keyDecoder pkBytes with - | h
  · right
    right
    exact verdict_key_none keyDecoder hashTo pkBytes msg sigBytes hk
  · rcases hd : decodeSig sigBytes with - | xs
    · right
      left
      exact verdict_key_some_sig_none keyDecoder hashTo pkBytes msg sigBytes h hk hd
    · left
      exact ⟨h, toVec xs, rfl, sigVector_some hd⟩

/-- Norm invariance under full negation of one vector. The C verifier
computes `s1 := h·s2 - c` (`falcon-vrfy.c:1419`) while `Relation.extract`
keeps `c - h·s2`; the two differ by full negation of `s1`, and this lemma
records that the compared norms (`falcon_is_short` vs `Geometry.Q`)
coincide, so the sign convention is not a silent assumption. -/
theorem q0_neg (v : FT1536.Geometry.Vec) :
    FT1536.Geometry.Q0 (fun i => (-(v i).1, -(v i).2)) = FT1536.Geometry.Q0 v := by
  simp only [FT1536.Geometry.Q0]
  apply Finset.sum_congr rfl
  intro i _
  simp only [FT1536.Geometry.block]
  ring

end FT1536.VerifyBind
