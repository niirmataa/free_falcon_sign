/-!
# FTFamily.Roots — tabele pierwiastków NTT i wartość Phi (kernel Lean 4)

Sprawdzenia całkowite (Nat, kernel przez `decide`) dla q = 18433 i
Phi_N(X) = X^N - X^(N/2) + 1:

* poprawne pierwiastki pierwotne rzędu 3N (3532, 625, 25): Phi_N(w) = 0 mod q,
  w^(3N) = 1 oraz w^(3N/p) != 1 dla p ∈ {2,3} (przesłanka rzędu 3N w grupie
  cyklicznej (Z/q)^*),
* pierwiastki z poprzedniej wersji (8, 27, 13): Phi_N(w) = 3 mod q (NIE są
  pierwiastkami), w^N = 1 oraz w^(N/p) != 1 dla p ∈ {2,3} (rząd N).

Fakt, że w^m = 1 i w^(m/p) != 1 dla wszystkich pierwszych p | m implikuje
rząd równy m w grupie cyklicznej, jest standardowym algebrą z tekstu; kernel
sprawdza dokładnie te warunki liczbowe.

Log kompilacji jest czysty; nie użyto sorry/admit/native_decide.
-/

-- Pełna ewaluacja kernela dla potęg Nat rzędu 4 cyfr (progi redukcji, nie
-- wyciszanie ostrzeżeń; wynik weryfikuje kernel).
set_option maxRecDepth 1000000
set_option exponentiation.threshold 100000

namespace FTFamily

-- N = 768, 3N = 2304, poprawny pierwiastek 3532
example : (3532 ^ 768 - 3532 ^ 384 + 1) % 18433 = 0 := by decide
example : 3532 ^ 2304 % 18433 = 1 := by decide
example : 3532 ^ 1152 % 18433 ≠ 1 := by decide
example : 3532 ^ 768 % 18433 ≠ 1 := by decide

-- N = 1536, 3N = 4608, poprawny pierwiastek 625
example : (625 ^ 1536 - 625 ^ 768 + 1) % 18433 = 0 := by decide
example : 625 ^ 4608 % 18433 = 1 := by decide
example : 625 ^ 2304 % 18433 ≠ 1 := by decide
example : 625 ^ 1536 % 18433 ≠ 1 := by decide

-- N = 3072, 3N = 9216, poprawny pierwiastek 25
example : (25 ^ 3072 - 25 ^ 1536 + 1) % 18433 = 0 := by decide
example : 25 ^ 9216 % 18433 = 1 := by decide
example : 25 ^ 4608 % 18433 ≠ 1 := by decide
example : 25 ^ 3072 % 18433 ≠ 1 := by decide

-- Odrzucone wartości z poprzedniej wersji: Phi_N(w) = 3 mod q, rząd N.
example : (8 ^ 768 - 8 ^ 384 + 1) % 18433 = 3 := by decide
example : 8 ^ 768 % 18433 = 1 := by decide
example : 8 ^ 384 % 18433 ≠ 1 := by decide
example : 8 ^ 256 % 18433 ≠ 1 := by decide

example : (27 ^ 1536 - 27 ^ 768 + 1) % 18433 = 3 := by decide
example : 27 ^ 1536 % 18433 = 1 := by decide
example : 27 ^ 768 % 18433 ≠ 1 := by decide
example : 27 ^ 512 % 18433 ≠ 1 := by decide

example : (13 ^ 3072 - 13 ^ 1536 + 1) % 18433 = 3 := by decide
example : 13 ^ 3072 % 18433 = 1 := by decide
example : 13 ^ 1536 % 18433 ≠ 1 := by decide
example : 13 ^ 1024 % 18433 ≠ 1 := by decide

end FTFamily
