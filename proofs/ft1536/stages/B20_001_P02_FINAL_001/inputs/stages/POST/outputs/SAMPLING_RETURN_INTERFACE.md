# Whole-root return: przesłanki i wyprowadzenie

Cut: rzeczywisty return ffSampling_fft3:1897. x=tmp[3072..4607],
y=tmp[4608..6143] to residuals, nie sampled integer vectors. LEFT domyka
wszystkie active pre-floor centers do937866518, także−0, i forward guards.
Completed history ma wszystkie normal terminal returns. Rejection stutters
nie dokonują caller stores. To nie totality sampler loop.

## Obie gałęzie, nie tylko prawa

Odebrane terminal returned pairs spełniają caps552/367 i source first-bank
weighted A2 budget849346588; każda768-terminal gałąź ma budżet
E=652298179584. Branch0 factor2, branch1 factor6 pochodzą z LEFT/METRIC_BRIDGE.
LEFT/energy_transfer reconstruction recurrence używa wyłącznie terminal
caps, binary |L|≤1+2^-40, cubic |L10|,|L20|≤2,|L21|≤4 i source operation
errors. Te bounds dotyczą OBU source subtrees; initial target i ideal sample
law nie występują w returned-part recurrence. Po completed left return można
więc zastosować tę samą indukcję do lewego returned merge u i prawego y:

```
|u_C|,|y_C|≤R=115184881,
|u_C-u*|,|y_C-y*|≤δ=20102235062439/562949953421312,
Q_A0(u*)≤2E,  Q_Droot(y*)≤6E.
```

Gwiazdki to exact source-L reconstructions z actual terminal pairs tej samej
historii, idealnymi phase/split maps i ACTUAL immutable L words. Nie idealne
Gaussian samples. R/δ recurrences i source primitive domain były udowodnione
w LEFT; przeniesienie na lewą gałąź korzysta z nowo domkniętego normal history.

Root wykonuje x_C=sub_C(u_C,CM_C(y_C,Lroot)). Odebrany correlated gain daje
P=freq_correction+2^25 δ. Source CM error≤6UP+8η; last sub error≤
U(R+P+CMerror)+2η. Stąd |x_C|≤R+P+CMerror+suberror<2^35, |y_C|<2^27.
Wszystkie operands są ustalone PRZED operation, wewnątrz cap2^100. Equal-word
recomputation wynika z immutable L i niezmienionego y; roundoff sub pozostaje.

## Energia pełnego obrazu basis

Niech B0=(g_hat,-f_hat),B1=(G_hat,-F_hat) będą actual rounded basis rows,
a=||B0||²,c=B1 B0*,j=||B1||²,v=det B. ROOT daje a>1/4, |v-q|≤dc,
|A0-a|≤γa (γ=8U), |Droot-|v|²/a|≤256Uj oraz
|L_C-c/a|≤32U sqrt(j/a). W szczególności nie zakładamy v=q.

Niech Bperp=B1-L_C B0. Orthogonal decomposition względem B0 daje, dla α=1/1024,

```
||(u*-y*L_C)B0+y*B1||²
 ≤(1+α)a|u*|² + [|v|²/a+(1+1/α)(32U)²j]|y*|².
```

Z β=256U*jmax*amax/(q-dc)²<1 otrzymujemy factors
c0=(1+α)/(1-γ)<2 i
c1=[1+(1+1/α)(32U)²*jmax*amax/(q-dc)²]/(1-β)<2.
Po średniej po768 roots pełna energia reference image≤
E*=2(2+6)E=10436770873344. To suma budgets obu gałęzi z root correlations.

Dla actual source root error używamy TYCH SAMYCH triangular coordinates:
Δimage=(u_C-u*−root_defect)B0+(y_C-y*)Bperp.
Nie wolno zgubić Lδ_y przez niezależny x-error. Pythagorean identity daje
||Bperp||²=|v|²/a+a|L_C-c/a|²≤4(q+dc)²+(32U)²*jmax<2^31;
a<2^23. Zatem pointwise combined image error²≤
Eδ=2[2^23(δ+root_defect)²+2^31δ²]. Exact QQ constants i inequalities są
odtwarzane w numeric_certificate.py. Teoria obejmuje wszystkie completed H;
finite fixtures kontrolują jedynie source/model binding.
