# CONGRUENCE — integrality i v1 + h·v2 = c mod (q, Phi)

FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001. v_ref = [c,0] − Z(Y)·B z
EXACT_SKELETON.md; B = [[g,−f],[G,−F]], det B = fG − gF = q w Z[X]/Phi;
h = g·f^{-1} mod (q, Phi) z tego samego klucza (publiczny hm/c canonical).

## 1. Integrality — PROVED

Z(Y) = (a, b) jest signed permutationem całkowitych returns (EXACT_SKELETON §3),
więc a, b ∈ Z[X]/Phi. Wtedy

```
v_ref1 = c − a·g − b·G ∈ Z[X]/Phi,   v_ref2 = a·f + b·F ∈ Z[X]/Phi
```

zamkniętości Z[X]/Phi na +,·. Nie jest to argument z source output ani z
monomial samplingu; obejmuje wszystkie 1536 współczynników obu wektorów
uniformnie (konstrukcja placementu). Kontrola exact: checks/exact_ring_checks.json
A_integrality_0..2 (losowe |Y_i| do 2^30, 2 rodziny kluczy).

## 2. Tożsamość pierścieniowa (named lemma)

W dowolnym pierścieniu przemiennym (redukcja do Z[X]/Phi):

```
v_ref1 + h·v_ref2 − c = a·(h·f − g) + b·(h·F − G)          (★)
```

(rozwinięcie: c − ag − bG + haf + hbF − c; regroup). Kontrola dokładna na
Z[X]/Phi (pełny rozmiar 1536, całkowita arytmetyka, nie FFT port):
checks/exact_ring_checks.json C4_ring_identity_0..2 = PASS.

## 3. Relacje klucza i kongruencja — PROVED (przy relacjach klucza)

Z det B = q i odwracalności f w F_q[X]/Phi wynikają (dokładnie sprawdzone,
C1/C5 w checks/exact_ring_checks.json):

```
h·f ≡ g (mod q, Phi)      (definicja h = g·f^{-1})
h·F ≡ G (mod q, Phi)      (bo f·(G − hF) = fG − gF = q ≡ 0 i f odwracalne)
```

Podstawiając w (★): **v_ref1 + h·v_ref2 ≡ c (mod q, Phi)** dla całego required
H (dowolne Y). Kontrola C3_congruence_0..2 = PASS (2 rodziny syntetycznych
kluczy z dokładnym det = q, w tym f = 1+Xj niebędące jedynką nad Z — h·f − g = q·k
z k ≠ 0, więc tożsamość nie degeneruje). Uniwersalność w (a,b,c) jest cechą
twierdzenia (kongruencja zależy od struktury Z·B, nie od wartości Y); czułość
na błędy relacji (h, det, target signs) wykazują mutacje M_*.

## 4. Zakres

Kongruencja dotyczy **całkowitej pary v_ref**. Actual stored pair (w1, w2) jest
równy v_ref dopiero po recovery (ROUNDING_RECOVERY.md), którego przesłanka
|pre_rint − v_ref| < 1/2 nie jest w tym pakiecie wykazana uniformnie
(SOURCE_ERROR.md, B=OPEN). Nie ma tu Sign→Verify, Safe16 ani twierdzenia o
stored norm; patrz VERIFY_NEXT_INTERFACE.md.
