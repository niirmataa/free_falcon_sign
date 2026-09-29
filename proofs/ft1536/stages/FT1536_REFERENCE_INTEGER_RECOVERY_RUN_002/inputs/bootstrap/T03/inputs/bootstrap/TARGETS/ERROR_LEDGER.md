# Dwie warstwy błędów i norm transport

Wszystkie stałe są uniform po P_key/emitted normalized basis i każdym
canonical c. Exact QQ values/stages/physical roots są w numeric certificate
i ERROR_LEDGER.json. U=2^-48,eta=2^-900,EC=2^-13,Ef=2^-26,EF=2^-15.

## 1. Boundy operandów i exact reciprocal

Ideal C modulus Mc=N*18432=28311552, Mf=1536, MF=3144192.
Component errors FFT są EC,Ef,EF; complex-norm errors bezpiecznie2EC,2Ef,2EF.
Stąd actual word-value norm caps A=Mc+2EC, B=Mf+2Ef albo MF+2EF.
Primitive caps przed multiplication: A<2^26, Bf<2^11,BF<2^22.
Scalar products/add-sub intermediates<2^49, końcowe scaled operands<2^36,
więc każda required source operation jest w proved2^100 domain.

ρ=val(ni)=500372811634285/2^63, δ=|ρ−1/q|=403/(18433*2^63).
Computed Word i of18433 są kernel-checked constant executions i native
crosschecks. q jest positive normal w nawet starszym ROOT div domain.
Nie użyto host reciprocal; negacja −ni to source sign XOR.

## 2. Rounding-only względem tych samych actual values

Dla actual complex values Ĉ,Bv, source CM ma norm error
Ec=6U*|Ĉ|*|Bv|+8eta. Wynika to z4 mul/2 add-sub i Cauchy na sums of absolute
products; source operand domains ustalono przed instrukcjami. Nie łączymy
niezależnych idealnych boxes. |Ĉ Bv|=|Ĉ|*|Bv| dla tej SAMEJ pary values.

Po per-component source scale przez±ρ norm error do±Ĉ Bv/q jest co najwyżej

```
ρ*(1+U)*Ec + (δ+Uρ)*|Ĉ|*|Bv| + 2eta.
```

Pierwszy składnik to CM error i jego propagation przez scale, drugi to
reciprocal i scalar rounding na exact product, ostatni to absolute floors.
Nie policzono dwa razy FFT/input errors: ta warstwa zaczyna od actual words.
Globalnie stosujemy A*B; otrzymujemy norm/component bounds:

|target|rounding-only error|
|---|---|
|t0|**<1/8192**|
|t1|**<1/16777216**|

Pointwise można zapisać relative-plus-absolute bound
`error ≤ θ*|R|+tail`, θ=qδ+qρ(7U+6U²)<2^-44, tail<3eta.
Przy R=0 pozostaje absolute bound; nie dzielimy przez nieznane nonzero R.

## 3. Pełna warstwa ideal coefficient/root

Zachowujemy te same C_ref/B_ref przy każdej frequency. Dokładna identity
`Ĉ Bhat − C_ref B_ref = ΔC*B_ref + C_ref*ΔB + ΔC*ΔB` daje transport

```
(2EC*Mb + Mc*2Eb + 4EC*Eb)/q.
```

Dodajemy go JEDEN raz do warstwy rounding-only. Nie zakładamy niezależności
c/p, unitarności rounded FFT albo determinant q zaokrąglonej basis.

|target|ideal modulus bound|pełny norm/component error|source norm/component bound|
|---|---|---|---|
|t0|89016955305984/18433|**<1/4**|**<4829216911**|
|t1|43486543872/18433|**<1/8192**|**<2359169**|

Bounds dotyczą actual finite normal/signed-zero outputs; reference cancellation
i zero są objęte absolute errors. Nie eksportujemy fałszywej uniform relative
accuracy względem dowolnie małego T_ref.

## 4. Coefficient-space: wyprowadzone weights, nie source cast bound

W product degree≤3070 redukcja X^1536=X^768−1 daje:
`X^(1536+u)=−X^u+X^(768+u)` dla u<768,
`X^(2304+v)=−X^v` dla v<767. Recursive monomial checker policzył wszystkie
2359296 pairs. Absolute row counts to2303−k dla k<768 i2304 dla k≥768.
Kernel reduced_count lemmas i symbolic coefficients potwierdzają maximum2304.

Zatem ideal rational coefficients mają uniform linf bounds:
t0: **86930620416/18433**, t1: **42467328/18433**.
Dla odpowiedniego B: l2²≤1536B², Phi quadratic form≤2304B².
To nie redukcja modulo q ani źródłowe zaokrąglone coefficient outputs.

Dla exact root evaluation na1536 roots Phi geometric-series orthogonality
zeruje każdy coefficient difference oprócz0,±768. Sumy wynoszą1536 lub768.
Dlatego `sum_full |eval(a)|² =1536*(sum a_i²+sum a_i a_(i+768))`.
Gram ma pair-block eigenvalues768,2304. Dla real coefficient vectors oraz
conjugate extension768 physical complex values:

```
||inverse_eval(e)||₂² ≤ (4/N)*sum_physical |e_j|².
```

Uniform component error E daje l2 drift≤2E. Stąd mathematical inverse
evaluation SOURCE target values ma coefficient linf≤B+2E: t0 B+1/2,
t1 B+1/4096. ERROR_LEDGER zawiera także rational squared-norm transports.
Nie wykonano source iFFT3 i nie przypisano tym boundom jego rounding error.

## 5. Granica do Reach

Source frequency t0 bound przekracza2^31; jest to rzeczywisty eksport
otrzymanej majoranty, nie dopasowanie do NumericCenter. Nie wynika z niego
scalar-center counterexample. Initial frequency values, inverse-evaluation
reference coefficients i późniejsze scalar mu to różne obiekty. ORDERED_REACH
musi osobno śledzić source splits/updates/coins/fault/rejection i errors.
