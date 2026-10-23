# M5 — ENTRY_PINS-style schema for packet/env/seed vectors (SYNTHETIC draft)

**Status:** draft schema only (K1 ans 4: **no packet artifact pin exists**;
ans 5: `evaluate` **not** owner-accepted; ans 6: ENTRY_PINS pattern for
env/input). **No claim of canonical packet.** All vectors below are synthetic
spike material until R1 region 5 + witness (MAP M5 BLOCKED).

## Scope
Pin **what the spike can freeze today**: seed fixture bytes, env/input
interface objects, and — when R1 emits it — the post-emit packet bytes.
Do not pin `G_frag` outputs as if they were `G(seed*)` (TT55:9).

## Fields (per vector record)
| Field | Meaning | Required now |
|---|---|---|
| `vector_id` | stable id (e.g. `SEED9_SYNTH`, `ENV_PIN_DRAFT`, `PACKET_R1_PENDING`) | yes |
| `kind` | `seed` \| `env` \| `input` \| `packet_pk` \| `packet_sk` | yes |
| `synthetic` | always `true` until R1 witness; **false only with owner+R1 proof** | yes |
| `bytes_len` | seed **32**; pk **2881**; sk ≤ **10370** (buf 12289) — SOURCE (R5 §2 / ans 2) | yes |
| `seed_pattern` | synthetic recipe (e.g. `seed[i]=7i+3`) or `seed9` fixture label | seed only |
| `env_ref` / `input_ref` | names of `Env` / `Input env` objects (canonical env = `KeygenSeedPrefix092.Input`) | env/input |
| `sha256` | hash of exact bytes, **SHA-256** (match KEYGEN_*_PINS practice) | yes |
| `entry_sha256` | ENTRY pin in the sense of local `ENTRY182`/`ENTRY183` receipts | when formal track exists |
| `receipt` / `postseal` | JSON receipt + postseal SHA256 (KEYGEN_*_PINS pattern) | formal only |
| `fnv64` | optional spike-local cross-check (VECTOR_PINS style) | optional |
| `source_ref` | file:line or commit that produced/defines the bytes | yes |
| `witness_ref` | `evaluate env input seed = some (.inr packet)` proof id — **empty until R1** | packet |

## Hash algorithm
- **SHA-256** for all contractual pins (length, availability, already used
  in KEYGEN_*_PINS receipts). FNV-64 is **spike-local only** (VECTOR_PINS;
  note: PRSS `hash256` = 4×FNV, **not** SHA — do not conflate).
- Pin the **exact byte string**, not a pretty-print. Changing endianness or
  vector-pattern changes the pin (VECTOR_PINS rule).

## What to pin / what not to pin
**Pin:** seed 32 B fixture (public synthetic); env+input interface identity
(names + lengths + sha256 of serialized form once defined); pk 2881 B and
sk bytes **only after** R1 region 5 accepts `evaluate` on that seed.
**Do not pin / do not claim:** a “canonical packet” (ans 4: none exists);
`G_frag` 64 B as `G(seed*)`; accept-bit openings; any secret material.
On pin/hash/semantics conflict: **M8 stop-and-report** (owner decides).
