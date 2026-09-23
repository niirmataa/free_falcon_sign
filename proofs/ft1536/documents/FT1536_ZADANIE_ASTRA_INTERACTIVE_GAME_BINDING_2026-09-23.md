# Astra — RUN_002: trzy konkretne zadania domykające redukcję

TASK_ID=FT1536_MATH_EUFCMA_MTISIS_RUN_002. ROADMAP_ID=T12.1 (T07–T14).
REPO=/home/footfalcon/free_falcon_sign. BRANCH=main.
BASE=5992d48416496020b51dab183982698def65a425.
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002.
Autor projektu Niirmata. Astrę uruchamia właściciel,w osobnej sesji.

## Wejścia i sposób pracy

Kontynuujesz matematykę RUN_001,nie rozpoczynasz od nowa rachunku Phi.
Źródło RO: `proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_001/output/`.
REPORT SHA `fa6bbac7b379d80c256ceb2875a67106a1d7322d84e7ee0cc6b8bddecec7de9a`.
OUTPUTS SHA `a9e3af2ebccc221035024fabc7631fa47a93b841c1611e3e79f28ccf5ee5c98f`.
Przeczytaj jego MODEL,NEXT_INTERFACE,BRIDGE_LEDGER,formal_types i odpowiednie
źródła. Uwagi właściciela/Astry Pro:
`proofs/ft1536/documents/FT1536_MATH_EUFCMA_MTISIS_ocena_20260923.md`,
SHA `1c92b1c068a967178d73da8b0fca0953ce35798f6d01218a84d9a46b4798ec52`.
To przegląd statyczny i nowe wyprowadzenia,nie wykonany niezależny Lean replay.

**Jedna sesja,jeden W,trzy części A1→A2→A3,jeden końcowy handoff.**
Nie wracaj do koordynatora po każdym lemacie. Rozwijaj i kompiluj potrzebne
moduły; pełny clean rebuild/replay wykonaj przy finalizacji i ponownie tylko
po zmianie mającej wpływ na jego wynik. Bez nowych gałęzi/worktrees/Git/push.
Zachowaj failed routes i krótkie notatki wznowienia w W,bez obowiązkowych CP.

## A1 — interpreter jednej konkretnej gry i reduktora

Zdefiniuj `ClassicalAdversary beta`, `MTAdversary`, stany,przejścia i wykonania
EUF-CMA oraz MT-ISIS. Gra ma obejmować:
- jeden klucz z muKey i jego publiczny marginal muH (nie uniform h);
- prywatne coins przeciwnika,adaptacyjne zapytania i pełny transkrypt;
- jedną tablicę H dla dowolnych Bytes*,również nazw krótszych niż nonce;
- nonce40 bytes,injective framing r||m,SeenSign także dla abortów;
- pełne odpowiedzi Sign i stopped game przy konflikcie programowania;
- **skończoną listę Q_H+1 celów** z zerami/powtórzeniami,indeksami i IO;
- finalne Verify,również gdy A nie pytał wcześniej o punkt fałszerstwa.

Honest body ma być dokładnie dotychczasowym E0/coefficient-valued finite-box
G16. Nie dodawaj Verify do Emit,nie usuwaj abortów i nie zastępuj go łatwiejszą
grą. B skonstruuj jako publiczny kod uruchamiający A i podany PublicSampler;
nie ma dostępu do sk. Reprezentację programu/interpretera i mapę do Law
określ jawnie; rekord zawierający oczekiwaną nierówność nie jest programem.

**Wyjście A1:** `Games.runEUF`, `Games.runMT`, `Reduction.build`,definicje
AdvEUF/AdvMT oraz dowody podstawowych invariantów i zgodności zdarzeń z Verify.
Nazwy są orientacyjne; dokładne drukowane typy są obowiązkowe.

## A2 — utożsamienie praw gier z istniejącym rachunkiem

1. Udowodnij lazy-sampling equivalence: kolejne niewykorzystane cele są
   uniform/niezależne względem właściwej historii. Nie warunkuj na całej
   nieujawnionej przyszłej liście. Połącz lokalny nonanticipating lemma z prawem
   pełnego wykonania,jednorazowym kluczem i rozróżnieniem public/latent history.
2. Wyprowadź prawa przejść real-stopped i sim z interpretera A1. Zidentyfikuj
   pełne K i J,AC oraz kierunek J||P. Lokalne certyfikaty nie mogą zakładać
   końcowej nierówności ani równoważności całych gier.
3. Dowiedź,że **najwyżej Q_s przejść płaci czynnik1+e**. Kroki H,A,wspólne
   przejścia i padding mają zerową stratę. Samo podstawienie n=Q_s do
   constant_adaptive_chi2 jest niedozwolone. Użyj licznika płatnych kroków,
   odpowiedniego potencjału lub dowiedzionej kompresji transkryptu.
4. Podłącz konflikt nonce do faktycznych rozmiarów tabeli interpretera i
   sprzęgnij honest z honest-stopped. Podłącz indexed_extraction do PRAWA
   wyniku `Reduction.build A S`; MT nie może pozostać dowolnym predykatem.

W tej samej części dodaj mały,konkretny most cap/Emit z uwag właściciela:

```
pi_c=1-(1-a_c)^16; L_c=accepted law PO Emit; b_c=L_c(bot)
K_c=pi_c*L_c+(1-pi_c)*delta_bot; J(c,o)=nu(c)*L_c(o)
K_c(bot)=1-pi_c+pi_c*b_c
Pr[nonabort]=pi_c*(1-b_c)
1+chi2(L_c||K_c)=(1-b_c)/pi_c+b_c^2/(1-pi_c+pi_c*b_c) <= 1/pi_c
```

Wymagaj 0<pi_c<=1; rozlicz osobno pi=1,b=0 oraz pi=0 (b=1 daje równość
praw,inaczej mismatch supportu). Dla nu(c)=0 nie stosuj niezdefiniowanego
warunkowania; sumuj po support nu. Utożsamienie L_c i nu z definicjami
PublicSimulation trzeba udowodnić,nie tylko przepisać wzór mieszaniny.

Sformalizuj też lokalny wniosek o centrowaniu: dla świeżego uniform celu i
każdego h,`freshHonest h` ma dodatnią masę wyemitowania signed16 podpisu,
który Verify odrzuci. Użyj istniejącego witnessa (9217,-5000)/(32767,18000),
dodatniej wagi i pierwszej próby. To brak bezbłędnej poprawności tego modelu,
nie oszacowanie rozmiaru błędu,atak EUF-CMA ani osiągalność w C.

**Wyjście A2:** pełne semantic/law bindings,loss exponent Q_s,nonce conflict
bound,zdarzenie MT związane z konkretnym solverem,cap/Emit joint law i jego
chi2 bound oraz dodatnia masa BadVerify w zdefiniowanym fresh modelu.

## A3 — zasoby i właściwe twierdzenie forall A,exists B

Zdefiniuj rzeczywisty model kosztu i udowodnij narzut konstruktora B:
tablica/porównania nazw,framing,challenge IO,mapa A_h,Verify/ekstrakcja,
kopiowanie danych i pamięć. Długości wiadomości i limity zapytań muszą być
uwzględnione. Nie traktuj nieskończonej funkcji celów ani noncomputable mapy
jako operacji o darmowym koszcie. Bit-cost ma odnosić się do wskazanego kodu.

Można przyjąć certyfikat LOKALNEGO publicznego samplera jako parametr:
jego kod,rzeczywiste coins,prawo,czas,pamięć i błędy. Fin coinCount nie jest
automatycznie implementacją na fair bits. Nie zakładaj kosztu całego B ani
oczekiwanego boundu AdvEUF jako części certyfikatu.

Docelowy wynik (z dokładnymi typami,nie sam szkic):

```
forall beta muKey (A : ClassicalAdversary beta) S,
  PublicSamplerCodeAndLocalCostCertificate S ->
  LocalFullJointLawCertificate muKey Sigma_math S beta e ->
  exists B : MTAdversary (publicMarginal muKey) (beta.QH+1),
    B = Reduction.build A S /\
    Resources B <= resourceBound beta S /\
    AdvEUF Sigma_math muKey A <=
      min 1 (eps_coll + phi ((1+e)^beta.Qs-1) (AdvMT B))
```

eps_coll=min(1,(Q_s*Q_H+Q_s*(Q_s-1)/2)/2^320).
Wykorzystaj istniejące Phi/monotoniczność/chi2,nie wyprowadzaj ich od nowa.
Potem dodaj corollary z jawnym zasobowym założeniem MT-ISIS. Nie dodawaj
target-guessing factor. Nie deklaruj M7/source security ani poziomu bitowego.

**Wyjście A3:** twierdzenie odnoszące się do eksperymentów A1,z dowiedzionymi
bindings A2 i zasobami B. Efektywny sampler,małe e_img/e_sign oraz most do
rzeczywistego FT1536 mogą pozostać jawnymi OPEN instancjacjami tego lematu.

## Wykonanie i kryterium końca

Lean4.34.0 + Mathlib@5ed2965256430c3649e86755f9576b54eca72435,kernelowo.
Rachunek `sage <nazwa>.sage`,preparser,ZZ/QQ/rigorous intervals. Tekst służy
prowadzeniu dowodu,nie zastępuje formalizacji. Bez sorry/admit/native_decide,
Lean.ofReduceBool,aksjomatu celu i ukrywania warnings. Przebuduj/audytuj także
odziedziczone źródła; RUN_001 nie uzyskał dotąd niezależnego kernelowego odbioru.

Wszystkie zapisy,HOME/TMPDIR/cache/build/logi pod W. Biblioteki i RUN_001 RO,
network-off podczas build/replay,jeden worker. Zachowaj uzasadnione limity
RUN_001 (Lean-j1/-M6144,AS12GiB,RSS<=8GiB,wall1800s/krok) i ich receipty.
Bez startowania innych modeli/subagentów/relay oraz bez dotykania P02.

W W/run prowadź bieżące źródła; W/output to końcowy pakiet. Zapisz MODEL,
GOAL_SPEC,FORMAL_EXPORTS,ASSUMPTIONS,RESOURCE_BOUND,BRIDGE_LEDGER i NEXT_INTERFACE
oraz zwykłe REPORT/RESULT/INPUTS/OUTPUTS,pełne sources/configs,axioms,failed
sources/logs i receipty. Jeden finalny świeży replay w nowym DEST z zewnętrznym
pinem; wszystkie produkty usunięte przed producerami. Pełna closure i raw logs.

Publiczny manifest wejść replayu w NOWYM pakiecie nazwij REPLAY_INPUTS.sha256,
aby nie kolidował z filtrem nazw archiwizatora. Nie zmieniaj nazw/bajtów RUN_001;
historyczne odwołania zachowaj w ORIGINS/BASE_PINS. Nie kopiuj cache do OUTPUTS.

Kończ COMPLETE_FOR_REVIEW po zamknięciu A1–A3. Jeśli pozostanie luka,oddaj
PARTIAL_PROOF z dokładnym brakującym typem; nie zasłaniaj jej kolejnym
abstrakcyjnym finite_trace_bound. Bez pętli ponownych odbiorów komponentów:
jedno przekazanie całości do niezależnego recenzenta,po nim import/commit
przez koordynatora. Nie uruchamiaj frozen poprzednika ani nowej kampanii dudect.
