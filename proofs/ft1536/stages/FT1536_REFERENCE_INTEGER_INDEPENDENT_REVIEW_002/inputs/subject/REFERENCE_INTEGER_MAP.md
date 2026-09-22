# REFERENCE_INTEGER_MAP — Z(Y) i v_ref (streszczenie)

Pełny opis: EXACT_SKELETON.md. Formuła: v_ref = [c,0] − Z(Y)·B, B=[[g,−f],[G,−F]].
Z(Y) = signed permutation (+1): slot (a|b, s) pobiera Y wywołania wskazanego
formułami placementu z merge conventions (out[2i]=u0[i], out[2i+1]=u1[i];
cubic out[3i+c]=v_c[i]). Kolejność literalna: root prawy(b)→lewy(a), cubic
2→1→0, binary prawy→lewy, terminal Y1(mu1)→Y0(mu0'). Klucz slotu: side = gałąź
root (a=lewy z0, b=prawy z1); slot = 3·m + c (cubic child c), m = 2·m1 + i1
(wyjście depth1), dalej bity m wyznaczają kierunki R/L poziomów binary; przy
k=0 indeks wyjścia = slot terminala (1=Y1, 0=Y0).
Maszynowa tabela 3072 wierszy: checks/z_map_full.json (bijekcja sprawdzona).
Weryfikacja dokładna: checks/skeleton_cancellation.json (E1/E1b/E2).
