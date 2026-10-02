# FT1536 — C code findings ledger

Opened: 2026-10-02. Discovered during formal source binding (T12.1),
confirmed by independent batch review the same day. This ledger records
defects found in the C sources BY THE PROOF WORK. Pinned source bytes are
FROZEN and must not be edited to fix these findings; fixes belong to
future C candidates, which then get their own pins. Proofs that bind to
the pinned bytes remain valid exactly as stated.

Status vocabulary: `LATENT` (real defect, unreachable in every examined
profile), `LIVE` (reachable), `FIXED-CANDIDATE` (fixed in a future
candidate, pinned there).

---

## F-001 — `falcon_prng_get_bytes` copies from the buffer start, not the cursor

- Status: **LATENT** (all profiles, whole lineage)
- Severity if ever activated: **critical** (the caller receives wrong
  "random" bytes — duplicated buffer prefix instead of the stream tail;
  for a signer this would mean biased/correlated nonces)
- Found by: B2/AdvPRG window while source-binding the tape law of the
  sampler stream (the get_u8/get_u64 draw path); confirmed by coordinator
  batch review 2026-10-02.

### Exact defect

In `Extra/c/frng.c` (pinned sha256
`4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644`),
lines 342-363, `falcon_prng_get_bytes`:

```c
clen = (sizeof p->buf.d) - p->ptr;      /* available bytes FROM offset ptr */
if (clen > len) { clen = len; }
memcpy(buf, p->buf.d, clen);            /* <-- BUG: copies FROM OFFSET 0 */
buf += clen;
len -= clen;
p->ptr += clen;                          /* cursor advances as if correct */
```

The source pointer must be `p->buf.d + p->ptr`. As written, the function
copies `buf.d[0..clen)` while consuming from offset `ptr`. It is correct
ONLY when called with `p->ptr == 0` and `len <= sizeof p->buf.d`. In
every other case — entry with `ptr != 0` (after any `get_u8`/`get_u64`
draws) or a `len` spanning a refill — the caller receives stale/duplicated
prefix bytes instead of the ChaCha20 stream.

### Lineage — inherited, not introduced here

The identical statement exists in every Falcon-family copy in this
repository (call-site census 2026-10-02):

| Copy | Location |
|---|---|
| `Reference_Implemention/falcon512/frng.c` | line 222 |
| `Reference_Implemention/falcon768/frng.c` | line 222 |
| `Reference_Implemention/falcon1024/frng.c` | line 222 |
| `Optimized_Implemention/falcon512/frng.c` | line 222 |
| `Optimized_Implemention/falcon768/frng.c` | line 222 |
| `Optimized_Implemention/falcon1024/frng.c` | line 222 |
| `Extra/c/frng.c` | line 355 |

This places the defect in the upstream Falcon reference/optimized
lineage as vendored here — it is an inherited latent bug, not a local
regression.

### Reachability — dead pipe in every examined profile

`grep` census over `Reference_Implemention/`, `Optimized_Implemention/`
and `Extra/c`: `falcon_prng_get_bytes` has ZERO call sites. The function
is declared in `internal.h` and defined in `frng.c`, and never called:
the sampler draws exclusively through the indexed, correct primitives
`falcon_prng_get_u8` / `falcon_prng_get_u64` (inlined in `internal.h`,
cursor-correct). The pinned FT1536 signing profile (`Extra/c`) therefore
never executes the defective statement. The formal tape model in
`T12_1/run2/formal/AdvPrg.lean` binds the draw path exactly through
`get_u8`/`get_u64`, matching the reachable code.

### Fix (for a future C candidate — one line)

```c
-		memcpy(buf, p->buf.d, clen);
+		memcpy(buf, p->buf.d + p->ptr, clen);
```

plus a regression test that consumes a few bytes via `get_u8`/`get_u64`,
then requests `get_bytes` of a length spanning a refill, and compares
against the independently expanded ChaCha20 stream.

### Binding note

The pinned bytes stay as they are: B1/source3 and AdvPrg bind to exact
lines of the pinned `frng.c`, and historical pins are never rewritten.
Because the defect is unreachable in the pinned profile, no existing
theorem's scope is affected. A fixed candidate receives NEW pins and its
own source binding; both bindings remain true statements about their
respective bytes.

---

(Future findings append below as F-002, F-003, ...)
