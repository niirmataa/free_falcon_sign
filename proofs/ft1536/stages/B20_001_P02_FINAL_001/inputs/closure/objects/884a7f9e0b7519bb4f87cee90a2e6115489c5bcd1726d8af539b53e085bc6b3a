# Zakres pamięci i kontroli

Skonsumowano legal scalar/context/getter frame z IID. Source mu/sigma passed
by value i tables const; normal/rejection loop nie modyfikuje caller key/tree/
targets. CDF fixed scans≤5×512,scalar k≤365,s+z signed32-safe,normalizer/helper
operations w wyprowadzonych domains. PRNG buffer reads/refills pozostają tymi
z IID; w tej pracy nie uruchomiono actual seeded generatora lub całego Sign.

Original scalar/BerExp slices są testowane w normal i ASan/UBSan. Nowe primitive
callbacks są read-only poza własnymi locals; input arrays/word ranges są
preflightowane przez exact transducer. Standalone leaf slice987–990 czyta
leaves[0],leaves[1],pisze tree[2],tree[3],increment index0→2; canaries tree[0/1]
zachowane. D jest publicznym word, nie kluczem lub pozyskanym sekretem.

RBF/QQ evaluator jest osobnym matematycznym procesem: nigdy nie przekazuje
infinite-tail integer y do native casts/API. Global source proof korzysta z
odebranych primitive ranges oraz nowych [0,273]/remainder<.7/scaled<2^63
domains przed arithmetic. Finite public words sprawdzają binding, nie safety
arbitralnych pointers,malformed contexts/faulted tails lub full Sign execution.

Source byte maps/aborts/norm checks/narrowing nie zostały zmienione przez
analityczne conditioning G_S albo truncation sumy Gaussian. Tail to proof
bound, nie nowy source abort. Wszystkie jobs bounded,single-worker,W-only.
