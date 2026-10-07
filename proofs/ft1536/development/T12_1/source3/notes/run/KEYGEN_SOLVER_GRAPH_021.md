# B1.05 — solver and sampler dependency census

**Inventory / NOT_REVIEWED. This does not discharge source execution.**

The complete recorded adjacency tables are in
`.build/jobs/keygen_solver_graph_021_003/SOLVER_GRAPH.json`, SHA256
`dd0e42256a6178bc05d7304d06dfd5a2cea9d34e14ba81999b59958e7ebc3b7c`.
Generator: `sage/inventory_keygen_solver_graph.sage`, run through the
unchanged guarded Sage runner. The job compiled four pinned translation
units with the PROFILE.json flags and traversed GCC's initial call graph.
All17 profile source-file hashes were checked. No indirect call occurs in
the recorded reachable closures. Function bodies and external memory
operations are distinguished. A node's translation unit includes its
pinned headers; e.g. inline fpr helpers are defined in fpr-emulated.h.

| Closure | Nodes | Scope |
|---|---:|---|
| Unpruned solve_NTRU |99| Both runtime branches, all transitive body dependencies and external calls |
| Top-selected M0 solver |92| Remove four binary-only direct root edges; deeper runtime branches remain an overapproximation |
| MODE1 sampler |6| Actual get_rng_u64, shake_extract, enc64le, process_block and memcpy |

The four compiled source units are falcon-keygen.c, falcon-fft.c,
fpr-emulated.c and shake.c. Their hashes and all adjacency lists, commands,
raw dump hashes and compiler version are in the JSON. Raw GCC addresses and
dump hashes are run-specific; source pins and graph structure are the
reproducible inventory. This is not a kernel callgraph extraction theorem.

## Solver root and search

The root's M0 direct calls are:

1. `solve_NTRU_deepest(fk,f,g)` with its actual failure return.
2. `solve_NTRU_intermediate(fk,f,g,depth)` at body depths9 through1.
   The source uses `depth -- > 1`; the terminal failed test changes1 to0.
3. `solve_NTRU_ternary_depth0(fk,f,g)` with its actual failure return.
4. Both `poly_big_to_small` calls, in short-circuit order, F then G.
5. `modp_ninv31`, `modp_mkgm3`, `modp_set`, four `modp_NTT3_ext` calls
   (through the stride1 macro), `modp_montymul` and `modp_sub`.

Excluded only at the root: solve_NTRU_binary_depth0/depth1, modp_mkgm2 and
modp_NTT2_ext. No deeper branch was silently dropped. In particular the
inventory still contains binary helpers reached syntactically through
`make_fg`, `make_fg_step`, `solve_NTRU_intermediate` and poly_sub_scaled_ntt.

The substantial open operational clusters are:

- deepest → make_fg / ternary-top / iterative reductions → CRT → zint_bezout;
- intermediate → prime/NTT/iNTT and CRT reconstruction, bit lengths,
  zint_get_top, floating-point transforms and scaled polynomial subtraction;
- ternary_depth0 → pointer alignment, small-to-fpr conversion, FFT3/iFFT3,
  polynomial operations, rounding, memmove and final integer-word updates;
- the full root caller: fk members, actual scratch pointer views, local
  declarations, MKN, post-decrement loops, branches and all failure returns.

The source search does not need a separate NTRU correctness proof: the
BATCH_020 validation theorem supplies the equation. It DOES need fixed
body execution and material-preserving frames. The inventory cannot be
used as an assumed callee relation or source-completeness premise.

## Sampler and exact boundary

```text
sample_true_ternary_secret
  -> get_rng_u64(&fk->rng)
       -> shake_extract
            -> process_block (Keccak)
            -> enc64le
            -> memcpy
```

The fresh finite controls link the actual pinned shake.c and compare two
successive sampler calls against a deterministic SHAKE256 byte/cursor
reference, using public fixture labels. They check rejection, refill,
discarded residual bits at the call boundary, coefficient bytes and
preservation of the first vector. No IID or success-law claim follows.

Kernel export `KeygenTernaryStore.accepted_store` covers the source tail
AFTER refill: x extraction, rb shift, rbits decrement, the actual x<3 gate,
the narrowed store at v[u], and break. `rejected_heap` proves the non-store
edge preserves memory. It still needs the full outer/inner-loop derivation,
the real refill/body binding above and preservation of earlier coefficients.

Kernel export `KeygenSmallBounds.source_material` covers the COMPLETE
parsed poly_big_to_small body, with no bound premise. The fixed
zint_one_to_plain call executes its parsed load/update prefix and actual
signed32 local-object byte interpretation. `bound_call` also consumes real
parameter binding and proves that a nonzero converted return is1.
`two_outputs` preserves F across the second bounded-write trace. The actual
root caller arguments and short-circuit gates must still instantiate those
exports on common heaps; no complete solver theorem is claimed here.

## Next execution work, in plan order

1. Source-bind the root and fixed search callees above, including member
   reads, memory views, scalar scopes and real failure control.
2. Bind F/fk->tmp/logn/fk->ternary and G/(fk->tmp+n)/logn/fk->ternary to
   `KeygenSmallCalls.params`. Extract both successful calls from the actual
   short-circuit gate, preserve f/g and the first output, then pass the
   same four arrays to the BATCH_020 validation seam.
3. Source-bind MODE1 refill and the two loops; obtain actual retained f/g
   witnesses with Bound1. Reuse the checked store tail rather than replace
   get_rng_u64 by an IID or arbitrary-word oracle.
4. Compose the source-derived bounds and caller bindings with
   `generated_converted_checked`. B1.05 Acceptance remains NOT MET until
   this yields the integer equation for the same source-retained material.
