# CDF: dokładne atomy128-bit, wspólne U, deterministyczny bank

Source2733–2828 i literal ft1536-adaptive-cdf-tables.h. CDF_MASS.json zawiera
wszystkie5×512 thresholds T_j,u,513 integer mass numerators i dokładne supports.
Fresh parser porównuje WSZYSTKIE threshold values z również świeżo zbudowanym
inherited CDF.lean. Niczego nie regeneruje z ideal exp lub komentarza headera.

Source comparator128 jest leksykograficznym unsigned porównaniem hi/lo,
z przeniesieniem i equality rozliczonym przez inherited Comparator.lean.
Gettery pobierają hi, potem lo, na rozłącznych fresh bytes. U=(hi<<64)|lo
jest uniform na[0,2^128), a **K_j=Σ_u[U<T_j,u]** dla wszystkich j korzysta
z TEGO SAMEGO U. Wektor K_j ma zależności; nie przyjmujemy niezależności banków.

Wszystkie thresholds leżą[0,2^128), są nierosnące; zero tails i duplicates
są zachowane. Dla K=k>0 dokładny atom to interval
[T_k,T_(k−1)), z T_512=0. Dla k0: [T_0,2^128).
Monotonicity daje prawdziwość strict predicate dokładnie na pierwszych k
positions. Kernel count_all/count_none/count_append formalizuje to partycjonowanie.
Liczności n_0=2^128−T_0, n_k=T_(k−1)−T_k. Gdy endpoints są równe, atom
ma0. Sumowanie teleskopowe daje2^128, masses są nonnegative. Max supports:
**29,59,118,235,365**. U=0 osiąga count dodatnich thresholds; U=T daje
strict endpoint po właściwej stronie. Nie enumerowano2^128 inputs.

Source dss=inv_C(mul_C(sqr_C(sigma),of_C(2))). Certified stored/paired widths
NORMALIZED dają finite positive dss<1 i dss≥ostatni actual coefficient.
Ge comparisons są wtedy mathematical positive-word order. found/take scan
wybiera pierwszy j spełniający dss≥a_j: po pierwszym take found1 zeruje dalsze
take, mask allones przenosi dokładny coefficient word. Dokonane wcześniej
odczyty U nie wpływają na j, który jest fixed z entry PAST. Bank-found jest
wyprowadzony, nie dodatkowo założony przez wymuszenie sigma/key gate.

Independent sign b=get_u8&1 ma mass1/2 dzięki fresh/disjoint theorem.
s=floor_C(mu),r=sub_C(mu,of_C(s)),delta=b?sub_C(1,r):r. Raw−0 daje s=−1,r=1;
endpoint1 nie jest obcinany. Outputs s−k oraz s+1+k są wewnętrznie injective
i rozłączne; source integer bridge zapewnia signed32 range. Table proposal
masses nie są deklarowane jako exact ideal discrete Gaussian. Również
positive proposal support nie implikuje positive RETURNED support po BerExp.
