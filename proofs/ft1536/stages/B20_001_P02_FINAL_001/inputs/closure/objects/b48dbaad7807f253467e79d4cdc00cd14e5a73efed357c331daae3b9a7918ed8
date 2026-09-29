# Source scalar outcomes i zakres arithmetic refinement

## 1. Pre-floor i return relation

sampler_large2841–2972 sprawdza sticky fault przed finite(mu)/positive(sigma),
a następnie2864 floor,2865 residual. NumericCenter NIE wynika z guardu
finite. Musi przyjść z ordered invariant. Floor candidate ma all-word bridge
do zero-aware ZERO floorC; exact source difference pozostaje przypięte FLOOR.

Po NumericCenter kernel C_INT_BRIDGE daje floor oraz floor+z signed32-safe,
OF_EXACT i analityczny ZERO source-add dają normal residual≤366+2^-20.
Actual r=mu−of(floor(mu)) i delta=1−r są +0/positive normal z value[0,1],
także raw−0/subnormal mu. Nie założono mathematical floor(+0)=floor(−0).

Source fixed CDF scan sumuje u128 comparisons; kernel i public parser podają
bank supports[29,59,118,235,365]. Selector wybiera najwyżej jeden bank,
b=get_u8&1, z=b?(1+k):-k, więc z∈[-365,366]. Bez względu na rejection count,
każdy NORMAL_RETURN2970 to s+z. To support/word refinement, nie sampling law.

## 2. Cztery rozłączne outcomes

- ACTIVE_PRE_FLOOR: faultNONE, guards passed, PC2864. Current NumericCenter
  jest wnioskiem tylko w udowodnionym scope (prawa branch lub local premise).
- NORMAL_RETURN: completed source return s+z, po sprawdzonej current domain.
- REJECTION_STUTTER: rejected proposal/BerExp zmienia PRNG/local state, ale
  caller nadal czeka, bez nowego target store. Nieskończony stutter nie wraca.
- FAULT_RETURN: guard zapisuje sticky fault i zwraca0 albo existing fault
  zwraca0 przed floor. Return value0 sam nie rozróżnia tych outcomes.

NormalResult(mu,a) w formalnym modelu nie zawiera hidden NumericCenter.
safe_normal_return/normal_residual_after_center mają tę premise jawnie i
stosuje się je dopiero po wyprowadzeniu bieżącego boundu. Fault0 nie dostaje
closeness; np.mu=10000000 i returned0 daje residual10000000.

## 3. Local scalar-internal arithmetic po ustaleniu center

Zakres: NumericCenter(mu), actual normalized stored/paired sigma certificate,
legalny typed PRNG/context i każde zakończone legalne get_u8/get_u64.
Te byte-read premises dotyczą source interface, nie uniformity ani gwarancji
termination/refill. Po ich spełnieniu consumed scalar operations są defined:

1. NORMALIZED daje positive finite sigma/dss, bank-found i dss<1. Positive
   coefficient comparison zapewnia selected coefficient≤dss.
2. Source gap subtraction ma sign0 (positive normals ordered; cancellation
   gives+0, ich nonzero difference jest daleko od underflow). Gap<2. R/delta
   są w[0,1], sign0. Of(k²),of(2k) są exact: k²≤133225,2k≤730.
3. Mul/add tworzą sign0 finite x<2^19: conservative bound
   2*133225+(730+1) wraz z U/eta jest<524288. Nie oparto się na komentarzu393.
4. BerExp mul(x,inv_ln2)<2^20 jest finite nonnegative, +0 przy zerze. ZERO
   floor theorem w TEJ already-small domain daje0≤s<2^20, signed int safe.
   Coarse source r=x−mul(of(s),log2) ma finite |r|<2^21; wszystkie operands
   nadal w2^100. Ostrzejszy remainder/log2 accuracy nie jest potrzebny do
   integer-definedness i nie jest tutaj theorem Bernoulli exp accuracy.
5. sw∈[0,2^20), over=(63−sw)>>31 jest dokładnie sw>63, safe_s=min(sw,63).
   W obu shifts safe_s<64. Bools/unsigned corrections bez UB; kernel cutoff.
6. fpr_expm_scaled: mul(r,p63) operands w2^100 i finite. Literal fpr_trunc
   ma small signed cc/field ranges i masked shifts, casts GCC/two's complement;
   trunc jest raw integer transform, nie hardware FP narrowing. z<<1,
   Horner uint64 subtractions i high products mają legal unsigned wrapping,
   fixed count12. Returned threshold/55-bit comparisons są defined. Nie
   przypisujemy im przez to accuracy/law poza osobnym exp proofem.

Te domains nie wyprowadzają samego NumericCenter mu ani whole rejection
termination. Lokalne fault predicates na powyższych inputs są wykluczone
przez positivity/domains; nie deklarujemy globalnego fault-free entry theorem
na nieudowodnionej lewej części. Global fault_unreachable flag pozostaje false.

504 publiczne scalar slices sprawdziły CDF/selection/shift/expm integer words
w normal i ASan/UBSan; bez PRNG/realnego sampler loop. Podane words to jawne
test data, nie seedy projektu. Natywna zgodność jest kontrolą bindingu,
a uniwersalne ranges/support wynikają z argumentu wyżej i kernel lemmas.
