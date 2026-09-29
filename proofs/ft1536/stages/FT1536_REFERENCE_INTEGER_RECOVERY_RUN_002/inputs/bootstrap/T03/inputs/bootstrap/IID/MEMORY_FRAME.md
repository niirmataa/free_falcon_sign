# Scalar memory i outcomes

Entry: poprawnie wyrównany żywy ternary_sampler_context, jego embedded prng
buf4096,ptr0..4095,state256,type1; faultNONE dla main theorem. mu/sigma passed
by value; source tables są static const. Getter reads8 lub1 są bounded przez
IidBytes/BYTE_SCHEDULE. Refill zapisuje buf4096 i ptr0; w real generatorze
mutuje też opaque state/counter, w IID game zastępuje provider. Probability
filtration nie ujawnia całego state/buffer. Brak get_bytes substitution.

CDF samples[5] jest w pełni zainicjalizowane:5×512 fixed scans, threshold indices
legalne, count≤512, a actual supports≤365. Selector mask/take0..1 i unique take
zapewniają safe int casts/sums oraz zapis k/coefficient/proposal_level przez
legalne lokale. Wszystkie banks używają tych samych hi/lo words. Constant
tables,sigma,mu,caller tree/targets/outputs nie są modyfikowane przez scalar call.

Scalar floor of NumericCenter i s+z są signed32-safe. k²≤133225,2k≤730,
source of/mul/sub/add/div domains przed każdą instrukcją z ORDERED/NORMALIZED.
BerExp e signed int safe, safe_s0..63; uint64 arithmetic/Horner wrapping
zachowane, high-product internal carries nie gubione,12 iterations. Counter
pointer updates nie overflowują size_t. Source stack/local scalars nie aliasują
PRNG buffers lub static table memory. Observer context guards i opaque-state
canaries kontrolują ten footprint na synthetic arrays; universal source argument
jest podany niezależnie od ich PASS.

Main-domain loop outcomes: NORMAL_RETURN s+z lub REJECTION_STUTTER; guard faults
wykluczone forward z required domains, nie przez późniejszy caller fault check.
Existing fault zwraca0 przed reads/floor; invalid sigma/nonfinite mu fault1;
no bank/gap fault2; negative x fault3 — pozostają source paths poza main claim.
Normal integer0 nie jest FAULT_RETURN. Infinite stutter nie jest return0.

Każda proposal iteration ma skończone fixed-bounded arithmetic/table work i5
getters w IID oracle. Rejection loop ma nieograniczoną liczbę iterations. A.s.
termination jest wynikiem prawa IID i source floor A, nie deterministic
termination wszystkich tapes. Native fixture exhaustion ma tag
HARNESS_EXHAUSTED NONE; standalone original i observer zatrzymują się w tym
samym miejscu bez wykonywania brakującego native read. Nie zmienia to programu.
