# RootSlice a rzeczywista kolejność loadera

RootSlice to lokalna deterministyczna funkcja source arrays. Nie wywołuje
private loadera i nie przestawia kolejności kodu w dowodzie całego Sign.

W load_skey tmp mieści7N słów, N1536. Root Gram g00/g10/g11 zajmuje
[0,N),[N,2N),[2N,3N). gxx zaczyna się w3N. Matrix B i tree są w osobnym
sk allocation: cztery B arrays, następnie12N tree words. API wymaga legalnych
buforów i braku overlap między outputs/scratch a const inputs. W samym
LDL_dim2 dozwolony jest overlap pomiędzy const inputs.

ffLDL_fft3: przed root call split_top(g00) zapisuje t0,t1,t2 pod gxx,
po512 słów. adj zmienia tylko t1/t2. Następnie ffLDL_depth1(tree+N,...,t3)
z t3=gxx+N wykonuje pierwsze subtree. Dopiero później d11=t3 i root
LDL_dim2(d11,tree,g00,g10,g11). Drugi subtree również nie zapisuje root Gram.

Frame/input binding pochodzi z rzeczywistych destinations:
- poly_* modyfikują wyłącznie jawny pierwszy output; split zapisuje swoje
  outputs, nie const input;
- LDL_dim2 pisze d11 i l10, LDL_dim3 swoje outputs oraz tmp;
- inner/depth1 wywołują je z tree lub suffixami tmp; wszystkie nowe offsety
  są nieujemne, a const inputs nie stają się destinations;
- żadna ścieżka nie otrzymuje write pointer do [0,3N) root Gram.

Indukcja po składni recursion/stores, z kernelowym RootLDL.root_frame,
daje dla KAŻDEGO defined prefixu docierającego do root call identyczne bity
g00/g10/g11 jak przed pierwszym split. Nie wymaga boundów numerycznych
subtree. Jeśli prefix jest STUCK albo root call nie występuje, frame lemma
nie jest twierdzeniem o jego ukończeniu.

Sizes: inner(k) ma tree size(k+1)2^k i scratch≤2*2^k (base k1:4 tree,2 tmp).
Depth1 przy k9/n512 ma3n+3*(9*256)=8448 tree, scratch≤4n=2048.
Top:1536+2*8448=18432=12N; scratch1536+2048=3584<4N dostępnych od gxx.
To rozlicza legalność indices i rozdział frame, nie poprawność divisors
wewnętrznych nodes. Layer translates flat tagged allocation addresses into
the Nat store model; actual C pointers/heap are not a kernel C interpreter.

W KeyGen g00/g10/g11 są pod offsets4N,5N,6N. gxx=7N, tree=8N i t3=20N;
analogiczne helpery *_keygen piszą tylko tree/scratch, nigdy te trzy inputs.
Defined successful Emitted execution dociera do późniejszego gate z tymi
samymi raw g00 słowami. Różny layout scratch nie zmienia funkcji FFT/Gram.

Kontrole C wykonują publiczne constant Gram cases (A=J=2, C=−1/0/1),
oryginalną pełną ffLDL_fft3 i osobny root dim2. Sprawdzają root L bits,
niezmienione input arrays, output/tree canaries oraz dozwolony alias g11=g00.
Normal i ASan/UBSan są kontrolą bindingu, nie universal subtree theorem.

Nie stosuje się późniejszego ft_build_stable_certified_leaves jako root
frame invariant po końcu loadera: ten etap ponownie używa tmp. Binding
dotyczy właściwego MOMENTU root call. Normalize nadpisuje1536 terminal
widths, a16896 internal words zachowuje własny odrębny obowiązek.
