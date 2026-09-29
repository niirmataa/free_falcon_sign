# SOURCE_ERROR — uniform bound luki |pre_rint − v_ref| (składnik B)

FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001. Wszystkie liczby **exact outward
rationals** w checks/gap_composition.json (ten plik: wartości zaokrąglone dla
czytelności; dokładne ułamki w JSON). Transport punktowo-root → współczynniki:
**stała konwencja pinowana** `|coeff_r| ≤ sqrt(4/3)·bound_root` (H6P
ERROR_LEDGER §3, A2; crosscheck: moja formuła odtwarza pinned
graph_basis_coefficient_error = 1078.6942 do 4 cyfr — C1_formula_crosscheck).

## 1. Dekompozycja (per coefficient, oba wektory 1536)

pre_rint − v_ref = A + B + C + D + E (frames w EXACT_SKELETON §5):

| Składnik | Pochodzenie | Bound |
|---|---|---|
| A1 challenge FFT words vs eval(c) | TARGETS fft_challenge_component_error=1/8192 | 0.000141 |
| A2 εdet × |Ĉ/q| (rounded-basis det error) | ROOT eps_fg=2^-26, eps_FG=2^-15, caps | **332.455** |
| A3 target rounding layer × basis words | TARGETS rounding_only 1/8192, 2^-24 | 0.433 |
| A4 word errors × target operands | ROOT × TARGETS caps | 166.227 |
| **A (refined)** | suma | **499.115** |
| B_wordres Z(Y)·(B'_words − B_exact) | ROOT eps × (t0cap+Xcap, t1cap+Ycap) | **4489.916** |
| C1 tree/L-reconstruction defect | PINNED H6P graph_basis (δ=0.0357, eroot) | **1078.694** |
| C2 terminal sub/half/last-sub × coeff box | H6P Er+Eh+Elast, P_key 2047, n=1536 | 3.000 |
| C3 defect × word errors | cross | 0.0000013 |
| D suffix CM/add rounding | PINNED H6P post_CM_add | 15.667 |
| E source iFFT | PINNED 1/128 | 0.0078 |
| **TOTAL** | | **6086.401** |

Wymagane dla recovery: **< 1/2** (strict) — gap NIE jest domknięty (brakuje
~4 rzędów wielkości). εdet = 0.18745 (4 składniki pierwszego rzędu Δ×wartość
+ quady); ηt = Er+Eh+Elast = 9.5368e-7.

Dominanty: (1) B_wordres 4489.9 — immutable stored basis words (błąd source FFT
2^-26/2^-15) pomnożone przez operandy |a(ζ)| ≤ t0cap+Xcap = 2.021e10 i
|b(ζ)| ≤ t1cap+Ycap = 1.175e8; (2) C1 1078.7 — defekt rekonstrukcji drzewa
δ=0.0357 przez rząd perpendicularny (sqrt(Pperp) = 26069) w skorelowanym
trójkątnym układzie; (3) A2 332.5 — ten sam błąd słów przez εdet × |Ĉ/q|.

## 2. Trasy odrzucone/luźniejsze (zachowane z liczbami)

| Trasa | Liczba | Przyczyna |
|---|---|---|
| A_coarse (pinned ideal_reference_error 1/4) | 887.03 | gorsza od refined (499) — użyta tylko jako envelope |
| C1_alt niezależne boxy (sqrt(amax), sqrt(Pperp)) | 1165.41 | gorsze od skorelowanej trasy pinned (1078.69) |
| C_failed_convolution (współczynnikowy box δ przez ||G||_1) | 160471.46 | katastrofalny; rama eval+trójkąt lepsza |
| H6P failed route (niezależny box |Lroot|≤2^25, cyt.) | 3.681e9 | pinned w H6P/artifacts/failed_routes_numeric.json |
| Sample maxima fixtures (~6e-13) jako bound | — | zakazane; to nie uniform bound |

Uwaga modelowa: obserwowane w fixture błędy source (~6e-13) są ~11 rzędów
mniejsze niż boxy — pinned stałe ROOT/LEFT są worst-case'ami i nie są ciasne.
To **nie jest** kontrprzykład równości: brakuje uniform proof, nie ma witnessa.

## 3. Minimalny missing type (progi = udział 1/10 budżetu 1/2)

Do domknięcia B wystarczyłyby (z dokładnymi progami z JSON):

1. **Residualy stored basis words** (source FFT words vs dokładne eval):
   ε_fg ≲ **3.32e-13** (względem cap 1536: ~2.16e-16 ≈ 2^-52.1) oraz
   ε_FG ≲ **6.80e-10** (względem cap 3144192: ~2.16e-16 ≈ 2^-52.1) — tj. uniformna
   dokładność ~2^-52 zamiast pinowanych 2^-26/2^-15 (względnie 2^-35). To
   rozwiązuje też A2 (εdet ≲ 5.6e-5). Alternatywnie: per-key exact potraktowanie
   immutable słów sk (dyadiki policzalne dla każdego klucza) złożone z
   Z(Y) w warunek per-instance (wymaga jednak uniform w Y).
2. **Defekt rekonstrukcji źródłowej**: δ ≲ **3.3e-6** oraz eroot ≲ **3.7e-5**
   (razem ≲ 4e-5; pinned δ+eroot = 0.0361, czynnik ~900), przy zachowaniu
   skorelowanej trasy trójkątnej (sqrt(Pperp)).
3. **Terminal rounding transport**: ηt ≲ **3.18e-8** zamiast 9.54e-7 (czynnik 30)
   — UWAGA: nawet true worst-case sub_C na skali mu≈9.4e8 (~2.1e-7) przekracza
   ten próg w boxie splotowym (1536·2048·ηt), więc sam ciasny Er nie wystarczy;
   potrzebny transport korelacyjny 3072 defektów terminalnych (sum-type) albo
   per-instance folding. Izolowany box C2 = 3.0 już przekracza 1/2.

Zadanie domknięcia B jest więc jednym dobrze określonym obowiązkiem:
**certyfikat uniformnych, source-instantiated residualów stored FFT words na
poziomie ~2^-52 (rel.) + defektu (δ, eroot) ≲ 4e-5 + transportu ηt ≲ 3.2e-8**,
przy istniejącej ramie trójkątnej/energy. Bez tego C pozostaje warunkowe.
