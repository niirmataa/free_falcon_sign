# Dziennik koordynatora B20 — append-only

Format wpisu: data UTC / akcja + komenda / wynik (hash, status) / następny krok.
Każdy wpis trafia w tym samym commicie co efekt akcji. Stare wpisy się nie przepisuje.

## 2026-09-22T22:10:01Z — naprawa narzędzi po przeglądzie właściciela

- Zlecenie: „popraw proszde”,następnie „kontynuuj”. Naprawiono checkpoint
  (objects,main,tożsamość,exact paths,ochrona obcego stagingu,para B20 z dziennikiem),
  setter STATUS (frozen W przed importem,zewnętrzne piny,przypięty wynik review,
  negatywne statusy,atomowy zapis),generator promptu (piny TASK,ścieżki,ochrona
  istniejących plików) i task-init (40/64-znakowy BASE,sprawdzenie dokumentu).
- Importer obsługuje oryginalny REVIEW_OUTPUTS.sha256 i verdict bez przepisywania
  zapieczętowanego pakietu. AGENTS i instrukcje zachowują ustaloną kolejność
  work → review → zaakceptowane stages → commit main. Hook wymaga poprawienia
  stagingu; usunięto podpowiedź jego pomijania.
- Komendy: `python3 -B -m unittest discover -s proofs/ft1536/tests -p 'test_*.py' -v`
  →27/27 PASS; `python3 -B proofs/ft1536/tools/archive.py verify` →34 checkpointy,
  51 dokumentów PASS; `python3 -B proofs/ft1536/batches/B20_001/build_package.py verify`
  →20+20,manifest `e5921b01b4f03f189627c8a0ed8e78e3716e5efe5f2eaa36cfb80d34631633b2`
  zgodny; `python3 -B tools/b20_review_prompt.py V01` →sprawdzone ścieżki/piny TASK.
  Test regresji odtwarza parę z czystego klonu,bez roboczych plików źródła.
- Receipty/logi narzędzi: `proofs/ft1536/work/TOOLS_COORDINATOR_FIX_2026-09-23/run002/`.
  Weryfikator pakietu sprawdza dokumenty; nie jest obserwacją aktywności workerów.
  Zmiana dotyczy narzędzi i instrukcji,bez zmiany statusów matematycznych/archiwów.
- Następny krok: użyć poprawionego workflow przy kolejnym rzeczywistym handoffie
  B20. Lokalny commit tej naprawy; push wymaga osobnego polecenia.
- Kontrola uzupełniająca po dodaniu odrzucania `..` w ścieżkach wyjściowych:
  ta sama komenda unittest →28/28 PASS; źródła/test ścieżki i końcowe logi
  w `TOOLS_COORDINATOR_FIX_2026-09-23/run003/`. Bieżący zakres archiwów bez zmian.

## 2026-09-23T00:42:07Z — P01 handoff,STOP_AND_REPORT przed V01

- Otrzymano COMPLETE_FOR_REVIEW od MiMo V2.6 Pro (wg HANDOFF),HEAD85b8e7c.
  REPORT `5ce98acca2519ee80b69ef11acab7a2c44a17c422f5a01565be0e2138e351ae0`,
  OUTPUTS `acd1aec63edd8b9410c679b694e2306263b99b9f9ae273a332d1b95688185ea7`.
- Komendy organizacyjne: `python3 -B` z archive.verify_bundle/manifest/checked_bytes
  (read-only) →40/40 outputs,7930/7930 inputs względem W,10 raw logs zgodnych
  z receiptami i13 sealed źródeł zgodnych z before/after replayu.
- Porównanie całego source snapshotu z output zatrzymało się na brakującym
  `formal/Debug.lean`. Diagnostyka:Debug iRedTest występują w15-elementowym
  receipcie,poza40-member freeze. Ich rolę musi rozliczyć autor.
  Sterownik replayu,konfiguracja Lake/toolchain iREPLAY_RESULT także nie są
  przypięte przez OUTPUTS/INPUTS. Obecny driver zapisuje w W autora.
- Zachowano stan; bez zmian w frozen P01,bez awansu STATUS/importu/replayu.
  Szczegóły i minimalne wymagane uzupełnienie:
  `proofs/ft1536/work/B20_001/_coordination/P01_handoff_001/PRECHECK.md`.
- Następny krok: decyzja właściciela/nowy poprawiony handoff autora z kompletną
  closure replayu; potem binding iV01. P02 nadal czeka na odebrane eksporty.

## 2026-09-23T01:41:42Z — P01 v2 bound; V01 przygotowany

- Właściciel przekazał poprawiony output_v2. Zewnętrzne piny:
  REPORT `e7431aa06716e2960a86fd60bebea2ea213e770dd3f61b39a00292ac80ddd888`,
  OUTPUTS `ebd4cff87995d34d318fa86512aef266a3c3c05f6147c81b8bac307cb2553386`,
  HANDOFF `fef71b6ad36df51fde6e38991adfccb343300efb2b8f5602ed1f6ee2b8284a67`.
  Source HEAD85b8e7c; model autora opencode/mimo-v2.6-pro wg HANDOFF.
- Read-only preflight:archive.verify_bundle/manifest/checked_bytes →62/62
  outputs,7930/7930 inputs względem W,21 źródeł w exact-set snapshotu before/after,
  12 sealed raw logs i5 product_checks zgodnych z receiptami6 jobów exit0.
  11 formalnych źródeł i3 certyfikaty identyczne z v1; v1 manifest40/40 zgodny.
  Nie stwierdzono aktywnych jobów obliczeniowych P01. Nowego replayu nie wykonano.
- Poprzednia blokada kompletności source/config/log closure usunięta w v2.
  Semantykę definicji,TCB/reuse biblioteki,izolację wykonania i zakres PROVED
  oceni V01; nie nadano matematycznego PASS.
- Kanoniczne akcje: `b20_status_set.py P01 --start --model opencode/mimo-v2.6-pro
  --context <retrospektywny wpis HANDOFF> --bound-inputs <P01/inputs/BOUND_INPUTS.json>`;
  `b20_status_set.py P01 --final-report <output_v2/REPORT.md>
  --final-outputs <output_v2/OUTPUTS.sha256> --report-sha e7431aa0…
  --outputs-sha ebd4cff8… --head 85b8e7c4659685ef885e0121164b61e2421a926a`
  →FROZEN_AWAITING_REVIEW. `--start` odnotowuje zakończony przydział,nie startuje procesu.
- `archive.bootstrap(root,V01/inputs/producer_v2,BOOTSTRAP_PLAN_001.json)`:
  7994 pliki (62 outputs+OUTPUTS+HANDOFF+7930 inputs),kopie bajtowo zgodne,
  readonly; manifest `7e26e2fd558e541d06c4f5e5170cfaadb0a387503529b0c03722d4c6b01624ab`.
  ORIGINS zachowuje mapowanie. Względne INPUTS skopiowano pod root kopii,
  bez przepisywania autorskich manifestów.
- `b20_status_set.py V01 --bound-inputs <V01/inputs/BOUND_INPUTS.json>`:
  SHA `faae7bf95c4cac01fd039921485909b57a3a51caa8c386bf6a2fa2177720caaf`.
  Model V01 pozostaje do wyboru właściciela; początkowy status roli zostanie
  zmieniony przez --start dopiero przy rzeczywistym przydziale.
- `b20_review_prompt.py V01 --out <V01/run/REVIEW_PROMPT_001.md>` + jawne
  wskazanie FOCUS/BOUND_INPUTS. Finalny prompt
  SHA `cff6922d65a5eb5142a0db1af47ed4d900f89a8ba059970146599ba41cf0cd73`;
  REVIEW_FOCUS_001.md SHA `ef838fd620c0d451b3e9592169671d6878fe6ce51b9d50f302c0febc3e16beea`.
  Wskazano poprawny entry tools/restore_replay.py i kwestie do oceny:conditionalHistory,
  source-binding return-constant,certyfikaty,Mathlib provenance,manifest/EXPECTED
  przed wykonaniem oraz rzeczywisty RO/network-off sandbox (find-newer to kontrola pomocnicza).
- Następny krok: właściciel wybiera niezależnego recenzenta V01 w świeżym
  kontekście; start od V01/AGENTS.md i promptu. P02 czeka na odebrane eksporty.
  Tylko lokalny commit metadanych przygotowania; stages/import i push nie wykonano.
