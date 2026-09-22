# Pełny błąd source noise map — nie tylko iFFT1/128

Exact outward rationals: ERROR_LEDGER.json; wszystkie dependencies/piny w JSON.
Zakres: każdy required e i legalny Q_S live path, przed rint/narrowing.

## 1. Terminal source returns → innovations

ZERO daje |sub_C(mu,of(Y))−(val(mu)−Y)|≤Er=2^-20 dla każdego current
NumericCenter i source-supported normal integer return. JOINT zapewnia te
premises przed call. r1_C i normal residual0 mają abs≤367, rx_C≤184.
All-finite source Half ma Eh=2^-1023, a final sub error≤U(367+184)+2eta.
Nie zakładamy exact Half na subnormals ani IEEE blanket arithmetic.

Z SOURCE_NOISE_MAP: equivalent innovation errors eta0,eta1 mają bounds
Er+Eh+Elast i Er. Dla actual source sigma parameters:

```
Σ_i eta_i²/sigma_i²
 ≤1536[(Er+Eh+Elast)²/v_stored_min + Er²/v_paired_min].
```

Coefficientwise Cauchy-Schwarz z WYPROWADZONYM V daje Eterminal=sqrt(V*sum),
około0.0867063. To obejmuje wszystkie3072 scalar errors, bez local indep.
Nie poprawiano wcześniejszego ZERO boundu lub zakładano idealnych returns.

## 2. Source-L reconstruction po obu branches

LEFT reconstruction recurrence używa terminal returned-pair caps552/367,
actual L caps,source CM/add/merge/twiddle errors i gamma2^-36,tiny2^-800.
Nie zależy od initial target values. Dlatego po domkniętym normal Q_S history
stosuje się do OBU branches: |u_C-u*|,|y_C-y*|≤
delta=20102235062439/562949953421312. Gwiazdki rekonstruują actual terminal
pairs, nie innovations; terminal discrepancy policzono oddzielnie powyżej.

Root actual x=sub_C(u_C,CM_C(y_C,Lroot)). POST daje osobne root CM/sub errors;
ich suma=eroot. Error actual B image wobec exact-L terminal image można
rozwinąć w TYCH SAMYCH triangular coordinates:
`(delta_u−root_defect)B0 + delta_y*(B1−L_C B0)`.
Nie gubimy L*delta_y przez niezależny x bound, lecz zachowujemy korelację.

## 3. Rounded basis i coefficient error

Dla actual basis a,c,j,v i L_C z VARIANCE_BRIDGE:
a_min=(1/2)/(1+8U) z source Gate00 A0≥1/2 oraz |A0−a|≤8Ua.
Nie jest to nowe gate. Mamy

```
||B1−L_C B0||²=|v|²/a+a|L_C−c/a|²
 ≤(q+dc)²/a_min+(32U)²*jmax = Pperp,
|<B0,B1−L_C B0>|≤32U sqrt(amax*jmax)=Cross.
```

Zatem pointwise joint image error²≤
amax(delta+eroot)²+2Cross(delta+eroot)delta+Pperp*delta² = Eimage.
Parseval average1/768 nie mnoży tej stałej przez768. Dla każdego coefficient
A2 daje |error_r|≤sqrt((4/3)Eimage). Ta nowa source-orthogonality estimate
jest ciaśniejsza niż niezależne product boxes, bez założenia exact det=q/L=ideal.

Source post CM/add ma per-output complex error epost z POST, stąd joint
Q≤2epost² i coefficient allowance sqrt(8/3)*epost. Na końcu source iFFT
z ACTUAL post-frequency input dodaje≤1/128 per coefficient. Basis FFT
approximation nie jest pominięta: referencja używa actual rounded B, a jej
root/metric comparison używa pinned det-error i a/c/j bounds.

Cały E=Eterminal+sqrt((4/3)Eimage)+sqrt(8/3)*epost+1/128 jest outward
wyliczony i **E<1095**. Nie dodajemy input-target FFT error drugi raz:
innowacje są centrowane w actual mu, obejmującym wszystkie source target
updates. Nie twierdzimy przez to equality z independent ideal lattice signature.

## 4. Coarse/failed route

Niezależny box |Lroot|≤2^25,delta i basis caps daje poprawną, ale bezużyteczną
coefficient error majorantę około **3.681×10^9**, ponad rint margin. Daje tylko
q≤1. To luźny bound, nie counterexample. Liczba i wzór zachowane w
artifacts/failed_routes_numeric.json. Samo iFFT1/128 nie jest pełnym budżetem.

Local native/RBF controls obserwują niezerowe source errors (~6.2e-13 i~9.6e-15),
lecz nie zastępują uniform E. Ich małość nie upoważnia do zastąpienia E sample max.
