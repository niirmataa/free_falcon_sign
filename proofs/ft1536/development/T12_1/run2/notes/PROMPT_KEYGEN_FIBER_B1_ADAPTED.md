# KEYGEN_SOURCE_TO_FIBER_001 — prompt dostosowany do wspólnego toru (rung B1)

Kontynuuj T12.1 w tej samej sesji:
ses_f12636605ffeL1FZg4teLUwUf5
Wykonawca: GPT-6 Astra / openai/gpt-6-astra.

PAKIET: KEYGEN_SOURCE_TO_FIBER_001

W=/media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/development/T12_1/source3

## 0. WSPÓLNY CEL I POŁOŻENIE PAKIETU (dodane 2026-09-30)

Właściciel zatwierdził wspólny cel end-to-end i drabinkę implikacji
w `proofs/ft1536/development/T12_1/END_TO_END_SCOPE.md` (commit 0887d033).
Dokument jest wiążący dla wszystkich torów; ten pakiet jest jego
**szczeblem B1 — wiązaniem prawa klucza z realnym wykonaniem**.

- Teza docelowa (kształt stały): `AdvEUF <= min{1, eps_coll^cond +
  Phi((1+e^cond)^q_s - 1, AdvMT)} + Adv_PRG(ChaCha20)` — dla prawa klucza
  **warunkowego** (D1: `Law(real C KeyGen | success)`) i **realnego** PRNG
  (D2, trasa (b) — zapisana na stanowisku po identyfikacji: ChaCha20
  z `Extra/c/frng.c`, siew SHAKE-256 ← /dev/urandom + siew użytkownika).
- Konsumenci tego pakietu: **B4** (`LocalJointCertificate S e`, tor
  matematyczny run2) i **B5** (montaż `ConcreteReduction`). Wszystkie
  punkty 1–6 poniżej są dostarczalnymi B1 wobec B4/B5; punkt 3 zawiera
  dodatkowy interfejs (jawna semantyka pętli prób), bo rachunek
  prawdopodobieństwa (`P(sukces)`, czynnik `1/P(sukces)` przy warunkowaniu)
  jest po stronie toru matematycznego i musi mieć nazwany punkt zaczepienia.
- **Poza zakresem tego pakietu i nie Twoim problemem:** rozkład próbkowania,
  `P(sukces)`, bezpieczeństwo PRNG, stała `e`, analiza χ² — to S1/S2/B4 toru
  matematycznego. Twój model taśmy losowej jest konsumowany jako dany;
  składnik `Adv_PRG(ChaCha20)` doda montaż B5.
- **Przecinanie z audytem SOL 6.1 (T03):** ewentualne rozbieżności między
  tym pakietem a rozwiązaniem §6.1 są rozliczane w `END_TO_END_SCOPE.md`
  decyzją właściciela — nie zmieniaj samodzielnie kształtu tezy końcowej.

To większe zlecenie integracyjne. Jego końcem ma być konkretny most
od udanego wykonania przypiętego KeyGen do faktów o tych samych kluczach
i istniejącego matematycznego modelu NTRU/włókna.

Helpery, parsery, frame lemmas i callee contracts są krokami wewnętrznymi.
Nie kończ całego zlecenia po domknięciu jednego z nich.

## BAZA

Konsumuj CERTIFICATE_SUFFIX_001:
notes/run/CERTIFICATE_SUFFIX_001_REPORT.md
SHA256=7b36b9c4a01056b577e6b60c329646ba5fdee31266b836a42f6d592cc21ed898

notes/run/CERTIFICATE_SUFFIX_001_CLOSURE.json
SHA256=657b907273f0bda6e9ecfc5bbeae24bf169cd1bc8e6965f8662b6501f97cfd56

Dziedzicz STABLE_TOP_001, STABLE_BINARY_004 i ich przypięte closure.
Zachowaj PROVED_KERNEL_SCOPED / NOT_REVIEWED. Nie powtarzaj zakończonych
dowodów; rozbuduj brakujące połączenia.

Źródło M0 falcon-keygen.c:
SHA256=0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf.

Pozostałe źródła i profil pobierz z przypiętego PROFILE i manifestów,
bez podmiany na zastane Extra/c.

## 1. NAJPIERW ZAPISZ RZECZYWISTY TYP KOŃCOWY

Docelowy schemat:

każde skończone, zdefiniowane wykonanie przypiętego falcon_keygen_make,
w profilu M0 i legalnym środowisku pamięciowym,
które zwraca 1 i emituje sk/pk
⇒ istnieją dokładnie związane z tym wykonaniem f,g,F,G,h oraz fInv,
dla których:
- dekodowanie wyemitowanych sk/pk daje właśnie ten materiał;
- wykonano i zaakceptowano cały mandatory leaf certificate tych samych
  f,g,F,G;
- zachodzą dokładne równania NTRU, public-key i odwracalności f;
- dostępny jest źródłowy certyfikat 1536 zapisanych liści;
- można bez dodatkowych przesłanek tych równań zainstancjować istniejący
  ActualNTRUFiber dla tego samego h.

Użyj istniejących Geometry.Vec, Relation.Rq, reduceVec/mulRq i operacji
CoefficientQuotient. Dopasuj rzeczywiste nazwy, nie twórz równoległego
modelu pierścienia.

Success/Emitted ma pochodzić z semantyki źródłowego wykonania i jego
obserwowanych bajtów. Nie definiuj go przez NTRU, acceptance bramki,
FiniteFlat, zakres liści ani oczekiwaną deltę.

Przed pracą zapisz dokładny typ i zależności w żywym planie T12.1/source3.
Nie wymaga to nowego zatwierdzenia każdego kolejnego lematu.

## 2. DOMKNIJ CAŁĄ FUNKCJĘ ft_keygen_leaf_certificate

Zakres obejmuje pełną funkcję około 7689–7778, wraz z:
- parametrami, MKN, profile guard i wcześniejszym return 0;
- tworzeniem i inicjalizacją lokalnego bad;
- layoutem tmp, wszystkimi aliasami, rozmiarami i inicjalizacją;
- smallints→fpr, FFT3, działaniami wielomianowymi i raw LDL prefixem;
- pełnym Gate00;
- ukończonym suffixem top→reverse→scan→return;
- wyjściem z funkcji i zakończeniem lifetime lokalnych obiektów.

Udowodnij, że rzeczywisty prefix dostarcza WellFormed/Legal konsumowane
przez suffix. Gotowy snapshot g00/t3 nie może pozostać dodatkową przesłanką
końcowego twierdzenia o całej funkcji.

Rozlicz rzeczywiście potrzebną closure źródłową. Można korzystać
z modularnych kontraktów callee, ale wymagane kontrakty muszą być
kernelowo wyprowadzone i związane z przypiętym kodem.

Gate00 ma być powiązane z niezależną semantyką i bajtową pamięcią,
nie tylko z dotychczasowym modelem pojedynczej komórki.

Zachowaj dokładne źródłowe słowa i kolejność. To jeszcze nie wymaga
utożsamienia FFT/LDL FPEMU z idealną arytmetyką rzeczywistą.

Zamknij obecny return-edge gap:
bad jest lokalnym obiektem funkcji. Przenieś jego fakty przez poprawny
return/teardown. Nie odczytuj go po zakończeniu lifetime. Potrzebne
snapshoty zachowaj jako wyprowadzone świadectwa wykonania, związane
z tym samym wywołaniem.

Wyprowadź ramę: wejściowe f,g,F,G pozostają zachowane, a zapisy ograniczają
się do faktycznie dozwolonej pamięci roboczej i lokalnej.

## 3. ZWIĄŻ SUKCES KEYGEN Z TYM SAMYM WYWOŁANIEM I BAJTAMI

Obejmij falcon_keygen_make, około 7781–8187, w aktywnym profilu M0:
- parametry logn 10/ter 1/STATIC i actual attempt cap;
- rzeczywiste continue/break/return;
- finalny attempt, który przeszedł mandatory certificate;
- zachowanie tego samego f,g,F,G,h do serializerów;
- oba kodowania i rzeczywiste długości sk/pk;
- wyjście z funkcji i życie lokalnych tablic.

Udowodnij z return 1, że finalny attempt naprawdę wykonał certificate
z wynikiem 1. Wcześniej odrzucony attempt nie może dostarczyć świadectwa
dla później wyemitowanego klucza.

Domknij source-bound round-trip/zgodność kodowania z dekodowaniem
tych samych współczynników, w tym obecności G i publicznego h.
Niewykazane SameSTATICDecode nie może zostać przesłanką zamiast wyniku.

Istniejący KeygenMandatory jest pomocniczym lematem lokalnym.
Jego parametryczny Calls/Frame nie jest końcowym źródłowym mostem KeyGen.

**Dodatkowe dostarczalne B1 (interfejs dla toru matematycznego):**
wyeksponuj semantykę pętli prób jako jawne, nazwane predykaty —
per-attempt acceptance (warunek continue/break wyprowadzony z realnych
source gates), actual attempt cap oraz warunek sukcesu pętli — dla
wszystkich skończonych zdefiniowanych wykonań, bez dowodzenia rozkładu
ani P(sukces). Tor matematyczny policzy P(sukces) i czynnik 1/P(sukces)
z tego interfejsu. „Pusty lub zawężony do oczekiwanej tezy predykat
success" pozostaje niedopuszczalny.

Nie musisz udowadniać, że każda taśma losowa kończy się sukcesem,
ani dowodzić rozkładu lub kryptograficznego bezpieczeństwa PRNG.
Zakres obejmuje wszystkie skończone zdefiniowane successful executions.
Definicja i adequacy wykonania musi jednak rzeczywiście obejmować kod;
pusty lub zawężony do oczekiwanej tezy predykat success jest niedopuszczalny.

## 4. WYPROWADŹ RÓWNANIA DLA WYEMITOWANEGO MATERIAŁU

Dla tych samych f,g,F,G,h wyprowadź z właściwych fragmentów KeyGen:

- zakresy współczynników wymagane do integer lift;
- dokładne fG−gF=q modulo Phi nad liczbami całkowitymi;
- h*f=g modulo q/Phi;
- istnienie fInv z fInv*f=1 modulo q/Phi.

Wykorzystaj rzeczywiste końcowe kontrole solvera i public-key computation.
Nie zakładaj poprawności solve_NTRU lub falcon_compute_public przez nazwę.

Przy modularnym integer lift:
- użyj właściwego PRIMES3[0]=2147355649;
- wyprowadź potrzebny bound współczynników z faktycznych source gates;
- zwiąż modular check/NTT/Montgomery z dokładnym wielomianem;
- udowodnij przejście od modularnej kontroli do równania całkowitego.

Istniejące algebraiczne NTRUBasis/CoefficientQuotient/ActualNTRUFiber
są zależnościami do ponownego użycia. Historyczny mixed analytical proof
nie jest brakującym kernelowym kontraktem C.

Nie dodawaj nowej bramki, warunkowania lub selekcji kluczy.

## 5. ZŁÓŻ KONKRETNY MOST DO WŁÓKNA

Skonsumuj istniejące:

FT1536.Run2.ActualNTRUFiber.coordinates
FT1536.Run2.ActualNTRUFiber.coordinates_formula
FT1536.Run2.ActualNTRUFiber.gaussian_fiber_in_basis

Wymagane tam ntru/public_eq/inverse_eq mają wynikać z punktów 2–4,
dla dokładnie tego h, które dekoduje się z wyemitowanego pk.

Końcowy eksport ma dostarczyć dla każdego targetu c:
- równoważność między parametrami bazy a całym włóknem Relation.A h;
- istniejącą jawną formułę bazy/afinicznego przesunięcia;
- możliwość konsumpcji reindeksowania masy Gaussa;
- równocześnie certyfikat źródłowej bramki dla tych samych f,g,F,G.

Nie zostawiaj ntru/public_eq/inverse_eq jako nieudowodnionych dodatkowych
założeń theorem zaczynającego się od successful KeyGen.

## 6. ZAWARTOŚĆ ŹRÓDŁOWEGO CERTYFIKATU

Certyfikat musi być zbudowany ze śladu wykonania i obejmować:
- identyczność materiału klucza w producerze, bramce i kodowaniach;
- rzeczywisty związek g00 i liści z obliczeniami prefixu;
- accepted Gate00;
- wszystkie wykonane kontrole i brak fallbacku przy certificate return 1;
- 1536 słów w literalnym inclusive zakresie MIN…MAX;
- 1024≤decoded stored value<332054;
- dokładny reverse 1535-u z actual source div;
- poprawne snapshoty przed teardown i ramę pamięci po powrocie.

Stored-word bounds pozostają stored-word bounds.
Nie awansuj ich do exact LDL leaves, błędu <33, FiniteFlat lub M6.
To będą następne mosty, ale niniejszy pakiet ma już dostarczyć
konkretny, źródłowo związany materiał wejściowy do nich.

## 7. KRYTERIUM ZAKOŃCZENIA CAŁEGO PAKIETU

Odbieralny koniec to wspólny theorem:

EMITTED PINNED KEYGEN
  → SAME DECODED KEY MATERIAL
  → ACCEPTED FULL SOURCE CERTIFICATE
  → EXACT NTRU/PUBLIC/INVERSE FACTS
  → EXISTING ACTUAL FIBER CONSTRUCTION.

Domknięcie samego Gate00, prefixu, jednej funkcji FFT lub serializerów
jest postępem wewnętrznym, nie ukończeniem tego zlecenia.

Końcowy typ nie może zakładać:
- działania dowolnego abstract callee zamiast wymaganej implementacji;
- poprawności solvera/serializerów;
- gotowego suffix-entry Legal;
- brakującego source completeness;
- samego końcowego certyfikatu lub równań, które miał wyprowadzić.

Jawne legalne warunki wejściowej pamięci, profil M0 i source execution
pozostają dopuszczalne. Nie należy ich wzmacniać własnościami wyniku.

Ślad konsumpcji: w KEYGEN_SOURCE_TO_FIBER_001_REPORT.md zaznacz wyraźnie,
które tezy są dowodami B1 i jaki jest ich dokładny typ dla konsumentów
B4 (`LocalJointCertificate S e`) i B5 (`ConcreteReduction`), tak aby montaż
nie potrzebował dodatkowych przesłanek.

## 8. AUTONOMIA, COMMITY I SPRAWDZENIA

Prowadź wszystkie powyższe części jako jeden pakiet badawczy.
Wewnętrzne etapy zapisuj małymi logicznymi commitami na main.
Nie potrzebujesz zgody po każdym lemacie ani po przejściu do kolejnej
części zakresu.

Zgoda „trzy commity i push" została wykorzystana przez CERTIFICATE_SUFFIX_001.
Dla tego nowego pakietu wykonuj commity lokalne; push czeka na osobny jawny
sygnał właściciela. Zachowaj cudze zmiany i jeden writer Git naraz.

Pozostajesz w aktualnym source3. Bez dalszej migracji/scalania,
porządkowania SOURCE_MAP, przenoszenia katalogów lub zmian run2/t5.
run2 to tor matematyczny właściciela. Konsumpcja jego eksportów wymaga
pinów i dokładnych typów; nie przejmuj certLo/certHi ani jego planu splotu.

Lean4/Mathlib, Sage z preparserem, dokładne ZZ/QQ lub rigorous intervals.
Pojedyncze joby z kontrolą tła i dotychczasowymi limitami.
Nie zwiększaj limitów w celu przepchnięcia monolitycznych redukcji.
Zachowuj failed attempts, źródła, raw logs i receipty.

Sprawdzenia obejmują:
- typy, termy i transitive axioms końcowego mostu;
- świeży replay nowej/zmienionej closure i finalnej kompozycji;
- piny całego wymaganego source/callee/import graph;
- mutacje pominięcia gate, zamiany materiału między attemptami,
  zmiany materiału przed kodowaniem, błędnego lifetime, złego modułu
  lub boundu integer lift oraz niewłaściwego kodowania G/h.

Kontrole wyłącznie na publicznych syntetycznych wejściach/helperach.
Bez odczytu sekretów, generowania rzeczywistych kluczy i uruchamiania
produkcyjnego prywatnego KeyGen. Skończone testy nie zastępują proofu.

Jeżeli wystąpi rzeczywista blokada, zapisz dokładny brakujący typ,
zależności i wynik próby. Kontynuuj inne części pakietu, które można
poprawnie wykonać. Nie zamieniaj blokady w założenie lub scoped PASS
całego mostu.

## 9. ARTEFAKTY

Aktualizuj żywe WORK_STATE, rejestr luk i rozwinięcie ROADMAP T12.1/source3.
Zachowaj wcześniejsze raporty i piny.

Końcowe pliki:
notes/run/KEYGEN_SOURCE_TO_FIBER_001_REPORT.md
notes/run/KEYGEN_SOURCE_TO_FIBER_001_CLOSURE.json
notes/run/KEYGEN_SOURCE_TO_FIBER_001_REVIEW_TASK.md

Raport ma zaczynać się od pełnego końcowego typu i listy jego rzeczywistych
przesłanek. Następnie: co domknięto, co pozostało, source/model granica,
wykonane sprawdzenia i lokalne commity.

Dowód pozostaje w jawnej autorskiej semantyce użytego fragmentu C99/GCC-LP64.
Nie oznacza weryfikacji całej normy ISO, kompilatora ani bezpieczeństwa Sign.
Niezależny odbiór organizuje koordynator; nie uruchamiaj recenzenta,
subagentów, nowych sesji ani nie nadawaj samodzielnie REVIEWED.
