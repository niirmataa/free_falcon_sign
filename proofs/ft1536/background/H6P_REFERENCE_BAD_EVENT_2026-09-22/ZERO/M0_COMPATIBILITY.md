# Porównanie starego i nowego interfejsu

M0/H3_INTERFACE i H3_RANGE są frozen inputami. Nie zmieniono ich bajtów,
kwantyfikatorów ani werdyktu PARTIAL_PROOF.

| Własność | Stare H3_RANGE | H3_ZERO_SCALAR |
|---|---|---|
| Domena globalna | emitted-KeyGen/M0 Reach | NIE dowiedziona w tym etapie |
| Domena lokalna | CenterClass z NotNegZero i C_mu | niezależny NumericCenter(val), bez NotNegZero |
| Floor | source=mathematical floor | source=mathematical floor−eps0 |
| Cast/s+z | conditional po CenterClass | wszystkie NumericCenter, z∈[-365,366] |
| Fraction | dokładne[0,1) dla mathematical floor | dokładne rho∈[0,1] dla source s_C |
| r_C/delta_C | stary backend/domain obowiązek | uniwersalna lokalna analiza: finite,+0/positive normal,[0,1] |
| Błąd scalar-sub | wcześniej jawnie otwarty | E_r=E_res=2^-20 z instrukcji źródłowych |
| Global errors/LDL | otwarte | nadal otwarte |

ValueDomain.exponent_from_value wyprowadza exponent<=1053 z pełnego val,
zanim użyto starego mathFloor. ZeroRho.old_implies_numeric i old_new_relation
pokazują, że dla Word64 stary CenterClass odpowiada NumericCenter wraz
z wykluczeniem−0. Nowy wynik nie dowodzi source==mathematical floor dla−0,
więc nie może ustawić H3_range_proved=true.

Dokładne zero endpoints:
- +0: source s=0, rho=0, r_C=+0, delta_C=1;
- −0: source s=−1, rho=1, r_C=1, delta_C=+0;
- −2^-1074: source s=−1, rho=1−2^-1074, r_C=1, delta_C=+0.

Źródłowy support propozycji nadal z∈[-365,366]. Zatem możliwe przesunięte
y=s_C+z to dla−0 przedział[-366,365], a dla+0 [-365,366]. Nie deklarujemy
równości tych praw ani równości praw scalar output ze względu na samo
val(-0)=val(+0). Truncated support, atomy brzegowe, computed r/delta i
ich error terms wymagają własnego spożycia w source scalar-law/acceptance
bridge. Nie przydzielono automatycznej globalnej straty, nowego abortu lub
równoważności H1R/FFO/R5T/M7.

## Dokładny następny globalny typ

```
forall E,sk,pk,history,attempt,call,state,mu_bits,sigma_bits,
  Reach_call_C(E,sk,pk,history,attempt,call,state,mu_bits,sigma_bits) ->
  NumericCenter(mu_bits).
```

Reach zachowuje emitted successful-KeyGen support, legalny M0 environment,
ładowanie tego samego sk, ordered source buffers i pre-dss calls; obejmuje
także próby później odrzucone przez normę. Brak norm acceptance nie wycina
stanów. M0 capacity3160/4096 nie daje wcześniejszych center bounds.

Odrębnie: source emitted/loader/internal subtractive LDL, split/merge,
FPEMU oraz ordered next-center bounds wciąż trzeba związać globalnie.
Na poziomie terminalu nowy E_res można już użyć w kolejności: NumericCenter
bieżącego call → bezpieczny return → rzeczywiste residuum → kolejny center.
E_half/E_add pozostają nazwanymi przesłankami tam, gdzie ich argumenty/domeny
nie są właśnie objęte obecnym lokalnym twierdzeniem. Sticky fault-return0
jest inną gałęzią i nie jest Gaussowską próbką blisko centrum.

M04096 payload, oddzielny nonce40, zmienna długość, pełne NONE/STATIC Verify,
jeden K_seed[E], sigma768/B2093922385,16 attempts i parametry Q_s,Q_H,t,w,L
są zachowane. Żaden nowy guard ani canonicalization zera nie został wdrożony.
