# S05 / EXECUTION018 — aktywny duży pakiet

Status: IN_PROGRESS / WARUNKOWY / NOT_REVIEWED. Autor: bieżąca sesja S05.
Baza rozpoczęcia:09491ff4ba7f93681a28f4352bdec466ed7ce216; dowód samplera:
e8006fec5c2b01a0ee23085e577ccba8bbf8bbeb (65 pinów sprawdzonych w Git).
Ten plan wykonuje TODO_COST_AND_SOURCE_018; jego historycznych bajtów nie zmienia.

Cel Q-RESC/Q-SAMPLER: wykonywalny sampler z jednoznacznym modelem kosztu,
dokładną zgodnością prawa z017 i rachunkiem obejmującym wszystkie gałęzie.
Wybrany model ma jawne odczyty taśmy, dostęp do publicznych tablic/pamięci,
operacje na słowach o ograniczonej szerokości i zapis wyjścia. To osobny
model operacyjny; koszt kompilacji dowodu i liczba logicznych miejsc prób
nie zastępują kosztu samplera. Zgodność z konkretnym C/kompilatorem/PRG
wymaga dalszego mostu źródłowego i nie powstaje przez nazwanie modelu RAM.

Trasy optymalizacji samplera (ich litery są niezależne od wariantu A naprawy F04):

- A — WYBRANA: binarny pierwszy próg CDF, jawne przechowanie par/wektorów,
  krótkie pętle z capami i pełne złożenie kosztu. Dyskryminator: dla każdej
  reszty u<S dokładna zgodność pierwszego progu i najwyżej15 odczytów CDF.
  Następnie zgodność całego wyniku dla każdej taśmy, nie tylko test rozkładu.
- B — ZACHOWANA ALTERNATYWA: instrumentacja dosłownej referencji016.
  Wymaga jawnego rachunku powtórnych ewaluacji funkcyjnych współczynników;
  nie wolno przypisać jej kosztu pętli z zapamiętanym wektorem. Wrócić, jeśli
  dokładne powiązanie trasyA z referencją okaże się niedostępne.
- C — ODROCZONA: bezpośredni koszt zoptymalizowanego C. Bez formalnej
  semantyki kompilatora/implementacji nie jest zamiennikiem dowodu modelu.
  Dyskryminatory po trasieA: jawne257-bitowe progi,268-bitowy CDF,
  te same odczyty losowe i deterministyczna zgodność emisji.

Zadania zależne trasyA:

- [x] Kernel: skończone wyszukiwanie binarne, inwariant rozcięcia, granica
      porównań, rzeczywisty CDF i zgodność z wyborem liniowym.
- [x] Kernel: nowe funkcje prób/capów i zapisanych wektorów mają ten sam
      wynik na tej samej taśmie co016, z zerem i świeżym cube po wyczerpaniu.
- [ ] Jawny model wykonania: arytmetyka Q, syndrom, tablice i pamięć;
      kompozycja kosztu rzeczywistych wywołań w tym modelu.
- [x] Pełny certyfikat J/P przez równoważność z017, to samo(M), publiczny
      initial, pełne modelowane porażki; bez zmiany nierówności po cichu.
- [ ] Sage/Lean: dokładne rachunki budżetu i kontrole krytycznych gałęzi;
      wszystkie próby zachowane, czysty build, receipty, piny i checkpoint.

ROM: BATCH061 (e1f409ba/09491ff4) ograniczył VirtualLegal do finite-live
i dodał tail_cells_of_loop/loop_tail_entry. Globalne Dimensions pozostaje
otwarte w invocation_certificate; certFrame, srcLive, kodeki/emisja oraz
źródłowe pokrycie(M) nie zostały przez te eksporty domknięte. Nadzór jest
odczytowy, bez przejmowania tamtego wykonawcy i bez uruchamiania jego jobów.

Wszystkie nowe źródła i runtime w S05; jeden autor tego pakietu, małe
lokalne commity na main, bez push. Limit pojedynczego eksperymentu Lean:
1 rdzeń,4GiB pamięci Lean/8GiB przestrzeni adresowej,110s CPU/120s czasu.
Nie startujemy innych modeli ani recenzentów. Brak twierdzenia QROM;
klasy: rachunek to obowiązek, semantyka wykonania to model, PRG/MT pozostają
oddzielnymi założeniami kryptograficznymi i właściwymi mostami.

Checkpoint rdzenia: EXECUTION_018_CORE_CHECKPOINT.md.39 eksportów/6 modułów.
Dalsza praca nad śladem i szerokościami nie jest jeszcze pełnym kosztem.
F04: decyzja wariant A i granica S05 zapisane w ROM_VARIANT_A_018.md.

Checkpoint uzupełniający: EXECUTION_018_CHECKPOINT.md.73 eksporty/10 modułów,
Sage10.9 exact003, czysty audyt typów i aksjomatów, native TeX success.
Zadanie rachunku zdarzeń i wybranych szerokości jest wykonane. Zadanie
pełnego kosztu operacyjnego/pamięci pozostaje OPEN; cały018 IN_PROGRESS.
Nie zmniejszamy celu do ledgeru. Kontynuacje maszyny/taśmy/tablic i source
bindingu są jawnie wskazane w mapie murów checkpointu.

019 / nowy checkpoint granicy modelu: MODEL_BRIDGE_019_CHECKPOINT.md.
Podetap84 eksportów oddziela parę publiczną od reply-only variant A,
wydziela ten sam rzeczywisty kod do StandaloneRuntime019 i zachowuje jego
certyfikat pod(M). Rozstrzygnięto dokładny typ celu dalszego Q-RESC;
pełny koszt maszyny018 nadal OPEN. Następny kontrakt wykonania zapisany
w TODO_PAIR_MACHINE_020.md; nie stosować26113-bitowego reply-only boundu
do pełnej pary. Warunkowy nowy mianownik wymaga jawnego kappa i nowego e'.
