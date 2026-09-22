# Pre-narrow event i asymetryczne nearest-even endpoints

JOINT/POST zapewniają defined deterministic suffix, source iFFT i actual
rint refinement PRZED instructions na każdej legalnej live Q_S historii.
POST input bound |t|≤4572095+1/128 jest operational domain theorem, nie
variance. Actual int64 w=rint_C(t) jest nearest integer ties-to-even,
|w−val(t)|≤1/2. Nie używamy floor, cast rounding lub późniejszej stored normy.

Dokładny safe real interval dla signed16 preservation:

```
-32768.5 <= val(t) < +32767.5.
```

Przy−32768.5 tie wybiera even−32768 (SAFE); poniżej niego wynik≤−32769.
Przy+32767.5 tie wybiera even32768 (BAD); ostatni poprzedni raw word jest safe.
Oba fixed ties i sąsiednie words są sprawdzone original C normal/ASan/UBSan
i independent exact-dyadic RN oracle. H6PEvent ma cleared-denominator/tie
lemmas oraz joint bad coefficient selection dla obu vectors.

Zatem BadPrecast implikuje dla co najmniej jednego r:
t_r<−32768.5 albo t_r≥32767.5. Korzystamy z jawnie słabszej symetrycznej
implikacji |t_r|≥32767.5. Dla t_r=L_r+delta_r,|delta_r|≤E,d_r=0:

```
Bad_r => L_r >= M albo L_r <= -M,
M=32767.5−E>0.
```

Non-strict tails pozwalają bezpiecznie objąć positive bad tie; nie gubimy
go przez użycie strict >. Negative safe tie tylko powiększa conservative
symmetric tail event, nigdy nie jest błędnie klasyfikowany jako source bad.

To dotyczy w1/w2 PRZED narrowing. Przykład standalone w1=0,w2=32768 pokazuje,
że bad drugiego vector nie jest marginal pierwszego; bez emitted-history claim.
Mały probability bound nie jest twierdzeniem uniwersalnego Safe16. Signed16
stores/norma mogą zmienić wartości; future Q<B nie jest premise tego bridge.
