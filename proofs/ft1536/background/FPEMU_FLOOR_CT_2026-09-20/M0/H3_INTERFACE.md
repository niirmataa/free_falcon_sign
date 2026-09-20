# Gotowy interfejs wejścia następnego zadania H3 (nie wykonany w M0)

## Piny i domena

PROFILE.json i INPUTS określają źródła: falcon-sign.c
`eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8`,
Makefile flags FPEMU, full ternary MODE1, σ768, max attempts16;
keygen `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`.
Norm/Verify candidate pin jest zachowany. Nie dodawać H3G guardu do tej wersji.

Kwantyfikator: każda para (sk,pk) rzeczywiście wyemitowana w E_K, NIE cały
zbiór wejść akceptowanych przez prywatny loader; każdy zgodny M0 environment E,
każda osiągalna historia oracle, wiadomość/canonical target, outer attempt
1..16, każde aktywne wywołanie sampler_large i każdy skończony retry prefix.
Uwzględnić historie po wcześniejszych aborts i wspólny klucz. Fault!=NONE
wraca przed floor i nie jest aktywnym floor call.

## Wymagany typ lematu

Niech Reach_call_C(sk,pk,tau,attempt,call,state,mu,sigma) oznacza konkretny
source execution prefix przy wejściu falcon-sign.c:2841–2864, po dotychczasowych
guardach finite(mu)/positive sigma, z fault=NONE. To relacja do wyeksportowania
przez wykonawcę H3, nie dowolny aksjomat wniosku.

```
forall (sk,pk) in Supp(K_seed[E]), forall reachable tau/attempt/call,
 Reach_call_C(...) =>
   mathematical_floor(exact_value(mu_bits)) in [-2147483283,2147483281]
   and fpr_floor(mu) / long->int conversion has the required exact semantics;
 forall accepted proposals z on the active adaptive branch,
   -365 <= z <= 366 and INT32_MIN <= s+z <= INT32_MAX.
```

W razie korzystania z istniejącego warunkowego H3/H4 trzeba wyeksportować
dokładnie ich dodatkowe przesłanki o sigma/computed dss i dodatnich atomach.
Computed dss jest dokładną dyadyczną wartością wyniku FPEMU, nie automatycznie
parametrem idealnej geometrii przy σ768. Rounded residual rhat=1 nie może
zostać odrzucony jako niemożliwy bez dowodu (jest już częścią H3 arithmetic).

## Miejsca źródła i obowiązki

- do_sign/FFT3/ffSampling/residual/iFFT: sign1870–1934;
- s=fpr_floor(mu), int s: sign2841–2866;
- actual dss i guards: sign2866–2895;
- z=(b?1+k:−k), s+z: sign2898–2969;
- fpr_floor zwraca long, rint int64: fpr-emulated.h98–133;
- świeży kontekst, ten sam wyemitowany sk, poprawne loader state: M0 GAME;
- KeyGen emission/solve/mandatory leaf certificate i |F_i|,|G_i|<=2047
  dla emitted support: konsumować odpowiednie istniejące dowody z pinami.

Wiązać prawdziwe FFT/LDL multipliers, residua i błędy FPEMU. Sama skończoność
mu, właściwe liście lub kampania kluczy nie są proof of range. Nie gubić
korelacji przez niezależne majorowanie; uwzględnić NTRU/Schur/Babai gdy używane.

H3 ma zwrócić zamknięty range/refinement theorem, dokładny kontrprzykład
w jego domenie albo konkretną lukę. Jeśli potrzebny jest nowy guard, to osobny
kandydat i osobne rozliczenie wpływu na abort/law. M0 nie wykonuje tego zadania,
nie losuje kluczy i nie przypisuje temu interfejsowi statusu PROVED.
