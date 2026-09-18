# FT1536 — instrukcje pracy w Dokumenty

## Projekt i zakres

- Autor prowadzący: Niirmata. Projekt: **FT1536 full ternary secret**,
  rozwijany jako schemat podpisu. Historyczny Falcon EXTRA jest bazą kodu;
  zachowuj jego atrybucję oraz odróżniaj wkład FT1536.
- Ustalony profil uczciwego podpisywania: **FALCON_COMP_STATIC**. Nie zmieniaj
  go na COMP_NONE ani nie utożsamiaj STATIC ze stałą długością podpisu.
- Pracuj tylko nad bieżącym, wskazanym przez użytkownika zadaniem FT1536.
  Pozostałe pliki w Dokumenty, instalatory i dane osobiste są poza zakresem.
- Starsze prompty są opisami konkretnych zleceń. Nie uruchamiaj ich kolejno
  ani nie zakładaj, że stary napis „następny krok” jest nadal aktywnym zadaniem.

## Aktualny podział pracy

1. GPT-ASTRA ukończył `FT1536_LV_STATIC_RUN_001`.
2. **Codex / Daybreak Blue-latest** ma wykonać jeden niezależny odbiór wyniku.
3. Raport odbioru wraca do użytkownika i GPT-ASTRA. Dalszy dowód lub projekt
   poprawki będzie osobnym zadaniem; nie zaczynaj go automatycznie.

Model wybiera użytkownik w kliencie. Ten plik nie przyznaje dostępu TAC,
nie zmienia uprawnień usługi i nie zastępuje ustawień modelu.

## Korzenie i właściwa baza

```text
DOC = /home/footfalcon/Dokumenty
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
S17 = H/build
R = DOC/FT1536_LV_STATIC_RUN_001
W = DOC/FT1536_LV_STATIC_ODBIOR_BLUE_001
```

Referencją jest historyczny S17. Manifest 17 plików:

```text
git commit: d641ab1037c2fa1dd4a22c258854d79d67b9b46b
git path: evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256
SHA-256: 03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
```

Oryginalne H, USB, S17 oraz ukończone R są **tylko do odczytu**.
Lokalny `/home/footfalcon/free_falcon_sign/Extra/c` zawiera wycofany kandydat
warning-clean i nie jest źródłem obecnego zadania. Nie zmieniaj jego gałęzi
ani indeksu. Polecenia odczytowe Git wykonuj z `GIT_OPTIONAL_LOCKS=0`.

## Zamrożony wynik do odbioru

```text
R/REPORT.md
SHA-256: c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd

R/OUTPUTS.sha256
SHA-256: 0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87
```

Deklarowany wynik: `COUNTEREXAMPLE_REQUIRED_DOMAIN` dla ustalonego
`Ext0` w lemacie L_V-STATIC. To wynik do niezależnego sprawdzenia, nie
oczekiwany z góry werdykt recenzenta. Nie utożsamiaj go z obaleniem T2C3/T5,
nieistnieniem dowolnego ekstraktora lub efektywnym fałszerstwem EUF-CMA.

Bieżące zlecenie:

```text
DOC/FT1536_DAYBREAK_BLUE_ODBIOR_LV_STATIC_2026-09-17.md
```

## Zapis i ochrona danych

- W bieżącym odbiorze zapisuj nowe artefakty wyłącznie w W.
- Nie zmieniaj plików R, nawet dziennika, cache, binariów lub manifestu.
  Do uruchomień przygotuj hash-sprawdzone kopie potrzebnych wejść w W.
- Nie generuj nowych kluczy w tym zadaniu. Nie czytaj prywatnych kluczy,
  seedów, prywatnych współczynników, `.private`, `private_extraction`,
  keyringów sekretów ani danych uwierzytelnienia klienta.
- Publiczny klucz, publiczne h, syntetyczny świadek i jawne commitmenty
  wskazane w zleceniu są dozwolonymi danymi badawczymi.
- W danych projektu i manifestach nie podążaj za symlinkami ani ścieżkami
  uciekającymi z bazy manifestu. To ograniczenie danych wejściowych nie
  wyklucza standardowych dowiązań zainstalowanego toolchainu.
- Nie inicjalizuj repozytorium, nie commituj, nie podpisuj, nie pushuj ani
  nie publikuj bez osobnego, jawnego polecenia właściciela.
- Nie uruchamiaj równoległego wykonawcy zapisującego do tego samego katalogu.

## Sandbox i narzędzia

AGENTS.md jest instrukcją, **nie sandboxem systemowym**. Przed obliczeniami
ustal rzeczywisty zakres zapisu narzędzi. Pracuj w W z sandboxem klienta
ograniczającym zapis do tego obszaru; oryginalne wejścia pozostają poza nim.
Nie wyłączaj sandboxa ani mechanizmów zatwierdzania. Jeśli ograniczenie
uniemożliwia kontrolę, opisz problem techniczny; nie nadaj kontroli PASS.

Cache, TMPDIR, DOT_SAGE i nowe wyjścia kompilacji kieruj pod W. Nie uruchamiaj
oryginalnych runnerów, które zapisują wyniki do R lub H. Nie instaluj narzędzi
i nie używaj sieci do zadań badawczych bez odrębnego polecenia.

Zaobserwowane narzędzia:

- SageMath 10.9: `/home/footfalcon/.local/bin/sage`;
- Python Sage: `/home/footfalcon/miniforge3/envs/sage/bin/python`;
- Lean 4.34.0/Std:
  `/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean`;
- GCC: `/usr/bin/gcc`.

Potwierdź wersje przy starcie. Nowa kontrola na tych wersjach nie jest
automatycznie historycznym replayem Sage 9.5 lub Lean 4.30.0. Nie zakładaj
dostępności mathlib. Gdy `rg` nie jest dostępne, użyj standardowego Pythona
lub dostępnego narzędzia wyszukiwania zamiast zatrzymywać całe zadanie.

## Rygor i komunikacja

- Najpierw krótko podaj cel, zakres zapisu, wymagany wynik i warunek końca.
- Odróżniaj zgodność hashy, obserwację C, dokładny rachunek i formalny dowód.
  PASS, podpis Git lub opinia modelu nie zastępują dowodu.
- Zachowuj kwantyfikatory, Q, B, Phi, profil i ustalony ekstraktor. Nie
  poprawiaj tezy lub kodu podczas jej sprawdzania, żeby wymusić wynik.
- Lean: pokazuj rzeczywistą tezę, imports i `#print axioms`; nie używaj
  `sorry` ani założenia pożądanego wniosku do deklarowania pełnego dowodu.
- Nie nadawaj owner acceptance ani nie zmieniaj historycznych statusów.
- Zapisuj polecenia, kody wyjścia, logi, wersje i hashe. Wynik ograniczony lub
  niewykonana kontrola mają być nazwane wprost.
- Przerwanie przez narzędzie/usługę jest zdarzeniem technicznym, nie wynikiem
  matematycznym. Zachowaj stan i jawnie opisz komunikat; nie obchodź ograniczeń.
- Końcowe podsumowanie po polsku: rozstrzygnięcie, granice, ścieżka raportu
  i SHA-256. Następnie poczekaj na decyzję użytkownika o dalszej pracy z Astrą.
