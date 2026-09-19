# GPT-ASTRA — H3_NODE3: split_top → Adj → LDL_dim3

Data: 2026-09-19. Autor projektu: Niirmata.
Kontynuacja tej samej rozmowy po odebranym H3_ROOT_LDL.

## 0. Jeden cel następnego etapu

Wyprowadź **jednostajny źródłowy certyfikat pierwszego poziomu LDL3** dla
OBU root branches i wszystkich256 fizycznych częstotliwości każdej branch.
Konsumuj dokładny typ z ROOT/NEXT_INTERFACE.md: split_top(logn10), Adj
oraz rzeczywisty LDL_dim3(logn9,full0), z dodatnimi dzielnikami/pivotami,
boundami L10/L20/L21, błędami i propagacją części urojonej.

ROOT_LDL ma ukończony certyfikat korzenia w zakresie mixed proof;
niezależny replay131/131,17 modułów/99 twierdzeń (17 nowych). Jego root
positivity pochodzi z korelacji determinantowej przy obliczonej FFT macierzy,
nie z luźnego absolute error2^22. Zachowaj ten mechanizm przy nowej kompozycji.

Ten etap kończy się na NODE3. Wyjścia mają być gotowym interfejsem dla
split_deep/niższych nodes. Initial targets, ordered Reach i sampler law
mają osobne obowiązki. Wykonaj zadanie do raportu, freeze i standard replayu.

## 1. W, baza i komplet wejść

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_NODE3_RUN_001
IN = W/inputs/bootstrap
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_NODE3_2026-09-19.md
BASE = 3d6bf58b833d729983718f80da020118fa94188a
```

Przeczytaj REPO/AGENTS i lokalny AGENTS; potwierdź cwd, rzeczywisty sandbox
wyłącznie W i brak drugiego wykonawcy. REPO ma wcześniejszy checkout/indeks;
źródłem zadania jest IN/source, nie REPO/Extra/c. Nie operuj na Git.

Publiczny zestaw `proofs/ft1536/background/H3_NODE3_2026-09-19/` ma106
oryginałów Git oraz ORIGINS/README, czyli108 członków manifestu. Gotowy
bootstrap jest bajtowo identyczny. **Zewnętrzny pin IN/MANIFEST.sha256:**

```text
426db8a67b74de0de0141a8d9ca406fca7a2bdad45a42e97a913bad4d62b6ca3
```

Zweryfikuj wszystkie piny, dokładny zbiór plików i proweniencję:

| Wejście w IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| ROOT/REPORT.md | `0d79129b04b192bca97a1aa3f6bbdce3153767b7673934335a1895509dc8f39c` |
| ROOT/OUTPUTS.sha256 | `9894d5f10e11f65ff7da338881c71d8008456ef4c371d45bb2119f5cd66abc48` |
| ROOT/NEXT_INTERFACE.md | `1e17e35ecbb91c410ec66f95d773c62933c1e8234283494228aac46223584952` |
| ROOT/ROOT_CERTIFICATE.json | `fd2130d53bdd7f580924110018dc04ed429733b4ce66e6bde6e2d75381c77f76` |
| ROOT/ANALYTIC_PROOF.md | `e2caa8b9d7996a241bee2e6bb8a478eadf031279860cdaf586daa3473ed69ef7` |
| ROOT/EMITTED_BINDING.md | `7dd3be1172eb31f6b497a709d9299492e1731e139e515446c25c271e563a57a5` |
| ROOT/ROOT_FRAME.md | `921d254b6da9d91978e8e44cbfbf11e721b89e12208a91979cfa169157a4d681` |
| ROOT/artifacts/numeric_certificate.json | `5190ddf21d676ebf1045a35c29b9600b26ee461aa86b58e0d2012d6db8564c10` |
| ROOT/scripts/backend.py | `81415d92a73474efcbcc414c9f5ec80c85a3a328dcd377a9d088438bf87fa870` |
| ROOT/scripts/root_model.py | `7bb30b17f7f73771f6a40b4bed156e8a3005409402da39af6a68b4f7f5f316b3` |
| source/falcon-fft.c | `06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063` |
| source/falcon-sign.c | `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8` |
| source/fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| source/fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| review/VALIDATION.sha256 | `507562db7454e8db06d0d1e26eb81654d37bd73eeda28e1db3ec18934dcdc24d` |

To projekcja potrzebnych wejść, nie pełne stare replay tree. Oryginalne
OUTPUTS/VALIDATION zachowują własne bazy. Skopiowane członki ROOT/ZERO/H3/M0
zweryfikowano wobec ich manifestów; legacy także wobec LEGACY_CONTEXT.
Adaptuj skrypty do nowego W z diffami/pinami; nie uruchamiaj ich w IN.
Nowy replay ma działać bez starego W, Dokumenty/H/USB i worktree prowadzącego.

## 2. Zachowana dziedzina i to, co już wolno konsumować

N1536, q18433, Phi=X^1536-X^768+1, sigma768, B2093922385,
MODE1/FPEMU i dokładne flagi Makefile. M0: caller4096/nonce40,16 attempts,
jeden K_seed[E] i parametryczny cel. Żadne źródło lub gate nie jest zmieniane.

`Key4` to cztery Int^1536 vectors. **P_key jest dokładnie predykatem ROOT**:
ternary f/g, caps2047 dla F/G, exact NTRU i rzeczywisty Gate00_C.
Emitted_C + source decode tego samego STATIC sk implikuje P_key w zakresie
przejrzanego source-analytic bindingu. Nie dodawaj small-L, dodatnich node3
pivotów, przyszłego norm acceptance lub NumericCenter do P_key.

Konsumuj RootCertificate wraz z jego warstwą dowodu i korelacjami:

```text
S = RootSlice_C(p)
branch0: v=S.g00, real in[1/2,2^23), imag raw+0; error to exact A <1/1024
branch1: v=S.d11, 32<Re(v)<2^31, |Im(v)|<32; error to exact q²/A <2^22
correlated envelope: |S.d11-|det(Bhat)|²/a| <=256*2^-48*j
```

Tutaj a,c,j są exact Gram obliczonej FFT macierzy, z relacjami i bounds
wyprowadzonymi w ROOT. Używaj ich jako powiązanego rekordu. Zastąpienie go
niezależnymi worst-case boxes może zgubić istotny margines dodatniości.

Nie powtarzaj całego KeyGen/FFT/NTT wyniku, jeśli jego piny i przesłanki
pasują. Każde reused theorem/certificate ma dokładny statement/domain,
proof layer i opis konsumpcji. Nowe rozszerzenie domeny ma własny dowód.

## 3. Teza do rozstrzygnięcia

Zachowaj następujący kwantyfikowany typ (operacyjny, do formalizacji/bindingu):

```text
exists c3 : Node3Constants,
  ValidConstants(c3) and
  forall p : Key4, P_key(p) ->
  forall b : Fin2,
    let S := RootSlice_C(p);
    let v := if b=0 then S.g00 else S.d11;
    let (t0,t1,t2) := SplitTop_C(v,10);
    let u1 := Adj_C(t1,9,0); let u2 := Adj_C(t2,9,0);
    Defined(SplitTop_C;Adj_C;LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0)) and
    forall j : Fin256,
      Node3Certificate(c3,j,t0,u1,u2,LDL_dim3_C(...),
        ExactSplitAndSchur(if b=0 then A(p) else q²/A(p),j)).
```

Jeden jawny rekord racjonalny c3 musi działać dla wszystkich p,b,j. Może
zawierać osobne ustalone pola obu branches; nie może być dopasowany do
konkretnego klucza lub obserwacji. ValidConstants wymaga STRICTLY positive
lower bounds dzielników/pivotów i skończonych nonnegative error budgets.

Node3Certificate obejmuje:
- defined/finite wszystkie faktycznie wykonane instrukcje i source words;
- zakresy real slots t0 oraz d11 i d22, z dodatnimi dolnymi granicami;
- klasę dodatnich dzielników użytych w każdym div, w tym nowego d11;
- component/modulus bounds L10,L20,L21 i wszystkie pośrednie operand caps;
- błędy wobec niezależnego exact split/3x3 Schur, ze skalowaniem i kolejnością;
- osobne imaginary bounds dla t0/d11/d22 i właściwych pośrednich danych;
- raw-bit layout i legalne buffers/aliasing w przypiętym C/modelu.

Te numerical properties mają być WNIOSKAMI. Założenie potrzebnego pivot
margin lub small error w poprzedniku daje co najwyżej partial. Jeśli pełny
typ się nie domyka, podaj najbliższy udowodniony interface i brakującą
nierówność. Nie relabeluj innego lub silniej warunkowego celu jako powyższego.

## 4. Źródłowy program i niezależny exact reference

Wiąż source spans/hashes co najmniej:
- falcon-fft.c1275–1322: split_top, sześć finalnych mul przez rzeczywiste
  `fpr_inverse_of(3)`, cubic twiddle/conjugation oraz FPC_SQR;
- falcon-fft.c1245–1271: mul/div_autoadj używają **real slot** denominator;
- falcon-sign.c505–530 i548–595: LDL_dim2 oraz cały LDL_dim3;
- falcon-sign.c651–701 i706–751: depth1 i caller obu root branches.

Przy logn10 split pobiera triple root slots3j,3j+1,3j+2 (imag+768).
Każdy child ma512 słów, real j/imag j+256, j∈Fin256. Wyprowadź dokładną
mapę child roots, fazy i konwencję scaling; samo matching długości nie wystarcza.
Adj zmienia znak części urojonej, także signed zero.

Zdefiniuj `Node3Slice_C` literalnymi/source-normalized operacjami źródła:

```text
LDL_dim2(d11,L10,g00,g10,g11)
L20 = div_autoadj(g20,g00)
L21 = muladj(g20,g10); div_autoadj(L21,g00);
      neg/add(g21); div_autoadj(L21,d11)
d22 = neg(muladj(L20,g20)) + g22;
tmp = mulselfadj(L21); mul_autoadj(tmp,d11);
d22 = sub(d22,tmp)
```

Wejścia to dokładnie `(t0,u1,t0,u2,u1,t0)`, ze source aliasingiem powtarzanych
const inputs. Nie upraszczaj wzorów przez idealny reciprocal lub reassociation.
Szczególnie `tmp*d11` w mul_autoadj korzysta z real d11, nawet gdy ma on imag.

Niezależny exact reference powstaje ze split dokładnego realnego spectrum
A albo q²/A. Wyprowadź jego Hermitian Gram i 3x3 LDL w fizycznej kolejności.
Znane tożsamości pivots `e1/3, e2/e1, 3abc/e2` są punktami odniesienia,
nie definicją maszynowych wyjść. Potwierdź, że oznaczenia/scaling pasują
do tego source layoutu; dawny exact T5 nie dostarcza błędów nowego programu.

## 5. Dodatniość, część urojona i domeny FPEMU

W branch0 wejście ma imag+0; w branch1 ma tylko udowodniony mały imag bound.
Nie odrzucaj Im(D_C), nie zakładaj exact Hermitian machine matrix i nie
wyciągaj dodatniości z samego absolute error2^22 wobec q²/A.

Zachowaj relacje computed-spectrum/Gram, determinantowe bounds albo inną
udowodnioną strukturę pozwalającą uniknąć niepotrzebnego interval blow-up.
Jeśli w analizie używasz Hermitian porównania lub real part jako reference,
wyprowadź jego związek z rzeczywistymi split/adj/real-slot divisions.
To obiekt dowodowy; nie wolno zmienić maszynowego programu na tę projekcję.

Najpierw wykaż domenę pierwszego denominator t0, potem wykonanych operacji
do d11, następnie dodatniość/domenę d11 przed dzieleniem L21, a dopiero
potem d22. Coarse caps ustanawiaj przed zastosowaniem ostrych error bounds.
Przyszły pivot ani końcowe finite nie mogą uzasadniać własnej wcześniejszej operacji.

ROOT primitive contracts mają |operand|<=2^100, u=2^-48, eta=2^-900 oraz
**div denominator w[1/2,2^23]**. Każde użycie wymaga wykazania tych warunków.
Nowe denominators mogą wykraczać poza ten przedział: rozszerz kontrakt na
udowodnioną potrzebną domenę z rzeczywistym pack/underflow/exponent0 proof,
zamiast przenosić samą stałą u/eta. Rozlicz również source inverse_of(3).
E2^-20 z ZERO nie jest domyślnym błędem wszystkich nowych działań.

T5/H4 mają własne zakresy. Historyczna deklaracja correctly-rounded IEEE
nie zastępuje nowego domain bridge. H4 final widths nie certyfikują całych
16896 internal words; normalize nadpisuje tylko1536 terminal widths.

## 6. Chronologia, frame i eksport do niższych nodes

W rzeczywistym ffLDL_fft3 branch0 zaczyna się PRZED root dim2 i branch1.
Jej certyfikat g00 pochodzi z FFT/Gram i Gate00_C. Nie zakładaj ukończenia
późniejszego root call, by uzasadnić tę wcześniejszą fazę.
RootSlice może być matematyczną funkcją referencyjną; zachowaj rozróżnienie
między Defined(Node3Slice) a total execution całego wcześniejszego subtree.

Zwiąż source inputs i output blocks dla obu wywołań LDL_dim3 z deklarowanymi
slice'ami oraz wymaganiami buforów. Frame dla zdefiniowanych prefiksów nie
może być przedstawiony jako dowód poprawności niższych nodes.

`NEXT_INTERFACE.md` ma eksportować trzy source diagonal branches
`d00=t0,d11,d22` na każdą root branch, L10/L20/L21, imaginary errors,
relacje i jawne constants. Określ pełny następny typ dla split_deep/inner,
bez zakładania jego pivotów. Niższa rekurencja pozostaje osobnym zadaniem.
Initial targets i ordered Reach konsumują ZERO_SCALAR dopiero po NumericCenter;
fault0 nie dostaje residual-closeness. Sampler-law/hybrid losses pozostają osobne.

## 7. Dowód, kontrole i wyniki negatywne

Mixed universal analytical/kernel proof jest dopuszczalny, z jawnym ledgerem
upstream contracts i źródłowego bindingu. Pokaż rzeczywiste typy, termy,
implicit arguments i axioms nowych Lean. Rebuild konsumowanych dependencies,
bez starych olean. Nie utożsamiaj finite checks lub replay tekstu z dowodem
uniwersalnej analitycznej kompozycji.

Kontrole normal C/ASan/UBSan i niezależny exact dyadic/QQ/RBF/RIF oracle:
obie branches, wszystkie256 pozycje, różne kontrasty widma, nonzero imag,
znaki/Adj, source1/3, actual real-slot denominators, cancellation i alias/frame.
Nie używaj host double jako jedynego oracle. Małe przypadki są kontrolami,
nie dowodem kwantyfikatora po wszystkich P_key.

Mutacje mają zmieniać wartości/operacje: pominięcie Im(D_C), wrong Adj/slot,
idealne1/3 zamiast source coefficient, zastąpienie subtractive pivot wzorem
exact, zła domena div, pominięty rounding term; no-op musi przechodzić.
Zatrzymuj kontrolę przed nielegalnym C działaniem zamiast wykonywać UB.

Publiczne synthetic spectral/Gram arrays mogą badać szerszą domenę.
Kontrmodel niezależnych root boxes nie jest automatycznie kontrprzykładem
P_key lub emitted support. Rozdziel brak wystarczalności boundu, falsyfikację
lokalnego interfejsu i rzeczywiste required-domain naruszenie. To ostatnie
wymaga publicznego membership proof, bez odczytu/generowania sekretów.
Świadek spełniający P_key może obalić nową tezę§3; dopóki nie wykazano
Emitted_C, nie jest tym samym kontrprzykładem do osiągalnego Sign/M0.

## 8. Wykonanie, artefakty i replay

Tylko W writable; bootstrap i source read-only. Potwierdź sandbox:
AGENTS nie jest sandboxem. HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin
pod W, jeden wykonawca, skończone wall/CPU limity. GCC14.2/C99/LP64,
Sage10.9 (`sage plik.py ...`), Lean4.34/Std `-j1 -M2048`/8GiB.
ASan ma osobny tryb z dostępną przestrzenią shadow. Bez instalacji i sieci.

Bez innych agentów/Git/KeyGen/private loadera/Sign/nowych kluczy/prywatnych
seedów/współczynników/.private/private_extraction. Dozwolone są publiczne
syntetyczne lokale i źródłowe funkcje FFT/split/LDL na nich.
Nie zmieniaj C, guards, parametrów, domeny M0 lub algorytmu na stable LDL.

Nowe/edytowane Lean: pełne czyste logi, bez sorry/admit/native_decide,
lokalnego aksjomatu wniosku lub wyciszania ostrzeżeń. Kopie historyczne
zachowują piny; adaptacje mają nowe kopie/diffy i ponowne sprawdzenie.
Zachowaj wszystkie nieudane próby, command/cwd/limits/exit codes/streams.

Wymagane: REPORT.md, RESULT.json, CLAIM.md, NODE3_CERTIFICATE.json,
BOUND_LEDGER.json/.md, SOURCE_MODEL_BINDING.md, REUSED_RESULTS.md,
OBLIGATIONS.json, NEXT_INTERFACE.md, formalne źródła/certyfikaty/checkery,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
OUTPUTS.sha256. Ledger minimum: ROOT_CONSUMPTION, SPLIT_TOP_MAP,
SPLIT_TOP_ERROR, ADJ_AND_IMAGINARY, FIRST_DIVISOR, NODE3_D11,
NODE3_L10_L20_L21, NODE3_D22, PRIMITIVE_DOMAINS, NODE3_FRAME,
LOWER_TREE_OPEN, INITIAL_TARGETS_OPEN, ORDERED_REACH_OPEN.

Standard: `python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`.
Sprawdź zewnętrzny pin i cały OUTPUTS przed utworzeniem nowego DEST pod tmp.
Rebuild wszystkich konsumowanych dowodów i istotnych kontroli, bez gotowych
olean/bin/cache. `artifacts/fresh_replay.json` ma matches(path,sha256),
związane OUTPUTS; pre-freeze rehearsal z osobną kotwicą bez hash cycle.
Po freeze standard replay z finalnym pinem, zapis tylko do DEST.

## 9. Warunek końca

- `H3_NODE3_PROVED_FOR_PINNED_MODEL`: cały typ§3, jeden jawny uniform c3,
  wszystkie numerical/domain premises i source bindings rozliczone.
- `PARTIAL_PROOF`: nowe konkretne wyniki i dokładnie wskazany brakujący
  typ/nierówność; nie tylko powtórzenie listy obowiązków.
- `COUNTEREXAMPLE_REQUIRED_DOMAIN` / `COUNTEREXAMPLE_EXTENDED_DOMAIN`:
  jawna dziedzina oraz membership i relacja do tezy§3.
- `EXECUTION_BLOCKED`: rzeczywista przeszkoda techniczna, pełne logi.

Także po pozytywnym wyniku: H3_range_proved=false,
global_reachability_proved=false, full_internal_tree_proved=false,
sampler_law_proved=false, security_reduction_proved=false.
baseline_source_integrated=true, source_changed=false,
new_source_patch_integrated=false, protocol_wrapper_integrated=false,
owner_accepted=false. Pole full_node3_theorem_kernelized ma odzwierciedlać
faktyczny zakres kernelizacji.

Podaj REPORT/OUTPUTS SHA-256, dokładną tezę i stałe, warstwy dowodu oraz
pełny następny typ. Prowadzący wykona niezależny odbiór/import/commit.
Zakończ na przekazaniu; nie uruchamiaj następnego etapu automatycznie.
