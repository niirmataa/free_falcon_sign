# S05 / MODEL_BRIDGE019 — bramka modelu przed dalszym kosztem018

SCOPED_MATH_CHECKPOINT / PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED. Baza35420d59, publiczny sampler
018 na2b5afcf2. Wpis S05/TARGET_CONTRACT bez zmiany celu.018 pozostaje
otwarte: po naprawie F04 najpierw ustalamy poprawny typ odbiorcy kosztu.
Nowe źródła i próby wyłącznie w development/S05_QROM; bez innych modeli,
bez zmian T12.1/B20/paperu, małe lokalne commity pod obiema blokadami Git,
bez push. Osobne runtime legacy/variant_a nie mieszają modułów Run2.Games.

Cel: jawne rozdzielenie publicznego generatora wspólnej pary i realnego
samplera odpowiedzi przy challenge z ROM; kernelowe wspólne prawa i
przeniesienie dokładnego certyfikatu018 do niezależnego interfejsu pary.
Powiązać nowy typ variant A z osobnym interfejsem odpowiedzi. Nie twierdzić,
że powstał source Sign, gra QROM albo wykonawczy sampler dla zadanego c.

Trasy:
A WYBRANA: dwa interfejsy, wspólny model praw i jawny kontrakt gry.
Dyskryminator: ten sam moduł wspólny kompiluje się w obu rozdzielonych
światach; stary kod i pełne J/P przechodzą do interfejsu pary bez zmiany(M)
i e. Nowy reply-only typ ma oddzielny adapter i jednostajny marginal.
B KONTROLA OBSTRUKCJI: dokładny adapter starego finite-bit joint law na
nowy external-uniform law. Ponownie użyć mechanizmu dzielności audytu F04;
wykazać zakres niemożliwości zamiast zgadywać adapter. To nie obala trasyA.
C ODROCZONA: warunkowanie starego joint law na zadanym c. Samo istnienie
regularnego prawa warunkowego nie daje wykonywalności, finite-tape prawa
ani kosztu. Nie usuwać challenge i nie zastępować korelacji iloczynem.
Powrót tylko z jawnym algorytmem i certyfikatem pełnego prawa/kosztu.

TODO:
- [x] Czyste interfejsy pair/noise i formalne prawa wspólne dla obu światów.
- [x] Legacy: instancja publicznego samplera018 i ten sam pełny AC/moment.
- [x] Variant A: rzeczywisty adapter nowego Run2.Sampler, dokładne prawo
      joint i wspólny idealny cel uczciwy, bez source-binding claimu.
- [x] Kernelowa przeszkoda dokładnego adaptera finite bits → uniform Rq;
      zachować atrybucję i piny mechanizmu z audytu F04.
- [x] Kontekst pełnej odpowiedzi: zachowanie momentu pod obserwacją, jeśli
      istniejące repo nie dostarcza właściwego wspólnego lematu.
- [x] Sage/Lean kontrole zakresu, piny, audyt, receipty i checkpoint.
- [x] Jawny handoff z modelem dalszego kosztu018 i otwartym QROM bridge.

Klasy: interfejs/źródło losowości = MODEL; równości, AC/moment, zasoby,
wiążenia gry/kodu = OBOWIĄZKI; A-QMT/Q-PRG primitive-bound osobno.
Każdy nowy wynik potrzebuje kernela przed użyciem w końcowej tezie.
Pojedynczy Lean:1 rdzeń,4GiB Lean/8GiB AS,110s CPU/120s wall; bez
nadpisywania prób. Nie uruchamiamy cudzych workerów ani pełnych replayów.

Zamknięcie zakresu019:84 eksporty/15 modułów,21 równości kodu i niezależny
rdzeń194 linie.33 moduły wspólnych źródeł zgodne między rozdzielonymi
środowiskami. Kernelowy transfer referencji dopisany jawnie: P≤kappa R
na nośniku J daje e'=kappa(1+e)-1; nie ma instancji źródłowego kappa.
Rozszerzenie trasyA o wydzielenie rzeczywistego runtime usuwa zależność
przyszłego kosztu od starego typu Sampler; generator odtworzono bajt w bajt.

Sage744 skończone kontrole PASS, standardowy preparser, exact004 reprodukuje
exact003.9 nieudanych prób Lean,2 timeouty Sage i diagnostyka startupu
zachowane. Podgląd natywnego TeX niezweryfikowany po3 próbach środowiska;
źródło i raport Markdown pozostają dostępne. Nie jest to source/kernel gry.

Dalsze obowiązki nie są odhaczone jako rozwiązane: pełny koszt018,
połączona gra/QROM, source KeyGen/M/Sign/PRG i właściwe porównanie do prawa
rzeczywistego. Konkretny następny kontrakt: TODO_PAIR_MACHINE_020.md.
Szczegóły/piny: MODEL_BRIDGE_019_CHECKPOINT.md i MODEL_BRIDGE_019_CHECKS.json.
