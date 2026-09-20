# Binding rzeczywistego C do raw-prefix proofu i kontroli

Model: GCC14.2.0-19/C99/Linux x86_64 LP64, portable integer FPEMU, literalny
Makefile profil. Unsigned modulo2^w, two's-complement/narrowing i arithmetic
signed shift są jawnymi faktami wybranego ABI. Nie postulujemy complete IEEE
lub sprawdzonego GCC. Source pin i closure/body hashes są w SOURCE_TRANSPORT.

| C span falcon-sign.c | Operacja modelu / obowiązek |
|---|---|
|1049–1056,1066–1095|converters i sk offsets; exact int16→int64→fpr przy caps|
|1159–1208|MKN, offsets, f,g,F,G conversion; cztery FFT3, potem neg f/F|
|1217–1248|guard PO FFT, następnie trzy source Gram arrays i gxx reuse|
|505–530|literal dim2: dwa component div, muladj,neg,add; nie reciprocal rewrite|
|548–595|literal LDL3 order i tymczasowe d11/d22/L10/L20/L21/work|
|598–648|inner: first child, local dim2, second child; base literal two real stores|
|651–703|LDL3, następnie trzy split9/Adj/inner8; chronione diagonal lifetimes|
|706–752|branch0 przed root dim2, read root D przed branch1 reuse; return18432|
|1253|raw observation cut po ffLDL_fft3, przed stable/normalize|

Falcon-fft source operations zapisują pierwszy output lub jawne split outputs;
read-only arguments nie są destinations. Poly lengths=MKN, packed imag+N/2,
top root triples3j+k, square adjacent pairs2j/2j+1; ich exact maps i twiddles
są w ROOT/NODE3/TOWER certificates. Literal Makefile/profile i nowe header
nie zmieniają body/tables. Dawne fpr header line numbers po floor są przesunięte
o2; wiążą je rzeczywiste body bytes, nie stare numerki linii.

## Actual instancja a kernel

RawAssembly.Ops odpowiada kolejno source FFT/Gram, top split0, root dim2,
top split1, cubic LDL3, lower split9/Adj i source inner operations. Partial
Option operations reprezentują potrzebę legalnej domeny. Good predicates
instancjujemy actual immutable source-word snapshots wraz z wyprowadzonymi
record bounds/origin paths, jak COMPOSITION§4. RootP_key nie zawiera
LocalDomains jako nowej przesłanki: każdą jego składową wyprowadzono z ROOT,
NODE3/NODE2/TOWER numeric/totality results w opisanej kolejności.

Kernel totality composition nie zakłada completed whole raw prefix. Actual
memory pointer translation, local analytical source-domain proofs i emitted
binding są jawnie poza pełnym kernel refinement, a nie ukrytymi aksjomatami
wniosku. RAW_PREFIX_CERTIFICATE i OBLIGATIONS rozdzielają te warstwy.

## Native controls i niezależny model

checks/raw.c zawiera ORIGINAL falcon-sign.c, z aliasami obserwacyjnymi dla
poly operations. Każdy wrapper wywołuje oryginalną primitive dokładnie raz;
nie zmienia arytmetyki lub kolejności. checks/raw_prefix.inc ma dokładny
diff/spany do cut1253. Nie wywołuje pełnego load_skey ani API, KeyGen/Sign,
stable rebuild lub normalization. Link GC sekcji służy odłączeniu nieużytych
API z control executable; argv jawnie zapisane, brak nowego source patcha.

E events zapisują operation/logn/full i tagged addresses, po nich WSZYSTKIE
output words. O events to exact converters. B events obserwują dwa literalne
base stores przy następnym hooku albo finalnym return; verify real bytes.
K trailer zawiera wszystkie24576 sk words. Frame checks zachowują root Gram,
basis, coefficients/read aliases, canaries i untouched tmp tail. High-water
8192 obejmuje najwyższy byte extent poly writes i base stores.

Niezależny Python model nie woła C: guarded literal integer transducers,
source-order flat-memory interpreter z initialized-word checks i osobnymi
exact dyadic domains. Przed native call każda fixture przechodzi cały
model/domain preflight; C dodatkowo kontroluje real div interval i readonly
aliases. Porównanie obejmuje pełne E/V/O/B/K bytes, nie tylko checksum tree.

Trzy synthetic Gram cases (w tym complex varying i repeated alias) oraz
trzy synthetic coefficient cases (w tym const input aliases). Te ostatnie
mają NTRU constant coefficient2,2,1 zamiast18433, więc NIE są kluczami P_key
ani emitted witnesses. Nie wykonano key search/generation. Synthetic Gram
nie ma przypisanego coefficient witness.

No-op uruchamia także rzeczywisty C. Pięć złych mutation controls zmienia
wykonanie/physical memory modelu (skip child, offset, leaf swap, late snapshot,
root frame write), zamiast tylko filtrować expected event list. Pełne traces,
memory words i snapshots zachowano. Invalid cases zatrzymano w preflight,
bez wywołania C; nie nazywamy ich P_key/emitted counterexamples. Kontrole
są skończone i nie zastępują uniwersalnego argumentu COMPOSITION.
