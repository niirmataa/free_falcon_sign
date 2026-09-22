# Literalny suffix i mapa stanów

Przed1902 oznacz x=tx,y=ty i basis [b00,b01,b10,b11]=[g,-f,G,-F].
CM_C/add_C/iFFT_C to source integer-FPEMU algorithms w fizycznym packed order.

| PC | zapis / zachowane snapshoty |
|---|---|
|1902,1903|t0=x,t1=y (oddzielne copies)|
|1904,1905,1906|tx=add_C(CM_C(x,b00),CM_C(y,b10)); ty tymczasowo product|
|1907,1908|ty=CM_C(x,b01), używa starego x z t0|
|1910,1911,1912|t0=tx; t1=add_C(CM_C(y,b11),ty)|
|1914,1915|t0=iFFT_C(t0),t1=iFFT_C(t1)|
|1931,1932|s1_i=narrow16(rint_C(t0_i)),s2_i=narrow16(rint_C(t1_i))|

Kolejność sumy w t1 jest source b11 product + b01 product. Nie dodajemy hm,
nie odejmujemy od hm, nie negujemy drugiego rint. Probe branch jest nieaktywny.
Literalne source bytes są w checks/suffix_original.inc; observer ma oddzielny
diff i porównuje final memory z oryginalnym slice.

## Domains i transport do współczynników

X<2^35,Y<2^27 z całego return. Basis complex modulus caps:
bs=1536+2^-25, bL=3144192+2^-14, po exact P_key coefficient bounds i źródłowym
FFT error z ROOT (nie host FFT). Products/sums coarse<2^49. Przed każdą
instrukcją argumenty add/mul są finite i <2^100. Source per-output roundoff
εpost=6U(Xbs+YbL)+16η+U(Ps+PL)+2η,
gdzie Pz=(1+6U)*product+8η. Nie traktujemy rounded operations jako liniowych.

Dokładna inverse evaluation I jest jedynym real degree<1536 polynomial z
wartościami packed F_j na r_j=1+6rev8(j/3)+1536(j%3), root order4608,
i conjugates na pozostałych roots Phi. Jej A2 identity:
Q_A2(I(F))=(1/768)Σ|F_j|², ||coeff||₂²≤2Q_A2.
Stąd dla każdego z dwóch actual post-frequency vectors:

```
max |F_j| ≤ ceil(sqrt_up(768E*)+sqrt_up(Eδ)+εpost)=89531345,
max |I(F)_i| ≤ ceil(sqrt_up(2E*)+sqrt_up(2Eδ)+2εpost)=4572095.
```

sqrt_up to jawne ceil-integer square root enclosure. Nie jest to norma całego
przed-cast integer signature i nie korzysta z przyszłego Q<B. IFFT_SOURCE_PROOF
wiąże I z faktycznym iFFT_C, RINT_REFINEMENT z faktycznym int64 wynikiem.
Dokładne bitwise mapy są w post_model.py; nie definiujemy reference lattice pair
przez source output i nie ogłaszamy na tej podstawie reference recovery.
