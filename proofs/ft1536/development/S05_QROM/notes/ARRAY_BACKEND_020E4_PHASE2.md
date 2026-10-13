# TODO020E4 — prymitywy i pętla, checkpoint częściowy

PARTIAL_KERNEL_OBLIGATIONS / WARUNKOWY / NOT_REVIEWED. 2026-10-13.
15 modułów,77 nowych twierdzeń; osobny czysty audit aksjomatów. Receipty
w ARRAY_BACKEND_020E4_PHASE2.json. To zapis pracy, bez niezależnego odbioru.

Wykazano zgodność kosztowanej realizacji z tablicowym backendem oraz
ograniczenie obu liczników pętli:4 + fuel*(5 + stepPrice cap capacity).
stepPrice dolicza pełny przegląd wartości, instrukcję, odczyt stosu,
zdjęcie ramki i co najwyżej2 wstawiane ramki. Nie zakłada się ceny
niezrealizowanego callbacku: wywoływany evaluator to konkretny bank wartości.
Obsłużone są również nieudane gałęzie. 877 literalnych komórek programu ma
kernelowe wiązanie; generator Sage odtworzył dokładne bajty źródła.

Ceny są **MODELEM Word512/RAM** z kopiowaniem przy zapisie. Drugi licznik
liczy skumulowane naliczone słowa, nie zmierzony peak procesu Lean/C.
**OBOWIĄZKI** zgodności i nierówności tego wykonawcy są udowodnione;
**ZAŁOŻENIE** momentu M oraz pozostałe warunki QROM pozostają bez zmian.
Do pełnego Q-RESC brakuje przygotowania publicznego wejścia/monet/ROM,
parsowania obrazu, inicjalizacji, kopii odpowiedzi oraz uzasadnienia
pełnego modelu przestrzeni. S05 nie ma przez ten checkpoint dowodu EUF-CMA
w QROM ani deklaracji poziomu bezpieczeństwa.

Próby i odrzucenia zachowano append-only w .build/pair_machine_020/
array_backend_001/runs. Szerokie rozwijanie dowodu atomów przekraczało
pamięć; złożenie z lokalnych granic zamknęło moduł w2,47s. Bazowe zużycie
procesu kompilatora tych zależności jest bliskie4GiB. Wiązanie obrazu
przeszło pod wcześniej zatwierdzonym limitem6GiB; nie podnoszono limitu
pozostałych kompilacji. PublicDataCheck/AtomValueCheck były diagnostyką,
nie zależnościami zaakceptowanej biblioteki. Nieudany eksport interpreterem
nie jest dowodem błędu programu; udany eksport redukcją również sam nie
jest dowodem — użyty dowód to PublicImage020E4.binding.
