# Next180: generator cube rows and inverse-table initialization

Verify179 into ENTRY180 and inspect live processes before one Lean job.
The next exact obligation is:
  C99ModularReference.Exec
    (C99ModularReference.chainOf SelectedGeneratorRow179.remaining)
    SelectedGeneratorRow179.after out
The remaining list is [kFromLogn,ifFull,squareLoop]++topElements.
SelectedGeneratorRow179.continue_generator composes this with all actual
source execution already constructed. The complete generator call is still
open; do not supply a source-execution premise from a correctness theorem.

Closed179:
- GeneratorRowBody179.source executes the original eight-statement body:
  four actual REV10-addressed stores and four Montgomery scalar updates.
- GeneratorRowLoop179.source/full proves all 256 iterations parametrically,
  with the original u=0,2,...,510 sequence and final false guard at u=512.
- SelectedGeneratorRow179.source binds the whole rowSelect, including its
  logn10 false test and exact elseRow scope restoration, to the actual state.
- SelectedGeneratorRowTable179.forward_filled proves canonical gm cells
  512..1023 by consuming the newly constructed source execution in the
  existing KeygenMkgm3RowInit.selected_row theorem. u=512 and k=1 are closed.
- SelectedGeneratorRowFrame179.f_image/g_image preserve both complete
  converted sampler images at fs/gs. bytes preserves every other block and
  scratch bytes below 19064; stable preserves sizes and writability.
  This byte-frame export on block31 is limited to offsets below19064.

Important next input: the old canonical-table theorem covers gm, not igm.
The real source stores to igm have been constructed, but a separate exported
upper-half igm initialization theorem has not yet been supplied. Derive it
from those writes before using igm[2*u] in cubeBody. Do not silently use the
synthetic heap's initial zero fill as a replacement for source writes.

A direct route uses C99InitializationTrace.Initialized/Preserves:
- Store32 initializes its four destination bytes.
- steps_preserve and KeygenMkgm3RevMemory.memory_steps transport that fact
  through later defined writes, even without retaining the old word value.
- GeneratorRowStore179.source and the explicit GeneratorRowBody179.states
  identify the two destinations per table in each iteration.
- Induct the initialized prefix of lastIndex(0..u-1), then use the existing
  checked reverse9 permutation/covers facts to cover physical512..1023.
- From four initialized bytes plus Allocated and width4, construct an
  existential Load32; it supplies the actual word, not a guessed value.
This can be a source-derived postcondition on the already constructed loop,
or a strengthened construction linked back by existing source determinism.
Inspect exact types before choosing the smaller proof.

Then execute kFromLogn (k=9), ifFull with actual full1, its k decrement to8,
and the original cubeLoop: initialize u=256, iterate through511, reading
both tables at2*u and writing their cubes at u. Existing canonical gm
lemmas can be used after constructing this source execution. Preserve the
upper-half reads and establish inverse-table initialization of256..511.
Afterwards squareLoop initializes u=255 and descends to1, reading already
initialized children2*u. topElements writes gm[0], reads w=gm[1] and writes
igm[0] through the fully constructed ModpDivTotal178.source_exists.

Use the actual gm/igm indices4766/5790, width4, count71680 and block31;
REV10 stays the source-bound readonly table. GeneratorRowFixed179 and
KeygenMemoryStability.modular already transport allocations and writability.
Use explicit frame/slot lemmas on selected states; unrestricted definitional
conversion of nested records caused the retained slow attempts in178/179.

After the generator remain both original modp_NTT3 calls, R3 and 512 paired
triple products, the inactive inverse-branch exclusion, nine make_fg_step
calls, CRT/Bezout/carry tests, intermediate/depth0/root validation and
certificate/codecs before the corrected134 emitted witness. No numerical
acceptance/coding/p_K bound or unconditional Z>0 has been obtained. Old110,
paper measured wording and exactly five do_sign items remain unchanged.

One job111 process, standard limits, accepted logs0/0, retained failures,
small local commits, postseal and no push. Audit269 is the final job if its
receipt confirms PASS; inspect it before taking the next unused suffix270.
