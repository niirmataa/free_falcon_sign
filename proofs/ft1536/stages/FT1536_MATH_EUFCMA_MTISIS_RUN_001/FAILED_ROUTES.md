# Zachowana historia prób

Każdy run w history/ zachowuje własny snapshot formal/sage, raw stdout/stderr
i dostępne receipty. Nie dopisuję brakujących exit codes ani rzekomych
udanych replayów do prób przerwanych.

## Wykonanie/toolchain

- basic_001: błędna początkowa ścieżka dodatkowych pakietów Mathlib;
  Aesop znaleziono RO w P01/run/.lake/packages. Nie pobierano zależności.
- basic_002: frontend shell przerwał po120s; brak końcowego receipt. Potem
  sprawdzono procesy: nie został worker tego W. Zachowano pusty stdout.
- basic_003/imports_001: Lean -M2048 zakończył memory_exception nawet przy
  samym imporcie Exp/Sqrt/taktyk. Przed następnym krokiem zapisano -M6144.
- divergence_001, public_001, public_002: `failed to create thread` przy
  AS8GiB. public_002 maxRSS2455428KiB; przed następnym krokiem podniesiono
  limit **przestrzeni adresowej** do12GiB. Fizyczny budżet8GiB, -j1 i wall1800
  zachowane. Zmiany zapisano na bieżąco w W/WORK_STATE.md.
- sage_001: rachunek przeszedł do serializacji; deprecated version() oraz
  Sage Integer w JSON. Zmieniono na sage.version.version i int w metadanych.
  sage_002 ma czyste wyjście i dokładne produkty. Nie zmieniono trybu .sage.
- audit_001: nieistniejące `pp.width`; zastąpiono właściwym `format.width`.
  Formalne moduły miały exit0, ale tej próby audytu nie uznano za PASS.

## Iteracje formalizacji

- basic_004: brak importu lematu sum_div; dołączono BigOperators.Field.
- sign_001–003: suma geometryczna/option, zastrzeżona nazwa prefix,
  niewykorzystane implicit instances i dowód sumy sparse spike.
- divergence_002/event_001–002: dystrybucja sum, normalizacja dzielenia
  i radicandu sqrt w dowodzie pierwiastka; bez założenia celu jako axiomu.
- adaptive_001: niezgodność universes rekursywnego typu Hist. Jawnie
  ustalono Type0 (wystarcza dla konkretnej skończonej klasy).
- public_003–006: różne rozwinięcia ogromnego Fintype Pi przy mem_univ;
  naprawione jawnie nieobliczalną instancją Fintype.ofFinite. Próba zwiększenia
  maxRecDepth nie pomogła i nie jest w finalnym kodzie.
- collision_001: normalizacja dzielenia. relation_001–002: jawna specjalizacja
  ZMod.intCast_mod dla q, oznaczenie specyfikacji wielomianu noncomputable.
- trace_001: kolejność składników przy monotoniczności. model_001: jawne
  przekazanie dowodów bounds w encode/decode. Ostrzeżenia unused/deprecation
  usunięto z nowych źródeł, nie wyciszono linterów.

Pozostałe runs są udanymi krokami pośrednimi, zachowane wraz z pierwszymi
czystymi przebiegami. Błędy elaboracji nie są matematycznymi kontrprzykładami.

## Wynik negatywny matematyczny

Centrowanie A2 naprawdę może zwiększyć Q ponad B. To odrębny, dodatnio
sprawdzony eksport, nie failed proof. Nie usunięto dodatnich podpisów z
law przez dodatkowy test Verify. Nie uzyskano też pełnego warunkowego
twierdzenia EUF-CMA: brak game interpreter/conditional identification/
typed-cost odnotowano jawnie, zamiast zakładać końcowy advantage bound.
