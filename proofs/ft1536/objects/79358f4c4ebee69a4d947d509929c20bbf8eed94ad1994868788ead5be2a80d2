# Binding do przypiętego źródła i granica zaufania

Źródło to17-file FLOOR_CT candidate o CANDIDATE.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985,
wyjęty z manifestu bootstrap ae0b43d2c9ce7b88e63e2d81be97e04dcbd45bbab827cf63f9339828df147cff.
Base fbf4a5c23e36d7089dca563e70b58db886959d1a. Nie zastany Extra/c.
source_changed=false, production_source_changed=false,
new_source_patch_integrated=false, owner_accepted=false.

Build Linux x86_64,8-bit byte,int32,long64,uint64/int64 two's-complement GCC14.2,
C99, literal source/Makefile CFLAGS -O i FT1536 FPEMU/adaptive/profile macros,
SIGN_MAX_ATTEMPTS16; build.py odczytuje faktyczny Makefile. Probe branch nieaktywny.
ASan/UBSan diagnostic build dodaje instrumentację do tych samych flags; bez
LSan claim. Normal8GiB, sanitizer bez AS cap na shadow; każdy job bounded,
single-worker/network-off/W-only. TOOLCHAIN zawiera wersje i narzędzia.

## Mapy i dowody

| Source | Formal/model/refinement |
|---|---|
|ffSampling return1897|LEFT→SAMPLING_RETURN_INTERFACE, whole two-branch reconstruction|
|suffix1902–1934|literal extract checks/suffix_original.inc, post_model.suffix, POSTPROCESSING_MAP|
|iFFT3 FFT854–965|literal source + observer diff, post_model.ifft, symbolic inverses/QQ recurrence, direct RBF inverse|
|rint header99–115 +shift helpers|RintBits/RintRefinement, exact dyadic argument, post_model.rint_word|
|casts1931–1932|GCC modular signed16 conversion, Precast.narrow_preserves_iff|
|norm enc609–666|LV Norm64, source norm slice, SourceBytes.stored_norm|
|STATIC enc289–395,462–559|analytical byte-stream/cursor simulation, codec_model, SourceBytes coefficient decode; M0 EncoderCount separately|
|caller3411–3421|exact source slice with public profile wrapper, frame/cap/header proof|

Source_binding.json zapisuje exact line ranges/hash każdego original slice;
observers mają artifacts/diffs/* i są porównane z original functions, nie
zastępują ich poprawioną mathematical implementacją. Header rint jest użyty
bez przepisywania; FPEMU C i FFT/enc są oryginalnymi TU/includes. Brak pełnego
do_sign/Sign, KeyGen, private API, nowych keys/secrets, PRNG history generation.
Fixtures to publiczne arrays, membership jawnie oznaczony jako local/extended.

Źródłowe add/mul/div/of/half/double domains pochodzą z pinned ROOT/NODE2/
TOWER/NORMALIZED/LEFT analytical primitives, nie blanket IEEE correctness.
Word models i formal dependencies są skopiowane byte-identical z reuse pins.
Floor patch nie zmienia rint/mul/div/FFT/codec. Historyczne ograniczenia
(signed−0 floor, fpr_lt zero issue, Half subnormal behavior) pozostają rozliczone.

Kernel audit: pełne types/terms32 nowych twierdzeń i axioms wszystkich795
w102 modules, source hashes i clean final logs. Dopuszczone tylko propext,
Classical.choice,Quot.sound. Generic consumers mają jawne premises;
source-instantiation bounds są wyprowadzone w analitycznych dokumentach i QQ
certificate. Real metric/FFT theory, source loops/heap i GCC compile relation
nie są w całości kernelized: proof_kind=MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF,
fully_kernelized=false,C_compiler_verified=false. Test PASS nie jest dowodem
supremum, Safe16, probabilistic sampler law ani security.
