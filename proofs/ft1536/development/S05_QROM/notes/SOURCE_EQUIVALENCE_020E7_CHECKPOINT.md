# TODO020E7 — uniwersalny odczyt producenta i referencyjny efekt slotów

**PARTIAL_KERNEL / IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.**
**Nie zamknięto całego polecenia właściciela:** pełna uniwersalna zgodność
konkretnego producenta ze starszym krokiem samplera pozostaje OPEN.
Domknięto odczyt źródłowy i referencyjny efekt układu; nie utożsamiamy ich
z brakującym dowodem decyzji i zapisów konkretnego obwodu.

Baza S05: `8ed5e9e9a800ca7cee9a5b38f42b788ef3c9a8af`.
Źródła odczytu: `592455c3803e5a0ff2db590df48bff2050807d8d`.
Układ referencyjny i kontrola kernela: `865c316690b3caf167850c47ae97e0eb072f0859`.
Runtime: `.build/pair_machine_020/source_equivalence_001/`.
Jedno okno, jeden proces Lean naraz, lokalne commity na main, bez push.

## Co rzeczywiście wykazano

1. `ProducerWindowSource020E7.field` dowodzi równości każdego z **96 pól**
   rzeczywiście wykonywanego odczytu z `ProducerSnapshot020E6.fields`.
   Kwantyfikatory obejmują każdy `BoundaryPayload020E5.Data`, oba `fresh`
   i każdy indeks. Brak przesłanki osiągalności stanu, poprawności programu,
   dekodowalności tokenu lub udanego odczytu cache. To uniwersalny dowód,
   nie rozszerzenie skończonych testów E6.
2. `window` składa równość całych banków; `executed` wiąże ją z wykonaniem
   zainstalowanego `ProducerStored020E6.windowCode`. Podstawą są wcześniejsze
   dowody kompilatora i maszyny pobierającej instrukcje. Nie dostarczamy
   gotowego snapshotu jako bezkosztowego wejścia wykonawcy.
3. Odczyt obejmuje metadane, pusty/niepusty stos, pola węzła skanowanego
   i wykonywanego, oba argumenty skanowania, trzy argumenty instrukcji,
   rejestr, RAM, ROM, taśmę i wszystkie pola zerowego dopełnienia.
   Brak wartości i nieprawidłowy adres dają dokładnie odpowiednią
   reprezentację źródłową. Ujemny payload rejestru jest normalizowany przez
   `toInt.toNat` tak samo jak stary dekoder; ujemny adres pamięci jest odrzucany.
4. `ProducerReference020E7.stored_output` wiąże wynik **obu** zainstalowanych
   programów z konkretnymi wyrażeniami `CoreSlots` na tym udowodnionym
   snapshotcie. `fresh_irrelevant` dotyczy wyłącznie tego producenta poleceń
   rdzenia; nie twierdzi, że sampler nie potrzebuje losowości.
5. `ProducerSlotLayout020E7.layout_effect` dowodzi, że opcjonalne zapisy
   danych w pierwszych trzech slotach, szesnaście slotów sterowania oraz
   trzynaście pustych slotów mają efekt starej konkatenacji list zapisów.
   `reference_effect` instancjonuje to starszym `CoreStore/CoreStep` dla
   każdego typowanego stanu. Puste sloty i zapisane zera nie są mylone.

## Dokładnie co pozostaje

Brakuje dowodu następującego zdania, zapisanego jako jawny cel
`ProducerSlotLayout020E7.RemainingEquality`:

```lean
∀ d : BoundaryPayload020E5.Data,
  ArrayBank020E4.load (fun j =>
    ProducerExpr020E6.eval (ProducerReference020E7.env d)
      (ProducerCoreSlots020E6.cells j)) =
  ProducerSlotLayout020E7.encodedReference d
```

To **otwarta propozycja**, nie aksjomat ani przesłanka przemycona do gotowego
certyfikatu. Trzeba wykazać zgodność `scanPresent/scanValue` ze starym
`ArrayValues.entry`, `actionOK/edit/pending` z `FixedAction/MemoryEdit`,
wszystkich szesnastu słów `nextMeta` z `CoreControl.next`, adresów i flag
opcjonalnych zapisów oraz zerowego dopełnienia. Obejmuje to fazy
check/clear/scan/act/push/done/bad, brak argumentów, przepełnienie stosu,
wyczerpanie licznika, błędne tokeny i nieprawidłowe adresy.

Dopiero ta równość łączy dwa końce już domknięte w E7. Równość efektu
mogłaby wystarczyć zamiast równości surowych banków, ale również wymaga
pełnego dowodu; nie osłabiono po cichu dziedziny stanów.

## Próby i kontrola

- **15 modułów wynikowych, 63 twierdzenia, audyt 72 eksportów.** Wszystkie
  końcowe logi tych modułów oraz audytu są czyste. Dopuszczone aksjomaty
  audytu: `propext`, `Classical.choice`, `Quot.sound`; bez `sorryAx`, nowego
  aksjomatu, `native_decide`, `bv_decide` i wyłączania linterów.
- Zachowano **41 uruchomień** z kopiami źródeł, stdout/stderr i receiptami.
  `decision001` dochodzi do siedmiu otwartych przypadków faz. `control001`
  pozostawił niedomknięte bloki przypadków. `control002` przekroczył limit
  heartbeatów przy rozwijaniu całego kontekstu. `control003` ograniczył
  upraszczanie do celu, ale nadal pozostawił cele Word512 i osiągnął limit
  heartbeatów. Żaden z tych modułów nie został zainstalowany ani uznany za dowód.
- Nie znaleziono kontrprzykładu. Komunikat `omega` o możliwym modelu
  arytmetycznym nie jest kontrprzykładem do semantyki źródłowej: taktyka
  nie miała brakujących powiązań słów/warunków.
- Profile kompilacji są w CHECKS i receiptach; budowano sekwencyjnie z
  limitem Lean 4096 MiB. Są to koszty sprawdzania dowodu, nie koszty samplera.
  Brak nowego oszacowania numerycznego lub testu Sage do awansowania na dowód.
- [Kontrola autora](SOURCE_EQUIVALENCE_020E7_SELF_REVIEW.md) nie jest odbiorem
  niezależnym. [Klasy](CERTIFICATE_CLASSES_020E7.json),
  [kolejka](KERNEL_QUEUE_020E7.json), [receipty](SOURCE_EQUIVALENCE_020E7_CHECKS.json).

## Mapa murów i następny krok

| Obowiązek | Stan po E7 |
|---|---|
| Pełny odczyt snapshotu ze źródeł | KERNEL, scoped CLOSED |
| Wykonany kod daje wyrażenia na tym snapshotcie | KERNEL, scoped CLOSED |
| Referencyjne sloty mają efekt starego CoreStep | KERNEL, scoped CLOSED |
| Konkretny obwód daje ten referencyjny efekt | **OPEN — następny krok** |
| Producent parsera/fill/startup | OPEN |
| Wspólny czas życia obu etapów, pełny peak/czas samplera | OPEN |
| Pokrycie źródłowego (M), KeyGen/Sign, konkretny hop PRG | OPEN, bez zmian |
| QROM hash/embedding/collision/reprogramming i reszta TARGET_CONTRACT | OPEN, bez zmian |

Następna praca rozwija ten sam obowiązek: małe lematy semantyczne po polach
i fazach zamiast jednego rozwinięcia całej struktury przez `simp_all`.
Zachowane są dotychczasowe J≪P i moment pod **tym samym (M)**. Nie ma nowego
transportu J/P przez producenta, zmiany prawa kluczy, pełnego peak ani
nowej deklaracji bezpieczeństwa FT1536 w QROM. Monitor ROM pozostaje PAUSED.

Manifest OUTPUTS obejmuje wynik i narzędzia; nie pinuje żywego README.
Manifest RUNTIME zamraża pliki istniejące w chwili zamknięcia, w tym nieudane
próby; późniejszy plan/receipt commita dokumentów i POSTCOMMIT są dopiskami
operacyjnymi poza tym manifestem. Stare manifesty i źródła E6 pozostają nienaruszone.
