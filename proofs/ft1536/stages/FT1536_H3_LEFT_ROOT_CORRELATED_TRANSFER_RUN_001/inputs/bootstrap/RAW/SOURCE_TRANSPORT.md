# Stary pin → archived FLOOR_CT candidate

BASE6ed89cac3249bdfe6d874c6616fd2899f4b3ef6a. Input/source ma dokładny pin
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985;
PREVIOUS_SOURCE ma2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a.
Zastany Extra/c nie jest bazą zadania.

source_transport.py sprawdza wszystkie17 nazw i wszystkie nowe bytes,
16 identycznych starych hashy oraz jedyny zmieniony header. Odwrócenie
dokładnego FLOOR/PATCH.diff odtwarza header242a7027… (pełny pin w JSON),
z nowego6b897d6c…. Prefix/suffix ciała fpr_floor są identyczne. Zatem każdy
inny function/macro/table body jest BYTE-IDENTICAL, nie tylko nazwany tak samo.
fpr_gm3_square/cubic mają osobne body hashes. Skopiowane derived old header
jest publicznym dowodem tego porównania; nie zastępuje źródeł kandydata.

Z literalnymi active Makefile flags wygenerowano preprocessing siedmiu TU.
Call graph jest syntaktycznym nadzbiorem (także inactive ter0 arm raw slice).
Same static names w różnych TU są konserwatywnie łączone przez union edges;
każdy body ma osobny unit/hash. To może dodawać paths, nie usuwać callees.
Raw prefix closure ma39 funkcji, emitted KeyGen closure140. W obu floor jest
NIEOSIĄGALNE; jego jedyni source callers to BerExp/sampler/sampler_large.
Raw prefix nie dociera do load_skey remainder/stable rebuild/normalize.

Entry raw_prefix_slice wiąże się diffem z dokładnym1158–1253: rename,
usunięcie czterech deklaracji używanych dopiero po cut, domknięcie scopes/
return w punkcie obserwacji. Kolejność converters/FFT/neg/guard/Gram/top-call
jest zachowana. Do actual trace dochodzą czysto obserwacyjne wrappers.

Źródłowe składniki transportu: of/FFT3 i tablice, add/sub/mul/div/half/neg,
SplitTop/Deep/Adj, dim2/dim3/inner/depth/top, source coefficient/gate checks,
NTT final-check i serializers. Bodies i dependency closure są objęte
porównaniem, nie utożsamieniem nazw. Krytyczne expected edges sprawdza JSON.
Emitted zawiera defined successful KeyGen i obie serializacje; domain facts
ROOT pozostają tymi samymi przy tym samym legalnym E i coins.

Ponieważ zmieniona funkcja nie jest tu wykonywana, transport jest identity
na tych source operations. FLOOR all-word replacement pozostaje przypiętym
wynikiem, ale nie jest potrzebną numerical premise raw-prefix proofu.
Historyczne raporty i certyfikaty zachowują stare hashe. Nie transportujemy
floor CT na loader/Sign ani bit-equality na runtime/cost; GCC nie jest
formalnie zweryfikowany. source_changed=false; brak nowej integracji.
