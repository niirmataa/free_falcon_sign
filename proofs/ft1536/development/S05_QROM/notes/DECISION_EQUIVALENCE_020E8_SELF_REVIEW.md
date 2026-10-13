# E8 — kontrola autora

PARTIAL_KERNEL_NOT_REVIEWED. To kontrola autora, nie niezależny odbiór.

Sprawdzono dokładne typy wyników, ich przesłanki i połączenia:

1. Nonact.source ma tylko jawne wyłączenie act. Obejmuje dowolny typowany
   Data i świeży bit, wszystkie 16 indeksów, pusty stos, wyczerpany licznik
   i przepełnienie push. Nie wymaga invariantów udanego wykonania.
2. ScanDecision.correct jest uniwersalny na całym Data. Rozbicie dotyczy
   rzeczywistych 16 tagów Cell i wyniku dekodera; brak operatora oraz brak
   każdego argumentu mają zachowane gałęzie. Selected wiąże wszystkie siedem
   operatorów bez ograniczania argumentów Word512 lub zmiany kolejności
   second/first. Ujemny payload podlega tej samej normalizacji toInt.toNat.
3. Cache_words obejmuje tag i payload wartości, również none. Nie oznacza
   automatycznie poprawności taga/adresu opcjonalnego polecenia zapisu.
4. OutputSlots.produced używa istniejącego stored_output. Control i padding
   odnoszą się do banku zwróconego przez uruchomiony kod, nie do podstawionej
   referencji. Sloty są sprawdzone przez dokładne pozycje w Fin96.
5. Passive.reference_equality dowodzi oryginalnej tezy E7 jedynie dla
   check/done/bad. Script zawiera skonstruowany świadek reference d i dowód
   jego obrazu oraz efektu; nie ma nowej przesłanki brakującej zgodności.
6. Funkcje transportu i referencje są obiektami dowodu. Ich przesłanki są
   wypełnione wcześniejszymi twierdzeniami. Nie występują jako nowe instrukcje,
   callbacki, alokacje lub bezkosztowe wejścia wykonawcy.
7. Nie zmieniono celu all-state, (M), J/P, źródłowego prawa kluczy, publicznego
   initial, eksperymentu QROM ani klas założeń kryptograficznych. Pełna zgodność,
   inne rodziny producenta oraz pełny czas/peak pozostają OPEN.

Czyste kompilacje i audyt 98 eksportów sprawdzono wraz z SHA wszystkich
zainstalowanych źródeł/artefaktów. Wyniki używają wyłącznie standardowych
propext, Classical.choice, Quot.sound. Nie stosowano sorry, nowych aksjomatów,
native_decide/bv_decide ani wyciszania ostrzeżeń. Brak nowego oszacowania
numerycznego lub skończonego testu podnoszonego do rangi dowodu.

Niepowodzenia zachowano z receiptami. Próby push skorygowano przez małe
równości flag, a problem pamięci przy cache — przez ogólny transport przed
konkretną instancjacją. Ograniczenie pamięci pozostało4096 MiB. Próby projekcji
clear z proof-generated programu nie zostały zamknięte i nie są w bibliotece.
Nie stwierdzono kontrprzykładu do schematu lub obwodu na podstawie tych błędów.

Jedna przedwczesna komenda install po błędzie scanrows001 została zatrzymana
przez asercję czystego receiptu przed zmianą PINS. Zainstalowano wyłącznie
późniejszą czystą próbę002. Ta odmowa instalacji jest zapisana w runtime.
