# 114 — computable finite memory with original C-reference soundness

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. The continuous
three-point KeyGen program remains ACTIVE / NOT COMPLETE. This checkpoint
provides execution-checker infrastructure; it is not the concrete109
KeyGen Execution witness and does not establish Z>0 or p_accept>=1/4.

The natural-index bit trie has a proved injective key encoding and exact
lookup-after-insert behavior. Finite blocks interpret into the ORIGINAL
C99MemoryReference.Memory; their byte overrides are Option Byte, preserving
explicit uninitialized bytes even inside an otherwise zeroed service object.
No uninitialized read silently becomes zero.

The following computations have kernel proofs into the existing relations:
- byte update -> ShakeEncode.Store8, with size/permission preservation and
  exact outside-byte frame;
- readVec/read64/read32 -> actual initialized bytes and Load64/Load32;
- writeVec/write64/write32 -> every target byte and Store64/Store32, with
  exact frames, original allocation/width/write guards and little endian;
- checked copy -> original Memcpy, including separate source/destination
  extents, nonoverlap, initialized reads, permission and frame;
- checked fill -> original ShakeSeedMemory.Fill with its object/heap bounds.

These are soundness theorems for computed operations, not an arbitrary
postcondition interface. They use source-defined memory predicates without
weakening their guards. Allocation/lifetime and statement/callee execution
remain to be connected before the concrete native fixture can become a
kernel source witness.

Eleven closed kernel controls cover uninitialized, unaligned and out-of-range
reads; full-word and low/high-half little-endian results; untouched bytes;
overlap rejection, nonoverlap copy, read-only fill rejection, and an explicit
uninitialized override in a zeroed block. They supplement, rather than
replace, the universal source soundness proofs. No numerical/Sage experiment
was needed for these exact representation lemmas.

Final keygen_memory114_012: **7/7, stdout/stderr0/0**, six mathematical
modules and full audit of65 named declarations. Every full term/type DAG
roundtrip passed; only propext/Classical.choice/Quot.sound. Twelve jobs,
four failures retained: obsolete strong-induction name, unused simp lemma,
Tree namespace/lemma import collision, and a bound hypothesis requiring
substitution before simplification. No warning suppression or limit increase.
The representation refinement to Option Byte was followed by a coherent
five-module replay010, controls011, and final full replay012.

Parent:113 receipt907d29e9ca5d9282e4c4debf1f674c8674340f7fd721fc0303f6d3e5158a88e1,
postseal35af0f85303e89bf092de7b13ee2710105a084a9926a35a171c3624f0c43cce8
(28256pins). The owner-authorized113 manifest repair and all old evidence
remain sealed. No production edit, push, migration, independent review or
change to the five do_sign items. Continue with allocation/lifetime and
computable state/statement source soundness for the selected public seed9.
