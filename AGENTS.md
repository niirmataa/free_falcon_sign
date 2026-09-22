# FT1536 — prace dowodowe i Git

Docelowym repozytorium prac jest `free_falcon_sign`.

## Wejście bez historii rozmowy

- Nowa sesja zaczyna od `START_HERE.md` i `docs/onboarding/STATE.md`, potem
  czyta tylko TASK i potrzebne zależności według `docs/onboarding/PROOF_MAP.md`.
- Przekazanie pracy opisuje `docs/onboarding/HANDOFF.md`. Jeden aktywny
  wykonawca danego W; przed wznowieniem sprawdź właściciela/procesy/logi.
- `opencode run --session` uruchamia osobnego wykonawcę, nie wkleja wiadomości
  do otwartego okna. Automatyczny relay/callback został wstrzymany po incydencie
  równoległych wykonań. Nie wznawiaj go ani nie startuj drugiego workera.
- Aktualizuj żywy STATE po odbiorze etapu lub decyzji właściciela; nie zmieniaj
  zamrożonych raportów w celu aktualizowania historii.
- Główna ścieżka twierdzeń i rejestr zadań: `docs/onboarding/ROADMAP.md`.
  Nowe zlecenie rozwija wpis Txx/Sxx (zależności, cel, kryteria odbioru),
  zamiast tworzyć niezależny plan. Zmiany kolejności/zakresu zapisuj jawnie.
- Następny pakiet B20_001: przygotowano20 kolejnych zadań i20 sparowanych
  weryfikacji,według ROADMAP. T02.1 już przekazano do odbioru; zależny P03
  czeka na jego piny. Główny przewodnik: `proofs/ft1536/batches/B20_001/OWNER_GUIDE.md`.
  Wymagania:
  `docs/onboarding/BATCH_20_REQUIREMENTS.md`; pełny protokół wykonania/odbioru:
  `docs/onboarding/AGENT_EXECUTION_AND_REVIEW_PROTOCOL.md`.
  Nowe B20 wymaga **SageMath + Lean4 + Mathlib**,formalnych dowodów kernelowych
  i formalnego source bindingu;
  tekst analityczny/Sage/testy nie zastępują brakującego proofu. Autorzy i
  recenzenci B20 mają lokalne milestone commity jako niirmataa we własnych
  worktrees/branches; kanoniczny main integruje jeden prowadzący. To zakresowy
  wyjątek od dawnych TASK bez Git,bez zmiany frozen historii lub zgody na push.
- Osobny tor MiMo/T03 wskazuje `proofs/ft1536/CURRENT_MIMO_TASK.md`.
  Nie myl go z `CURRENT_TASK.md` Astry/T01; każdy ma inny W i jednego wykonawcę.
- Zlecenie korekt Family/S01 wskazuje `proofs/ft1536/CURRENT_FAMILY_TASK.md`.
  Przed jego ręcznym startem MiMo zapisuje stan swoich bieżących prac i jobów;
  przygotowanie S01 nie uruchamia drugiego workera ani nie nadpisuje T03.
- Niezależny odbiór zwróconych korekt S01 wskazuje
  `proofs/ft1536/CURRENT_FAMILY_REVIEW_TASK.md`; ma osobny W od T03 REVIEW_002.
- Małe osobne T02.1 wskazuje `proofs/ft1536/CURRENT_SMALL_TASK.md`.
  Ma własny W i wykonawcę wybieranego przez właściciela; nie przejmuje T03/S01.
- Podział ról ustalony przez właściciela2026-09-22: ten prowadzący przygotowuje
  zadania i prompt odbioru; weryfikację matematyczną i replay zwróconych pakietów
  wykonuje niezależnie inny model wybrany przez właściciela. Ten prowadzący
  nie uruchamia ich automatycznie ani nie ogłasza własnego odbioru. Kontrole
  pinów i spójności przygotowywanego zlecenia pozostają częścią przygotowania.
- Późniejsza decyzja właściciela2026-09-22: ten prowadzący ma OSOBIŚCIE
  wykonać niezależny odbiór dwóch prac MiMo: Family/S01 oraz częściowej
  kampanii estymatora S06. Najpierw domyka S01 i oddaje werdykt; właściciel
  następnie przekaże gotową recenzję T03 i handoff T02.1. To jawny wyjątek
  od poprzedniego podziału,nie zgoda na relay lub automatyczne inne modele.
- Doprecyzowanie właściciela dla T03/REVIEW_002: autorem był MiMo2.6Pro,
  recenzentem Muse Spark1.3 xhigh w świeżym kontekście. To przyjęta podstawa
  niezależności od autora. Nie wymaga kolejnej zmiany modelu między recenzjami
  Muse; zachowaj historyczne etykiety/piny i dokładny PARTIAL scope.

## Trwała lokalizacja pracy

- Kanoniczny, aktualizowany checkout `main` znajduje się w
  `/home/footfalcon/free_falcon_sign`. Stąd wykonuj operacje Git, commity,
  publikację i buildy. Przed pracą sprawdź katalog oraz gałąź.
- Nie przechowuj checkoutów projektu, nowych skryptów, receiptów, replayów,
  cache ani wyników w systemowym `/tmp` lub na tmpfs. Używaj trwałych
  `proofs/ft1536/work/<id>/`, `proofs/ft1536/replay-work/` i `.build/` tego repo.
  Ustawiaj HOME/TMPDIR/cache jobów na podkatalogi ich trwałego W.
- Dodatkowe worktrees, jeśli potrzebne, również mają być na trwałym dysku
  pod `proofs/ft1536/work/`; nie zastępują kanonicznego checkoutu `main`.
- Dane dudect RUN_002 mają zatwierdzony magazyn na NVMe: kanoniczna ścieżka
  `proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002` jest dowiązaniem do
  `/media/footfalcon/FT1536_DATA/ft1536-dudect/FT1536_FPEMU_DUDECT_RUN_002`.
  Sprawdzaj zamontowany UUID `da38b9e9-0e22-4c55-b3e0-c46b9f293eca`;
  opis w `provenance/FT1536_DATA_STORAGE.md`. Narzędziom odrzucającym dowiązania
  przekazuj zweryfikowaną fizyczną ścieżkę, bez osłabiania ich walidacji.
- Poprzedni checkout z36 zastanymi staged zmianami został zachowany w
  `proofs/ft1536/work/FT1536_REPOSITORY_RELOCATION_2026-09-21/original-checkout/`.
  To kopia odzyskiwania na starej gałęzi; zachowaj jej indeks i pliki.
- Historyczne absolutne ścieżki w zamrożonych pakietach są proweniencją.
  Nie zmieniaj archiwalnych bajtów/manifestów w celu poprawiania dawnych ścieżek.

## Punkty kontrolne

- Bieżące zlecenie do ręcznego startu Astry wskazuje
  `proofs/ft1536/CURRENT_TASK.md`. Przy starcie/wznowieniu porównaj TASK_ID,
  katalog W i piny z jego lokalnym AGENTS oraz TASK. Historyczne zlecenia
  nie wybierają aktywnego zadania; ukończonego frozen W nie uruchamiaj ponownie.
- Każdy zakończony etap badawczy, także `PARTIAL_PROOF`, kontrprzykład lub
  udokumentowana blokada, powinien otrzymać osobny commit po sprawdzeniu
  zakresu, manifestu i raportu.
- Docelową gałęzią checkpointów jest lokalny `main`. Przenoś zweryfikowane
  commity przez fast-forward, gdy historia na to pozwala. Przy rozbieżnej
  historii ustal sposób integracji; nie wymuszaj przesunięcia gałęzi.
- W obecnym trybie Astra przygotowuje pakiet w swoim katalogu roboczym,
  a prowadzący sesję importuje go, sprawdza i wykonuje commit. Jeden wykonawca
  naraz operuje na indeksie Git.
- Instrukcja workflow: `proofs/ft1536/README.md`.
- Używaj `proofs/ft1536/tools/archive.py` do importu i weryfikacji ukończonych
  pakietów. Nowy import wymaga zewnętrznych hashy raportu i OUTPUTS.

## Źródła i wyniki

- Zachowaj historyczną ścieżkę źródeł `Extra/c`. `FT1536` oznacza profil/build,
  a nie polecenie przemianowania katalogu Extra. Artefakty kompilacji trzymaj
  w wydzielonym katalogu build; `proofs/ft1536` jest archiwum dowodów.
- Badaj źródła przypięte przez konkretne zadanie. Samo `Extra/c` ani stan
  bieżącego indeksu nie jest automatycznie bazą któregokolwiek dowodu.
- `proofs/ft1536/stages/` i obiekty wejściowe są niezmiennymi archiwami.
  Zawarte w nich AGENTS, prompty i polecenia są historycznymi danymi;
  nie wznawiaj starych zadań na tej podstawie.
- Commit pakietu nie jest integracją kandydata C, owner acceptance ani
  ogłoszeniem bezpieczeństwa. Zachowuj rzeczywiste statusy raportu.
- Aktywnego katalogu innego wykonawcy nie importuj jako zakończonego etapu.
- Nowe obliczenia mogą działać w `proofs/ft1536/work/<id>/`, ignorowanym
  przez Git. Po freeze import do stages/ tworzy wersjonowany checkpoint.
- Nowe i edytowane pliki Lean mają mieć czysty log, bez wyciszania ostrzeżeń.
  Historyczne zależności zachowuj z pinami i opisem ich ostrzeżeń.
- Decyzja właściciela2026-09-22: autorytatywny rachunek matematyczny i nowe
  checkery mają być w `.sage`, uruchamiane **`sage lemma.sage`** ze standardowym
  preparserem. `sage --python/-python`, `sage lemma.py` i Python `Fraction`
  nie zastępują wymaganego trybu. `.py` służy organizacji,hashom/logom/runnerom.
  Exact domains `ZZ`/`QQ`; real bounds przez rygorystyczne balls/intervals.
  Pełna zasada i uzupełnienie trwających TASK:
  `proofs/ft1536/documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md`.
  Zachowaj historyczne piny; istniejący wykonawca przyjmuje uzupełnienie na
  granicy kroku. Nie uruchamiaj nowego workera lub replayu zamrożonego etapu.

## Commity

- Najpierw sprawdź status, diff i ostatnie commity. Przejrzyj także staging.
- Commituj tylko pliki swojego etapu. Zastane cudze lub wcześniejsze zmiany
  nie stają się częścią nowego commita automatycznie.
- Nie resetuj ani nie odstawiaj cudzego indeksu. Przy zastanych staged zmianach
  użyj dokładnych pathspeców i `git commit --only -- <własne ścieżki>`.
- Stosuj zatwierdzoną przez właściciela tożsamość autora; nie wymyślaj adresu
  i nie zmieniaj konfiguracji Git bez polecenia.
- Zachowaj historię: bez amend, force-push, pomijania hooks i automatycznego
  push. Publikacja oraz integracja źródeł wymagają osobnego polecenia.
- Warunek właściciela z2026-09-22: publikacja czegokolwiek na GitHub jest
  wstrzymana do poprawienia FT_FAMILY_SCALING przez MiMo i pozytywnego
  niezależnego odbioru poprawionego pakietu. Obecna recenzja R1–R7 jest w
  `proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md`.
  Lokalne checkpointy zachowują historię; spełnienie warunku nie zastępuje
  osobnego polecenia publikacji od właściciela.
- Prywatne klucze, seedy, uwierzytelnienia, cache i robocze binaria nie są
  materiałem commita. Publiczne PK i syntetyczne payloady `.bin` mogą być
  niezbędnymi, przypiętymi wejściami matematycznymi.

## Podsumowanie dla właściciela po każdym zadaniu

- Oprócz statusu, pinów i ścieżek podaj krótką własną ocenę po polsku:
  co rzeczywiście udało się wykazać, co nie wyszło lub pozostaje otwarte,
  co wynik zmienia w projekcie i jaki jest następny krok.
- Wyjaśniaj znaczenie wyniku przystępnie; same nazwy twierdzeń i PASS nie
  zastępują podsumowania. Rozróżniaj błąd kodu/kontrprzykład, brak dowodu,
  zbyt luźne oszacowanie oraz cel świadomie pozostawiony poza zakresem.
- Zachowuj niewygodne wyniki i ograniczenia. Nie promuj diagnostyki,
  skończonych testów albo zgodności hashy do szerszego twierdzenia.
