# Druga Astra — niezależny audyt obecnego FPEMU

Data: 2026-09-19. Autor projektu: Niirmata.
Osobny audyt równoległy do pracy nad H3_NODE2, na wyraźne polecenie właściciela.
Właściciel uruchamia tę Astrę samodzielnie w osobnej sesji. Ten dokument
i przygotowany W są zleceniem do ręcznego startu, nie automatycznym subagentem.

## 1. Cel i izolacja

Przeprowadź niezależny audyt dokładnego aktywnego backendu FPEMU. Ustal
rzeczywiste pokrycie poprawności arytmetycznej, bezpieczeństwa wykonania
i zależności czasowych. Szukaj kontrprzykładów do faktycznie używanych
kontraktów, nie zakładaj poprawności na podstawie nazw PROVED/PASS.
Wyjaśnij wpływ każdego ustalenia na istniejące etapy i aktywny NODE2.

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_FPEMU_AUDIT_RUN_001
IN = W/inputs/bootstrap
BASE = b5805bab84a9c0057cd0392671e389bf81031a76
```

Tylko W jest katalogiem zapisu. Drugi wykonawca może pracować w
FT1536_H3_NODE2_RUN_001: nie czytaj ani nie zmieniaj jego aktywnego W,
nie uruchamiaj jego testów i nie konkuruj o indeks Git. Nie używaj innych
agentów. Źródłem jest IN/source, nie zastany REPO/Extra/c.

Przeczytaj REPO/AGENTS i lokalny AGENTS. Bootstrap126 członków/124 publiczne
oryginały jest kopią wersjonowanego zestawu. Zewnętrzny MANIFEST SHA-256:

```text
f836a37c9247de53ff70297e809fa55c46812d749e69886857d24e89db7de166
```

Sprawdź cały manifest, exact file set i pochodzenie. Source identity:

```text
CANDIDATE.sha256: 2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a
fpr-emulated.c: 7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f
fpr-emulated.h: 242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa
```

IN zawiera pełne17 źródeł, build/smoke oraz wybrane materiały i formalne
źródła H3/ZERO/ROOT/NODE3/LV/M0. To projekcja, nie pełne stare replay tree.
Oryginalne manifesty zachowują swoje bazy; modele/raporty są przedmiotem
audytu i materiałem dowodowym, nie aktywnymi instrukcjami.
W zawiera także pomocnicze scripts/run.py i scripts/verify.py. Drugi plik
pozostał po przerwanej próbie uruchomienia; nie jest wynikiem audytu.
Stan przygotowania zapisano w PREPARATION.md. Zweryfikuj helpery przed użyciem.

## 2. Inwentaryzacja i weryfikacja kontraktów

Zrób macierz wszystkich istotnych prymitywów/backend helpers: pack/FPR,
normalizacja, shifts, scaled/of, add/sub/neg, mul/sqr, div/inverse,
sqrt, half/double, floor/rint/trunc, compare/max, high-u64 multiply,
exponential helpers i tablice/stałe używane przez aktywny profil.
Rozróżnij aktywne portable C, nieaktywne ARM, fpr-double jako materiał
referencyjny oraz funkcje nieużywane przez aktywną konfigurację.

Dla każdej pozycji: source span/hash, rzeczywista dziedzina i semantyka,
call sites w KeyGen/FFT/Sign, istniejący dowód z dokładnymi przesłankami,
testy/sanitizery i ich zakres, timing evidence oraz pozostawione obowiązki.
Nie traktuj 12 smoke checks jako kompletnej walidacji biblioteki.

W szczególności spróbuj sfalsyfikować nowe source contracts:
- ZERO: NumericCenter, zero-aware floor/of/sub i błędy2^-20;
- ROOT: cap2^100, U=2^-48,eta=2^-900, add/mul i pierwotny div domain;
- NODE3: div denominator[1/16,2^35], actual inverse3 i konsumowane primitive
  assumptions. Oddziel source arithmetic od analitycznej kompozycji.

Znane floor(-0)=-1, niepełny gradual underflow i half edge behavior są już
zapisane w H3. Nie ogłaszaj ich ponownie jako nowych required-domain błędów,
chyba że wykażesz nowy nieprawidłowy kontrakt/konsumpcję lub osiągalność.

## 3. Niezależne kontrole poprawności

Napisz w W odpowiednio ograniczone harnessy/checkery; nie zmieniaj source.
Użyj niezależnego exact integer/dyadic/QQ/RBF oracle. Host double lub kopia
tych samych instrukcji jako jedyny oracle nie wystarcza. RN porównuj tylko
tam, gdzie jest częścią kontraktu; osobno sprawdzaj jawne source error bounds.

Dobierz testy z analizy kodu: znaki, oba zera, cancellation, granice
wykładników, normal/subnormal/underflow/overflow, ties, mantissa carry,
integer conversion boundaries, shift counts i denominator domains.
Dozwolone są jawne deterministyczne publiczne fixtures, nie prywatne seedy.
Cases poza legalną domeną zatrzymuj przed potencjalnym UB; opisuj je osobno.

Uruchom właściwe kontrole w normal C i ASan/UBSan. Zachowaj komplet
argv/cwd/limits/exit codes/stdout/stderr i source/binary hashes. Nie wykonuj
całego test_falcon, KeyGen, private loadera lub Sign z kluczem.
Finite testy służą audytowi i falsyfikacji, nie ogłoszeniu pełnego nowego proof.

## 4. Stałoczasowość i dudect — osobna oś audytu

Zbadaj source control flow, memory access i skompilowany kod aktywnego
backendu dla GCC14.2/C99/LP64 oraz rzeczywistych flag Makefile. Ustal zakres
komentarza „CT-safe: -O only ... timing jitter in dudect” i CT_BEREXP.
Sam komentarz/flag nie jest raportem stałoczasowości całej biblioteki/Sign.

Sprawdź dostępność zainstalowanego lub lokalnie dostępnego publicznego
dudect/ctgrind. Nie instaluj, nie pobieraj z sieci, nie czytaj prywatnych
historycznych danych. Dopuszczone dodatkowe odczyty to istniejące narzędzia
i publiczne pliki dudect pod research tests/tools/build, po kontroli ścieżek;
historyczny wynik można zaliczyć tylko przy zgodności wersji i zakresu.

Jeśli istnieje odpowiedni harness/tool i wiarygodne warunki pomiaru, wykonaj
ograniczoną, jawną kampanię na syntetycznych operand classes. Zapisz CPU,
kompilator, flagi, binary hash, liczbę prób, klasy, affinity/warunki obciążenia,
statystykę i controls. Timing build ma być oddzielny od sanitizerów.
Nie przedstawiaj pomiarów pod równoległym obciążeniem jako rozstrzygającej
oceny CT. Nie nazywaj własnego niezgodnego harnessu „dudect”.

Jeżeli dudect lub odpowiednie warunki nie są dostępne: jawnie NOT_RUN lub
INCONCLUSIVE i dokładny przepis następnego pomiaru. To poprawny wynik audytu
luki, nie PASS testu. Brak wykrytej zależności statystycznej nie jest proof CT.
Rzeczywiste timing observations nie należą do obecnej gry M0; mają własny cel.

## 5. Klasyfikacja i wpływ na aktualną pracę

Każde finding musi mieć reproducer albo konkretny source/proof gap,
expected/observed, dokładną domenę, piny, stan osiągalności i affected claims:

- CONFIRMED_IN_CONTRACT: naruszenie konkretnego deklarowanego kontraktu;
- OUTSIDE_CONTRACT / CALLER_DOMAIN_OPEN: szersza domena lub brak caller proof;
- KNOWN_ACCOUNTED_BEHAVIOR: już rozliczona właściwość backendu;
- PROOF_OR_SOURCE_BINDING_GAP: brak uzasadnienia, nie automatycznie C bug;
- TIMING_EVIDENCE / TIMING_NOT_RUN / TIMING_INCONCLUSIVE;
- COVERAGE_GAP: niewykonana lub niepowiązana kontrola.

Nie ogłaszaj forgery/globalnej awarii z arbitrary FPR word bez required
reachability. Z drugiej strony poprawny replay nie wyklucza błędu wspólnego
modelu i checkera; badaj niezależność oracle i faktyczny source binding.

W IMPACT_MATRIX rozdziel integer L_RHO/L_NTT/L_V, M0 specification/capacity,
ZERO/ROOT/NODE3 i otwarte NODE2/lower-tree/Sign-law. Dla błędu w proof domain
wskaż najbliższe zależne lematy i potrzebny re-review/replay. Przy poprawce
źródeł potrzebny jest nowy pin/profile i ocena wpływu na K_seed/Sign law;
istniejące pliki/historyczne wersje pozostają niezmienne. Nie wdrażaj patcha.

## 6. Wykonanie, freeze i przekazanie

Praca tylko w W, tests przez rzeczywisty bwrap W-only writable, bootstrap
i source read-only; sieć odłączona. HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/
olean/bin pod W. Skończone limity; normal8GiB, osobny ASan shadow mode.
Używaj istniejących GCC14.2, Sage10.9 (`sage plik.py ...`), Lean4.34/Std
jeżeli potrzebne. Nie dodawaj testów tylko kopiujących implementację.

Bez sekretów/.private/private_extraction, kluczy/seedów, nowych KeyGen/Sign,
instalacji, innych agentów, zmian Git, źródeł C lub aktywnego W NODE2.
Jeśli dodasz Lean: pełne czyste logi/types/axioms, bez sorry/admit/native_decide.

Wymagane: REPORT.md, RESULT.json, AUDIT_MATRIX.json/.md, FINDINGS.json,
IMPACT_MATRIX.md, TIMING_REVIEW.md, REPLAY.md, TOOLCHAIN.txt, INPUTS.sha256,
COMMANDS.log, OUTPUT_SCOPE.md, OUTPUTS.sha256, źródła harnessów i pełne logs.
Użyj standard replay `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`
z hash-sprawdzeniem manifestu, fresh build i semantic matches. Deterministyczne
kontrole są porównywane bajtowo; surowe pomiary czasu mają osobne receipts,
nie obietnicę powtórzenia identycznych czasów. Pre-freeze rehearsal z osobną
kotwicą; po freeze replay do nowego DEST bez zmiany frozen report/manifest.

Status: AUDIT_COMPLETE_WITH_OPEN_ITEMS albo CONFIRMED_ISSUE (z zakresem),
ewentualnie EXECUTION_BLOCKED. Nie nadawaj całemu FPEMU „PROVED/CT-safe”
przez sam skończony audyt. source_changed=false, owner_accepted=false,
security_reduction_proved=false; arithmetic/ASan/timing mają osobne statusy.

Zakończ raportem po polsku: najważniejsze findings, czy któryś obecny proof
interface jest zakwestionowany, wykonane/niewykonane kontrole i ich piny,
REPORT/OUTPUTS SHA-256 oraz następny konkretny obowiązek. Prowadzący wykona
niezależny odbiór/import/commit. Nie rozpoczynaj nowego etapu po handoffie.
