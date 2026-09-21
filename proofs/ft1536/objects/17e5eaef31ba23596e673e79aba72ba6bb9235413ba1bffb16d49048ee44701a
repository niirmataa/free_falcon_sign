# Support, kierunek i jawna strata conditioning

W każdej legalnej PAST IID_BUFFER i dla D_env/D_cert:

```
S={s_C+z(k,b): n_j,k>0 AND e_C(k,b)<64}.
```

Nowy expm proof daje Z>0, więc powyższa definicja jest dokładnie positive K_C
support. S niepusty (IID positive atom),skończony,⊆[s_C−365,s_C+366]. Zera
table quantization i forced cutoff nie są traktowane jako positive atoms.

G_(val(mu),val(sigma)^2) ma strictly positive mass dla KAŻDEGO integer y:
variance>0, exp finite argument>0 i Gaussian normalizer finite positive przez
sum/infinite-tail bound. Zatem **K_C≪G** i forward chi-square z ledgeru jest
skończona,≤2^-60. TV jest symetryczna,≤2^-36.

Natomiast y=s_C+367 daje K_C(y)=0<G(y) dla KAŻDEGO entry. Stąd **G nie jest
absolutely continuous względem K_C i chi2(G||K_C)=∞**. To uniwersalna informacja
o kierunku miary, nie przypadkowy overflow numeryczny ani mały approximation
error. Kernel finite_support_reverse_failure formalizuje użyte support logic.
Nie eksportujemy reverse finite chi-square lub nieograniczonego ratio theorem.

## Jeśli przyszły consumer wybierze G_S

G_S=G conditioned on S ma normalization1/(1-t),t=G(S^c). **TV(G_S,G)=t>0**.
Niniejszy główny cel pozostaje G na Z. Tail certificate obejmuje:
-source proposal truncation poza D_j;
-source e>=64 cutoff wewnątrz D_j;
-holes n_j,k=0 wewnątrz D_j (bounded przezCDF L1, a nie pominięte).

Dokładny uniform upper:
`t ≤4(T_prop+T_cut)+4 exp(ep)*L1(p,q)` w ERROR_LEDGER.json.
Strict positivity wynika z dowolnego y poza finite S, nie z zakresu RBF table.
Nie nazywamy probability mass poza skończonym oknem zerem. Conditional
Gaussian może ułatwić przyszłą zgodność supportu, lecz jego cost i normowanie
muszą być doliczone we właściwym kierunku. Nie dowiedziono tutaj reverse
chi2(G_S||K_C) ani pełnej ordered/H6P kompozycji.

Point controls używają independent RBF384 evaluator do2049 terms plus
rigorous infinite-tail bound. Dla każdego101 examples podano main i machine
reference,normalizer,TV,forward chi2,tail i dodatni Gaussian mass poza K.
Ich maxima są diagnostyką bindingu, nie uniform supremum proofem.
