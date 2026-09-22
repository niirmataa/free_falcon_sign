/-!
# FTFamily.Bounds — próg Verify FT1536 i margines (kernel Lean 4)

Extra/c/falcon-enc.c (`falcon_is_short`, ternary) podaje komentarz
"floor(1.075^2 * 2*N * 768^2)" dla aktywnego progu logn = 10. Kernel sprawdza
dokładną arytmetykę całkowitą:

* (43/40)^2 * 2*1536*768^2 = 2093922385 + 1472/1600, więc podłoga wynosi
  dokładnie FALCON_FT1536_NORM_BOUND2 = 2093922385,
* wartość bez marginesu 2*1536*768^2 = 1811939328 (to liczba użyta jako B
  w wycofanej tabeli wersji poprzedniej),
* 1.075^2 = 1849/1600.

Wybór sigma = 768 i marginesu 1.075 pozostaje otwarty w źródle (SIG-001);
kernel sprawdza tylko rachunek.

Log kompilacji jest czysty; nie użyto sorry/admit/native_decide.
-/

namespace FTFamily

/-- 2*N*sigma^2 dla N = 1536, sigma = 768: wartość bez marginesu. -/
example : 2 * 1536 * 768 * 768 = 1811939328 := by decide

/-- (1.075)^2 = 1849/1600. -/
example : 43 * 43 = 1849 := by decide
example : 40 * 40 = 1600 := by decide

/-- floor((43/40)^2 * 2N * sigma^2) = 2093922385 (aktywny próg FT1536). -/
example : (43 * 43 * (2 * 1536 * 768 * 768)) / (40 * 40) = 2093922385 := by
  decide

/-- Reszta z dzielenia (margines ułamkowy) jest niezerowa: wartość nie jest
dokładnie wielokrotnością 1600. -/
example : (43 * 43 * (2 * 1536 * 768 * 768)) % (40 * 40) = 1472 := by decide

/-- Porządek wielkości marginesu: wartość z marginesem przekracza wartość bez
marginesu. -/
example : 2 * 1536 * 768 * 768 < 2093922385 := by decide

end FTFamily
