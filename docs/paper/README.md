# FT1536 research manuscript

## Draft 0.2 — 19 September 2026

**[Read the PDF: FT1536 — Design, Specification and Security Analysis](FT1536_specyfikacja_v0.2.pdf)**

Author: **Niirmata**. English research specification, 33 PDF pages.
Prepared with AI assistance using ASTRA 6 PRO, as reported by the project
author. The manuscript retains the Falcon implementation lineage and attribution.

Draft 0.2 describes the construction, algorithms, encodings, M0 contract,
verifier results, capacity bound, and conditional security-analysis structure.
Its own pinned research snapshot is:

| Identity | Commit / SHA-256 |
|---|---|
| Documentation snapshot | `f5266765c5f0733fb3ab6a5e2906aa44d15e17f7` |
| Integrated corrected core | `2959064e8132443649de50600b20bfc32ed618cb` |
| Candidate source manifest | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| PDF SHA-256 | `9f225d3d7ba2465d65c90a81f7f5a6417262ddf1334460c57485e1d672e15494` |

The PDF is preserved byte-for-byte as supplied by the author. Its snapshot
precedes the later H3_RANGE and H3_ZERO_SCALAR checkpoints. The
[current proof archive](../../proofs/ft1536/README.md) records those results
and the prepared H3_ROOT_LDL assignment. The draft's open obligations retain
their meaning at the stated snapshot; the newer results are documented separately.

The manuscript reports a research construction and its established interfaces;
it does not claim completed end-to-end unforgeability or a concrete security
level. The M0 wrapper remains a distinct specification layer.

To check this PDF's identity, run from `docs/paper/`:

```sh
sha256sum -c FT1536_specyfikacja_v0.2.pdf.sha256
```
