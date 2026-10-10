# S05 — duży pakiet017: rzeczywiste lokalne liście

Baza `32d2639ae913c088c6fe7ec163caaf0385b246e8`, status IN_PROGRESS/WARUNKOWY.
Cel: dostarczać faktyczne świadki pól016, nie kolejne równoważne założenia.
Klasa każdego poniższego zadania: obowiązek dowodowy Q-SAMPLER; koszt
operacyjny i source/KeyGen/QROM pozostają osobnymi obowiązkami.

- [x] Z istniejącego shifted Gaussian/Poissona ROM wyprowadzić konkretny
      normalizator pary g1≤4300000 i wypełnić pole zero_mass.
- [x] Z rzeczywistej taśmy cube, bijekcji słów i normy wyprowadzić atomy U,
      a potem wypełnić CubeLeaf z jawnym rachunkiem stałej2^4630.
- [x] Kernelowa semantyka wyboru CDF, przedziały i zliczanie modulo; dokładne
      p_T związane z kodem i literałami; konwolucję zastępuje jawna trasa
      Gaussian sandwich + central mass (patrz GAUSSIAN_CERTIFICATE_ROUTE_017.md).
- [ ] Zaokrąglenia tablic do Gaussa: potrzebne certyfikaty eksp/sandwich,
      potem rejection i raw. Wyniku Sage nie traktować jako kernela.
- [ ] Złożyć faktycznie wypełnione pola; przy niewypełnionym polu zachować
      dokładny typ i status OPEN, bez przemianowania go na założenie crypto.
- [ ] Świeży build, piny, próby, kontrole negatywne i polski checkpoint.

Kolejność zależności: najpierw dwa niezależne liście normalizatora/cube,
równolegle w sensie planu — liczności CDF i metoda certyfikacji tablic.
Wykonuje jeden autor; nie uruchamiamy cudzych workerów/modeli.

Rozważane mechanizmy dla tabel: bezpośrednie rygorystyczne exp-rational
certyfikaty, propagacja dyadycznych przedziałów przez małe kroki Gaussianu,
oraz kontrola dokładnego floor/ceil wobec publicznych literałów. To próby
badawcze; nie zawężają zakresu celu i nie tworzą dodatkowych założeń.

Postęp017: 2ae6e140 zapisuje pierwsze47 eksportów (normalizator/cube/central mass).
77a65116 zapisuje osobno kernelową przeszkodę VirtualLegal w pinie ROM18a3ffe3.
PairLeaves017 domyka rejection/raw POD kontrolą wszystkich wierszy;
nie jest jeszcze bezwarunkową instancją, dopóki GaussianWitness017 nie przejdzie.
Pełny przebieg121 niezależnych modułów kontroli trwa w witness_build001;
ActualInterface017 jest przygotowany, lecz nie wolno oznaczać go jako kernelowy
przed zakończeniem kontroli i jego własnym czystym buildem.
