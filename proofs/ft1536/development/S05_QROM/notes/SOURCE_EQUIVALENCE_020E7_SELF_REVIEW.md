# E7 — kontrola autora, bez odbioru niezależnego

Status: PARTIAL_KERNEL_NOT_REVIEWED. Celem kontroli jest niedopuszczenie do
awansu źródłowego odczytu i referencyjnego układu do pełnej zgodności kroku.

## Sprawdzone granice

- Odczytałem treść wszystkich nowych twierdzeń i zależności użytych do
  złożenia. `field/window/executed` kwantyfikują wszystkie typowane dane,
  bez nowych założeń o cache, tokenach czy osiągalności. Lematy pomocnicze
  z przesłanką odczytu pola są instancjonowane przez dowody źródłowe.
- `register_correct` odtwarza rzeczywisty dekoder także dla ujemnych słów;
  `valid_eval` osobno odtwarza signed checked address. Nie utożsamiam tych
  dwóch reguł. Puste pola mają także poprawny zerowy payload, nie tylko tag.
- Funkcja `input` w referencji jawnie używa `d.tape.bank` i `d.rom.bank`.
  Stan rdzenia, arena i wszystkie limity pozostają te same. `reference_effect`
  używa istniejącego `CoreStore.realizes` i pełnego `CoreStep`.
- Referencyjny bufor jest obiektem dowodu. Nie został podstawiony do
  wykonania w miejsce rzeczywistego producenta ani dopisany do maszyny
  jako funkcja hosta. Wykonanie nadal używa zamkniętego kodu E6.
- `RemainingEquality` jest definicją otwartego zdania. Audyt typu tej
  definicji nie jest dowodem tego zdania. Żaden certyfikat nie przyjmuje
  go jako nowo ukrytej przesłanki. Główne zlecenie pozostaje OPEN.
- Flaga diagnostyczna producenta nie staje się abortem samplera. Nie
  zmieniono modelu porażek, (M), J/P, prawa kluczy ani publicznego initial.
- Nie nadano nowego statusu Q-SAMPLER/Q-BIND/Q-RESC w pełnym zakresie ani
  bezpieczeństwa QROM; nadal brakuje pełnego sterownika czasu życia i źródeł.

## Walidacja i próby negatywne

Końcowe15 modułów wynikowych i osobny audyt przeszły Lean bez błędów
ani ostrzeżeń. Audyt sprawdza typy i aksjomaty72 eksportów; występują tylko
standardowe propext/Classical.choice/Quot.sound. Wszystkie piny zależności,
artefakty i zgodność bieżących źródeł z kopiami kompilacji sprawdzono hashami.
To kontrola lokalna autora, nie niezależny replay lub review.

Nieudane próby pełnej zgodności i sterowania są zachowane w decision001
oraz control001–003. Nie zainstalowano ich artefaktów. Timeout taktyki i
niedomknięty cel nie dowodzą fałszu twierdzenia; nie oznaczono ich PASS.
Nie wykorzystano skończonego testu E6 jako dowodu uniwersalnego.

Pierwsza próba przygotowania runtime użyła złej podstawy ścieżek manifestu;
po zachowaniu opisu poprawiono podstawę i zweryfikowano wszystkie50/1175
pozycji E6. Nie był to mismatch hasha. Pierwszy plan commita wskazał kopie
build zamiast formal; Git odrzucił ignorowane ścieżki. Poprawiony plan
używał formal po kontroli identyczności SHA, bez force-add. Obie próby
organizacyjne pozostały w runtime. Obcy indeks zachowano.
