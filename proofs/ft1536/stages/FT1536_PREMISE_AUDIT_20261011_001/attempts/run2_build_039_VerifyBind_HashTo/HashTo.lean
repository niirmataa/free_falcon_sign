import VerifyBind.Verdict

/-!
# Rung B3/X — the hashTo ROM interface

The B3 verdict binds `hashTo` as a parameter. This module makes that
interface precise and usable by the B5 assembly.

## Pinned C-side shape (source-bound extraction)

The challenge `c` of the verifier is derived by the call chain

* `falcon_vrfy_start(fv, r, rlen)` — `shake_init(&fv->sc, 512)` and
  `shake_inject(&fv->sc, r, rlen)` (`falcon-vrfy.c:1357-1364`): the nonce
  is injected FIRST, into a SHAKE-256 instance of capacity 512;
* `falcon_vrfy_update(fv, data, len)` — `shake_inject` of each message
  chunk (`falcon-vrfy.c:1368-1371`), so the absorbed stream is exactly
  `r ++ message`;
* `falcon_vrfy_verify` — `shake_flip(&fv->sc)` and
  `falcon_hash_to_point(&fv->sc, q, c0, fv->logn)` (`falcon-vrfy.c:1514-1515`);
* `falcon_hash_to_point` (`falcon-enc.c:563-593`): emits `n` coefficients
  with `n = 3 << (logn - 1)` (`:578-580`, so 1536 at the pinned profile),
  each by rejection sampling of 16-bit big-endian stream words
  `w = (buf[0] << 8) | buf[1]` (`:586-588`) with acceptance `w < lim`
  (`:589`) and emitted residue `w % q` (`:590`); the threshold is
  `lim = 65536 - (65536 % q)` (`:581`).

The producer side is the same chain: `falcon_sign_start` extracts a 40-byte
nonce (`falcon.h:234`, `falcon-sign.c:3285`), `falcon_sign_start_external_nonce`
absorbs it (`falcon-sign.c:3293-3298`), `falcon_sign_update` absorbs the
message (`:3302-3305`), and `falcon_sign_generate` calls the identical
`shake_flip` + `falcon_hash_to_point` (`:3322-3323`). The challenge map is
therefore shared by producer and consumer.

## What is assumed (recorded, NOT proven)

SHA-3/SHAKE-256 is a random oracle at this boundary (an A-side assumption
on par with A2). It is stated as the single predicate `UniformChallenge`;
nothing in this module uses it. The SHAKE internals, the law of the word
stream, key-material decoding (rung B1) and the signing sampler (rung B4)
are outside this module.
-/

namespace FT1536.VerifyBind
open FT1536.Run2

/-! ### Rejection-sampling layer (`falcon-enc.c:563-593`) -/

/-- Rejection threshold of `falcon_hash_to_point`
(`falcon-enc.c:581`: `lim = 65536 - (65536 % q)` at q = 18433). -/
def lim : ℕ := 65536 - (65536 % 18433)

theorem lim_eq : lim = 55299 := rfl

theorem lim_three_q : lim = 3 * 18433 := rfl

/-- Number of emitted challenge coefficients (`falcon-enc.c:578-580`:
`n = 3 << (logn - 1)`; 1536 at the pinned profile). -/
def challengeCount : ℕ := 1536

theorem challengeCount_eq : challengeCount = 3 * 2^9 := rfl

theorem challengeCount_pos : 0 < challengeCount := by decide

/-- One 16-bit big-endian stream word (`falcon-enc.c:587`). -/
def wordOfBytes (a b : Byte) : ℕ := a.val * 256 + b.val

theorem wordOfBytes_lt (a b : Byte) : wordOfBytes a b < 65536 := by
  have h1 : a.val < 256 := a.isLt
  have h2 : b.val < 256 := b.isLt
  dsimp only [wordOfBytes]
  omega

/-- Emitted residue of one accepted word (`falcon-enc.c:590`: `w % q`). -/
def valueOf (w : ℕ) : ZMod 18433 := w

theorem valueOf_val (w : ℕ) : (valueOf w).val = w % 18433 := by
  simp [valueOf]

theorem valueOf_lt (w : ℕ) : (valueOf w).val < 18433 := ZMod.val_lt _

theorem valueOf_accepts_lt (w : ℕ) (h : w < lim) : w < 3 * 18433 := by
  rw [← lim_three_q]
  exact h

/-- One scan step of the rejection loop (`falcon-enc.c:582-592`): consume
words until one is `< lim`; `none` models the loop still running when the
word source is exhausted. -/
def scanValue : List ℕ → Option (ZMod 18433 × List ℕ)
  | [] => none
  | w :: ws => if w < lim then some (valueOf w, ws) else scanValue ws

theorem scanValue_sound : ∀ (ws : List ℕ) (v : ZMod 18433) (rest : List ℕ),
    scanValue ws = some (v, rest) → v.val < 18433
  | [], _, _, h => by simp [scanValue] at h
  | w :: ws, v, rest, h => by
    by_cases hw : w < lim
    · simp [scanValue, hw] at h
      obtain ⟨hv, ht⟩ := h
      subst hv
      exact valueOf_lt w
    · simp [scanValue, hw] at h
      exact scanValue_sound ws v rest h

theorem scanValue_length : ∀ (ws : List ℕ) (v : ZMod 18433) (rest : List ℕ),
    scanValue ws = some (v, rest) → rest.length < ws.length
  | [], _, _, h => by simp [scanValue] at h
  | w :: ws, v, rest, h => by
    by_cases hw : w < lim
    · simp [scanValue, hw] at h
      obtain ⟨_, ht⟩ := h
      subst ht
      simp only [List.length_cons]
      omega
    · simp [scanValue, hw] at h
      have hl := scanValue_length ws v rest h
      simp only [List.length_cons]
      omega

/-- `falcon_hash_to_point` (`falcon-enc.c:576-592`) over a finite word
source: `k` accepted residues, or `none` if the source runs out first (the
C loop keeps squeezing the SHAKE stream in that case). -/
def hashToPointOf : ℕ → List ℕ → Option (List (ZMod 18433) × List ℕ)
  | 0, ws => some ([], ws)
  | k + 1, ws =>
    match scanValue ws with
    | none => none
    | some (v, rest) =>
      match hashToPointOf k rest with
      | none => none
      | some (vs, rest') => some (v :: vs, rest')

theorem hashToPointOf_length : ∀ (k : ℕ) (ws : List ℕ) (vs : List (ZMod 18433))
    (rest : List ℕ), hashToPointOf k ws = some (vs, rest) → vs.length = k
  | 0, ws, vs, rest, h => by
    simp [hashToPointOf] at h
    obtain ⟨he, _⟩ := h
    subst he
    rfl
  | k + 1, ws, vs, rest, h => by
    simp only [hashToPointOf] at h
    rcases hs : scanValue ws with - | p
    · simp [hs] at h
    · obtain ⟨v, ws'⟩ := p
      simp [hs] at h
      rcases ht : hashToPointOf k ws' with - | q
      · simp [ht] at h
      · obtain ⟨vs', rest'⟩ := q
        simp [ht] at h
        obtain ⟨he, _⟩ := h
        subst he
        simp only [List.length_cons]
        rw [hashToPointOf_length k ws' vs' rest' ht]

theorem hashToPointOf_sound : ∀ (k : ℕ) (ws : List ℕ) (vs : List (ZMod 18433))
    (rest : List ℕ), hashToPointOf k ws = some (vs, rest) → ∀ x ∈ vs, x.val < 18433
  | 0, ws, vs, rest, h, x, hx => by
    simp [hashToPointOf] at h
    obtain ⟨he, _⟩ := h
    subst he
    simp at hx
  | k + 1, ws, vs, rest, h, x, hx => by
    simp only [hashToPointOf] at h
    rcases hs : scanValue ws with - | p
    · simp [hs] at h
    · obtain ⟨v, ws'⟩ := p
      simp [hs] at h
      rcases ht : hashToPointOf k ws' with - | q
      · simp [ht] at h
      · obtain ⟨vs', rest'⟩ := q
        simp [ht] at h
        obtain ⟨he, _⟩ := h
        subst he
        simp only [List.mem_cons] at hx
        rcases hx with hx | hx
        · rw [hx]
          exact scanValue_sound ws v ws' hs
        · exact hashToPointOf_sound k ws' vs' rest' ht x hx

/-- Challenge coefficients of a word source (the pinned emission order of
`falcon_hash_to_point`: `challengeCount` accepted residues). -/
def challengeOf (ws : List ℕ) : Option (List (ZMod 18433)) :=
  (hashToPointOf challengeCount ws).map Prod.fst

theorem challengeOf_length {ws : List ℕ} {vs : List (ZMod 18433)}
    (h : challengeOf ws = some vs) : vs.length = challengeCount := by
  simp only [challengeOf] at h
  rcases ht : hashToPointOf challengeCount ws with - | p
  · simp [ht] at h
  · obtain ⟨vs', rest'⟩ := p
    simp [ht] at h
    subst h
    exact hashToPointOf_length challengeCount ws vs' rest' ht

theorem challengeOf_sound {ws : List ℕ} {vs : List (ZMod 18433)}
    (h : challengeOf ws = some vs) : ∀ x ∈ vs, x.val < 18433 := by
  simp only [challengeOf] at h
  rcases ht : hashToPointOf challengeCount ws with - | p
  · simp [ht] at h
  · obtain ⟨vs', rest'⟩ := p
    simp [ht] at h
    subst h
    exact hashToPointOf_sound challengeCount ws vs' rest' ht

theorem challengeOf_none_or_some (ws : List ℕ) :
    (∃ vs, challengeOf ws = some vs) ∨ challengeOf ws = none := by
  rcases h : challengeOf ws with - | vs
  · exact Or.inr rfl
  · exact Or.inl ⟨vs, rfl⟩

/-- Pairing of 1536 linear challenge coefficients into `Rq` (the
`Relation.poly` layout: pair `i` holds coefficients `i` and `i + 768`). -/
def toRq (vs : List (ZMod 18433)) : FT1536.Relation.Rq := fun i =>
  ((vs.getD i.val 0), (vs.getD (i.val + 768) 0))

/-- B5 plug point: the pinned realization of the challenge map — `toRq` of
the accepted residues of the SHAKE-256 word stream over the absorbed bytes
`streamOf r message`. The stream itself stays the A-side oracle. -/
def challengeRqOf (ws : List ℕ) : Option FT1536.Relation.Rq :=
  (challengeOf ws).map toRq

/-! ### The hashTo contract (axiom-shaped parameter) -/

/-- Injected stream of the pinned chain: the nonce `r` first
(`falcon_vrfy_start`), then the message chunks (`falcon_vrfy_update`). -/
def streamOf (r message : Bytes) : Bytes := r ++ message

/-- The hash-to-point interface of the pinned C chain: the deterministic
challenge map on injected streams, with the pinned nonce length. This is an
explicit parameter of the B3 verdict; NO security property is assumed here
(see `UniformChallenge`). -/
structure HashToSpec where
  /-- Deterministic map: injected stream bytes -> challenge in `Rq`. -/
  challenge : Bytes → FT1536.Relation.Rq
  /-- Nonce length of the pinned chain (`falcon.h:234`). -/
  rLen : ℕ
  /-- Pinned value: the nonce is 40 bytes (`falcon-sign.c:3285`). -/
  rLen_eq : rLen = 40

/-- The single ROM assumption (A-side; ASSUMED, not proven): the challenge
law seen by the adversary is uniform on `Rq` — i.e. SHA-3/SHAKE-256 is
modeled as a random oracle at the hash-to-point boundary. One name for the
assumptions ledger and for B5. -/
def UniformChallenge (L : FT1536.Law FT1536.Relation.Rq) : Prop :=
  L = FT1536.Law.uniform

theorem uniform_challenge_mass (x : FT1536.Relation.Rq) :
    (FT1536.Law.uniform).mass x = 1 / Fintype.card FT1536.Relation.Rq := rfl

theorem uniform_challenge_eq (L : FT1536.Law FT1536.Relation.Rq) :
    UniformChallenge L ↔ L = FT1536.Law.uniform := Iff.rfl

/-! ### Composition: the B3 verdict at the C-side shape -/

/-- The byte-level verdict at the pinned C-side shape: nonce `r` and message
absorbed as `r ++ message` into the challenge map. -/
def verdictOf (ht : HashToSpec) (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes) : Outcome :=
  verdict keyDecoder ht.challenge pkBytes (streamOf r message) sigBytes

theorem verdictOf_valid_iff (ht : HashToSpec)
    (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes) :
    verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.valid ↔
      ∃ h s, keyDecoder pkBytes = some h ∧ sigVector sigBytes = some s ∧
        FT1536.Relation.Verify h (ht.challenge (streamOf r message)) s :=
  verdict_valid_iff keyDecoder ht.challenge pkBytes (streamOf r message) sigBytes

theorem verdictOf_valid_decodes (ht : HashToSpec)
    (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes)
    (h : verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.valid) :
    keyDecoder pkBytes ≠ none ∧ sigVector sigBytes ≠ none :=
  verdict_valid_decodes keyDecoder ht.challenge pkBytes (streamOf r message) sigBytes h

theorem verdictOf_key_none (ht : HashToSpec)
    (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes) (hk : keyDecoder pkBytes = none) :
    verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.malformedKey :=
  verdict_key_none keyDecoder ht.challenge pkBytes (streamOf r message) sigBytes hk

theorem verdictOf_key_some_sig_none (ht : HashToSpec)
    (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes) (h : FT1536.Relation.Rq)
    (hk : keyDecoder pkBytes = some h) (hd : decodeSig sigBytes = none) :
    verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.malformedSig :=
  verdict_key_some_sig_none keyDecoder ht.challenge pkBytes (streamOf r message)
    sigBytes h hk hd

theorem verdictOf_total (ht : HashToSpec)
    (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes) :
    verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.valid ∨
      verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.invalid ∨
      verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.malformedSig ∨
      verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.malformedKey :=
  verdict_total keyDecoder ht.challenge pkBytes (streamOf r message) sigBytes

theorem verdictOf_decoded_or_rejected (ht : HashToSpec)
    (keyDecoder : Bytes → Option FT1536.Relation.Rq)
    (pkBytes r message sigBytes : Bytes) :
    (∃ h s, keyDecoder pkBytes = some h ∧ sigVector sigBytes = some s) ∨
      verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.malformedSig ∨
      verdictOf ht keyDecoder pkBytes r message sigBytes = Outcome.malformedKey :=
  decoded_or_rejected keyDecoder ht.challenge pkBytes (streamOf r message) sigBytes

end FT1536.VerifyBind
