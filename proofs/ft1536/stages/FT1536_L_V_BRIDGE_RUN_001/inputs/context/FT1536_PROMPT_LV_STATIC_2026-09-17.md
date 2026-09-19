# FT1536 — jedno zadanie kontynuacyjne: rozstrzygnięcie L_V-STATIC

Najpierw przeczytaj:

```text
/home/footfalcon/Dokumenty/FT1536_CODEX_START_2026-09-17.md
```

Nie zakładaj znajomości wcześniejszej rozmowy. Odtwórz potrzebny stan z
przypiętych wejść. Poniższe zadanie nie upoważnia do zmian źródeł ani do
nadawania akceptacji projektowi.

## 1. Cel i wynik

Rozstrzygnij lemat `L_V-STATIC` z §6 raportu:

```text
/home/footfalcon/Dokumenty/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md
SHA-256: 5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e
```

Uzyskaj albo dowód dla dokładnie podanej dziedziny, albo odtwarzalny pełny
kontrprzykład, albo precyzyjnie nazwany niewykonany krok. Nie zakładaj wyniku.
Nie kończ na ponownym spisie ogólnych obowiązków ani na samym świadku lokalnej
konwersji `-20000`.

Profil uczciwego Sign pozostaje **FT1536 full ternary secret / COMP_STATIC**.
Lemat obejmuje jednak wszystkie payloady rzeczywiście akceptowane przez S17
Verify, w tym NONE, ponieważ źródłowy verifier je obsługuje.

## 2. Teza bez osłabiania

```text
N=1536, q=18433, Phi=X^1536-X^768+1, B=2093922385.
Q0(a)=sum_(i=0)^767(a_i^2+a_i*a_(i+768)+a_(i+768)^2).
Q(z1,z2)=Q0(z1)+Q0(z2).
```

Niech h należy do successful-output support rzeczywistego S17 KeyGen
z prawem seedu opisanym w raporcie. Niech c należy do `[0,q-1]^1536`, a b
będzie dowolnym skończonym payloadem reprezentowalnym w modelu API.

`V_S17(h,c,b)` obejmuje dokładne kontrole nagłówka, oba dekodery, pełne
zużycie długości oraz ścieżkę raw verification, przy prawidłowo przygotowanym
publicznym kluczu. HashToPoint zastępuje tu jawne c: to dokładnie dziedzina
lematu, nie twierdzenie o znalezieniu preimage hasha.

Niech `s(b)` oznacza matematyczne wartości int16 zapisane przez rzeczywisty
dekoder. Kandydat ekstraktora jest ustalony:

```text
Ext0(h,c,b) = (center_q(c - h*s(b)), s(b)),
```

z dokładnym mnożeniem modulo `(q,Phi)` poza implementacją NTT.

Teza do rozstrzygnięcia:

```text
V_S17(h,c,b)=1
  => Ext0 jest zdefiniowany,
     z1+h*z2=c modulo (q,Phi),
     Q(z1,z2)<B.
```

Nie dodawaj przesłanek, że b pochodzi od uczciwego Sign, ma tylko STATIC,
że s(b) jest centered, wejście NTT już jest canonical residue albo machine
norm z definicji równa się normie Ext0. Nie ograniczaj b do 2049 bajtów:
pojemność bufora CLI Sign nie ogranicza wejść bibliotecznego Verify.

Kongruencja wynika algebraicznie z definicji Ext0. Sednem jest implikacja
źródłowej akceptacji do dokładnej krótkości tego ekstraktora.

## 3. Wejścia, źródła i model

Używaj tylko historycznego S17 wskazanego w pliku startowym. Zweryfikuj
17/17 hashy oryginalnego manifestu przed kompilacją/kopiowaniem. Katalog
warning-clean `free_falcon_sign/Extra/c` nie jest wejściem zadania.

Bezpośrednio istotne pliki i SHA-256:

| Plik w H/build | SHA-256 |
|---|---|
| `falcon-enc.c` | `0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05` |
| `falcon-vrfy.c` | `01c496e5626a37b9d29848c596f0e0efaa328bf9b328649eea4bd1a45fa47f78` |
| `internal.h` | `512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5` |
| `falcon.h` | `657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519` |
| `Makefile` | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` |
| `falcon-keygen.c` | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |

Zapisz model LP64, szerokości słów, semantykę signed/unsigned konwersji,
kompilator i flagi. Nie traktuj signed overflow jak zdefiniowanego modulo.
Nie ukrywaj różnicy między obserwacją binarium GCC i dowodem semantyki C.

Publiczne h* z istniejącego canonical KeyGen, jego PK oraz metadane support
są dozwolone. Nie odczytuj prywatnego klucza lub współczynników. Dla
kontrprzykładu odróżnij udokumentowane h* z required support od zabawkowego
h, którego przynależności do tego support nie wykazano.

## 4. Obszar zapisu

Zacznij od nieistniejącego katalogu:

```text
/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/
```

Jeśli istnieje, zachowaj go i użyj następnego numeru; podaj wybraną ścieżkę
przed pierwszym zapisem. Wszystkie nowe źródła pomocnicze, logi, certyfikaty,
programy, cache i raporty zapisuj wewnątrz tego jednego katalogu W.

Dozwolona jest wierna, hash-sprawdzona kopia publicznych źródeł S17 do
`W/reference/` i kopia wskazanych publicznych wejść. Zachowaj referencję
bajtowo; nowy harness i model umieść oddzielnie. Nie kopiuj całego repozytorium
ani nie wykonuj generowania kluczy. Nie modyfikuj historycznych źródeł,
manifestów, statusów, starej gałęzi Git ani wcześniejszych raportów.

Nie podpisuj, nie commituj, nie pushuj, nie publikuj i nie uruchamiaj innych
agentów. Nie instaluj ani nie pobieraj narzędzi. Dla Sage/Python/kompilatora
ustaw cache i TMPDIR na podkatalogi W; nie uruchamiaj historycznego runnera
mogącego zapisać artefakty w H.

## 5. Kolejność pracy

### A. Piny i niezależny model referencyjny

1. Zapisz INPUTS, toolchain i źródłowe zakresy funkcji.
2. Zaimplementuj dokładne mnożenie w `(Z/qZ)[X]/Phi`, centrowanie i formę Q
   w Sage ZZ/GF(q) lub niezależnej dokładnej implementacji. Nie używaj
   badanego NTT jako oracle dla poprawnej matematyki.
3. Wyprowadź rzeczywisty decoder jako funkcję słów: ne, lo, znak, wrap,
   negative zero, padding, zużycie całej długości i rezerwowane nagłówki.

### B. Sprawdzenie pełnej tezy na jawnych przypadkach

Najpierw sprawdź, czy tezę da się sfalsyfikować na publicznym h* i
syntetycznych bajtach. Wybór jawnego c jest dozwolony w dziedzinie lematu;
nie nazywaj go znalezieniem wiadomości/nonce dla rzeczywistego HashToPoint.

Obejmij wartości ±9216, ±9217, ±18433, -20000, ±32767, -32768 oraz
graniczne reprezentacje magnitude 32768/65535, ne=255/256 i padding.
Uwzględnij obie obsługiwane gałęzie dekodowania. Przypadki bardzo długiego
unary code rozpatrz przez arytmetykę licznika; ograniczony test długości nie
może zastąpić dowodu pełnej dziedziny.

Do obserwacji V użyj dokładnego S17 lub wiernego wrappera nad niezmienionymi
funkcjami. **Argument h funkcji `falcon_vrfy_verify_raw` jest już przygotowany
przez NTT/Montgomery.** Nie przekazuj tam surowego wielomianu publicznego.
Odtwórz przygotowanie jak w `falcon_vrfy_set_public_key`; sprawdź wrapper
na dodatnich kontrolach, zanim uznasz wynik negatywny za świadek.

Nie kończ na rozbieżności lokalnego iota. Dla pełnego kandydata oblicz:

```text
dekodowane s(b), wejście i wyjście istotnych etapów C,
rzeczywistą decyzję V_S17, parę badaną przez machine norm,
Ext0 obliczony niezależnie oraz obie dokładne normy.
```

### C. Rozstrzygnięcie i formalny zakres

Jeżeli istnieje pełny kontrprzykład w required support, zachowaj publiczne
`(h,c,b)` oraz dowód `V=1` i `Q(Ext0)>=B`. Sprawdź go ponownie niezależnym
checkerem i powtórnym uruchomieniem niezmienionego C. Po uzyskaniu takiego
świadka nie próbuj „uratować PASS” zmianą ekstraktora, B, dekodera lub klucza.

Jeżeli nie znaleziono kontrprzykładu, kontynuuj właściwy dowód: rzeczywiste
zakresy słów, modular arithmetic, forward/inverse NTT, normę i implikację
dla wszystkich wejść. Brak kontrprzykładu w kampanii nie jest dowodem.

Użyj Lean 4.34.0/Std do sprawdzalnych fragmentów nad słowami/całkowitymi
wartościami albo do certyfikacji konkretnych nierówności świadka. Pokaż tezy,
`#print axioms`, zależności i rzeczywisty zakres formalizacji. Nie wprowadzaj
aksjomatu „Verify implies witness”, nie używaj `sorry` do zamknięcia tezy
i nie przedstawiaj formalnego lematu pomocniczego jako formalizacji całego C.
Jeżeli do dalszego kroku potrzeba niedostępnej biblioteki, wskaż ten konkretny
brak zamiast instalowania lub podmieniania historycznych zależności.

## 6. Kontrole jakości

- Dodatnie kontrole potwierdzają poprawne przygotowanie publicznego klucza,
  znaki, Phi i normę. Warunki przy B-1/B/B+1 mają odpowiadać właściwemu
  obiektowi, nie przypadkowej innej dziedzinie testu.
- Kontrole negatywne rzeczywiście zmieniają wejście lub model: pełne modulo
  zamiast jednego dodania q, pominięcie wrap, centered założone dla STATIC,
  zły offset, znak lub nierówność normy. Zapisz konkretny powód odrzucenia.
- Parser kopiowany ze źródła i drugi parser ze zmienioną nazwą nie stanowią
  dwóch niezależnych checkerów. Podaj granicę wspólnego kodu.
- Zapisz wszystkie komendy, cwd, kody wyjścia, stdout/stderr i hashe.
  Potwierdź niezmienność oryginalnych wejść na końcu.

## 7. Granice i obowiązki pozostające poza zadaniem

- Ujemny wynik obala dokładnie L_V dla wskazanego Ext0/modelu/domeny.
  Nie dowodzi nieistnienia innego ekstraktora ani efektywnego fałszerstwa
  EUF-CMA. Dla takiego fałszerstwa potrzebne byłoby również właściwe powiązanie
  c z wiadomością/nonce w grze.
- Dodatni wynik nie zamyka samplera, R5T, trudności MT-ISIS ani całej redukcji.
- Znana niejednoznaczność zmiennego nonce pozostaje odrębną granicą API/CLI.
  Nie naprawiaj opakowania ani bufora Sign podczas badania L_V.
- Zachowaj obronione zakresy T2C3 i T5. To nowe źródłowe ogniwo szerszego
  dowodu, a nie powtórna obrona fixed-key T2C3.

## 8. Wymagane wyjścia w W

- `REPORT.md` — teza, wynik, wyprowadzenie, źródła, ograniczenia i jeden
  następny krok wynikający z rezultatu;
- `RESULT.json` — identyfikator lematu, source hashes, model, wynik
  `PROVED_FOR_DECLARED_MODEL`, `COUNTEREXAMPLE_REQUIRED_DOMAIN`,
  `PARTIAL_OPEN` lub `EXECUTION_FAILED`, zakres kwantyfikacji i pozostałe
  przesłanki. Są to etykiety tego wykonania, nie akceptacja projektu;
- `INPUTS.sha256`, `TOOLCHAIN.txt`, `COMMANDS.log` i logi wykonania;
- nowe źródła harnessu, niezależnego checkera i formalnych lematów;
- w przypadku negatywnym: publiczny świadek i deterministyczny replay;
- `OUTPUTS.sha256` z jawną bazą i zakresem; wyłączenia cache/binarek opisz;
- `REPLAY.md` z dokładnymi poleceniami na nowej kopii, bez nadpisywania wyniku.

W odpowiedzi końcowej podaj pełną ścieżkę W/REPORT.md, jego SHA-256,
rozstrzygnięcie oraz krótko: co rzeczywiście udowodniono lub sfalsyfikowano.
