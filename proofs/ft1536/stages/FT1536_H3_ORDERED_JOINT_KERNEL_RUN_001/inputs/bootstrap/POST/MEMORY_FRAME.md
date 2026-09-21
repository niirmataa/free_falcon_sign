# Source memory, aliasing i deterministyczne zakończenie

Wejściowy frame/lifetime/alignment z RAW/NORMALIZED/TARGETS/LEFT: sk ma24576
initialized fpr words, normalized tree immutable; tmp10752 aligned words;
hm1536 initialized uint16; s1,s2 oddzielne writable1536 int16 prefixes
(caller rezerwuje3072 każdej). Te extents i sk/tmp/output/context są legalnie
rozłączne zgodnie z source restrict/allocator interface. Nie są nowym key gate.

| Obszar | Odczyt / zapis po completed sampling cut |
|---|---|
|sk[0,6144)|odczyt czterech basis rows|
|sk[6144,24576)|tree: brak odczytów suffixu, zachowany|
|tmp[0,1536)|t0: copy x, live do1907, potem post-F0,iFFT0|
|tmp[1536,3072)|t1: copy y, live do1911, potem post-F1,iFFT1|
|tmp[3072,4608)|tx: input x→product→F0, zachowany po1910|
|tmp[4608,6144)|ty: input y→product; potem old x→CM(x,b01)|
|tmp[6144,10752)|sampling scratch: suffix nie czyta/nie zapisuje|
|s1/s2[0,1536)|po jednym int16 store na indeks; norm/encoder read później|
|s1/s2[1536,3072)|nietknięty caller tail|
|hm/context/callback/fault/PRNG|suffix ich nie czyta/nie zapisuje/nie wywołuje|

Memcpy1902/1903/1907/1910 ma n*8=12288 bytes i disjoint extents. Source
CM functions czytają pair real/imag przed zapisami; a in-place wobec własnej
poprzedniej wartości jest dozwolone, b jest rozłączne sk. Add tx,ty i t1,ty
mają rozłączne restrict pointers. Source iFFT index partition i local copies
opisano w IFFT_SOURCE_PROOF; wszystkie reads mają earlier initialized store.
Sk immutable zapewnia equal-word recomputations; nie utożsamiamy add/sub errors.

Rint loop dokładnie1536 iteracji, dla obu arrays tylko t0/t1 reads i własny
int16 store. n,u,size_t/shift/index products mieszczą się w LP64; integer
domains sprawdzono przed arithmetic. Norma czyta wyłącznie zapisane prefixes.
Encoder/decoder footprints: sequential input≤1536, guarded byte stores/reads,
partial writes na failure, header dopiero po success; STATIC_BYTES ma invariant.

Termination suffixu:4 bounded copies,4 pointwise CM i2 adds,2 iFFT(256 cubic,
8*384 binary,768 terminal,1536 scales),1536 dual-rint/store. Brak callbacks,
PRNG lub data-dependent unbounded loop. Encoder ma1536 coefficients i≤129
unary bodies/coeff; decoder na jego image zużywa≤26496 bytes. Norma ma2304
loop iterations. Te skończone bounds nie dotyczą sampling/H2P całego caller.

Kontrole obu buildów porównują cały original/observed tmp, sk i s arrays,
canaries przed/po, unused tails, final tx/ty, wszystkie iFFT stages. Source
analiza footprintu jest uniwersalna dla wymaganych legal extents; C heap
semantics i compiler są poza pełną kernelizacją. Synthetic harness nie wywołuje
do_sign/private loadera/KeyGen ani fake-sampler Sign.
