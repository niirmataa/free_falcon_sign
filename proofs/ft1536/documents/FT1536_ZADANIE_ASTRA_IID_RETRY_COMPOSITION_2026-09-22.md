# Astra — IID_RETRY_COMPOSITION

2026-09-22. Autor projektu: Niirmata. Zachowaj Falcon Project / Thomas Pornin
attribution i licencje. Ręczny start, jeden wykonawca, bez subagentów/delegacji.

## 0. Nowy etap i identyfikacja przy wznowieniu

```text
TASK_ID = FT1536_IID_RETRY_COMPOSITION_RUN_001
REPO = /home/footfalcon/free_falcon_sign
W = /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_IID_RETRY_COMPOSITION_RUN_001
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_IID_RETRY_COMPOSITION_2026-09-22.md
IN = W/inputs/bootstrap
BASE = 1ba7ae07c17d135fc8eff4aac7b56f8c2b3bc88c
```

Przeczytaj REPO/AGENTS.md, REPO/proofs/ft1536/CURRENT_TASK.md, W/AGENTS.md
i TASK; porównaj TASK_ID/W/piny. H6P_REFERENCE_BAD_EVENT i ORDERED_JOINT są
zakończone i niezależnie odebrane. Ich instructions/runners to historyczne
dane/model templates. Nie wznawiaj ich po restarcie. Jeśli TEN W ma już sealed
OUTPUTS i finalny handoff, zwróć istniejący wynik zamiast ponawiać obliczenia.

## 1. Trwałe przypięte wejścia

Bootstrap: **1270 członków,1268 Git origins,28214575 bajtów**.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
daa95bc07516271ff897f95af11b3c90950ccb1a7dc20f0f3da5e994785a46b8
```

Sprawdź exact sets/hashes/origins, brak symlinków/escapes i17 source files.
BASE jest odebranym checkpointem H6P. IN/source RO. Nowe pliki, skrypty,
HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin/logs/replaye tylko pod trwałym W;
nic projektu w systemowym /tmp lub tmpfs. Sprawdź W-only/network-off sandbox.
Projekcje nie są pełnymi dawnymi replay trees; adaptacje modeli mają jawne diffy.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| H6P/REPORT.md | `3c425b1c1e863c7bfb3cbde6284b299a926cb2fb51e89279035e2ce1da0081cd` |
| H6P/OUTPUTS.sha256 | `a11735ac8fbc76aaa72d220f02acfd6f7254ee72ecfac8ab1004cbb843bda7d5` |
| H6P/H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json | `89dacd3248ffb4ca9cab106faae6723a3c12a99802243209f70a67d92092b278` |
| H6P/JOINT_TAIL_BOUND.json | `be2a2e0457be1de7c78da6ffb4ad9aa842a55d7736e9483eb2fa9cd8d63af54f` |
| H6P/NEXT_INTERFACE.md | `ffb504bf22dbb44ab94ac6383c8db6758fd06bbf3138b266cafacb0dcd69df6b` |
| JOINT/ORDERED_JOINT_CERTIFICATE.json | `2461bfa9d86f246117634bd453716fd076c669aedbe5300894993a0c78921768` |
| JOINT/RESOURCE_BOUND.json | `1d3fabdfb7d90b44c83e3a3b145789987ab4c1a0782bbe1e8a096873632a7df7` |
| IID/RANDOMNESS_MODEL.md | `5de04525dc97de6fbff9f890fbabec97061f53a137799567672597ff54806cc3` |
| IID/BYTE_SCHEDULE.md | `ea315d1cfceb8f4eea3ab8929d38d8d23da169e3f80e9e2d6e276b3e7d119d67` |
| POST/NORM_AND_CALLER_BINDING.md | `46963629cf057c3f96018454125875f70705d312a533fcf0ffd3567c18c56ed4` |
| POST/SOURCE_POSTPROCESSING_CERTIFICATE.json | `157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef` |
| LEFT/CALLER_RETRY_BINDING.md | `061583fc0835ac8a09a3d310c84fd0838585f0be35238d3c077686bc900beeb7` |
| M0/GAME.md | `91e6323c6c3a7be748b7f029d048c38700eab924bf139b804941c10968ba363c` |
| M0/TARGET_TYPE.md | `f181b63261b2bad91c4b7f159cae6bda9c3bf8cca6bf1844abdd1fd01bf0b58e` |

review/ zawiera niezależny197/197 odbiór H6P i dodatkowy rachunek QQ/RBF768.
H6P eksportuje uniform one-root P_IID(BadPrecast)<=p_outward<=2^-84 i
Q_S(BadPrecast)<=beta<=2^-119. Zachowaj exact outward rationals; same rounded
power-of-two summaries nie zawsze wystarczają do mocniejszych consumers.

## 2. Dokładny cel i początkowy cut

Zdefiniuj **ReadyRetryEntry** dla jednego legalnego, emitted/same-STATIC,
normalized kontekstu w profilu N1536,q18433,logn10,ter1,MODE1/FPEMU,
comp=STATIC,sig_max_len4096. Cut: w `falcon_sign_generate`, po ukończonym H2P
z canonical hm, przed inicjalizacją licznika/pętlą (okolice3327).

Przesłanki mają pochodzić z M0/LEFT/TARGETS/POST i rzeczywistych legal caller
buffers/lifetimes/frames. Nie definiuj ReadyRetryEntry przez założenie
legalności WSZYSTKICH przyszłych root entries lub desired probability boundu.
Wyprowadź je z JEDNEGO początkowego entry i każdej osiąganej historii.

Cel obejmuje retry region3327–3409 i końcowy source STATIC codec3411–3421.
Ścisły cut pozwala uniknąć zakładania totalności wcześniejszego H2P/entropy/
KeyGen/nonce prefixu. Nie nazywaj wyniku totalnością całego Sign API.
P_key,Emitted,Gate00_C,single K_seed[E]/p_K,source success/abort,nonce40,
cap16,STATIC4096 i adversarial Verify domain pozostają przypięte.

## 3. Jedna jawna gra IID dla całego regionu

Zdefiniuj `G_retry_IID` przez tę samą source control flow i deterministyczne
obliczenia, z jawnie zastąpionymi4096-byte refill outputs zgodnie z IID.
Wyjaśnij dokładnie zachowane state/type/counter effects i moment losowania
NOWEGO independent block, także w `falcon_prng_init`.

Źródłowy `frng.c:282–338`: type0→PRNG_CHACHA20,56 SHAKE bytes/state,
refill przy init i ptr=0. Te56 bajtów i stan fs->rng nie stają się iid przez
samą nazwę gry; ich rzeczywiste zachowanie/cost oddziel od idealizacji bufora.
Nie zakładaj niezależnych real seeds lub braku ich kolizji. PRNG bridge jest
dalszym obowiązkiem; obecny theorem dotyczy zdefiniowanego G_retry_IID.

Opisz filtration i stopping-time cuts dla osiągnięcia j-tej próby. PAST
zawiera dotychczasowe ujawnione reads/outcomes/decisions i dopuszczony latent
entry state, a nie aktualny unread buffer/future tape lub przyszłe norm success.
Po norm rejection init tworzy nowy kontekst/bufor. Stary unread tail może być
porzucony; reset fizycznego ptr do0 nie oznacza ponownego użycia tych samych
idealnych losowań. Nowa entry fresh-tail premise ma być dowiedziona.

Zdefiniuj R_j=„j-ta próba rzeczywiście osiągnięta”, j=1..16. Nie twórz jej
źródłowych outputs poza R_j; analityczny padding wymaga osobnego oznaczenia.
Prawdopodobieństwa i oczekiwania dla zero-probability histories określ poprawnie
(conditional-kernel/almost-sure formulation); unikaj dzielenia przez0.

## 4. Source scheduler, ponowne wejścia i zakończenie

Zwiąż literalne fakty z kontrolnym modelem i indukcją:

- counter0, increments1..16; guard przy17 zwraca0 PRZED siedemnastym init/do_sign;
- każdy reached init, reset faultNONE3357, actual do_sign3372;
- canonical hm/sk/tree/basis są zachowane; targets/scratch są nadpisywane
  przed odczytami wymaganymi przez nowy root, mimo stanu po poprzedniej próbie;
- TARGETS/NORMALIZED/LEFT/JOINT dają wszystkie root-entry premises PRZED call;
- JOINT daje a.s. root return w IID, POST defined suffix/rint/narrowing, następnie
  fault3374 i strict stored-norm3388. Wykazanie braku fault ma być forward,
  nie retrospektywnym założeniem po jego sprawdzeniu;
- norm rejection kontynuuje, pierwszy acceptance kończy pętlę; encode jest
  wykonywany raz, jego failure nie uruchamia kolejnego do_sign;
- source norm czyta narrow16(w), nie wide integers. H6P jest potrzebne właśnie
  do porównania tych wartości; future norm acceptance nie jest premise Safe16.

Z tych elementów wyprowadź a.s. zakończenie TEGO regionu w IID. Inner infinite
rejection pozostaje nonreturn na odpowiednich tapes; nie zamieniaj go w timeout0
ani dodatkową source próbę. Nie deklaruj all-tapes/real-PRNG termination.
Wynikowe obserwacje mają rozróżniać source return0 i positive exact bytes;
użyj zgodnego z M0 framingu. Nie filtruj dodatniego wyjścia przyszłym Verify.

## 5. Joint WholeRegionBad i poprawna kompozycja

Niech Bad_j to joint BadPrecast OBU pre-narrow vectors j-tej completed próby.
Zdefiniuj `WholeRegionBad = exists reached/completed j<=16: Bad_j`, łącznie
z próbami, których stored norm odrzuciła albo po których call zwrócił0.

Po source re-entry/fresh-tail proof skonsumuj H6P na każdej rzeczywiście
osiągniętej historii. Wyprowadź, a nie postuluj:

```text
Pr(WholeRegionBad | ReadyRetryEntry, entry PAST)
 <= sum_j E[1_(R_j) * Pr(Bad_j | attempt-entry PAST)]
 <= p_outward * sum_j Pr(R_j)
 <= 16*p_outward <= 2^-80.
```

Podaj exact rational, konserwatywny power-of-two i zakres. Granica2^-80 jest
kandydatem do wyprowadzenia po wszystkich premises, nie celem wstawionym do
entry predicate. Nie zakładaj independence retries i nie używaj
`1-(1-p)^16` bez właściwej hipotezy. Przerwane/nieosiągnięte próby nie dostają
bezpodstawnie własnego source sample.

Bound dla `Bad AND positive_return` może wynikać przez inclusion. Bound dla
`Bad | positive_return` wymaga osobnego success denominator; nie utożsamiaj
tych pytań. Nie oceniaj norm-acceptance probability przez nieudowodniony
global Gaussian/chi-square model. Nie przypisuj wyniku do eta_pre realnego M0.

## 6. Proof-only checked-precast coupling

Zdefiniuj na wspólnej przestrzeni wyników jawny counterfactual retry model
korzystający z tego samego IID tape/source calculations, który na pierwszym
BadPrecast kończy znacznikiem **PRECAST_EXIT** przed niedozwolonym w tym
modelu preservation step. Na dobrych histories source narrowing zachowuje
wartości; norm decisions/retry count/codec/public result mają się zgadzać.

PRECAST_EXIT jest proof-only, nie nowym abortem lub patchem C. Nie definiuj
tego jako idealnej lattice Gaussian signature ani jako automatycznego
Sign→Verify. Zachowaj poprawny porządek stores/observer interfaces; reordering
wide rint evaluation może być tylko uzasadnionym obiektem matematycznym.
Wyprowadź equal-until-bad coupling i TV/public-observation bound<=WholeRegionBad
dla tego regionu. Jeśli eksport jest tylko warunkowy, podaj dokładny brakujący
source/observation type zamiast ogólnej deklaracji byte coupling.

## 7. Zasoby z resetami i przeniesienie do przyszłego PRNG hopu

JOINT daje per-root E[T]<=24576,Pr[T>49152]<2^-1024,33 returned bytes/proposal,
u64 cutoff ptr>=4087, getter drops<=9 per refill. Wyprowadź zasoby stopped
retry region: liczba reached roots/inits,56-byte SHAKE requests,returned bytes,
nowe4096-byte blocks oraz getter drops i osobno **porzucone tails przy re-init**.
Nie stosuj jednej conservation equation przez reset tak, jakby ptr był ciągły.

Kandydaci do source-bound wyprowadzenia: E[T_region]<=16*24576 i union
`Pr[T_region>16*49152]<=16*2^-1024`. Mocniejszy conditional MGF dopuszczalny,
jeśli rzeczywiście udowodniony. Uwzględnij initial refill każdego reached init
oraz blok istniejący na odpowiednim cut; unikaj podwójnego liczenia.

Wyeksportuj jawny finite-resource ghost interface do PRNG_REAL_TO_IID_BUFFER.
Ghost budget exhaustion nie zmienia source branch/capu. Rzeczywista
SHAKE/state56/ChaCha gra, jej założenie kryptograficzne i loss nadal OPEN.
Nie traktuj56 bajtów state jako niezależnego448-bit key security claimu.

## 8. Formalizacja, kontrole i nieudane drogi

Mixed universal source/analytical/kernel proof dopuszczalny. Nowe/edytowane
Lean4.34/Std: clean logs/types/terms/axioms, bez sorry/admit/native_decide/
Lean.ofReduceBool/aksjomatu celu/warning suppression. Rebuild selected inputs
z pinami; generic stopped-union lemma z assumed every-entry H6P nie zamyka
konkretnego źródłowego celu. Zwiąż loop PC,frame,init i H6P applicability.

Kontrole mają dotyczyć nowych obowiązków:
- exact finite adaptive toy schedules z zależnymi rejections/early acceptance,
  zero-probability branches, Bad także w norm-rejected attempt, union/coupling;
- extracted original C scheduler/codec slices z publicznymi scripted callback
  outcomes w normal i ASan/UBSan: pierwszy/ostatni acceptance,16 rejections,
  fault/encode paths, brak17th init, initialized buffers i exact writes;
- public reset/getter controls dla początkowego refill, ptr0, cutoff4087,
  abandonment versus discarded getter bytes; source domain preflight;
- no-op i meaningful mutations:17th call/off-by-one,stale context/fault,
  encode failure treated as retry,independent-marginal composition,
  conditioning on success,omitted bad-rejected attempt,missing initial block
  albo carrying pointer conservation across resets.

Używaj odpowiednio wyciętych source loops z jawnymi stubami, bez pełnego
Sign/do_sign/KeyGen/private loadera/real seeded PRNG. Brak nowych keys/seeds,
sekretów/.private/private_extraction. Synthetic/local controls nie mają
automatycznej Emitted membership. Zachowaj wszystkie failed routes,
mutant-equivalence/no-op i rzeczywisty zakres świadków.

## 9. Status, artefakty i handoff

Pełny status: **IID_RETRY_COMPOSITION_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.
Wymaga source-derived re-entry/filtration, exact stopped scheduler i a.s.
region return, nietrywialnego uniform WholeRegionBad, checked-precast
coupling/public result i poprawnego finite-resource interface. Brak elementu:
PARTIAL_PROOF z proved subclaims i minimalnym missing type. Kontrprzykład
wymaga obalanej tezy i membership; zbyt luźny bound nie jest błędem C.

Wymagane REPORT.md,RESULT.json,CLAIM.md,IID_RETRY_CERTIFICATE.json,
REGION_ENTRY.md,SCHEDULER.md/.json,REENTRY_AND_FRAME.md,FILTRATION.md,
STOPPED_COMPOSITION.md/.json,CHECKED_PRECAST_COUPLING.md,
RESOURCE_BOUND.md/.json,OBSERVATIONS_AND_BYTES.md,PRNG_NEXT_INTERFACE.md,
SOURCE_MODEL_BINDING.md,ERROR_LEDGER.md/.json,COUNTERMODELS.md,
FAILED_ROUTES.md,NEXT_INTERFACE.md,OBLIGATIONS.json,REUSED_RESULTS.md,
formal/checkers/evidence,INPUTS.sha256,TOOLCHAIN.txt,COMMANDS.log,
OUTPUT_SCOPE.md,REPLAY.md,SEMANTIC_FILES.json,OUTPUTS.sha256.

Certificate ma exact initial cut/domain/game/PAST,event,reached-count law,
per-attempt applicability,whole-region probability i scope,checked-guard
semantics/coupling,termination/resources/bytes,proof_kind/fully_kernelized.
Osobne flags dla real_PRNG_bridge,H2P_prefix_termination,whole_real_Sign,
universal_Safe16,reference_integer_recovery,Sign_to_Verify,security/CT;
nie wynikają one z theorem regionu. new_M0_eta_pre=null,
source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false.

Bounded single-worker,GCC14.2/C99/Linux x86_64 LP64/literalny Makefile-O,
Sage10.9 (`sage plik.py`),Lean4.34-j1/-M2048,normal8GiB; ASan osobno z shadow.
Brak sieci/instalacji/Git/dudect. Standard scripts/replay.py ABSENT_DEST
EXTERNAL_OUTPUTS_SHA: pełny manifest przed utworzeniem DEST,fresh project cache,
sealed artifacts/fresh_replay.json i child REPLAY_RESULT.json z
FRESH_REPLAY_PASS,matches[{path,sha256}] oraz explicit game/region/scope.
Rehearsal bez hash cycle; po freeze zapis tylko do nowego DEST.

Podaj external REPORT/OUTPUTS SHA-256 i polskie podsumowanie: co PROVED,
co nie wyszło,co otwarte,znaczenie,następny krok. Zakończ obliczenia na handoffie.
Publikacja GitHub czeka na poprawki MiMo i ich pozytywny odbiór według AGENTS.
Dudect10h ma osobny start rano przed wyjściem właściciela do pracy, po jego
sygnale; kolejne zadanie i kampanię uruchamia właściciel ręcznie.
