# External reference identification

## Grover (C20)

Lov K. Grover, *A Fast Quantum Mechanical Algorithm for Database Search*,
Proceedings of STOC 1996, pp. 212–219. Versioned author preprint:
https://arxiv.org/abs/quant-ph/9605043v3 (19 November 1996).
Metadata and abstract inspected at https://arxiv.org/abs/quant-ph/9605043
on 2026-10-06. The abstract states that search takes `O(sqrt(N))` steps.
The paper uses this only for the conventional 256-bit search-space / 128-bit
quantum exponent comparison. It is not a Lean result, a gate-cost model,
a QROM reduction or a proof that a concrete deployment achieves either level.
The 256/128 reporting convention is explicitly requested in the binding
outline, section 8. `tools/check_numbers.sage` performs the exact arithmetic.

## Falcon specification and API (C13)

The locally archived PDF identifies itself as specification v1.2,
1 October 2020; authors and title are transcribed in `refs.bib`.
The round-3 ZIP is separately pinned in `SOURCES.sha256`.
Member `falcon-round3/Extra/c/falcon.h`, SHA-256
`dad8ed7c0dd2a69128d3f70df6fdd1775e89199de3f1f5dc972fbab5954d35f1`:

- lines 127–145: COMPRESSED, PADDED and CT formats;
- lines 133–138 and 268–274: fixed-size padding and generation retries;
- line 162: degree 512, padded size 666;
- lines 335–338: `FALCON_SIG_PADDED_SIZE` macro.

This is a different API/source generation from the project's vendored
`Reference_Implemention/*/frng.c`. The C findings ledger's inherited
buffer-cursor defect must not be attributed to this round-3 archive without
a separate source check. No such attribution is made in the article.

## Literature context entries (section 10, form pass 2026-10-10)

The following bibliography entries were added for professional context
in section 10. Each was verified against public bibliographic metadata
on 2026-10-10 before being cited; none is a claim of comparable
guarantees, and no entry was added without a located primary record.

- `falcon2018` — Fouque, Hoffstein, Kirchner, Lyubashevsky, Pornin,
  Prest, Ricosset, Seiler, Whyte, Zhang, *FALCON: Fast-Fourier
  Lattice-based Compact Signatures over NTRU*, the NIST PQC submission
  document as cited by the literature (falcon-sign.info). No separate
  2018 peer-reviewed proceedings paper by that title/author list was
  identified; the submission document is what is cited. The pinned
  local specification v1.2 remains `falcon2020`.
- `hps1998` — Hoffstein, Pipher, Silverman, *NTRU: A Ring-Based Public
  Key Cryptosystem*, ANTS 1998, LNCS 1423, pp. 267–288.
- `gpv2008` — Gentry, Peikert, Vaikuntanathan, *Trapdoors for Hard
  Lattices and New Cryptographic Constructions*, STOC 2008, pp. 197–206.
- `lyu2012` — Lyubashevsky, *Lattice Signatures without Trapdoors*,
  EUROCRYPT 2012, LNCS 7237, pp. 738–755.
- `dilithium2018` — Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe,
  Seiler, Stehlé, *CRYSTALS-Dilithium: A Lattice-Based Digital
  Signature Scheme*, IACR TCHES 2018(1), pp. 238–268.
- `fktwy2020` — Fouque, Kirchner, Tibouchi, Wallet, Yu, *Key Recovery
  from Gram-Schmidt Norm Leakage in Hash-and-Sign Signatures over NTRU
  Lattices*, EUROCRYPT 2020, Part III, LNCS 12107, pp. 34–63
  (ePrint 2019/1180).

The full comparison survey (GPV/NTRU/BLISS/Falcon reductions, verified
compilers, estimator conventions) remains an explicit TODO before any
ePrint submission; uncertain items stay TODO and are not cited.
