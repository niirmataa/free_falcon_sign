# Universal STATIC byte-value refinement i source round-trip

Zakres: każdy1536-elementowy signed16 vector b, q18433,logn10,STATIC=1.
Nie potrzeba Safe16 szerokich rint outputs; b jest actual STORED s2. Length
capacity po norm acceptance to oddzielny M0 consumer, nie zastępnik tego proofu.

## 1. Niezależna specyfikacja bitów

Dla w∈[-32768,32767], m=|w|≤32768, s=1 iff w<0, h=m div256∈[0,128],
l=m mod256. Code(w) to s (1bit), l (8bit MSB-first), h zer, jedna jedynka.
Nie ma negative-zero code emitowanego przez encoder. Stream jest konkatenacją
1536 codewords. Body=MSB byte-pack stream z0..7 końcowymi zero padding bits.
T=Σ(10+|w|div256), L=ceil(T/8). Q nie występuje w definicji tych bajtów.

## 2. Symulacja literalnego encoder loop289–379

Przed każdym coefficient: n niewczytanych, x następny initialized int16,
u ukończonych bajtów,0≤acc_len<8. Niech S będzie już dołączonym strumieniem,
K=|S|. Invariant: K=8u+acc_len; zapisane bytes są pierwszymi u bajtami S;
low acc_len bits acc są niewypisanym suffixem S, high bits acc są obojętne.
acc to uint32, mask255. Source w=*x++ promuje do int32; nawet−(-32768)=32768
jest exact i bez overflow. lo=(s<<8)|l<512, ne=h≤128.

Source acc=(acc<<9)|lo mod2^32 i acc_len+=9 dołączają dokładnie9 bits.
Nowa ważna długość≤16. Drain przy≥8 zmniejsza ją o8 i bierze unsigned char
(acc>>acc_len), czyli najstarszy ważny byte. High garbage modulo2^32 nie może
wpłynąć na ważne low16 bits (kernel unsigned_wrap_preserves_suffix). Po co
najwyżej2 drains pozostaje0..7 bits; guard u>=cap jest PRZED store.

Unary `while(ne-->=0)`: przy wejściowym h wykonuje h+1 bodies. Dla pierwszych h
post-decrement ne≥0, bit ((unsigned)ne>>15)&1=0; ostatni body ma ne=−1,
conversion unsigned=2^32−1, bit1. Ostatni failed condition zmienia−1 na−2,
wciąż int32-safe. Każdy body append1, z drain przy8; shifts1/9 i0..8 są legalne,
unsigned wrap jest zamierzony. Źródło emituje więc h zeros+terminator dokładnie.
Indukcja od empty S daje pełne codeword concatenation. Na końcu jeśli r=acc_len>0,
unsigned char(acc<<(8-r)) emituje ważny suffix i zero padding; high garbage odpada.

Gdy cap≥L, każdy guard przechodzi i return=L. Gdy cap<L, pierwsza próba store
o index cap zwraca0, przed zapisem; wcześniejsze dokładnie cap bytes są prefixem
specyfikacji. Buf[cap..] pozostaje niezmienione, nie ma rollback. Przy cap0
brak stores. out=NULL jest osobnym query: pomija guardy i stores, ale increment
u pozostaje, return=L niezależnie od cap. Nie jest to NULL signing buffer.
Worst-case dla signed16 T≤1536*138=211968,L≤26496; size_t/counters nie overflowują.
Pełna indukcja stream value jest tutaj source-analytical; M0 EncoderCount
kernel daje zgodność licznika i guard induction, SourceBytes daje digit/range steps.

## 3. Source decoder462–545

Invariant: v wczytanych bytes, db_len unread bits (0..7 przed header fill);
low db_len db równe unread prefix input bitstream. Fill while db_len≤8 czyta
tylko z v<len, append8 modulo2^32, kończy z9..16 bits. Wszystkie potrzebne
bits są w low16. Sign z highest pending bit, następne8bits lo; po subtract9
zostaje0..7 bits. Unary czyta po jednym; gdy bufor pusty, źródło bezpiecznie
ładuje następny byte. Dla encoder stream napotyka dokładnie h zeros i terminator,
więc ne=h≤128 i guard ne>255 nie odrzuca. Nie występuje uint32 unary wrap.

lo+(ne<<8)=m≤32768. Dla sign0 w≥0 i m≤32767, cast daje w. Dla sign1,m>0,
source robi `-(int16_t)m` z integer promotion, następnie store int16.
Dla m<32768 jest to−m; dla m=32768 pierwszy cast daje−32768, promowana
negacja int32 daje32768, final signed16 store daje−32768. Kernel
coefficient_roundtrip obejmuje oba przypadki z literalnym double narrowing.

Indukcja1536 repetitions daje dokładnie b, także actual endpoint−32768.
Ponieważ każdy fill czyta tylko potrzebny byte, po terminatorze ostatniego
coefficient v=ceil(T/8)=L i db_len=8L−T<8. Pozostałe bits są padding0,
source final mask check przechodzi. Return=L. Dla wejścia dokładnieL bytes
to full consumption; z dodatkowym suffixem decoder nadal zwracaL, a caller
verifier może wymagać pełnego input length. Nie przypisujemy decoderowi
bijection dla wszystkich accepted/noncanonical/adversarial strings; np.
negative-zero code może być accepted. Dziedzina Verify nie jest zawężana.

## 4. Caller i kontrole

Framing to0xaa||Body: (ter1<<7)|(STATIC1<<5)|logn10. Header store następuje
DOPIERO po dodatnim codec return. Cap<2 to wcześniejszy caller return0.
Przy encode failure header nietknięty, body może mieć partial writes.
Na sukcesie reszta legalnego output buffer pozostaje niezmieniona; nonce40
jest oddzielny od payload, brak paddingu do4096. NORM_AND_CALLER_BINDING
określa dokładny branch scope i konsumuje M0<=3160.

Kontrole normal/ASan/UBSan porównują full bytes z niezależnym bit-packerem,
literal unsigned encoder model i actual decoder. Pokrywają wszystkie65536
signed16 values w43 publicznych vectors, actual local suffix outputs, zero,
M0 length3156 witness, strict norm B−1/B/B+1. Dla każdego: caps0/1/L−1/L/
4095/4096/L+1, query mode, partial writes/header/canaries, exact decode,
truncation i suffix consumption. Nie są podstawą universal stream induction.
