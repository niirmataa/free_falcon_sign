# 073 development step — physical decoder rules and NONE source frame

Owner-expanded TODO remains IN_PROGRESS. This is a small source step,
not a midpoint close, B1.08 Acceptance, independent review or final report.
Base checkpoint52R /3619a22d;15815 unchanged entry pins.

Eight new proof modules and their audit are checked with clean0/0 logs.
The audit contains75 declarations:71 new and4 inherited;62 complete terms
and13 kernel inductives, only standard axioms, no elisions.

- `KeygenDecodeNoneFrame.source_frame` consumes a finite defined execution
  of the complete pinned NONE body and an actual destination pointer, then
  derives preservation of allocation metadata and bytes outside that physical
  array. It has no desired output, length, successful return or frame premise.
- `KeygenDecodeMemory.store_readback` derives the exact little-endian int16
  word from an actual physical store.
- `KeygenDecodeMemory.store_same_memory` proves that storing the represented
  word already present restores every byte and metadata of that memory.
- The decoder rules now include real allocated initialized byte loads and
  typed allocated writable int16 stores. Pointer/cell/scope helpers and pure
  expression inversion are checked; these definitions alone do not establish
  the existence or correctness of the complete decoder.

The full source NONE memory inverse remains OPEN. In particular the actual
encoder stream must be read by the decoder, each guarded source scalar
calculation must recover the same input, and all1536 stores/loop/return must
compose. The earlier pure pair-stream inverse is not that missing theorem.
STATIC, mathematical/physical transport and public LAST remain subsequent.
No desired codec facts were inserted as premises.

Jobs001–011 are retained, with native streams/snapshots/receipts and causes
in the paired JSON. Mixed005 and010 retain their accepted prefix modules.
The outer sandbox's NETLINK_ROUTE refusal001 was followed by authorized
outer execution with unchanged inner bwrap and limits. No automatic approval
review rejected an action. No linter, proof limit or guard was weakened.

Source commit06392f4f; separate pin commit follows. No push, independent
review, subagent, relay, migration, archive import or production-C edit.
