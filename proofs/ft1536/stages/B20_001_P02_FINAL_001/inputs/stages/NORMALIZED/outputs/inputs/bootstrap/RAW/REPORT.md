# FT1536 H3_RAW_ASSEMBLY — raport końcowy

2026-09-20. Autor projektu: **Niirmata**.

## Wynik i dokładny cut

**H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL**.

Domknięto actual defined terminating raw prefix `load_skey` dla
q18433/logn10/ter1, do chwili powrotu `ffLDL_fft3` w falcon-sign.c:1253.
W niezmienionej domenie **P_key + LegalRawExpansionBuffers** otrzymujemy:

-6144 słowa basis, bitowo równe SourceFFT_B w fizycznej kolejności[g,−f,G,−F];
- całe **18432 raw tree words**, zgodne z actual source snapshots ROOT,
  dwóch NODE3, sześciu NODE2 i dwunastu actual inner7;
- **16896 finite internal L words i1536 positive finite raw leaves**;
- poprawne source order, layout, read moments, input/basis/root Gram frame
  i zakończenie, bez założenia completed prefixu;
- emitted/same-STATIC-decode corollary przy legalnych buffers.

Jest to **MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF**.
`raw_prefix_fully_kernelized=false`, `C_compiler_verified=false`.
Kernelowa kompozycja jest wsparta pełną actual numerical/source-memory
instancją w COMPOSITION.md; sam generic theorem lub suma18432 nie stanowią
uzasadnienia statusu. Nie pozostała niewykazana numerical/earlier-termination
przesłanka w wymaganej domenie.

Cut leży PRZED stable rebuild i normalization. Raw leaves są literalnymi
source subtractive pivots, nie późniejszymi stored widths.

## Baza, piny i sandbox

BASE `6ed89cac3249bdfe6d874c6616fd2899f4b3ef6a`.
Źródłem jest archived FLOOR_CT candidate, nie zastany Extra/c:

```text
CANDIDATE.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
TASK SHA-256
f667184425ee1b00d19d9a5fde757b66b607ff698dd611245b1a361174f7bf1f
bootstrap MANIFEST SHA-256
5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4
```

Zweryfikowano exact set308 członków,306 publicznych origins Git,5907504
bytes i wszystkie17 source hashes. INPUTS obejmuje312 publicznych records
z TASK/AGENTS/manifestem. Historyczne projekcje zachowują własne bazy OUTPUTS.

Rzeczywisty bwrap: writable tylko W, bootstrap/source RO, network-off,
osobny PID namespace. Odczyt mountinfo i próby open bez zapisania bajtów
potwierdziły scope; RO źródeł ponownie sprawdzono w replayu. HOME/TMP/DOT_SAGE/
LEAN_PATH/cache/olean/bin są lokalne. Jeden bounded worker, normal8GiB,
Lean4.34/Std-j1/-M2048, ASan oddzielnie z shadow. Nie wykonano Git, instalacji,
sieci, KeyGen, Sign, rzeczywistego private-key API lub dudect. Użyte publiczne
synthetic arrays nie są nowymi kluczami; nie czytano prywatnych danych.

## Jawny source transport

PREVIOUS_SOURCE pin2553358f… i nowy56974571… różnią się tylko ciałem
fpr_floor.16 plików identycznych; odwrócenie dokładnego FLOOR patcha
odtworzyło poprzedni header242a7027…. Cała reszta headera, w tym functions,
macros i tables, jest byte-identical. Nie oparto transportu na samych nazwach.

Active preprocessing siedmiu TU i konserwatywny call graph:39 raw-prefix
functions,140 emitted KeyGen functions. Floor jest nieosiągalny w obu;
jedyni callers to BerExp/sampler/sampler_large. Static-name collisions
między TU rozliczono przez union edges i osobne body hashes. Decoder/
serializer/gate/NTT bindings zachowują te same źródła i profile. Historycznych
certyfikatów nie przepinano. Floor CT nie zostało przeniesione na loader/Sign.

## Dlaczego kompozycja jest actual i niekołowa

1. P_key coefficient caps najpierw dają exact conversions i defined FFT3/
   Gram. Guard q/logn/n pozostaje po FFT; fixed parameters wyprowadzają jego
   wynik. Root g00 facts pochodzą z tego istniejącego prefixu i Gate00.
2. Branch0 SplitTop/Adj/LDL3 i wszystkie jej children kończą się PRZED root
   dim2. Do jej domain nie użyto przyszłego root D.
3. Każdy inner8 ma kolejność: first split/Adj → actual inner7 → input frame
   → local level8 LDL → read/split d11 → drugi actual inner7. To konsumuje
   TOWER totality z jawną instancją Good/base/step/frames, nie założony return.
4. Node3 d11/d22 pozostają żywe przez wcześniejsze sequential children.
   Ich buffers są niżej niż lower child scratch, więc można wyprowadzić
   domenę i odczyt kolejnego child po zakończeniu poprzedniego.
5. Pełny branch0 frame daje niezmieniony root Gram. Dopiero teraz wykonane
   root dim2 ma actual input równy ROOT slice i wyprowadza dodatni D.
6. Drugi SplitTop czyta całe D przed Node3 reuse storage. Branch1 składa się
   analogicznie; nie zakłada się zachowania starego root D po reuse.
7. Dopiero po tych powrotach uzyskuje się source s=18432, bitowe matching,
   rozłączne pokrycie stores i końcowe klasy words/frame.

Numeric instancja używa ROOT correlations, NODE2 refined root imaginary<1
i mocnego TOWER INIT, nie iteracji coarse c2. Branch0 Node3 real lower127/256,
branch1 lower28. Fresh Sage/QQ/RBF256 sprawdził wszystkie6 refined S8 i1524
lower records; denominator interval[1/16,2^35], positive margins, scalar
caps2^100, half/subnormal behavior i outward rounding. Wynik numeric jest
byte-identical odebranemu TOWER certificate. Wszystkie raw leaves mają
wyprowadzone positive finite bounds (uniform branch0>49/100,branch1>27).

Memory: sk24576 words, tmp10752; tree zaczyna się w6144. Top scratch3584
od gxx4608, czyli high-water8192. Root L[0,1536), B_b=1536+b*8448,
A_bk=B_b+1536+k*2304, inner7 starts A_bk+256+e*1024. Sprawdzono2301
coverage blocks i1536 leaf positions, z literalną sekwencją read/store.

Emitted corollary konsumuje pełne ROOT binding: caps, exact NTRU integer
lift z final modular check, G-present STATIC roundtrip tych samych bytes
i mandatory Gate00. Nie wzmacnia P_key, nie zmienia jednego K_seed[E] na
K_iid i nie dodaje allocation-success conditioning.

## Kernel i kontrole

Lean: **33 moduły,180 twierdzeń,33 nowe**;28 inherited modules byte-identical
i przebudowane. Wszystkie final logs czyste. Pełne nowe types/terms oraz
axioms wszystkich konsumowanych deklaracji zachowano. Tylko standardowe
propext/Classical.choice/Quot.sound; bez sorry/admit/native_decide,
Lean.ofReduceBool, aksjomatu wniosku lub warning suppression.

```text
RawAudit.stdout SHA-256
943e8e0ac5ecff42f08e1442d0e78835220bff2c84bd23266e2a1c7ed76c6b7f
RawTypes.stdout SHA-256
c3a4e824006461cad82c52375708cdde0df991c1950b051685852ba818b99bdb
```

C normal oraz ASan/UBSan: **PASS** dla sześciu publicznych fixtures:
trzy synthetic Gram i trzy synthetic coefficient arrays, również legalne
read aliases. Original ffLDL_fft3 oraz literalny raw-prefix slice z diffem
do1253; helpers wywołane raz przez observers. Nie wykonano pełnego loadera.
Sprawdzono wszystkie18432 tree i6144 basis words, wszystkie intermediate
poly outputs/source-order events, base stores, input preservation, canaries,
scratch high-water i raw leaf map. LSan nie jest deklarowany.

Niezależny checker używa integer FPEMU transducers i flat-memory modelu,
nie drugiego wywołania C. Pełny source-domain preflight poprzedza native
call. Coefficient fixtures mają NTRU constant coefficient2,2,1 zamiast18433:
nie są P_key/emitted witnesses. Zgodność skończonych kontroli nie zastępuje
uniwersalnej instancji wyżej.

No-op: PASS w modelu i native. Pięć wykonanych model mutations odrzucono:
pominięty child, przesunięty offset, realny leaf swap, spóźniony snapshot
root D i niedozwolony zapis root frame. Mutacje nie są tylko filtrowaniem
expected trace; zachowano ich pełne states/streams. Cztery invalid cases
(zero divisor, nonfinite, short coefficients, buffer end) zatrzymano przed
native call; to kontrole rozszerzonej domeny, nie P_key counterexamples.

## Replay i freeze

Świeży pre-freeze replay: **FRESH_REPLAY_PASS,195/195** semantic matches,
70.806 s,409 seed members, bez olean/bin/cache. Odtworzono źródłowy transport,
Sage certificate, cały kernel, modele/fixtures, C normal/sanitizers,
mutacje i końcowy RawPrefixCertificate. Pełne receipts zachowano.

```text
Rehearsal anchor SHA-256
3d230a9e3a7e240bd46b98033a92eb69b4db7f12721f0ea06fb67c6836bcc93e
artifacts/fresh_replay.json SHA-256
4e7c683529954f095f646f40a40f4e2e0a09c476ea994285b97a94cf104bcabd
RAW_PREFIX_CERTIFICATE.json SHA-256
d2e6662b1ca88cc023a62cb2e42fbc0267e98c0db70329c5c84866c88b8df94a
```

Zachowano pierwszą błędną analizę zderzenia static names i dwie nieudane
elaboracje RawComposition (reserved prefix / nadmierne unfolding). Finalne
źródła i logi są poprawione i czyste; historia nie została odfiltrowana.

OUTPUT_SCOPE określa exact manifest, frozen completed prefix COMMANDS
i wyłączenia cache. Standard replay sprawdza zewnętrzny pin i wszystkie
bajty przed nowym DEST; wynik musi odtworzyć195 path/SHA. Po freeze kontrola
readonly pakietu zapisuje receipts wyłącznie w nowym tmp DEST. REPORT/
OUTPUTS hashes są przekazane zewnętrznie bez cyklu i bez dopisywania do pakietu.

## Handoff i następny typ

RAW_PREFIX_CERTIFICATE/LEAF_MAP/MEMORY_LAYOUT/NEXT_INTERFACE są gotowym
wejściem następnego etapu: **P_key + RawPrefixCertificate → actual stable
rebuild/normalization, exact stored width sequence, sqrt/inverse/scaling
domains/gates i preserved internal L/basis**. Actual normalization nie jest
w source osłonięta nowym if(stable_ok); zachować tę kolejność.

normalized_expansion_proved,full_private_loader_proved,H3_range_proved,
global_reachability_proved,sampler_law_proved,security_reduction_proved,
full_sign_ct_proved=false. Nie użyto niekwalifikowanego full_internal_tree
statusu dla post-normalize loadera. source_changed=false,
production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Odbiór/import/commit należą do prowadzącego.
