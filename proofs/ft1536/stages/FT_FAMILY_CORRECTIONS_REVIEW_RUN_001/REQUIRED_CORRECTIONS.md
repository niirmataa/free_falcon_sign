# Minimalne poprawki po niezależnym odbiorze S01

Nie nadpisywać frozen RUN_003; nowa wersja/suplement ma nowe piny i spójny PDF.

## I1 / R1 — zakres twierdzenia o przewagach (medium, wymagane)

ATTACK_PROBLEMS.md:32–49,73–102 i zależne C20/CORRECTION_MATRIX:

- PROVED: dla zadanego akceptowanego świeżego forgery transcriptu ekstraktor
  zwraca krótki witness tego samego celu. To punktowy wynik L_V.
- Game-level Adv_rel≥Adv_cond: jawnie warunkowe od zgodności eksperymentów
  i dostępnego symulatora/implementacji oracles wymaganych przez Forge.
  Zdefiniować interfejs Solve_rel albo wycofać bezwarunkowy wpis „proved”.
- Nie trzeba dowodzić całego M7. Wystarczy poprawnie ograniczyć claim.
- N3 opisać jako test postconditions/toy encoding; obecny przykład wywołuje
  Sign na m*,więc nie jest świeżym fałszerstwem. Jeśli reklamowany jest test
  kompozycji,sprawdzić rzeczywisty target index/output i legalny transcript.
- Enc jest nieudowodniony; toy rejection nie dowodzi nieistnienia realnego Enc.

## I2 / R5 — precyzja certyfikatu (medium, wymagane)

paper/main.tex:188–192,CLAIMS.md:C19,opis metody lemma_chi_tail.sage:

- Zachować poprawny wynik ogona i obie nierówności2^-40/2^-28.
- Podać rzeczywistą obudowę: dla autorskiego Arb256 promień≈1.06e-82,
  a zapisane decimal endpoints mają szerokość10^-50. Nie przypisywać temu
  runowi≈10^-305. Jeśli wymagany węższy claim,zmienić precyzję i wyeksportować
  nowe dokładne endpointy wraz z rzeczywistym receipt/hashami.
- Użyć exact_rational() dla binarnych midpoint/radius albo dołączyć dokładny
  dowód zapasu konwersji; QQ(RealNumber) nie jest tu exact binary conversion.
- RESEARCH_NOTES:55:akceptacja=1−ogon,odrzucenie=ogon.
- Przebudować PDF i sprawdzić spójność tekstu/kodu/certyfikatów.

## Pozostałe erraty/porządek pakietu (low)

- Oznaczyć stary hash lemma_controls w port/COMMANDS jako historyczny;
  finalny source/run pin ma być5a3466b9… lub pin nowej rzeczywiście wykonanej wersji.
- Usunąć .pyc z nowego source manifestu; oryginalną historię zachować.
- Nie nazywać identycznych eventów „nieidentycznie rozłożonymi”.
- Union bound podać z właściwym wspólnym conditioning/oczekiwaniem.
- Przy replayu wykluczyć stale semantic/PDF products i oceniać ich producer
  exit/logs. source_header jako jawna metadata transportowa,nie różnica liczb.
- S06 konkretne komórki istnieją; zdania NOT_RUN/„nigdzie” ograniczyć do
  tego manuskryptu/zadania. Nie dodawać nieodebranych kosztów do claims S01.
