# Zlecenie właściciela — następne20 zadań i20 niezależnych weryfikacji

2026-09-22. Status: **PACKAGE_PREPARED**. Właściciel potwierdził,że T02.1 już
przekazano do weryfikacji. Pakiet B20 przygotowuje się w tym czasie;
zadania zależne od T02.1 odblokuje dopiero odebrany handoff z pinami.

Gotowy pakiet: [OWNER_GUIDE](../../proofs/ft1536/batches/B20_001/OWNER_GUIDE.md),
[INDEX](../../proofs/ft1536/batches/B20_001/INDEX.json),
[protokół agentów](../../proofs/ft1536/batches/B20_001/AGENT_GIT_PROTOCOL.md).
20 TASK +20 REVIEW_TASK,40 własnych W,127 przypiętych plików dokumentacji.
PACKAGE.sha256 SHA `5037ae6ce10746fdf5d2dc1503b09289c34785d340da381fe116ac21c4e19889`.
Gotowość dokumentów nie oznacza,że przyszłe dependency outputs już istnieją.
Ten plik zachowuje wymagania na wypadek zmiany sesji/modelu lub wyczerpania
limitu Astry. Rzeczywistą gotowość dokumentów i zadań określa indeks B20.

## Wymagany rezultat przygotowania

1. Dokładnie **20 kolejnych zadań wykonawczych P01–P20**,rozwijających
   istniejący ROADMAP w kolejności zależności; każde z pełnym TASK i AGENTS.
2. Dokładnie **20 sparowanych zadań weryfikacyjnych V01–V20**:Vxx odbiera Pxx,
   ma własny W,kontrakt wejścia z frozen Pxx,formalną checklistę i replay.
3. Dokładne trwałe katalogi input/run/output/checkpoints dla wszystkich40 ról.
4. **OWNER_GUIDE.md:** główny dokument dla właściciela,opis każdego Pxx/Vxx,
   graf zależności,kolejność startów,gotowe komunikaty przekazania,warunki
   odbioru,integracji i wznowienia oraz sposób śledzenia postępu.
5. **AGENT_GIT_PROTOCOL.md:** operacyjna instrukcja agentów,lokalne milestone
   commity jako niirmataa,własne branches/worktrees,freeze i handoff; spójna
   z istniejącym stages/catalog/objects/archive.py.
6. **INDEX.json** i czytelny indeks:task ID,ROADMAP link,rola,status,W/branch,
   wymagane input pins,outputs,paired reviewer i następny consumer.

Proponowany stabilny układ (w finalnym pakiecie wszystkie ścieżki dosłowne):

```text
proofs/ft1536/batches/B20_001/
  OWNER_GUIDE.md
  AGENT_GIT_PROTOCOL.md
  INDEX.json
  tasks/P01/TASK.md ... tasks/P20/TASK.md
  reviews/V01/REVIEW_TASK.md ... reviews/V20/REVIEW_TASK.md
proofs/ft1536/work/B20_001/
  P01/{inputs,run,output,checkpoints,home,cache,tmp,checkout}/ ... P20/...
  V01/{inputs,run,output,checkpoints,home,cache,tmp,checkout}/ ... V20/...
```

Worktrees materializuje się tylko dla aktywnych ról. Katalogi i instrukcje
mogą być gotowe wcześniej. Brak przyszłego dependency hash oznacza jawne
BLOCKED_INPUTS z opisanym kontraktem przekazania; nie zmyślaj pinu lub PASS.

## Treść każdego TASK

- Miejsce w ROADMAP i zależności; cel i dokładny typ/eksporty Lean.
- Co ma być sformalizowane:semantyka/program binding,kwantyfikatory,domeny,
  prawa/gry,kierunek porównania,zasoby i instancje przesłanek.
- Lista lematów i certyfikatów,źródła ich dowodu oraz formalni konsumenci.
- Jawne assumptions/dług formalizacji starszych mixed-proof etapów.
- Dokładne input/output paths,scope,metryki,limity,toolchain,source pins.
- Meaningful controls,negative routes,mutation/no-op plan oraz fresh replay.
- Co uprawnia do PROVED/PARTIAL/BLOCKED/counterexample i jaki typ pozostaje
  przy niepowodzeniu; bez narzucania fałszywego pozytywnego wyniku.
- Kamienie milowe,unikalne checkpoint IDs,Git allowlist i handoff do Vxx.

## Wiążący standard

[AGENT_EXECUTION_AND_REVIEW_PROTOCOL](AGENT_EXECUTION_AND_REVIEW_PROTOCOL.md)
opisuje wykonanie i odbiór krok po kroku. Wymagane są rzeczywiste formalne
dowody w kernelu,bez zastępowania ich tekstem analitycznym lub samym rachunkiem.
Sage przez `sage lemma.sage` generuje certyfikaty konsumowane przez formalne
checkery. Każdy nowy source/receipt/output binding jest sprawdzany przed freeze.

Właściciel polecił,aby **wykonawcy i recenzenci sami commitowali lokalnie
przebieg pracy jako niirmataa**. Nowe zlecenia B20 mają to jawnie dopuszczać;
stare frozen TASK z zakazem Git pozostają historią. Jeden writer na checkout,
integracja main przez jednego prowadzącego. Push nadal wymaga odrębnego
polecenia i spełnienia obowiązującej bramki Family.

## Warunek uznania pakietu za przygotowany

Wszystkie20+20 dokumentów i40 W istnieją,linki/piny/stan zależności są
sprawdzone,zakresy formalne nie zawierają analitycznych luk ukrytych jako
przesłanki,a właściciel i dowolny następny prowadzący mogą z OWNER_GUIDE
jednoznacznie wybrać kolejny gotowy krok. Weryfikatorzy mają rzeczywiste
instrukcje oceny theorem terms/assumptions/source applicability,a nie tylko
polecenie uruchomienia autorskiego testu. Przygotowanie jest lokalnym commitem;
modele uruchamia się zgodnie z ustalonym ownership i decyzją właściciela.
