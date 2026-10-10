# S05_QROM — aktywne development

Decyzja właściciela 2026-10-10, późniejsza od początkowego podziału work/development:
**cała nowa praca tej kampanii powstaje bezpośrednio tutaj**.
Wyjątek dla bieżącego okna NORMALIZER-005 i jego kontynuacji MARGINAL-006:
późniejsze bezpośrednie polecenie właściciela wyznacza próby/logi/cache
w nowych podkatalogach `work/FT1536_S05_QROM_001/{normalizer_005,marginal_006}/`,
a źródła, wyniki i receipty tutaj.
Dotychczasowych prób i podkatalogów nie nadpisujemy. Ten wyjątek zastępuje
poniższy zakaz dopisków do work wyłącznie dla tych nowych podkatalogów.

Polecenie właściciela przy MARGINAL-006: dla nowej konstrukcji wymagany
jest nowy certyfikat capów, pełnych porażek, J≪P i momentu. Kolekcja
`obstructions/` gromadzi dokładne zakresy i statusy wyników jako materiał
do ewentualnego Aneksu B; nie zmieniamy paperu ani statusu publikacji.

- Źródła, szkice i dokumenty: odpowiednie pliki w `notes/` lub `formal/`.
- Uruchomienia, logi, cache, duże tablice i zachowane wersje prób: ignorowane
  `.build/`, z osobnymi katalogami prób i pinami; bez nadpisywania historii.
- Dotychczasowe `work/FT1536_S05_QROM_001/` pozostaje historycznym wejściem.
  Nie dopisuj tam kolejnych prób. Własny handoff SAMPLER-004 jest zapisany
  w `notes/SAMPLER_004_HANDOFF.json`; nie dotyczy torów T12.1.
- Małe lokalne commity na main, dokładne własne ścieżki, jeden writer Git.
  **Bez push** do jawnego sygnału właściciela. Zachowaj obcy indeks i pliki.
- Status WARUNKOWY. Brak kernela oznacza jawnie tekstowy dowód.
  TV nie zastępuje `J≪P` ani `ΣJ²/P≤1+e`. Porażki należą do prawa odpowiedzi.
- Cel nadal obejmuje całą uzgodnioną dziedzinę h. Wynik dla h=0 jest
  oznaczonym wynikiem częściowym; nie ogranicza po cichu końcowego celu.
- Doprecyzowanie właściciela 2026-10-10 przy kontrakcie tezy: celem
  końcowym jest **dowód bezpieczeństwa FT1536 z deklaracją jak dla celu ROM**.
  Dotyczy to rzeczywistego prawa kluczy schematu, z jawnymi założeniami
  kryptograficznymi i modelem. All-h certyfikat samplera pozostaje osobnym,
  silniejszym celem pomocniczym OPEN; nie zmieniamy jego historycznej tezy.
  Ograniczony certyfikat wymaga pokrycia całego nośnika właściwego prawa
  KeyGen i dowodu nowych interfejsów. Kontrakt: `notes/TARGET_CONTRACT_001.tex`.
- Nie zmieniaj statusów T12.1/B20, mainline, paperu ani strony.
- Poprzednie manifesty checkpointów weryfikuj względem ich commitów;
  README jest żywym stanem. Nowe manifesty wyników nie pinują żywego README.

Pozostałe zasady głównego AGENTS i WORK_COMMITS nadal obowiązują.
