import Assembly

/-! # AdvPrg — window B2: the ChaCha20 stream accounting (`hprg`)

Window B2 of the run2 lane (`notes/PROMPT_B2_ADVPRG.md`). `hprg : AdvPRG tau ≤
deltaPRG` is the LAST, smallest named assumption of
`Assembly.end_to_end_assembled_theorem_statement`. This module does NOT prove
ChaCha20 secure (impossible); it (1) models the real stream of the pinned
`Extra/c/frng.c` (sha256
`4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644`) as the
tape law `tau` in the B3/VerifyBind source-bound style, (2) computes the exact
tape consumption, (3) shrinks the assumption to ONE named predicate
`ChaCha20PRFBound` in the standard distinguishing-game form against the uniform
tape and proves that `hprg` follows from it EXACTLY (the shape: the canonical
predicate and the seam quantity are the same object), and (4) records the
honest ledger (route (a) closed BY THEOREM below, seed boundary, what the term
costs).

## Source-bound model (`Extra/c/frng.c`, `Extra/c/internal.h`)

* **State**: "key (32 bytes) then IV (16 bytes) and block counter (8 bytes)"
  (frng.c:192-193) = 56 bytes = 14 little-endian words; the counter is "XORed
  into the first 8 bytes of the IV" (frng.c:198), i.e. into state words 14-15
  (frng.c:222-223). Modeled: `FrngState` = `keyIv : Fin 12 → Word` (words 0-11)
  and `cc : Fin 2 → Word` (the 64-bit counter, lo/hi).
* **Seeding chain** (A2 territory — what is assumed, NOT proven): a SHAKE-256
  instance `src` over `/dev/urandom` and/or CryptGenRandom plus the user seed
  (frng.c:48-56, `falcon_get_seed` `:171-187`, `urandom_get_seed` `:118-148`,
  `win32_get_seed` `:150-167`); `falcon_prng_init` draws the state with
  `shake_extract(src, p->state.d, 56)` (frng.c:290) and enforces the LE word
  interpretation with the counter reassembled as `tl + (th << 32)`
  (frng.c:292-315; the `FALCON_LE_U` shortcut `:289-291` agrees on LE
  machines). In the streaming signing API the SAME instance `src = fs->rng`
  also yields the 40-byte nonce (`shake_extract(&fs->rng, r, 40)`,
  falcon-sign.c:3285). Modeled: `shakeDecode`; the law of the 56 extracted
  bytes is the seed boundary object `seed : Law FrngState` (assumption A2 +
  SHAKE-as-extractor at the boundary; see `notes/B2_ADVPRG_WORK_STATE.md`).
* **Generator block**: ChaCha20 with constants `0x61707865, 0x3320646e,
  0x79622d32, 0x6b206574` (frng.c:203-205), counter XOR (frng.c:222-223), 10
  rounds of the eight `QROUND` calls in the recorded order (frng.c:224-252),
  feed-forward (frng.c:254-262), little-endian byte serialization
  (frng.c:266-275). Modeled: `initState`, `qround`, `permute`, `feedForward`,
  `blockOut`. Word semantics wrap mod 2^32 (scope A5).
* **Counter/block structure**: one 64-byte block per counter value
  (`u += 64`, frng.c:215; `cc++` per block `:264`, written back `:277`); the
  refill buffer is 4096 bytes = 64 blocks (internal.h:769 `d[4096]`) and the
  consumption cursor is `ptr` (`falcon_prng_get_u8` internal.h:857-863,
  `falcon_prng_get_u64` internal.h:814-849 — LE assembly `:842-849`, refill
  when fewer than 9 bytes remain `:819-827`, discarding the tail).
  Recorded, not smoothed: `falcon_prng_get_bytes` (frng.c:343-363) copies
  `memcpy(buf, p->buf.d, clen)` from the buffer BASE while advancing `ptr` —
  the pinned bytes differ from the `p->ptr`-indexed reads of `get_u8`/`get_u64`;
  there are NO callers of `get_bytes` in the pinned profile (the sampler draws
  via `get_u8`/`get_u64`, falcon-sign.c:2057-2947), so the modeled stream is
  unaffected. Modeled: `streamByte` (the block stream), `tapeOfState` (the
  consumed bits).

Tape-bit convention: bits are read LSB-first within each serialized byte
(matching the LE word assembly internal.h:842-849). The convention is a fixed
coordinate labeling and `AdvPRG` is invariant under fixed relabelings applied
to BOTH laws (uniform is uniform); the exact sampler-side addressing of the
drawn words stays the open `S.code` byte seam (B1) and is not claimed here.

## Consumption (the security parameter of the PRG claim)

Per sampler call the model draws ONE tape `Fin S.bits → Bool`
(`Run2.sample`/`Assembly.samplerLawAt` = `(Dist.draw tape).map (S.code …)`,
Run2/Games.lean:96-97). A `beta`-budget game run executes at most `beta.qs`
sign tokens (`Program` indices are structural, Run2/Games.lean:76-79) and each
executed sign token triggers at most one sampler call (the fresh-nonce branch
of `Games.signSim`, Run2/Games.lean:144,:165-167). Total ChaCha20-tape
consumption: `tapeBitsTotal beta S = beta.qs * S.bits` bits (exact when all
queries use fresh nonces). C-side per call: one ChaCha20 instance per
`falcon_sign_generate` (`falcon_prng_init(&tsc.p, &fs->rng, 0)`,
falcon-sign.c:3356/:3361) serving up to `SIGN_MAX_ATTEMPTS = 16` attempts at
`get_u8`/`get_u64` word granularity — the byte-exact per-call draw is part of
the open `S.code` binding (B1). The 40-byte nonce per signing query is drawn
from the SHAKE instance `fs->rng` (falcon-sign.c:3285) and modeled as
`Law.uniform (Law Nonce)` on the game side (Run2/Games.lean:131,:141) — it
rides the SAME seed boundary (A2/RO), not the ChaCha20 claim.

## The named assumption and the composition

`ChaCha20PRFBound tau delta` (the `UniformChallenge` pattern of B3/X,
VerifyBind/HashTo.lean:244) is the standard distinguishing game against the
uniform tape. Theorem (the SHAPE, "nearly immediate once both are stated
correctly"):

    ChaCha20PRFBound tau delta  ↔  AdvPRG tau ≤ delta

so `hprg` follows from `ChaCha20PRFBound tau deltaPRG` EXACTLY (same `delta`,
no slack), and the consumers
(`Assembly.assembled_hardness_substitution` and the assembled statement) get
the predicate-installed variants below.

## Honest ledger (details: `notes/B2_ADVPRG_WORK_STATE.md`)

* The final claim is CONDITIONAL on standard PRF security of ChaCha20 at the
  stated consumption (`ChaCha20PRFBound` at `tapeBitsTotal beta S` bits).
* Route (a) is closed BY THEOREM, not by measurement alone: the stream is a
  function of the 56-byte seed, so its support has at most 2^448 points and
  `1 - 2^448/2^n ≤ AdvPRG tau` (`route_a_closed`) — statistical distance ~1 at
  any realistic length (recorded D2 finding,
  `development/T12_1/END_TO_END_SCOPE.md` §2 route (a)). Consequently the
  additive term can only be the computational `Adv_PRG(ChaCha20)` reading
  (route (b), owner-approved); as a statistical term it is ~1 and vacuous.
* A future ideal-PRG theorem (uniform tape = the generator's law below the seed
  boundary) drops `deltaPRG` from the assembled bound entirely, leaving only
  the A2 seed-boundary assumptions.
-/

namespace FT1536.AdvPrg
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.Relation
open FT1536.Run2

/-! ## 0. The real stream: `Extra/c/frng.c` (source-bound model) -/

/-! ### 0.1 Machine words, state and constants (frng.c:189-205) -/

/-- One 32-bit machine word as its bit vector (bit `i` has weight `2^i`);
word arithmetic wraps mod 2^32 (machine-model scope A5). -/
abbrev Word := Fin 32 → Bool

/-- The unsigned value of a word. -/
def wordVal (w : Word) : ℕ := ∑ i : Fin 32, (if w i then 1 else 0) * 2 ^ (i : ℕ)

/-- The word of an unsigned value (truncated to 32 bits = wrapping). -/
def wordOf (n : ℕ) : Word := fun i => n.testBit i

/-- Wrapping 32-bit addition (`+=` of the `QROUND`, frng.c:226-239). -/
def add32 (a b : Word) : Word := wordOf (wordVal a + wordVal b)

/-- 32-bit XOR (`^=` of the `QROUND`, frng.c:226-239). -/
def xor32 (a b : Word) : Word := fun i => Bool.xor (a i) (b i)

/-- Left rotation by `s` bits (`state[d] = (x << s) | (x >> (32-s))` of the
`QROUND`, frng.c:229-238). -/
def rotl32 (a : Word) (s : ℕ) : Word := fun i =>
  a ⟨((i : ℕ) + (32 - s % 32)) % 32, Nat.mod_lt _ (by norm_num)⟩

/-- The PRNG state (frng.c:192-198): key (32 bytes) then IV (16 bytes) as 12
little-endian words, and the 64-bit block counter as its lo/hi words ("The
block counter is XORed into the first 8 bytes of the IV", frng.c:198). The
56-byte extraction and LE decode are `shakeDecode`. -/
abbrev FrngState := (Fin 12 → Word) × (Fin 2 → Word)

/-- The ChaCha20 constants (frng.c:203-205):
`0x61707865, 0x3320646e, 0x79622d32, 0x6b206574`. -/
def cwVal (i : Fin 4) : ℕ :=
  if i = 0 then 0x61707865
  else if i = 1 then 0x3320646e
  else if i = 2 then 0x79622d32
  else 0x6b206574

theorem cwVal_zero : cwVal 0 = 0x61707865 := rfl

theorem cwVal_one : cwVal 1 = 0x3320646e := rfl

theorem cwVal_two : cwVal 2 = 0x79622d32 := rfl

theorem cwVal_three : cwVal 3 = 0x6b206574 := rfl

def cw (i : Fin 4) : Word := wordOf (cwVal i)

/-- Bytes of one generated block (frng.c:215: `u += 64`). -/
def blockBytes : ℕ := 64

theorem blockBytes_eq : blockBytes = 64 := rfl

/-- Word count of one generated block. -/
def wordsPerBlock : ℕ := 16

/-- Round count of the permutation (frng.c:224: `for (i = 0; i < 10; i++)`). -/
def rounds : ℕ := 10

theorem rounds_eq : rounds = 10 := rfl

/-- Refill buffer size (internal.h:769: `unsigned char d[4096]`). -/
def bufferBytes : ℕ := 4096

/-- Blocks generated per refill (frng.c:215 loop over the 4096-byte buffer). -/
def bufferBlocks : ℕ := bufferBytes / blockBytes

theorem bufferBlocks_eq : bufferBlocks = 64 := rfl

/-! ### 0.2 The generator block (frng.c:200-278) -/

/-- One `QROUND(a, b, c, d)` of frng.c:226-239, in the recorded update order:

`a += b; d ^= a; d <<<= 16; c += d; b ^= c; b <<<= 12; a += b; d ^= a;
d <<<= 8; c += d; b ^= c; b <<<= 7`. -/
def qround (st : Fin 16 → Word) (a b c d : Fin 16) : Fin 16 → Word :=
  let st := Function.update st a (add32 (st a) (st b))
  let st := Function.update st d (rotl32 (xor32 (st d) (st a)) 16)
  let st := Function.update st c (add32 (st c) (st d))
  let st := Function.update st b (rotl32 (xor32 (st b) (st c)) 12)
  let st := Function.update st a (add32 (st a) (st b))
  let st := Function.update st d (rotl32 (xor32 (st d) (st a)) 8)
  let st := Function.update st c (add32 (st c) (st d))
  Function.update st b (rotl32 (xor32 (st b) (st c)) 7)

/-- The eight `QROUND` calls of one double round, in the recorded order
(frng.c:241-248): column step `(0,4,8,12) (1,5,9,13) (2,6,10,14) (3,7,11,15)`
then diagonal step `(0,5,10,15) (1,6,11,12) (2,7,8,13) (3,4,9,14)`. -/
def schedule : List (Fin 16 × Fin 16 × Fin 16 × Fin 16) :=
  [(0, 4, 8, 12), (1, 5, 9, 13), (2, 6, 10, 14), (3, 7, 11, 15),
   (0, 5, 10, 15), (1, 6, 11, 12), (2, 7, 8, 13), (3, 4, 9, 14)]

theorem schedule_length : schedule.length = 8 := rfl

/-- One double round (frng.c:241-248). -/
def doubleRound (st : Fin 16 → Word) : Fin 16 → Word :=
  schedule.foldl (fun st t => qround st t.1 t.2.1 t.2.2.1 t.2.2.2) st

/-- The block permutation: 10 double rounds (frng.c:224-252). -/
def permute (init : Fin 16 → Word) : Fin 16 → Word :=
  (List.range rounds).foldl (fun st _ => doubleRound st) init

/-- The initial state words of one block (frng.c:220-223): words 0-3 are the
constants CW, words 4-13 are `p->state.d` words 0-9 (key || IV), and words 14-15
are `p->state.d` words 10-11 (IV bytes 8-15) XORed with the counter lo/hi. -/
def initState (keyIv : Fin 12 → Word) (cc : Fin 2 → Word) : Fin 16 → Word := fun i =>
  if h : (i : ℕ) < 4 then cw ⟨(i : ℕ), h⟩
  else if h2 : (i : ℕ) < 14 then keyIv ⟨(i : ℕ) - 4, by have hi := i.isLt; omega⟩
  else if _h3 : i = 14 then xor32 (keyIv 10) (cc 0)
  else xor32 (keyIv 11) (cc 1)

/-- The feed-forward of frng.c:254-262: words 0-3 add CW, words 4-13 add
`p->state.d` words 0-9, and words 14-15 add `p->state.d` words 10-11 XORed with
the counter lo/hi. -/
def feedForward (keyIv : Fin 12 → Word) (cc : Fin 2 → Word) (st : Fin 16 → Word) :
    Fin 16 → Word := fun i =>
  if h : (i : ℕ) < 4 then add32 (st i) (cw ⟨(i : ℕ), h⟩)
  else if h2 : (i : ℕ) < 14 then add32 (st i) (keyIv ⟨(i : ℕ) - 4, by have hi := i.isLt; omega⟩)
  else if _h3 : i = 14 then add32 (st i) (xor32 (keyIv 10) (cc 0))
  else add32 (st i) (xor32 (keyIv 11) (cc 1))

/-- The 16 output words of the block at counter value `cc`
(frng.c:220-262: init, 10 double rounds, feed-forward). -/
def blockWords (keyIv : Fin 12 → Word) (cc : Fin 2 → Word) : Fin 16 → Word :=
  feedForward keyIv cc (permute (initState keyIv cc))

/-! ### 0.3 Serialization, stream and tape (frng.c:266-275) -/

/-- The value of one serialized byte of a word (bits `8j..8j+7`, LSB first). -/
def byteVal (w : Word) (j : Fin 4) : ℕ :=
  ∑ b : Fin 8, (if w ⟨(8 * (j : ℕ) + (b : ℕ)) % 32, Nat.mod_lt _ (by norm_num)⟩
    then (1 : ℕ) else 0) * 2 ^ (b : ℕ)

/-- One serialized byte of a word (frng.c:266-275: byte `u + (v << 2) + k` is
bits `8k..8k+7` of word `v`; `byteVal < 256` always, the `% 256` is identity). -/
def byteOfWord (w : Word) (j : Fin 4) : Byte :=
  ⟨byteVal w j % 256, Nat.mod_lt _ (by norm_num)⟩

/-- The 64 output bytes of the block at counter value `cc` (frng.c:254-275). -/
def blockOut (keyIv : Fin 12 → Word) (cc : Fin 2 → Word) : Fin 64 → Byte := fun t =>
  byteOfWord (blockWords keyIv cc ⟨(t : ℕ) / 4, by have ht := t.isLt; omega⟩)
    ⟨(t : ℕ) % 4, Nat.mod_lt _ (by norm_num)⟩

/-- Block-counter update (frng.c:264 `cc++` per block, wrapping at 64 bits). -/
def ccAdd (cc : Fin 2 → Word) (k : ℕ) : Fin 2 → Word :=
  let v := (wordVal (cc 0) + 2 ^ 32 * wordVal (cc 1) + k) % 2 ^ 64
  fun j => if j = 0 then wordOf v else wordOf (v / 2 ^ 32)

/-- Byte `t` of the generated stream: block `t / 64` at counter `cc + t / 64`
(frng.c:215,:264,:277 — the refill buffer only batches 64 blocks at a time). -/
def streamByte (st : FrngState) (t : ℕ) : Byte :=
  blockOut st.1 (ccAdd st.2 (t / blockBytes)) ⟨t % blockBytes, Nat.mod_lt _ (by decide)⟩

/-- Bit `k` of a byte (LSB first). -/
def bitOfByte (b : Byte) (k : Fin 8) : Bool := b.val.testBit k

/-- The consumed tape of width `n`: bit `t` is bit `t % 8` of stream byte
`t / 8` (LSB-first convention, matching the LE assembly internal.h:842-849;
a fixed coordinate label, so `AdvPRG` is convention-independent). -/
def tapeOfState (st : FrngState) (n : ℕ) : Fin n → Bool := fun t =>
  bitOfByte (streamByte st ((t : ℕ) / 8))
    ⟨(t : ℕ) % 8, Nat.mod_lt _ (by norm_num)⟩

/-! ### 0.4 The seeding chain and the tape law `tau` -/

/-- The 56-byte state decode of `falcon_prng_init` (frng.c:292-315): 14
little-endian words (`:303-310`); words 0-11 become `state.d` (key || IV) and
words 12-13 reassemble into the 64-bit counter `tl + (th << 32)` (`:312-314`).
The 56 bytes are `shake_extract(src, p->state.d, 56)` (frng.c:290) — the
SHAKE-256 seed boundary over `/dev/urandom` and the user seed (A2 territory;
the law of the extracted bytes is the object `seed : Law FrngState` below). -/
def shakeDecode (b : Fin 56 → Byte) : FrngState :=
  let wordAt (i : Fin 14) : Word :=
    wordOf ((b ⟨4 * (i : ℕ), by have hi := i.isLt; omega⟩).val
      + 256 * (b ⟨4 * (i : ℕ) + 1, by have hi := i.isLt; omega⟩).val
      + 65536 * (b ⟨4 * (i : ℕ) + 2, by have hi := i.isLt; omega⟩).val
      + 16777216 * (b ⟨4 * (i : ℕ) + 3, by have hi := i.isLt; omega⟩).val)
  (fun i => wordAt ⟨(i : ℕ), by have hi := i.isLt; omega⟩,
   fun j => if j = 0 then wordAt ⟨12, by norm_num⟩ else wordAt ⟨13, by norm_num⟩)

/-- THE real-generator tape law `tau` at width `n`: the law of the first `n`
consumed bits of the `Extra/c/frng.c` ChaCha20 stream under the seed-boundary
law `seed : Law FrngState` (56 bytes from the SHAKE-256 seeding chain,
frng.c:290). This is the `tau` of `Assembly.samplerLawAt` at `n = S.bits`. -/
noncomputable def frngTapeLaw (seed : Law FrngState) (n : ℕ) : Law (Fin n → Bool) :=
  seed.map (fun st => tapeOfState st n)

theorem frngTapeLaw_eq (seed : Law FrngState) (n : ℕ) :
    frngTapeLaw seed n = seed.map (fun st => tapeOfState st n) := rfl

/-! ## 1. The exact tape consumption (the security parameter of the PRG claim) -/

/-- Tape bits consumed per sampler call: exactly `S.bits` (one `Dist.draw` of
`Fin S.bits → Bool` per call — `Run2.sample`/`Assembly.samplerLawAt`). -/
def tapeBitsPerCall (S : Sampler) : ℕ := S.bits

theorem tapeBitsPerCall_eq (S : Sampler) : tapeBitsPerCall S = S.bits := rfl

/-- Sampler calls per `beta`-budget game run: at most `beta.qs` (one per
executed sign token — `Program` indices are structural, Run2/Games.lean:76-79,
and each executed sign token triggers at most one `Games.sample`, the
fresh-nonce branch of `Games.signSim`, Run2/Games.lean:144,:165-167). Exact
when all `beta.qs` queries use fresh nonces. -/
def samplerCallsPerRun (beta : Budget) : ℕ := beta.qs

theorem samplerCallsPerRun_eq (beta : Budget) :
    samplerCallsPerRun beta = beta.qs := rfl

/-- THE total ChaCha20-tape consumption of a `beta`-budget game run (the
security parameter of the PRG claim): `beta.qs * S.bits` bits. -/
def tapeBitsTotal (beta : Budget) (S : Sampler) : ℕ :=
  samplerCallsPerRun beta * tapeBitsPerCall S

theorem tapeBitsTotal_eq (beta : Budget) (S : Sampler) :
    tapeBitsTotal beta S = beta.qs * S.bits := rfl

theorem tapeBitsTotal_zero_qs (S : Sampler) :
    tapeBitsTotal ⟨0, 0, 0, 0⟩ S = 0 := by
  simp [tapeBitsTotal_eq]

/-- Total consumption in bytes (rounded up). -/
def tapeBytesTotal (beta : Budget) (S : Sampler) : ℕ :=
  (tapeBitsTotal beta S + 7) / 8

/-- Total consumption in ChaCha20 blocks (rounded up): the generator's own
accounting (one counter value per 64-byte block, frng.c:215,:264). -/
def chachaBlocksTotal (beta : Budget) (S : Sampler) : ℕ :=
  (tapeBytesTotal beta S + blockBytes - 1) / blockBytes

/-- Nonce draw per signing query: 40 bytes = 320 bits
(`shake_extract(&fs->rng, r, 40)`, falcon-sign.c:3285; `Nonce` is 40 bytes,
Run2/Games.lean:9, card `2^320`, Run2/Games.lean:46). On the game side this is
an ideal `Law.uniform` draw (Run2/Games.lean:131,:141) riding the same A2 seed
boundary — NOT part of the ChaCha20 tape claim. -/
def nonceBitsPerQuery : ℕ := 320

theorem nonceBitsPerQuery_eq : nonceBitsPerQuery = 320 := rfl

/-! ## 2. THE named standard assumption: `ChaCha20PRFBound` -/

/-- The distinguishing advantage of the one-tape distinguishing game of `tau`
against the uniform tape on the event/distinguisher `E`: the event gap
`|Pr[E(tau)] - Pr[E(uniform)]|` (bit-output distinguishers are the special
cases `E := fun x => D x = true`). -/
noncomputable def distinguishingAdv {ξ : Type} [Fintype ξ] [Nonempty ξ] (tau : Law ξ)
    (E : ξ → Prop) : ℝ :=
  |(Dist.draw tau).event E - (Dist.draw (Law.uniform : Law ξ)).event E|

/-- THE named standard assumption — the `UniformChallenge` pattern of B3/X
(VerifyBind/HashTo.lean:244) for the generator: `ChaCha20PRFBound tau delta` is
the standard distinguishing game against the uniform tape — the challenger
draws the tape from `tau` (real `Extra/c/frng.c` stream, SHAKE-256 seeding) or
from `Law.uniform`, and every distinguisher's event gap is at most `delta`.

What the seed boundary assumes (A2 territory, recorded): the 56 bytes of
`shake_extract(src, p->state.d, 56)` (frng.c:290) are drawn from a SHAKE-256
instance over `/dev/urandom` and/or CryptGenRandom plus the user seed
(frng.c:118-187) — i.e. hardware entropy is idealized as uniform and
adversary-independent AT THE SEED BOUNDARY (assumption A2), and SHAKE-256 is
used as a seeded extractor there. A deeper reduction would split this
predicate into a SHAKE-extraction term plus a ChaCha20-PRF term at fixed key;
this module keeps the canonical single predicate at the tape law. -/
def ChaCha20PRFBound {n : ℕ} (tau : Law (Fin n → Bool)) (delta : ℝ) : Prop :=
  ∀ (E : (Fin n → Bool) → Prop), distinguishingAdv tau E ≤ delta

/-- THE final assumption sentence of the assembled claim, instantiated at the
game horizon: standard PRF security of the pinned `frng.c` ChaCha20 stream at
the total consumption `beta.qs * S.bits` bits, i.e.
`ChaCha20PRFBound (frngTapeLaw seed (tapeBitsTotal beta S)) deltaPRG`. -/
def ChaCha20AtGameHorizon (seed : Law FrngState) (beta : Budget) (S : Sampler)
    (deltaPRG : ℝ) : Prop :=
  ChaCha20PRFBound (frngTapeLaw seed (tapeBitsTotal beta S)) deltaPRG

/-! ## 3. The composition: `hprg` from `ChaCha20PRFBound` (the SHAPE) -/

/-- `Dist.bind` of point masses is the computation itself (expectation level). -/
theorem bind_pure_same {α : Type} (q : FT1536.Run2.Dist α) :
    Dist.Same (q.bind fun x => Dist.pure x) q := by
  intro f
  rw [Dist.expect_bind]
  simp_rw [Dist.expect_pure]

/-- Event of a straight draw via the point-mass bind (the
`tape_game_hop_abs` shape). -/
theorem event_draw_eq {ξ : Type} [Fintype ξ] (p : Law ξ) (E : ξ → Prop) :
    ((Dist.draw p).bind fun x => Dist.pure x).event E = (Dist.draw p).event E :=
  Dist.same_event _ _ (bind_pure_same (Dist.draw p)) E

/-- The positive-set identity: the gap of the event `0 ≤ p.mass x - q.mass x`
is exactly the sum of the positive parts (the centering
`∑ (p.mass - q.mass) = 0` makes `AdvPRG` the gap of ONE event). -/
theorem gap_posEq {ξ : Type} [Fintype ξ] (p q : Law ξ) :
    (Dist.draw p).event (fun x => 0 ≤ p.mass x - q.mass x)
      - (Dist.draw q).event (fun x => 0 ≤ p.mass x - q.mass x)
      = ∑ x, max (p.mass x - q.mass x) 0 := by
  classical
  have hsum : (Dist.draw p).event (fun x => 0 ≤ p.mass x - q.mass x)
      - (Dist.draw q).event (fun x => 0 ≤ p.mass x - q.mass x)
      = (∑ x, if 0 ≤ p.mass x - q.mass x then p.mass x else 0)
        - (∑ x, if 0 ≤ p.mass x - q.mass x then q.mass x else 0) := rfl
  rw [hsum, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro x _
  by_cases h : 0 ≤ p.mass x - q.mass x
  · simp [h]
  · simp [h, max_eq_right (le_of_lt (lt_of_not_ge h))]

/-- `∑ |a| = 2 * ∑ max a 0` at zero total mass (the positive-set identity of
statistical distance). -/
theorem sum_abs_two_mul_pos {ι : Type} [Fintype ι] (a : ι → ℝ) (hsum : ∑ x, a x = 0) :
    ∑ x, |a x| = 2 * ∑ x, max (a x) 0 := by
  have key : ∀ x, |a x| = 2 * max (a x) 0 - a x := by
    intro x
    by_cases h : 0 ≤ a x
    · rw [abs_of_nonneg h, max_eq_left h]
      ring
    · rw [abs_of_neg (lt_of_not_ge h), max_eq_right (le_of_lt (lt_of_not_ge h))]
      ring
  calc ∑ x, |a x| = ∑ x, (2 * max (a x) 0 - a x) := by simp_rw [key]
    _ = 2 * ∑ x, max (a x) 0 - ∑ x, a x := by rw [Finset.sum_sub_distrib, ← Finset.mul_sum]
    _ = 2 * ∑ x, max (a x) 0 := by rw [hsum]; ring

/-- Every distinguisher's event gap is at most `AdvPRG tau` (data processing of
the one-tape game hop, `Assembly.tape_game_hop_abs` at the point-mass form). -/
theorem distinguishingAdv_le_advPRG {ξ : Type} [Fintype ξ] [Nonempty ξ] (tau : Law ξ)
    (E : ξ → Prop) :
    distinguishingAdv tau E ≤ Assembly.AdvPRG tau := by
  unfold distinguishingAdv
  rw [← event_draw_eq tau E, ← event_draw_eq (Law.uniform : Law ξ) E]
  exact Assembly.tape_game_hop_abs tau (fun x => Dist.pure x) E

/-- EASY direction of the shape: `AdvPRG tau ≤ delta` implies the standard
distinguishing bound (all events). -/
theorem chacha20PRFBound_of_advPRG_le {n : ℕ} (tau : Law (Fin n → Bool)) (delta : ℝ)
    (hdelta : Assembly.AdvPRG tau ≤ delta) : ChaCha20PRFBound tau delta :=
  fun _E => (distinguishingAdv_le_advPRG tau _).trans hdelta

/-- HARD direction of the shape — **`hprg` follows from `ChaCha20PRFBound`
EXACTLY** (same `delta`, no slack): the canonical distinguishing predicate and
the seam quantity are the same object (the positive set attains the
statistical distance). -/
theorem advPRG_le_of_chacha20PRFBound {n : ℕ} (tau : Law (Fin n → Bool)) (delta : ℝ)
    (h : ChaCha20PRFBound tau delta) : Assembly.AdvPRG tau ≤ delta := by
  classical
  have hsum : (∑ x, (tau.mass x - (Law.uniform : Law (Fin n → Bool)).mass x)) = 0 := by
    rw [Finset.sum_sub_distrib, tau.total, (Law.uniform : Law (Fin n → Bool)).total]
    ring
  have hkey := sum_abs_two_mul_pos
    (fun x : Fin n → Bool => tau.mass x - (Law.uniform : Law (Fin n → Bool)).mass x) hsum
  have htv : Assembly.AdvPRG tau
      = ∑ x, max (tau.mass x - (Law.uniform : Law (Fin n → Bool)).mass x) 0 := by
    unfold Assembly.AdvPRG Assembly.TV
    rw [hkey]
    linarith
  have hgap := gap_posEq tau (Law.uniform : Law (Fin n → Bool))
  have hg := h (fun x => 0 ≤ tau.mass x - (Law.uniform : Law (Fin n → Bool)).mass x)
  have hgoal : distinguishingAdv tau
      (fun x => 0 ≤ tau.mass x - (Law.uniform : Law (Fin n → Bool)).mass x)
      = |∑ x, max (tau.mass x - (Law.uniform : Law (Fin n → Bool)).mass x) 0| := by
    unfold distinguishingAdv
    rw [hgap]
  rw [htv]
  rw [hgoal] at hg
  exact (le_abs_self _).trans hg

/-- THE shape, both ways: the named standard predicate IS the seam bound. -/
theorem chacha20PRFBound_iff_advPRG_le {n : ℕ} (tau : Law (Fin n → Bool)) (delta : ℝ) :
    ChaCha20PRFBound tau delta ↔ Assembly.AdvPRG tau ≤ delta :=
  ⟨advPRG_le_of_chacha20PRFBound tau delta, chacha20PRFBound_of_advPRG_le tau delta⟩

/-- THE composition of task item 3: the assembled theorem's `hprg` follows from
`ChaCha20PRFBound tau deltaPRG` exactly — this is the predicate-installed form
of the seam premise. -/
theorem hprg_of_chacha20 {S : Sampler} (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ)
    (h : ChaCha20PRFBound tau deltaPRG) : Assembly.AdvPRG tau ≤ deltaPRG :=
  advPRG_le_of_chacha20PRFBound tau deltaPRG h

/-- The consumer plug: `Assembly.assembled_hardness_substitution` with the seam
premise INSTALLED as the named standard assumption (task item 3). -/
theorem assembled_hardness_substitution_chacha {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (k : ℝ)
    (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ) (keyIdent : Prop) (epsilon : ℝ)
    (hk : 1 ≤ k)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt k)
    (hkey : keyIdent)
    (hprg : ChaCha20PRFBound tau deltaPRG)
    (hepsilon : epsilon ≤ 1)
    (hardness : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) ≤ epsilon) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1) epsilon)
      + deltaPRG :=
  Assembly.assembled_hardness_substitution beta muKey A S jatt k tau deltaPRG keyIdent epsilon
    hk huc hshape hattempt hkey (hprg_of_chacha20 tau deltaPRG hprg) hepsilon hardness

/-- The assembled statement with the seam premise INSTALLED as the named
standard assumption. -/
theorem end_to_end_assembled_theorem_statement_chacha {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (k : ℝ)
    (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (hk : 1 ≤ k)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt k)
    (hkey : keyIdent)
    (hprg : ChaCha20PRFBound tau deltaPRG) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + deltaPRG :=
  Assembly.end_to_end_assembled_theorem_statement beta muKey A S jatt k tau deltaPRG keyIdent hk
    huc hshape hattempt hkey (hprg_of_chacha20 tau deltaPRG hprg)

/-! ## 4. Route (a) is closed BY THEOREM (support counting) -/

/-- Mass of a mapped law (the `Law.map = bind pure` shape). -/
theorem mass_map {σ ξ : Type} [Fintype σ] [Fintype ξ] [DecidableEq ξ]
    (p : Law σ) (f : σ → ξ) (y : ξ) :
    (p.map f).mass y = ∑ x, p.mass x * (if y = f x then 1 else 0) := rfl

/-- Support-counting lower bound: a law supported on `T` has statistical
distance at least `1 - |T| / |ξ|` from uniform (the tape has `|ξ|` points). -/
theorem advPRG_ge_one_sub_supportCard {ξ : Type} [Fintype ξ] [Nonempty ξ] (tau : Law ξ)
    (T : Finset ξ) (hT : ∀ x, tau.mass x ≠ 0 → x ∈ T) :
    1 - (T.card : ℝ) / Fintype.card ξ ≤ Assembly.AdvPRG tau := by
  classical
  have hpt : ∑ x ∈ T, tau.mass x = 1 := by
    have h0 : ∑ x, tau.mass x = 1 := tau.total
    have hz : ∑ x ∈ (Finset.univ.filter fun x => x ∉ T), tau.mass x = 0 := by
      apply Finset.sum_eq_zero
      intro x hx
      simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hx
      by_contra hne
      exact hx (hT x hne)
    have hsp := Finset.sum_filter_add_sum_filter_not
      (Finset.univ : Finset ξ) (fun x => x ∈ T) tau.mass
    rw [show (Finset.univ.filter fun x => x ∈ T) = T from by simp] at hsp
    rw [hz, h0] at hsp
    linarith
  have hu : ∑ x ∈ T, (Law.uniform : Law ξ).mass x = (T.card : ℝ) / Fintype.card ξ := by
    have um : ∀ x, (Law.uniform : Law ξ).mass x = 1 / Fintype.card ξ := fun _ => rfl
    simp_rw [um]
    rw [Finset.sum_const, nsmul_eq_mul, mul_one_div]
  have hTsum : ∑ x ∈ T, (tau.mass x - (Law.uniform : Law ξ).mass x)
      = 1 - (T.card : ℝ) / Fintype.card ξ := by
    rw [Finset.sum_sub_distrib, hpt, hu]
  have hit : (∑ x, if x ∈ T then (tau.mass x - (Law.uniform : Law ξ).mass x) else 0)
      = ∑ x ∈ T, (tau.mass x - (Law.uniform : Law ξ).mass x) := by
    rw [← Finset.sum_filter]
    congr 1
    ext x
    simp
  have hptwise : ∀ x, (if x ∈ T then (tau.mass x - (Law.uniform : Law ξ).mass x) else 0)
      ≤ max (tau.mass x - (Law.uniform : Law ξ).mass x) 0 := by
    intro x
    by_cases hx : x ∈ T
    · simp [hx]
    · simp [hx]
  have hgapge : (Dist.draw tau).event (fun x => 0 ≤ tau.mass x - (Law.uniform : Law ξ).mass x)
      - (Dist.draw (Law.uniform : Law ξ)).event
        (fun x => 0 ≤ tau.mass x - (Law.uniform : Law ξ).mass x)
      ≥ 1 - (T.card : ℝ) / Fintype.card ξ := by
    rw [gap_posEq tau (Law.uniform : Law ξ), ← hTsum, ← hit]
    exact Finset.sum_le_sum fun x _ => hptwise x
  have habs := distinguishingAdv_le_advPRG tau
    (fun x => 0 ≤ tau.mass x - (Law.uniform : Law ξ).mass x)
  unfold distinguishingAdv at habs
  exact le_trans (le_trans hgapge (le_abs_self _)) habs

/-- Support-counting lower bound, mapped form: the law `p.map f` is supported
on at most `|σ|` tape points, so its statistical distance from uniform is at
least `1 - |σ| / |ξ|`. -/
theorem advPRG_ge_one_sub_card_map {σ ξ : Type} [Fintype σ] [Fintype ξ] [Nonempty ξ]
    [DecidableEq ξ] (p : Law σ) (f : σ → ξ) :
    1 - (Fintype.card σ : ℝ) / Fintype.card ξ ≤ Assembly.AdvPRG (p.map f) := by
  have hT : ∀ x, (p.map f).mass x ≠ 0 →
      x ∈ (Finset.univ : Finset σ).image f := by
    intro x hx
    by_contra hmem
    have hz : (p.map f).mass x = 0 := by
      simp only [Finset.mem_image, Finset.mem_univ, true_and, not_exists] at hmem
      rw [mass_map]
      apply Finset.sum_eq_zero
      intro st _
      have hne : x ≠ f st := fun h => hmem st h.symm
      simp [hne]
    exact hx hz
  have hle := advPRG_ge_one_sub_supportCard (p.map f) ((Finset.univ : Finset σ).image f) hT
  have hc : ((Finset.univ : Finset σ).image f).card ≤ Fintype.card σ := Finset.card_image_le
  have h2n : (0:ℝ) ≤ Fintype.card ξ := Nat.cast_nonneg _
  have hcast : (((Finset.univ : Finset σ).image f).card : ℝ) ≤ (Fintype.card σ : ℝ) :=
    Nat.cast_le.mpr hc
  have hdiv := div_le_div_of_nonneg_right hcast h2n
  have hre : 1 - (Fintype.card σ : ℝ) / Fintype.card ξ
      ≤ 1 - (((Finset.univ : Finset σ).image f).card : ℝ) / Fintype.card ξ :=
    sub_le_sub_left hdiv 1
  exact hre.trans hle

/-- The tape-space cardinality: `|(Fin n → Bool)| = 2^n`. -/
theorem card_tapeSpace (n : ℕ) : Fintype.card (Fin n → Bool) = 2 ^ n := by
  rw [Fintype.card_fun, Fintype.card_bool, Fintype.card_fin]

/-- The seed-space cardinality: `|FrngState| = 2^448` (14 words of 32 bits =
the 56 bytes of `shake_extract(src, p->state.d, 56)`, frng.c:290). -/
theorem card_frngState : Fintype.card FrngState = 2 ^ 448 := by
  have h1 : Fintype.card Word = 2 ^ 32 := by
    rw [Fintype.card_fun, Fintype.card_bool, Fintype.card_fin]
  have h2 : Fintype.card (Fin 12 → Word) = 2 ^ 384 := by
    calc Fintype.card (Fin 12 → Word) = (2 ^ 32) ^ 12 := by rw [Fintype.card_fun, h1, Fintype.card_fin]
      _ = 2 ^ 384 := by rw [← pow_mul]
  have h3 : Fintype.card (Fin 2 → Word) = 2 ^ 64 := by
    calc Fintype.card (Fin 2 → Word) = (2 ^ 32) ^ 2 := by rw [Fintype.card_fun, h1, Fintype.card_fin]
      _ = 2 ^ 64 := by rw [← pow_mul]
  rw [Fintype.card_prod, h2, h3, ← pow_add]

/-- **Route (a) is closed by measurement AND by theorem** (recorded D2 finding,
`development/T12_1/END_TO_END_SCOPE.md` §2): the `frng.c` tape at width `n` is
a function of the 56-byte seed, so its statistical distance from uniform is at
least `1 - 2^448 / 2^n` — about 1 at any realistic length. -/
theorem route_a_closed (seed : Law FrngState) (n : ℕ) :
    1 - (2:ℝ) ^ 448 / 2 ^ n ≤ Assembly.AdvPRG (frngTapeLaw seed n) := by
  have hgen := advPRG_ge_one_sub_card_map seed (fun st => tapeOfState st n)
  rw [card_frngState, card_tapeSpace] at hgen
  have h448 : ((2 ^ 448 : ℕ) : ℝ) = (2:ℝ) ^ 448 := Nat.cast_pow 2 448
  have hn : ((2 ^ n : ℕ) : ℝ) = (2:ℝ) ^ n := Nat.cast_pow 2 n
  rw [h448, hn] at hgen
  rw [frngTapeLaw_eq]
  exact hgen

/-- **The honest ledger, kernel-checked**: any `delta` satisfying the named
assumption on the real `frng.c` tape is at least `1 - 2^448/2^n` — the
statistical reading of `deltaPRG` is ~1 at real consumption, so the term can
only be the computational `Adv_PRG(ChaCha20)` reading (D2 route (b)). -/
theorem chacha20PRFBound_delta_ge (seed : Law FrngState) (n : ℕ) (delta : ℝ)
    (h : ChaCha20PRFBound (frngTapeLaw seed n) delta) :
    1 - (2:ℝ) ^ 448 / 2 ^ n ≤ delta :=
  (route_a_closed seed n).trans (advPRG_le_of_chacha20PRFBound _ _ h)

end FT1536.AdvPrg
