# Niezależny odbiór F04 wariant A + F05

**Werdykt pakietu: CHANGES_REQUIRED.** Matematyczna naprawa F04/F05 jest
poprawna pod jawnymi przesłankami źródłowymi. Własny świeży rebuild zakończył
się 167/167 exit 0, bez diagnostyk kompilatora. Jednak literalne kryterium 1
prompta nie jest spełnione dla całych 167 modułów: historyczny, nieużywany
przez naprawę `SelectBitPreserve` wnosi dodatkowy aksjomat natywnego
`bv_decide`. W closure znajduje się także historyczne lokalne wyłączenie
lintera w `ThetaBox`. Nie można wydać bezwarunkowego PASS dla tak opisanego
pakietu ani twierdzić, że wszystkie 167 modułów używa tylko standardowych
aksjomatów.

To nie jest kontrprzykład F04/F05 ani stwierdzenie fałszywości twierdzeń
bitowych. Jest to rozbieżność z zadeklarowaną granicą zaufania i warunkami
odbioru. **21 konkretnych deklaracji wskazanych w tym odbiorze ma wyłącznie
standardowe aksjomaty.**

## Przypięty cel i niezależność

- Repo: `/media/footfalcon/FT1536_DATA/free_falcon_sign`, `main`.
- HEAD wejściowy i końcowy: `d053369e081d1e8b35630f736072286095876e43`.
- Naprawa: core `832a9953`, konsumenci `46761f1d`, koszty `5f907a43`,
  F05 `0a8693d1`, notes `63b81a3c`, checkpoint `35420d59`, prompt `d053369e`.
- TASK: `inputs/PROMPT_REVIEW_F04_ROM_A.md`; W tego raportu jest odrębne od
  W/build autora. Polecenie właściciela w tym czacie: „no to odbierdxz”.
- Recenzent: bieżąca sesja Codex GPT-6, nieautor naprawy w tej sesji.
  Trzech pomocników otrzymało w izolowanych kontekstach surowe źródła,
  bez werdyktu autora: model/prawo joint, koszty/PRG, F05. To pomoc w
  rozdzieleniu obowiązków, nie dowód statystycznej niezależności modeli.
  Wersja modelu autora nie jest poświadczona metadanymi badanego pakietu.
- Źródeł autora, zamrożonych stages i indeksu Git nie zmieniano. Brak
  importu, commita, tagu, push i owner acceptance w tym odbiorze.
- Repo miało zastane cudze zmiany; ich lista jest w
  `evidence/git_status_initial.txt` i `evidence/git_status_final.txt`.

## Karta twierdzeń i zależności

F04: dla każdego `S,h,st,m,r`, na świeżej gałęzi podpisywania,

`q(c,o) = U_Rq(c) * Pr[w ← U_{Bool^S.bits}, S.code h st m r c w = o]`.

`sample` wykonuje to prawo, marginal challenge jest `U_Rq`, a conditional
przy każdym `c` jest `replyLaw … c`. Znormalizowane skończone prawa są nad
`ℝ`; wyzwanie jest idealnym prymitywem ROM poza skończoną taśmą szumu.
`RomChallengeAt` ma dowód dla każdego `S`. Dalsze certyfikaty odpowiedzi
pozostają warunkowe na `ReplyShapeAt`, `AttemptPointwiseAt`, odpowiednie
warunki O-NONE i budżety. Nie dowodzimy istnienia efektywnego publicznego
samplera realizującego te przesłanki dla zadanego challenge.

Łańcuch: `Games.Sampler/sample` → `LawBinding.replyLaw/samplerLaw/sample_law`
→ `JointDecomp.marginal_joint/condOf_joint/samplerLaw_marginal_uniform`
→ `HacGlue.romChallengeAt/replyAt_eq_replyLaw` → cztery certyfikaty HacGlue,
ONoneGeometry → pięć Assembly → dwa AdvPrg. Wszystkie liście specyficzne
dla realizacji odpowiedzi są jawnie przesłankami, a nie dostarczonym
bindingiem C.

F05: `target,mach : BoxPair → ℝ`, `L=t5lo`, `H=t5hi`. Celem jest
punktowe `L*target ≤ mach ≤ H*target`. Trzy nowe implikacje korzystają
odpowiednio z: błędu absolutnego, floor tylko przy `target>0`, osobnego
`hzero` i dwóch budżetów; błędu względnego bez floor; albo `TowerWhole`
z floor na włóknie i zerami maszyny poza nim. Wnioskiem jest `MachineStage`,
nie pełne `AttemptPointwise` ani wiązanie rzeczywistego samplera.

Łańcuch F05: `Sandwich`/`MachineStage` i `TowerWhole` →
`towerWhole_iff/support/nonneg`, `towerLo>0`, `gaussianWeight_pos` →
trzy nowe lematy. Nie było potrzebnego niezweryfikowanego zewnętrznego
twierdzenia literaturowego.

## Numerowane kontrole prompta

1. **Replay — wykonany; pełne kryterium aksjomatów/wyciszeń NIE SPEŁNIONE.**
   Własny `replay.py` pobrał wszystkie 167 źródeł przez `git show` z HEAD,
   sprawdził je względem hashy receiptu autora i bieżących bajtów, następnie
   zbudował w pustym własnym `.build/check_lib`. Żadne project oleans autora
   nie znajdowały się w `LEAN_PATH`. Reużyto bibliotek toolchain/Mathlib,
   nie ich nowego builda. Lean 4.34.0, Mathlib
   `5ed2965256430c3649e86755f9576b54eca72435`, checkout Mathlib czysty.
   Czas 396.924 s; 167/167 exit 0, zero compiler warnings/errors. Z 573
   wydrukowanych wpisów aksjomatów trzy mają dodatkowy aksjomat opisany
   w rozbieżności R1. Własny audyt 21 wskazanych deklaracji: standard only.
   Nie znaleziono aktywnych `sorry`, `admit`, `native_decide`, `sorryAx`
   w źródłach; ten skan sam nie wykrywa natywnego aksjomatu `bv_decide`.
   Historyczna opcja lintera jest opisana w R2.

2. **Model ROM — PASS w modelu idealnym, na świeżej gałęzi.**
   `Games.lean:98–110`: challenge jest osobnym wejściem, `sample` losuje
   `c`, potem szum. `LawBinding.lean:25–46,104–124`: reply law, joint i
   execution binding. `JointDecomp.lean:166–198`: dowód marginalu przez
   normalizację odpowiedzi; `:176–186,289–295` rozlicza dodatniość uniform
   marginalu w conditional. `HacGlue.lean:135–149` dostarcza
   `romChallengeAt`, bez nowej przesłanki. `Games.lean:135–157` zapisuje to
   samo `c` w ROM. Przy cached wpisie honest używa zapisanej wartości,
   a signSim/stopped honest abortuje. Nie przypisujemy jednostajności
   cached odpowiedzi warunkowanej wcześniejszym transcript.

3. **12 konsumentów — PASS.**
   Nowe sygnatury nie zawierają `huc` ani `UniformChallengeAt`:
   HacGlue `:460,485,506,528`; ONoneGeometry `:269`;
   Assembly `:359,394,419,441,464`; AdvPrg `:503,524`.
   W `JointDecomp:375–399` pozostał binder nazwany `huc` w generycznym
   helperze na marginal law. Nie jest to stary niemożliwy interfejs:
   HacGlue `:511–512` przekazuje tam dowiedzione `romChallengeAt S`.
   Nie został przeniesiony jako obowiązek callerów. Nazwa deklaracji
   `UniformChallengeAt` nie istnieje w aktywnym kodzie closure.

4. **Encoding, koszty i hprg — PASS jako wariant A.**
   `PublicEncoding:106–126` ma osobne `field c` na wejściu i samą odpowiedź
   na wyjściu, ≤26113 bitów. `SamplerMachine:12,33–63` używa właściwych
   capów. `LocalMachineCode:69–119` zachowuje argument `c` w certyfikacie
   i erasure. `MachineExecution:33–40` i `MeteredExecution:76–84` sprawdzają
   świeżość nazwy przed challenge i szumem. `MeteredExecution:41,49–54,133`
   fakturuje `challengeCost`; `PrefixResources:60–83,166–188` go konsumuje.
   To zadeklarowany koszt prymitywu ROM, nie dowód skończonej fair-bit
   implementacji dokładnie jednostajnego Rq. `CompPrg:397–404,575–689,
   719–938` losuje challenge poza oknem szumu i dowodzi uniform seam;
   `tapeWidth=qs*S.bits` dotyczy tylko szumu. Publiczne reply i maszynowe
   certyfikaty nadal wymagają osobnej realizacji źródłowej.

5. **F05 — PASS dla trzech implikacji, bez aplikacyjnego source bindingu.**
   `T5Pointwise:695–724` oddziela dodatni support i zera;
   `:730–745` dowodzi relative form; `:752–776` przenosi floor na fiber
   przez `TowerWhole`. Własne `SupportChecks.lean` dowodzi kernelowo
   `target z>0 ↔ A z=c` przy TowerWhole oraz że względny błąd sam wymusza
   `mach z=0` przy `target z=0`. Wszystkie trzy własne lematy mają
   standardowe aksjomaty. Nowe formy nie wymagają globalnej dodatniej
   podłogi i nie kolidują z zerami poza włóknem. Na skończonym BoxPair
   istnieje dodatnie minimum dodatniej gaussianWeight; dla danego
   TowerWhole daje to realizowalny support floor z `mach=target,E=0`.
   Ten ostatni argument egzystencjalny jest audytem matematycznym,
   nie nowym źródłowym boundem ani dodatkowym przeprowadzonym proof Lean.
   Stare `machineFloor>991` nie zostało użyte w nowych implikacjach i nie
   może być automatycznie podstawione za floor wag. Globalna sprzeczność
   starej wersji wymaga punktu poza włóknem — zachowujemy ten warunek.

6. **AssemblyComp — PASS dla nienaruszonego eksportu.**
   `AssemblyComp.advMT_ge_of_public_sim_stream_win` ma standardowe
   aksjomaty, bez huc w typie, i należy do własnej przebudowanej closure.
   Plik przed naprawą i w HEAD jest identyczny: SHA256
   `b6112bef9c093439acdd7ee01b9aefa8f797b18738140e99306f045d25795929`.
   Nie rozszerzamy jego wniosku poza public simulation.

7. **Historia i piny — PASS integralności.**
   17/17 pinów jest zgodnych zarówno z HEAD, jak i z podanymi commitami
   źródłowymi. Receipt i log audytu autora mają zadeklarowane hashe.
   Zachowano 13 prób: run_001..run_011 i final_clean_001/002;
   1529 zapisanych kroków. Źródłowe snapshoty i dostępne logs zgadzają się
   z receiptami, łącznie 2052 dodatkowe zewnętrzne pliki wejściowe przypięte
   w `INPUTS.external.sha256`. Nie uznajemy incremental skips za fresh
   replay. Wczesne błędy obejmowały LawBinding, Assembly, MeteredExecution,
   stare scratch files, F05 proof branch oraz import Source3. Ich materiały
   zachowano. Historycznych shared oleans poszczególnych prób nie
   weryfikowano jako zachowanych binariów; receipt podaje ich dawne hashe,
   a źródła i logi są zachowane. Własny rebuild nie zależał od tych oleans.

8. **Scope i otwarte obowiązki — PASS z doprecyzowaniem granic.**
   Niezależny graf importów potwierdza dokładnie sześć wyłączeń autora:
   `Probe`, `Run2.Scratch`, `Run2.rawBadEnclosure` oraz trzy pliki FftBind
   zależne od Source3. Żaden included moduł ich nie importuje.
   `ReplyShapeAt`, source-defined sampler, byte bridge, additive-error
   contract oraz `hzero`/`hrel` nie są dostarczone przez tę naprawę.
   Nie powstaje pełny dowód bezpieczeństwa schematu. W Assembly nadal
   LHS jest idealne `Games.AdvEUF`; `hkey : keyIdent` jest ignorowane,
   a hprg użyte tylko do nieujemności budżetu (`:359–388`). Istniejące
   `ChaCha20PRFBound` kwantyfikuje wszystkie zdarzenia, a jego support
   bound pozostaje w `AdvPrg:648–665`. To granice B1/B2/F06, nie nowe
   regresje F04 i nie domknięcie computational hopu.

## Rozbieżności i zalecenie dla właściciela

**R1 — blokuje literalny odbiór całych 167 modułów.**
`SelectBitPreserve.lean:32–34,58–61` oraz własny
`replay/logs/166_SelectBitPreserve.log` pokazują, że `select_bits_equiv`,
`select_old_eq_new` i `select_code_variants_equiv` zależą od
`select_bits_equiv._native.bv_decide.ax_1_5`, poza standardową trójką.
To samo widnieje już w logu autora. Nie jest to regresja F04; reverse
import graph potwierdza brak konsumentów tego modułu. Poprawka pakietu:
albo dostarczyć dowód bez dodatkowego aksjomatu, albo jawnie zawęzić
odbierany build do właściwej closure F04/F05 i wyłączyć ten niezależny
diagnostyczny moduł z twierdzenia „standard only”. Następnie przypiąć
nowy zakres i evidence. Nie należy maskować problemu skanem samego
słowa `native_decide`.

**R2 — historyczny wyjątek narzędziowy do jawnego rozliczenia.**
`ThetaBox.lean:166` lokalnie ustawia
`linter.constructorNameAsVariable false`. Było to już w baseline przed
`832a9953`; źródło nie zostało zmienione przez naprawę. Własna kopia z
włączonym linterem kończy się exit 1: „maximum recursion depth has been
reached” w linterze. Potwierdza to opisany historyczny problem narzędzia,
nie błąd matematyczny dowodu. Cały build zachowuje ten wyjątek, więc
blanket claim „zero wyciszeń” wymaga korekty zakresu/opisu albo rozwiązania
problemu lintera bez wyłączenia. Testowa kopia i jej błąd są zachowane;
nie zmieniano źródła autora.

**Rekomendacja: zmiany wymagane w pakiecie odbioru przed tagowaniem.**
Najtańszy następny krok to rzetelne doprecyzowanie zakresu R1 i
historycznego wyjątku R2, z nowymi pinami, albo usunięcie obu zależności
z audytowanego zakresu; potem tylko ukierunkowany recheck zmienionego
evidence. Nie ma podstaw do zlecania od nowa całego matematycznego F04/F05.
Zakres, który po tym można tagować: idealny fresh-ROM wariant A, 12
przepisanych sygnatur, noise-only koszt/PRG seam i trzy warunkowe
implikacje F05. Bez full source bindingu, pełnej public simulation,
byte bridge i computational-security claim.

## Komendy, dowody wykonania i granice zaufania

Główne uruchomienie z repo:
`python3 -B proofs/ft1536/work/FT1536_F04_ROM_A_REVIEW_001/replay.py`.
`REPLAY_RECEIPT.json` zawiera dokładne argv wszystkich 167 wywołań,
wersje, hashe źródeł i logów, wyniki oraz czas. Każdy Lean miał wall
timeout 1500 s, bez oczekiwania na busy guard. Nie ustawiano dodatkowych
limitów CPU/RAM; compilation przebiegła sekwencyjnie. Procesy widoczne
przez shell były izolowane przez sandbox, więc process scan nie jest
globalnym dowodem braku jobów hosta.

`EXTRA_CHECKS_RECEIPT.json` zapisuje trzy dalsze polecenia:
ReviewerAudit (exit 0), SupportChecks (exit 0), ThetaBoxLinterEnabled
(oczekiwany diagnostyczny exit 1, timeout 30 s nie został osiągnięty).
`evidence/REVIEWER_AXIOMS.json` zawiera wszystkie 21 wyników aksjomatów;
`REPLAY_LOG_AUDIT.json` rozlicza 573 wpisy z pełnego replayu.

Nie wykonywano nowych oszacowań numerycznych ani testów Sage; nie ma tu
zamiany dowodu przez skończony eksperyment. Nowe kontrole matematyczne są
uniwersalnymi lematami Lean; Python służył wyłącznie snapshotom, hashom,
grafowi importów i uruchamianiu/rejestrowaniu kompilatora.

## Ocena po polsku

F04 usuwa rzeczywisty konflikt modelu: challenge nie musi już być dokładnie
jednostajnym obrazem skończonej taśmy dwójkowej, bo jest osobnym idealnym
losowaniem ROM. F05 usuwa konflikt dodatniej podłogi z zerami poza włóknem,
zachowując konieczne obowiązki maszyny. To wartościowa naprawa interfejsów
papera, ale nie nowy dowód bezpieczeństwa rzeczywistego Sign. Otwarta
pozostaje najtrudniejsza część: realizacja odpowiedzi, jej supportu i błędów
przez przypięte źródła oraz właściwy argument obliczeniowy PRG.

Mam wysokie zaufanie do tego wąskiego wyniku po własnym replayu,
odczycie dowodów i audycie aksjomatów; nie ufam bez poprawki szerszemu
opisowi „167 modułów, standardowe aksjomaty, bez wyciszeń”.
