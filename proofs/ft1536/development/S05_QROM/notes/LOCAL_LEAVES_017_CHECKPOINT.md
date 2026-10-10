# S05 — LOCAL_LEAVES017: checkpoint warunkowy

Status: **PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED**. Domknięto lokalne
obowiązki analityczne rzeczywistej referencji samplera; nie ogłoszono QROM.

Wszystkie cztery pola 016 mają teraz rzeczywiste świadki kernelowe:
`PairLeaves.rejection`, `raw`, `zero_mass` i `CubeLeaf`. Dokładne prawo
CDF/modulo i surowej próby pary jest wyprowadzone z kodu. Pełny certyfikat
sprawdza 61 441 wierszy, w tym 30 721 wag CDF i 61 441 progów; rekurencja Gaussa
obejmuje 30 721 stanów. Żaden wiersz nie został pominięty po limitach pamięci.

`ActualInterface017.initial_certificate` daje **J≪P oraz ΣJ²/P≤1+2^-47**
dla publicznego initial pod dokładnym (M). Certyfikat obejmuje każdy stan;
`key_law_under_cover` zachowuje to samo pokryte prawo kluczy. Cztery lokalne
pola nie są już przesłankami tego eksportu. M nadal jest jawną przesłanką.
AC dla każdego h, również bez (M), pochodzi z 016. P zawiera pełne modelowane
porażki, choć J(none)=0. Nie rekonstruuje się historii zapytań kwantowych.

Sprawdzono **147 audytowanych eksportów** w dokładnych
typach, w tym 5 kontroli liczbowych i 5 lematów dwóch przeszkód źródłowych.
Dochodzi pełny generowany świadek wierszy i 5 jego eksportów składających.
Świeży build strukturalny/finalny reużywa przypięte, osobno skompilowane
świadki skończone. To kontrola autora, nie niezależny odbiór.

Zachowane granice: pełny emitted KeyGen→M/source harmonic, Sign/API/PRG,
koszt wykonania i zgodność zoptymalizowanej implementacji oraz mechanizmy
QROM pozostają OPEN. Nie podano poziomów bezpieczeństwa. h=0 i Dyadic
nie awansują automatycznie do kernela, a cel forall-h pozostaje osobny.

## Koszt i odtwarzalność

Suma zmierzonych czasów poszczególnych wybranych kompilacji skończonych:
7168.832 s; to suma czasów procesów,
nie czas całej kampanii ani koszt samplera. Świeża closure strukturalna:
53.417 s. Pełne limity, pomiary
i brakujące próbki RSS są w `LOCAL_LEAVES_017_RECEIPT.json`.

Logiczna taśma 24 662 538 240 bitów i 24 084 480 miejsc propozycji z 016 nie są
liczbą rzeczywistych operacji/czasem/pamięcią. Doprecyzowano kernelowo:
terminalny CDF potrzebuje 268 bitów, środkowy próg to 2^256 i potrzebuje 257
bitów lub równoważnej reprezentacji pełnej akceptacji.

Źródła dużych świadków odtwarzają generatory z `LARGE_ARTIFACTS_017.json`.
Kanoniczny JSON oddziela koszt generacji od treści certyfikatu; ponowna
generacja odtworzyła wszystkie 9 źródeł danych bajt w bajt. Historyczny
JSON 001 z czasem wykonania pozostaje zachowany.

## Niewygodne wyniki

Bloki 128 wierszy i później niektóre bloki 8 przekraczały pamięć reduktora.
Mniejsze moduły 16 bloków nie naprawiły problemu pojedynczego bloku.
Wybrano indywidualne twierdzenia wierszy, zachowując sprawdzony prefiks.
Limity per compiler pozostały bez zmian; zachowano wszystkie próby,
diagnostyczne #eval nie są dowodami. Sealed lista: `LOCAL_LEAVES_017_ATTEMPTS.json`.

W pinie ROM 18a3ffe3 kernelowo wykryto dwie niezależne niemożliwe przesłanki:
globalne VirtualLegal (iniekcja Nat w skończone adresy) oraz globalne
Dimensions (sprzeczne ze stanem o pustych locals). Dokładny zakres i piny
są w `ROM_INVOCATION_AUDIT_017.md` i suplemencie001. Sampler 017 nie
konsumuje tych pustych przesłanek. Naprawy należą do wykonawcy ROM.

## Co wynik zmienia i co dalej

Łańcuch od konkretnych publicznych liczb i bitów do małego pełnego momentu
nie ma już czterech lokalnych luk 016. Wąskie gardła są teraz jawne:
zasoby/wykonanie, źródłowe pokrycie M i późniejsza redukcja kwantowa.
Następny duży pakiet: `TODO_COST_AND_SOURCE_018.md`; mapa murów:
`KERNEL_QUEUE_017.json`, klasy: `CERTIFICATE_CLASSES_017.json`.

Źródłowe checkpointy 017: 2ae6e140,77a65116,6d7b15df,ef354c48,7143b71b;
końcowy commit dokumentów identyfikuje Git. Brak push i zmian statusów T12.1/B20.
