# BATCH_035 — B1.06 BOTH complete last rows / upward-body midpoint

2026-10-09,GPT-6 Astra (`openai/gpt-6-astra`).
**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**B1.06 Acceptance NOT MET.** Expanded recoverable midpoint under
`run2/notes/B1_STAGED_ROADMAP.md`. B1.05 remains closed at BATCH_032;
B1.07 is not entered. The stage still requires BOTH SAME-material equations.

## 1. Entry and predecessor integrity

BEFORE edits/jobs,the committed verifier checked BATCH_015–034:
**5674 distinct pins,580 current inputs,no supersession,no active job**.
Entry `.build/levels_035/ENTRY_PINS_035.json`,SHA256
`7a9f11c2eb138bd33182dea526d396e6b774a4c68adcace10b90ae6436f953cf`.
Preseal checked identical predecessor bytes:
`.build/levels_035/PRESEAL_PREDECESSOR.json`,SHA256
`f092ae684b3ca0b3053240a7b7eb0c3361c2415bbb7cf38bcad9a040bf0b6cc9`.
Pinned M0 inputs were consumed read-only. BATCH_015–034 sources,reports,
receipts and manifests were preserved. Inherited runner session labels are
historical provenance;this window's model is given above. Foreign worktree
changes and staging were preserved. Owned local commits use main/niirmataa
under the shared archive.lock:`b408ced4`,`2b8909ef`,`f7a32284`,`cfa5ee34`;the pair and
expanded live checkpoint receive their own final documentation commit.

## 2. Actual source results

Eleven new proof modules have current guarded0/0 streams:

1. **KeygenPublicTableControl:** structural local/pointer/normal-flow frames
   for the real public language,including declarations,scopes and loops.
2. **KeygenPublicLastProgram:** exact source849–860 partition,all eight
   statements per iteration,both size_t indices,the for-init grouping and
   real u+=2 increment. No synthetic store schedule replaces that body.
3. **KeygenPublicTableIndex:** size_t shift THEN unsigned32 cast,actual
   rev10 invocation and pointer addition. Derives512+reverse9(u) and the
   odd partner;the earlier checked actual rev10 theorem is consumed.
4. **KeygenPublicTableStore:** both canonical scaled Word/cell adapters,
   actual Montgomery assignments,paired Store16 updates and cross-table
   preservation. LastFrame preserves size/writability and EVERY byte outside
   the two last-row ranges,including uninitialized or noncanonical bytes.
5. **KeygenPublicLastBody:** all eight statements derive both directions'
   even/odd cells and next x/ix. Exponents advance by4 then2,not a guessed
   common increment. Existing cells outside those two indices are retained.
6. **KeygenPublicLastLoop:** actual guard/increment derive256 iterations and
   terminal u512. Both physical images accumulate from the SAME stores;the
   byte/allocation frame and lower-cell preservation compose with the loop.
7. **KeygenPublicLastEntry:** derives k1,b512,u0 from the previously DERIVED
   seed/last-row entry;constructs the invariant without a table-image premise.
8. **KeygenPublicLastRow:** SAME complete mq_mkgm3 execution yields both
   complete last-row images512..1023,original profile/pointers,terminal u512,
   k1,w still declared-uninitialized and the actual remaining source suffix.
9. **KeygenPublicUpperProgram:** complete source863–884 partition,cube body,
   square body and actual controls,including both nested store expressions.
10. **KeygenPublicUpperAtoms:** unsigned16 promotion to int32 and subsequent
    U32 argument/assignment conversion,actual loads and nested Montgomery
    calls,typed child-index arithmetic and restored block-local frames.
11. **KeygenPublicUpperBody:** BOTH cube/square per-iteration updates and
    preservation of other cells,including the inverse child's survival of
    the preceding forward-table store. Their local domains are explicit;
    whole upward-loop composition is still OPEN.

### 2.1 Exact enclosing boundary

`KeygenPublicLastRow.source_last_row` has these inputs:

```text
s : C99ArrayReference.State; out : C99ProcedureReference.Result
gm,igm : C99MemoryReference.ArrayPointer
profile : KeygenPublicTableAtoms.Slot s "logn" (10#32)
pointers : s.arrays "gm"=some gm AND s.arrays "igm"=some igm
gw : gm.elementBytes=2; iw : igm.elementBytes=2
separate : DisjointBytes gm 2048 igm 2048
source : KeygenPublicExec.Exec KeygenPublicSource.program []
  (KeygenPublicSource.code generate) s out
---------------------------------------------------------------------
exists after,
  Exec program [] KeygenPublicTableRows.afterRows after out
  AND forall512<=i<1024,
    Cell after.heap gm i (root^tableExponent i)
    AND Cell after.heap igm i ((inverse root)^tableExponent i)
  AND LastFrame gm igm s.heap after.heap
  AND same pointers,logn10,u512,k1,w:uint32 declared-uninitialized
```

Names in the code are `List Char`;the rendering above abbreviates them.
Cell means a Load16 witness,canonical value<18433,and its cast into ZMod18433
equal to radix times the stated root power. LastFrame leaves size/writable
maps unchanged and every byte outside offsets[p.offset+1024,p.offset+2048)
for BOTH tables unchanged. It is not merely preservation of canonical cells.
The local pointer/profile/separation domains still need binding from the
enclosing public caller/automatic arrays. No generated image,loop outcome,
root/scalar correctness or final public equation is an input here.

### 2.2 Exact upper-body boundary — still local

`KeygenPublicUpperBody.cube_body` consumes a real cubeBody execution,actual
pointer slots,u=i,width2,separation,256<=i<512 and BOTH child Cell facts at
2*i. It concludes normal flow,unchanged locals/pointers and BOTH updated
Cell facts at i,with preservation of other cells below1024.
`square_body` has the same structure with1<=i<256. Both cell conclusions
use tableExponent i and the correct forward/inverse roots.

These child-cell and counter domains are premises of LOCAL body lemmas.
They have NOT been discharged by an enclosing cubeLoop/squareLoop theorem.
The next proof must derive them from2.1 and actual preceding iterations.
No full initialized tables or NTT correctness is asserted by these adapters.

## 3. Full internal audit and focused finite controls

Final audit: **187 entries =158 named source declarations +29 inherited
interfaces;179 complete terms +8 kernel inductives/structures with constructor
types;standard axioms only,zero elisions.** Twelve current proof/audit modules
have0/0 streams;592 current inputs. Artifact1814086 bytes:
`.build/jobs/keygen_public_upper_closure_035_001/PUBLIC_LAST_AUDIT.json`,SHA256
`ce0e888a6c6bf10b112c06d34a7ac1db58dd3e60c3d628b6162f34d680bf48c0`.
Receipt SHA256
`e2a22668bb318a8b667c8fe908666864bb2faf7af3e887b1e9e70a800f2c5062`.
Earlier accepted146/186-entry audits are retained as earlier scopes.
Maximum cumulative RSS3917340KiB(current)/3917856KiB(all recorded steps).
Process,kernel and print limits remain unchanged. This is an internal audit,
not independent review;no broad unchanged replay was required.

`sage check_keygen_public_last_row.sage`,standard preparser/exact ZZ:
**12 normal/UBSan runs**,baseline and five mutations in each mode. Baseline
checks all256 chronological pairs,both next seeds,terminal u512/k1,2050
pre-upward paired cells/sentinels,256 cube updates and255 square updates.
Five detected mutations:even inverse copied from forward,odd forward write
overwriting even,omitted final pair,cube replaced by square,and upper inverse
using forward children. The omitted-pair mutation has255 pairs;that missing
iteration and its consequences are detected,not normalized away.

Result `.build/jobs/keygen_public_last_checks_035_003/PUBLIC_LAST_CHECK.json`,
SHA256 `0de88e1a5830c745613de6a1a4eb5db9b20419755e1d84a51f8ec8aa131ba738`;
receipt `6f06de35288e0629b2fbd94920bfbe1650e873357669f416fa1ca70e5c232ed6`.
The instrumented C copies are diagnostic helper fixtures. No private-key
generation,full-attempt acceptance,probability law or security claim follows.
Finite upward matches do not replace the still-missing source-loop proof.

## 4. Traps186–195 and attempt history

186. Public array indices execute scalar expressions with the actual public
Call relation. The solver/FPEMU scalar-call relation is not interchangeable.
187. u<<k is computed at size_t width before the explicit unsigned32 cast.
The reached bound proves the exact2*u argument;rev10 is then a real Call.
188. Both table directions need their OWN word/cell invariant. Interleaved
stores preserve the other direction through byte separation,not name equality.
189. The last-row loop's real u+=2 and failed terminal guard yield u512.
Both old-cell preservation and the stronger arbitrary-byte frame are proved.
190. Two naive entry-heap reductions exhausted2M heartbeats. Named generic
bind_heap/rows_heap equations avoid expanding the huge inverse-word expression
through a heap projection. No limit was increased and no proof was weakened.
191. Reserved identifier `variable`,an unspaced numeric relation,constant
casts/projections and dependent-index induction caused failed drafts. Explicit
names,typed conversions,projection equations and generalized syntax indices
resolved them;all failed snapshots/raw streams remain.
192. The first diagnostic C instrument read u on the logn1 branch and was
rejected by unchanged -Werror. The diagnostic read is now guarded by logn>1;
no production initializer or warning suppression was introduced. The helper
is invoked with logn10. That failed source/compiler stderr remains preserved.
193. Cube source stores contain nested Montgomery calls directly;the solver's
different temporary-assignment body is not substituted. Unsigned16 values
promote to int32 before U32 conversion;they are not modeled as uint32 loads.
194. Upper-body child images remain explicit LOCAL premises until the complete
loop supplies them. Successful finite full-table controls are not that proof.
195. First sealing attempt stopped before creating the batch JSON:two audit
run_cmd sources produced identical olean bytes,and an artifact-only lookup
selected the wrong source snapshot. Both sources/artifacts were intact. The
resolver now keys by module+artifact SHA+SOURCE SHA,keeping every equality
check. This is a stricter historical binding,not pin supersession. The failed
tool bytes and observed exit1/traceback are retained in
`.build/levels_035/SEAL_001_TOOL.py` and `SEAL_001_FAILURE.json`;the old tool
is also committed in f7a32284. No mathematical proof or predecessor pin failed.

All28 attempt directories/38 receipted steps are retained:15 wholly accepted
directories,13 with a failed step. Several accepted artifacts are earlier
within-window versions,not current final evidence. The pair resolves reused
old source/olean paths to matching immutable job snapshots/artifacts/receipts;
mutable cache paths are not historical substitutes. No predecessor pin was
superseded. No receipt-less attempt,unresolved current Lean source or active
owned job remains. Local source commits precede the documentation checkpoint.

## 5. Remaining B1.06,in plan order

1. From source_last_row,derive actual k=logn-2 (8),u256 and cubeLoop through
   u512;then u255 and squareLoop through u0. Supply every child-cell/counter
   premise to the already checked cube_body/square_body from that SAME run.
2. Execute/refine actual gm0 copy,w read and exceptional igm0 division:
   radix/(2*firstRoot-1),NOT radix/firstRoot. Derive BOTH complete table images,
   legal caller layout/frames and automatic-array lifetimes.
3. Actual signed f/g conversions and complete forward NTT:canonical unsigned16
   words AND evaluations of the SAME CoefficientQuotient polynomial at
   KeygenPublicRoots.point,in physical order. Derive tables in the caller.
4. SAME successful public execution→all1536 nonzero tests→division;actual
   inverse transform/normalization→canonical h. No assumed round-trip.
5. Construct fInv from the proven evaluation isomorphism;derive BOTH
   `mulRq h (reduceVec f)=reduceVec g` and
   `mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod18433)` for SAME f/g/h.

The remaining gap is an enclosing source proof,not a numerical/code
counterexample. B1.06 Acceptance remains NOT MET. No subagent,worker/session,
relay,push,review,migration,stages import or owner/security acceptance.
