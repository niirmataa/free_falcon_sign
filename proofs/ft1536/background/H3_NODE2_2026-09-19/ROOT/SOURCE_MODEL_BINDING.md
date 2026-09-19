# Źródła, modele i granica dowodu

Pin źródeł:2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a.
Bootstrap106/104, BASE9a76ecfd72d83e131d79299f0249bca1efdf9468.
Dokładne spans/piny i zgodność tokenów: artifacts/source_binding.json,
inputs/slices/. Źródła source/ są byte-identical, read-only w jobach.

## Modele

- fp_literal.py: niezmieniona kopia ZERO active add/of/floor;
- backend.py: source uint32/64 limbs/masks/division loop, mul/div/sqr/double;
- root_model.py: wszystkie loops FFT3, pełny packed layout, signs/Gram,
  rzeczywiste div/muladj/neg/add root LDL;
- RootModel.lean: source-normalized integer mulC/divC, nie definicje przez
  idealną wartość; norm/round z przebudowanych dependencies ZERO;
- dyadic.py: niezależna interpretacja finite binary64 i exact RN oracle;
- certificate.py: wyprowadzony primitive envelope, actual FFT recurrence,
  complete symbolic coefficient map, RBF256 twiddles, exact QQ composition;
- emitted_certificate.py: source forward NTT final check, all coefficients,
  integral lifting bound i symbolic Gram determinant identity;
- oracle.py: independent rigorous ring evaluations (bez host double).

Algorytmy integer/FFT pochodzą z przypiętych źródeł Falcon Project /
Thomas Pornin i adaptacji projektu Niirmata; oryginalne notices/licencje
pozostają w source. Nowe modele są jawnie związanymi transkrypcjami.

Normalized mul korzysta z exact106-bit product zamiast schoolbook limbs;
§2 ANALYTIC_PROOF dowodzi równości high50/sticky i bounds wszystkich limbs.
Normalized div zastępuje unsigned all-zero/all-one mask równoważnym
comparison branch:0≤r<2V<2^54 gwarantuje compare. RootDiv kernelowo dowodzi
remainder/invariant przez wszystkie55 iterations. Pack pochodzi z source
0xC8 rounding; zachowane są correction ex0, flush, cancellation i zero bits.
334 native/Python/Lean raw mul/div controls sprawdza ten binding, a nie
stanowi universal proof samym finite zbiorem przykładów.

Source div_autoadj1268–1269 to DWIE divisions. Nie użyto fikcyjnego wspólnego
rounded reciprocal. D_C zachowuje complex muladj, negację i addition
z g11. Kontrole wykrywają zmianę conjugation i podmianę na q²/g00.
G00/G11 imag+0 pochodzi z jawnego store of(0), nie z przemilczenia błędu D.

## Input/KeyGen i frame

EMITTED_BINDING dowodzi support/caps/NTRU/roundtrip/mandatory gate z konkretnych
checked source paths. Source binding porównuje tokeny sześciu par helperów
signer/keygen, po usunięciu komentarzy i suffixu _keygen: instrukcje są
identyczne. FFT/Gram wejścia i layout porównane są osobno. Gate g00 po
wcześniejszej rekurencji jest związany frame theorem, nie samą nazwą normy.
ROOT_FRAME określa legalne buffers i rekurencyjny write footprint; stores
z wcześniejszego subtree nie zmieniają trzech root Gram arrays.

## Warstwy proof

Kernel sprawdza99 twierdzeń (17 nowych), w tym source integer dependencies,
restoring division i frame composition. Pełne types/implicits/terms wszystkich
NOWYCH twierdzeń i definitions oraz axioms są w logs/final/RootTypes.stdout
i RootAudit.stdout. Conditional consumers pozostają jawnie conditional;
nie są przedstawiane jako dowód całego RootCertificate.

Uniwersalna kompozycja source FFT/Gram/LDL, finite/error/domain i emitted
translation są ANALITYCZNE, wspierane exact polynomial/QQ/RBF certificates.
Pełnego C/assembler/compiler semantics nie kernelizowano. Analytic upstream
error contracts są udowodnione w ANALYTIC_PROOF, nie założone w celu domknięcia
końcowego wniosku. To nie automatyczny kompletny IEEE backend.

## Kontrole

checks/root.c wywołuje oryginalne FFT3 i LDL_dim2 na publicznych synthetic
polinomach/Gram. Frame controls wywołują też original ffLDL_fft3 na trzech
constant arrays; nie private loader ani Sign. checks/keygen_map.c wykonuje
wyłącznie publiczne modp table/NTT(X), nie KeyGen lub solve_NTRU.
Wszystkie Makefile flags zachowano; harness dodaje C99, section GC i w drugim
trybie ASan/UBSan. Pełne argv/streams są w checks/logs/ i COMMANDS.log.
Nie czytano sekretów, nie tworzono kluczy; syntetyczne arrays nie są witnessami
emitted membership. Finite diagnostics są oddzielone od universal proofs.
