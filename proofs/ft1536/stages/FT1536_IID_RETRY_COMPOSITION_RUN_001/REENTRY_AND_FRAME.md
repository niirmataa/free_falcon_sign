# Wyprowadzenie wszystkich reached entries z jednego entry

## Invariant na guard następnej próby

Po k completed stored-norm rejections (0<=k<=16) pozostają: canonical hm,
ten sam normalized sk/basis/raw-L/width map, q/logn/ter/comp/sig capacity,
legalne live disjoint allocations, legalny squeezing rng state. Tmp i s1/s2
mogą mieć dowolne poprzednie, poprawnie zapisane wartości. K ma counter k,
sig jeszcze nie był zapisywany. Pozostały idealny tape jest fresh względem
dozwolonej filtracji. Nie zakładamy Safe16 poprzednich outputs.

Base k=0: dokładnie REGION_ENTRY. Dla k=16 guard17 od razu kończy. Dla k<16:

1. **Init/context.** frng281–324 definiuje wszystkie state bytes używane
   przez refill z aktualnego56-byte SHAKE output, ustawia type1, initial
   refill i ptr0. State.d poza56 bytes nie jest read w tej ścieżce.
   Counter/preserved first48 projection jest total unsigned arithmetic.
   Legal rng state jest zachowany przez fixed-length squeeze. Local `tsc`
   nie musi zachować starej zawartości:3357 resetuje fault,3358/3359 wybiera
   właściwy callback/context. Fresh block jest nowy także gdy state56 się
   powtarza. Żadna przyszła norm decision nie jest czytana.
2. **Target overwrite.** Do_sign1859–1869 wylicza legal offsets:
   t0=tmp0,t1=1536,tx=3072,ty=4608,tz=6144,tree=sk6144. Fill1874–1879
   zapisuje wszystkie t0 z hm. FFT1886 czyta wyłącznie nowe t0. Memcpy1888
   kopiuje wszystkie12288 bytes do t1 PRZED jego odczytem; implicit-zero
   comment nie jest initialization premise. Mul/scale1889–1892 czytają
   nowe t0/t1 i readonly basis. TARGETS daje source-word/root target bounds
   i initialized reads niezależnie od dawnych tmp/outputs/context.
3. **Root entry/application.** NORMALIZED nadal dotyczy tego samego sk.
   TARGETS daje actual canonical challenge target; LEFT daje forward
   NumericCenter, width/source-operation domains i brak fault dla każdego
   ACTIVE_PRE_FLOOR history. JOINT dostarcza ordered3072-call kernel,
   initialized scratch/frame i a.s. return w IID. Sampling destinations
   są tmp/outputs/context, nie sk/hm/fs controls. Source root theorem
   rozpoczyna od legal scratch allocation, nie wymaga starego initialized
   tz lub starych tx/ty. H6P konsumuje ten dokładny entry i conditional
   fresh-tail, z uniform p_outward. To moment PRZED root sampling, nie
   retrospektywne wywołanie po norm acceptance.
4. **Suffix/frame.** POST obejmuje zarówno Safe16, jak i not-Safe16:
   actual reconstruction/iFFT/rint są defined, wide |w|<=4572095, a GCC14.2
   pinned int16 narrowing ma exact modulo interpretation. Out-of-range
   cast nie jest undefined write i nie zmienia destination range. Stores
  1931/1932 inicjalizują oba pierwsze1536-elementowe outputs. tmp/s1/s2
   są jedynymi array destinations suffixu; sk/hm i caller controls są
   zachowane. Nie trzeba Safe16, aby wyprowadzić następny legal entry.
5. **Stored norm/rejection.** POST/LV Norm64 daje defined strict norm na
   wszystkich int16 arrays. Jeżeli norm odrzuca, nie wykonuje się codec,
   caller wraca do guard z powyższym frame. Getter pointer może być niezero;
   nie jest przenoszony do następnego init. Stary tail zostaje porzucony,
   a filtration lemma daje świeżość następnego initial block. Otrzymano
   invariant k+1, także jeśli ukończony attempt miał joint BadPrecast.

Indukcja ta instancjuje `RetryIID.reentry_induction`: `preserve` nie jest
otwartym source assumption — discharge stanowią kroki1–5 i przypięte
upstream contracts. Wrócenie z normą accepted kończy indukcję; nie konstruuje
się fikcyjnych późniejszych source samples. Inner nonreturn kończy tylko
finite-prefix argument i ma conditional measure0, jak w SCHEDULER.

## Boundary audytu

Jest to source destination/range/domain proof z pinami, nie kernelized C
heap/compiler theorem. Whole-key/hm stability nie wynika z przypadków
canary: wynika z disjoint destinations we wszystkich konsumowanych
prefix/root/post contracts. Native controls z publicznymi stubs i celowo
brudzonym tmp sprawdzają praktyczne powiązanie tych slices, bez Emitted
membership albo wykonania pełnego do_sign.
