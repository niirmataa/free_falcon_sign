# Kontrola autora — Array i naliczenia020E4

2026-10-13. Self-review / NOT_REVIEWED. Kernelowo poprawne w zapisanych
typach; pełne zadanie020E nadal incomplete. Nie uruchomiono Daybreak.

1. ArrayBank dowodzi dokładnego read/write i rozmiaru, potem wszystkie warstwy
   zachowują wcześniejsze funkcje. Wariant kosztowany naprawdę używa
   copyWrite/tabulate/read; algebraiczne ścieżki obejmują również None,
   pełny stos, adres-sentinel, fuel0 i nieudany decode. Poprzednie hipotezy
   poprawności programu/pojemności w konkretnej instancji pozostają wypełnione.
2. Przypisane ceny są semantyką MODELU, nie wynikiem pomiaru ani twierdzeniem
   o natywnym Lean. CostRun.bind sumuje koszty, a tabulate liczy każdy
   initializer. Jego ogólny callback ma lokalny bound, ale końcowy driver
   podstawia konkretne funkcje i dostarcza wszystkie te boundy. Nie zostaje
   końcowe „assume sampler cost”. Koszt obliczania samych liczników przez
   interpreter Lean nie jest utożsamiony z modelowym kosztem algorytmu.
3. CostAction za każdym krokiem tworzy nowy cache wartości bieżącego stanu.
   Atom store i binary zachowują porządek dzieci. ArrayPrefix daje≤2 dla
   wszystkich zwróconych akcji; CostExecute używa boundu tylko na osiągniętym
   wyniku optBind, więc nie zakłada≤2 dla dowolnie podanego obcego wyniku.
4. CostParse dolicza sprawdzanie dzieci i oba zapisy, nie tylko decode.
   PublicImage zawiera877 literalnych komórek. Generator nie jest częścią
   aksjomatów; serial_injective i serial_binding wiążą je kernelowo z kodem.
   Pierwszy eksport exit0 bez poprawnych danych został odrzucony. Dwa
   generatory Sage odtwarzają dokładnie zaakceptowane źródła.
5. Operational Key to bank768 par; jego read daje to samo h. Nie pobiera się
   sekretu ani historii kwantowych zapytań. Idealne draw odpowiada kolejnym
   współrzędnym pełnego zbioru monet, a każdy jest naliczony. Generator PRG,
   źródłowe KeyGen, codec i porównanie realnego Sign pozostają poza wynikiem.
6. EveryTape i law_eq są równościami dla całych wyników, nie testami ani
   warunkowaniem na sukces. CostCertificate nie dodaje przesłanek liści ani
   efektywnego samplera; dokładne M i Covered pozostają jawne. M wymaga
   źródłowego dowodu na właściwym prawie kluczy; nie jest nowym A-QMT.
7. Ujawniona luka zakresu: Run może zawierać pure/map z wartością większą od
   naliczonej pamięci. CostSpaceGap daje formalny kontrprzykład dla reguły
   ogólnej. Konkretne naliczenia samplera nie są przez to obalone, lecz
   nie dają same pełnego live-space. Brakuje świadków układu/alokacji i
   czasu życia, łącznie ze scratch, wywołaniami i stałymi. Dlatego brak
   twierdzenia peak i brak zamknięcia Q-RESC są zapisane wprost.
8. Pełna taśma w tej reprezentacji jest bardzo duża. Liczba1578402447360
   to bajty samego payloadu przy modelowym paddingu512bit/Bool; nie jest
   pomiarem Array Bool, minimalnym kodowaniem ani pamięcią procesu build.
   Bound11763954238966829723 dotyczy jawnych ticks/skumulowanych naliczeń,
   nie praktycznego czasu w sekundach i nie poziomu bezpieczeństwa.

183 eksporty sprawdzono przez #print axioms, standardowy kernel;
592 piny źródeł/artifactów ponownie zweryfikowano. Wszystkie38 końcowych
modułów i końcowy audit mają exit0/warnings0/errors0.110 prób zachowano;
43 czyste kompilacje obejmują także dwa audyty, diagnostyczny data-only,
udaną ekstrakcję danych oraz odrzucony semantycznie pierwszy eksport.
Nie wolno przedstawiać43 jako liczby zaakceptowanych modułów dowodowych.

Najcięższe próby dochodziły do około6GiB RSS. Przyczyną widoczną w logach
było rozwijanie zamkniętych interpreterów/dużych danych podczas elaboracji
lub kontroli kernela; w generatorze również interpreter. Nie diagnozujemy
na tej podstawie usługi modelu ani stanu całego komputera. CostPipeline
zastąpił kosztowne konkretne podstawienia ogólnym lematem, bez dodatkowych
aksjomatów. Lokalne irreducible w CostDriver steruje elaboracją, nie
wyłącza kernela; końcowy dowód przeszedł z pełnym audytem aksjomatów.

Historia źródeł, nieudane snapshoty, piny, receipty i brak niezależnego odbioru
pozostają jawne. Nie konsumowano nowych twierdzeń ROM; ich współbieżne
commity nie zmieniają bazy biblioteki tego checkpointu. Cudzy staging,
T12.1/B20, mainline/paper i strona pozostały poza zakresem zmian.
