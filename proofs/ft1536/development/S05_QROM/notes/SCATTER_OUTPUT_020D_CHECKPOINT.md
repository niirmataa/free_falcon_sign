# TODO020 / continuation020D — EveryTape i pełne J/P maszyny

Status: **KERNEL_EVERYTAPE_AND_FULL_LAW_UNDER_M / WARUNKOWY / NOT_REVIEWED**.
Data:2026-10-12. Rozwinięcie S05/ROADMAP, wejście020C z checkpointu
`3209aa5b45af3d8d93a12243b94985b5b174e855`. Własna kontrola autora;
bez niezależnego odbioru, importu stages, tagu ani deklaracji bezpieczeństwa.

## Co rzeczywiście wykazano

Oryginalny program `PairProgram020.program` wykonuje teraz kernelowo
sprawdzone **select → multiply → emitPair**. Dla każdego publicznego h,
każdej taśmy24662538240 bitów i każdego stanu początkowego daje dokładnie
pełne50689-bitowe kodowanie wyniku niezmienionej referencji019. Zachowuje
wejściową flagę błędu. Z publicznego `initial` kończy bez błędu.

`ProgramRefinement020D.every_tape` wypełnia dokładnie propozycję
`RefinementTarget020.EveryTape`, pozostawioną otwartą w020. Nie przyjmuje
poprawności scatter, kodera, tablic ani układu taśmy jako nowych przesłanek.
Twierdzenie deterministyczne nie potrzebuje(M) i nie rekonstruuje historii
kwantowych zapytań.

Przeniesiono też certyfikat probabilistyczny na wyjście tej samej maszyny:

- `MachineCertificate020D.all_h_ac`: J≪P dla każdego h i stanu;
- `actual_certificate`: ΣJ²/P≤1+2⁻⁴⁷ pod dokładnym, dotychczasowym(M);
- `public_initial`: ta sama instancja przy zawsze publicznym initial;
- `same_key_law`: to samo pokryte prawo kluczy μ na obu stronach,
  z zachowaniem h w obserwacji, bez ponownego losowania lub warunkowania.

Tutaj **J to prawo faktycznego wyjścia020**, a **P to bezstratnie zakodowane
pełne prawo odniesienia019**. `WireFormat020D.wire_injective` obejmuje
również `none`. Nie usuwamy porażek ani nie warunkujemy P na sukcesie.
Generator wspólnej pary019/020 zwraca `some`; jego zerowa masa przy `none`
nie usuwa tych atomów z przestrzeni ani z odniesienia. Dowód AC i momentu
porównuje pełne prawa, tak jak wcześniejszy certyfikat.

Równość kodu i prawa obejmuje każdy stan maszyny. Wywołania publiczne
używają initial; nie wyciągamy z certyfikatu historii stanu orakulum.
To nadal generator **wspólnej pary**, nie sampler odpowiedzi na dowolny
z góry ustalony challenge. Przeszkoda dokładnego adaptera019 pozostaje.

## Jak domknięto konkretną instancję

| Warstwa | Wypełniony obowiązek |
|---|---|
| Interleaved/IndexReference/DataWords/KeyWords | RAM i ROM mają te same współczynniki, znaki i wykładniki co019 |
| BufferUpdate/BufferField/ScatterBranches | Aktualizacja modulo18433 i wszystkie trzy gałęzie redukcji wykładnika |
| ScatterRead/ScatterTerm/ActualScatter | Rzeczywiste instrukcje czytają właściwy klucz i podpisane dane |
| ClearBuffer/ScatterRow/MultiplyRow/MultiplyLoop | Czyszczenie oraz obie pętle1536; cały multiply równy Scatter.multiply019 |
| OutputSlice/EmitStep/EmitWord | Każdy bit ma właściwą pozycję, kolejność i wartość; ramki pamięci zachowane |
| EmitRead/Entry/Loop/Tag | Rzeczywiste pola16/17 bitów, przesunięcie signed+65535 i bit obecności |
| EmitPredicates/OutputFormat/EncodedOutput/ActualEmit | Pełne50689 bitów jest dokładnym PairEncoding020 wyniku019 |
| ProgramRefinement | EveryTape oraz brak błędu z initial, bez wolnej przesłanki poprawności etapu |
| WireFormat/MachineLaw/MachineCertificate | Iniektywne kodowanie obu praw, konkretne J/P pod(M), to samo pokryte μ |

Ogólne konstruktory kroków pozostają użytecznymi lematami pomocniczymi.
W eksportach końcowych wszystkie ich lokalne przesłanki są wypełnione.
(M) pozostaje jawnym obowiązkiem matematycznym dotyczącym klucza;
nie awansuje do założenia kryptograficznego ani do dowodu dla każdego h.

## Koszt i granica modelu

`ProgramRefinement020D.public_initial_with_cost` odnosi wynik i bound do
**tego samego oryginalnego programu**. Zachowuje bound rdzenia020:
1106642201817 operacji w zadeklarowanym modelu słowa512bit.
W tym oknie nie uruchamiano programu dla całej konkretnej taśmy;
powstał uniwersalny dowód, nie pomiar takiego wykonania.

Koszt zbudowania obrazu wejścia, dostarczenia losowości, zewnętrznego
przekazania wyjścia oraz reprezentacji kodu/sterowania i pełnej pamięci
szczytowej pozostaje OPEN. `initial` i skończone banki modelu nie zapewniają
same z siebie świadectwa alokacji konkretnej implementacji. Nie jest to
czas CPU, koszt C ani pełny certyfikat Q-RESC. Nie ogłaszamy praktycznej
szybkości na podstawie tak dużego oszacowania instrukcji.

## Kontrola, piny i nieudane próby

- **186 nowych twierdzeń,41 modułów dowodowych i audyt całości.**
- 72 próby Lean zachowane;42 końcowe czyste buildy,30 nieczystych/nieudanych.
- Audyt `#check` i `#print axioms` wszystkich186 eksportów:180 list będących
  podzbiorami {propext, Classical.choice, Quot.sound};6 bez aksjomatów.
- Brak nowych aksjomatów, sorry, native_decide/bv_decide i wyciszeń linterów
  w przyjętych źródłach. To kontrola autora, nie niezależna recenzja.
- Jedna próba `program001` trafiła w limit pamięci kernela; inne niepowodzenia
  dotyczyły rozwijania dużych termów/list, zależnych indeksów lub elaboracji.
  Rozwiązaniem były ogólne lematy kompozycji i nazwane granice reprezentacji.
  Nie zmieniono programu ani semantyki wykonania.
- Nieudana instalacja `scalar001` została prawidłowo odrzucona. Następujący
  po niej `branches001` wykazał brak zależności. Żaden wadliwy artefakt nie
  został przyjęty; zachowano `INSTALL_REJECT_001.json` i oba receipty.
- Guard Git wykrył zmianę HEAD przed pierwszym commitem; nie zapisywał wtedy
  indeksu. Rozłączne zmiany sprawdzono i zachowano osobny receipt ponowienia.
- 38 pinów wyników i244 runtime020C ponownie sprawdzono.447 wejściowych
  modułów zachowano; końcowa biblioteka ma489 przypiętych źródeł/artefaktów.
- Każda próba ma snapshot źródła, wrapper, stdout/stderr i receipt. Rachunek
  matematyczny jest uniwersalnym dowodem Lean; nie zmieniono przybliżeń ani
  tablic probabilistycznych i nie dodano nowych skończonych testów Sage.

Małe commity źródeł: `35484c4b` (scatter), `e3488d07` (multiply),
`eb7a8e7f` (wyjście/EveryTape), `a0f5c327` (J/P i audyt).
Manifesty `SCATTER_OUTPUT_020D_OUTPUTS.sha256` i `..._RUNTIME.sha256`,
receipty oraz pełny wykaz prób w `..._CHECKS.json`. Runtime:
`.build/pair_machine_020/scatter_output_001/`.

Certyfikat pochodzi z przypiętego środowiska legacy019. Nie połączono go
z naprawioną grą ROM wariantu A przez podmianę wersji modułów. Nie konsumowano
nowych commitów ROM/source3 w tym kroku; ich postęp nie jest przesłanką020D.
Historyczne checkpointy i manifesty pozostały nienaruszone.

## Mapa murów

| Warunek | Klasa i stan po020D |
|---|---|
| Zgodność całego020 z019 / EveryTape | Obowiązek Q-SAMPLER, KERNEL CLOSED |
| Pełne kodowane J≪P | Obowiązek Q-SAMPLER, kernel dla każdego h |
| Moment≤1+2⁻⁴⁷ maszyny | Obowiązek Q-SAMPLER, kernel pod niezmienionym(M) |
| To samo pokryte prawo kluczy | Kernel przy jawnym cover i(M); źródłowa instancja OPEN |
| Bound instrukcji tego samego rdzenia | Obowiązek Q-RESC, kernel w modelu020 |
| Wejście/losowość/wyjście, kontrola i pełna pamięć | Obowiązek Q-RESC, OPEN — następny020E |
| Słowo512bit, banki i ceny instrukcji | MODEL, zachowany jawnie |
| Emisja KeyGen i źródłowe pokrycie(M) | Obowiązki Q-KEY/Q-BIND, OPEN |
| Rzeczywiste Sign, wariant A, hop PRG | Obowiązki Q-BIND/Q-PRG, OPEN |
| A-QMT, primitive-bound Q-PRG | Założenia kryptograficzne, bez zmian |
| Log/reprogramowanie, embedding, kolizje i kompozycja QROM | Obowiązki kwantowe, OPEN; pełna księga w TARGET_CONTRACT |

Nie zmieniono nonce320, kierunku J/P, e, D=(1+e)^q_s−1 ani przesłanek
kwantowego użycia kompozycji. T12.1/B20/paper/mainline bez zmian tego okna.

**Ocena:** domknęliśmy rzeczywistą lukę między certyfikowaną referencją a
całym programem instrukcji. Następny krok to pełne zasoby tego programu,
nie ponowne dowodzenie samplera. Końcowe bezpieczeństwo QROM nadal wymaga
źródłowych i kwantowych obowiązków wskazanych w kontrakcie.
