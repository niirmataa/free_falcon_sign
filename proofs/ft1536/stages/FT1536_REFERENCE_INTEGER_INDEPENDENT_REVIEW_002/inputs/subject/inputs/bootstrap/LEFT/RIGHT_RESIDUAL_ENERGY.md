# Actual right residual i energia wszystkich normal histories

Przesłanka transferu: actual right subtree wróciło z faultNONE. To nie theorem
termination. Przez source sticky flag wcześniejsze completed calls były
NORMAL_RETURN; rejection stutters nie dodały caller stores/errors. Odebrany
ORDERED right theorem zapewnia NumericCenter PRZED każdym z tych calls,
więc bank/terminal budgets nie są kołowym założeniem.

## 1. Exact reconstruction z actual words

Weź rzeczywiście zwrócone terminal pairs(r0,r1), nie sampled integers ani
ideal scalar residuals. Zdefiniuj Z* przez exact coefficient merges/backsolve
w actual order, z ACTUAL source L values i ideal root phases. W każdym
binary node: z1*=merge(right), z0*=merge(left)−z1*L. W cubic z2*, potem
z1*=merge(child1)−z2*L21, potem z0*=merge(child0)−z1*L10−z2*L20. To te same
L i snapshots, które source ponownie czyta; nie niezależne roundoff samples.

METRIC_BRIDGE definiuje S_stable przez dokładnie tę rekonstrukcję, zatem
`S_stable(Z*)=sum_i stableD_i Q_A2(r0_i,r1_i)`.
To algebraic identity dla linear reconstruction, nie założenie o source
return. Bank proof gives sum<=652298179584, niezależnie od joint law/history.
Z porównania metryk:
`Q_Re(Droot_C)(Z*) <=6*652298179584 =3913789077504`.

## 2. Source residual versus exact reconstruction

Actual z1 nie jest automatycznie Z*. Nowy signed error allowance
Γ=2^-36, tau=2^-800 obejmuje split/merge/CM/add-sub rounding. Exact polynomial
coefficient checks potwierdzają ten silniejszy allowance z U/eta/twiddles.
Half/last-sub terminal error jest już w actual terminal pair budget; nie
liczymy go ponownie jako błąd rekonstrukcji.

Indukcja reconstruuje tylko returned part po child returns. Child actual
caps R0/R1 są odebranymi uniform ORDERED caps, a E0/E1 mierzą actual output
minus exact skeleton. Merge: Emerge<=E0+E1+Γ(R0+R1)+tau. Product:
Eprod<=|L|Eright+Γ Rright |L|+tau. Last sub dodaje
Γ(Rmerge+Rprod)+tau. Analogicznie liczone są TRZY cubic corrections, a
top merge kończy recurrence. Current-target adds nie występują w tej
rekonstrukcji: wpływają na actual terminal responses, które wzięliśmy już
z tej samej historii i objęliśmy uniform bank bounds.

Wszystkie roundings są outward na siatce2^-50; raw source errors pozostają
w budgetach. Otrzymany uniform complex-position defect:

```
max_j |z1_C(j)-Z*(j)| <=20102235062439/562949953421312 <0.036.
```

Nie wymaga on typical sample, fault return0 closeness lub source exact
cancellation. Recomputed CM inputs/outputs są te same przez frame, lecz
każde add/sub ma jawny osobny błąd. Energy/frequency/metric comparison
odnosi się do ukończonego normal right history; fault/nonreturn ma inny scope.

## 3. Domains

All right primitive domains i |mu|<=156276714 są skonsumowane z ORDERED,
bez zmiany jego historycznego PARTIAL statusu. Returned caps≤115M i L caps
zapewniają source products/sums wewnątrz2^100, także zera/subnormals.
Exact skeleton jest mathematical proof object, nie ponowne wykonanie C.
Niezależny RBF oracle rekonstruuje go z każdego observed terminal pair i
sprawdza cały weighted quadratic form oraz source difference. Trzy fixtures
nie zastępują powyższej all-history indukcji.
