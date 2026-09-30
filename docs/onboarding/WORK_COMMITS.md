# Małe commity pracy i odebrane etapy

Decyzja właściciela **2026-09-30**: normalne, małe commity rzeczywistej pracy
już od `work/`, publikowane na bieżąco na GitHub. Etap jest zbyt duży, aby
czekać z historią Git na końcowy freeze, verify i stages. Ta decyzja uzupełnia
wcześniejszy workflow odbioru. Doprecyzował: **nowy katalog**, przenieść
nowości, pominąć identyczne źródła już obecne w stages i zachować bieżącą
pracę aktywnego agenta. ROADMAP: T12.1/T5. Repo: `free_falcon_sign`, gałąź
`main`, jeden writer Git.

## Codzienny rytm

1. Autor kończy mały logiczny kawałek i zapisuje pliki: np. faktoryzację MGF,
   lemat pamięci, generator certyfikatu albo udokumentowaną nieudaną próbę.
2. Koordynator lub właściciel przegląda diff i dodaje **dokładne pliki**.
   Wykonawca z TASK „bez Git” przekazuje listę plików koordynatorowi.
3. Zwykły commit na main, np. `proof(T12.1): factor the 1535-block moment`.
   W treści: zakres zmiany, wykonane sprawdzenia albo `not run`, otwarte typy.
4. Push tego małego commita na `origin/main`. Właściciel zezwolił na taki
   bieżący rytm dla pracy projektu; nie potrzeba osobnego odbioru stages.

Commit po logicznym kroku i przed końcem sesji, a nie po każdym wywołaniu
narzędzia. Nie ma obowiązkowego prefiksu `wip` ani obowiązkowego pełnego
replayu całego etapu przed zapisaniem pracy. Błąd, szkic i kontrprzykład też
mają historię; opis commita podaje ich rzeczywisty stan.

```sh
# W to komponent nowego katalogu development/T12_1, po handoffie.
git status --short --branch
git diff -- "$W/formal/Run2/ConvStruct.lean"
git add -- "$W/formal/Run2/ConvStruct.lean"
git diff --cached --stat
git diff --cached --check
git commit --only -m 'proof(T12.1): factor the 1535-block moment' -- "$W/formal/Run2/ConvStruct.lean"
git push origin main
```

To przykład wyboru pliku, nie potwierdzenie jego obecności w każdym W.
Przy cudzym stagingu używaj exact pathspecs/`--only`; przy częściowym stagingu
jednego pliku sprawdź cały indeks i zachowaj wybrane hunki. Jeden writer
obsługuje Git; pozostali autorzy kontynuują pracę w swoich W.

## Nowe miejsce pracy

**`proofs/ft1536/development/T12_1/`**, komponenty `run2/`, `source3/`, `t5/`.
Tam trafiają małe nowe/zmienione źródła Lean/Sage, narzędzia i opis postępu.
Każdy kolejny krok powstaje bezpośrednio w tym katalogu po przejęciu przez
wykonawcę. Nowe zadania mogą dostać analogiczny katalog w `development/`.

Całe historyczne `work/` pozostaje ignorowane. Istniejący hook nadal blokuje
przypadkowe dodanie go do Git. `.build`, `.lake`, `.olean`, `.so`, cache,
HOME/TMPDIR i surowe kampanie są poza historią źródeł. W nowym katalogu
obowiązuje zwykłe `git add` wybranych plików, bez `-f`.

Przy pierwszym przeniesieniu porównujemy zawartość z committed `stages`
po obiektach Git i potwierdzamy dokładne bajty. Identyczny plik dostaje
referencję w `ARCHIVED_DEPENDENCIES.json`, a nie kolejną kopię w commicie.
Nowa/zmieniona wersja trafia do `formal/`, `sage/` lub `tools/original/`.
Źródła większe niż8 MiB są podczas przygotowania pomijane i wymienione
jawnie jako duże artefakty. To selekcja przy migracji, nie nowa bramka review.

## Aktywny agent: przekazanie na granicy kroku

Nowy katalog ma początkowo status **PREPARED_HANDOFF**. Autor kończy obecny
krok w swoim dotychczasowym W. Koordynator kopiuje źródła read-only, zapisuje
SHA256 i pochodzenie; starych plików nie przenosi ani nie usuwa.

Przed przełączeniem właściciel odbiera handoff i rozlicza późniejsze dopiski:

```sh
python3 -B tools/ft1536_dev_sources.py pending source3
```

Analogicznie dla `run2`/`t5`. Wynik jest listą zmian, bez automatycznego
scalania. Dopiero po ich przeniesieniu i potwierdzeniu przez wykonawcę nowy
katalog staje się ACTIVE. Runnery muszą wtedy dostać nowe source/runtime
paths. Szczegóły: [CURRENT_DEVELOPMENT](../../proofs/ft1536/CURRENT_DEVELOPMENT.md).

## Duże wyniki

`proofs/ft1536/development/T12_1/LARGE_ARTIFACTS.json` wiąże duże pliki z SHA256,
rozmiarem, generatorem i sposobem odtworzenia. Przykład: wygenerowany
`CountsFoldCertificate.lean` ma ponad 100 MiB; zwykłym źródłem w Git jest
jego generator Sage. Sam certyfikat pozostaje poza Git.

- Dane odtwarzalne: commit generatora, parametrów i pinu oczekiwanego wyniku.
  Pobranie źródeł z Git i generacja odtwarza potrzebny artefakt; zgodność SHA
  sprawdzamy przed użyciem. Generacja sama nie jest weryfikacją dowodu.
- Dane nieodtwarzalne (np. historyczne pomiary): zachowujemy dokładne bajty
  w wersjonowanym magazynie/niezmiennym snapshotcie oraz manifest w Git.
  Miejsce odzyskiwania musi być zapisane przy konkretnym zbiorze. Sam hash
  nie jest kopią zapasową. Wybór i uruchomienie dodatkowego magazynu pozostaje
  osobnym krokiem; ta zmiana nie twierdzi, że surowe dane są już na GitHub.
- Cache kompilacji: odtwarzamy z przypiętych źródeł i toolchainu.

Istniejący `backup_work.sh` jest lokalnym mirrorem z `rsync --delete`.
Nie zapewnia odzyskania starszych bajtów po ich nadpisaniu. Nie używamy go
jako zamiennika historii Git ani wersjonowanego magazynu artefaktów.

## Odbiór i tag

Po ukończeniu zakresu: freeze → niezależny review → import przez `archive.py`
→ checkpoint stages na main. Dalej obowiązują piny i wymagania B20.
Na **commicie odebranego checkpointu** tworzymy tag annotowany, np.:

```sh
git tag -a 'ft1536/T12.1/RUN_003/reviewed-001' CHECKPOINT_COMMIT \
  -m 'Scoped review: STAGE_ID; REVIEW_ID; PARTIAL_PROOF; report/manifest pins in catalog'
git push origin main 'refs/tags/ft1536/T12.1/RUN_003/reviewed-001'
```

Wartości zastępujemy rzeczywistymi ID i statusem. Tag identyfikuje dokładny
zakres recenzji, także PARTIAL; wcześniejsze zwykłe commity już są na GitHub.
Tagi są nowe i nieruchome; korekta dostaje kolejny commit i kolejny tag.

## Pierwsze włączenie istniejącej pracy

Dzisiejszy stan to **pierwszy source baseline nowości względem stages**,
nie odtworzona wstecznie historia powstawania. Commitujemy go w osobnych
częściach: nowości rodzica RUN_002, kontynuacja RUN_003, T5. Kolejne kroki
to zwykłe małe diffy po przejęciu nowego katalogu przez wykonawcę.
Raporty i statusy autora zachowują swoją treść; publikacja źródeł nie jest
niezależnym odbiorem ani zamknięciem brakujących typów.
