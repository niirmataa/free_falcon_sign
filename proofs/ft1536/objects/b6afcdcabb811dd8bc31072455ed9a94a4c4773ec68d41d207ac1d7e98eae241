# Obowiązkowy tryb rachunku matematycznego — SageMath / .sage

Decyzja właściciela2026-09-22. Autor projektu Niirmata. Uzupełnienie dotyczy
nowych prac,niezależnych kontroli matematycznych i niezakończonych zleceń,
w szczególności T02.1,T03 oraz S01 CORRECTIONS_RUN_003.

## Wymagany format i wykonanie

Autorytatywny rachunek matematyczny i jego checker zapisz w **pliku `.sage`**
i wykonaj standardowym wejściem SageMath z włączonym preparserem:

```sh
sage scripts/lemma.sage
```

W tej instalacji dopuszczalna jest przypięta pełna ścieżka launchera:

```sh
/home/footfalcon/.local/bin/sage scripts/lemma.sage
```

Nie zastępuj tego przez `sage --python`, `sage -python`, `python lemma.sage`,
`sage lemma.py` lub `.py` z `from sage.all import ...`. Nie wystarcza zmiana
rozszerzenia wrappera, który deleguje cały istotny rachunek do starego `.py`.
Formuły,rekurencje i sprawdzane nierówności nowego certyfikatu mają być
wyrażone i wykonane w autorytatywnym kodzie `.sage`.

Normalne wewnętrzne preparsowanie Sage do wygenerowanego `.sage.py` jest
częścią tego trybu. Pliki pochodne/cache zapisuj wyłącznie pod trwałym W;
runner ma uruchamiać przypięty oryginał `.sage`, nie ręcznie plik pochodny.

## Dziedziny i semantyka

- Dokładne całkowite/wymierne: jawnie `ZZ`, `QQ` i dokładnie zadane wejścia.
- Funkcje rzeczywiste wymagające oszacowań: `RealBallField` lub
  `RealIntervalField`,z podaną precyzją i outward enclosure/remainder.
- `float`,`RDF`,same przybliżenia MPFR lub centra przedziałów nie zastępują
  certyfikowanego boundu. Diagnostykę zmiennoprzecinkową oznacz osobno.
- Podczas przenoszenia z `.py` rozlicz zmianę semantyki literałów,dzielenia
  i `^`. W modelu Word/XOR/shift/modulo jawnie zachowaj semantykę operacji;
  nie traktuj konwersji rozszerzenia jako proofu równoważności.

W nowym autorytatywnym wejściu lub osobnym preflight `.sage` sprawdź tryb:

```sage
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024
```

To kontrola preparsera/toolchain,nie dowód celu matematycznego.
W COMMANDS.log/receipt zachowaj rzeczywisty argv,wersję SageMath,hash `.sage`,
exit code,stdout/stderr oraz powiązanie wygenerowanych certyfikatów z tym runem.
Fresh replay autora i niezależnego recenzenta ma odtwarzać ten sam tryb.

## Pozostałe narzędzia i granice

Python `.py` pozostaje narzędziem organizacji wykonania: hashe,manifesty,
JSON,obsługa procesów,logów i sandboxu. Taki runner wywołuje `sage lemma.sage`
dla rachunku matematycznego. C harness sprawdza oryginalny C,Lean zachowuje
rolę kernela formalizacji. Nowa zasada nie przypisuje Sage statusu proof kernela.

Stare przypięte zależności zachowują swoje rzeczywiste formaty i zakresy.
Nowe/zmieniane rachunki oraz wymagane nowe checkery stosują niniejszą zasadę.
Przeniesienie istniejącego własnego rachunku wymaga diffu,ponownego wykonania
i zgodności certyfikatów,nie samego przemianowania. Zachowaj każdy mismatch.

## Przekazanie do trwających prac

To jawne uzupełnienie TASK: ma pierwszeństwo w wyborze formatu/trybu rachunku
nad wcześniejszym dopuszczeniem Python Fraction lub `sage file.py`.
Pierwotne TASK/bootstrap piny pozostają identyczne; dodaj kopię tego uzupełnienia
i jego SHA do INPUTS oraz sealed outputs nowego pakietu.

Właściciel przekazuje uzupełnienie istniejącemu wykonawcy. Ten przyjmuje je
na bezpiecznej granicy kroku; nie startuj drugiego modelu i nie nadpisuj
zakończonego freeze. Jeśli W już frozen,zgłoś to i przygotuj osobny suplement
po wskazaniu właściciela. Historyczne raporty,manifesty i odebrane wyniki
nie są przepisywane ani automatycznie unieważniane.

Niezależny review/replay nadal wykonuje inny model wybrany przez właściciela.
Prowadzący przygotowuje zlecenia i archiwizuje przekazany wynik. Wszystkie
nowe pliki i cache wyłącznie pod trwałym W,bez systemowego tmp/tmpfs.
