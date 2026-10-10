# S05_QROM — publiczny sampler i redukcja kwantowa

Status: **WARUNKOWY / DEVELOPMENT**, bez twierdzenia bezpieczeństwa FT1536
w QROM i bez niezależnego odbioru. Tor rozwija wpis S05 w ROADMAP.

Właściciel uruchomił ten tor 2026-10-10: małe lokalne commity na main,
**bez push**, bez zmian statusów T12.1/B20, mainline, paperu i strony.
Wyniki i źródła są tutaj; próby, szkice, błędy i duże generowane pliki
pozostają w `proofs/ft1536/work/FT1536_S05_QROM_001/`. Nie nadpisujemy prób.

## Baza

- RECON-001: [źródło](notes/RECON_001.tex), baza `2d2cdf52304cee9cf513487d4296392262df22f4`.
- CONTINUATION-002: [źródło](notes/CONTINUATION_002.tex), tekstowy warunkowy
  lemat kompozycji z `D = (1+e)^q_s − 1`; kwantowe użycie wymaga jawnych
  przesłanek. Podstawienie `st := initial` wykorzystuje uniwersalny
  kwantyfikator `LocalJointCertificate`, nie odczytuje zapytań kwantowych.
- [Piny źródeł i oryginalnych pakietów](notes/BASELINE_PINS.json).

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Algebra pojedynczej ekstrakcji, rachunek pełnego Sign, kierunkowy moment J/P | Zachowane w dokładnym dotychczasowym zakresie |
| Wspólna kontynuacja i kompozycja w grach programowanych | Dowód tekstowy warunkowy, CONTINUATION-002 |
| Wykonalny publiczny sampler pełnej odpowiedzi, również porażek | SAMPLER-003 wykonany; TV do modelowego publicJoint <2^-90, dowód transferu tekstowy |
| Absolutna ciągłość J względem uczciwego P | Tekstowy argument nośnika, także dla terminalnego none; formal source binding OPEN |
| Certyfikat `ΣJ²/P≤1+e`, z użytecznym e | OPEN; ten kandydat dla h=0 ma e>1/8, więc małe e jednolite po całym Rq jest wykluczone |
| Dokładny UniformChallengeAt z ustalonej taśmy uczciwych bitów | Niemożliwy: masy dyadyczne, moduł 18433 nie dzieli 2^bits; nie zmieniono przesłanek głównej linii |
| Klasyczny log hasza | Wymaga nowej semantyki QROM |
| Osadzenie `q_H+1` celów | Wymaga nowej konstrukcji Q-TARGET i straty |
| Klasyczna strata kolizyjna | Wymaga osobnego rachunku reprogramowania |
| Rzeczywiste prawo Sign i wszystkie wyjścia API | Otwarty bridge źródłowy |
| Kwantowy PRG/seed, publiczny SHAKE/H2P (S04), zasoby reduktora | Osobne otwarte przesłanki |

Trzy przebudowy mechanizmów ROM nie są pełną listą wymagań QROM.
Mały błąd TV również nie zastępuje certyfikatu kierunkowego momentu.

## Struktura

- `notes/`: dokumenty wynikowe, piny, receipty i źródła rachunku Sage;
- `formal/`: nowe moduły Lean z jawnym zakresem weryfikacji;
- runtime i historia prób: `work/FT1536_S05_QROM_001/sampler_003/`.

Pierwszy commit jest zapisem źródeł rozpoznania, nie akceptacją dowodu.

## Checkpoint SAMPLER-003

[Wynik i pełne argumenty](notes/SAMPLER_003.tex),
[wykonywalne źródło Sage](notes/PUBLIC_SAMPLER.sage),
[certyfikat rachunku](notes/SAMPLER_003_CERTIFICATE.json),
[koszt, próby i receipty](notes/SAMPLER_003_RECEIPT.json),
[duże tablice przez generator/pin](notes/LARGE_ARTIFACTS.json).

Trzy syntetyczne wykonania sprawdziły kongruencję, normę i signed16;
obie gałęzie cap-failure sprawdzono również przy faktycznych limitach.
Limit to 150994944 prób par i 18 GiB zużytych bitów, czytanych leniwie,
bez takiej alokacji pamięci. Obserwowane wykonania po przygotowaniu tablic
zużyły 2625–2710 prób par; nie jest to benchmark produkcyjny.

Sage 10.9: rachunek ZZ/QQ i balls512 zakończony. Lean: 120 s timeout
pierwszego modułu i 60 s timeout samego importu. Drafty Lean zachowano
w kuźni; **niczego nowego nie oznaczono jako kernelowo sprawdzone**.

Następny krok pozostaje **S05-Q-JOINT-INSTANCE**: potrzebny sampler
z użytecznym momentem na dokładnie wymaganej dziedzinie kluczy.
Wynik h=0 wyklucza tę konkretną konstrukcję z małym e na całym Rq,
nie inne samplery. Ewentualne ograniczenie do emitted keys wymaga jawnej
decyzji i nowego dowodu zakresu; tutaj nie osłabiono kwantyfikatora.
