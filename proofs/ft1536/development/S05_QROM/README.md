# S05_QROM — publiczny sampler i redukcja kwantowa

Status: **WARUNKOWY / DEVELOPMENT**, bez twierdzenia bezpieczeństwa FT1536
w QROM i bez niezależnego odbioru. Tor rozwija wpis S05 w ROADMAP.

Właściciel uruchomił ten tor 2026-10-10: małe lokalne commity na main,
**bez push**, bez zmian statusów T12.1/B20, mainline, paperu i strony.
Późniejsze polecenie właściciela z tego samego dnia: **cała nowa praca jest tutaj**.
Źródła i dokumenty zapisujemy w `notes/` lub `formal/`; próby, logi, cache
i duże wyniki w ignorowanym `.build/`, z odrębnymi katalogami uruchomień.
Dotychczasowe `work/FT1536_S05_QROM_001/` jest zachowaną historią wejściową.
Nie nadpisujemy prób. [Własny handoff](notes/SAMPLER_004_HANDOFF.json),
[lokalne zasady](AGENTS.md).

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
| Certyfikat `ΣJ²/P≤1+e`, z użytecznym e | SAMPLER-004 naprawia h=0: tekstowy dowód pełnego momentu e<2^-50. Cel dla wszystkich h nadal OPEN; ograniczenie e>1/8 dotyczy starego kandydata 003 |
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
- bieżący runtime i historia nowych prób: `.build/sampler_004/`;
- historyczne wejścia: `work/FT1536_S05_QROM_001/` (bez dalszych dopisków).

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

Wynik h=0 wyklucza konstrukcję 003 z małym e na całym Rq,
nie inne samplery. Poniższy krok 004 zachowuje ten niewygodny wynik
i buduje osobną poprawioną gałąź.

## Najnowszy checkpoint — SAMPLER-004

[Pełny dowód tekstowy i następny interfejs](notes/SAMPLER_004.tex),
[wykonywalny sampler h=0](notes/HZERO_SAMPLER.sage),
[certyfikat rachunku](notes/SAMPLER_004_CERTIFICATE.json),
[koszt, receipty i zachowane próby](notes/SAMPLER_004_RECEIPT.json).

Dla **h=0 i każdego wyzwania** nowy sampler odtwarza prawo włókna
z kontrolowaną dominacją punktową. Obejmuje sukces, cap16, porażkę
modelowej emisji oraz rozliczony fallback pary. Łącznie z dyadycznym
wyzwaniem daje `J≪P` i `ΣJ²/P≤1+e`, `e<2^-50` (około 4.6840e-17).
To dowód tekstowy z rygorystycznym rachunkiem Sage, bez nowego kernela.

Koszt ograniczono do 2359296 propozycji par i 2419187712 bitów na odpowiedź,
czytanych leniwie; prekomputacja kategorii ma jawny limit 49152 przedziałów
wag. Sprawdzono cztery przypadki warunkowe oraz faktyczny fallback przy cap192.

**Cel S05-Q-JOINT-INSTANCE dla wszystkich h pozostaje OPEN.** Dla naturalnego
rozszerzenia wyprowadzono dokładny moment przed normą:
`E[Z_res] * E[1/Z_res]`. Dla h=0 jest równy 1; dla pozostałych h brak
użytecznego oszacowania. [34 dokładne testy tożsamości](notes/SAMPLER_004_RESIDUAL_CHECKS.json)
są małymi modelami kontrolnymi, nie dowodem dla parametrów FT1536.
Nie osłabiono końcowego kwantyfikatora ani nierówności momentu.

README jest żywym stanem. Historyczne manifesty, które pinowały README,
weryfikujemy względem ich commitów (003: `0a6999d7`). Nowe manifesty
pinują wyłącznie pliki wynikowe checkpointu.
