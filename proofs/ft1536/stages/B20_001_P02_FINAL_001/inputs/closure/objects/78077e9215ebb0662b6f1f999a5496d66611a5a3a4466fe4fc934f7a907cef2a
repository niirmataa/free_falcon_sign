# Protokół wykonania, formalnego odbioru i lokalnych commitów — B20

Decyzja właściciela2026-09-22. Autor projektu Niirmata,Git `niirmataa`.
Obowiązuje dla nowego pakietu20 zadań i20 odpowiadających im weryfikacji.
Zlecenie przygotowania pakietu: [BATCH_20_REQUIREMENTS](../../../../docs/onboarding/BATCH_20_REQUIREMENTS.md).
Stare frozen zadania/raporty zachowują własne piny,zakresy i rzeczywiste tryby.

**Ostateczne polecenie właściciela: dotychczasowy workflow — praca w `work/`,
weryfikacja,zaakceptowany wynik do `stages/`,lokalny commit na `main`.**
REPO/CHECKOUT to istniejący `/home/footfalcon/free_falcon_sign`.
Każda rola korzysta ze swojego W. Nie tworzymy gałęzi/worktrees dla B20.
Roboczy postęp i handoff zapisujemy w W; nie ma obowiązkowych checkpointów
pośrednich ani importowania każdego kroku do archiwum.

## 1. Co stanowi ukończony dowód

Każdy TASK musi określić nazwane eksporty Lean z pełnymi typami:kwantyfikatory,
dziedzinę wejść,stan początkowy/końcowy,przesłanki,model programu/gry,obserwacje,
metrykę i kierunek porównania. Wymagany wynik jest formalnym twierdzeniem
sprawdzonym przez kernel,w dokładnie tej postaci i zakresie.

1. `PROVED` wymaga gotowego termu dowodowego i rzeczywistych instancji wszystkich
   przesłanek koniecznych do zadeklarowanego zastosowania.
2. Analiza tekstowa służy objaśnieniu. Rachunek Sage generuje certyfikaty,
   które mają wskazanego formalnego konsumenta. Testy C/mutacje wspierają
   kontrolę powiązania z kodem. Żaden z tych elementów sam nie zamyka TASK.
3. Historyczne `REVIEWED` o granicy mixed analytical/source/kernel nie jest
   automatycznie kompletną formalną przesłanką. TASK wymienia dług formalizacji
   i eksporty,które wolno rzeczywiście skonsumować.
4. Jeśli wynik dotyczy C,związek przypiętego kodu z formalną semantyką/modelami
   musi być objęty obowiązkami dowodowymi. Sam hash,czytanie linii lub zgodność
   kilku przykładów nie jest dowodem refinementu. Claim o modelu C i claim
   o skompilowanym programie mają jawne,różne zakresy.
5. Założenia kryptograficzne/platformowe mogą występować wyłącznie jako nazwane,
   jawnie opisane parametry twierdzenia warunkowego. Cel zadania,desired gap,
   poprawność symulatora lub source applicability nie mogą być przemycone
   jako założenie pod inną nazwą.
6. Brak lematu/instancji/domeny oznacza `PARTIAL_PROOF` lub `BLOCKED` z dokładnym
   missing type. Negatywny wynik lub kontrprzykład jest pełnoprawnym rezultatem.
   Nie wymusza się PROVED przez nowy gate,zmianę gry lub pominięcie przypadku.

**Obowiązkowy stos: SageMath + Lean4 + Mathlib.** Lean/Mathlib mają przypięte,
zgodne rewizje,source closure i receipt budowy; projekt dowodu przechodzi fresh
rebuild,typy/termy/aksjomaty eksportów są zachowane.
Bez sorry/admit/native_decide/Lean.ofReduceBool,aksjomatu celu lub ukrywania
ostrzeżeń. Standardowe aksjomaty biblioteki i wszystkie założenia wypisz jawnie.
Brak potrzebnej biblioteki oznacza blocker narzędziowy do rozwiązania w jawnie
przypiętym bootstrapie; nie zastępuj go ręcznym argumentem analitycznym.

## 2. Role i własność katalogów

- **Wykonawca Pxx:** buduje dowód,certyfikaty i frozen handoff; sam tworzy
  wynik we własnym W i przekazuje go do weryfikacji.
- **Recenzent Vxx:** ocenia odpowiadający Pxx,w osobnym W i kontekście,
  wykonuje fresh rebuild/replay i niezależne kontrole; oddaje raport z pinami.
- **Prowadzący/integrator:** utrzymuje kolejkę,piny zależności i kanoniczny main.
  Może go zastąpić inny model po jawnym handoffie. Historia czatu Astry nie
  jest zależnością wykonania.

Jeden aktywny worker na W,jeden writer wspólnego indeksu Git na main.
Recenzent nie jest wykonawcą ocenianego Pxx; modele i konteksty są jawne.
Domyślnie model recenzenta jest różny od autora. Każde doprecyzowanie właściciela
zapisz dosłownie z zakresem,nie zgaduj runtime ID lub modelu.

Nowa sesja czyta START_HERE,STATE i ten protokół raz. Przy kolejnym zadaniu
wystarczą własny TASK,odebrane wejścia i ostatni handoff; wspólne dokumenty
doczytuj przy zmianie zasad lub rzeczywistej potrzebie.
Sprawdź ownership,procesy i stan jobów. PID TUI lub plik lock sam nie rozstrzyga
aktywności. Gdy W ma już freeze,oddaj istniejący handoff; nie startuj drugiego
wykonania. Bez automatycznego relay/callback lub `opencode run --session`.

## 3. Katalogi i start zadania

Każdy TASK podaje DOSŁOWNIE:ID,ROADMAP_ID,REPO,BASE,BRANCH,CHECKOUT,W,IN,
OUTPUT_DIR,CHECKPOINT_PREFIX,FINAL_STAGE,VERIFIER_ID i wszystkie piny.
Katalogi znajdują się pod trwałym repo w `proofs/ft1536/work/B20_001/`.
Wszystkie40 ról mają `CHECKOUT=REPO` i `BRANCH=main`.
Praca i niezależny replay pozostają w ich W. Do stages trafia odebrany wynik.

- `IN`:readonly kopie przypiętych wejść z pełną closure manifestów.
- `run/`:nowe projekty/checkery/buildy i raw logs.
- `output/`:wynik autora lub recenzenta przygotowywany do freeze.
- `checkpoints/`:lokalne snapshoty kolejnych zakończonych kamieni milowych.
- `home/`, `cache/`, `tmp/`:środowisko procesu,wyłącznie na trwałym dysku.
- `CHECKOUT=REPO`:wspólny Git; W służy artefaktom danej roli.

Sprawdź exact set,hashy,duplikaty,symlinks/path escape i wszystkie transitive
inputs. Brakujący pin zależności daje `BLOCKED_INPUTS`; nie bierz żywego W
innego agenta. Weryfikator otrzymuje zamrożony output konkretnego Pxx wraz
z zewnętrznymi hashami REPORT/OUTPUTS i commitem,nie ogólny folder „latest”.

## 4. Rzeczywiste wykonanie i receipty

Autorytatywny rachunek: **`sage lemma.sage`**,standardowy preparser,ZZ/QQ,
rigorous balls/intervals z jawnymi endpointami/remainder i precyzją.
Właściwe formuły mają być w `.sage`. Python organizuje procesy/manifesty/logi;
nie zastępuje nowego rachunku. Formalny checker w Lean konsumuje certyfikaty
wymagane do zamknięcia twierdzenia.

Każdy job ma osobny nieistniejący DEST i zapisane:
- rzeczywisty pełny argv,cwd,toolchain/wersje,namespace mapping i limity;
- readonly snapshot uruchamianych źródeł oraz SHA przed i po wykonaniu;
- piny wejść,czas start/stop/elapsed,exit code i timeout/OOM;
- oddzielne raw stdout/stderr oraz hashe rzeczywiście wyprodukowanych wyników.

W-only/network-off sandbox. HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG i wszystkie cache
pod W; bez systemowego /tmp,/tmp/opencode/tmpfs dla pracy. Bounded single-worker
jobs,Lean-j1/-M2048 i normal8GiB jako punkt wyjścia; inne limity muszą być
uzasadnione i wpisane w TASK. ASan osobno z właściwym shadow allocation.
Timing campaign wyklucza równoległe proof jobs; harmonogram określa właściciel.

Po zmianie kodu powstaje nowa wersja i nowy run. Zachowaj kod/logi/output failed
attempt,nie tylko jego hash. W końcowym raporcie odwołuj się do finalnej wersji,
a historyczne próby opisuj osobno. Każdy cytowany hash musi zgadzać się z
odpowiednim źródłem,receiptem i manifestem. Same PASS/mtime nie dowodzą wykonania.

## 5. Cykl pracy wykonawcy Pxx

1. Zweryfikuj wejście,przeczytaj cel i zapisz plan formalnych lematów/dependencies.
2. Zbuduj najmniejsze formalne komponenty wraz z typami i konkretnymi instancjami.
3. Wygeneruj/przelicz potrzebne certyfikaty Sage i sprawdź ich formalne użycie.
4. Powiąż formalny model z przypiętym kodem zgodnie z zakresem TASK.
5. Wykonaj wymagane kontrole domen,negative cases,meaningful mutations/no-op.
6. Zapisuj źródła,wyniki prób i handoff w W. Plan/typy wejściowe są częścią
   pracy; nie wymagają osobnego checkpointu ani commita.
7. Przed freeze wykonaj własny fresh rebuild/replay z czystych źródeł.
8. Sprawdź spójność claim→Lean export→assumptions→source pin→execution→output.
9. Oddaj frozen handoff z REPORT/RESULT/CLAIM,source bindings,certificates,
   formal source,auditem aksjomatów,FAILED_ROUTES,INPUTS,OUTPUTS,TOOLCHAIN,
   COMMANDS/receipts,REPLAY i NEXT_INTERFACE. TASK doprecyzuje własne artefakty.
10. Zakończ joby,podaj source HEAD,hashy i stan W. `COMPLETE_FOR_REVIEW` jest
    handoffem autora; zaakceptowany zakres wynika dopiero z odbioru.

## 6. Cykl niezależnego odbioru Vxx

1. Zweryfikuj zewnętrzne piny Pxx i własność W. Autor/inputy są RO.
2. Odczytaj dokładne typy celów i cały łańcuch przesłanek. Dla każdego eksportu
   sprawdź,co rzeczywiście wykazał kernel oraz skąd pochodzą instancje założeń.
3. Przygotuj własny seed wyłącznie z sealed źródeł i input closure. Bez
   autorowych bin/olean/pyc/cache i bez skopiowanych wyników jako nowych outputs.
4. Manifest sprawdź przed utworzeniem DEST. Usuń WSZYSTKIE produkty regeneracji,
   także semantic-only,PDF auxiliaries i wyniki opcjonalnych etapów.
5. Fresh rebuild Lean i formalnych checkerów; niezależne Sage dla kluczowych
   liczb/granic; wymagane C controls/source refinement checks i mutations.
6. Sprawdź faktyczne exit/logs/producentów i każdy semantic match. Brak producenta,
   no-op lub jego failure ma zostać wykryty. Opcjonalny krok/PDF nie może być
   przemycony jako potwierdzony przez węższy bool PASS runnera.
7. Transport-only adapter/normalizacja np. ścieżki w JSON wymaga jawnego diffu,
   pinów,wyjaśnienia i osobnej oceny. Zachowaj pierwotny mismatch/exit.
8. Dopasuj evidence do claimu. Zmiana gry,dodanie desired conclusion do premises,
   skończone fixtures zamiast uniform theorem lub analityczny substytut są
   podstawą `CHANGES_REQUIRED`,nie dopisania brakującego dowodu za autora.
9. Oddaj REVIEW,REVIEW_RESULT,CHECKLIST,INTEGRITY,NUMERIC/REPLAY/SOURCE checks,
   pełne logs/receipts,failed versions i REVIEW_OUTPUTS. Sprawdź internal binding
    przed podaniem zewnętrznych hashy; zakończ joby. Archiwizacja/commit po odbiorze.

Werdykty:PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL / REPLAY_FAIL /
EXECUTION_BLOCKED. PASS wymaga pełnego formalnego uzasadnienia zadeklarowanego
scope; hash match sam nie wystarcza. PARTIAL może być odebrany jako PARTIAL,
ale nie zamyka zależnego celu,który potrzebuje brakującego lematu.

## 7. Lokalne commity agentów — zgodnie ze schematem repo

**W → review → zaakceptowane stages → lokalny commit na main.**
To ostateczne doprecyzowanie wcześniejszej prośby o commity agentów.
Autor i recenzent mogą sami wykonać import/commit odebranego zakresu jako
niirmataa,gdy prowadzący przekaże im ten krok. Domyślnie robi to prowadzący
jak dotychczas. Zawsze jeden writer; bez gałęzi/worktrees i merge dla zadań.

Tożsamość już zatwierdzona w repo:
`niirmataa <245027293+niirmataa@users.noreply.github.com>` jako author i committer.
Ustawiaj ją per-komenda,bez zmiany globalnej konfiguracji.

`work/` jest ignorowany przez Git i przechowuje robocze wersje,logi i handoff.
Po zaakceptowaniu zakresu importujesz wynik autora i odbiór przez `archive.py`
do `stages/<ID>_FINAL_001`,`catalog/`,content-addressed `objects/` w REPO.
Wystarczy jeden lokalny commit odebranej pary. PARTIAL/BLOCKED/kontrprzykład
może być odebranym wynikiem,ale zachowuje ten status i otwarte obowiązki.
Przy CHANGES_REQUIRED autor poprawia nową wersję w W; stare próby i recenzje
zostają zachowane jako historia. Brak odbioru oznacza brak importu B20 do stages.

Przed KAŻDYM commitem:
1. `git status --short --branch`,diff,ostatnie commity i staging we wspólnym
    CHECKOUT; sprawdź main,piny źródła i przejęcie roli piszącej Git.
2. Zweryfikuj manifesty,scopes i przypięte dane. Użyj archive.py do importu/
   weryfikacji checkpointu; sprawdź exact staged bytes.
3. `git add -- "${ALLOWLIST[@]}"` tylko dla własnych ścieżek. Ignorowane
   logi dodawaj `-f` wyłącznie z dokładnej listy sealed members,nie całego W.
4. Zachowaj obcy staging bez reset/stash. Przy konflikcie ownership zatrzymaj
   commit; przy znanych cudzych staged files użyj exact `commit --only`.
5. Sprawdź whitespace nowych własnych plików. Historycznych przypiętych bajtów
   nie reformatuj dla kosmetycznego PASS; udokumentuj wyjątek.
6. Commit:

```sh
GIT_AUTHOR_NAME=niirmataa \
GIT_AUTHOR_EMAIL=245027293+niirmataa@users.noreply.github.com \
GIT_COMMITTER_NAME=niirmataa \
GIT_COMMITTER_EMAIL=245027293+niirmataa@users.noreply.github.com \
git -C "$CHECKOUT" commit -m "proof($TASK_ID): archive reviewed scope"
```

Recenzent stosuje prefiks `review(...)`. Podaj pełny HEAD w HANDOFF i sprawdź
końcowy status. Bez amend/rebase/reset cudzej historii,force-push,pomijania
hooks lub automatycznego push. Żadnych sekretów,cache,bin/olean/pyc w commicie.

Po odbiorze prowadzący aktualizuje STATUS/STATE/ROADMAP i piny dla następnego
zadania w tym samym main. Integracja produkcji i publikacja mają osobne
decyzje; bramka S01 obowiązuje.

## 8. Wznowienie i koniec limitu modelu

Przed przekazaniem pracy aktualizuj lokalny HANDOFF w W:ID/model/kontekst,source HEAD,
input pins,completed exports,missing types,ostatni receipt,failed routes,
stan jobów oraz dokładny następny krok. Zachowaj źródła i raw journal w W.
Nowy model wznawia z tych plików; zmiana sesji nie wymaga wcześniejszego
importu nieodebranej pracy do stages ani commita.

OWNER_GUIDE i INDEX pakietu wskażą zadania READY/BLOCKED,pary Pxx/Vxx i
zależności. Następny prowadzący ma móc przejąć projekt z tych plików i Git,
bez pamięci poprzedniej sesji Astry. Zmiana modelu nie zmienia pinu,celu,
kryterium formalnego lub historii niepowodzeń.
