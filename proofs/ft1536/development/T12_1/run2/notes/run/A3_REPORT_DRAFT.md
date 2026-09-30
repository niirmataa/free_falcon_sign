# FT1536_MATH_EUFCMA_MTISIS_RUN_002 — T12.1

Autor projektu: **Niirmata**. Zachowano atrybucję **Falcon Project / Thomas
Pornin** i licencje przypiętych źródeł. Wznowienie: GPT-6 Astra Fast
(`openai/gpt-6-astra-fast`), sesja `ses_f13464e70ffeuAM6Xf31ztFHAS`.

## Wynik i granica zakresu

Złożono warunkową redukcję konkretnych gier z zasobami konkretnego wykonawcy
w zadeklarowanym modelu referencyjnych procedur bitowych i skończonych plików.
Wykonawca uruchamia lokalne programy A/S, zachowuje pełną historię samplera,
używa skończonej listy celów i wykonuje publiczne Verify oraz ekstrakcję.
Twierdzenia zasobowe są **upper bounds**. Nie dowodzą osiągalności maksimum,
praktycznej szybkości na sprzęcie ani kosztu kompilacji i wykonania C.

Status całego pakietu pozostaje **PARTIAL_PROOF**: nadal brakuje pełnego
kernelowego M6/hbLo/hbHi, konsumpcji potrzebnych faktów ogonowych oraz
source-bound transportu od wszystkich wyników C-KeyGen przez Gram/liście/T5.
Sampler publiczny, mały parametr e, real-PRNG bridge i bezpieczeństwo kodu
nie są instancjowane tym warunkowym twierdzeniem. Niezależny odbiór i decyzja
właściciela należą do kolejnego etapu.

## Główne twierdzenie

Źródło: `formal/Run2/ResourceReduction.lean`, eksport
`FT1536.Run2.ResourceReduction.exists_resource_bounded_concrete_reducer`.
Rzeczywiste wydruki Lean, wraz z przesłankami, znajdują się w `formal_types.txt`.
Typ kwantyfikuje:

- `SK : Type`, `[Fintype SK]`, `beta : Budget`, `muKey : Law (SK × Rq)`;
- `A : ClassicalAdversary beta`, `S : Sampler`;
- lokalny `AdversaryCertificate beta A` i `SamplerCertificate beta S`;
- `e : ℝ`, `LocalJointCertificate S e`.

Wniosek:

```lean
∃ B : MTAdversary (beta.qh+1),
  B = Reduction.build beta A S ∧
  ResourceRealization beta B (resourceBound beta ⟨A,S,ac,sc⟩) ∧
  AdvEUF beta muKey A ≤ min 1
    (StoppingLoss.epsColl beta +
      EventTransfer.phi ((1+e)^beta.qs-1)
        (AdvMT (beta.qh+1) (SigmaMath.muH muKey) B))
```

`MTAdversary` w istniejącym modelu jest prawem wyjścia, bez pola kodu lub
kosztu. Dlatego zasoby są przyłączone przez **udowodniony wniosek**
`ResourceRealization`: istnieje `Implementation` z `Denotes ... B` i
`Resources ... ≤ cap`. `Implementation` dopuszcza wyłącznie zdefiniowaną
rodzinę interpreterów lokalnego kodu i publicznych procedur. Nie dopuszcza
arbitralnej funkcji z dowolnie zadeklarowaną ceną.

`Resources` to trzy maksima po wszystkich wejściach h, całych wektorach
QH+1 celów i wszystkich ścieżkach instrumentowanego wykonania. To nie jest
definicja równa `resourceBound`. Użycie uniform h w pomocniczym `allRuns`
służy zdefiniowaniu skończonej dziedziny maksimum; właściwa gra AdvMT nadal
używa **`SigmaMath.muH muKey`**, nie uniform h.

Kolizje: dokładnie
`min 1 ((Qs*QH + Qs*(Qs-1)/2) / 2^320)`, z odejmowaniem w ℕ przy Qs=0.
Nie dodano czynnika zgadywania celu. `resource_hardness_substitution` podaje
osobny wniosek z jawnym założeniem trudności dla solverów mających takie
zasobowe realizacje oraz `epsilon ≤ 1`.

## Łańcuch wykonania i zasobów

1. `LocalMachineCode`: skończona składnia read/output. Liście są statycznymi
   literalnymi plikami o zadeklarowanej reprezentacji. `erasure` utożsamia
   wykonanie z istniejącym `LocalBitCode`; koszt skanowania kodu, lokalnego
   odczytu, nawigacji, wyjścia i portów pochodzi z tego interpretera.
2. `MachineExecution`: paliwowy interpreter bez wywoływania `A.code` lub
   `S.code` jako operacji runtime. Żądania powstają przez wykonanie lokalnego
   kodu. Paliwo Qs+QH+1 nie obcina dopuszczalnego A, co wynika z `At`, Fits
   i strukturalnego budżetu. `build_binding` wiąże prawo z Reduction.build.
3. `MachineAccounting`, `BitAllocation`, `TableAllocation`,
   `VerifierAllocation`: jawne kopie i profile alokacji zgodne z gałęziami
   referencyjnych procedur. Wewnątrz wywołania/tury nie odejmuje się odzyskanej
   pamięci. Między turami bierze się maksimum. Arytmetyka wielomianowa ma
   jawny koszt oraz kod AST; pole wejścia nie jest darmową funkcją celów.
4. `MeteredExecution`, `PrefixResources`: czas, arena/peak, ruch danych i
   invariants całego faktycznego przebiegu. Naliczane są także ścieżki stopu,
   zgłoszenie wiadomości przed abortem, nonce, sampler, resume A i historia.
5. `FinishResources`: jawnie eager zakończenie, także na odrzuconej gałęzi
   materializujące potencjalny wynik. Weryfikacja i ekstrakcja korzystają
   z procedur na plikach słów. `fileFinish_correct` dowodzi identycznego
   wyniku, a `finalCost_bound` ogranicza ten konkretny profil wykonania.
6. `ResourceReduction`: dolicza wejściowe pliki/kody/coins, bierze globalne
   maksima zasobów, dowodzi law binding i składa wszystko z istniejącym
   probabilistycznym twierdzeniem. Nie powtarzano wyprowadzenia Phi/chi².

Dokładne jednostki, formuły i rezerwy modelu są w `RESOURCE_BOUND.md`.
Sam fakt zliczenia instrukcji/komórek tego formalnego modelu nie jest
twierdzeniem o fizycznym RAM, kompilatorze Lean lub kodzie Falcon C.

## Przesłanki lokalne

`AdversaryCertificate`: konkretny skończony kod; Fits dla wszystkich h/coins;
lokalna zgodność resume z głową właściwej kontynuacji na obserwowalnej
historii `At`. A nie dostaje dodatkowego celu c przy odpowiedzi Sign.

`SamplerCertificate`: konkretny skończony kod; zgodność pojedynczego
wykonania z S.code dla publicznego h/st/m/r i rzeczywistych fair bits, na
wejściu o ograniczonej wielkości. Przeliczone lokalne koszty są twierdzeniami,
a nie deklaracją Resources całego reduktora.

`LocalJointCertificate`: `0 ≤ e`, AC samplerLaw względem freshHonest oraz
drugi moment w kierunku samplerLaw||freshHonest ≤ 1+e dla każdego lokalnego
h/st/m/r. Nie zakłada równoważności całych gier ani końcowej nierówności.

## M6/T5 — rzeczywiście otwarte

Historyczny rachunek daje przedział około
`[1.26606846824675; 1.26782523071824] · 10^-24`, wspólne zaokrąglenie
**1.27e-24**. Nie wynika z niego jeszcze source-bound twierdzenie dla
wszystkich wyników C-KeyGen/Sign. Wymagane brakujące typy są zapisane
dosłownie w `NEXT_INTERFACE.md`; aktualne warunkowe konsumenty są audytowane.

Certyfikat CountsFold dowodzi równości konkretnego iloczynu/splitu dużych
liczb naturalnych. Nie dowodzi, że końcowe endpointy Arb opisują dokładne
masy okien ani że nastąpiła kernelowa konsumpcja ogonów. Historyczny
`rawBadEnclosure.lean` z `numerical_bounds_assumption` zachowano jako
odrzucony szkic w historii; nie jest częścią importowanej closure dowodu.

Osobny T5 W odczytano RO. Jego wyniki nie są nowymi importami formalnymi
tego pakietu i nie zostały tu odebrane. Piny i dokładne wymagane eksporty
są w `T5_DEPENDENCY_STATUS.json` oraz `NEXT_INTERFACE.md`. Lokalny Rejection
z CENTERING_CLOSURE/PARTIAL nie zastępuje `rejection h c` tego modelu.

## Errata MiMo i historia

Właściciel wskazał `FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001_V2_1_ERRATA`.
Sprawdzono295/295 członków; OUTPUTS
`c80b3e542288fe22f60cdb8d8d14465a1c41695cba923b3c87b68b6ac2581a10`.
REPORT pozostaje
`e593d91ed0e827bd240a145a31d2767407c4ea55eafd34e9a07252b49cd10d7c`.
Zmiana dotyczy jednego escape w RESULT i dodania ERRATA. 28 modułów dowodowych
jest identycznych z RUN_002; oddzielny Audit.lean ma inne zadanie. Bajty
zachowano w `inputs/MIMO_V2_1_ERRATA.tar.xz`; szczegóły w receipcie intake.

Próby nieudane, ich źródła, surowe logi i receipty pozostają w historii.
Stare output przeniesiono w tym samym W do `run/OUTPUT_DRAFT_20260929`.
Restart harnessu nie uruchomił drugiego wykonawcy: proces pakowania
przetrwał, a jego zakończenie obserwowano przez pidfd. Nie przypisuje się
nieznanego kodu exit przerwanemu połączeniu narzędzia.

## Ocena autora

Najważniejszy postęp to dołączenie globalnych zasobów do warunkowej redukcji
o zdefiniowanych grach, z wykonaniem rzeczywistych lokalnych programów.
Narzut jest bardzo luźny i dotyczy wybranego referencyjnego algorytmu.
Zwiększa to kompletność formalnej redukcji, ale nie ustala praktycznego
poziomu bezpieczeństwa FT1536 ani pełnej poprawności Sign.

Następny merytoryczny krok: niezależny odbiór zakresu A3 i jego modelu
zasobów; równolegle wymagane nadal kernelowe numeryczne bindingi M6 oraz
source/Gram/leaf i box-tail z osobnego toru T5. Import stages i Git prowadzi
koordynator po zaakceptowaniu rzeczywistego zakresu.
