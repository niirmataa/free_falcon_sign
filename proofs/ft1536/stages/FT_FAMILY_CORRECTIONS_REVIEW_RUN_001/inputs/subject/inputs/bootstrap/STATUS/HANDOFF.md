# Mały kontekst, jeden wykonawca, odtwarzalny handoff

## Role i bezpieczne wznowienie

Każdy handoff podaje również `ROADMAP_ID` z [rejestru zadań](ROADMAP.md).
Aktualne IID_RETRY_COMPOSITION odpowiada T01. Nowy TASK rozwija wpis planu;
nie zmienia celu końcowego ani zależności bez zapisanego uzasadnienia.

**Prowadzący** przygotowuje zadania i prompty odbioru oraz koordynuje archiwum
i Git. **Wykonawca** pracuje w przydzielonym W i oddaje frozen handoff; bez
Git, jeśli TASK tak stanowi. **Niezależny recenzent** czyta przypiętą kopię,
weryfikuje argument, wykonuje replay i zapisuje kontrole we własnym W.
Role, modele i katalogi muszą być jawne.

**Aktualizacja właściciela2026-09-22:** w bieżącym podziale ten prowadzący
przygotowuje zadania i prompty weryfikacyjne. Odbiór matematyczny i replay
realizuje **inny niezależny model wybrany przez właściciela**. Procedura odbioru
poniżej jest instrukcją dla tego recenzenta, nie automatycznym działaniem
prowadzącego. Handoff autora nie awansuje statusu do REVIEWED.

Po przekazaniu przez właściciela zakończonego niezależnego odbioru prowadzący
wiąże jego zewnętrzne piny z raportem/receiptami, importuje niezmienny pakiet,
archiwizuje evidence i aktualizuje REVIEWED/Git w dokładnym scope recenzenta.
To kontrola integralności archiwizacji, nie ponowny własny odbiór matematyczny
lub automatyczne powtórzenie replayu. Raport recenzenta pozostaje przypięty,
a tożsamość modelu nie jest zgadywana, jeśli nie została podana.

Przed wznowieniem sprawdź task ID/piny, repo/branch, stan W i wykonawców.
PID żyjącego TUI nie dowodzi aktywnego inference; istniejący executor.lock
nie dowodzi sam braku lub obecności workera. Porównaj procesy, aktualne logi
i polecenie właściciela. Przy niejasności nie uruchamiaj drugiego workera.
Nie resetuj W lub indeksu. Zachowaj failed attempts.

**OpenCode pułapka:** `run --session` rozpoczyna wykonanie modelu; nie jest
wklejeniem tekstu do istniejącego okna. W1.x osobne procesy mogą mieć wspólną
bazę bez wspólnego live event stream. W1.x i2.x mogą posiadać kopie tych samych
session ID. Nie wysyłaj przez domyślne PATH ani automatyczny callback.
Najprostszy handoff: plik w repo + właściciel przekazuje go w istniejącym oknie.

## Protokół nowego, małego kontekstu

1. Dotychczasowy wykonawca zapisuje poniższy HANDOFF i zatrzymuje swoje joby
   lub kończy freeze. Podaje właścicielowi, że można przejąć W.
2. Prowadzący potwierdza brak nakładającego się wykonania. Nowa sesja nie
   startuje równolegle „na wszelki wypadek”.
3. Nowy model czyta AGENTS, START_HERE, STATE, konkretny HANDOFF i TASK.
   Nie importuje całej historii czatu. Weryfikuje wskazane hashes samodzielnie.
4. Czyta wyłącznie potrzebne dependencies: najpierw CLAIM/certificate/interfaces,
   później proof source i kod. Wybiera następny niedomknięty krok z HANDOFF.
5. Kończąc turę/etap aktualizuje własny handoff. STATE aktualizuje prowadzący
   po faktycznym odbiorze, nie na podstawie samego planu.

Nie obiecuj konkretnej oszczędności limitu: zależy od providera/modelu/cache.
Krótki packet usuwa konieczność przesyłania około900k tokenów starego czatu.
Nie zmieniaj modelu/variant ani nie uruchamiaj innej sesji bez wyboru właściciela.

## Szablon HANDOFF.md w roboczym W

```text
TASK_ID / rola / autor / czas UTC:
REPO / branch / HEAD / TASK path + SHA / bootstrap SHA:
W / status: IN_PROGRESS | BLOCKED | FROZEN_AWAITING_REVIEW
Czy pracuje wykonawca lub job? Dokładne PID/service, jeżeli aktualne:
Ostatni ukończony krok i dowód wykonania (receipt/log/hash):
Co faktycznie PROVED / tylko checked / tylko proposed:
Otwarte przesłanki i minimalny missing type:
Zmodyfikowane pliki oraz pliki nienależące do zadania:
Failed routes/errors i gdzie zachowane:
Następny konkretny krok; potrzebne dokumenty (krótka lista):
Komendy uruchomione + exit/status; joby niedokończone:
Czego NIE uruchamiać ponownie / które bajty frozen:
REPORT SHA / OUTPUTS SHA (tylko po freeze):
Zakończyłem swoje obliczenia: TAK/NIE.
```

Handoff nie zastępuje pełnych logów. Bez sekretów/kluczy/tokenów dostępu.
Po freeze dopiski wyłącznie w nowym niezapieczętowanym katalogu pod W;
nie zmieniaj frozen raportów/manifestów. Wszelkie `tmp` w ścieżkach oznaczają
wyłącznie jawny podkatalog trwałego W, nigdy systemowy `/tmp`.

## Odbiór i lokalny Git

1. Otrzymaj jednoznaczny koniec pracy, REPORT/OUTPUTS SHA spoza pakietu.
2. Sprawdź scope/status/piny/source identity. Użyj `archive.py import`.
3. Wykonaj wymagany fresh replay w trwałym replay-work oraz niezależny review
   matematyczny. PASS hashów sam nie dowodzi twierdzenia.
4. Zachowaj pełne receipts, failed routes, scope flags i granicę formalizacji.
5. Zaktualizuj indeks/STATE, sprawdź dokładne staged bytes, osobny lokalny commit.
   Nie publikuj przy obowiązującej blokadzie właściciela.

Przy standardowym pakiecie (zmienne muszą wskazywać nowe, zweryfikowane dane):

```sh
python3 -B proofs/ft1536/tools/archive.py import "$W" --manifest-sha "$OUTPUTS_SHA" --report-sha "$REPORT_SHA" --replay standard
python3 -B proofs/ft1536/tools/archive.py replay "$STAGE" --run maintainer-replay-001 --timeout 1800 --hide-originals
python3 -B proofs/ft1536/tools/archive.py verify "$STAGE"
python3 -B tools/verify_ft1536_checkpoint_index.py "$STAGE" "$VALIDATION_NAME"
```

Te polecenia są wzorcem, nie instrukcją powtarzania zakończonych stages.
Pakiet dokumentacyjny może mieć replay=none z jawnymi scoped checks.
work/ jest ignorowany; ważne ukończone prace zachowujemy w stages/validation,
także PARTIAL/counterexample/review-changes-required. Cały projekt ma główne .git.

## Dokumenty żywe a niezmienne

- Żywe indeksy: START_HERE, STATE, PROOF_MAP, HANDOFF, CURRENT_TASK, README.
- Niezmienne wyniki: stages, objects, przypięte background/documents, frozen
  validation/provenance receipts. Koryguj przez nowy checkpoint i nową recenzję.
- Aktualizuj STATE po każdej decyzji o publikacji, zakończeniu/uruchomieniu etapu,
  zmianie single-writer ownership lub kampanii. Podaj czas obserwacji.
- Historyczny task path z Dokumenty może mieć identyczną kopię w repo;
  sprawdź SHA i używaj kopii repo bez rozszerzania dostępu do innych katalogów.
