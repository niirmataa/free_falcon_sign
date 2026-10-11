# S05 / F04 — jawne przyjęcie wariantu A

Decyzja właściciela w tej rozmowie: „z wariantem A w f04”. Odczytany zapis
ROM: b92f79a9c7aaced6e545ce10d265830fe93b83d0, B4_SYNTHESIS.md. Ten commit
zapisuje decyzję i zakres naprawy; nie dostarcza jeszcze nowych świadków.
Poprzedni zapis audytu: 44cece7ffa52277d77d421c3c7daf731e096e243.

Model naprawy: rzeczywisty Sign otrzymuje challenge c=H(r||m) z ROM poza
prywatną taśmą losowych bitów samplera podpisu. Nie wymagamy od skończonej
uczciwej taśmy dokładnie jednostajnego elementu przestrzeni o nieparzystej
liczności. Naprawa obejmuje typy, prawa gry, wszystkie 12 konsumentów F04,
koszty i właściwy hop PRG. To praca właściciela toru ROM, nie przejęta tutaj.

S05/017 jest publicznym symulatorem pełnej pary: najpierw losuje z, potem
oblicza c=syndrome(h,z) i emituje (c,some z2). Nie deklaruje dokładnie
jednostajnego marginalnego c z taśmy. Dowód daje J≪P i ΣJ²/P≤1+2^-47
pod dokładnym (M), gdzie P jest pełnym uczciwym prawem z jednostajnym
challenge i wszystkimi modelowanymi porażkami. Wariant A nie upoważnia
ani do zmiany tego algorytmu na sampler z zadanym c, ani do uznania jego
prawa za równe prawu rzeczywistego Sign. Powiązanie P z naprawioną grą,
źródłowym Sign/PRG oraz QROM/reprogramowaniem nadal pozostaje obowiązkiem.
Nie dodajemy UniformChallengeAt i nie zastępujemy brakujących dowodów A2.

Odczytany audyt wejściowy jest REPORT_ONLY / CONFIRMED_VACUITY /
OPEN_SUSPECTS przy zamrożonym ef354c48, bez uznania aktualnych poprawek za
wadliwe na podstawie starego pinu. F03 zabrania konsumpcji globalnego
LegalWorkspace wraz z actualCertBind; F04 wskazuje 12 niemożliwych
konsumentów UniformChallengeAt. F05 jest osobno podejrzaną kombinacją
TowerWhole z globalnym dodatnim floor: nie obala każdego lematu floor,
ale wymaga ograniczenia do właściwego nośnika. Nie ogłaszamy całego
obecnego ROM ani S05 wolnym od usterek na podstawie tej listy.

Własna kontrola zależności 018 (metadane kompilatora, nie nowy dowód ani
niezależny odbiór): z pełnych typów i ciał trzech eksportów 017
initial_certificate, key_law_under_cover, actual_pair_leaves osiągalnych
jest 150762 stałych; nie ma żadnego z 14 wskazanych konsumentów F03/F04,
nie ma brakujących definicji. To wąskie sprawdzenie nie jest audytem F05
ani dowodem kompletności listy usterek.

Klasy: wariant A — MODEL; zgodność praw, implementacji i kosztów —
OBOWIĄZKI; primitive-bound PRG i A-QMT — oddzielne ZAŁOŻENIA
KRYPTOGRAFICZNE. Status S05 pozostaje WARUNKOWY / NOT_REVIEWED.
