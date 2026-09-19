# H3_RANGE — translacje i ich dokładne granice

25 source spans i SHA-256: artifacts/source_bindings.json. Bootstrap jest
read-only, wszystkie17 kopii source są bajtowo identyczne. Nie zmieniono C,
CDF, backendu ani guards. Natywne programy dołączają przypięty source bez
instrumentowania instrukcji produkcyjnych; scripted callbacks są jawnie
testowymi argumentami funkcji ffSampling, a nie losowaniami rzeczywistego Sign.

## Floor

fpr-emulated.h117–133: pola raw word x to sign t, exponent e i fraction f.
Dla e<=1053/f<2^52 jawna redukcja bitów daje
`xi_abs=2^62+1024*f=1024*(2^52+f)`, także gdy e=0. Mask usuwa exponent/sign;
OR wymusza hidden bit. xi_abs mieści się w[2^62,2^63−1024], więc signed cast,
xor−t i +t są legalne i dają ±xi_abs. cc=1085−e jest w[32,1085].
fpr_irsh(xi,cc&63) odpowiada arithmetic-right shift/division przez2^(cc&63)
w wybranym GCC LP64. Mask końcowy nadpisuje wynik przez−t dla cc>=64.
Nie używa się tu rounding assumption dla fpr_add/mul.

To redukcja C→floorParts w formal/Floor.lean, sprawdzana również niezależnym
literalnym64-bitowym modelem scripts/dyadic.py i C na granicach. Kernelowy
normal_floor_refinement dowodzi równości z mathematical dyadic floor przez
cancel wspólnego factor1024 oraz low-exponent cases. Dla e=0 positive0 i
niezerowe subnormals dają właściwy floor; wyjątek to **negative zero**.
mathFloor jest zdefiniowany jako exact dyadic floor w jawnej domenie e<=1053;
nie udaje modelu wszystkich2048 exponent codes.

GuardPrefix to dokładna kolejność fault, finite mu, positive-finite sigma,
then atFloor. Nie ma guardu dss w tej fazie. dss/gap/exponent guards później
nie mogą zostać użyte do usunięcia wcześniej osiągniętej konwersji.

## Pozostałe FPR

FPR(s,e,m) clampuje mantissę przy zbyt niskim e i zachowuje sign; nie
implementuje ogólnie gradual underflow. mul traktuje wszystkie exponent0
operands jako zero, div analogicznie numerator (z canonical+0), sqrt ignoruje
sign przy założeniu nonnegative i clampuje exponent0, half bezpośrednio
odejmuje exponent bit. neg flipuje sign także na zerze. add ma własną
normalizację i signed-zero/cancellation behavior. Nie zadeklarowano totalnego
IEEE modelu dla tych przypadków. Native/exact dyadic diagnostics są jawne
w fpr_analysis.json, razem z błędami wobec RN-even/u|x|+eta.

Na ograniczonej normalnej domenie synthetic order tests niezależny oracle
RN-even odtwarza wszystkie source wyniki. To kontrola domeny tych testów,
nie nowy uniwersalny rounding theorem. Globalne zastosowanie wymaga wykazania
warunków dla każdej rzeczywistej operacji w emitted loader i reachable prefixie.

## CDF i propozycja

Comparator.lean dowodzi branchless lt64,eq64,lt128 ze source2729–2757 z
uint64 subtraction wrap. List recursion above odpowiada512 inkrementacjom
o0/1. export_cdf.py parsuje pary hi/lo i porównuje WSZYSTKIE2560 wierszy
z C dumpem. CDF.lean zawiera te same literały; kernel liczy dodatnie thresholds
29/59/118/235/365. At random word0 maxima są osiągane w szerszej domenie słów.
Nie zakłada się PRNG reachability konkretnego słowa dla każdego seedu.
Selector found/take może wybrać najwyżej pierwszy eligible bank; wyjście
bez found prowadzi do fault, nie innego k. z=(b?1+k:−k), b∈{0,1} daje zakres
[-365,366]. Wszystkie sumy/counts mieszczą się w C int i uint64.

## Ordered buffers i wsparcie klucza

REACHABILITY.md określa cały initialized source path i stan stosu/buforów;
scripts/order_model.py zachowuje prawa2/1/0/prawa→lewa, split/merge, correction
mul/add/sub, ponowne obliczenia i terminal scale. Pełne syntetyczne requests
3072 i wynikowe buffers zgadzają się bitowo z oryginalnymi static C functions.
First scalar reads width18431; po1536 normalize writes pozostałe16896
wewnętrznych tree words nie są zastępowane. Kernel listVisits i lokale residual
nie zastępują open uniform machine-error refinement całego tego programu.

KeyGen route wymaga poly_big_to_small na F i G, solve success i gate przed
serializacją. Lokalny kernel cap odpowiada reject(<−2047 or>2047). Źródłową
własność propaguje success path, ale nie daje boundu idealnego Babai quotient
ani błędu samego reduction FFT. Historia i inputs/T5 mają swoje własne zakresy.

Wszystkie synthetic arrays są publiczne/testowe, bez private loader/KeyGen/Sign.
Syntetyczny leaf_gap kończy kontrolę przed niebezpiecznym narrowing, nie
wykonuje signed overflow. Sticky-fault test wywołuje prawdziwy sampler_large
z fault!=0; modelowe zero-returns po fault nie są traktowane jako Gaussian
samples. Żadna zgodność testów nie nadaje im emitted support.
