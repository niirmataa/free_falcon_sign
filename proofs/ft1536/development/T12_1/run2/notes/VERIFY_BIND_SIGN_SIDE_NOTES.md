# VERIFY_BIND — sign-side producer path (formalization notes, batch B3/X)

Extension of the B3/X window (owner's closing item): source-bound
extraction of the SIGN-side encoder entry (`falcon-sign.c:3412` producer
path) and an honest coverage map. Everything here is extraction/notes in
the style of the VerifyBind modules; no new claims beyond the cited lines.

## Pinned producer call chain (`Extra/c/falcon-sign.c`, sha256 `eee8d7dc…`)

1. **Key/context** — `falcon_sign_set_private_key` (`falcon-sign.c:3143+`):
   header `t cc g dddd`, then `falcon_decode_small` of f, g, F (and G) in
   due order (`:3184-3202`), strict consumption (`len != 0` → reject).
   **NOT formalized here** — key-material codec is rung B1 (Astra's, source3).
2. **Hash chain** — `falcon_sign_start` extracts a 40-byte nonce
   (`:3285`, `falcon.h:234`) and absorbs it; `falcon_sign_start_external_nonce`
   (`:3293-3298`), `falcon_sign_update` (`:3302-3305`): identical SHAKE-256
   (capacity 512) chain as the verifier. **Formalized** as `streamOf` +
   `HashToSpec` in `formal/VerifyBind/HashTo.lean` (shared by both sides).
3. **Challenge** — `falcon_sign_generate` (`:3308-3422`):
   `shake_flip(&fs->sc)` + `falcon_hash_to_point(&fs->sc, fs->q, hm, fs->logn)`
   (`:3322-3323`) — the SAME function and parameters as
   `falcon_vrfy_verify` (`falcon-vrfy.c:1514-1515`). **Formalized** as the
   rejection layer `scanValue`/`hashToPointOf`/`challengeOf` (HashTo.lean).
4. **Sampling loop** — `for(;;)` (`:3331-3406`): PRNG init from the SHAKE
   context (`:3349-3357`), `do_sign(...)` producing `(s1, s2)`
   (`:3362-3363`), then the norm gate `falcon_is_short(s1, s2, logn, ternary)`
   (`:3381`) with retry on failure (`:3403-3405`), capped by
   `SIGN_MAX_ATTEMPTS` (`:3333-3337`, availability only).
   **NOT formalized here** — sampler law is rung B4; `do_sign` internals and
   the PRNG (decision D2 route (b)) are other lanes.
5. **Norm gate consistency** — the gate is the SHARED function
   `falcon_is_short` (`falcon-enc.c:595-700`; ternary bound
   `FALCON_FT1536_NORM_BOUND2 = 2093922385`, `internal.h:163`). Producer
   acceptance (`:3381`) and consumer acceptance (`falcon-vrfy.c:1441`,
   `falcon_vrfy_verify_raw`'s return) call the same code with the same
   arguments, so the emitted `(s1, s2)` satisfies exactly the verifier's
   predicate. **Formalized side**: the predicate itself is `Geometry.Q < B`
   through `FileVerifier.decision_correct` (REUSE); the shared-C-function
   claim is extraction (same bytes, same call shape).
6. **Emission** — `falcon_encode_small(sig_buf + 1, sig_max_len - 1, comp,
   fs->q, s2, fs->logn)` (`:3412-3413`) of the 1536 coefficients of `s2`,
   then `sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn`
   (`:3418`), result `sig_len + 1` (`:3421`). **Formalized**: `encodeSig`,
   `sigHeader`, `encodeSmall` (ByteCodec.lean) with `encodeSig_consumed_*`
   = this emission is accepted by the modeled consumer.

## What this window does NOT cover (explicit)

- `do_sign` and the sampler distribution (samplerZ / sampler_large) — rung
  B4 (statistical certificate), plus the sampling law under D1 conditioning.
- The PRNG (`falcon_prng_init` from the SHAKE context, `:3352-3356`) —
  decision D2 route (b), `Adv_PRG` accounting — other lane.
- Private-key codec (`falcon_sign_set_private_key`) — rung B1 (Astra's, source3).
- Output-buffer failure path: `falcon_encode_small` returns 0 when
  `sig_max_len` is exceeded (`falcon-enc.c:111-113, 344-346`) and
  `falcon_sign_generate` then returns 0 (`:3414-3417`). The VerifyBind
  encoder is total (no buffer bound); the caller-visible failure shape is
  recorded here, not modeled.
- `SIGN_MAX_ATTEMPTS` loop cap and attempt-count observability — the cap is
  availability only (D1 refinement (i)); observable retry traces are the A1
  theorem-hypothesis matter of the scope document.
- `falcon_is_short`'s binary branch (q = 12289) — outside the pinned
  FT1536 profile (same boundary as the B3 package).
- `falcon_compute_public` / `falcon_complete_private` (`falcon-vrfy.c:1521+`)
  — key-generation side (rung B1).
