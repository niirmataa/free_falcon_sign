# STATIC: uniwersalny bound3160 i świadek3156

Status: **PROVED_ANALYTIC_AND_KERNEL_COUNT_MODEL_WITH_PINNED_C_BINDING**.
Przesłanki źródłowe: signed int16 s1,s2, profil N1536/q18433/j8/STATIC,
rzeczywiste strict norm acceptance Q(s1,s2)<B=2093922385 i legalny bufor.
Nonce nie jest częścią tej pojemności. Nie deklaruje się optimum3160.

## 1. Geometria i całkowitoliczbowy bound

Dla A2(x,y)=x²+xy+y² mamy
`2*A2(x,y)=x²+y²+(x+y)²`, więc A2>=0 i x²+y²<=2*A2.
Sumowanie po dokładnych parach offset768 daje Q0(s1)>=0 oraz
`sqSum(s2)<=2*Q0(s2)<=2*(B−1)=4187844768`.

Klasyczny skończony Cauchy daje
`(Σ|s2_i|)²<=1536*Σs2_i²<=2*1536*(B−1)`.
Końce całkowitoliczbowe sprawdzono dokładnie:

```
2536243² <= 2*1536*(B−1) < 2536244².
```

Kernel nie wymaga biblioteki Real lub założenia o pierwiastku. Używa
równoważnie wystarczającego majorantu z `(abs(x)−1651)²>=0`:

```
3302*|x| <= x²+2725801
3302*Σ|s2_i| <= 4187844768 + 1536*2725801 = 8374675104
3302*2536244 = 8374677688 > 8374675104
Σ|s2_i| <=2536243.
```

Ponieważ `256*floor(|x|/256)<=|x|`, suma quotientów<=9907.
CapacityMath dowodzi wszystkich użytych sum i nierówności dla tych samych
Q/Q0 co Norm64. Matematyczny bound jest nawet ważny bez signed16 ograniczenia;
source-corollary stosuje dokładnie signed16 i STRICT_B z L_V.

## 2. Rzeczywista długość kodera

falcon-enc.c289–379, j=8 z q18433. Na każdy współczynnik:
1 sign bit +8 low bits +ne zero bits +1 terminator, ne=floor(|x|/256).
Komentarz o7 low bits nie zmienia aktywnego kodu j=8.

`w=*x++` promuje int16 do int32. Negacja−(−32768)=32768 mieści się w int32;
ne jest0..128. W `while(ne-->=0)` ciało wykonuje się ne_initial+1 razy,
z nowymi wartościami ne od ne_initial−1 do−1. Ostatni bit pochodzi z
unsigned32(−1)>>15 &1, wcześniejsze są0. Następny fałszywy test pozostawia−2,
bez signed overflow. source_ne_bounds/terminal_bit/post_decrement_count
rozliczają ten fragment, bez mylenia go z decoderowym unsigned unary.

EncoderCount śledzi użyte bajty i acc_len. Prefix9 dodaje9 i wykonuje
faktyczny, co najwyżej dwukrotny drain; unary dopisuje ne+1 bitów; finish
obsługuje padding. Każdy write zawiera dokładny guard u<max_out_len.
Inwariant `weight=8*used+bits`, `0<=bits<8` dowodzi conservation, minimalnego
ceil oraz sukcesu wszystkich guards przy wystarczającej pojemności.
Acc jest unsigned32: jego wrap nie zmienia liczby emitowanych bajtów.
Shift counts pozostają legalne (prefix drain0..8, final padding1..7).

```
STATIC bits <=10*1536+9907=25267
encoded data length <=ceil(25267/8)=3159
payload (header included) <=3160 <4096.
```

`STATIC_FITS_4096` ma wejście source isShort=true i daje sukces
encodeCount4095 dla List.ofFn s2 oraz granicę payloadu. positive_encoder_length
gwarantuje dodatni return; nie myli się success0 z failure. Źródłowy Sign
przekazuje sig+1,4095 i dopisuje header dopiero po sukcesie.

To jest kernelowy argument długości/control-flow i jawny binding do C,
nie ponowny dowód całego byte-value correctness kodera. Wymagany rzeczywisty
round-trip, canaries i normal/ASan/UBSan sprawdzono poniżej.

## 3. Syntetyczny świadek

s1=0, s2=(x,−x), x[0..329]=1792, x[330..767]=1536.

```
Q =330*1792²+438*1536²=2093088768 <2093922385
L1=2528256
sum quotients=2*(330*7+438*6)=9876
bits=25236, encoder bytes=3155, payload=3156.
```

CapacityEndpoint dowodzi signed range, dokładnego Q i długości kernelowo.
Sage wylicza je niezależnie. Rzeczywiste falcon_is_short zwraca1.

| Capacity payloadu | Capacity przekazana encoderowi | Wynik |
|---:|---:|---|
|2049|2048|return0|
|3073|3072|return0|
|3155|3154|return0|
|3156|3155|3155 data bytes, round-trip PASS|
|4096|4095|3155 data bytes, round-trip PASS|

Pomiar out=NULL:3155. Canaries przed/po faktycznej capacity nienaruszone;
nieużyty suffix przy sukcesie pozostał nietknięty. Norma/length/round-trip są
identyczne pod normal i ASan/UBSan. Dodatkowe przypadki: zero payload1921,
short x=1536 payload3073 dokładnie na granicy, oraz non-short−32768 payload26497
(ostatni pokazuje znaczenie przesłanki Q<B, nie przeczy boundowi).

Mutacja usuwająca unary terminator daje payload2964; j7 zamiast j8 daje4198.
Sprawdzenia długości/round-trip odrzucają je. No-op przechodzi. Framing mutation
akceptująca rlen39 jest wykrywana niezależnie od zgodności surowego r||m.
Pełne dane: artifacts/capacity_checks.json i checks/native_*.json.

Nie wykonano KeyGen ani Sign i nie czytano sekretów. Świadek nie jest
wylosowaną sygnaturą, przypadkiem EUF-CMA ani dowodem reachability H3.

## 4. Konsekwencja i pozostały zakres

Brak miejsca nie powoduje failure STATIC po source norm acceptance przy
wybranym legalnym buforze4096. To usuwa WYŁĄCZNIE encoding-space bad event
w tym miejscu. Loader, entropy, fault,16-retry exhaustion, geometria/pre-cast,
źródłowa poprawność emitowanych b i budgets pozostają rozliczane osobno.
H6P z dawnym warunkiem>=3073 nie jest automatycznie przeniesiony.
