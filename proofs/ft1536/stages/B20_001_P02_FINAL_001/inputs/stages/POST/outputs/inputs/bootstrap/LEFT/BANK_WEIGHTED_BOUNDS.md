# Source bank inequalities i terminalna waga A2

Autor projektu: Niirmata. U=2^-48, eta=2^-900. Wszystkie piny i dziedziny
pochodzą z niezmienionego emitted normalized key i source scalar interface
ORDERED. Current NumericCenter musi być ustalone PRZED NORMAL_RETURN/ZERO.
Nie zakładamy rozkładu albo niezależności zwróconych samples.

## 1. Pierwszy udany source comparator

Source dss=inv_C(mul_C(sqr_C(S),of_C(2))), w tej kolejności. Normalized S0/S1
mają positive normal squares w(1,1024). Z trzech local source error contracts:

```
(1-epsilon)/(2S²) < dss_C < (1+epsilon)/(2S²), epsilon=2^-40.
```

bank_bounds.py sprawdza exact QQ factors (1±U)/(1∓U)^2 i eta terms, przy
S²∈(1,1024). Nie podmieniono dss idealną funkcją. Positive-word fpr_lt jest
porządkiem realnych wartości. Selector source2808–2822 wybiera PIERWSZY
ge, zatem dla wybranego j:
`dss_C>=a_j`, a dla j>0 `dss_C<a_(j-1)` (strict failure!). Wniosek:

```
S² <= (1+epsilon)/(2a_j),
S² >  (1-epsilon)/(2a_(j-1))       (j>0).
```

Dla j0 dolny bound pochodzi z actual normalized width enclosure. Końce są
przecięte z odpowiednią stored/paired enclosure. Wszystkie10 rekordów mają
dyadic coefficients, strict/inclusive labels, domain i read moment w JSON.
Actual supports29/59/118/235/365 wynikają z liczby dodatnich u128 thresholds
i source first-bank scan, nie z nominalnej Gaussian variance.

## 2. Związek storedD z obiema width classes

D jest source stable word konsumowanym przez normalizer w danej fizycznej
pozycji. Source sqrt/div proof daje
`768²(1-2^-40) < D*S0² < 768²(1+2^-40)`.
S1=mul_C(IW1I,S0), IW1I bits3ff279a74590331c, dokładna wartość dyadic; source
mul i constant-square defect dają
`(4/3)*768²(1-2^-39) < D*S1² < (4/3)*768²(1+2^-39)`.
Obie nierówności są sprawdzone exact QQ, z eta/cross terms; brak RN premise.

Normal scalar residual dla wybranego j ma abs<=K_j+1+2^-20. Stąd source
weighted bounds to minimum dwóch wcześniej dowiedzionych majorant:
`Dmax*R_j²` oraz `(D*S_class² upper)*R_j²/(selected variance lower)`.
To pełna domain implication dla banku, nie maximum obserwowanych fixtures.

## 3. Terminal pair, half i cross term

Oryginalny base0: paired call daje r1; rx=half_C(r1); updated mu0 daje normal
residual u0, po czym returned r0=sub_C(u0,rx). Mamy
`r0+r1/2=u0+delta`, gdzie
`|delta| <= half_error + last_sub_error < 2^-37`.
Half all-finite bound2^-1023 i source sub bound U*(367+184)+eta rozliczają
wszystkie znaki/zera, bez half=RN assumption. ZERO daje u0/r1 dopiero po
ich właściwych current center domains.

Dokładna tożsamość, w kernelze w skali4:

```
Q_A2(r0,r1)=r0²+r0*r1+r1²=(u0+delta)²+(3/4)*r1².
```

W szczególności oba scalar squares NIE mają wspólnej identycznej wagi.
Czynnik3/4 pary konsumuje wyprowadzony4/3 w paired D*S1². Dodatkowe
`Dmax*(2*Rmax*|delta|+delta²)` zachowuje half/last-sub defect.

Nowy uniform source budget (outward ceil dokładnej rational sum):
**D*Q_A2(r0,r1) <=849346588**.
Prawe subtree ma768 terminal pairs, więc **652298179584** to budget sumy.
Ukończenie z faultNONE implikuje wszystkie wcześniejsze NORMAL_RETURN,
przez sticky flag. Rejection stutter nie wnosi nowego residualu.

Native700 przypadków140 D words obejmuje oba width classes, wszystkie banki,
progi±8ULP, endpoints,−0/half i rzeczywiste updated mu0. To local gated-leaf
kontrole; nie emitted witnesses. Uogólnienie wynika z powyższych inequalities.
