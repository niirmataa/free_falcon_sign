# GOAL_SPEC — INTERACTIVE_GAME_AND_RESOURCE_BINDING (przed dowodem)

Task: FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001. Baza: zamrożony
FT1536_MATH_EUFCMA_MTISIS_RUN_001 (PARTIAL_PROOF), piny w
`inputs/bootstrap/PREV_VERIFICATION.json`. Ten plik jest specyfikacją celu
napisaną PRZED wykonaniem, nie listą gotowych wyników.

## 0. Zakres zmiany ścieżki wykonania

W tym wykonaniu W leży pod `/home/footfalcon/Obrazy/...` (decyzja właściciela
2026-09-23), poza repo. Nie zmienia to treści matematycznej żadnego celu.
Wszystkie odwołania do `REPO/proofs/ft1536/work/...` oznaczają RO bazę.

## 1. Przedmiot twierdzenia (bez zmian wobec MODEL.md poprzednika)

Sigma_math = E0 / coefficient-valued finite-box G16 / klasyczny direct-output
ROM: N=1536, q=18433, X^1536−X^768+1, sigma=768, ścisły próg Q<B=2093922385,
`A_h(z)=reduce(z1)+h*reduce(z2)` (reszta wielomianowa z `Relation.lean`),
box współczynników −65535..65535 z wagami `PublicSimulation.lean`, do 16 IID
prób przy stałym c, pojedynczy Emit (z2 albo POST_ABORT), jedna sól 320-bitowa
na Sign, `muKey` jednorazowe, `muH` jego marginal, ordinary freshness
(każde zgłoszone m w SeenSign, także po abort). Verify = signed16(s) oraz
Q(center(c−h*s),s)<B.

## 2. Przeciwnik klasyczny, ograniczony (Etap A)

`Adv(beta)`: jawny program interakcji — maszyna stanowa z prywatnymi losowymi
bitami (skończona taśma, budżet `randomBits`), krok `step : State → Reply →
coins → State × Query`, `Query = hquery bytes | signquery m | done`, oraz
końcowy fałszerstwo `(m*, s*)`. Adaptacyjność bez ograniczenia do stałej listy
pytań: następne pytanie jest dowolną funkcją dotychczasowych odpowiedzi.

Budżet `beta = (Q_H, Q_s, t_A, w_A, L_A, randBits, maxNameLen, maxMsgLen)`:
alfabety wynikają z budżetów (długości nazw/wiadomości ograniczone, liczba
kroków maszyny ograniczona). Nowe zakończenie `budget_exceeded` należy do
definicji gry ograniczonego przeciwnika; nie zmienia gry dla A w budżecie.

Atomowość Sign: zapytanie niesie w pełni ustalone m przed solą; maszyna sama
losuje `r : Fin (2^320)` i wykonuje dokładnie jedną odpowiedź — brak
reentrancy i brak ujawniania nonce przed ustaleniem m.

## 3. Front-end bajtowy jednej tabeli (Etap A)

- `toBytes40 : Fin (2^320) → Fin 40 → Fin 256` bijekcja (256^40 = 2^320);
  `nonceName r = List.ofFn (toBytes40 r)` dokładnie 40 bajtów.
- `signName r m = nonceName r ++ m`; `shortName b` dla `|b| < 40`.
- Rendering do literalnych `List (Fin 256)` jest iniektywny:
  krótkie nazwy mają długość <40, nazwy Sign długość ≥40 ⇒ brak kolizji
  krótkie↔Sign; wewnątrz Sign: rama długości 40 + `fixed_length_framing`
  + iniektywność `toBytes40`; wewnątrz krótkich: równość list.
  Dłuższych nazw nie obcina się (tablica porównuje całe listy).
- Jedna tablica nazw `List (Fin 256)`, lookup zwykłym równaniem list
  (zgodność z literalnymi ciągami bajtów wykazana lematem render↔lookup).

## 4. Trzy gry (Etap A)

1. `EUF_real`: niezmieniona Sigma_math, jedno muKey, jedna leniwa tablica H;
   przy konflikcie nazwy Sign z tablicą używa istniejącego wpisu (zwykła gra).
2. `EUF_stopped`: jak wyżej, lecz wewnętrzny STOP bez wygranej przy konflikcie
   świeżo wylosowanej nazwy Sign z tablicą; STOP jest stanem absorbującym
   (padding), nie zwracanym PRE/POST_ABORT.
3. `SIM_targets`: reduktor `B = reduce(A, S)`; wejściowy wektor
   `targets : Fin (Q_H+1) → Rq`; każdy nowy H zużywa ≤1 cel (odczyt
   `targets[used]` z poprzednim dowodem `used < Q_H+1`), cached H nie zużywa,
   Sign programuje z S, końcowa świeża nazwa zużywa ≤1 dodatkowy cel.

Obserwacje: pełne odpowiedzi (w tym oba abort tagi); STOP niewidoczny jako
PRE/POST_ABORT. Wewnętrzna liczba prób, monety S i czas odpowiedzi nie są
obserwacjami. Koszt jest osobną metryką.

## 5. Wektor celów i lazy sampling (Etap B)

Stan fizyczny B zawiera całą listę; filtracja dowodowa ujawnia cele w kolejności
odczytu; publiczny stan przekazywany S to (h, historia operacji, własne dane
publiczne B, m, r) — bez sk, monet A i nieujawnionych celów (egzekwowane
typem `PublicState`).

Lokalne prawo jednostajności: rozkład `targets[used]` względem przeszłości, od
której zależy następna operacja, to uniform na Rq; niezależność od
nieodczytanych prefixów. Forma: konstrukcja sekwencyjna (IID uniform draws)
równoważna z wejściowym wektorem (refinement), `hash_nonanticipating`
uogólniony na zgodność na odczycie `range used`.

## 6. Jądra lokalne i licznik Q_s (Etap C)

Lokalny certyfikat jednego wywołania S w świeżym punkcie:

```
J_S = pushforward monet S przez S.run(h, pubState, m, r)
P   = uniform_Rq(c) * Sigma_math.signBody(h,c)(o)
AC(J_S, P)   oraz   second(J_S, P) <= 1+e,  e >= 0
```

pełna para (c,o) z POST_ABORT, dokładny stan dostępny S. Certyfikat jest
parametrem twierdzenia (jak w §1 zlecenia).

Główny nowy lemat: `second(Law_SIM_trace, Law_EUF_stopped_trace) ≤ (1+e)^Q_s`
przez **lemat licznika płatnych przejść**: kroki wspólne mają identyczny kernel
(`second p p = 1` dokładnie), płatne przejścia to dokładnie wywołania Sign
(końcowy segment wspólny), więc iloczyn lokalnych drugich momentów ma ≤Q_s
czynników `1+e`; wcześniejjsze zakończenie = stan absorbujący/padding.
Nie podstawiamy mechanicznie n=Q_s do `constant_adaptive_chi2`.

## 7. Konflikt, wygrana, ekstrakcja (Etap D)

Per-i-taśma: przed i-tym Sign tabela ma ≤Q_H+i nazw ⇒ ryzyko konfliktu
`≤ (Q_H+i)/2^320` (`fresh_nonce_conflict` + uśrednianie + `accumulated_conflicts`
+ `collision_sum` podpięte do interpretera, z realnymi rozmiarami tabeli).
Sprzężenie EUF_real↔EUF_stopped do pierwszego konfliktu daje
`AdvEUF_real ≤ eps_coll + Pr_stopped[Win]`.
W SIM_targets `indexed_extraction` daje j<T i świadek `(center(c−h*s),s)`;
prawo zwróconego wyniku B jest utożsamione ze zdarzeniem MT symulatora
(MT nie jest dowolnym predykatem). Q_s=0, Q_H=0, cached/fresh final H,
powtórzone/zerowe cele, oba aborty, odrzucenie końcowe — jawnie.

## 8. Zasoby reduktora (Etap E)

Maszyna bitowa: t (bit steps), w (bits), L (port bytes), M≤Q_H+Q_s+1 wpisów.
Interpreter kosztowy liczy realne operacje: tabela (porównania całych nazw),
kopie danych, SeenSign, odczyt całej listy Q_H+1 celów (jeden wybrany model —
wejściowa lista; bez darmowego streamingu), monety samplera/nonce + exact
uniform, mnożenie/reszta/modulo, centrowanie, Verify, ekstrakcja, kodowanie
indeksu/świadka. Suma wynika ze składania lokalnych kosztów (konkretne funkcje
w `RESOURCE_BOUND.md/.json`), nie z pola rekordu. A i S mają własne certyfikaty
kosztu jako założenia metatwierdzenia; koszty signBody należą do semantyki
wyroczni.

## 9. Deklaracja końcowa (plan typu głównego)

```
forall beta muKey (A : Adv beta) (S : PublicSamplerCode)
       (certS : LocalFullJointLawCertificate muKey Sigma_math S beta e)
       (costS : LocalPublicSamplerCostCertificate S),
  e >= 0 -> AdversaryResourceCertificate A beta ->
  let B := reduce A S in
    PublicExecutableMTAdversary B (muH muKey) (beta.Q_H+1)
    ∧ ImplementsDefinedReduction B A S
    ∧ Resources B <= derivedResourceBound beta S
    ∧ AdvEUF Sigma_math muKey A
        <= min 1 (eps_coll beta
                  + Phi ((1+e)^beta.Q_s - 1) (AdvMT (muH muKey) (beta.Q_H+1) B)))
```

z `eps_coll = min 1 ((Q_s*Q_H + Q_s*(Q_s−1)/2)/2^320)` i
`Phi D b = (2b+D+sqrt(D²+4Db(1−b)))/(2(1+D))`.
Kierunek zdarzeń: J_sim ‖ P_honest_stopped; strata konfliktów POZA Phi.
Wariant `forall A, exists B` wynika z konstrukcji `B := reduce A S`.

Niedopuszczalne przesłanki (koło): globalna nierówność chi² transkryptów,
sukces ekstrakcji całej gry, poprawność symulatora, bound Resources(B),
oczekiwana końcowa nierówność. Dozwolone: normalizacja muKey, lokalny
certyfikat S.run i kosztu, lokalne AC/moment dla właściwych h/historii,
budżet A, odrębna hipoteza trudności MT-ISIS.

## 10. Osobne osie statusu

Pełna analityka ≠ kernelizacja ≠ instancjacja samplera/małych e ≠ bridge do
C/FPEMU. Brak bit-cost lub interpretera ⇒ `PARTIAL_PROOF` + nazwany brakujący
typ. Flagi wg §9 zlecenia; `independently_reviewed`/`owner_accepted` nie są
flagami autora.
