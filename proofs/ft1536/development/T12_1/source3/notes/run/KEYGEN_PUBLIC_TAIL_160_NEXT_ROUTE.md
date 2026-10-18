# Next route after the first public NTT pass160

1. PublicTailLoop160.seed_firstPass_source is the reusable first-pass
   execution. Its TailEntry is a caller-domain obligation, not a proved
   concrete invocation. Preserve access to both generated tables through
   all passes using source byte frames.
2. Execute PublicTailShape159.midInnerBody parametrically at v and v+ht:
   two loads, one Montgomery multiplication, two modular stores. Reuse
   PublicArgumentSource157 and PublicGenerateRow159.mont_var; prove the
   Written invariant once, then inner/group/outer inductions.
3. Eight rounds: t=768 down to3 and m=2 doubled to512. Then execute the
  512 triple butterflies and assemble the tail with the generated tables.
4. Compose actual h/t calls, then nonzero tests/division/inverse/return;
   continue with root solver, certificate, codecs and G(seed*).

Type check of the previous suggested shortcut: FftLoopInduction141.source,
FftGroupsInduction143.source, FftOuterInduction144.source and
FftTripleBody147.source_and_image use C99ProcedureReference.Exec,
KeygenSearchFft.program and BitVec64/FPR memory. The public NTT uses
KeygenPublicExec.Exec, KeygenPublicSource.program and uint16 memory with
modular helpers. Direct instantiation is ill-typed; reuse their induction
pattern and the existing public modular helper proofs, not a substitution
of their conclusions. This is an adapter requirement, not a counterexample
to the program or a reason to repeat scalar-algebra certification.
