# SCALAR_GAUSSIAN_COMPARISON — teza

Autor projektu: Niirmata. Status:
**H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

Wyłącznie w **IID_BUFFER**, warunkowo względem legalnej PAST z odebranego IID
(bez unread-buffer/future-tape, norm-success lub Sign-success conditioning):
dla każdego required scalar entry w D_cert oraz szerszego jawnego D_env,

```
m=val(mu_word), v=val(sigma_word)^2,
G(y)=exp(-(y-m)^2/(2v))/Σ_z∈Z exp(-(z-m)^2/(2v)),
TV(K_C,G) ≤ 2^-36,
chi2(K_C||G) ≤ 2^-60,
chi2(G||K_C) = infinity.
```

G jest niezależnie zdefiniowany na CAŁYM Z, z lokalną source-input sigma,
nie sigma_sign768 lub nominalną proposal variance. K_C to odebrany exact
source law w_y/A, nie idealny sampler. D_cert⊆D_env przez LEFT/NORMALIZED;
szczegóły domains i conditioning w REFERENCE_LAWS/REDUCTION_DOMAIN.

Source reduction ma0≤x<273,e≤393 i rB∈[0,R],
R=12193974156573/17592186044416 > binary64(log2).63 z394 exponent buckets
przekraczają nominalny upper endpoint; wszystkie actual source buckets mają
rB≥0. Nowy source-bound expm proof obejmuje cały [0,R]. Nie użyto komentarza
e<=393/remainder[0,log2] jako premise, nie poprawiano kodu lub remainder.

Ledger rozlicza exact dyadic CDF, infinite half-line normalizer/quantization,
correction/r/delta, real log2 reduction,Horner/trunc/count/cutoff, accepted
normalizer i G_hat→G. Nowy source A lower bound1/8 jest wyprowadzony;
odebrane1/256 pozostaje historycznym poprawnym wynikiem. G(S^c) jest jawne,
a reverse chi2 infinite nie zostaje zamienione na finite loss.

Trzy normalizer-derived standalone-leaf scalar witnesses obalają nominalne
rB≤literal log2 w D_env; ich Emitted membership nie jest dowiedzione. Extended
ujemne wejście samego expm daje różnicę>3/5 względem exp(-r), lecz nie jest
osiągalną resztą w nowej certified reduction domain. Wyniki zachowano.

Dowód mixed kernel/universal analytical source/QQ-RBF, nie pełny kernel C/real
analysis/compiler proof. Testy101 publicznych kernels nie definiują supremum.
Real-PRNG bridge,full ordered joint law/H6P,joint BadPrecast/Safe16,
reference recovery,Sign→Verify,whole Sign termination/security/CT pozostają OPEN.
POST nadal PARTIAL_PROOF; P_key/Emitted/K_seed[E]/M0/source success event bez zmian.
