# B2 — the ChaCha20 stream accounting (`hprg`)

Task: `notes/PROMPT_B2_ADVPRG.md` (window B2; the LAST, smallest named
assumption of `run2/formal/Assembly.lean`). Workspace
`proofs/ft1536/development/T12_1/run2/`. Own files only: `formal/AdvPrg.lean`
+ this entry. Recorded 2026-10-02.

## Status

**DONE — `formal/AdvPrg.lean` builds 0/0** (EMPTY log = 0 errors/0 warnings,
guarded serial compile `tools/original/run_lean_guarded.sh`, exit 0, 2s).
Axiom audit: **71/71 declarations (defs + theorems) depend only on subsets of
`[propext, Classical.choice, Quot.sound]`**; zero unfinished-proof markers,
zero `sorry`. `#print` statement evidence in `.build/audit/AdvPrgAudit.log`.

## 1. THE final assumption statement (one sentence + one predicate name)

> The assembled bound is CONDITIONAL on **`ChaCha20PRFBound`** — the standard
> distinguishing game of the pinned `Extra/c/frng.c` ChaCha20 tape law
> `tau = frngTapeLaw seed n` against the uniform tape, at the total
> consumption `n = tapeBitsTotal beta S = beta.qs * S.bits` bits, with budget
> `deltaPRG` (`ChaCha20AtGameHorizon seed beta S deltaPRG`).

Kernel form (the canonical predicate, the `UniformChallenge` pattern of B3/X):

    ChaCha20PRFBound (tau : Law (Fin n -> Bool)) (delta : ℝ) : Prop :=
      ∀ (E : (Fin n -> Bool) -> Prop), distinguishingAdv tau E <= delta

where `distinguishingAdv tau E = |Pr[E(tau)] - Pr[E(uniform)]|` (bit-output
distinguishers are `E := fun x => D x = true`; the quantifier runs over all
events — the information-theoretic reading is the SHAPE, the ledger below
records the computational reading). What the seed boundary assumes (A2
territory, recorded in the docstring): the 56 bytes of
`shake_extract(src, p->state.d, 56)` (frng.c:290) come from a SHAKE-256
instance over `/dev/urandom`/CryptGenRandom plus the user seed
(frng.c:118-187) — hardware entropy idealized as uniform and
adversary-independent AT THE BOUNDARY (A2), SHAKE-256 as seeded extractor
there. A deeper reduction would split this predicate into a SHAKE-extraction
term plus a ChaCha20-PRF term at fixed key; the module keeps ONE named
predicate at the tape law.

## 2. The consumption numbers (kernel-checked)

| Quantity | Value | Pin |
|---|---|---|
| tape per sampler call | exactly `S.bits` bits | `tapeBitsPerCall_eq` (rfl; one `Dist.draw (Fin S.bits -> Bool)` per `Run2.sample`, Run2/Games.lean:96-97) |
| sampler calls per `beta`-budget run | at most `beta.qs` | `samplerCallsPerRun_eq` (rfl; `Program` sign tokens are structural, Run2/Games.lean:76-79; at most one `Games.sample` per executed sign token = fresh-nonce branch of `Games.signSim`, Run2/Games.lean:144,:165-167) |
| **total ChaCha20-tape consumption** | **`beta.qs * S.bits` bits** | `tapeBitsTotal_eq` (rfl; exact when all queries use fresh nonces) — **the security parameter of the PRG claim** |
| total bytes / blocks | `tapeBytesTotal`, `chachaBlocksTotal` (ceil; 64-byte blocks) | defs, frng.c:215,:264 |
| nonce draw per signing query | 40 bytes = 320 bits | `nonceBitsPerQuery_eq` (falcon-sign.c:3285 `shake_extract(&fs->rng, r, 40)`; `Nonce` card `2^320`, Run2/Games.lean:46) — rides the A2/RO boundary, NOT the ChaCha20 claim |
| seed state | 56 bytes = 14 LE words = 2^448 states | `card_frngState`; frng.c:192-193,:290-315 |
| refill buffer | 4096 B = 64 blocks per refill | `bufferBlocks_eq`; internal.h:769 |

C-side per call (recorded, feeds the open `S.code` binding of B1): one
ChaCha20 instance per `falcon_sign_generate` (`falcon_prng_init(&tsc.p,
&fs->rng, 0)`, falcon-sign.c:3356/:3361) serving up to
`SIGN_MAX_ATTEMPTS = 16` attempts at `get_u8`/`get_u64` word granularity
(internal.h:814-863; `get_u64` refills when fewer than 9 bytes remain and
discards the tail, `:819-827`).

## 3. The source-bound model (`Extra/c/frng.c` sha256 `4b1289ad…`, B3/VerifyBind style)

`formal/AdvPrg.lean` §0 transcribes, with exact line citations (module
docstring carries the full pin list):

- **state**: key 32 B + IV 16 B + counter 8 B (frng.c:192-198), counter XORed
  into IV bytes 8-15 = state words 14-15 (frng.c:222-223);
  `shakeDecode` = the LE 14-word decode with `tl + (th << 32)` counter
  (frng.c:292-315);
- **generator block**: constants `0x61707865, 0x3320646e, 0x79622d32,
  0x6b206574` (frng.c:203-205, `cwVal_zero..three` rfl pins), `qround` in the
  recorded update order (frng.c:226-239), the eight-QROUND schedule
  (frng.c:241-248, `schedule_length`), 10 double rounds (frng.c:224-252),
  feed-forward (frng.c:254-262), LE byte serialization (frng.c:266-275);
  word ops wrap mod 2^32 (scope A5);
- **counter/block structure**: 64 B per counter value, `cc++` per block
  (frng.c:215,:264,:277 — `ccAdd`), 64 blocks per refill (internal.h:769),
  stream = refill batches (`streamByte`), tape = LSB-first bits of the stream
  (`tapeOfState`; a fixed coordinate label — `AdvPRG` is invariant under fixed
  relabelings applied to both laws, so the convention does not affect the
  claim; the exact sampler-side addressing stays the open `S.code` byte seam
  of B1);
- **seeding chain**: `falcon_prng_init` extracts the state from a SHAKE-256
  instance (frng.c:290) that is seeded over `/dev/urandom`
  (`urandom_get_seed`, frng.c:118-148) and/or CryptGenRandom (frng.c:150-167)
  plus the user seed (`falcon_get_seed` frng.c:171-187); in the streaming
  signing API the same instance `fs->rng` also yields the 40-byte nonce
  (falcon-sign.c:3285).

**RECORDED, NOT SMOOTHED (audit note)**: `falcon_prng_get_bytes`
(frng.c:343-363) copies `memcpy(buf, p->buf.d, clen)` — from the buffer BASE
— while advancing `p->ptr` as the cursor, unlike the `p->ptr`-indexed reads of
`falcon_prng_get_u8`/`get_u64` (internal.h:857-863,:814-849). The pinned
bytes are what they are; there are NO callers of `get_bytes` in the pinned
profile (the sampler draws via `get_u8`/`get_u64`, falcon-sign.c:2057-2947),
so the modeled stream (get_u64/get_u8 cursor semantics) is unaffected. If a
future profile calls `get_bytes` more than once per refill period, the
consumed stream repeats buffer prefixes and the tape law must be re-modeled —
recorded as a live wire.

## 4. The composition — `hprg` follows from `ChaCha20PRFBound` EXACTLY (the SHAPE)

    ChaCha20PRFBound tau delta  <->  AdvPRG tau <= delta   (chacha20PRFBound_iff_advPRG_le)

- HARD direction (`advPRG_le_of_chacha20PRFBound`) — the point of the shape:
  the canonical predicate CANONICALLY implies the seam quantity at the SAME
  `delta` (no slack). The positive set `E := {x | 0 <= tau.mass x - u.mass x}`
  attains the statistical distance (`gap_posEq` + `sum_abs_two_mul_pos`:
  `∑|a| = 2 * ∑ max a 0` at zero total mass).
- EASY direction (`chacha20PRFBound_of_advPRG_le`) — data processing via the
  already-proved `Assembly.tape_game_hop_abs` at the point-mass form
  (`distinguishingAdv_le_advPRG`, `bind_pure_same`, `event_draw_eq`).
- `hprg_of_chacha20` = the task's item-3 derivation of
  `hprg : Assembly.AdvPRG tau <= deltaPRG`.
- Consumer plugs (task item 3): `assembled_hardness_substitution_chacha` and
  `end_to_end_assembled_theorem_statement_chacha` — the B5 consumers with the
  seam premise INSTALLED as the named standard assumption (the audit log
  prints their exact argument lists: same binders as B5 with
  `hprg : ChaCha20PRFBound tau deltaPRG` in place of the raw inequality).

## 5. The honest ledger (what this assumption costs)

- **The final claim is CONDITIONAL on standard PRF security of ChaCha20 at
  the stated consumption** — `ChaCha20PRFBound` at `n = beta.qs * S.bits`
  bits. Nothing about ChaCha20 is proven here (impossible); the assumption is
  shrunk to its canonical standard form and bound into the assembly.
- **Route (a) is closed — now BY THEOREM, not by measurement alone**
  (recorded D2 finding, `development/T12_1/END_TO_END_SCOPE.md` §2: "a
  ChaCha20 stream has statistical distance ~1 from uniform at real lengths").
  Kernel: `route_a_closed` — the tape is a function of the 56-byte seed, its
  support has at most 2^448 points (`card_frngState`), so
  `1 - 2^448/2^n <= AdvPRG tau` (`advPRG_ge_one_sub_card_map`), and
  `chacha20PRFBound_delta_ge`: **every `delta` satisfying the named
  assumption on the real tape is at least `1 - 2^448/2^n`**. At any realistic
  consumption (even one sampler call) that is ~1.
- **Consequence for the term (route (b), owner-approved)**: the statistical
  reading of `deltaPRG` is ~1 and vacuous as an additive term; the operative
  reading is the COMPUTATIONAL `Adv_PRG(ChaCha20)` one — the same predicate
  quantified over the distinguishers realizable by the composed game. The
  outer bound stays conditional and carries `deltaPRG` explicitly, exactly as
  D2 route (b) decided; silent idealization remains forbidden.
- **Width convention (exact reading of B5's binder)**: `tau :
  Law (Fin S.bits -> Bool)` is ONE sampler call's tape; the `tape_game_hop`
  family is a one-draw hop. The single additive `deltaPRG` of the outer bound
  is the ONE-STREAM reading at total width `n = tapeBitsTotal beta S` (the
  whole game run's generator usage is one stream; the distinguishing claim at
  the total width covers any downstream splitting of it). A per-call reading
  instead would compose with a `beta.qs`-fold factor — the two readings
  coincide only under the total-width claim above; recorded here so no later
  window silently mixes them. (C-side nuance recorded in §2: each signing
  call re-inits its own instance from `fs->rng`, so the joint claim at total
  width is over the concatenated per-instance streams — the same object.)
- **Seed boundary (A2)**: `/dev/urandom` + user seed uniform and
  adversary-independent at the boundary; SHAKE-256 as seeded extractor
  (frng.c:290). The nonce law (`Law.uniform (Law Nonce)` in the model) rides
  the SAME boundary (SHAKE side) and is NOT covered by the ChaCha20 claim.
  A2 also lives at `huc` (the hash boundary, B3/X) — the two bites are the
  same assumption at two interfaces.
- **What a future ideal-PRG theorem would gain**: proving the generator's law
  equals the uniform tape below the seed boundary (`AdvPRG tau = 0`, e.g. by
  an ideal-cipher/ideal-sponge treatment) drops `deltaPRG` from the assembled
  bound ENTIRELY — `end_to_end_assembled_theorem_statement_prgTerm` collapses
  to the bare `min 1 (...)` term and the claim becomes unconditional below
  the seed boundary. Alternatively a concrete PRF reduction for ChaCha20
  would replace `deltaPRG` by its computed advantage at the stated
  consumption (`beta.qs * S.bits` bits, 256-bit key).
- A3/A4 (byte bridge) and the additive-error mass floor stay OPEN
  non-arguments as before; A5 is the word-semantics scope of the block model.

## 6. Receipts

- `bash tools/original/run_lean_guarded.sh formal/AdvPrg.lean
  .build/check_lib/AdvPrg.olean 900 1800` — exit 0, 2s, log EMPTY (0/0).
- Axiom audit `bash tools/original/run_lean_guarded.sh
  .build/audit/AdvPrgAudit.lean .build/audit/AdvPrgAudit.olean 900 1800` —
  exit 0; **71/71 declarations, standard axioms only** (50 with subsets of
  `[propext, Classical.choice, Quot.sound]`, 21 data/rfl defs with none);
  zero `sorry`; the `#print` blocks print the exact shapes of
  `ChaCha20PRFBound`, `ChaCha20AtGameHorizon`, `tapeBitsTotal_eq`,
  `hprg_of_chacha20`, `chacha20PRFBound_iff_advPRG_le`, both consumer plugs,
  `card_frngState`, `route_a_closed`, `chacha20PRFBound_delta_ge`.
- Hashes (sha256/16): `formal/AdvPrg.lean` `f0c2e858e1ab0e4d…`,
  `AdvPrg.log` `e3b0c44298fc1c14…` (= empty),
  `AdvPrgAudit.lean` `d8f44ad25bcd55dd…`,
  `AdvPrgAudit.log` `2a69b17eb74ced62…`.
- Pinned source: `Extra/c/frng.c` sha256
  `4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644` (checked
  at start; matches the task pin).

## 7. Workstate lessons (for the next window)

- **The `classical` instance trap**: inside a proof over big `Fintype`
  instances (here `FrngState`/`Fin n -> Bool`), `classical` changes
  `DecidableEq` synthesis; comparing mass terms whose `Law.map`/`Finset.image`
  carry DIFFERENT `DecidableEq` instances makes the unifier unfold
  `Fintype.elems`/`Fin.foldr.loop`/Real-Quotient machinery to depth infinity
  (`maximum recursion depth`). Symptom: a `have h := lemma ...` blows up at
  the argument pass while the lemma itself compiles. Fix used: keep the
  cross-lemma application in the LEMMA's own binder context (mapped-form
  lemma `advPRG_ge_one_sub_card_map`), no `classical` in `route_a_closed`.
- `Nat.mul` does NOT reduce definitionally on a literal-zero left argument —
  `0 * x = 0` needs `Nat.zero_mul`/`simp`, not `rfl`.
- `rw` auto-closes `rfl`-residual goals — never follow a goal-closing `rw`
  with `ring`/`norm_num`/`congr` ("no goals to be solved").
- `if_pos`/`if_neg` are deprecated in this Mathlib — `simp [h, …]` idioms
  instead (unused simp args also lint!).
- `Law.event`/`Dist.event` bridge: `Dist.event (Dist.draw p) E` is
  `rfl`-defeq to the if-sum with the CLASSICAL decidability instance — do the
  `show`-chain under `classical`, and state helper lemmas without `if`s in
  their types (`max` form works: `max (a x) 0`).
- `Nat.cast_pow`/`Nat.cast_le`/`Nat.cast_nonneg` replace `exact_mod_cast` on
  big numerals (`mod_cast` tried to evaluate `2^448` and recursed out).

## 8. Podsumowanie dla właściciela (po polsku)

**Zadanie B2/AdvPRG — zamknięte.** Ostatnie, najmniejsze założenie montażu
(`hprg`) ma już nazwaną postać kanoniczną i jest doliczone uczciwie.

- **Zdanie końcowe (jedno zdanie + jedna nazwa predykatu):** dowód złożony
  jest warunkowy na **`ChaCha20PRFBound`** — standardową grę rozróżniającą
  strumienia ChaCha20 z `Extra/c/frng.c` (siew SHAKE-256 ← /dev/urandom +
  siew użytkownika) przeciw taśmie równej, przy całkowitej konsumpcji
  **`n = beta.qs * S.bits` bitów** i budżecie `deltaPRG`.
- **Liczby konsumpcji (kernelowo):** na jedno wywołanie samplera dokładnie
  `S.bits` bitów; na grę budżetową najwyżej `beta.qs` wywołań (znaczniki
  `Program` są strukturalne; jedno `sample` na gałąź świeżego nonca);
  razem `beta.qs * S.bits` bitów = parametr bezpieczeństwa twierdzenia PRG.
  Dodatkowo: stan generatora56 Bajtów (2^448 stanów), blok ChaCha2064 B,
  refill4096 B =64 bloki; nonce320 bitów na zapytanie idzie z SHAKE (ta sama
  granica A2), nie z roszczenia ChaCha20.
- **Co faktycznie wykazaliśmy (to mocna część okna):** kształt — nazwany
  predykat i składnik szwu to **ten sam obiekt** (`ChaCha20PRFBound tau delta
  ↔ AdvPRG tau ≤ delta`, oba kierunki kernelowo, dokładnie ten sam `delta`),
  więc `hprg` wynika z założenia bez luzu; do tego wpięcie w konsumenta B5
  (`assembled_hardness_substitution_chacha` z predykatem zamiast surowej
  nierówności) oraz — nowość — **trasa (a) zamknięta twierdzeniem, nie tylko
  pomiarem**: strumień jest funkcją56-bajtowego siewu, więc
  `1 − 2^448/2^n ≤ AdvPRG`, i każdy `delta` spełniający założenie na realnej
  taśmie jest ≥ `1 − 2^448/2^n` (przy realnych długościach ~1).
- **Czego NIE rozstrzygnęliśmy (otwarte, zapisane wprost):** samego
  bezpieczeństwa ChaCha20 (niemożliwe — jest założeniem); odczytu
  statystycznego `deltaPRG` — ten jest ~1 i czyni składnik próżnym, więc
  realny sens ma wyłącznie odczyt obliczeniowy `Adv_PRG(ChaCha20)` przy
  podanej konsumpcji (trasa (b), decyzja właściciela); granica siewu (A2:
  równomierność /dev/urandom + siewu użytkownika, SHAKE jak ekstraktor) jest
  założeniem, nie dowodem; mostkowanie bajtowe A3/A4 i mass-floor zostają
  otwartymi nie-argumentami.
- **Co ten wynik zmienia w projekcie:** lista domykania B4_SYNTHESIS pozostaje
  bez `hprg` jako „okna do otwarcia” — to teraz gotowy, wpięty komponent
  z nazwanym założeniem i policzoną konsumpcją; księga mówi wprost, że
  warunek końcowy to standardowe PRF ChaCha20 przy `beta.qs * S.bits` bitów,
  a statystyczna wersja składnika jest uczciwie odrzucona twierdzeniem
  (2^448 granica nośnika). Przyszły teor idealnego PRNG skasowałby `deltaPRG`
  z montażu całkowicie.
- **Następny krok:** `hprg`/B2 nie blokuje dalszych szczebli — zostają
  `hshape` (B1.02, source3), `hattempt` (AttemptWeights) i `hkey` (B1.10).
  Dla porządku księgi warto przy odbiorze B2 sprawdzić odnotowaną obserwację
  o `falcon_prng_get_bytes` (frng.c:355 kopiuje od początku bufora; brak
  wywołań w przypiętym profilu — martwy przewód, ale żywy drut na przyszłość).

Mały lokalny commit wykonany według promptu (`git commit --only` o własnych
plikach), **bez push** (czekam na sygnał właściciela).
