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
