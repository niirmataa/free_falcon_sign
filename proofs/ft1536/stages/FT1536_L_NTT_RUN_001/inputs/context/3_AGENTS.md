# FT1536 — aktywne zadanie GPT-ASTRA: L_NTT

Aktualne zlecenie:

`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_NTT_2026-09-18.md`.

## Etap i katalog pracy

Przeczytaj nadrzędny `/home/footfalcon/Dokumenty/AGENTS.md`. Ogólne zasady
projektu, danych, formalnego dowodu i sandboxa pozostają w mocy. Ten lokalny
plik i nowe zlecenie aktualizują etap, wykonawcę, badaną wersję i katalog:

- wykonawca: GPT-ASTRA;
- zadanie: związany ze źródłem dowód poprawności i zakresów kanonicznej
  ścieżki NTT/Montgomery dla FT1536;
- jedyny katalog zapisu:
  `/home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001`;
- badana baza: **candidate/** z ukończonego `FT1536_L_RHO_RUN_001`;
- `L_RHO_PROVED_FOR_PINNED_MODEL` jest wejściem nowego zadania;
- po raporcie przekaż wynik użytkownikowi i zakończ ten etap.

Historyczne W wskazujące odbiór Blue albo wykonanie L_RHO nie jest bieżącym
katalogiem zapisu. Nie wznawiaj tamtych zadań. Awaryjne zlecenie Daybreak
dotyczące L_RHO również nie jest aktywnym zleceniem tej sesji.

## Właściwy obiekt dowodu

```text
L_RHO candidate/falcon-vrfy.c SHA-256:
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42

L_RHO CANDIDATE.sha256 SHA-256:
2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a
```

Pracuj na hash-sprawdzonej kopii w `source/`, zachowując ją bajtowo.
Oryginalny S17 pozostaje historyczną referencją; nie zastępuje nowego
kandydata w konsumowanym łańcuchu. Nie wdrażaj nowej poprawki źródeł
w tym zadaniu. Własne modele, harnessy i jawne kopie obserwacyjne są dozwolone
w bieżącym katalogu.

FT1536 ma `ternary=1`, `logn=10`, `N=1536`, `q=18433`.
W tym wariancie tablice powstają przez **mq_mkgm3**, a inverse scaling przez
**mq_div_18433**. Udowodnienie wyłącznie ścieżki statycznych tablic dla
`logn<=9` nie realizuje zadania.

## Zakres i rygor

- Ukończone L_RHO, L_V-STATIC, odbiór Blue, H/S17, USB, instrukcje i wcześniejsze
  raporty są tylko do odczytu. Ich AGENTS.md i manifesty są przypiętymi wejściami.
- Zachowaj N, q, Phi, Q, B, full ternary secret i uczciwe COMP_STATIC.
- Teza obejmuje wszystkie kanoniczne h,r,c, nie tylko jeden klucz lub regresję.
- Oddziel reprezentację zwykłą od Montgomery oraz wynik modularny od centrowania.
- Dowody zakresów i zgodności źródła poprzedzają przenoszenie własności
  abstrakcyjnej transformacji na rzeczywisty kod C.
- L_NTT nie jest jeszcze pełnym L_V, dowodem parsera lub bezpieczeństwa EUF-CMA.
- Korzystaj z danych publicznych; bez KeyGen, sekretów, instalacji, sieci
  badawczej, commitów, podpisów, publikacji i równoległych agentów.
- Sandbox ma rzeczywiście ograniczać zapis do bieżącego katalogu;
  cache/TMPDIR/HOME/DOT_SAGE również kieruj tutaj. AGENTS.md nie jest sandboxem.
- Sage uruchamiaj jako `sage plik.py ...`; zainstalowany frontend nie
  obsługiwał `sage -python`. Osobno zapisuj wersję Sage i jego Pythona.
- Zapisuj komendy, błędy, limity i pełne wyniki. Dodatni werdykt wymaga
  zamknięcia wszystkich obowiązków tezy, nie samego powodzenia testów.

Ten plik jest przygotowaną instrukcją startową; katalog nie zawiera jeszcze
wykonania ani wyniku L_NTT.
