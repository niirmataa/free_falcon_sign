# TODO020E8 — zgodność sterowania, skanu i trzech pełnych przypadków

**PARTIAL_KERNEL / IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.**
Pełne zlecenie uniwersalnej zgodności producenta ze starym krokiem nadal
pozostaje OPEN. E8 zamyka konkretne części tej samej luki; nie zmienia celu
na słabszy eksperyment ani nie dodaje założenia o zgodności.

Baza S05: `fa9253b8359f950a20b0c8eb4f9f5dce4c50159b`.
Sterowanie: `2da8971ac5f1f85ff7c360ce3472358efe32e223`.
Skan, sloty i przypadki pełne: `5b359eae386e6378d6af78f0fe1a4065a420f48f`.
Runtime: `.build/pair_machine_020/decision_equivalence_001/`.
Jedno okno i jeden ciężki proces naraz; lokalny main, bez push.

## Co wykazano

- `ProducerControlNonact020E8.source`: **wszystkie 16 słów sterowania**
  rzeczywistego czytnika i obwodu są zgodne z `CoreControl.next` w fazach
  check/clear/scan/push/done/bad. Dziedzina obejmuje każdy typowany stan,
  bez założenia osiągalności lub sukcesu. Push obejmuje brak oczekujących
  ramek, jedną/dwie ramki oraz przepełnienie stosu.
- `ProducerScanSpec020E8.source` wiąże specyfikację na snapshotcie z dawnym
  `ArrayValues.entry`. `ProducerScanDecision020E8.correct/cache_words`
  domykają **całą decyzję skanu i oba słowa cache** z konkretnego obwodu.
  Obejmują 16 tagów modelowanej komórki, wszystkie payloady Word512, siedem
  operacji ALU, niepoprawne opcode/rejestry, brak węzła/wartości i ograniczenie
  dzieci do wcześniejszych węzłów. Nie ograniczono dowodu do legalnego programu.
- `ProducerOutputSlots020E8.control` wiąże **wynik uruchomionego kodu**
  z referencją w 16 slotach sterowania poza act. `padding` obejmuje 13 pustych
  slotów we wszystkich fazach. Każdy slot ma trzy słowa512bit. Są to
  pokryte części reprezentacji, nie procent ukończenia dowodu.
- `ProducerPassive020E8.executed/reference_equality` zamykają **całą bankową
  równość wyjścia** dla check/done/bad. To dokładne przypadki oryginalnego
  `ProducerSlotLayout020E7.RemainingEquality`, obejmujące wszystkie96 słów.
  `script` konstruuje konkretny świadek bufora: jego obrazem jest wynik
  zainstalowanego producenta, a jego wykonanie daje stary `CoreStep`.
  Świadek służy dowodowi; nie podstawiamy referencji do runtime i nie
  deklarujemy dodatkowego dekodera ani nowego rachunku alokacji.
- `ProducerDataList020E8.values_code/frames_code` dowodzą jawnej postaci
  zapisów cache i ramek. To materiał do pozostałego połączenia trzech
  aktywnych slotów, a nie samo zamknięcie tego połączenia.

Przesłanka `phase ≠ act` i predykat `Passive` są jawnymi zakresami lematów
składowych. Nie zastępują docelowego kwantyfikatora nad wszystkimi stanami.

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Wszystkie96 pól rzeczywistego czytnika | KERNEL, E7 |
| Sterowanie:16 słów, sześć faz poza act | KERNEL, E8 |
| Pełna decyzja skanu i kodowanie dwóch słów cache | KERNEL, E8 |
| Wyjściowe sloty sterowania poza act; pusty ogon zawsze | KERNEL, E8 |
| Cały producent kontra stary krok: check/done/bad | KERNEL, E8 |
| Trzy sloty danych: clear/scan/push | **OPEN — następny krok** |
| Act: sukces/odrzucenie, edit, pending, sterowanie i dane | **OPEN** |
| Cały krok bez ograniczenia fazy, potem EveryTape/J/P | **OPEN** |
| Inne rodziny producenta, pełny czas życia/czas/peak | OPEN, bez zmian |
| Pokrycie (M), rzeczywiste KeyGen/Sign/PRG i pozostała redukcja QROM | OPEN, bez zmian |

Przy aktywnych slotach trzeba wykazać **tag obecności, adres i wartość**.
Brak wartości cache oznacza dwa aktywne zapisy zerujące cache, a nie brak
poleceń zapisu. Dowód samego `cache_words` tej różnicy nie rozstrzyga.

## Nieudane próby i następna droga

W `datacases001–003` próbowano bezpośrednio wydobyć kod gałęzi clear z
`CoreDataPatch.program`, wygenerowanego wcześniejszym dowodem. Redukcja
napotkała transporty `Decidable.rec/Eq.mpr` i limity głębokości/heartbeatów.
Nie jest to kontrprzykład. Próby zachowano; z modułu wynikowego DataCases
odebrano wyłącznie osobno domknięte check/done/bad.

Następna praca powinna domknąć obecność/adres/wartość trzech slotów dla
clear/scan/push, korzystając z `values_code/frames_code`, już zamkniętego
skanu i poprawności prymitywnych patchy. Możliwy jest bezpośredni dowód
**efektu** zamiast redukowania równości kodu zależnego od dowodu. E7 dopuszcza
równoważność efektu jako wystarczającą, lecz taki wybór trzeba opisać jawnie
oraz zachować każdą fazę i porażkę; E8 nie ogłasza go już wykazanym.
Po tym pozostaje pełny dispatch act i złożenie siedmiu faz.

## Kontrole, zasoby, granice

**26 modułów wynikowych, 81 twierdzeń, audyt 98 eksportów.** Wszystkie końcowe
logi modułów i audytu są czyste. Aksjomaty: wyłącznie standardowe
propext/Classical.choice/Quot.sound; bez nowego aksjomatu, sorry/admit,
native_decide/bv_decide i wyłączania linterów. Zachowano 55 uruchomień.

`scandecision004` został przerwany przez wewnętrzny limit pamięci Lean
4096 MiB, z komunikatem memory_exception w interpreterze; szczytowym RSS 4 195 892 KiB.
Nie awansowano tej próby do sukcesu. Ogólny lemat transportu oddzielił
składanie dowodu od specjalizacji konkretnego czytnika. Czysta próba005
zajęła 2,070 s przy tym samym limicie4096 MiB.
To diagnostyka **kompilacji dowodu**, nie pomiar czasu/pamięci samplera.
Nie zmieniano kodu kandydata E6 ani nie dodano funkcji hosta do jego instrukcji.

[Receipty](DECISION_EQUIVALENCE_020E8_CHECKS.json),
[klasy warunków](CERTIFICATE_CLASSES_020E8.json),
[kolejka](KERNEL_QUEUE_020E8.json),
[kontrola autora](DECISION_EQUIVALENCE_020E8_SELF_REVIEW.md).
Brak niezależnego odbioru. Niezmienione J≪P i moment pod tym samym(M);
brak nowego transportu całego prawa przez producenta, pełnego peak lub
nowej deklaracji bezpieczeństwa FT1536 w QROM. Monitor ROM PAUSED.

OUTPUTS nie pinuje żywego README. RUNTIME zamraża istniejące w chwili
zamknięcia pliki, włącznie z próbami nieudanymi; późniejszy plan/receipt
commita dokumentów i POSTCOMMIT są operacyjnymi dopiskami poza manifestem.
