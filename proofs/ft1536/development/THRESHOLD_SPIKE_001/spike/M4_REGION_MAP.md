# M4 — regions 2–4 map + MPC cost model (working; region map UNCONFIRMED by R1)

**Status:** draft for ans 3. Region numbering follows KEYGEN_R1_TAIL_TODO.md
(owner order). Parent labels in parentheses. Loop counts marked SOURCE vs
ESTIMATE. No region map is accepted until R1 confirms (ans 3).

## Region 2 — NTT tail (NTT)
| Item | Calls / structure | Loop count | Where |
|---|---|---|---|
| first pass | `firstBody` butterfly X²−X+1 (`montymul(a1,r)`, add/sub stores); `firstLoop` | **768** first butterflies (u=0..768, hn=768, n=1536) — SOURCE | R1_TAIL 2.C; NTT_FIRST_182 (`NttFirstLoop182.full`) |
| mid passes | `midPasses` / `FftLoop141`+`FftGroups143`+`FftOuter144`; `NttBinaryBody183` | **8 rounds** t: 768→384→192→96→48→24→12→6 — SOURCE (R1_TAIL 2.D); NTT_MIDDLE_183 lists (m,t)=(2,768)…(512,3), end m512/t3 | R1_TAIL 2.D; NTT_MIDDLE_183 |
| mid butterflies | same bodies | **~6144** (≈ n/2 per round × 8) — **ESTIMATE** | not counted in sources |
| tripling | `tripleLoop` / `FftTripling148`+`FftTripleBody147`; `w=montysqr(gm_square[1])` | **512** triple-butterflies (u→1536, v→1024) — SOURCE | R1_TAIL 2.E; NTT_MIDDLE_183:53 |
| mkgm3 (region 1d, prior) | `mq_mkgm3` suffix loops + gm0/w/igm0 | **256/256/255** loops — SOURCE (CLOSED) | R1_TAIL region 1d table |

Call chain: `mq_NTT_ternary` → `mq_mkgm3` → tail first/mid/triple (PublicForward 159). PREFIX COMPLETE through mid; triple + 2nd call OPEN (NTT_MIDDLE_183).

## Region 3 — suffix 1537 10 (root solver in parent label; local = pre-root suffix)
| Item | Calls | Notes | Where |
|---|---|---|---|
| zero tests | `t[u]==0` branches | not assume | R1_TAIL region 3 |
| CRT-ish stores | `mq_div_18433` on nonzeros | div-by-18433; NTRU fG−gF=18433 gate | R1_TAIL; Z_LOWER gates |
| inverse | `mq_iNTT` | layers already named `KeygenPublicInverseCalls` / `KeygenPublicReverseCalls` | R1_TAIL |
| return | `return 1` | nonzero public return | R1_TAIL |
| status | OPEN | no body constructed locally | R1_TAIL |

## Region 4 — root solver + CRT + certificate + codec
| Item | Calls | Notes | Where |
|---|---|---|---|
| root entry | `SelectedRootEntry175`, `solve_NTRU` binding, `SelectedDeepestEntry175` | prologue/deepest setup SOURCE; bodies OPEN | ROOT_ENTRY_175 |
| open solver body | `make_fg`, **CRT**, Bezout, deepest muls, intermediate/depth0, root validate/return1 | explicitly OPEN | ROOT_ENTRY_175:48-49 |
| search | `SelectedAttemptPrefix156.continue_search` | constructive continuation; attempt loop length **OPEN** (retry/t_max) | R1_TAIL region 4 |
| certificate | certificate gate; `from_sampled` (104) | leaf cert of Z_LOWER acceptance chain | CERTIFICATE_104; Z_LOWER |
| codec | `KeygenMakeProgram.encoding` tails (106) | pk **2881 B**, sk ≤ **10370 B** (ans 2) | CODEC_106; K1 ans 2 |
| boundary | “this is NOT yet G(seed*)” | explicit | R1_TAIL region 4 |

## MPC cost model (assumptions labeled)
Model (ans 3): **muls on shares per region** are the allowed cost unit. Two primitives (I1): **reshare** = `mul_shamir_reshare`
(~O(n·k) gf_mul, 1 deal round); **Beaver** = `generate_triple_shares`
(1 triple ≈ 1 AND; 2 mask openings).

| Region | mul-kind (assumed) | muls/region (order) | Label |
|---|---|---|---|
| R2 NTT | field `montymul` on shares = **1 reshare-mul** or 1 Beaver per mul (A1) | first 768 × ~1 mul + mid ~6144 × ~1 + triple 512 × ~3 ≈ **~1.3×10⁴ mul** (A2: butterfly ≈ 1 montymul + local add/sub) | **ESTIMATE** (counts of butterflies SOURCE; mul-per-butterfly ASSUMPTION) |
| R3 suffix | compares `t[u]==0` → Beaver (accept_bit style 255/bit is upper, I1); `mq_div_18433` ≈ 1 mul-inversion chain; `mq_iNTT` ≈ R2-sized | **~10³–10⁴ mul** + ~n compares | **ESTIMATE**; iNTT size from n=1536 (A3: iNTT ≈ one inverse NTT) |
| R4 solver+CRT+cert+codec | `make_fg`/CRT/Bezout = poly muls (reshare); cert/codec = mostly linear encode + hash; search retries | **OPEN** — attempt count / depth0 gates not bounded locally; do not invent a number | **UNKNOWN** (open body) |

Assumptions: A1 = Shamir mul on shares priced as 1 reshare-mul (G_frag 1/B
pattern) OR 1 Beaver triple if masked; pick one and keep consistent. A2 =
one `montymul` per butterfly, adds local/free (I3: XOR/add free). A3 = inverse
NTT same butterfly count as forward. No opening of secret shares in this
model. Reshare vs Beaver: algebra field muls → reshare OK for cheaper redeal
when n,k small; any **comparison/predicate** (zero tests, accept bits) →
Beaver (I1: 255 triples/bit for `accept_bit`; t_max-window select 259/bit).
XOF/SHAKE stays outside R2–R4 (I3: dominates, 10⁵–10⁷ × G_frag) — regions
here are the cheap algebra tail per K1 ans 1/3.

**Not claimed:** no R1 confirmation of this region split; no benchmark;
R4 unbounded. Region map = do potwierdzenia przez R1 (ans 3).
