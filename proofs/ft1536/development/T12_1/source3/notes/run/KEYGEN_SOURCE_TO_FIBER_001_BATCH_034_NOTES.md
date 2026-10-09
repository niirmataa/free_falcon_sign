# BATCH_034 — B1.06 actual rev10 / source last-row entry midpoint

2026-10-09,GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**B1.06 Acceptance NOT MET.** Expanded recoverable midpoint under
`run2/notes/B1_STAGED_ROADMAP.md`. B1.05 remains closed at BATCH_032;
B1.07 is not entered. The stage is NOT narrowed to these internal helpers.

## 1. Entry, ownership and unchanged predecessor

BEFORE edits/jobs,the committed BATCH_033 verifier checked BATCH_015–033:
**5308 distinct pins,571 current inputs,no supersession,no active job**.
Entry `.build/levels_034/ENTRY_PINS_034.json`,SHA256
`53d81c7181148871c32177a3af7a7dbe80e960096fbeb8b1d7ce16ac5cf3cc9a`.
Preseal checked the identical predecessor bytes,receipt
`.build/levels_034/PRESEAL_PREDECESSOR.json`,SHA256
`d071cae15ab9991dc32b97ad201f3a8e8827b7983fc6d6a28f95635c59284aa4`.
Sources are pinned M0 inputs,not live `Extra/c`. No BATCH_015–033 source,
report,receipt or manifest was edited. Concurrent other-lane documentation
commits and foreign worktree changes/staging were preserved. Local owned
commits use main/niirmataa and the shared archive.lock; no push.

## 2. Checked results and exact local boundaries

Seven new proof modules have current guarded0/0 streams:

- **KeygenPublicScalarControl:** proved scalar-only projection of the actual
  modular execution,including loops,abrupt returns and scope restoration.
  Array/call operations are not silently lowered.
- **KeygenPublicRev:** COMPLETE actual public rev10 function,its real parser
  grouping,signed32 i,unsigned32 x/y,and actual parameter/return conversion.
  Every uint32 input's finite source return equals the ten-step word result.
  The ten iterations are derived from guards/increment,not supplied as a trace.
- **KeygenPublicRevCert:**64 kernel chunks ×16 indices cover ALL1024 reached
  domain inputs;four named assembly blocks keep full terms printable. Actual
  source returns equal bitrev10;the2*u calls specialize to reverse9 with
  result<512. The solver's static REV10 equality is not substituted for this
  function-execution proof. The Decidable instance is explicitly named/audited.
- **KeygenPublicTableAtoms:** actual scalar-expression/statement inversions;
  signed literal U32 conversion,complete source mul/division calls,typed local
  assignments/declarations and exact guard/post-increment results.
- **KeygenPublicTableSeed:** COMPLETE generator partition with every statement
  retained. SAME logn10 execution derives g conversion,one squaring,terminal
  k=12 and canonical/scaled ig via the complete checked division chain. At
  this source entry,heap/arrays/globals/static tables are unchanged.
- **KeygenPublicTableRows:** SAME complete execution selects the actual else
  branch and derives the last-row entry x/ix,g2/g4,ig2/ig4. Both directions'
  radix-scaled root powers are conclusions. Scope b/rest/normal flow and the
  remaining source execution are retained. No generated table image is a premise.
- **KeygenPublicTableCells:** correct two-byte Store16/Load16,canonical
  narrowing,unsigned promotion to int32 followed by U32 conversion,and
  same-array/separated-table byte preservation. Local cell adapters ONLY;
  these lemmas do not populate the complete tables.

The rev10 boundary is:

```text
x : BitVec32; v : C99IntegerReference.Value
source : KeygenPublicScalar.Call (name rev) [uint32 x] v
-------------------------------------------------------------------
v = uint32 (KeygenPublicRev.reversed 10 x 0)

x.toNat < 1024
-------------------------------------------------------------------
v = uint32 (ofNat32 (KeygenRev10.bitrev10 x.toNat))
KeygenRev10.bitrev10 x.toNat < 1024
```

The source generator entry is exactly:

```text
s : C99ArrayReference.State; out : C99ProcedureReference.Result
profile : KeygenPublicTableAtoms.Slot s "logn" (10#32)
source : KeygenPublicExec.Exec KeygenPublicSource.program []
  (KeygenPublicSource.code generate) s out
-------------------------------------------------------------------
exists after inner,
  Exec program [] KeygenPublicTableRows.remaining
    (KeygenPublicTableRows.ready (KeygenPublicTableSeed.ready s)) inner
  and after = restoreScope (KeygenPublicTableSeed.ready s)
    inner.state ["b"] []
  and inner.flow = normal
  and Exec program [] KeygenPublicTableRows.afterRows after out
```

`remaining` is the actual source849–860;k/b/u initialization and all paired
last-row stores are STILL executions to be refined. `afterRows` is actual
863–884:cubing/upward rows,gm0 copy and exceptional igm0 division. Entry
states and all eight seed words are explicit defs,not desired table images.
Owned/local declaration premises of internal adapters are DERIVED in the
full `source_last_row_entry` theorem. Its only value-domain input is the
local logn10 profile; binding from the enclosing public caller remains part
of complete B1.06 composition. No final f/g/h equation or fInv is produced.

## 3. Full internal audit and finite controls

The final internal audit is accepted with0/0 streams:
**271 entries =236 named new declarations +35 inherited interfaces;
255 complete terms +16 kernel inductives/structures with constructor types;
standard axioms only,zero elisions.**580 current source inputs. Artifact
7749410 bytes,retained in `.build/jobs/keygen_public_tables_audit_034_006/`
with tracked generator and producer;SHA256
`4cca633bc0abde0a4752399fdf36e4aa8a4851a7ad382adb9613ec075f7da6e3`.
Audit receipt SHA256
`38308ed950d0ccd69b80c2f309c0c478a864411322084f20ceb2f578d95176ab`.
Eight current proof/audit modules have0/0 streams. Maximum cumulative RSS:
5270472KiB for current accepted records,5373720KiB over all wholly accepted
attempts. All process/kernel/print limits remain unchanged.

Focused `sage check_keygen_public_tables.sage`,standard preparser/exact ZZ:
**8 runs** (baseline +three mutations in normal and UBSan modes). Each:
1025 reversal rows(all1024 reached-domain inputs plus UINT32_MAX),one
terminal-k record,eight seed words and2050 paired gm/igm cells including
untouched sentinels. Baselines match exact root/exponent/scaled words and
the exceptional igm0 formula. Mutations detected in both modes:nine rev
iterations,pre-increment generator,and wrong inverse-zero denominator.
The C copies are instrumented diagnostic harnesses,not edited production
sources or universal source proofs. No KeyGen/private-key generation.

Result `.build/jobs/keygen_public_tables_checks_034_001/PUBLIC_TABLES_CHECK.json`,
SHA256 `cba0d9e4be1548cabf166fd4c87c68e59a281feff4746952cc080fbdd718b439`;
receipt `cfbe5cd55c5e64bbae639b132d78f3150bdfcef804efe04715726f105530450b`.
Finite table matches do NOT discharge the remaining source table/NTT proofs.
No broad unchanged replay or independent review was run.

## 4. Traps175–185 and complete failed history

175. Source for-loop initialization is grouped with its loop. The proved
scalar seq reassociation preserves that exact parse;do not assume a different
outer chain or silently replace source execution by a model evaluator.
176. Actual k++ executes the failed condition's increment too:logn10 squares
once and leaves12. Pre-increment is a detected mutation,not an equivalent loop.
177. Public rev10 is a ten-iteration function. Its output theorem must precede
physical bit-reversal facts;static solver tables alone do not bind it.
178. Known signed/unsigned types are retained. Literal-to-U32 conversion and
unsigned16-to-int32 promotion occur before scalar-call parameter conversion.
179. String-to-list names need exact binding equalities;failed rewriting and
model-state/function equality attempts are retained,not weakened.
180. Public table cells are2 bytes,not solver4-byte cells. Narrowing/promotion
and footprint results are local adapters,not initialized-table conclusions.
181. igm0 is exceptional:radix/(2*firstRoot-1),NOT inverse(firstRoot) times
radix. The source store/refinement for it remains open despite finite checks.
182. Five full-print audits were rejected for elisions. The64-way certificate
assembly and deep local-cell/frame proofs were decomposed into named bounded
lemmas. Affected consumers were rebuilt. No limit was raised and no truncated
audit was accepted;all partial JSONL artifacts and raw errors remain.
183. Mutable cache paths are not historical evidence for earlier versions.
The pair resolves every superseded WITHIN-WINDOW reused product to its
matching immutable job output/snapshot/receipt. This is not a supersession
of any BATCH_015–033 pin. Earlier accepted versions remain historical,not
current final proofs.
184. RevProbe's stdout is diagnostic. It is explicitly DIAGNOSTIC_NOT_PROOF,
not counted among the8 current proof/audit0/0 modules.
185. Instrumented source/synthetic table controls are finite diagnostics.
They do not imply full public/KeyGen success,probability laws or security.

All40 attempt directories and46 receipted steps remain:16 wholly accepted,
23 failed,one accepted diagnostic. No receipt-less attempt,no unresolved
current Lean source or active owned job. Parser/type/model/linter errors,
five truncated audits and the earlier accepted source versions are fully
preserved in the pair. Source commits precede this documentation checkpoint.

## 5. Remaining B1.06,in plan order

1. Continue actual source849–860 from the DERIVED entry above:derive k1,
b512,u0,all paired store indices including cast/u<<k→rev10 input,and both
last-row canonical/scaled exponent images with byte preservation. Reuse the
checked real rev10 result and derived forward/inverse seed words.
2. Execute/refine actual cubing/upward rows,gm0 copy and exceptional igm0;
derive complete BOTH table images and caller/automatic-array layout/lifetime.
3. Actual signed f/g conversion and complete forward NTT,canonical uint16
words AND evaluations of the SAME original CoefficientQuotient polynomial
at KeygenPublicRoots.point,in physical order. Tables must be DERIVED in the
enclosing public source call,not supplied as a final premise.
4. SAME successful public execution→all1536 nonzero tests→division;actual
inverse transform and normalization→canonical h. No assumed round-trip.
5. Construct fInv through the proven evaluation isomorphism and derive BOTH
Relation.mulRq equations for SAME retained f/g/h,at the existing caller seam.

This is a missing enclosing source proof,not a numerical/code counterexample.
B1.06 Acceptance remains NOT MET;B1.07 waits. No subagent,second worker,
session,relay,push,review,migration,stages import or owner/security acceptance.
