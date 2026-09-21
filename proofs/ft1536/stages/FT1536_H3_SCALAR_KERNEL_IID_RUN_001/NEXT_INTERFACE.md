# Eksport: IID scalar kernel oraz trzy osobne dalsze obowiązki

Status: **H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

## Conditional scalar consumer

```
forall legal PAST in IID_BUFFER,
forall mu_word,sigma_word chosen from that PAST with certified entry,
forall ptr in[0,4095] with conditional-IID unread tail:
  exact K_C(mu,sigma)(y)=w_y/A,
  A>=1/256,
  Pr[N=n,Y=y|PAST]=(1-A)^(n-1)w_y,
  post state=(q_ptr(n),R_ptr(n),D_ptr(n)) on this event,
  unread tail/future blocks after finite return remain conditional IID,
  Pr[N>m|PAST]<=(255/256)^m,
  Pr[N=infinity|PAST]=0; E[N|PAST]<=256.
```

Required entries korzystają z LEFT current NumericCenter i NORMALIZED actual
stored/paired widths; law nie zmienia argumentów/source tables. Przy kolejnych
calls mu/sigma mogą zależeć od przeszłych returns. Należy używać tego conditional
kernel/fresh-tail interface, nie produktu nieudowodnionych independent marginals.
Kernel obejmuje outcome i exact resource schedule; ghost cap nie jest source abortem.

## 1. PRNG_REAL_TO_IID_BUFFER — OPEN

Związać real root SHAKE/state56/type0→ChaCha20/layout/counter/refill/getters
z dokładną finite-resource pseudorandom transcript game i dowieść jej
computational loss. PRNG_GAP_INTERFACE określa hidden-state/output access,
Q_ctx/B/L/T i IID tail consumer. Nie podano wartości straty ani równości law.
K_seed[E] i p_K pozostają pojedyncze, bez dodatkowego conditioning/gates.

## 2. SCALAR_GAUSSIAN_COMPARISON — OPEN

Porównać DOKŁADNY K_C(mu_word,sigma_word) z wybraną niezależnie reference
discrete Gaussian/law, z właściwym kierunkiem miary i quantifiers. Uwzględnić
raw−0/floor shift,table quantization/finite support,BerExp cutoff/saturation,
normalizer i actual sigma words. Nie przyjmować K_C=idealGaussian lub exp
accuracy przez nazwę funkcji. Ten etap dowodzi exact integer kernel, nie tego hopu.

## 3. ORDERED_JOINT_KERNEL/H6P — OPEN

Zastosować conditional kernels w actual right-before-left/cubic order,
z dynamic mu dependence i source metric/postprocessing/error maps. Dopiero
osobny whole-history argument może ograniczyć joint WholeCallBad z POST,
obejmujący oba pre-cast vectors i wszystkie reached completed attempts j<16.
Nie przypisano eta_pre,zero probability lub independence. Uniwersalne Safe16
required histories i reference integer recovery/Sign→Verify nadal OPEN.

Dalsze retry/ROM-QROM/reduction composition musi zachować source fault,
norm rejection/cap,bytes i nonreturn oraz M0 observation contract. Publiczny
adversarial Verify domain,NONE/STATIC/r40 i payload framing bez zmian.
Full real-source sampler law,whole Sign termination/security/CT nie wynikają
z tego statusu. Raport kończy bieżący etap; nocny RUN_002 pozostaje pracą
prowadzącego i nie jest uruchamiany w tym pakiecie.
