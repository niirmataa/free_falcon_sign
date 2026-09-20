# FT1536 H3_NODE2 — pierwszy poziom binarny po NODE3

Data zlecenia:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_NODE2_RUN_001`.

## 1. Werdykt

**H3_NODE2_PROVED_FOR_PINNED_MODEL.** Domknięto dokładny typ TASK§3:
SplitDeep(logn9)→Adj(logn8,full0)→LDL_dim2(logn8,full0), dla wszystkich
P_key, 2×3 source diagonal branches i128 positions każdej. Jeden uniform
rational c2 ma sześć stałych records. Nie pozostała założona numerical
premise wymagana dla tego pozytywnego wniosku.

Zakres mixed analytical/kernel: kernelowe half bit/value semantics,
paired identity, c2 validity i frame; nowy upstream imaginary refinement
i pełna complex/source error composition są analityczne z exact QQ/RBF
certificates. `full_node2_theorem_kernelized=false`; nie jest to pełny
kernel C/compiler proof lub theorem całego remaining internal tree.

## 2. Piny, profil i domena

- TASK: `f4a28c97adde1a2cbc26b4274086d0db171c9e5cbf3eb607e4464d511d583900`.
- Bootstrap MANIFEST: `f92dbaa6f4262f2cce5d4bd27e002da0f684f87a92fef8619bee226221782178`.
- BASE: `afa52d89be2f21208ac3135e74a1a60fc66d52c4`.
- Candidate manifest: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
- Zweryfikowano120/120 plików,118 publiczne ORIGINS i17 identycznych source
  files. INPUTS/provenance obejmuje124 records z TASK/AGENTS/manifestem.

P_key ma dokładnie definicję ROOT: cztery Int^1536 vectors, ternary f/g,
caps2047 F/G, exact NTRU, actual Gate00_C. Emitted_C+same STATIC decode→P_key
jest konsumowane w odebranym source-analytic zakresie. Nie dodano small-imag,
small-L, przyszłego pivotu, center lub norm acceptance do P_key.

N1536/q18433/Phi=X^1536−X^768+1/sigma768/B2093922385, MODE1/FPEMU, Makefile
flags, M0 caller4096/nonce40/16 attempts, jeden K_seed[E] i parametryczny cel
pozostają tym samym profilem. Badano bootstrap/source, nie zastany Extra/c/index.

## 3. Dokładna teza i c2

```
exists c2 : Node2Constants, ValidConstants2(c2) and
 forall p : Key4, P_key(p) -> forall b : Fin2, forall k : Fin3,
  let N := Node3Slice_C(p,b);
  let v := select(k,[N.t0,N.d11,N.d22]);
  let (s0,s1) := SplitDeep_C(v,9); let u1 := Adj_C(s1,8,0);
  Defined(SplitDeep_C;Adj_C;LDL_dim2_C(s0,u1,s0,8,0)) and
  forall f : Fin128,
   Node2Certificate(c2,b,k,f,s0,u1,LDL_dim2_C(s0,u1,s0,8,0),
    ExactSplitAndSchur(select(k,ExactNode3Diagonals(p,b)),f)).
```

Key4/P_key jak wyżej; legalne buffers/sizes/lifetimes/disjoint outputs/scratch,
read-only repeated alias g00=g11=s0 i fixed GCC14.2/C99/LP64 portable FPEMU
są jawnymi API/model premises. Numerical bounds są WNIOSKAMI.

| Uniform bound dla każdego k | Branch0 | Branch1 |
|---|---|---|
| Re(s0) lower / upper | 1/16 / 2^26 | 4 / 2^35 |
| Re(d11_C) lower / upper | **1/32 / 2^27** | **2 / 2^36** |
| Norma L_C | <2 | <2 |
| abs Im(s0),abs Im(d11_C) | ≤1/8192 | ≤9/8 |
| Source split norm error | <1/16384 | <1/32 |
| Source real pivot error do actual H | <1/65536 | <1/128 |

Lower bounds są dodatnie i actual wartości je przekraczają; upper są ścisłe.
Real denominators/pivots są normal. s0/s1 mogą mieć subnormal components po
half; L i d11 outputs są normal/zero. Wszystkie operations są defined/finite.

| b,k | L norm error do independent reference | Complex d11 error |
|---|---|---|
|0,0|<1/16|<1/128|
|0,1|<1/2|<1/16|
|0,2|<3|<1|
|1,0|<3|<2^25|
|1,1|<3|<2^28|
|1,2|<3|<2^32|

Pełny rekord z input/refinement bounds, split errors, margins i caps:
NODE2_CERTIFICATE.json. Reference to dokładne NODE3 real diagonals,
następnie binary h=(a+b)/2,L=x(a-b)/(a+b),D=2ab/(a+b). Source nadal wykonuje
add/half,sub/mul/half,Adj, direct div i subtractive muladj/neg/add.

## 4. Nowo domknięty upstream imaginary refinement

Sam coarse box Re≥8,|Im|≤34 nie wystarcza. Nowy dowód w UPSTREAM_REFINEMENT
zachowuje te same computed root operands c0,a0 i porównuje Lroot do c0/a0.
Imaginary c0*conj(c0/a0)=0 dokładnie. Rozliczenie div/muladj/neg/add,
correlated Gram gamma i jmax daje **|Im(D_ROOT_C)|<8U*j<1**.

Przez NODE3 source-to-H/tau relationships i rzeczywisty zero temporary:

```
NODE3 branch0 imag bounds: (0,1/262144,1/262144),
NODE3 branch1 imag bounds: (17/16,545/512,545/512).
```

To nowy dowód w tym W, nie poprawka historycznego certyfikatu lub liczba
wywnioskowana z prób. W binary pair zachowano
`h0²-|u1|²=ra*rb-(tau_a-tau_b)²/4`; nie założono równych tau.
Refined I i source split error dają actual-H eigen lower1/16 albo4.
Dopiero potem ustalono divider s0, bound L i błąd computed d11.

## 5. Rzeczywisty fpr_half

Kernel Half.lean wiąże unsigned wrap/mask z pełną valueNum interpretacją:

- exponent0, w tym OBA zera/subnormals →raw+0;
- exponent1 →ten sam sign/fraction, exponent0: możliwy subnormal lub signed0;
- exponent≥2 →exact value x/2;
- każdy finite input daje finite output i value error≤**2^-1023** wobec x/2.

Nie przyjęto RN(x/2) dla wszystkich bit patterns. Kontrola source split
wyprodukowała s0.imag=`0000000000000001`, a późniejszy source pivot imag=0.
Dlatego po half użyto ogólnego finite add contract, nie raw-preservation
sub(x,+0). To rozróżnia błąd wartości od zmiany zero/subnormal bits.

Istniejące NODE3 primitive contracts U2^-48,eta2^-900,operand cap2^100
i div[1/16,2^35] wystarczają na TYM poziomie po wyprowadzeniu intermediate
caps i positive s0. Nie przeniesiono ZERO E2^-20 lub complete-IEEE premise.

## 6. Chronologia/frame

NODE3 diagonals są odczytywane w trzech kolejnych split_deep/inner calls.
Earlier lower scratch/tree writes są rozłączne z jeszcze nieodczytanymi
NODE3 t0/d11/d22. Inner(logn8) robi własną lower recursion przed local dim2;
frame dla defined prefixu wiąże jego inputs z isolated Node2Slice.
Nie dowodzi to totalności tej wcześniejszej recursion. Scratch reuse po
local pivot jest związane z właściwym momentem, nie z wieczną niezmiennością.
Branch0 przed root dim2 nadal nie jest uzasadniana przyszłym wykonaniem.

## 7. Weryfikacja, kontrolny wynik negatywny i replay

- **26 modułów Lean,131 twierdzeń,16 nowych**,19 inherited modules
  byte-identical i rebuilt; final logs czyste, standardowe axioms only.
- BinaryAudit.stdout SHA:
  `e2dd3695301607f6b62cec7528d1d65cc7a02444551333af99eeb394fa9f54fb`.
  Pełne types/implicits/terms BinaryTypes.stdout SHA:
  `64e8e12d998958faf3fb5c5425ec228d2ad447d6aff927832e6757ee051785cd`.
- QQ polynomial identity i exact rational six-record checks; RBF256
  wszystkich128 square twiddles i parent/child root maps.
- Normal C/ASan/UBSan: wszystkie2*3*128 positions,6144 raw Node2 output words,
  native NODE3 parent dumps; independent QQ/RBF oracle3072 complex outputs.
- 98 half boundary words C/Python/Lean,768 root-imag controls,128 post-half
  subnormal split positions oraz3 original inner8 frame cases z2304-word tree.
- Mutacje imag-difference/root/phase/Adj/complex-div/harmonic/half/rounding/
  old-domain wykryte po wartościach. No-op przechodzi. Zero divisor zatrzymano
  przed C call; negative-result control nie używa wyniku do dalszej division.

Publiczna para9+34i,9−34i daje margin−1075 i exact pivot−1075/9. C zwraca
raw`c05ddc71c71c71c6`, wartość−4202577777277155/35184372088832. First divisor9
jest legalny. Klasyfikacja: **COUNTERMODEL_COARSE_NODE3_BOX_ONLY_NOT_P_KEY_OR_EMITTED**.
To dowód niewystarczalności starych independent boxes, nie obalenie P_key
lub nowego required-domain celu. Po nowym refinement para jest wykluczona
przez UDOWODNIONE właściwości wejść, nie przez zmianę P_key/runtime.

Fresh rehearsal **PASS160/160**, pełny rebuild/sanitizers bez starych olean/
bin/cache. Po freeze standard replay wymaga finalnego external OUTPUTS pin;
wynik pozostaje w nowym DEST. Kopiowanie proof text nie kernelizuje analityki.

## 8. Próby, sandbox i handoff

Failed elaborations, deprecated if_neg/unused simp diagnostics oraz C
misleading-indentation warnings zachowano w attempts/logs i poprawiono w
nowych własnych plikach. Nie wyciszano warnings lub logów. Końcowe Lean/C
kontrole są czyste. Nowe modele nigdy nie zmieniły source/ lub bootstrapu.

Rzeczywisty bwrap/EROFS i exclusive lock potwierdziły W-only zapis; source
read-only. Skończone wall/CPU limity, Lean -j1 -M2048/8GiB, osobny ASan
shadow mode, HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache pod W. Bez instalacji,
sieci, innych agentów/Git/sekretów, KeyGen/private loadera/Sign. Testy są
publicznymi synthetic numerical instances, bez membership claim.

NEXT_INTERFACE eksportuje d00=s0,d11,L i relacje do następnego lokalnego celu:

```
exists c7 : Node2Level7Constants, ValidConstants7(c7) and
 forall p : Key4, P_key(p) -> forall b : Fin2, forall k : Fin3, forall ell : Fin2,
  let S := Node2Slice_C(p,b,k); let v := select(ell,[S.s0,S.d11]);
  let (t0,t1) := SplitDeep_C(v,8); let u1 := Adj_C(t1,7,0);
  Defined(SplitDeep_C;Adj_C;LDL_dim2_C(t0,u1,t0,7,0)) and
  forall g : Fin64,
   Node2Level7Certificate(c7,b,k,ell,g,t0,u1,LDL_dim2_C(t0,u1,t0,7,0),
    ExactSplitAndSchur(select(ell,ExactNode2Diagonals(p,b,k)),g)).
```

Pełne definicje quantifier domains/records są w NEXT_INTERFACE. Level7,
remaining tree, initial targets, ordered Reach i sampler-law/hybrid losses
są otwarte. ZERO_SCALAR wymaga wcześniejszego NumericCenter; fault0 nie ma
closeness. Nie przydzielono nowego abortu lub automatycznej małej straty.

H3_range_proved=false; global_reachability_proved=false;
full_internal_tree_proved=false; sampler_law_proved=false;
security_reduction_proved=false; baseline_source_integrated=true;
source_changed=false; new_source_patch_integrated=false;
protocol_wrapper_integrated=false; owner_accepted=false;
full_node2_theorem_kernelized=false.

Odbiór/import/osobny commit wykonuje prowadzący. To kończy jedno zadanie.
