# Typed export do ordered/H6P oraz osobnego PRNG hopu

Status H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL.
W IID_BUFFER, dla każdej legalnej PAST i mu/sigma∈D_cert⊆D_env:

```
from: exact source conditional K_C(mu_word,sigma_word)
to: G_(val(mu_word),val(sigma_word)^2) on all Z
TV <=2^-36
chi2(K_C||G) <=2^-60
chi2(G||K_C) = infinity
```

Dodatkowo sourceA≥1/8, forward likelihood bound i exact positive support S
oraz t=G(S^c) upper są w ERROR_LEDGER. Jeśli consumer użyje G_S, musi jawnie
dodać TV(G_S,G)=t i normalizację1−t; główna reference tutaj NIE jest conditioned.
Ghat ma osobną definicję,parametric transport i bounds, nie jest aliasem G.

## ORDERED_JOINT_KERNEL/H6P — dalej OPEN

Consumer musi użyć IID conditional kernel/fresh-tail, actual right-before-left
order i adaptive mu/sigma wyliczanych z PAST. Potrzebne są shared-history
parameter semantics i domain invariant w porównywanych procesach. Reference
untruncated Gaussian może wyjść poza source support i następny legal NumericCenter
prefix; taki tail/domain-exit event trzeba rozliczyć. Nie mnożymy niezależnych
marginals i nie stosujemy reverse/high-order likelihood theorem przez support gap.

Następnie pozostają source raw-L/stable-D/transform maps,global reference lattice
law,integrality/rounding/tie gap oraz joint WholeCallBad z POST (oba vectors,
wszystkie reached completed attempts). Same scalar TV/forward-chi bounds nie
dają Safe16,eta_pre lub Sign→Verify. Historyczny POST pozostaje PARTIAL_PROOF.

## PRNG_REAL_TO_IID_BUFFER — osobno OPEN

Trzeba powiązać real root SHAKE/state56/type0→ChaCha20/IV-counter/refill/getters
z dokładną finite-resource transcript game i dowieść jej computational loss.
Niniejsze bounds dotyczą tylko IID_BUFFER; nie dowodzą realnego output law,
real termination lub pseudorandomness. Skonsumować dokładny resource interface
IID,nie zastępować56 bytes standardowym448-bit key albo dowolnym get_bytes.

Single K_seed[E] i p_K raz,source success/abort/bytes,16 outer attempts,M0
STATIC4096/r40 i adversarial Verify domain są ustalone. Brak nowych key gates,
clippingu,epsilon w M0 lub conditioning na future acceptance. Dalsze
retry/ROM-QROM/reduction/security/CT wymagają własnej kompozycji.

Ocena użyteczności: per-scalar bound jest mały i ilościowy,ale2^-36 nie jest
deklaracją globalnego security level. Kierunek forward chi2 jest istotny;
reverse∞ to rzeczywiste ograniczenie metody. Handoff kończy ten etap,bez
uruchamiania kolejnego zadania lub nocnego RUN_002 prowadzącego.
