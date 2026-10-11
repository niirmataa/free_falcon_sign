# S05 / następny duży TODO020 — maszyna publicznego generatora pary

Kontynuacja otwartego Q-RESC z018, po bramce modelu019. Nie jest nowym
celem poza ROADMAP/S05 ani ogłoszeniem bezpieczeństwa QROM.
Baza kodu: StandaloneRuntime019.publicCode, certyfikat:
StandaloneCertificate019.actual_certificate, commity35d8ebaf/67da1757.
Są to piny kodu publicznej pary; nowy Run2.Sampler ma inną rolę.

Cel odbioru: rzeczywisty program w jawnej maszynie słów/pamięci, jego
zgodność wyniku z kodem019 na KAŻDEJ taśmie oraz wyprowadzony koszt
instrukcji, pamięci, tablic i wyjścia. Ledger zdarzeń018 nie wystarcza.
Runtime/środowisko wybieramy jawnie; dowód maszyny nie jest automatycznie
source bindingiem C ani pomiarem czasu sprzętowego.

1. **Domena i świadek wejścia.** Opisać układ pamięci publicznego h,
   publicznych tablic, prywatnej taśmy i buforów. Udowodnić, że encoder
   tworzy dozwolony stan i że dozwoloność jest zachowana przez wykonanie.
   Stosować skończone zbiory adresów i osiągalne stany; nie wracać do
   globalnych Dimensions/LegalWorkspace ani Nat→bounded-injective.
2. **Taśma i tablice.** Pierwsza wykonalna trasa: niezmienna pełna taśma,
   jawnie24662538240 bitów /3082817280 bajtów przy materializacji; jej
   odczyt i przygotowanie muszą być rozliczone. Streaming pozostaje
   alternatywą wymagającą osobnego prawa i dowodu świeżego fallbacku.
   Nie usuwać nieodczytanych segmentów po cichu. Tablice mają30721+61441
   pozycji: osobno generacja/ładowanie i koszt per call. Funkcja literalna
   Lean nie jest sama dowodem stałokosztowego RAM lookup.
3. **Instrukcje i reprezentacje.** Ustalić ceny/semantykę pełnych operacji,
   w tym adresowania, pętli, odczytu bitów, modulo i kopiowania buforów.
   CDF potrzebuje268 bitów, progi257 (środkowy2^256); słowa384/256/10,
   adresy taśmy35, norma pełnego boxu<2^45, iloczyn reszt pola<2^29.
   To dostępne bounds wartości, nie gotowy dowód każdego kroku maszyny.
4. **Program.** Wyrazić binary CDF, cap80, zapis par/wektorów, normę,
   cap196, świeży cube i scatter syndromu. Materiał h ma być ten sam;
   nie rekonstruować historii kwantowych zapytań. Zweryfikować aliasy,
   ramki pamięci, dostęp do buforów i wszystkie ścieżki zatrzymania.
5. **Zgodność.** Kernelowy erasure/refinement do
   StandaloneRuntime019.publicCode dla każdego poprawnie zakodowanego h
   i każdej taśmy, z pełnym wynikiem (c,Option BoxVec). Tak przenosimy
   certyfikat(M), e=2^-47 i wcześniej udowodnione prawa capów; nie tworzymy
   nowego przybliżenia. Przy zmianie algorytmu potrzeba nowego mostu prawa.
6. **Pełny koszt.** Wyprowadzić liczbę operacji bitowych/słowowych,
   odczytów/zapisów, koszt przygotowania i szczyt pamięci. Uwzględnić
   reprezentację bufora/modyfikacji: bez darmowego copy-on-write/GC.
   Wyjście jest CAŁĄ PARĄ: nie brać26113-bitowego boundu reply-only z
   wariantu A. Logiczny format starej pary ma bound50689 bitów; trzeba
   związać konkretny encoder, zamiast przypisać liczbę do dowolnego formatu.
7. **Odbiór zakresu.** Czyste dowody Lean, rzeczywiste świadka/program,
   Sage ze standardowym preparserem do dokładnej numeryki, receipty/SHA
   i zachowane porażki. Koszty kompilacji podawać osobno od kosztów kodu.
   Jeden writer Git, małe commity na main, bez push; wyłącznie S05.

Klasy: maszyna i źródło uczciwych bitów to MODEL; jej program/refinement,
koszty i source binding to OBOWIĄZKI. Q-PRG primitive-bound i A-QMT są
odrębnymi ZAŁOŻENIAMI KRYPTOGRAFICZNYMI. Zastąpienie idealnego P prawem
źródłowym R wymaga jawnego obowiązku P≤kappa R na nośniku J i wtedy
zmienia e na kappa(1+e)-1, albo innego poprawnego mostu. Nie przyjmować
kappa=1 bez dowodu. Łączenie z nową grą/QROM, operatorowe przesłanki
kompozycji, reprogramowanie i pełne KeyGen/Sign/PRG pozostają osobne.
