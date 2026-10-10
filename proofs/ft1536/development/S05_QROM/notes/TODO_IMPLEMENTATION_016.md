# S05 — duży pakiet016: wykonanie, capy i dominacja

Baza `efce319823364df27ca2053478a1f6959f47e924`.
Status **KERNEL W ZAKRESIE WYKONANIA / PARTIAL_PROOF / WARUNKOWY**. Klasy: obowiązki Q-SAMPLER/Q-RESC;
model uczciwych niezależnych bitów, bez nowego założenia kryptograficznego.

- [x] Przypiąć rzeczywiste VECTOR_FIRST_007, tablice003 i certyfikaty; nie
      pomylić go ze starszym PUBLIC_SAMPLER003 z abortującymi capami.
- [x] Kernel: deterministyczny wybór pierwszej zaakceptowanej próby,
      prawo capu, świeży fallback, również n=0 i akceptacja o masie0.
- [x] Kernel: dominacja pary wraz z fallbackiem0, iloczyn1536 par,
      warunkowanie z zachowaniem anulowania wspólnej normalizacji,
      cap196 i pełna świeża gałąź sześcianu, deterministyczny obraz prawa.
- [x] Wykonalne skończone taśmy i podział niezależnych bloków; exact law
      do interfejsu Sampler, bez zastąpienia losowania idealnym Gaussianem.
- [x] Rzeczywiste progi/CDF: literały i pełny odczyt wszystkich92162 wartości; dokładne obowiązki numeryczne,
      co już kernelowe, co nadal tylko Sage. Nie przyjąć małej dominacji
      końcowej pod nową nazwą ani awansować hasha do matematycznego proofu.
- [x] Wpiąć dostarczony zakres w015 i zachować próby.
- [ ] Wypełnić kernelowe PairLeaves(actual tables) i CubeLeaf: to następny pakiet017.
- [ ] Pełny koszt operacji/pamięci/prekomputacji i właściwy source binding.
      Same liczby slotów taśmy/propozycji oraz czasy buildów go nie dowodzą.

Ścieżki zależności: (a) bezpośrednia semantyka finite-bit + dokładne liczenie;
(b) ogólne cap/produkt/normalizacja + jawne lokalne certyfikaty tablic;
(c) próby falsyfikacji: współdzielony fallback, masa zerowa, cap0,
nieprawidłowe warunkowanie. To komplementarne części, nie trzy dowody celu.
Reużycie: MathSign.cap/cap_none/cap_some/cap_mixture, TargetLaw.uniform_equiv,
RawProductLaw.actual_mass_product; source3 tylko odczyt.
Jeżeli numeryczne certyfikaty tablic pozostaną otwarte, checkpoint ma
pokazać dokładne nierozwiązane twierdzenia, nie gotową instancję007.

## Wynik i granica końcowa016

- 96 eksportów kernelowych w17 modułach; dodatkowo osobna kontrola korelacji.
- 13 odtwarzalnych modułów rzeczywistych publicznych tablic.
- Konkretny Lean actualSampler ma J≪P dla KAŻDEGO h, bez(M).
- Dokładna semantyka pełnych capów i świeżego fallbacku jest wyprowadzona z kodu.
- Pod(M) i czterema nazwanymi polami lokalnymi wynika e≤2^-47.
  Nie ma jeszcze instancji tych pól; Sage wspiera numerykę, nie kernel.

Referencja Lean ma liniowy CDF i odziedziczoną funkcję współczynnikowego
mnożenia. Nie przypisujemy jej kosztu bisect/mnożenia Sage ani twierdzenia
o identyczności całego Python/C runtime. Stała liczba slotów nie mierzy
ponownego obliczania funkcji czy wszystkich operacji.

Zachowana negatywna próba: zeta^196*2^4630 <2^-70 jest fałszywe dla
wybranej obwiedni; właściwy przedział to(2^-70,2^-69), kernelowo.
Ograniczenie końcowe1+2^-60 nadal przechodzi. To nie kontrprzykład do samplera.
Nieudane elaboracje i błędy serializacji/pierwotnego opisu kontroli
korelacji pozostają w runtime i receipcie; niczego nie awansujemy po cichu.
