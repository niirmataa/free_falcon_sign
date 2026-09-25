# FT1536 — INTERACTIVE_GAME_AND_RESOURCE_BINDING

**Zadanie kontynuacyjne dla wykonawcy FT1536_MATH_EUFCMA_MTISIS_RUN_001.**  
Data przygotowania: 2026-09-23. Autor projektu: Niirmata.  
Proponowany identyfikator nowego wykonania: `FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001`.  
Zakres roadmapy: kontynuacja T12.1 i brakujących powiązań T07–T14 z poprzedniego `NEXT_INTERFACE.md`. Nie jest to nowe zadanie MiMo o skalowaniu rodziny.

## 1. Cel tego cyklu

Zdefiniuj i połącz interaktywną grę ordinary EUF-CMA, publiczny reduktor oraz eksperyment MT-ISIS. Udowodnij **warunkowe twierdzenie o skonstruowanym przeciwniku MT-ISIS**, z wyprowadzonym narzutem zasobów, wykorzystując gotowy rachunek z poprzedniego pakietu.

Nie wyprowadzaj ponownie całej teorii chi²/Phi. Obecne `Reduction.finite_trace_bound` jest lematem dla abstrakcyjnych praw transkryptów. Nowy wynik ma dowodzić, że właściwe prawa i zdarzenia pochodzą z konkretnych interpreterów A/ROM/Sign i B/MT-ISIS. Samo nazwanie predykatów `Win` i `MT` nie spełnia celu.

**Nie wymagamy w tym cyklu skonstruowania dobrego publicznego samplera, małych e_img/e_sign, liczby bitów bezpieczeństwa ani mostu do C/FPEMU.** Publiczny sampler i jego lokalny certyfikat prawa/kosztu mogą pozostać parametrami twierdzenia. Nie mogą natomiast przyjmować w swoich polach końcowej redukcji, globalnego boundu transkryptów ani gotowego sukcesu ekstrakcji.

## 2. Baza i piny

Pracuj na zamrożonym poprzedniku, nie na zmiennym `main`:

```text
REPO = /home/footfalcon/free_falcon_sign
PREV = REPO/proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_001/output
W    = REPO/proofs/ft1536/work/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001
IN   = W/inputs/bootstrap
OUT  = W/output
```

`W` jest nowym katalogiem. Nie nadpisuj istniejącego wykonania. Przy kolizji nazwy wybierz jawny nowy suffix i odnotuj go w handoffie.

Zewnętrzne kotwice poprzednika:

```text
REPORT.md
fa6bbac7b379d80c256ceb2875a67106a1d7322d84e7ee0cc6b8bddecec7de9a
OUTPUTS.sha256
a9e3af2ebccc221035024fabc7631fa47a93b841c1611e3e79f28ccf5ee5c98f
REPLAY_SEED.sha256
a5ff7f1a2f34dd0735b35c1b84afb915773c226e797f16b0b767bea777b4b707
MODEL.md
c2a7aa00890e6c90879bbbb41524af1058e17bb15863a33a4efcb83fcc92a37a
NEXT_INTERFACE.md
4721514fbe1e0f0b796bb67c11ed9a23414a64108123730bb3136d235f64b876
BRIDGE_LEDGER.md
96982154bf23b9ceae08b87e02a2ece8ad61450aa89f27f0cf3773782cadc8ef
```

Archiwum dostarczone do przygotowania zadania: `FT1536_MATH_EUFCMA_MTISIS_RUN_001.tar.xz`, SHA-256 `e4434fa5632fef5437ff756811639d1aea7e25661626664a64c892dabeafeff1`.

Podczas przygotowania tego zlecenia sprawdzono piny i 4461/4461 członków OUTPUTS; **nie wykonano nowego replayu Lean/Sage**. Poprzednik nadal ma status `PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW`. Nie zamieniaj tej kontroli integralności ani własnego przebudowania w niezależny odbiór właściciela.

Przeczytaj w całości: `MODEL.md`, `CLAIM.md`, `NEXT_INTERFACE.md`, `BRIDGE_LEDGER.md`, `RESOURCE_BOUND.md/.json`, `ASSUMPTIONS.json`, `GOAL_SPEC.md`, `REPLAY.md`, `TOOLCHAIN.json`, `FORMAL_EXPORTS.json`, `formal_types.txt` i odpowiednie źródła Lean. Poprzedni raport przeglądu jest materiałem pomocniczym, nie aksjomatem ani zaakceptowanym automatycznie dowodem.

## 3. Nie zmieniaj przedmiotu twierdzenia

Zachowaj **Sigma_math = E0 / coefficient-valued finite-box G16 / klasyczny direct-output ROM** z poprzednika:

- N=1536, q=18433, wielomian X^1536−X^768+1, sigma=768 i ścisły próg Q<B przy B=2093922385.
- `A_h(z)=reduce(z1)+h*reduce(z2)`; iloczyn określony przez resztę wielomianową z `Relation.lean`.
- Propozycja na skończonym włóknie w boxie współczynników −65535,…,65535, z wagami z `PublicSimulation.lean`; puste włókno i norm-reject zgodnie z tamtą definicją.
- Do 16 IID prób **tego samego** prawa przy stałym c; pierwszy norm-accepted wektor kończy retry. Dopiero potem dokładny `Emit`: z2 albo POST_ABORT przy niespełnieniu signed16. Nie ma ponawiania po Emit-failure, centrowania z2 ani dodatkowego Verify.
- Jedna jednostajna sól 320-bitowa na Sign. E0 nie produkuje PRE_ABORT; szerszy istniejący typ obserwacji można zachować, wykazując zerową masę tej gałęzi w E0.
- Verify sprawdza signed16(s) i Q(center(c−h*s),s)<B. Przedmiotem są współczynniki, nie źródłowy codec NONE/STATIC.
- Jednorazowe parametryczne wspólne prawo `muKey(sk,h)`; `muH` to jego publiczny marginal, nie rozkład jednostajny h.
- Ordinary freshness: każda wiadomość zgłoszona do Sign trafia do SeenSign, również gdy Sign daje abort. Nowy podpis starej wiadomości nie jest wygraną.

Nie utożsamiaj tego modelu z nieograniczonym coset-Gaussian G16 ani z rzeczywistym K_seed/PRNG/H2P. Ograniczenia STUCK/nonreturn i ogólnego środowiska E pozostają w ledgerze. Nie dodawaj ich jako obserwowalnych abortów do skończonego E0.

## 4. Główny typ docelowy — specyfikacja do zrealizowania

Poniżej jest **cel**, nie gotowy kod Lean i nie dodatkowa hipoteza:

```text
forall beta muKey A S e,
  e >= 0 ->
  AdversaryResourceCertificate A beta ->
  LocalPublicSamplerCostCertificate S ->
  LocalFullJointLawCertificate muKey Sigma_math S beta e ->
  let B := reduce(A, S) in
    B is a public executable MT-ISIS adversary on T=Q_H+1 targets
    and its execution implements the defined reduction
    and Resources(B) <= derivedResourceBound(beta,S)
    and AdvEUF(Sigma_math,muKey,A)
        <= min(1, eps_coll(beta)
                    + Phi((1+e)^Q_s-1, AdvMT(muH,Q_H+1,B))).
```

```text
eps_coll = min(1,
  (Q_s*Q_H + Q_s*(Q_s-1)/2) / 2^320)
Phi(D,b) = (2*b+D+sqrt(D^2+4*D*b*(1-b))) / (2*(1+D)).
```

Przy Q_s=0 rozlicz naturalne odejmowanie i rzutowania do liczb rzeczywistych jawnie. Zachowaj kierunek **J_sim || P_honest_stopped**. Strata konfliktów pozostaje **poza Phi**, po sprzęgnięciu gry uczciwej z zatrzymaną. Zmiana tej postaci wymaga osobnego dowodu, nie przepisania formuły.

`B := reduce A S` musi być zdefiniowanym programem. `AdvEUF` i `AdvMT` muszą być prawdopodobieństwami zdarzeń w zdefiniowanych eksperymentach. Wariant `forall A, exists B` wyprowadź z tej konstrukcji, nie przez wybór obiektu zawierającego oczekiwany bound.

## 5. Kolejność prac

### Etap A — przeciwnik, alfabety, jeden interpreter

Zdefiniuj ograniczonego klasycznego przeciwnika jako kod lub jawny program interakcji z semantyką wykonania. Ma prywatne losowe bity, adaptacyjne H/Sign i końcowe fałszerstwo. Zapytanie Sign jest atomowe: wiadomość jest ustalona przed solą, bez reentrancy lub ujawniania nonce w połowie operacji.

Uwzględnij Q_H, Q_s, czas własny, pamięć, liczbę losowych bitów i limit długości/łącznego transportu wiadomości. Skończoność alfabetów powinna wynikać z jawnych budżetów. Nie ograniczaj przeciwnika do kilku ustalonych wiadomości ani do deterministycznej listy pytań. Nowe zakończenie gry przy przekroczeniu budżetu może należeć do definicji ograniczonego przeciwnika, ale nie może zmieniać gry dla A spełniającego budżet.

**H przyjmuje dowolne ciągi bajtów w ramach budżetu**, nie tylko gotowe pary (r,m). Zdefiniuj bijektywne kodowanie nonce na dokładnie 40 bajtów i front-end do pojedynczej tabeli nazw. Nazwy krótsze niż 40 bajtów również mają normalne odpowiedzi H; nie mogą kolidować z nazwą Sign. Dłuższe nazwy nie mogą być obcinane. Można wykorzystać sumę typów short-name / framed-name, ale trzeba wykazać zgodność z literalnymi ciągami bajtów.

Końcową niepoprawną długość nonce lub współczynniki spoza legalnego typu traktuj zgodnie z matematycznym Verify. Zawężenie alfabetu końcowych prób do signed16 wymaga wykazania, że wyłączone próby i tak nie mogą wygrać. Nie przemycaj w tym kroku implementacyjnego codec/Verify.

Przygotuj trzy nazwy eksperymentów i ich interpreterów:

1. `EUF_real`: niezmieniona Sigma_math, jedno muKey i jedna leniwa tablica H.
2. `EUF_stopped`: ta sama gra, lecz stop bez wygranej przy konflikcie świeżo wylosowanej nazwy Sign z istniejącą tabelą.
3. `SIM_targets`: reduktor używający publicznego S oraz skończonej listy T=Q_H+1 niezależnych jednostajnych celów.

Obserwacje nie ujawniają wewnętrznej liczby prób, monet samplera ani czasu odpowiedzi. Koszt wykonania jest osobną metryką, nie nowym kanałem bocznym dodanym do tej gry.

STOP jest wewnętrznym zakończeniem bez wygranej, **nie** zwróconym PRE_ABORT/POST_ABORT. Pozostałe odpowiedzi zachowują dotychczasowe rozróżnienie tagów. Zwykła gra uczciwa przy konflikcie używa istniejącego H; zatrzymanie występuje tylko w grze porównawczej i symulatorze.

### Etap B — publiczność i lazy sampling

Włącz jednorazowe muKey na początku. W dowodzie można zachować latent sk, natomiast A i reduktor otrzymują wyłącznie h. Reduktor nie losuje sk z warunkowego rozkładu i nie korzysta z nieobliczalnego wyboru sekretu zgodnego z h.

Zamień nieskończoną `targets : Nat -> Rq` w **wejściowy wektor długości Q_H+1** albo wyprowadź formalny refinement starego kodu do tego wektora. Odczyt target[used] ma poprzedzający dowód used<T. Każde nowe H zużywa najwyżej jeden cel; cached H nie zużywa następnego; Sign programuje z S; końcowa świeża nazwa zużywa najwyżej jeden dodatkowy cel. Powtórzone wartości celów i cel zerowy są dozwolone.

Dowiedź probabilistycznej zgodności z leniwą wyrocznią: niewykorzystane cele są jednostajne i niezależne **względem przeszłości, od której zależy następna operacja**. Sama funkcja `hash_nonanticipating` nie dowodzi tego faktu.

Rozdziel:

- stan fizycznego programu reduktora, który może zawierać całą wejściową listę;
- filtrację dowodową, która ujawnia cele w kolejności odczytu;
- publicznie dostępny stan przekazywany S: h, historia dotychczasowych operacji i dostępne dane własne reduktora, m, r.

Nie warunkuj lokalnego argumentu jednostajności na całej przyszłej liście celów. Nie przekazuj S sekretu, prywatnych monet A ani nieujawnionych celów. Nie wystarczy napisać w komentarzu, że sampler jest publiczny: typ i wywołania mają to egzekwować.

### Etap C — rzeczywiste jądra i najwyżej Q_s płatnych przejść

Lokalny certyfikat dotyczy **jednego wywołania kodu S** w świeżym punkcie, nie całego eksperymentu:

```text
J_S = pushforward rzeczywistych monet S przez S.run(h,public_state,m,r)
P   = uniform_Rq(c) * Sigma_math.signBody(h,c)(o)
AC(J_S,P)
second(J_S,P) <= 1+e.
```

W tej Sigma_math signBody nie potrzebuje sk; zachowaj jednak poprawną integrację muKey i jego marginalu. Certyfikat obejmuje pełną parę (c,o), w tym POST_ABORT, i dokładny stan dostępny S. Nie zastępuj go porównaniem samych obrazów, samych udanych odpowiedzi lub marginalnych próbek.

Zidentyfikuj te jądra z prawami interpreterów. Rozlicz nonce, konflikty, wpisy do tabeli, prywatny stan A, końcowe Verify i padding. Wspólne kroki mają dokładnie ten sam kernel; nie wymagają nieuzasadnionych mnożników 1+e.

**Główny nowy lemat probabilistyczny:**

```text
AC(Law_SIM_trace, Law_EUF_stopped_trace)
second(Law_SIM_trace, Law_EUF_stopped_trace) <= (1+e)^Q_s.
```

Nie podstawiaj mechanicznie n=Q_s do `constant_adaptive_chi2`, jeżeli n liczy wszystkie kroki maszyny. Dopuszczalne są np. segmentacja do Q_s epok podpisujących z końcowym segmentem wspólnym albo lemat o liczniku płatnych przejść. W obu wariantach udowodnij równoważność praw/obserwacji i ograniczenie licznika. Przy wcześniejszym zakończeniu stosuj jawny stan absorbujący/padding.

Lokalne certyfikaty można wymagać jednostajnie na odpowiednio zdefiniowanej domenie historii. Domena nie może zawierać jako założenia poprawności całej redukcji. Historie niemożliwe muszą mieć jawne traktowanie; nie używaj warunkowania przez zero. Nie dołączaj wewnętrznych monet różniących oba samplery jako dodatkowych obserwacji, jeżeli nie masz dla nich wspólnego porównania praw.

### Etap D — konflikt nonce, wygrana i indeks celu

Z rozmiaru rzeczywistej tabeli przed i-tym Sign, i=0,…,Q_s−1, wyprowadź co najwyżej Q_H+i wcześniej zajętych nazw. Po ustalonej historii i wiadomości świeży uniform nonce daje ryzyko co najwyżej (Q_H+i)/2^320. Podepnij istniejące `fresh_nonce_conflict`, uśrednianie i sumę do interpretera. Nie zakładaj gotowego boundu `Pr[Bad]` jako certyfikatu globalnego.

Dowiedź sprzęgnięcia EUF_real z EUF_stopped do pierwszego konfliktu:

```text
AdvEUF_real(A) <= eps_coll + Pr_EUF_stopped[Win].
```

Następnie w SIM_targets wykorzystaj `indexed_extraction`: świeże m* wyklucza Sign-origin, a finalny wpis wskazuje konkretny j<T. Reduktor oddaje ten indeks i świadek `(center(c−h*s),s)`. Powiąż prawo **zwróconego wyniku programu B** ze zdarzeniem wygranej w symulatorze. MT nie może pozostać dowolnym predykatem przekazanym do twierdzenia.

Na końcu zastosuj gotową Phi i monotoniczność do rzeczywistych praw gier. Rozlicz Q_s=0, Q_H=0, cached/fresh final H, powtarzające się cele, aborty Sign i końcowe odrzucenie. Nie wprowadzaj czynnika zgadywania indeksu celu, chyba że zmieniasz założenie na inny problem i dowodzisz odrębnej redukcji.

### Etap E — zasoby reduktora

Wybierz jawny model: t w bitowych krokach, w w bitach pamięci, L w bajtach portów, zgodnie z `RESOURCE_BOUND.md`. Zdefiniuj interpreter kosztowy albo refinement do wskazanej maszyny bitowej. **Samo liczenie wywołań z nieuzasadnionym kosztem 1 nie jest certyfikowanym bit-cost.** Nie potrzeba weryfikacji kompilatora C ani modelu mikroarchitektury.

Lokalne certyfikaty kodu A i S mogą być założeniami metatwierdzenia. Muszą dotyczyć wykonania tych programów i konkretnych budżetów, nie kosztu całego B. Dla części własnej reduktora rozlicz kod tabeli, SeenSign, framing, odczyt listy celów, Verify, mnożenie/resztę, centrowanie, normę i wyjście świadka.

Możesz zastosować prostą listę z dokładnym porównywaniem nazw oraz zwykłe mnożenie współczynnikowe. Nie optymalizuj AVX/NTT. Konserwatywny, udowodniony bound jest wystarczający. Koszt B ma wynikać ze składania lokalnych kosztów, a nie być polem rekordu wyrażającym cel.

Uwzględnij co najmniej:

- M<=Q_H+Q_s+1 wpisów, długości rzeczywistych nazw i kopie danych;
- pamięć/odczyt **całego wybranego modelu listy Q_H+1 celów**; nie łącz zalet bezkosztowego wejścia strumieniowego i darmowej pełnej listy;
- generowanie soli i monet S, zależność od ich rozmiaru oraz koszt exact uniform;
- finalne Verify/ekstrakcję i kodowanie indeksu/świadka; osobno zasoby A i sterowanie symulacją;
- brak podwójnego doliczania A_h lub Emit, jeżeli są już wewnątrz certyfikowanego S.

Przykładowa struktura sumy jest tylko specyfikacją:

```text
t_B <= C_simulate_A(beta)
       + Q_s*C_S(beta)
       + C_nonce + C_table + C_seen + C_IO
       + C_verify_extract.
```

Wyprowadź konkretne funkcje w swoim modelu; nie przepisuj tej sumy jako dowodu. Koszty obliczenia nieobliczalnego uczciwego signBody należą do semantyki wyroczni gry, nie do algorytmu B. B nie może odwoływać się do niego podczas wykonywania.

Istniejący `PublicSampler` używa uniform `Fin coinCount`. Dowolny coinCount nie daje automatycznie exact bounded sampling z bitów. Najprostszy dopuszczalny nowy wariant to skończona taśma b bitów i coinCount=2^b, z jawnym refinementem. Inny wariant wymaga osobnego kosztu i traktowania niepowrotu/obcięcia. Nie wymagaj dokładnego wygenerowania dowolnych rzeczywistych wag Gaussa skończoną taśmą bitów: porównuj **rzeczywisty law kodu S** z prawem matematycznym za pomocą lokalnego e.

## 6. Granice, których nie wolno ominąć

### Centrowanie i poprawność uczciwego podpisu

Zachowaj kontrprzykład `Geometry.centering_can_break_acceptance` oraz wartości 2051350378<B i 2143496945>B po centrowaniu. Nie wolno założyć, że każde krótkie z po Emit jest akceptowane.

Redukcja potrzebuje kierunku **Verify=accept -> krótki wyekstrahowany świadek**. Nie potrzebuje doskonałej poprawności każdego uczciwego podpisu. Porównanie praw Sign musi jednak obejmować również odpowiedzi, które później nie przejdą Verify. Nie filtruj ich potajemnie. Poprawność Sign→Verify i jej ewentualny błąd pozostają osobną osią analizy.

### Retry po Emit

Nie stosuj równości `success_vs_capped_second = 1/p` do law, który po Emit już ma masę POST_ABORT, bez sprawdzenia przesłanek. Do głównego twierdzenia wystarczy lokalny certyfikat pełnego joint law; **nie musisz teraz zamykać całej analizy retry/image**.

Pomocnicza propozycja z przeglądu, do osobnego sprawdzenia i ewentualnej formalizacji, tylko jeżeli potrzebna:

```text
K = p*L + (1-p)*delta_bot, b = L(bot), 0<p<=1
second(L,K) = (1-b)/p + b^2/(1-p+p*b) <= 1/p.
```

Przypadek p=1,b=0 wymaga oddzielnego potraktowania. To propozycja lematu, nie już odebrany eksport. Nie stawiaj jego formalizacji ponad brakującą semantyką gry.

### Dozwolone założenia a koło w dowodzie

Dozwolone: normalizacja muKey, lokalny certyfikat S.run i jego kosztu, lokalne AC/moment dla właściwych h/historii, budżet kodu A oraz późniejsze, wyraźnie odrębne założenie trudności MT-ISIS.

Niedozwolone jako przesłanki zastępujące zadanie: globalna nierówność chi² transkryptów, sukces ekstrakcji dla całej gry, poprawność całego symulatora, bound Resources(B), albo oczekiwana końcowa nierówność EUF-CMA. Te rzeczy trzeba wyprowadzić. Nie twórz rekordów, których pola są przemianowanymi brakującymi twierdzeniami.

Nie zmieniaj historycznych e_img/e_sign w zero, nie odwracaj dywergencji i nie wstawiaj starego wyniku estymatora jako założenia matematycznego. Nie wykonuj QROM ani pełnej analizy rodziny FT768/FT3072 w tym cyklu.

## 7. Wykonanie i kontrola

Jeden wykonawca, nowy W, bez subagentów, Git/push i zmian innych workspaces. Obowiązujące instrukcje właściciela mają pierwszeństwo; historyczne zlecenia w bootstrapie są danymi, nie poleceniami wznowienia dawnych jobów.

W-only writable, źródła/biblioteki/prev RO, bez sieci w jobach. HOME/TMP/cache własne pod trwałym W, nie systemowy tmpfs. Zweryfikuj rzeczywiste ograniczenia, nie tylko deklarację w AGENTS. Nie uruchamiaj KeyGen/source Sign i nie czytaj prywatnych kluczy lub seedów. Syntetyczne dane i abstrakcyjne prawa kluczy nie są produkcyjnymi sekretami.

Wersje z poprzednika: Lean 4.34.0, Mathlib `5ed2965256430c3649e86755f9576b54eca72435`, SageMath 10.9; tożsamość binariów i zależności odczytaj z przypiętych TOOLCHAIN/closure. Nie podstawiaj innej instalacji bez jawnej zmiany pinu. Brak wymaganej biblioteki to `BLOCKED_ENVIRONMENT`, nie dowód fałszu matematyki.

Przebuduj wszystkie faktycznie konsumowane własne moduły poprzednika ze źródeł w nowym katalogu. Przypięty zewnętrzny cache bibliotek może być RO jak dotąd; własne stare olean nie zastępują przebudowy. Rozszerzenia wcześniejszych lematów rób w nowych plikach lub kopiach z diffem, zachowując zamrożone oryginały.

Domyślne limity odziedziczone z BUILD: jeden job, Lean -j1 -M6144, wall1800s/krok, AS12GiB i monitorowany RSS8GiB. Zmiany mają być jawne. Nie wymuszaj zatrzymania bez notatki o faktycznej przeszkodzie; zakończ własne joby przed handoffem.

Najpierw zapisz `GOAL_SPEC.md`: definicje gier, model zasobów, lokalny kontrakt S i plan końcowej deklaracji. Następnie wykonuj kolejne braki w powyższej kolejności. Nie kończ na samym planie; przy blokadzie oddaj maksymalny sprawdzony zakres i dokładny brakujący typ.

## 8. Kontrole odbioru

Dla nowych twierdzeń zachowaj pełne typy, implicit arguments, termy i transitive axioms. Tylko standardowe propext/Classical.choice/Quot.sound; bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu celu. Taktiki dowodowe są dozwolone, gdy kernel sprawdza wytworzony term. Brak warning/error w finalnych logach; wcześniejsze nieudane próby pozostają w historii.

Sage uruchamiaj rzeczywiście przez `sage plik.sage`. Małe dokładne modele testowe powinny sprawdzić interpreter, nie tylko ponownie obliczyć Phi. Użyj małego parametrycznego nonce/alphabet do testów, ale główne twierdzenie musi być rzeczywiście zinstancjowane do 320-bitowego nonce, Relation.Rq i Sigma_math poprzednika.

Pokryj: powtarzane H, programowany wpis odczytany później przez H, adaptacyjne wiadomości, duplikaty/zerowe cele, świeży końcowy H przy Q_H=0, Q_s=0, oba rodzaje abortu na odpowiednich poziomach modelu, konflikt nonce, nieświeże m* także po abortowanym Sign, krótkie nazwy H, oraz granice budżetów. W E0 brak PRE_ABORT wykaż oddzielnie od testowania szerszego helpera.

Kontrole negatywne mają reagować na realną zmianę semantyki. Przykłady: pominięte SeenSign przy abortach; zwiększanie used przy cached H; zastąpienie celu o tym samym indeksie innym celem; brak dodatkowego celu finalnego; konflikt potraktowany jako normalny podpis; doliczanie straty przy każdym H zamiast przy Sign; nierozliczony odczyt/storage listy celów. Dodaj no-op. Nie zastępuj dowodu ogólnego pozytywnymi testami.

Szczególnie kontroluj rozdzielenie: `Law` jako specyfikacja probabilistyczna, kod B/S jako program oraz koszt tego programu. Nieobliczalna definicja mas nie stanowi wykonania samplera.

## 9. Pliki końcowe i status

Oddaj w OUT co najmniej:

- `REPORT.md`, `CLAIM.md`, `MODEL.md`, `GOAL_SPEC.md`, `RESULT.json`;
- `GAME_SEMANTICS.md`: pseudokod/definicje gier, kolejność operacji, prawa i obserwacje;
- `MAIN_THEOREM.md`: pełna treść warunkowego twierdzenia i samodzielny dowód na papierze, z odwołaniami do eksportów Lean;
- `RESOURCE_BOUND.md/.json`: wybrana maszyna, kodowanie, wyprowadzone funkcje kosztu i zakres certyfikatów;
- `ASSUMPTIONS.json`, zaktualizowane `BRIDGE_LEDGER.md` i `NEXT_INTERFACE.md`;
- nowe źródła Lean, dokładnie użyte odziedziczone źródła, FORMAL_EXPORTS/types/AXIOMS, skrypty Sage i kontrole;
- komplet wymaganych wejść i closure, build/replay scripts, receipty, historię prób, INPUTS/EXPECTED/OUTPUTS oraz handoff z pinami.

Nie pisz teraz całego paperu rodziny ani prezentacji projektu. `MAIN_THEOREM.md` ma być częścią matematyczną gotową do późniejszego wykorzystania w paperze o EUF-CMA.

Oddzielne flagi:

```text
interactive_games_defined
full_byte_query_frontend_proved
lazy_sampling_and_target_budget_proved
local_to_game_law_binding_proved
paid_steps_Qs_proved
honest_stopped_coupling_proved
programmed_reducer_extraction_proved
reducer_bit_cost_bound_proved
conditional_eufcma_theorem_proved
conditional_eufcma_theorem_kernelized
public_sampler_instantiated
small_distribution_errors_instantiated
implementation_bridge_proved
source_security_proved
independently_reviewed
owner_accepted
```

Nie zaznaczaj `conditional_eufcma_theorem_proved=true` bez powiązania programów, praw, ekstrakcji i zasobów. Kompletny dowód analityczny i kompletna kernelizacja są odrębnymi osiami: pełny dowód na papierze może mieć jawną częściową formalizację, ale nie może mieć ukrytej matematycznej luki. Jeśli nie ukończono bit-cost albo interpretera, zachowaj `PARTIAL_PROOF` i nazwij brak.

**Pełny odbiór tego cyklu nie wymaga public_sampler_instantiated ani małych e.** Można uzyskać prawdziwy status `PROVED_CONDITIONAL_REDUCTION_FOR_FINITE_BOX_E0_MODEL` przy lokalnych, jawnych parametrach S/e/cost. To nadal nie jest bezpieczeństwo rzeczywistego FT1536. `independently_reviewed` i `owner_accepted` nie są flagami, które autor nadaje własnemu wykonaniu.

## 10. Replay i zakończenie

Fresh replay wykonaj w nieistniejącym, trwałym DEST, z przebudową własnych modułów, wszystkimi nowymi testami oraz semantycznymi produktami zadeklarowanymi **przed** replayem. Rozdziel liczbę jobów od liczby plików i eksportów. W poprzedniku 19/19 oznaczało zadania, nie 19 dowodów.

Jeżeli samowystarczalny replay wymaga zewnętrznego cache, zapisz to jawnie, wraz z pinami, ścieżkami i sposobem relokacji. Nie opisuj archiwum jako samowystarczalnego instalatora, gdy zawiera tylko hashe zależności. Nie pobieraj zależności poza dozwolonym środowiskiem.

Zachowaj schemat bez cyklu hashy: wcześniejszy seed/EXPECTED -> fresh replay -> zamrożony OUTPUTS -> zewnętrzny handoff. Weryfikacja po freeze zapisuje wyłącznie do nowego DEST. Nie przepisuj zamrożonego REPORT/OUTPUTS po obejrzeniu odbioru. Sprawdź kontrole błędnego pinu, brakującego/zmienionego pliku i niedozwolonej ścieżki; poprawny no-op ma przechodzić.

Końcowa odpowiedź ma podać: rzeczywisty status, wybraną Sigma_math, pełny główny typ lub brakujący typ, co udowodniono o kosztach, co pozostało parametrem, wynik replayu z jego znaczeniem, REPORT/OUTPUTS SHA-256 i brak działających własnych jobów. Nie wykonuj Git/push. Właściciel przeprowadza osobny odbiór i integrację.

---

**Kryterium sukcesu w jednym zdaniu:** z istniejących dowodów prawdopodobieństwa i operacji tabeli powstaje warunkowa redukcja dla faktycznie zdefiniowanych przeciwników i gier — bez udawania, że domknięto już sampler, oszacowania błędów albo implementację.
