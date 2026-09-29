# Node3 input/output binding i kolejność

N_root1536, N_child512, half_child256. SplitTop(logn10) czyta trzy parent
slots3j+k oraz imag+768, zapisuje trzy child vectors: real j,imag j+256.
NodeInverse.normalization_indices sprawdza pełne granice indeksów.
Adj(logn9,full0) dotyka wyłącznie imag256..511 i wykonuje source sign XOR.

Rzeczywiste wejścia LDL_dim3 to(t0,u1,t0,u2,u1,t0). t0 jest tym samym const
buforem w g00/g11/g22, u1 w g10/g21. To dozwolony read-only alias; outputs
d11,d22,l10,l20,l21 i scratch muszą być rozłączne od inputs i od siebie.
API wymaga legalnych typowanych buforów, sizes i lifetimes, jak w ROOT.

W aktualnym callerze child inputs zajmują początek root scratch gxx:
t0 offset0, t1=512, t2=1024. Node3 tmp zaczyna się w1536: d11=1536,
d22=2048, lower t0=2560, lower t1=2816, pomocniczy LDL3 work=3072.
Ostatni zapis work kończy się w3584. Tych samych1536 input words Node3
nie nadpisuje. Model tagged allocation adresów oraz NodeFrame.node_frame
wyprowadzają niezmienność całego input prefixu dla dowolnej listy dozwolonych
stores. Source binding destinations jest analityczny, nie kernelowym C heap.

L blocks zajmują3*512 słów w tree. Dla branch0 zaczynają się w root tree
offset1536, a dla branch1 w9984=1536+8448. Dalej znajdują się trzy niższe
subtrees, po2304 słowa. Wszystkie te zakresy mieszczą się w18432 tree words.
Node3 nie wykonuje ich proof: kolejne split_deep/inner mają własne obowiązki.

Branch0: ffLDL_fft3 najpierw split g00, Adj t1/t2, potem ffLDL_depth1, którego
pierwszą numeryczną fazą jest LDL_dim3. Root dim2 następuje dopiero po tej
branch i jej niższych subtrees. g00 certificate pochodzi z FFT/Gram/Gate,
nie z późniejszego root call. Żadnej przyszłej operacji nie użyto do własnego
warunku defined.

Branch1: jeżeli rzeczywisty defined prefix dochodzi do root dim2 i następnie
drugiego split, ROOT_FRAME wiąże jego input Gram z RootSlice_C. Root D_C
jest przechowywany w t3=gxx+1536. Split czyta cały ten vector i zapisuje
child prefix0..1535, bez overlap. Dopiero potem Node3 outputs d11/d22 i
scratch ponownie używają storage dawnego root D_C. To legalna zmiana lifetime;
nie twierdzimy, że dawne root D_C pozostaje tam po Node3.

Analogicznie exported Node3 outputs są opisane w momencie końca LDL_dim3,
PRZED następne split_deep/inner mogącymi używać scratch. Frame nie implikuje
total execution wcześniejszych/późniejszych subtrees, a Node3 correctness
nie nadaje całemu internal tree statusu proved.

checks/node.c realizuje obie dokładne layouts, w tym branch1 storage reuse,
sprawdza wszystkie256 positions, powtarzane const aliases, unchanged child
inputs i canaries. To publiczne synthetic array controls, bez private loadera,
Sign/KeyGen lub membership claim. Preflight nie dopuszcza C call poza
wymaganą denominator domain; nie dodano takiego guardu do źródłowego C.
