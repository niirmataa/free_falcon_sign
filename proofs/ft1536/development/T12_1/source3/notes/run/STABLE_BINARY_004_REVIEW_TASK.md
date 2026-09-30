# Materiał do niezależnego odbioru — STABLE_BINARY_004

Status: **PREPARED_OWNER_START**. Nie uruchomiono recenzenta.
Autor: GPT-6 Astra, sesja `ses_f12636605ffeL1FZg4teLUwUf5`.
Odbiór, model recenzenta, jego osobny W i start wybiera właściciel.

## Kotwice przekazania

W autora:
`proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002/continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003/`.
Poniższe ścieżki są względem W:

| Plik | SHA256 |
|---|---|
| `run/STABLE_BINARY_004_REPORT.md` | `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96` |
| `run/STABLE_BINARY_004_CLOSURE.json` | `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2` |
| `run/stable_binary004_fresh_001/RECEIPTS.json` | `5d1af659b13588bee958dda41261791521d4867bdfab7beeec7b43490aab2fd5` |
| `run/formal/Source3/StableBinary004Outcome.lean` | `5229e200d264144ee41ed6d327010648a3b932cee957ffbb965c301400badec9` |
| `run/formal/Source3/C99HeaderProof.lean` | `14fb1d7a72b9fa30170defa20af7ddfffa69d4e7104fc8fb2022a00f2f887fee` |
| `run/formal/Source3/C99PrimitiveProof.lean` | `191b7e2791b828455d6779cbecf609c17a5b1433c969721e3dc8bf96242c701d` |

Autor zgłasza **PROVED_KERNEL_SCOPED B1/B2/B3/B4**, nie REVIEWED.
Fresh:54 moduły,261 twierdzeń,171.661s,maxRSS5953120KiB, wszystkie logi
clean przy warningAsError. Nie traktuj tych liczb ani zgodności hashy
jako zastępstwa niezależnego sprawdzenia matematyki i adekwatności modelu.

## Zlecenie dla recenzenta

Sprawdź dokładnie zakres B opisany w raporcie; source binding i semantykę
potraktuj równie poważnie jak kompilację termów. Użyj osobnego W i świeżych
produktów dla nowej closure, zachowując autorskie W read-only. Reused
A1–A3/byte-frame/memcpy/erasure pozostają przypiętymi zależnościami;
rozlicz ich hashe i import graph. Nie wybieraj nowszego P02 headera.
Nie wykonuj freeze całego RUN_003, Git/push ani startu innych modeli.

1. **B1:** porównaj pełne kwantyfikatory `HeaderCompleteness` z `_003`.
   Sprawdź argument conversion, WellTyped/initialization, declarations,
   assignment/update/return, short circuit, unsigned left shift i count32
   wyprowadzony przez checker AST. CallRelation musi być FunctionExec
   rzeczywistej tabeli; brak completeness hypothesis w końcowym termie.
2. **B2:** dokładny wynik add/mul/div, macro lowering/scope i reference
   while div55, wszystkie guardy i increment oraz lifetime b. Sprawdź także
   soundness i `all_primitives_inhabited`, aby reference nie była pusta.
3. **B3 — kluczowy punkt adekwatności:** niezależne `C99HelperReference`
   i `C99CheckReference`, ich source grammar i specjalizowane reguły
   kontrolne. Zweryfikuj normalizację private locals do SSA witnesses,
   powiązanie declarations/uses, deskryptory/tablice/elementBytes/offsety,
   granice PointerAdd, size_t n/hn/u i LP64 conversions. Zweryfikuj oba
   dozwolone porządki argumentów oraz lhs/rhs i brak ukrytych efektów
   w uznanych za pure operands. Oddziel dowód o autorskiej semantyce od
   oceny, czy obejmuje ona cały żądany fragment source execution.
4. **Pamięć i trace:** load32/64, store32/64, bez initial scratch reads,
   bad RMW w poprawnym miejscu, sześć kontroli/iterację, pełna pamięć
   także poza trzema obszarami, memcpy z pre-copy snapshotu, prawa
   rekurencja values+hn. Skontroluj również prywatne bitcast objects.
5. **B4:** przeczytaj dokładne typy i termy `pinned_complete`,
   `source_execution_exists`, `source_outcome`; finalny typ ma zaczynać
   się od niezależnego source judgment + dawnych Legal/wellFormed.
   Sprawdź, czy nie wprowadzono równoważnika brakującego wniosku jako
   założenia. Positive-finite/no-fallback jest wnioskiem przy final bad0.
6. **Replay/audyt:** odtwórz źródła wskazane w closure w kolejności z
   `run/stable_binary004_tools.py modules`, ze źródłami/produktami zależności
   i bibliotekami przypiętymi przez closure. Zachowaj raw logs, użyj
   dotychczasowych limitów i warningAsError. Sprawdź261 wydruków typów,
   termów i transitive axioms; dopuszczalne tylko propext/choice/Quot.sound.
   `stable_binary004_tools.py record` jest organizatorem hashy autora,
   nie samodzielną recenzją.
7. **Mutacje:** pięć testów w `StableBinary004Audit`; szczególnie błędny
   wynik przy nadal Some, lifetime/konwersja, brak RMW i zgubiona kontrola.
   Zachowane failed attempts są materiałem diagnostycznym. Skończony
   test nie zastępuje uniwersalnego dowodu.

Werdykt podaj oddzielnie dla B1–B4 i globalnie, z rzeczywistym scope.
Jeżeli brakuje source-adequacy lub któregoś efektu, wskaż konkretny typ,
regułę i kontrprzebieg/brak dowodu; nie nadawaj scoped PASS na podstawie
samego kernela. Jeżeli zakres spełnia kryteria, wyraźnie zachowaj granicę:
autorski fragment C99/GCC-LP64, bez weryfikacji kompilatora, ISO C w całości,
FPEMU real-error, FFT/exact Gram, pełnego KeyGen, T5, M6 i C Sign.

## Krótka ocena autora

Najważniejszą zmianą względem `_003` jest zamknięcie dokładnej zgodności
wyniku, a nie tylko totalności. Istnienie reference execution jest teraz
wykazane dla całego Legal. Najważniejszym zadaniem recenzenta pozostaje
adekwatność wyspecjalizowanej formalizacji źródła i normalizacji efektów.
Jest to materiał do odbioru; nie wykonano samodzielnego odbioru.
