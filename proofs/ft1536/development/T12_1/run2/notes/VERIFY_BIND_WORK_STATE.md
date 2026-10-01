# VERIFY_BIND (rung B3) — WORK_STATE of the verify-path binding window

Task: `notes/PROMPT_VERIFY_BINDING_B3.md` (this window). Scope pin:
`development/T12_1/END_TO_END_SCOPE.md` at commit `1ec29f7b` (last change;
window HEAD at start `82cb8467`). Workspace: `proofs/ft1536/development/T12_1/run2/`.

Pinned sources (sha256 verified byte-exact at window start):

- `Extra/c/falcon-vrfy.c`  `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`
- `Extra/c/falcon-enc.c`   `0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05`
- `Extra/c/falcon-sign.c`  `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8`
- `Extra/c/falcon.h`       `657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519`
- `Extra/c/internal.h`     `512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5`

## Step 1 — EXACT final target types (drive the work; adjust = record here)

Profile: FT1536 = ternary, logn = 10, q = 18433, n = 1536, hn = 768,
signature header `fb = (1 << 7) | (comp << 5) | 10` (`comp = 0` raw /
`comp = 1` static), decode coefficient count 1536.

```lean
-- objects (real names, REUSE layer: FT1536.Geometry / FT1536.Relation)
def  FT1536.VerifyBind.decodeSig   : Bytes → Option (List ℤ)
def  FT1536.VerifyBind.sigVector   : Bytes → Option Geometry.Vec
-- byte-level verdict, source-shaped (falcon-vrfy.c:1283-1518):
inductive FT1536.VerifyBind.Outcome | valid | invalid | malformedSig | malformedKey
def  FT1536.VerifyBind.Outcome.code : Outcome → ℤ    -- 1 / 0 / -1 / -2 (C returns)
def  FT1536.VerifyBind.verdict (keyDecoder : Bytes → Option Relation.Rq)
     (hashTo : Bytes → Relation.Rq) (pkBytes msg sigBytes : Bytes) : Outcome

-- (1) A3 as a THEOREM — verdict = Relation.Verify:
theorem FT1536.VerifyBind.verdict_valid_iff ... :
    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.valid ↔
      ∃ h s, keyDecoder pkBytes = some h ∧ sigVector sigBytes = some s ∧
        Relation.Verify h (hashTo msg) s

-- malformed coverage (modeled reject; no UB, no silent success):
theorem FT1536.VerifyBind.verdict_valid_decodes ...
theorem FT1536.VerifyBind.malformed_key ...
theorem FT1536.VerifyBind.malformed_sig ...
-- decoder totality (no third outcome):
theorem FT1536.VerifyBind.verdict_total ...
theorem FT1536.VerifyBind.decoded_or_rejected ...

-- (2) A4 signature round-trip (falcon-enc.c small-vector codec):
theorem FT1536.VerifyBind.static_decode_encode ... -- decodeStatic ∘ encodeStatic = id
theorem FT1536.VerifyBind.static_encode_injective ...
theorem FT1536.VerifyBind.none_decode_encode ...
theorem FT1536.VerifyBind.encodeSig_consumed ...   -- producer bytes accepted by decodeSig
theorem FT1536.VerifyBind.encodeSig_injective ...
```

Adjustments vs the prompt's suggested shape (recorded, not silent):

1. `Relation.Verify` takes the hash target `c : Rq`, not raw message bytes. The
   message enters through `hashTo : Bytes → Rq` = `falcon_hash_to_point` over
   the injected stream `msg = r ++ message` (`falcon_vrfy_start` + `update` =
   `shake_inject` of the concatenation). The SHAKE/hash-to-point law itself is
   the ROM interface (A2/B5), consumed here as a parameter — not re-modeled.
2. Key-material decoding (sk/pk) is rung B1 (HERS, source3). `keyDecoder` is
   a consumed parameter of `verdict`; no key-codec lemmas here.
3. "Legal memory, source execution" is carried by the REUSE layer
   (`Run2.FileVerifier.decision` = the file/bit verify program with
   `VerifierAllocation` bounds); `verdict` is defined through `decision`, not
   through the expected theorem.

## Source/model boundary (this window)

- Codec: `falcon_encode_small`/`falcon_decode_small` (`compress_none`,
  `compress_static`, `uncompress_none`, `uncompress_static`) modeled at the
  bit-stream level (MSB first), byte flushing = `pack` (right zero padding of
  the final partial byte). The C caller-side exact-consumption checks
  (`falcon-vrfy.c:1505`: `falcon_decode_small(...) != len`) are part of
  `decodeSig` (reject on trailing bytes / nonzero padding).
- C `int16_t` casts = `wrap16` two's complement wrap (A5 machine model). The
  C value expression `-(int16_t)lo` equals `wrap16 (-lo)` on the reachable
  range `lo ≤ 65535` (`ne ≤ 255` enforced by `uncompress_static`).
- `falcon_vrfy_verify_raw` computes `s1 := h·s2 − c` (falcon-vrfy.c:1419),
  while `Relation.extract` keeps `c − h·s2`. The two differ by full
  negation of `s1`; `Geometry.Q0` is even under full vector negation
  (`block (−x) (−y) = block x y`), so the compared norms coincide. A helper
  lemma `q0_neg` records this; without it the sign flip would be a silent
  assumption.
- NTT/Montgomery internals (`mq_NTT`, `mq_poly_tomonty`) are representation
  only; identified with the canonical `Rq` operations via the REUSE chain
  (`PolynomialMachine`/`PolynomialReference` consumed by
  `FileVerifier.decision_correct`) and `formal/FftBind/NttSemantics`.
- `Geometry.B = 2093922385 = FALCON_FT1536_NORM_BOUND2` (internal.h:163);
  `Geometry.Q` = the `falcon_is_short` ternary quadratic form
  (`Σ a[u]² + Σ a[u]·a[u+768]` per vector, pairs (i, i+768)); `Geometry.center`
  = the `verify_raw` s1 normalization (falcon-vrfy.c:1429-1435).

## Findings kept (uncomfortable results preserved)

- The static codec decoder is NOT injective on raw byte strings: the sign
  bit is not canonical. Aliases exist at 0 (`±0`) and at −32768 (where
  `wrap16 32768 = −32768` collides with the signed encoding). The truthful
  injectivity statement is: `encodeStatic` injective, `decodeStatic ∘
  encodeStatic = id` on int16 inputs, hence `decodeStatic` injective on the
  image of `encodeStatic` (canonical encodings). Witness lemmas included.
- `compress_none` round-trips only coefficients in `[-9216, 9216]`; outside
  (still int16) `uncompress_none` rejects (falcon-enc.c:443). So comp-0 is a
  strict sub-codec of comp-1 on the value domain; `falcon-sign.c:3412` emits
  `comp` chosen by the caller (tests/tool use `FALCON_COMP_STATIC`).

## Hard rules in force (from GAME_BINDING_WORK_STATE)

- ZERO `sorry`/`admit`/`native_decide`, also in drafts; drafts live in the
  conversation. On garbage in an edit: restore clean state immediately.
- No long inline expressions in theorem statements: `def` helpers first,
  small pointwise identities, then compose.
- Serial compiles through `tools/original/run_lean_guarded.sh`; forbidden
  tactic grep before EVERY compile; logs 0 err / 0 warn.
- `neg_mul` direction trap; `rw` rejects defeq-but-not-eq types (bridge with
  `Eq.trans` + `exact … rfl`); `show` after `funext`; per-piece casts;
  complete `open` lists; no extra tactics "just in case".
- English for comments/docstrings/commit messages (crypto register).

## Batches

### 2026-10-01 — batch B3-1: the rung B3 package lands (this window)

`formal/VerifyBind/` (all four modules compile 0 err / 0 warn, empty logs,
guarded serial compiles, forbidden-tactic grep before every compile):

- `StaticCodec.lean` — `wrap16`/`int16` (the C int16 casts, A5), MSB-first
  bit groups (`beBits`/`beVal` from the proved LSB primitives), `codeWord`,
  `parseCont`/`takeBits`/`parseWord`/`parseStatic`/`decodeStatic`; core:
  `parseWord_codeWord`, `parseStatic_encode`, `decodeStatic_encode`,
  **`static_decode_encode`** (A4 round trip), **`encodeStatic_inj`**
  (injectivity), `decodeStatic_cases` (totality). Kept findings:
  `static_alias_zero`, `static_alias_wrap`.
- `ByteCodec.lean` — packer layout (`packChunk`/`chunk8`/`padTail`/`pack`/
  `unpack`, key lemma **`unpack_pack`**), the raw 16-bit variant
  (`u16`/`s16be`/`wordBytes`/`decodeNoneAux`/`decodeNone`/`encodeNone`;
  **`none_decode_encode`**, `encodeNone_inj`), the signature framing
  (`Comp`/`sigHeader`/`compOf`/`decodeSig`/`encodeSig`; **`encodeSig_consumed_static`**,
  **`encodeSig_consumed_none`**, `encodeSig_inj_static`, `encodeSig_inj_none`),
  `decodeSig_length`, `decodeSig_mem_int16`, `decodeSig_cases`, `toVec`,
  `sigVector`.
- `Verdict.lean` — `Outcome` (valid/invalid/malformedSig/malformedKey with
  the C return codes), `verdictCore`, `verdict`; **`verdict_valid_iff`**
  (A3 becomes a theorem), `verdict_valid_decodes` (no silent success),
  `malformed_key`/`malformed_sig`, `verdict_total`, `decoded_or_rejected`
  (no third outcome); `wordsOfVec`/`wordsOfVec_represents` bridge to the
  file/bit program; `q0_neg` (s1 sign-convention record).
- `Audit.lean` — `#print axioms` of 15 key declarations: all within
  `[propext, Classical.choice, Quot.sound]` (two strictly smaller).

Headline statement (realized shape):

    verdict keyDecoder hashTo pkBytes msg sigBytes = Outcome.valid ↔
      ∃ h s, keyDecoder pkBytes = some h ∧ sigVector sigBytes = some s ∧
        Relation.Verify h (hashTo msg) s

Consumed REUSE (no parallel models): `Run2.FileVerifier.decision` +
`decision_correct` (the file/bit verify program refined to `Verify`),
`VerifierInputs.fieldEncoding(_length/_represents)`, `BitArithmetic`
word primitives, `FT1536.Relation`/`FT1536.Geometry` from committed stages.

### Findings kept (uncomfortable results)

- The raw decoder is NOT injective on strings: the sign bit of zero is not
  canonical and the int16 wrap collides at −2^15 (`static_alias_zero`,
  `static_alias_wrap`). Truthful statement: encoder injective,
  `decode ∘ encode = id` on the int16 domain, decoder injective on the
  encoder image (canonical encodings).
- `compress_none` round-trips only `[-9216, 9216]` (the source's own
  acceptance range, `falcon-enc.c:443`); outside it the decode rejects.
  Comp-0 is a strict sub-codec of comp-1 on the value domain.
- The static decoder accepts non-canonical strings (`±0`, wrap alias);
  exact-consumption still holds (zero padding + no trailing bytes).

### Source/model boundary (as realized)

- Byte flushing of the C packer = `pack` (right zero padding of the final
  partial byte); the ≤16-bit window invariant argument recorded in
  `StaticCodec.lean` docstrings.
- C `int16_t` casts = `wrap16` exactly (including `-(int16_t)lo` on
  `lo ≤ 65535`, the reachable range under the `ne ≤ 255` check).
- `falcon_vrfy_verify_raw` computes `s1 := h·s2 − c` while
  `Relation.extract` keeps `c − h·s2`; `q0_neg` records that `Geometry.Q0`
  is even under full negation, so the compared norms coincide.
- NTT/Montgomery internals identified with the canonical `Rq` operations
  through the consumed REUSE chain (`PolynomialMachine`/`PolynomialReference`
  via `decision_correct`); `formal/FftBind/NttSemantics` covers the tables.
- Key-material decoding (sk/pk) = rung B1 (HERS): consumed as `keyDecoder`.
- Hash-to-point (`falcon_hash_to_point` over `r ‖ message`) = ROM interface:
  consumed as `hashTo : Bytes → Rq`. Both remain parameters of `verdict`;
  closing B5 plugs the concrete B1 decoder and the ROM map in.

### Open items (explicit)

1. Consume the B1 key decoder when source3 lands; replace the `keyDecoder`
   parameter (no key-codec lemmas here, by design).
2. The `hashTo` parameter needs its own binding to `falcon_hash_to_point`
   (SHAKE-256, rejection sampling to q) at the ROM interface — not part of
   B3's verdict/serialization claim.
3. Signature codec covers the coefficient vector `s2` of the FT1536
   profile (1536 values, comp 0/1); comp 2/3 are modeled reserved/reject,
   matching `falcon-enc.c:553-559`.
4. `falcon_is_short`'s binary branch (q = 12289) is out of the pinned
   profile; only the ternary logn = 10 path is modeled.

### Lekcje (kolejne partie niech korzystają)

- `rcases e with - | a b` nie związuje drugiej nazwy (auto `tail✝`) — dla
  list używać `cases hb : e with | nil | cons a bs` (nazwy działają).
- W ciałach wzorców `| pat => by ...` parser `|` jest zdradliwy (linie z
  `|` w taktykach potrafią rozwalić blok) — tam trzymać się `simp`/`rw`.
- `show T at h` NIE istnieje — tylko `show T` dla celu; dla hipotez
  `have h2 : T := h` (defeq).
- `rw` nie sięga przez cieńowanie zmiennych w ramionach `match` — klasyczny
  wzorzec to pomocniczy „core" jako ZWYKŁA aplikacja (`verdictCore`) +
  `verdict_eq` + `rw` na scrutinee + `show`-mosty defeq.
- `split_ifs at h` bywa zawodne przy zagnieżdżonych `if`; `by_cases` +
  pełne `simp [hc]` jest przewidywalne. `if_pos`/`dif_pos`/`if_true` są
  zdeprecjonowane (0/0 wymaga nieużywania ich).
- `rw` zamyka przez `rfl` tylko czasem (nie przez iotę `match`) — planować
  jawne domknięcia lub `show`-defeq.
- Reguła z WORK_STATE o śmieciach w edycjach zadziałała raz: `sorry`
  wylądował w szkicu i został usunięty natychmiast przez guard-grep przed
  kompilacją. Guard jest obowiązkowy — łapie także takie przypadki.
