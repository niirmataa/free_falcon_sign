# Przypięty compiled floor — control/memory dependency review

GCC Debian14.2.0-19, C99/LP64, literalne -W -Wall -O i wszystkie makra
baseline Makefile. Brak LTO/march/pragma/attribute/noinline obejścia lub
compiler barrier. Baseline i candidate mają identyczny build recipe.
Pełne argv/dependency/preprocessor/.s/objdump i object/binary hashes są
w artifacts/asm/portable_001 oraz artifacts/benchmark_build. Binaria są
robocze w bin, odtwarzane ze źródeł podczas replayu.

## Pokrycie

Inwentaryzacja17 źródeł i aktywnego preprocessing: tylko trzy production
floor calls w falcon-sign.c:2481 (BerExp),2542 (sampler),2864 (sampler_large).
Nieaktywny fpr-double jest poza buildem. Baseline branch jest widoczny
w każdym z tych miejsc, we floor_wrapper i official timing target_floor.
Machine-readable `artifacts/assembly_ledger.json` zawiera wszystkie regiony,
adresy/bytes, source-assembly binding, instrukcje i reg/flags taint.

Annotation regions oryginalnego TU zostały dopasowane do sekwencji instrukcji
objdump po opcode, uporządkowanych registers i immediate operands; kod każdego
matched region ma własny raw-byte hash. Nie opieramy wniosku na grep `js`.

## Konkretny dependency argument

Baseline oblicza e−1022 i conditional `js` zależny od exponent(raw input).
Gałąź omija część obliczenia dla e<1022. Candidate zastępuje final signed
XOR select przez unsigned AND/OR. W sprawdzonych pięciu candidate regions:

- source input jest jedynym taint seed (RDI wrapper/target; odpowiedni RAX,
  RSI lub RBP w inline site). Aliasy32/64/8-bit registers są wiązane;
- integer mov/shift/btr/bts/xor/add/sub/neg/and/or propagują value taint;
- test count bit5 ustawia secret-dependent flags, ale konsumuje je wyłącznie
  register-to-register cmove: instruction pointer i memory address są stałe;
- variable SAR count jest masked0..31; nie ma integer division lub table lookup;
- LEA jest tutaj arytmetyką registers (−1 mask lub suma), nie memory load;
- żaden operand address/index nie jest tainted, bo floor regions nie wykonują
  load/store. Nie ma conditional jump, indirect target/call lub tainted RSP;
- wrapper/target ret ma zwykły publiczny call-frame return address.

Wszystkie instruction classes w tych regionach zostały wyliczone i sprawdzone.
Candidate floor jest straight-line oprócz data-select cmov, bez dependent
control/memory trace. Brak jednej mnemoniki nie jest jedyną kontrolą.

## Granica w callerach i sprzęcie

Region zaczyna się przy extraction e z raw operand i kończy po finalnym OR
wyniku long. Przed nim np.BerExp wywołuje fpr_mul, a po nim caller konwertuje
long na int/wykonuje dalsze FPEMU. Sampler_large ma swoje wcześniejsze guards,
rejection loop, PRNG/refill i późniejsze aborts. Te branches/effects pozostają
poza twierdzeniem fixed trace samego floor. Nie twierdzimy CT całego caller,
backendu lub Sign ani równego runtime starego i nowego programu.

Register cmov i shifts nie są tu dowodem wszystkich mikroarchitektur lub
absence każdego microarchitectural channel. Brak data-dependent integer div
oraz addresses rozliczono dla tych bajtów. Prespecified dudect stanowi osobną
skończoną oś walidacji na odnotowanym shared Intel Core5 210H.
