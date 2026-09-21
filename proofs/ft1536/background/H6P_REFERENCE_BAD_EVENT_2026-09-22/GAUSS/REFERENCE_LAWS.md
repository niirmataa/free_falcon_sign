# Reference laws, domeny i conditioning

Wszystkie source probability claims dotyczą IID_BUFFER i legalnej PAST:
argumenty mu/sigma mogą zależeć od wcześniejszych odczytów/returns, nie od
unread buffer lub przyszłego tape. Nie warunkujemy na przyszłym Q<B,Safe16,
zakończeniu Sign lub wybranych typical samples. IID law i fresh-tail są
przypiętym wejściem; real ChaCha/SHAKE equivalence pozostaje osobnym obowiązkiem.

## D_cert i D_env

D_cert: actual required scalar entries z LEFT/IID/NORMALIZED, emitted same-STATIC
normalized context, current NumericCenter,actual stored/paired sigma,faultNONE,
legal byte/context interface. D_env: każdy raw NumericCenter mu i positive finite
sigma, którego value ORAZ computed dss mieszczą się w odpowiedniej parze
stored albo paired intervals z NORMALIZED/WIDTH_BOUNDS.json. dss jest zawsze
literal inv_C(mul_C(sqr_C(sigma),of_C(2))); bank jest actual first source match.
To przecięcie obu bounds w jednej class, a nie dowolnie niezależny dss argument.

Każde D_cert entry spełnia dokładnie te dwa source interval conclusions,
więc D_cert⊆D_env. dss>last actual coefficient,dss<1,selector-found i scalar
guard exclusion wynikają z odebranych bounds. D_env może zawierać standalone
words niepochodzące z żadnego Emitted key/history; nie zmienia P_key/Emitted.
Legal scalar Sigma jest lokalnym input word, nie globalnym768.

## Trzy odrębne prawa

1. **K_C(mu,sigma)**: exact normalized source accepted weights w_y/A z IID,
   włącznie z integer CDF,sign,floor−0,source arithmetic,BerExp cutoff i counts.
2. **G_(m,v)** na wszystkich y∈Z: m=val(mu),v=val(sigma)^2>0,
   proportional exp(-(y-m)^2/(2v)). Definicja nie używa K_C,weights,A lub dss.
3. **G_hat**: proportional exp(-d_hat*(y-m_hat)^2),
   m_hat=s_C+val(r_C),d_hat=val(dss_C),s_C=floor_C(mu),r_C=sub_C(mu,of_C(s_C)).
   To pomocnicza machine-parameter reference, osobna od celu2.

Dla proof coordinates wybieramy integer s=s_C i y=s−k albo s+1+k,k≥0.
Exact rho_true=m−s∈[0,1] (raw−0 ma s−1,rho_true1); rho_hat=val(r_C)∈[0,1].
Wybranie source s jako przesunięcia indeksu nie zmienia definicji G.

Bank ma EXACT DYADIC a_j=val(coefficient_word). Half-line law
q_j(k)=exp(-a_j*k²)/H_j,H_j=Σ_k≥0 exp(-a_j*k²). To oddzielna reference
proposal; source p_j jest literal rational table law. Dla
Xhat=(d_hat-a_j)k²+d_hat(2k delta_hat+delta_hat²),delta_hat=rho_hat lub1−rho_hat,
q_j(k)/2 *exp(-Xhat)=exp(-d_hat*(y-m_hat)²)/(2H_j).

Takie rho_hat(y) ma sumę C_hat=Z_hat/(2H_j). Dla głównego celu definiujemy
tylko pomocniczą wagę rho(y)=exp(-(y-m)²/(2v))/(2H_j),C=Z/(2H_j).
Normalizacja rho/C daje DOKŁADNIE niezależne G; czynnik H_j znika. Nie jest
to zmiana głównej reference w zależności od K. NORMALIZATION_BOUND wyprowadza
source transport i normalizację, w tym infinite tails.

Opcjonalne G_S=G conditioned on positive K support S nie zastępuje G.
Jego conditioning cost TV(G_S,G)=G(S^c)>0 podano w SUPPORT_AND_METRICS.
