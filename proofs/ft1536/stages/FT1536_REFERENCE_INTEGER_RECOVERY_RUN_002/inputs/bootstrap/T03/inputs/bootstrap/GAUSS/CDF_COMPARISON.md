# Literal CDF kontra exact dyadic half-line Gaussian

W IID_BUFFER source p_j(k)=n_j,k/2^128, z odebranym strict shared-U interval
count proof. Reference q_j(k)=exp(-a_j k²)/H_j,k∈N, a_j jest EXACT DYADIC
word, H_j=Σ_k≥0 exp(-a_j k²). Nie nominalna5/20/80/320/768 i nie komentarz
generatora. Ten krok jest niezależny od późniejszych mu/dss/correction weights.

Fresh RBF384 evaluator sumuje k0..1024. Dla M=1024 i a>0:

```
Σ_k>M exp(-a k²)
 ≤ exp(-a(M+1)²)/(1-exp(-a(2M+3))).
```

Ilorazy kolejnych terms maleją, więc jest to rygorystyczny geometric upper
bound na CAŁY infinite tail. Lower sum i upper sum+tail dają H_lo,H_hi.
Wszystkie512 thresholds każdego banku porównano z infinite-tail CDF q(k>u),
z outward rational endpoints, uzyskując |T_u/2^128−Pr_q[k>u]|≤2^-128.
Nie jest to histogram lub interpolacja po continuous parameters: tych2560
literal constants to cały skończony obiekt tabeli, a ogon jest analityczny.

Każdy p_j atom, także duplicate/zero-tail, pozostaje literal. Dla k≤K_j
certyfikujemy q_lower≤q_j(k)≤q_upper, err_k≥|p−q| i
chi_k≥(p−q)²/q. Gdy p=0 używamy q_upper. Poza K p0, więc oba L1 i chi2
dostają dokładnie mass q(k>K), z jawnego enclosure. Każdy dodany term jest
zaokrąglony W GÓRĘ na siatce2^-256; sumy nie tracą ogona.

CDF_COMPARISON.json zawiera wszystkie atomy/threshold checks/H bounds i
uniform exports **L1(p_j,q_j)≤2^-121**, **chi2(p_j||q_j)≤2^-125**.
Pointwise p/q upper jest również certyfikowany dla positive source support;
nie zakładamy relative equality na bardzo małych quantized atoms.
Reverse chi2(q_j||p_j)=infinity z powodu finite support source table.

Main Gaussian comparison konsumuje L1 i forward chi2 z poprawnymi wagami
acceptance i normalizerami, nie zamienia ich w TV bez wymaganych inequalities.
Mutation nominal-a narusza2^-128 premise; mutation p=q pomija certyfikowaną
niezerową różnicę. Obie zachowano wraz z baseline/changed intervals.
