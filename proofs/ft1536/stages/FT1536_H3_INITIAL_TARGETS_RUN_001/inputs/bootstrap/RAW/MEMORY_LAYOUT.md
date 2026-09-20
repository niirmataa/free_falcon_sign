# LegalRawExpansionBuffers, offsets i lifetimes

N=1536. LegalRawExpansionBuffers(p,memory) oznacza:
- żywe, prawidłowo wyrównane, readable int16 arrays dla czterech vectors p;
  caps P_key zapewniają dokładną reprezentację. Read-only arrays mogą się
  pokrywać, gdy reprezentują te same wartości w pokrywających się miejscach;
- writable live typed fpr allocation sk≥24576 words i tmp≥10752 words,
  rozłączne ze sobą i coefficient storage; sizeof(fpr)=8, LP64;
- derived pointers pozostają w właściwym allocation, lifetime obejmuje cut;
  nie ma overlap write outputs/scratch z const inputs danego helpera ani
  nielegalnych restrict aliases. Powtórzone wyłącznie odczyty są dozwolone.

sk: b00[0,1536),b01[1536,3072),b10[3072,4608),b11[4608,6144),
tree[6144,24576). Byte extents196608 i86016 mieszczą się w int/size_t.
Pointers f=b01,g=b00,F=b11,G=b10 dają SourceFFT_B=[g,−f,G,−F].
Raw theorem zakłada legal allocations; nie ogłasza sukcesu malloc/API.

## tmp — offsets absolutne od początku allocation

| Zakres | Znaczenie / lifetime |
|---|---|
|[0,1536),[1536,3072),[3072,4608)|root Gram g00,g10,g11; po Gram chronione do cut|
|[4608,6144)|gxx temporary podczas Gram; następnie top t0/t1/t2 po512|
|[6144,7680)|root D po actual root LDL; odczytane w całości przez drugi SplitTop|
|[6144,6656),[6656,7168)|Node3 d11,d22; legalny reuse dawnego root D|
|[7168,7424),[7424,7680)|current inner8 g00/g10; trzecie const input aliasuje g00|
|[7680,7936)|inner8 tmp prefix; lower child inputs po128|
|[7936,8192)|inner7 scratch / local inner8 D; odczyt D przed reuse|
|[8192,10752)|niedotknięty suffix całego raw prefixu|

Node3 używa jeszcze [7680,8192) jako local work. Jego trzy diagonal snapshots
są zachowane przez niższe children aż do właściwego odczytu. Node3 input
prefix[4608,6144) jest chroniony przez całą depth1. W inner8 pierwszy child
działa w tree suffix i scratch≥7680, więc nie zmienia parent inputs<7680.
Analogiczna indukcja daje inner(k) scratch≤2*2^k; base1 ma2 scratch/4 tree.
Depth1 potrzebuje2048 scratch, top3584; z gxx4608 daje high-water8192<10752.
Przyszły source root D nie jest potrzebny do first-child domain.

## tree — offsets relatywne do tree=sk+6144

root L[0,1536), B_b=1536+b*8448, cubic L[B_b,B_b+1536).
A_bk=B_b+1536+k*2304; level8 L[A_bk,A_bk+256).
inner7 starts A_bk+256+e*1024, każdy1024 words. TOWER recursion partitions
każdy taki blok na896 L i128 raw leaves. Wszystkie2301 coverage blocks są
w artifacts/composition_certificate.json; LEAF_MAP daje1536 exact positions.
Suma16896 internal+1536 leaves=18432 jest WNIOSKIEM rozłącznego pokrycia.

Store order jest inny niż physical order: pierwszy subtree przed parent L;
cubic L przed jego trzema child subtrees. Branch0 całkowicie przed root L.
Immutable snapshots w modelu nie oznaczają wiecznej niezmienności scratch.
Root D jest martwe po drugim SplitTop; local inner D po drugim SplitDeep.
Zmiana momentu snapshotu została wykryta przez realny mutation control.

RawLayout używa tagged addresses (K0,S32768,coeff65536), które są injekcyjnym
modelem legalnych rozłącznych allocations, nie C pointer bits. Kernel frame
jest instancjowany przez source destination/loop/rank induction opisaną w
COMPOSITION. Po cut basis jest SourceFFT_B, root Gram zachowany, tmp tail
niezmieniony, const coefficients i pamięć poza zadeklarowanymi writes
niezmienione. Pełny C heap/compiler pozostaje poza kernel refinement.
