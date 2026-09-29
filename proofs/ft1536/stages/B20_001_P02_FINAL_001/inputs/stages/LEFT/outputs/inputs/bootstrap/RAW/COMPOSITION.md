# Uniwersalna kompozycja actual raw prefixu

Autor projektu: Niirmata. Źródła i domeny są przypięte w SOURCE_TRANSPORT.
Argument jest **mixed kernel/universal analytical source proof**. Część
analityczna poniżej instancjuje wszystkie przesłanki RawAssembly.LocalDomains;
sam ogólny theorem w Lean nie byłby pełnym wynikiem.

## 1. Domena i znaczenie funkcji

Key4 to cztery Int^1536 vectors. P_key jest DOKŁADNIE ROOT: ternary f/g,
|F_i|,|G_i|≤2047, exact fG−gF=18433 modulo Phi=X^1536−X^768+1 oraz Gate00_C.
Gate00_C dotyczy rzeczywistych computed g00 words: każdy real slot positive
finite i≥1/2. Nie dodajemy pozytywnych przyszłych pivots, małego L, completed
subtrees, norm acceptance lub NumericCenter. Gate nie jest assumption, że
load_skey już wykonał drzewo. ROOT definiuje go na computed FFT/Gram;
EMITTED_BINDING wiąże z późniejszym testem KeyGen przez tamten conditional
frame i zdefiniowany successful Emitted prefix.

RawPrefix_C to operacyjne wykonanie load_skey1159–1253, przy q18433/logn10/
ter1 i LegalRawExpansionBuffers z MEMORY_LAYOUT. Wniosek to dojście do cut
po powrocie ffLDL_fft3, nie sukces pełnego API/normalizacji. Typowane const
arrays w pamięci reprezentują p; odczyty są legalne przez wszystkie calls.

SourceFFT_B(p) wykonuje source conversions/FFT3 w kolejności f,g,F,G,
następnie source neg f,F i zwraca [g,−f,G,−F] w fizycznym sk order.
RootSlice/Node3Slice/Node2Slice i niższe slices to literalne FPEMU functions
na immutable WORD snapshots, nie idealne macierze lub niezależne interval
boxes. Definiowalny isolated slice nie oznacza, że actual loader wykonał go
wcześniej. Frame niżej wiąże jego wejścia w rzeczywistym MOMENCIE wywołania.

## 2. Primitive i finite-loop totality przed ich użyciem

ROOT ANALYTIC_PROOF§2–4: signed coefficient caps implikują int16/int32 safety
i exact of (przebudowany OF_EXACT). FFT3 wszystkie intermediate scalar
operands<2^30, finite outputs; symbolic all-coefficient map i tablice są
przypięte, bez complete-IEEE premise. Gram coarse products/sums<2^47,
C components<2^35. Każda add/sub/mul ma source domain |operand|≤2^100,
z U=2^-48, eta=2^-900. Twiddle double jest użyte w jego małej normal/zero
domenie. Nie pomijamy signed zero, cancellation lub imaginary slots.

ROOT div ma positive normal denominator[1/2,2^23]; NODE3/NODE2 rozszerzyły
ten sam source restoring-division proof do[1/16,2^35]. Normalizer wykonuje
sześć steps, div55 iteracji; wszystkie signed exponent/count/mantissa facts
są częścią tych contracts. Half ma kernelowy finite-word error≤2^-1023<eta,
może zmienić subnormal/zero bits; nie zastępujemy go RN lub identity.

Pętle conversions/FFT/Gram/poly operations mają fixed finite lengths;
recursion rank k maleje do1. Zakończenie każdej operacji jest wnioskiem
primitive domain + jej source finite loop, nie assumption o powrocie tree.
Większe absolute errors w wcześniejszych certyfikatach nie są używane jako
argument dodatniości; zachowujemy correlations/Hermitian refinements.

## 3. Basis/Gram i spóźniony guard

P_key coefficient caps i legal buffers wystarczają przed pierwszym fpr_of.
Source MKN=3<<9=1536, offsety B=0,N,2N,3N i tree=4N są legalne. Cztery
conversions kończą się, cztery FFT3 kończą się, potem negowane są f/F.
Dlatego basis to bitowo SourceFFT_B(p),6144 finite words.

Guard1223 leży PO FFT. Nie przenosimy go: fixed parameters wyprowadzają
logn10,n1536,q18433, więc jego disjunction jest false. Dopiero teraz wykonywane
są source Gram operations1232–1248 w podanej kolejności, z gxx reuse.
ROOT§4 daje exact +0 imaginary g00/g11, real g00∈[1/2,2^23), finite C/J
i wszystkie correlations. Na tym etapie powstaje immutable root Gram snapshot.
To instancja `prefix_domain` i `rootGood`, bez wywołania root LDL.

## 4. Instancja numerical Good — dane przed każdym call

`artifacts/tower_numeric_certificate.json` odtworzono Sage10.9/QQ/RBF256
na bieżących tablicach; jest byte-identical odebranemu TOWER numeric pinowi.
Nowy composition checker wiąże wszystkie6 S8 i1524 lower records z fizycznymi
paths i sprawdza every positive denominator/margin/output interval.

GoodRoot to computed Gram z§3 i ROOT correlations. GoodCubic(b) to actual
SplitTop/Adj entry z root diagonal branch b. GoodNodeDiag(b,k) to actual
Node3 g00/d11/d22 snapshot w chwili końca LDL3. Mocny TOWER INIT daje:

| b | real lower / upper wszystkich3 diag | imag(k0,k1,k2) |
|---|---|---|
|0|127/256 / 8388609|0,2^-18,2^-18|
|1|28 / 2147483649|17/16,1089/1024,1089/1024|

INIT b0 używa WYŁĄCZNIE g00 z§3. b1 używa ROOT D real(32,2^31) i NODE2
refinement |Im D|<1, dopiero po realnym root LDL. Source NODE3 domains mają
positive div[1/16,2^35], all operands<2^100, L10/L20<2,L21<4. Pierwotne
NODE3 certificates wyznaczają domains/przebieg LDL3 przed INIT sharpening;
silniejsze dolne granice są jego wyprowadzonymi postconditions.

Good8(b,k) to wejście SplitDeep9/Adj z tego Node3 diagonal i jego S8 record.
Good7(b,k,e) to SplitDeep8/Adj z d00 lub computed d11 S8, z odpowiednim
TOWER record path=e. Dalsze Good(d,entry) obejmuje actual immutable input
words i corresponding (b,k,path) Inv(m,M,I,E,R), NIE completed execution.

Każdy step ma hmin>(1/16), hmax<2^35, eigen lower>0, I0<hmin, L norm<2;
child lower m−I²/m−4delta−64U*hmax>0. Fresh exact QQ checker rozlicza
outward floor/ceil na2^-40 dla wszystkich ścieżek. Coarse NODE2 c2 upper
2^36 nie jest iterowane. Child0 jest current input g00, z add/half bounds
niezależnymi od jeszcze niewykonanego local LDL; child1 otrzymuje invariant
dopiero po source muladj/neg/add. To rozlicza każdy `eight_domain` component.

## 5. Actual inner7 i domknięcie inner8

TOWER INDUCTION§7–8 już dowodzi ACTUAL terminating inner7, włącznie z base
inner1 i jego literalnymi stores, po instancji Good/base/step/frames. Nie
konsumujemy tylko izolowanego level7 lub samego abstract successful_execution.
Source transport zachowuje wszystkie używane body/table bytes. Ponownie
sprawdzono wszystkie jego numerical records, half/subnormal domains i rangę.
To dostarcza `inherited_seven` dla12 konkretnych entry groups.

W każdym inner8 (source598–647):
1. Z Good8 current g00 ma Inv child0. SplitDeep8 i Adj są defined i tworzą
   dokładne Good7(e0) PRZED local level8 LDL.
2. Actual inner7 theorem daje jego defined return1024,896 finite L,128
   positive finite leaves i frame. Tree/scratch są poza parent inputs.
3. Parent inputs są więc bitowo niezmienione. NODE2 local source domain
   (z mocnym S8 refinement) uzasadnia teraz actual LDL2, jego256 L i d11.
   Determinizm wiąże je z TYM SAMYM Node2Slice i S8 record.
4. SplitDeep8/Adj czyta d11 z tmp+256 do tmp[0,256), zanim drugi inner7
   ponownie użyje tmp+256. Daje Good7(e1); actual theorem daje drugi return.
5. s=256+1024+1024=2304. L i child blocks są rozłączne, wypełnione dokładnie,
   a input snapshots zachowane. Scratch≤512.

W Lean `inner8_from_actual_inner7` wynika z pięciu local partial-operation
equations i obu actual IH. Generic ops nie otrzymują finalnego raw tree jako
premisy. Source frame/word instancję zamykają kroki1–5, z MEMORY_LAYOUT.

## 6. Depth1, pierwsza gałąź i rzeczywisty root LDL

Source depth1 najpierw wykonuje LDL3 na(t0,u1,t0,u2,u1,t0). Powtarzane const
aliases są legalne. Własny domain GoodCubic, już wykazany przed call, daje
trzy512-word L blocks i current diagonal snapshots g00,d11,d22.

Następnie source split9/Adj/inner8 kolejno k0,k1,k2. Split writes[7168,7680),
inner8 scratch writes[7680,8192); żaden z nich nie pisze Node3 input prefix
ani d11[6144,6656),d22[6656,7168). Po zakończeniu każdego child wynik z§5
daje frame umożliwiający legalny odczyt następnej diagonali. Nie zakładamy
uprzednio ukończenia k0/k1. Wszystkie trzy kończą się i s=1536+3*2304=8448.

Root branch0 jest właśnie tą kompozycją po split_top(g00)/Adj. Jej wszystkie
facts wywiedziono z istniejącego g00/FFT/Gate. Ani root D, ani branch1 nie
wystąpiły jako jej numerical premises. Frame zachowuje root Gram[0,4608),
basis[0,6144) w innym allocation i coefficients. Zatem actual execution
dociera do source741 z tym samym Gram, co ROOT isolated slice.

DOPIERO TERAZ ROOT§5–6 uzasadnia actual dim2: denominator≥1/2, initial coarse
L components<2^37, products<2^72, subtraction<2^75<2^100. Następnie ostrzejsza
correlated analiza daje L norm<2^25, real D∈(32,2^31), refined imag<1.
D11 do branch1 nie jest założone. Root L jest finite i trafia w[0,1536)
tree. Istniejący lewy subtree nie jest nadpisywany.

## 7. Branch1, matching i końcowy return

Root D snapshot powstaje w tmp[6144,7680). Source746 czyta CAŁY vector do
t0/t1/t2[4608,6144), potem Adj. Te inputs spełniają GoodCubic(1) z§4.
Dopiero Node3 call749 może nadpisać dawne storage D. Nie wymaga się frame
tego martwego storage. Wszystkie późniejsze slices referują właściwy
immutable read-time snapshot, nie końcową zawartość tmp+6144.

Analogiczna kompozycja§5–6 daje drugi defined return8448 i właściwe tree
words. Source sum s=1536+8448+8448=18432 mieści się w size_t. Argument nie
uzyskuje totality przez sam count: domains i powroty ustalono wcześniej.

Każdy store do tree ma jednego właściciela: root L, cubic L, level8 L lub
lower inner7. RawLayout partitions, Tower.partition i source offsets
wyprowadzają pokrycie wszystkich18432 positions bez overlap/holes.
Deterministyczne operation equations na wcześniej związanych bitach oraz
frame dają indukcyjnie EXACT source-snapshot matching, nie tylko bounds.
Local L ma finite components; concatenation/frame daje16896 finite internal
words.1536 leaf positions odpowiadają literalnym base stores g00[0],d11[0].
Ich real positive/finite facts z TOWER są zachowane; LEAF_MAP wyznacza
sekwencję bez zamiany na idealne, stable lub normalized values.

## 8. Emitted corollary i ostateczna granica

ROOT EMITTED_BINDING konsumujemy w CAŁOŚCI: ternary support, both signed caps,
modular all-coefficient NTT check + integer lift, G-present STATIC roundtrip,
same decoded vectors i mandatory machine Gate00. Source transport obejmuje
active KeyGen/serialization/gate closure; floor jest nieosiągalny. Zatem
Emitted_CANDIDATE(E,sk,pk) i SourceDecodeSameSTATIC(sk)=p implikują niezmienione
P_key(p). Podstawienie do§1–7 daje identyczny raw-prefix result przy legalnych
buffers. Nie zakładamy dowolnego accepted-loader input, niezawodności Babai
lub nowego K_iid; jeden K_seed[E] warunkowany całym capped KeyGen i oboma
serializerami pozostaje. Allocation failure nie spełnia Legal buffers i
nie jest nowym conditioning event.

Nie pozostaje numerical/earlier-termination premise w wymaganej domenie.
Kernel sprawdza partial-operation composition, supporting arithmetic/layout/
frame/finite-list lemmas i odbudowane dependencies. Wybór actual source
operations, ich pełne analytical numerical instantiation i translacja
pointer heap są jawnie ANALITYCZNE. GCC/full C heap nie są kernel-verified.
Finite C/model/sanitizer/mutation controls wspierają binding, nie zastępują
kwantyfikacji. Raw cut nie obejmuje stable rebuild, normalize, targets,
Reach lub prawa samplera; te cele są wyeksportowane osobno.
