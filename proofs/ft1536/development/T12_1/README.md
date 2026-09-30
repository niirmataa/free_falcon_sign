# T12.1 — małe kroki rozwoju

**Status: PREPARED_HANDOFF**, z osobnym stanem komponentów. Właściciel
2026-09-30 wybrał nowy katalog pracy oraz przeniesienie małych nowości,
których nie ma już w `stages`.

| Komponent | Stan przekazania |
|---|---|
| `source3` | **RECONCILED_AWAITING_WORKER_ACK** — pięć dopisków przeniesionych; następny krok: potwierdzenie tej samej sesji Astry |
| `run2` | PREPARED_HANDOFF, bez zmiany przy tym rozliczeniu |
| `t5` | PREPARED_HANDOFF, bez zmiany przy tym rozliczeniu |

Dokładne piny i okno writer Git dla Astry:
[source3/HANDOFF.md](source3/HANDOFF.md).
Przygotowanie i rozliczenie kopii nie jest potwierdzeniem ACTIVE za wykonawcę.

**Katalog i podział ról zatwierdzone przez właściciela:** worker po uzgodnieniu
z nim sam robi małe commity i push podczas pracy. Koordynator prowadzi odbiór,
import oraz końcowy commit/tag stages. `PREPARED_HANDOFF` dotyczy przekazania
aktywnej sesji; po przejęciu zgoda zastępuje jej historyczne „bez Git”.

Historyczna kontrola2026-09-30T02:43:37Z wykryła3 dopiski:
[HANDOFF_PENDING.json](HANDOFF_PENDING.json). Kolejna kontrola po zakończeniu
STABLE_BINARY_004 wykazała5; wszystkie przeniesiono i zweryfikowano w
[receipcie rozliczenia](source3/HANDOFF_RECONCILIATION_20260930_001.json).
`pending source3` nadal raportuje tę historyczną deltę wobec niezmienionego
`BASELINE.json`; jej rozliczenie sprawdzamy po receipcie, nie przez wyzerowanie
baseline. Przed potwierdzeniem przejęcia sprawdź ewentualne nowe dopiski.

## Układ

```text
run2/       nowe/zmienione źródła rodzica matematycznego
source3/    nowe/zmienione źródła kontynuacji źródłowej RUN_003
t5/         nowe/zmienione źródła T5
```

W każdym komponencie: `formal/` (Lean), `sage/`, `tools/original/`
(dotychczasowe skrypty), `notes/` (raporty/kontekst), `BASELINE.json`
(pochodzenie początkowych bajtów), `ARCHIVED_DEPENDENCIES.json`
(dokładne referencje do modułów już istniejących w stages).

Źródła identyczne z committed stages zostały pominięte w nowym drzewie.
Gdy taki moduł wymaga zmiany, jego nowa wersja trafia do lokalnego `formal/`.
Po przejęciu autor edytuje te pliki bezpośrednio, a kolejne zwykłe commity
zapisują diffy. `BASELINE.json` pozostaje historyczną proweniencją początku,
nie manifestem wymagającym aktualizacji przy każdej edycji.

## Przekazanie aktywnemu wykonawcy

1. Agent kończy bieżący krok w starym W i zapisuje handoff/job status.
2. Koordynator sprawdza dopiski od przygotowania kopii:

   ```sh
   python3 -B tools/ft1536_dev_sources.py pending source3
   ```

   Analogicznie `run2` i `t5`. Polecenie tylko raportuje zmiany. Nowe pliki
   i zmienione wersje są rozliczane jawnie, bez nadpisania zmian obu stron.
3. Właściciel przekazuje **tej samej sesji** nowe miejsce i właściwy TASK.
   Po potwierdzeniu przejęcia zmieniamy tutaj status na ACTIVE oraz żywy
   CURRENT. Do tego momentu za najnowsze wyniki odpowiada stary W.
4. Runner otrzymuje nowe ścieżki źródeł i osobny runtime `.build/`.
   `tools/original/` zachowuje oryginalne skrypty z dawnymi założeniami
   katalogowymi; nie jest jeszcze nowym skonfigurowanym launcherem.

Instrukcja commitów: [WORK_COMMITS](../../../../docs/onboarding/WORK_COMMITS.md).
Odbiór dotyczy konkretnego zakresu/commita; później `archive.py` i tag stages.

## Zależności i większe dane

`ARCHIVED_DEPENDENCIES.json` wiąże pominięte pliki ze ścieżką, SHA256
i obiektem Git. Można przygotować ignorowaną kopię małych źródeł do buildu:

```sh
python3 -B tools/ft1536_dev_sources.py materialize source3
```

Powstaje `source3/.build/formal/`; własne `formal/` ma pierwszeństwo nad
wersją archiwalną. Komenda nie buduje Lean ani pełnej closure bibliotek.
Wersje/toolchain i scope importów pochodzą z odpowiedniego TASK/receiptów.
Duży certyfikat ma generator/pin w `LARGE_ARTIFACTS.json`. Raw logs, cache
i frozen output poprzedników zachowano w dotychczasowych W.

Kopia źródeł nie oznacza nowego proofu/replayu ani niezależnego odbioru.
Wyniki i ograniczenia autorów są zapisane w zachowanych notatkach.
