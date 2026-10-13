# TODO020E / continuation001 — parser w stałych bankach

**KERNEL_SCOPED_PARSER / PARENT020E_IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.**
Data2026-10-13. Baza d2e192ec744d77e5e6dd8663bfbc59e5881c7e09.
Rozwinięcie S05/ROADMAP. Domknięto podetap parsera; pełne Q-RESC pozostaje OPEN.

## Co wykazano

Parser ma skończoną tablicę węzłów, skończony bank adresów stosu i dwa
ograniczone liczniki. Każdy poprawny krok dopisuje jeden węzeł, zdejmuje
wymaganą liczbę adresów i wpisuje nowy adres. Aktywne dzieci wskazują
wyłącznie wcześniejsze węzły. Runtime sprawdza miejsce, adresy i typy,
bez odwoływania się do pomocniczej denotacji Meaning z dowodu.

**Dla oryginalnego programu FT1536:** parsowanie kanonicznego obrazu kończy
z used=877 i sp=1. Odczyt wyniku wyłącznie z banku węzłów odtwarza dokładnie
`PairProgram020.program`. Nie podstawiono innego programu ani samplera.
Ogólny dowód obejmuje każdy legalny Code i wystarczającą pojemność.

Najważniejsze eksporty:

- `ArenaInvariant020E1.step_refines`: rzeczywisty krok równy SyntaxTape.push;
- `ArenaParse020E1.parse_refines`: cały ciąg, jeden nowy węzeł/token;
- `ArenaDecode020E1.root_correct`: odkodowanie z banku bez ghost danych;
- `ArenaProgram020E1.actual_roundtrip` i `actual_counts`: instancja877;
- `ArenaGuard020E1.rejects_iff`: dokładny komplet strażników odrzucenia;
- `ArenaWords020E1.actual_pack_injective`: bezstratne kodowanie całego stanu;
- `ArenaExecution020E1.public_initial`: zachowanie wcześniejszego EveryTape
  po parsowaniu i odtworzeniu Code, z publicznym initial.

## Reprezentacja i jej granice

Każdy węzeł ma pięć pól słowowych: tag, payload i trzy adresy. Stos ma jedno
słowo/adres, liczniki used i sp po jednym. Dla areny877 daje to **5264 słowa
512bit** w bezstratnym kodowaniu trwałego stanu. Piny wiążą formułę i kernelowy
wynik liczbowy; nie jest to pomiar pamięci natywnego programu.

Ten rozmiar nie obejmuje wejścia, scratch, wywołań dekodera ani reszty
samplera. Pamięć szczytowa i pełny czas pozostają otwarte. Obecny bridge
wykonania odtwarza AST Code, a potem woła dotychczasowy interpreter logiczny.
Bezpośredni wykonawca po adresach węzłów jest następną częścią020E.

Odrzucenia parsera nie są nowymi porażkami Sign. Pełny obraz programu ma
dowód poprawnego parsowania. Decoder komórek zachowuje wcześniejszą semantykę;
nie ogłaszamy walidacji kanoniczności dowolnych surowych bajtów.
Nieużywane pola child mogą zawierać0 — wcześniejszość dotyczy aktywnych dzieci.

## Co zmienia to w projekcie

Luka „mamy tylko abstrakcyjne listy i rozmiar składni” została zmniejszona:
parser naprawdę pracuje na ograniczonych bankach adresowanych, a jego wynik
ma dokładnie znaczenie znanej składni. Można teraz budować interpreter
używający adresów do tej stałej tablicy. Pętle mogą trzymać adres body i licznik,
zamiast tworzyć kolejne kopie AST. Ta implementacja i jej zasoby nadal wymagają
dowodu — nie wynikają automatycznie z samego roundtrip parsera.

## Kontrola i historia

**71 nowych twierdzeń,16 modułów dowodowych i jeden audyt.**17 końcowych
czystych buildów,29 prób łącznie,12 nieczystych/nieudanych zachowanych.
Audyt wszystkich71 nazw:69 list będących podzbiorami
{propext, Classical.choice, Quot.sound},2 bez aksjomatów. Bez nowych aksjomatów,
sorry, native_decide/bv_decide i wyciszeń linterów w przyjętych źródłach.
To własna kontrola autora, nie niezależny odbiór.

29 pinów wyników i189 runtime020E sprawdzono;507 modułów wejściowych
zachowano. Końcowa biblioteka ma524 przypięte źródła i artefakty. Nie zmieniono
starych manifestów, tablic probabilistycznych ani przybliżeń. Nowe twierdzenia
są uniwersalne; proste wartości rozmiarów sprawdził kernel. Bez nowych testów
Sage i bez wykonywania całej taśmy samplera jako skończonego eksperymentu.

heap001 zachowuje błąd parsera i wtórne komunikaty sorry; przyjęty heap002
jest czysty. Pozostałe niepowodzenia były błędami elaboracji/składni lub
niezamkniętymi celami. Szczegóły, klasy i receipty: CHECKS, SELF_REVIEW,
CERTIFICATE_CLASSES_020E1 i KERNEL_QUEUE_020E1. Każda próba ma snapshot,
wrapper i stdout/stderr. Runtime `.build/pair_machine_020/arena_parser_001/`.

Commity źródeł:465dbef5 i15e05f22. Manifesty ARENA_PARSER_020E1_OUTPUTS
oraz ARENA_PARSER_020E1_RUNTIME zawierają dokładne piny/SHA.
Daybreak jest planowanym niezależnym recenzentem; odbioru nie uruchomiono.
Bez push/importu/tagu; T12.1/B20/paper/mainline bez zmian tej sesji.

## Mapa murów

| Warunek | Klasa / stan |
|---|---|
| Parser kodu w skończonych bankach | Obowiązek Q-RESC, KERNEL CLOSED w tym zakresie |
| Odtworzenie oryginalnego programu877 | Obowiązek, KERNEL CLOSED |
| Bezstratne kodowanie trwałej areny | Obowiązek pod modelem Word512, KERNEL |
| Bezpośredni interpreter adresowy i stos ramek | Obowiązek Q-RESC, OPEN — następny krok |
| Cały koszt, scratch, wejście/losowość, peak pamięci | Obowiązek Q-RESC, OPEN |
| Dotychczasowe EveryTape i J/P pod(M) | Zachowane; brak zmiany samplera/odniesienia |
| Źródłowa emisja kluczy i pokrycie(M), real Sign/PRG | Obowiązki Q-KEY/Q-BIND/Q-PRG, OPEN |
| A-QMT i primitive-bound Q-PRG | Założenia kryptograficzne, bez zmian |
| QROM: log/reprogramowanie, embedding, kolizje, kompozycja | Obowiązki kwantowe, OPEN |

Nie zmieniono nonce320, kierunku momentu, e=2^-47 ani D=(1+e)^q_s−1.
Nie konsumowano nowych wyników ROM. Wybrana kontynuacja i alternatywy
są w RESOURCES_020E_CONTINUATION_002.md.
