# REFERENCJA: struktura pinów i pochodzenie olean (dla okien R1)

Cel: NIE dochodzić tego w oknie. Wszystkie okna czytają ten plik
zamiast badać strukturę. Uwagi/korekty: dopisuj jako SUPLEMENT
(nowa sekcja „Uzupełnienie YYYY-MM-DD"), nigdy nie przepisuj.

## 1. Skąd biorą się .olean
- Każdy przyjęty job buduje moduł w `.build/jobs/<nazwa_joba>/lib/Source3/<Moduł>.olean`.
- Przy przyjęciu joba: commit (feat) + **pin olean w rejestrze BATCH_XXX.json**
  (np. BATCH_088/089 — „olean-piny w BATCH_089").
- .olean jest artefaktem buildu — NIE jest źródłem prawdy; źródłem jest
  .lean w `source3/formal/Source3/`. Olean = dowód przyjęcia kompilacji.

## 2. Rodzaje pinów (kolejność łańcucha wejścia okna)
1. **ENTRY_PINS.json** (`.build/<etap>/ENTRY_PINS.json`) — manifest
   dziedziczonych pinów poprzedniego poziomu (SHA256 pliku manifestu
   porównywane z pinem z raportu trasy, np. `99ac47a1…`).
2. **POSTSEAL_<poziom>** — pin zestawu uszczelnionego checkpointu
   (liczba ścieżek, np. 73 564; 0 braków / 0 zmian = PASS_INTEGRITY).
3. **receipt produktu** — SHA256 receiptu wejścia (np. `1d6f11ec…`).
4. **Piny modułów** — w meldunkach: `<Moduł> <job> <commit> <source-hash>`
  (+ olean-hash w BATCH). Audyt job sprawdza: DAG roundtrip, kernel
  przy oryginalnym typie, logi 0/0, 3 aksjomaty.

## 3. Re-baseline łańcucha pinów (decyzja o rozszerzeniu stratum)
Precedens: B1.03 (r2/div). Wzór (suplementy, nie nadpisania):
1. Nowa wersja `C99ModularReference.lean` z konstruktorem `modp_Rx`
   = NOWY plik-wersja lub suplement-notatka z obiema wersjami pinów.
2. Re-baseline: policzyć nowe SHA256 dla zmienionych modułów i ich
   oleanów; zapisać STARY i NOWY łańcuch w `_REBASELINE_<id>.md`
   (co się zmieniło i dlaczego — powołanie na decyzję właściciela).
3. Następne okna dziedziczą NOWY ENTRY_PINS; stare akta zostają nietknięte.
4. Obowiązek meldunku: jawnie „re-baseline wykonany, stary pin X → nowy Y".

## 4. Dyscyplina kontekstu (obowiązkowa od 2026-10-21)
- **HISTORIA SIĘ ŁADUJE, NIE ODTWARZA.** Kontekst projektu jest gotowy:
  `/home/footfalcon/SERCE/history/` (`KRONIKA_FT1536.md`, `CHRONICLE.md`,
  `DECYZJE_WLASCICIELA.md`) + `SERCE/memory/`. Czytaj WYBRANE SEKCJE
  (szukaj po temacie), nigdy nie odtwarzaj historii z commitów/git log.
  Skill `ft-historia` (w `SERCE/skills/`) ma zasady dopisywania.
- **WORK_STATE prowadzony na bieżąco**: po KAŻDYM jobie dopisz jedną
  linię (job, status, co dalej). Nie na końcu okna — w trakcie.
- Pytania „skąd to / jak zbudowane" → najpierw TEN plik, SERCE i raporty
  checkpointów; jeśli brak — dopisz suplement tutaj i idź dalej.
- Kontekst: okno pracuje do **700 000 tokenów** — tam zamroź w punkcie
  odzyskiwalnym i melduj; nowe okno wznawia z WORK_STATE, bez
  dochodzenia od nowa. Wcześniej tylko przy wyczerpaniu jobów
  albo po domknięciu kamienia milowego.
- Decyzja właściciela 2026-10-27: **BEZ szkieletów z sorry** — nawet
  nieśledzonych. Wykonawca potrafi dowodzić wprost: moduł Source3
  powstaje z realnymi dowodami (0 markerów) albo wcale; scratch
  diagnostyczny wyłącznie w `.build` (odrzucany).

## 5. Uzupełnienia (dopisuj tutaj, data + inicjał okna)
- (miejsce na kolejne suplementy)
