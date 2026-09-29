# Stable recomputation, normalizer map i preservation

LegalSuffixBuffers dziedziczy RAW: live/aligned sk24576 fpr words, tmp10752,
rozłączne od siebie i readable const coefficient arrays. f/g odpowiadają p;
legalne repeated read-only aliases są dopuszczone. Out-pointer/leaf-count
locals są writable live objects. MKN fixed10/1 dajeN1536,hn768, arithmetic
offset/byte extents mieszczą się w LP64/int domains.

## Actual tmp lifetimes

1. f=tmp[0,1536),g=tmp[1536,3072). Oba conversions inicjalizują całe arrays;
   FFT, selfadj, add wykonują się przed jakimkolwiek overlap leaves/scratch.
2. Po sumie live root input do stable top to wyłącznie real f[0,768).
   f imaginary i całe g są martwe. Gate00 czyta/modyfikuje tylko live prefix.
3. leaves=tmp+768, primary[768,1536) nadpisuje martwe f imaginary; dwa inne
   top256 blocks też są w tym primary. Scratch[2304,2560) nadpisuje martwe g.
   Top czyta triples z0..767, wszystkie destinations są rozłączne od live input.
4. Binary n≤256: writes n scratch words, kopiuje całość do własnego values
   block, potem first/second recursion. Wspólny scratch nie aliasuje values
   ani innych live primary blocks; malejące n zachowuje initialized reads.
5. Reciprocal u0..767 czyta primary[u] i pisze leaves[1535-u], czyli tmp
   [1536,2304), bez niszczenia primary. Reverse map jest injekcją.
6. Full scan aktualizuje wyłącznie leaves, po czym leaves_out=tmp+768.
   Narrow failure nie omija assignment. Helper early-profile failure jest
   poza fixed logn10 domeną i nie został użyty jako bezpieczny suffix input.

Najwyższy write całego helpera to3072 z conversion/FFT g; stable arithmetic
ma peak2560. Tmp[3072,10752) jest zachowany względem raw cut. Dawny root
Gram w tmp[0,4608) NIE jest wymaganym frame: został legalnie częściowo zniszczony.
Nie używamy go jako późniejszego źródła stable values.

## Normalizer

Sk basis[0,6144), tree[6144,24576). Original normalizer pomija root/cubic/
binary L prefixes; w base inner1 czyta dwa kolejne stable values i zapisuje
tree[2],tree[3]. Recursion shapes dają dokładnie RAW/LEAF_MAP. NormalizeMap
kernelowo wiąże local list z filtrem leaf events Tower.trace, counts i ranges;
map_certificate sprawdza pełną bijekcję/order1536 positions i complement16896.

Każdy width zapisuje się raz w odpowiednią pozycję. Wszystkie16896 internal
L i6144 basis words są BITOWO zachowane; stores nigdy nie mają ich adresów.
Coefficient buffers pozostają readable/niezmienione. Kernel normalized_frame/
basis_preserved jest instancjowany tym źródłowym write footprint. Nie jest
to pełny formalny C heap/compiler.

Legal różnice layoutu KeyGen: g00=4N, tree=8N, t3=20N, leaves=t3,scratch=21N.
Root-frame jest konsumowany w MOMENCIE przed KeyGen Gate00. Same stable
operations są niezależne od tych adresów, gdy live spans są rozłączne.
Signer nie dziedziczy niezmienności starego g00 storage po recomputation.

Native controls mają canaries, pełne sk comparisons, tmp untouched suffix,
out-pointer check i observer rzeczywistych normalizer counts/return.
Osiem publicznych pipelines obejmuje accepted/rejected gates, fallback,
const aliases i exact1536 leaves. Fixtures nie są P_key/emitted witnesses.
