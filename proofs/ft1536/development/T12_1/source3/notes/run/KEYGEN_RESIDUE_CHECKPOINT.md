# Source coefficient-conversion checkpoint

Package remains **IN_PROGRESS / NOT_REVIEWED**. This is a recoverable
development checkpoint, not a completed B1 result.

## Checked scope

`KeygenResidueVectors.source_vectors` consumes the existing Geometry.Vec
representation of the four input arrays and execution of the parsed source
conversion loop7367--7372. It derives canonical output residues representing
the same integer coefficients. Source declarations, signed16 promotion,
modp_set calls, uint32 stores, all1536 iterations and value-preserving frames
are connected. Non-aliasing of input/output objects and the source entry
layout remain explicit local premises for the enclosing caller to derive.

Checks retained under `.build/jobs/`:

- `keygen_modular_memory_closure_009`:15/15 changed-closure modules clean.
- `keygen_residue_store_010` through `keygen_residue_vectors_016`: all seven
  modules checked individually, with current source/cache/log pins confirmed
  again at resume. These checks were not rerun merely for the recovery commit.
- `keygen_residue_audit_017`:20 type/term/axiom audits clean,1.526s; standard
  Lean axioms or none. RECEIPTS SHA256
  `98a4a770a4c28c515ae8e1b4716d73d1e5bf58cf9163c0b8da83db467a617101`;
  SOURCE_INPUTS SHA256
  `5c940d560edff175ef01d8837201e4652da59354ddec426f417674527293dda9`.
- `keygen_modular_suffix_checks_002`: Sage with standard preparser and ZZ,
  13 signed boundary operands and1536 public synthetic coordinates. Baseline
  and four mutations checked in normal/UBSan modes. No RNG or private KeyGen
  was called. Result SHA256
  `ed336129760e5178d482150f8f4d34556663b7ac637fa053811867a2ba00327b`;
  receipt SHA256
  `e8262316089ab4418721d2ea16033a2363189ac8b45391f78dae890c370c866c`.
  The previous `_001` JSON-serialization failure remains retained.

No batch009 fresh-replay receipt is claimed. The audit uses the checked
dependency artifacts recorded in SOURCE_INPUTS. The Sage probes are finite
diagnostics, not replacements for the kernel results.

## Resume boundary

Core/parser checkpoint: `0d29f339`. Subsequent logical commits save the
conversion proofs and this evidence. Read the latest WORK_STATE and Git log.
Next: source NTT range/evaluation and source alias/entry bindings, followed
by the same-material KeyGen attempt/caller/codec and public/inverse links.
The final emitted_to_actual_fiber theorem is still unavailable.
