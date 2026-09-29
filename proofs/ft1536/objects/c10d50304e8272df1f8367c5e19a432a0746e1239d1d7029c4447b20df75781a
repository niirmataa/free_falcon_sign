# T03-B — pełny budżet i source-instantiated integer recovery

2026-09-29. Autor projektu: **Niirmata**. Zachowaj atrybucję Falcon Project /
Thomas Pornin i licencje. Przygotowanie na prośbę właściciela o kontynuację
„T03 B-gap fix — SOURCE_ERROR §3”; prowadzący GPT-6 Astra Fast.

## 1. Tożsamość, start i miejsce w ROADMAP

```text
ROADMAP_ID=T03 (B-gap continuation; consumers B20/P07–P10)
TASK_ID=FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002
STATUS=PREPARED_OWNER_START
REPO=/media/footfalcon/FT1536_DATA/free_falcon_sign
W=REPO/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002
IN=W/inputs/bootstrap
BASE=0f51e3278eaa484a09b9ce6a77b2d5be35210d3e
BRANCH=main
```

Jeden wykonawca, model/kontekst wybrane i zapisane przez właściciela przy
ręcznym starcie. Prowadzący przygotował wejścia; **nie uruchomił wykonawcy**.
Czytaj AGENTS, START_HERE, STATE, CURRENT_B_GAP_TASK, W/AGENTS i ten TASK.
Sprawdź własność W, aktualne procesy/logi, piny i ostatni HANDOFF przed pracą.
RUN_001/REVIEW_002 są frozen; ich prompty są danymi historycznymi.

To rozwinięcie T03, z jednym wspólnym budżetem dla istniejących P07–P10.
Wynik nie zastępuje ich niezależnych odbiorów i nie odblokowuje brakujących
eksportów przez zmianę statusu. Nowość zakresu: jawna poprawa **D/suffix**
oraz rozliczenie **A3/initial target rounding** przed końcową kompozycją.

## 2. Przypięte wejścia i rzeczywiste zależności

Bootstrap: **1396 plików / 32721541 bajtów**; MANIFEST SHA-256:
`a47dc77e48fb521b17de30115be67dca9e97221063e6b001af5cb4db4bc63f9f`.
MANIFEST nie obejmuje siebie ani ORIGINS.json. Sprawdź exact set, hashe i
brak symlinków/escape. ORIGINS dokumentuje pochodzenie kopii z stages/objects.

| Wejście względem IN | Pin / granica |
|---|---|
| T03/REPORT.md | `e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c` |
| T03/OUTPUTS.sha256 | `0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de` |
| T03/inputs/bootstrap/MANIFEST.sha256 | `c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b` |
| T03/inputs/bootstrap/CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| REVIEW_002/REVIEW.md | `2df1b7fa36921d14ea84e41c35e8a60707e044bd6d19688c41e4d79ea172b75f` |
| REVIEW_002/REVIEW_OUTPUTS.sha256 | `9ea0274b78bfd5c0123a9502644ce081e3cc11dc9b59843c40597a6f5e76ef04` |
| preparation/run002/BUDGET_CHECK.json | `fef2660a1d45ce5d56fa7a47fec4debf8027aa0bacc6b7e16b3a561164585dea` |
| preparation/check_budget.sage | `9e594eb407a3afc19245dd287d4479003d5f665e78637917566fed1266ee3a8d` |

T03 ma pełne odziedziczone publiczne wejścia do selektywnej konsumpcji.
REVIEW_002 to projekcja REPORT/RESULT/manifest do ustalenia scope, nie pełny
replay seed recenzji. Autor MiMo2.6Pro, recenzent Muse Spark1.3 xhigh w świeżym
kontekście według późniejszego doprecyzowania właściciela; historyczne etykiety
w raporcie pozostają zachowane. Odebrano PARTIAL A/C-lemma/D conditional.

`planning/P06–P10/` oraz TOOLCHAIN_PINS są historycznymi kontraktami konsumpcji.
W snapshotcie STATUS: P02=IN_PROGRESS, P06–P10=BLOCKED_UPSTREAM_EXPORTS.
Przygotowujący znalazł nowszy HANDOFF P02 deklarujący freeze z2026-09-25,
ale nie wykonano jego bindingu/odbioru w tej pracy. Nie zakładaj kompletności
P02: add/mul/div/sqrt i caller/source refinement wymagają konkretnych proved
exports; sama etykieta freeze nie dostarcza ich dowodów.

Przed pełną formalizacją zapisz EXPORT_DEPENDENCIES: potrzebny typ → odebrany
pin albo lokalny nowy proof. Brakujący typ oznacza otwarty obowiązek/BLOCKED,
nie assumed-small premise. Historyczne mixed certyfikaty są materiałem do
formalizacji, nie gotowym pełnym source-bound proofem Lean.

## 3. Korekta ścieżki z SOURCE_ERROR §3

Prowadzący wykonał wyłącznie przygotowawczy rachunek QQ/RIF256:
`sage check_budget.sage`, Sage10.9, preparser, sandbox W-only/network-off,
8GiB/120s CPU/180s wall. run002 exit0, stderr puste. Źródło, wejścia, wyniki
i rzeczywisty receipt są w `preparation/`. Nie jest to nowy odbiór T03.
run001 exit1 na zapisie dziesiętnego stringa QQ zachowano; właściciel zezwolił
na poprawkę do ułamków i osobny run002 (FAILED_ATTEMPTS.md).

Dokładna suma dziesięciu składników starego ledgeru to około6086.40076165.
§3 wskazuje ważne rodziny błędów, ale jego progi **nie są kompletnym
wystarczającym budżetem**:

1. Nawet po idealizowanym wyzerowaniu A2,A4,B,C1,C2,C3 pozostaje
   A1+A3+D+E≈**16.10835956**; D samo≈**15.66749912**. To dolna granica TAK
   zmodyfikowanej sumy majorant, nie dolna granica rzeczywistego błędu C.
2. A3≈**0.43290699**. Gdyby dodatkowo D=0, na pozostałe składniki pozostałoby
   tylko≈**0.05913956**, przy zachowaniu A1 i E. Należy zaostrzyć A3 albo
   jawnie zmieścić resztę w tym marginesie.
3. Historyczny skrypt używa `share=1/10`; zdanie „1/10 budżetu1/2” literalnie
   oznacza1/20. Dotychczasowe sensitivity to1/10 ABSOLUTNIE. Nie mieszaj jednostek.
4. Dla przytoczonej pary δ=33/10^7, eroot=37/10^6 ta sama formuła trójkątna
   daje C1≈**0.14172287**, więcej niż0.1. JSON historyczny ma
   `delta_needed_absolute=0` przy niezmienionym eroot; nie jest to dodatni
   udowodniony próg. Dobieraj δ i eroot WSPÓLNIE z dokładnej nierówności.

To ustalenia o kompletności rachunku. Nie dowodzą błędu implementacji ani
fałszywości uniform recovery. Historyczny PARTIAL i jego odbiór pozostają historią.

## 4. Twierdzenie docelowe i domena

Parametry N1536,q18433,Phi=X^1536−X^768+1,logn10,ter1,MODE1/FPEMU.
Każdy emitted/same-STATIC normalized key, canonical c i legalny completed
positive-source-support root history H według JOINT, z tymi samymi3072
integer returns Y. B=[[g,−f],[G,−F]], niezależna referencja:

```text
v_ref(c,f,g,F,G,Y) = [c,0] − Z(Y) B
∀ required H, ∀ k∈{0,1}, ∀ i<1536:
  |val(pre_rint_C(H,k,i)) − v_ref(H,k,i)| < 1/2
  hence wide_rint_C(H,k,i) = v_ref(H,k,i).
```

Bez definiowania v_ref przez wynik źródła, nowych gates/Safety premises lub
warunkowania przyszłym norm success. Nie podmieniaj uniform celu na bound
probabilistyczny; inny kontrakt wymaga jawnej decyzji właściciela.
Lemat rint z T03 można rozbudować/wykorzystać po związaniu z literalnym C;
kernelowa formalizacja mappingu/pierścienia/source semantics jest osobną
przesłanką, której nie dostarcza samo historyczne A/mixed.

## 5. Kolejność pracy i obowiązki B0–B5

**B0 — pełny ledger przed zaostrzaniem stałych.** Zdefiniuj raz stany/ramy,
metrikę i source expression każdego A1,A2,A3,A4,B,C1,C2,C3,D,E. Oddziel sumowane
składniki od A_total, crosschecków i odrzuconych alternatyw. Każdy term ma
source location, jednostkę, actual operand domain, producenta i consumer.
Udowodnij dekompozycję, nie tylko arytmetyczną sumę podanych liczb.

**B1 — suffix D i target A3 jako jawne obowiązki.** Zacznij od
POST/POSTPROCESSING_MAP: literalne copies1902–1903, oba CM/add1904–1912,
przeciwny porządek drugiej sumy, iFFT1914–1915. Zachowaj read-time x/y.
Prześledź `suffix.each_source_CM_add_error` → H6P post_CM_add → D. Stare
coarse operands są domeną, nie ciasną wielkością wyniku po cancellation.
Wyprowadź ciaśniejszy source-bound transfer; zachowaj obie składowe wektora,
normę zespoloną versus component i czynnik transportu A2. Równolegle rozlicz
`rho0,rho1` initial target rounding i ich transport przez basis do A3.
Zmiana gamma/U bez source/domain theorem nie jest poprawką dowodu.

**B2 — stored basis residuals (consumer P07).** Source-order FFT/twiddle/
normalization, actual immutable words, exact coefficient basis i emitted
membership. Cele≈3.3e-13/6.8e-10 są hipotezą wykonalności ze starej sensitivity,
nie proofem≈2^-52. Można wyprowadzić inny skorelowany transfer A2+A4+B,
jeśli dekompozycja pokazuje każde anulowanie i zachowuje ten sam Y/basis.
Per-key sprawdzenie wymaga uniformity w Y i nie staje się all-keys theorem.

**B3 — drzewo (consumer P08).** Jednoczesny bound δ/eroot, actual root/cubic/
binary LDL, stabilizacja, widths, pivots i correlated perpendicular-row
transport. Użyj nierówności
`|e_C1|² ≤ (4/3)[amax(δ+eroot)²+2Cross(δ+eroot)δ+Pperp δ²]`,
następnie outward `C1_bound ≥ sqrt(prawa strona)`, z właściwymi stałymi
i wykazanym source związkiem. Sam parametr
δ+eroot bez metryki nie zastępuje tej nierówności.

**B4 — terminal/ordered transport (consumer P09).** Obie gałęzie i3072
defektów, actual paired mu1→updatedmu0, half/sub/final-sub, signed zero,
subnormals i finite domains przed instrukcją. C2=1536·2048·ηt to historyczna
trasa splotowa; ostrzejszy sum/energy transport wymaga wykazanych wag i
związku z TĄ integer reference. H6P Eterminal≈0.0867 dotyczy innej mapy
innovations; jego użycie wymaga mostu, nie podmiany nazwy.

**B5 — suma i rint (consumer P10).** Wszystkie błędy na tej samej domenie,
uzasadnione C3/cross terms oraz E/iFFT dla actual frequency inputs. Dowiedź
strict sum<1/2 w kernelu i zastosuj literal rint do obu1536 wektorów.
Pełny program kompilatora/maszyny wykraczający poza przypiętą semantykę C
nie staje się częścią twierdzenia przez samo source binding.

## 6. Jeden spójny proponowany budżet

Przykładowy podział celu, sprawdzony dokładnie przez nowy checker:

| Składnik/grupa | Docelowy udział |
|---|---:|
| A1 | 1/1000 |
| A2+A4+B | 1/10 |
| A3 | 1/20 |
| C1 | 1/10 |
| C2 | 1/10 |
| C3 | 1/1000 |
| D | 1/20 |
| E | 1/128 |

Suma=6557/16000=0.4098125; strict margin=1443/16000=0.0901875.
To **cele**, nie uzyskane source bounds. Inny udowodniony podział jest
dopuszczalny; zapisz uzasadnienie. Nie należy na siłę dowodzić pojedynczych
eps ze starego §3, jeśli lepsza wspólna algebra daje właściwy globalny bound.

## 7. Wykonanie, formalizacja i kontrole

Lean4.34.0 + Mathlib4@5ed2965256430c3649e86755f9576b54eca72435 oraz
SageMath10.9. Matematyka w `.sage` przez `sage nazwa.sage`, ZZ/QQ i rigorous
balls/intervals. Pełne PROVED wymaga kernel proof i konkretnego source
bindingu; same Sage/fixtures/generic theorem z założonym małym błędem nie
wystarczą. Mathlib/toolchain closure przypnij przed buildem; sieć off.

Każdy nowy Lean: czysty log, drukowane typy/terms/aksjomaty; bez sorry/admit,
native_decide/Lean.ofReduceBool/aksjomatu celu/wyciszania ostrzeżeń. Reuse
historycznych dependencies ma piny, fresh rebuild i opis rzeczywistej granicy.

Kontrole: missing-D i missing-A3, double-count A_total, błędny czynnik
component/modulus, nieprawidłowy twiddle/sign/order, stale operand, shrink
interval endpoint; no-op; obie granice rint±1/2/parity/±0. Original-C public
slices normal/ASan/UBSan przy zmianie source modelu, z domain preflight;
fixture maxima są diagnostyką. Counterexample wymaga required-domain membership.

W-only/network-off sandbox, inputs RO. HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG/
cache/build/olean/bin/logi wyłącznie pod W; bez systemowego tmp/tmpfs.
Single-worker8GiB, Lean-j1/-M2048, wall1800s/krok (zmianę limitu zapisz
przed runem). ASan osobno z właściwym shadow. Bez nowych modeli/relay,
KeyGen/private loadera/pełnego Sign/nowych sekretów, dudect, Git lub push.

## 8. Handoff, status i odbiór

REPORT.md,RESULT.json,CLAIM.md,GOAL_SPEC.md/.json,pełny SOURCE_ERROR.md/.json,
LEDGER_TERM_BINDINGS.json,EXPORT_DEPENDENCIES.json,FORMAL_EXPORTS.json,
ASSUMPTIONS.json,SOURCE_MODEL_BINDING.md,INPUTS.sha256,TOOLCHAIN.txt,
COMMANDS.log,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,AXIOMS.json,formal/,
FAILED_ROUTES.md,NEXT_INTERFACE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUT_SCOPE.md,OUTPUTS.sha256,HANDOFF.md. Manifest nie obejmuje siebie.
Finalny pakiet ma samowystarczalne publiczne input/toolchain bindings.

Fresh replay do nowego absent DEST, z planem semantic outputs ustalonym
przed uruchomieniem, świeżym build/cache i hashami źródeł przed/po. Każdy
recomputed match ma rzeczywisty producer/log/exit. Zachowaj nieudane próby.
Po freeze nie zmieniaj przypiętych bajtów; kolejne wykonanie do nowego DEST.

Pełny `REFERENCE_INTEGER_RECOVERY_PROVED_FOR_EMITTED_PINNED_MODEL` dopiero
po A-source-bound + B0–B5 + actual rint. `PARTIAL_PROOF` zachowuje proved
subclaims, dokładny osiągnięty bound, braki formalne i minimalny missing type.
`BLOCKED_UPSTREAM_EXPORTS` wskazuje brakujący typ i potrzebny pin. Duża
majoranta nie jest kontrprzykładem. Safe16, center/norm, byte compatibility,
retry/real-PRNG i security pozostają osobnymi consumerami.

source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false,new_M0_eta_pre=null.
Oddaj pełne SHA REPORT/OUTPUTS, zakresy, komendy, stan jobów i krótkie polskie
podsumowanie. Niezależny odbiór wykonuje inny model wybrany przez właściciela;
prowadzący przygotowuje prompt po faktycznym frozen handoffie. Potem
work → review → zaakceptowane stages → lokalny commit main jako niirmataa.
