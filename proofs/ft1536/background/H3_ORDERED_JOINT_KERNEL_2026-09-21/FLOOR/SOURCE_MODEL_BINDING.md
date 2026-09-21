# floor old/candidate — source/model/GCC binding

Baseline source manifest2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a,
header242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa.
Candidate manifest56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985,
header6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f.
Only fpr_floor body changed; all other header bytes and16 source files identical.

## Actual C ↔ kernel model

ZeroScalar.floorC is the pinned old raw model, with rawMant shift/mod/OR/AND,
sign selection, signed cc, modulo64 count and modulo2^32 flag. NumericCenter
was not promoted to all-word and floorParts is not used outside its proved
range. FloorWord candidateBits separately models unsigned mask and AND/OR.

Source normalizations explicitly used:
- unsigned shifts/casts are modulo2^w operations;
- sign t0/1 makes `(m^-t)+t` equal ±m; all signed arithmetic intermediates
  fit int64 by mantissa_range (complement also fits before+1);
- irsh n0..63 mask selects arithmetic right32 or unchanged x, then right0..31;
  irsh_eq proves the corresponding integer floor divisions compose;
- old final signed XOR mask selects shifted or−t because flag is0/1;
- new uint64 complement/AND/OR is precisely candidateBits, with uint64→int64
  GCC two's-complement decode and exact LP64 long result.

SEMANTICS supplies the full explicit C99/GCC/LP64 model, including implementation-
defined signed right shift and narrowing. all_word64_defined proves the range
facts for every Word64; source binding accounts for C effects/representations.
There is no inline asm, compiler barrier identity axiom, attribute or hidden
optimization flag. Kernel proof does not assert a verified C front-end/GCC.

Candidate has no new memory/random/IO effects. A finite pure replacement with
equal results preserves functional caller states under the same fixed inputs/
coins and existing caller-definedness premises; IMPACT_MATRIX gives scope.

## Controls and compilation

Separate TUs compile literal baseline/candidate floor under identical primary
flags. Independent oracle uses positive quotient/negative ceil on raw fields,
never hardware FP conversion for NaN/Inf. All2048 exponents, both signs,
16 mantissa patterns and1,000,000 public SplitMix64 words are covered, total
1,065,562 cases per normal/sanitizer mode. Results match bit-exactly.
The original fpemu_smoke is unchanged; LSan is not claimed.

ASSEMBLY_REVIEW/assembly_ledger bind source annotations to actual instructions
and bytes in wrapper, official target and all three Sign sites. Each candidate
region has only reviewed register arithmetic/data selection, no operand-
dependent jump/target/address or integer div. This compiled-build result is
distinct from the all-word semantic proof and finite dudect measurements.

All baseline/candidate objects, assembly, preprocessing, dependencies and
command hashes are recorded. Binaries remain under bin and are rebuilt.
Default candidate was tested once, then pinned before the first confirmatory
measurement. No data-driven candidate selection or post-plan retry was used.
