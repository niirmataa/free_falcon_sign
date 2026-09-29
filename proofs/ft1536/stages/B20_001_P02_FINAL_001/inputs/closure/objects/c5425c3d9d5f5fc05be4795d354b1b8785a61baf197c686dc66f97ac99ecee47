# Kernelowy all-word bridge

Źródła formalne: FloorWord.lean, FloorConsumers.lean. ZERO Floor/ValueDomain/
SourceFloor pozostają byte-identical, są przebudowane z przypiętych źródeł.
Stary raw model `ZeroScalar.floorC` jest konsumowany bez ograniczania raw
inputs; stary floorParts/Nat-subtraction refinement jest użyty WYŁĄCZNIE
w istniejącym NumericCenter consumer, nigdy jako all-word spec.

FloorWord definiuje niezależnie:
- common source xi/cc/count/flag;
- actual two-stage signed right-shift model irsh;
- unsigned enc modulo2^64 i GCC signed decode;
- candidateBits jako rzeczywiste dwa bitwise AND i OR z unsigned mask.

Główne kernel lemmas:
1. fields: wszystkie Word64, sign0/1, e≤2047, cc bounds, counts<64, flag0/1;
2. mantissa_range/xi_range: brak overflow wspólnego prefixu;
3. irsh_eq: oba stages helpera składają się do Euclidean division przez2^n;
4. div_range/old_range: signed64 wynik także dla wszystkich raw exponentów;
5. candidate_bit_equivalence: uint64 blend daje enc(old floorC);
6. decode_encode i all_word64_equivalence: równość signed long value;
7. all_word64_defined: jawne range facts potrzebne dla obu source programs.

Kandydat NIE jest zdefiniowany przez floorC lub desired equation, więc
relacja nie jest refleksyjnym alias theorem. Mask flag ma dwa wyprowadzone
przypadki; Nat.and_two_pow_sub_one i modulo/cast lemmas wiążą bit selection.
Proof obejmuje wszystkie2^64 values, a nie tylko numerical floor domenę.

FloorConsumers eksportuje FLOOR_ZERO_CANDIDATE i C_INT_BRIDGE_CANDIDATE
z dokładnie tymi samymi NumericCenter i z∈[-365,366] premises. zero_endpoints
potwierdza+0→0,−0→−1. NumericCenter predicate oraz eps0 nie są zmieniane.

Audit:8 modułów,41 twierdzeń,15 nowych; pełne types/implicit arguments/
terms w EquivTypes.stdout, axioms w EquivAudit.stdout. Final logs są czyste;
standardowe propext/Classical.choice/Quot.sound. Bez sorry/admit/native_decide/
Lean.ofReduceBool/lokalnych aksjomatów tezy lub warning suppression.

Source C binding i implementation-defined ABI facts są w SEMANTICS oraz
SOURCE_MODEL_BINDING. Kernel equality nie jest proof optymalizatora GCC;
wyemitowane instrukcje sprawdzono jako osobną oś ASSEMBLY_REVIEW.
