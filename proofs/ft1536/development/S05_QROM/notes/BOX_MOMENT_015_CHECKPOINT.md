# S05 — BOX_MOMENT_015: pełny moment i mocniejszy budżet

**WARUNKOWY / KERNEL W PODANYM ZAKRESIE / NOT_REVIEWED.**
Baza matematyczna `80233ea4132ba1bbb3065b3b5fc5e6d291e4e710`.
Klasa: **obowiązek dowodowy Q-SAMPLER**. Bez nowego założenia
kryptograficznego, zmiany modelu lub deklaracji bezpieczeństwa QROM.

## Co wykazano

Z dokładnych trzech temperatur(M)014 uzyskano cały transport do uczciwego
prawa skończonego Sign i prawa publicznego. Dla dowolnego pełnego prawa J,
pod **jawną przesłanką dominacji** `J(x)≤(1+2^-60)J⁰(x)` dla każdego x,
łącznie z `(c,none)`, kernel daje:

- `J≪P`;
- `Σ J²/P ≤ 1+2^-47` — wzmocnienie wcześniejszego2^-44 bez nowych przesłanek;
- certyfikat wszystkich stanów przez istniejący reset do publicznego initial;
- ten sam bound dla wspólnego prawa `(h,odpowiedź)` pod jawnym pokryciem
  nośnika **tego samego μ_H**, bez ponownego losowania/warunkowania klucza.

47 nowych twierdzeń w6 modułach:

| Moduł | Liczba | Domknięty krok |
|---|---:|---|
| BoxSupport015 | 9 | Sumowalność z dodatniej dolnej masy, dokładne osadzenie boxu, próg poza boxem |
| BoxTail015 | 8 | Ogon≤2^-160 K, skończone normalizatory, flatness2^-32 |
| NormTail015 | 5 | Dokładne tN=1811939328/2093922385, odrzucenie normy<2^-24 |
| AcceptedMarginal015 | 9 | Pełna partycja zaakceptowanej masy, przedział marginalu, moment1+z² |
| FullMoment015 | 13 | Aborty i cap16, AC, pełny moment, dominacja, rzeczywista harmoniczna014 |
| SamplerInterface015 | 3 | Publiczne initial/all-state, to samo prawo kluczy, ograniczenie obwiedni |

Najkrótszy eksport od geometrii:
`FullMoment015.actual_harmonic_certificate`: dokładne NTRU/public/inverse,
ternarność f/g, kanoniczna H≥991 oraz dominacja J względem J⁰.
Nie przyjmuje tożsamości Grama/Parsevala/Schura jako wejścia.

## Rzeczywiste ponowne użycie

Mocna nierówność A2 i encodery boxu pochodzą z ROM. Stamtąd pochodzą też
Chernoff, ogólny konsument skończonych normalizatorów, faktoryzacja pełnej
odpowiedzi, mieszanka z abortem i tożsamość wycentrowanego momentu.
Nie użyto helpera wymagającego2^-40, dodatkowego tilt7/8 ani silniejszej
bramki1023. Wspólna skala K jest wybierana przed wszystkimi c/t.

L(none) nie jest zerowane. P zawiera porażkę capu normy i porażkę emisji
signed16, również gdy oba mechanizmy prowadzą do tego samego none.
Zachowano kierunek J/P i oddzielny dowód nośnika; TV go nie zastępuje.

## Weryfikacja i niewygodne wyniki

- 6/6 finalnych modułów i6/6 świeżego replayu: zero błędów/ostrzeżeń;
 47 wydruków aksjomatów ograniczonych do propext/Classical.choice/Quot.sound.
 Logi finalne i replayu identyczne bajtowo. Świeży replay trwał12.523s.
- 65 przypiętych modułów projektu użytych w replayu; sprawdzono domknięcie
 importów.16 potrzebnych modułów ROM i stary KeySupport011 zbudowano świeżo
 w runtime S05; nie uruchamiano cudzych workerów ani kampanii.
- Sage przez standardowy preparser:10 dokładnych kontroli QQ; balls512
 służą wyłącznie orientacyjnym wydrukom. Lean dowodzi używanych granic.
- Natywny kompilator LaTeX: success, bez napraw. Dokument pozostaje edytowalny.
- Źródła i logi prób elaboracji zachowane w ATTEMPTS; błędne wydruki sorryAx
 nie są dowodami. Przyczyny: nazwy/sygnatury lematu sumy, normalizacja
 definicji, kierunek rewrite, pominięty argument potęgi i ostrzeżenia taktyk.
- Obecna konserwatywna obwiednia jest **większa od1+2^-48**. Kernel to
 potwierdza; nie jest to dolna granica momentu J ani niemożliwość dalszej poprawy.

Samoprzegląd autora, nie niezależny review ani status REVIEWED.
Pełne piny/koszty: `BOX_MOMENT_015_RECEIPT.json`; historia:
`BOX_MOMENT_015_ATTEMPTS.json`; manifest `BOX_MOMENT_015_OUTPUTS.sha256`.
Koszt buildów nie jest kosztem samplera. Dziedziczymy jawny receipt007:
cap80/196,24 084 480 propozycji par,24 662 538 240 bitów w najgorszym
przypadku; **machine bit-cost certificate=false**, zasoby reduktora OPEN.

## Czego nie wykazano — mapa murów

| Obowiązek | Stan po015 |
|---|---|
| M → pełny moment z abortami | KERNEL pod jawną dominacją; budżet2^-47 |
| Kod007 → dominacja≤1+2^-60 | OPEN_INSTANCE; nie dostarcza jej sam typ certyfikatu |
| Koszt wykonania007/reduktora | Osobny OPEN; wcześniejsze wyliczenie capów tekstowe |
| Emitted KeyGen → ten sam materiał/h/μ_H i H≥991 | OPEN źródłowa instancja;014/015 jej nie zakładają jako dowiedzionej |
| Rzeczywiste Sign, codec i wszystkie wyjścia API | Q-BIND OPEN; wynik015 dotyczy jawnego modelu matematycznego |
| Kwantowe mechanizmy, PRG i kompozycja | OPEN; brak awansu D=(1+e)^q_s−1 do twierdzenia o grze QROM |
| Silniejszy cel all-h, h=0 i Dyadic | Zachowano ich odrębne statusy; bez cichego awansu |

## Równoległy ROM — przydatny kandydat

`c25b93c9` / tools `3e4452eb`: `KeygenMakeStatementMachine`
daje m.in. `call_same_block`, `cert_entry_frame`,
`entry_facts_of_allocation`, `callAt_of_allocation` i `cert_package_of_call`.
Wspiera **Q-KEY/Q-BIND/K-KEY-INSTANCE**: powiązanie alokacji i call site,
świeżość bloków oraz świadki tego samego wywołania. Sprawdzono rzeczywiste
typy, czyste zapisane runy,181 wpisów audytu i1535 par pinów źródło/artefakt.
To kandydat, bez importu do zależności015. Pełna chronologia pętli,
codec/emisja i prawo kluczy nadal pozostają otwarte. Eksporty zachowują
jawne przesłanki Call/Original/Prefix/Pinned/Dimensions/LegalWorkspace
oraz wskazane separacje; nazwa „statement-machine” nie usuwa ich automatycznie.
Obserwacje append-only: `.build/rom_watch_001/observation_004.json` i005.
Zamknięcie ROM `325c1f36`: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED;
sprawdzono również 115 jawnych pinów closure. Bez nowych zależności015.

## Następny większy pakiet016

1. Ustalić dokładną semantykę skończonych uczciwych bitów007 i przypiąć
   rzeczywiste tablice/progi, bez orakulum idealnej eksponenty.
2. Kernelowo rozliczyć pojedynczą parę, cap80 i fallback zera.
3. Przenieść dominację przez1536 par, kontrolę normy, cap196 i świeży
   sześcian; uwzględnić każdą gałąź kończącą wykonanie.
4. Dostarczyć faktyczny Sampler i InitialDomination015. Dopiero wtedy
   uruchomić gotowy konsument pełnego momentu, z tą samą dziedziną kluczy.
5. Osobno przypiąć koszty taśmy, operacji, tablic, pamięci i prekomputacji.
   Zakres source/H oraz QROM nadal rozliczać przez księgę warunków.

To usuwa cały matematyczny most M→J/P z kolejki; pozostaje konkretny most
od kodu samplera do nazwanej dominacji. Historyczny007 pozostaje bez zmian.

Piny zamknięcia: receipt SHA256 `a88669c8e936df12b6d8cfe2d1851c8c9cb087a9e9211ca51e3e42115deae067`;
wejścia SHA256 `e8af14f6bbdabc34309eb15ac8eb1aece74ac446bb4fee02d5e9321786b63f24`.
Lokalny commit ma zakres S05-015; bez push i zmian T12.1/B20/paperu.
