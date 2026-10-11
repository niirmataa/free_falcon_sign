# EXECUTION018 / checkpoint rdzenia

Status: PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED. Pakiet018 pozostaje
IN_PROGRESS. To checkpoint źródeł i dowodu równości, nie zamknięcie Q-RESC.

Kernelowo: binarny pierwszy próg jest dokładnie tym samym wyborem co
liniowe CDF016 (najwyżej15 probes, plus osobny odczyt terminalnego CDF).
Nowe przechowane wektory zachowują wszystkie capy80/196, zerowy fallback
pary i świeży sześcian. Mnożenie scatter ma ten sam wynik co przypięta
referencja PolynomialReference, przy2359296 parach i≤4718592 aktualizacjach.
Wyjściowy challenge i odpowiedź są przechowywane w wektorach.

StoredInterface018.sampler_eq dowodzi równości całego samplera dla każdej
taśmy, nie tylko porównania statystycznego. Dzięki temu dziedziczy J≪P
dla każdego h oraz moment≤1+2^-47 pod dokładnym(M), dla każdego stanu,
publicznego initial i tego samego pokrytego prawa kluczy. Nie wzmocniono(M),
nie dodano UniformChallengeAt, nie usunięto modelowanych porażek z P.

Walidacja:39 drukowanych eksportów w6 modułach, czyste logi, standardowe
aksjomaty propext/Classical.choice/Quot.sound, bez sorryAx/native_decide.
Szczegóły i SHA: EXECUTION_018_CORE_CHECKS.json. Zachowane próby nieudane
w .build/execution_018/runs/: binary001/002 (składnia i pomocnicze cele),
cdf001 (projekcja Fin), cached001 (zależne przepisywanie), scatter001/002/003
(lemat sumy/nazwa/ostrzeżenia), stored001 (przebudowa zbyt dużej definicji).
Żadnego niezależnego odbioru; jest to własny build i kontrola autora.

Mapa murów: pełny koszt instrukcji i pamięci nadal OPEN; liczniki CDF,
pętli czy miejsca prób są tylko składnikami. Taśma ma24662538240 bitów:
nie wolno zakładać małej pamięci strumieniowej bez osobnego mostu.
Publiczne tablice, adresowanie, arytmetyka normy, źródła PRG i pamięć
muszą wejść do pełnego rachunku. Kompilacja dowodu nie mierzy samplera.
Pokrycie źródłowego KeyGen przez(M), Sign/PRG, Q-HASH-LOG, Q-EMBED,
Q-COLL/reprogramowanie, Q-COMPOSE i zasoby całego reduktora nadal OPEN.

F04: wariant A przyjęty jawnie w ROM_VARIANT_A_018.md. Challenge z ROM
poza prywatną taśmą rzeczywistego Sign. Naprawę gry i jej12 konsumentów
prowadzi ROM; jej nowe piny wymagają sprawdzenia przed konsumpcją S05.
