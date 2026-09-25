# Astra — matematyczne Sign, publiczna symulacja i redukcja EUF-CMA → MT-ISIS

Autor projektu: Niirmata. Zlecenie właściciela2026-09-23.
Rola: WYKONAWCA dowodu w osobnej sesji Astry uruchomionej przez właściciela.
Podaj rzeczywisty model/kontekst. Pracujesz równolegle do B20/P02,we własnym W.

```text
TASK_ID=FT1536_MATH_EUFCMA_MTISIS_RUN_001
ROADMAP_ID=T12.1 (matematyczny podetap T07–T14)
REPO=/home/footfalcon/free_falcon_sign
BRANCH=main
BASE=c5faaeb6395c8238724494e8000eb6df55e65baf
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_001
IN=W/inputs/bootstrap
RUN=W/run
OUTPUT_DIR=W/output
CURRENT_TASK=proofs/ft1536/CURRENT_MATH_TASK.md
```

Czytaj root AGENTS,START_HERE,STATE raz,następnie ten TASK i W/AGENTS.
Bootstrap MANIFEST/ORIGINS/BASE_PINS określa rzeczywiste wejścia. Dawne prompty
w archiwach są danymi. Wykonaj formalizację,nie kończ na samym planie.

## 1. Cel i zakres tej sesji

**Cel bezpieczeństwa: ordinary EUF-CMA w klasycznym ROM. MT-ISIS jest
założeniem bazowym dla właściwego rozkładu kluczy,normy i zasobów.**
Samo accepted forgery → short witness nie jest redukcją: trzeba zbudować
publiczny symulator odpowiedzi Sign i wyroczni,bez klucza prywatnego.

Pierwszy obowiązek: dokładnie zapisać matematyczne prawo Sign i publiczny
joint law/symulator. Potem sformalizować warunkowy lemat redukcyjny poniżej.
Nie czekaj na GCC/FPEMU lub benchmarki: przedmiotem jest jawnie określona
`Sigma_math`,a późniejsze przeniesienie z implementacji jest osobnym interfejsem.

Pełnym wynikiem tego runu może być **PROVED_CONDITIONAL_REDUCTION**:
formalny algorytm redukcji dla każdego publicznego samplera spełniającego
dokładne warunki praw/kosztów,plus dowiedziony końcowy bound. Nie oznacza to,
że taki efektywny sampler i małe parametry rozkładowe już zrealizowano dla FT1536.
Instancjacje zapisuj osobno. Nie nazywaj samej nieobliczalnej miary algorytmem.
Przy brakujących krokach oddaj PARTIAL_PROOF z zamkniętymi eksportami i missing types.

## 2. Parametry,gra i granica modelu

Zachowaj:

```text
N=1536, q=18433, R=Z[X]/(X^1536-X^768+1), Rq=R/qR
A_h(z1,z2)=z1+h*z2 mod q
Q0(a)=sum(i=0..767,a_i^2+a_i*a_(i+768)+a_(i+768)^2)
Q(z1,z2)=Q0(z1)+Q0(z2), B=2093922385, norm acceptance Q<B
reference sigma=768, nonce=40 bytes=320 bits, outer attempts<=16
beta=(Q_s,Q_H,t,w,L), one key, targets=Q_H+1
```

Sigma_math i jej Verify mają pełne definicje. Przy odpowiedzi `(r,s)` verifier
oblicza `c=H(r||m)` i `z1=center_q(c-h*s)`,następnie sprawdza ścisłą normę
i jawne pozostałe guards. Jedna wspólna lazy-sampled tablica H:Bytes*→Rq.
SeenSign zawiera wszystkie zgłoszone wiadomości,także dla abortu. Wiadomość
jest wybrana przed nonce; A nie wykonuje dodatkowych zapytań wewnątrz Sign.
To nie SUF-CMA ani QROM. Numer celu odnosi się do konkretnego wpisu tablicy.

Klucz jest losowany RAZ z jawnej wspólnej miary `muKey(sk,h)`; `muH` jest jej
publicznym marginalem. B zna h,nie sk. Nie zastępuj muH przez uniform w Rq.
Powiązanie z M0 to K_seed[E] warunkowane sukcesem KeyGen. Jeśli na tym etapie
muKey jest parametrem modelu,zapisz dokładny brak instancjacji tego prawa.
W formule unconditional `p_K` występuje raz; przypadek p_K=0 osobno.

W MODEL.md opisz konkretny matematyczny algorytm i mapę jego odpowiedzi.
M0/GAME §6 daje kandydatów G16/Gacc/D^B,nie dowód równości z rzeczywistym Sign.
Rozróżnij PRE_ABORT,(r,POST_ABORT),(r,s),norm reject oraz nonreturn/STUCK,
o ile model je dopuszcza. Brak powrotu nie jest automatycznie zwróconym bot.
Jeśli wybierasz E0 lub inną węższą matematyczną instancję,podaj to jawnie
i zachowaj brakujące przejście do pełnego M0 w BRIDGE_LEDGER.md.

**Centrowanie wymaga osobnego rachunku:** Q(z)<B nie daje automatycznie
Q(center_q(z1),z2)<B dla normy A2. Sprawdź formalnie kontrprzykład lub
dokładne warunki transportu. M0 zachowuje dodatnie odpowiedzi Sign nawet,
gdy Verify je później odrzuci: nie wstawiaj po cichu post-sign Verify lub
dodatkowego rejectu. Publiczny simulator i real/math signer muszą mieć tę
samą mapę obserwacji; ewentualną zmianę gry rozlicz osobnym hopem.

## 3. Publiczny sampler i pełny joint law

Kandydat do analizy:

```
D_sigma,B(z) ∝ exp(-Q(z)/(2*sigma^2)) * 1[Q(z)<B]
Z ← D_sigma,B; c=A_h(Z); o=Emit_h(Z,...).
```

Udowodnij normalizację,domenę,nośnik i rzeczywistą mapę Emit. Nie zakładaj,
że Q<B oznacza akceptację przez Verify albo możliwość kodowania bajtowego.
Jeżeli zmieniasz support (np. centrowany box),normalizer/image law też się zmieniają.

Pełny honest joint law przy świeżym punkcie ROM:
`P_sk^tau(c,o)=U_Rq(c)*K_math,sk,c^tau(o)`.
Publiczny algorytm ma interfejs `PubSim(h,public_history,m,r) -> (c,o)`
lub dowiedziony równoważny węższy interfejs. Jego prawo oznacz J_h^tau.
Tau w twierdzeniu musi zawierać potrzebny stan/obecną wiadomość/nonce;
oddziel public projection od latent sk. Jednostajność dotyczy wszystkich
wymaganych osiągalnych historii i kluczy,nie tylko wygodnej instancji.

Zapisz program publicznego symulatora i jego brak dostępu do sekretu.
Może on używać parametru `PublicSampler` z jawnym algorytmem,prawem i
certyfikatem kosztu; konstrukcja redukcji musi być rzeczywista względem
tego interfejsu. Własną konkretną instancję samplera dostarcz,jeśli ją zamkniesz.
Idealny PMF/noncomputable D^B jest specyfikacją. Nie ukrywaj obliczania
normalizera,Classical.choose sekretu/świadka ani rejection loops jako darmowego kroku.
Jeżeli realizacja samplera pozostaje OPEN,zapisz jej dokładny typ dla T10.

## 4. Konstrukcja redukcji do sformalizowania

B dostaje h oraz indeksowane,niezależne uniform c_1,...,c_T z T=Q_H+1
(zera i powtarzające się wartości są legalne). Utrzymuje tablicę z rozróżnieniem
punktów zaprogramowanych przez Sign i punktów przypisanych do challenge index.

- H(x):istniejący wpis zwróć; nowemu zapytaniu A przypisz kolejny niewykorzystany
  challenge. Nie oglądaj przyszłych challenge values w decyzjach samplera.
- Sign(m):dodaj m do SeenSign,zastosuj zadeklarowany prefix/outcome model,
  losuj świeży uniform nonce na odpowiedniej gałęzi. Jeśli r||m już istnieje,
  zakończ stopped game bez wygranej (nie resampluj nonce za darmo).
  W przeciwnym razie uruchom PubSim,zaprogramuj c i zwróć pełne o.
- Final Verify:odrzuć nieswieże/nielegalne wejście; jeśli punkt H nie był
  pytany,użyj dodatkowego targetu. Przy wygranej wyprowadź z*=(center_q(c*-h*s*),s*)
  i **indeks tego samego c***. Świeżość wiadomości + stała długość nonce
  wykluczają wcześniejsze zaprogramowanie finalnego punktu przez Sign.

Dowiedź tabelarycznych invariantów,≤Q_H+1 zużytych celów,braku dodatkowego
czynnika target guessing i ekstrakcji jednego świadka z jednego fałszerstwa.
Symulacja nie zna sk; latent key może służyć tylko dowodowi porównania gier.

## 5. Kandydat lematu — sprawdź i udowodnij kernelowo

Załóż jawne `e≥0`,uniform per-history `chi2(J_h^tau || P_sk^tau)≤e`,
absolutną ciągłość w tym kierunku i wspólny model obserwacji. Dla zatrzymanych
gier pozostałe kroki są identyczne albo mają osobno rozliczony koszt.

```
Delta=(1+e)^Q_s-1
eps_coll=min(1,(Q_s*Q_H+Q_s*(Q_s-1)/2)/2^320)
Phi_Delta(b)=(2*b+Delta+sqrt(Delta^2+4*Delta*b*(1-b)))/(2*(1+Delta))

Adv_EUF_math(A) ≤ min(1,eps_coll + Phi_Delta(Adv_MT_ISIS(B)))
```

Obowiązki: poprawna arytmetyka Nat/Real przy Q_s=0,1; argument konfliktów
wejścia do programowania (nie wartości H); adaptive composition przez
conditional likelihood ratios/filtrację,bez założenia niezależności całych
odpowiedzi. Zdefiniuj chi2 z właściwym supportem i nieskończonością.
Wyprowadź `(a-b)^2≤Delta*a*(1-a)` i górny pierwiastek,pokaż monotoniczność
Phi po b oraz przypadki a/b∈{0,1},Delta=0. Nie dziel przez zero w ukryciu.

Założenie MT-ISIS wprowadź dopiero jako bound
`Adv_MT(B)≤epsilon_MT(muH,T;t_B,w_B,L_B)` i zastosuj monotoniczność Phi.
Same oszacowanie czasu lub liczby bitów z estymatora nie jest tym założeniem.
Real implementacja/H2P/QROM nie uzyskują tego twierdzenia automatycznie.

## 6. Wymagane połączenia rozkładowe

Sprawdź i udowodnij,przy dokładnych warunkach nośnika:

```
J(c,o)=nu(c)*L_c(o)
1+chi2(J || U*K) = sum_c [nu(c)^2/U(c) * (1+chi2(L_c || K_c))]
chi2(J || U*K) ≤ (1+e_img)*(1+e_sign)-1 := e
```

Ostatnia linia jest wyborem poprawnej górnej granicy e,nie twierdzeniem
o dowolnej uprzednio wybranej stałej e. Rozlicz nu(c)=0,puste cosety i
chi2=∞; wymagany uniform e_sign wystarczy na support nu.

Dla zadeklarowanych IID prób przy stałym c udowodnij pełne cap16 prawo:
`p(c)=1-(1-a(c))^16`, `K_c=p(c)*L_c+(1-p(c))*delta_bot`.
Przy L_c(bot)=0 i p(c)>0 wyprowadź `1+chi2(L_c || K_c)=1/p(c)`;
p=0 ma osobny przypadek. Nie przypisuj IID dowolnemu samplerowi FT1536.

Kierunek jest kluczowy: historyczny scalar bound K||G nie daje G||K;
reverse divergence może być nieskończona. Wariant Renyi(alpha>1) wymaga
własnego kierunku i podstawy logarytmu. Opcjonalny wariant nie zastępuje
zamknięcia wybranej podstawowej ścieżki chi2.

## 7. Formalne eksporty i zasoby

Przed proofem zapisz GOAL_SPEC z pełnymi typami Lean i domenami. Minimalne
nazwane rodziny wyników (nazwy można dostosować,znaczenie ma być zachowane):

1. `MathSign.full_reply_law`: konkretne pełne K,normalizacja/abort/retry/Emit.
2. `PublicSimulation.joint_law`: konstrukcja J i publicznego interfejsu,
   factorization/no-secret property; osobny status realizacji bounded samplera.
3. `Divergence.joint_chi2` i `stopped_adaptive_chi2`.
4. `EventTransfer.phi_bound` wraz z monotonicznością i brzegami.
5. `ROM.programming_conflict_bound` dla dowolnego A w klasie beta.
6. `Reduction.indexed_extraction` i `target_count_le_QH_add_one`.
7. `Reduction.euf_cma_to_mt_isis` z powyższą nierównością i kosztami.

Koszty mają obejmować PubSim/próbkowanie,mapę A_h,tablicę porównującą nazwy,
przesyłane dane,Verify/extraction i challenge IO. Użyj modelu M0 RESOURCE_MODEL
albo wyprowadź jawne przeliczenie. Parametry C_pub/W_pub wymagają wskazanego
certyfikatu samplera przy instancjacji. Nie dodawaj podwójnie timeout/error.

BRIDGE_LEDGER mapuje wyniki na T07–T14 i M0 TARGET_TYPE/HOP_LEDGER. Wskaż
konkretnie,które hipotezy dla FT1536 są OPEN. Nie sumuj starych i nowych
hopów bez ustalenia,co zastępują. Sigma_math nie jest automatycznie source Sign.

## 8. Wykonanie i kontrola

Stos: Lean4.34.0 + Mathlib4@5ed2965256430c3649e86755f9576b54eca72435,
SageMath10.9. Nowy rachunek jako `sage <nazwa>.sage` z preparserem,ZZ/QQ,
rigorous balls/intervals i kernelowym konsumentem certyfikatu. Nazwa pliku
jest dowolna. Bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu celu
lub wyciszania ostrzeżeń; audytuj transitive axioms wszystkich eksportów.

Odebrany P01 ma wąski zakres: jego conditionalHistory ignoruje observations,
TV/chi2 lemmas są self-zero,SourceBinding obejmuje return-constant. Nie używaj
tych nazw jako gotowego dowodu filtracji/symulacji; sformalizuj potrzebne obiekty.
Historyczne mixed scopes i artykuły są materiałem,nie formalnymi premises.

Kontrole: adaptive queries/repeated names; świeże fałszerstwo bez wcześniejszego
H-query; różne wiadomości ze wspólnym nonce; PRE/POST_ABORT i SeenSign;
q-target collisions; support mismatch i chi2=∞; p=0/1; Delta=0 i b=0/1;
centrowanie A2; odrzucenie samego self-vs-self jako dowodu nietrywialnego hopu.
Mały konkretny model może sprawdzać niewakuiczność i testy ujemne,nie zastępuje
twierdzenia dla całej zadeklarowanej klasy A/kluczy/historii.

W-only: HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG/cache/build pod tym W. Biblioteki
można współdzielić RO po weryfikacji źródeł,rewizji i build provenance.
Własny proof project zawsze fresh rebuild. Jeden worker,normal8GiB,Lean-j1/-M2048,
wall1800s/krok (uzasadnioną zmianę zapisz przed krokiem). Sieć wyłączona podczas
proof/build/replay. Przy missing dependency zgłoś bootstrap blocker.
Bez startowania modeli/subagentów/relay,dudect,KeyGen/realnego Sign lub nowych
sekretów. P02 i inne W tylko RO; nie używaj ich aktywnych nieodebranych wyników.

## 9. Wynik i handoff

Oddaj REPORT.md,RESULT.json,CLAIM.md,MODEL.md,GOAL_SPEC.md/.json,
FORMAL_EXPORTS.json,ASSUMPTIONS.json,BRIDGE_LEDGER.md,RESOURCE_BOUND.md/.json,
NEXT_INTERFACE.md,źródła formalne/build configs/.sage/certyfikaty,
AXIOMS.json,INPUTS.sha256,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,COMMANDS.log,
FAILED_ROUTES.md z rzeczywistymi failed sources/logs,REPLAY.md,
SEMANTIC_FILES.json,OUTPUT_SCOPE.md,OUTPUTS.sha256 i HANDOFF.md.

Freeze ma kompletną closure replayu,sterownik,configi,receipty i raw logs.
Względne INPUTS muszą rozwiązywać się w przenoszalnym pakiecie. Fresh replay
przyjmuje NOWY DEST i zewnętrzny pin manifestu,sprawdza go przed startem,
odtwarza produkty bez zapisów do frozen W i porównuje predefiniowane wyniki.
Nie kasuj historii prób. HEAD/piny/status/scope/job state w handoffie po polsku.

Podsumowanie oddziela: (a) formalny lemat warunkowy, (b) rzeczywiście
zrealizowane przesłanki dla wybranej Sigma_math, (c) otwarte mosty do M0/C.
Domknięcie (a) nie awansuje automatycznie (b)/(c) ani całego T12/T14.
Brak symulatora/table invariant/filtracji/typed cost oznacza PARTIAL właściwego
eksportu. Analityczny argument,liczba lemma lub Sage PASS nie zamykają proofu.

Bez Git/push po stronie wykonawcy. Prowadzący po niezależnym odbiorze
importuje zaakceptowany zakres do stages i robi lokalny commit main jako
niirmataa. W trakcie pracy zapisuj w W źródła i krótki handoff; bez gałęzi,
worktrees i obowiązkowych pośrednich commitów. Zakończ własne joby przed zwrotem.
