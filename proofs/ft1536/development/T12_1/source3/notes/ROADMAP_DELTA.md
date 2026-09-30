# Rozwinięcie istniejącego T12.1 — decyzja2026-09-29

Właściciel po frozen A3 polecił kontynuować do pełnego source-bound wyniku
i wybrał kolejność **oba cele, najpierw M6**. To rozwinięcie wpisu T12.1
oraz jego zależności T02–T14, bez awansowania ich statusów.

1. Ostatni pakiet RUN_002: PARTIAL_PROOF, A3 złożone w referencyjnym modelu,
   niezależny odbiór nadal oczekiwany. Raportu/OUTPUTS nie zmieniać.
2. Nowa kontynuacja RUN_003: source-KeyGen→pełny M6, potem pełny C Sign/M7.
3. P02 arithmetic/real-error/caller-domain exports pozostają otwartymi
   zależnościami, zgodnie z jego PARTIAL. T03-B też nie dostarcza pełnego
   required-domain boundu. T5 osobny W pozostaje RO.
4. Pierwszy podetap: literalne source bindings i semantyka wymaganych
   pozytywnych/range gates oraz success path dla tej samej populacji kluczy.
   Rachunek rawBad hbLo/hbHi pozostaje osobnym jawnym ogniwem.

Zapis przygotowany we własnym W. Globalne STATE/CURRENT/ROADMAP i Git
aktualizuje koordynator; ten plik stanowi dokładne przekazanie decyzji.

## Postęp T12.1 / SOURCE_GATES_001

RUN_003 domknął lokalne source-refinement helpers, fpr_lt, skany768/1536,
końcowy return i stored-word real bounds oraz control fragment mandatory
call-before-break.17 modułów/218 audited exports/85 twierdzeń, clean Lean;
611 exact-Sage/C kontroli normal/UBSan/no-op i dwa wykryte mutanty.
Receipt: `run/SOURCE3_PROGRESS_RECEIPT.json`, SHA256
`e0c6ce832102bca8c8f78ffa1e3289663d93aae18c27a09b3725cadf7259553d`.

Status głównego T12.1 pozostaje PARTIAL_PROOF/WORKING. Callee execution
mandatory block jest parametrem, a typed views/Frame nie są jeszcze pełnym
source heap KeyGen. Nie zamknięto K/R z RUN_002 M6_BINDING_STATUS, nie ma
all-KeyGen delta ani pełnego source-bound C Sign. Następny krok:
kompozycja source-prefix/stable-recursion/sticky-bad i tej samej pamięci.

## Podetap T12.1: stable-binary (2026-09-29)

Właściciel zawęził najbliższy krok do `ft_stable_binary_inplace_keygen`
przed złożeniem bramki. W tym W przybył kernelowy parser+typed-memory model
całej struktury rekurencji dla `n=2^k`, `k≤8`, z dowodem sticky bad, ramy
i bez fallbacku przy finalnym clear oraz source-bound half/double.
Status **PARTIAL_PROOF**: `fpr_add/mul/div` nadal są jawnymi callbackami,
nie source execution aktywnych gałęzi C M0 (`FALCON_ASM_CORTEXM4=0`);
brak pełnego ABI/memory
bindingu. Następne w T12.1: uzupełnić ten typ, potem skomponować ze stable
top/reciprocal/leaf suffix i tą samą komórką `bad`. M6 i C Sign pozostają OPEN.
