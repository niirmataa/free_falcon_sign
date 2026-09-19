# H3_ROOT_LDL — dokładna lokalna teza

Autor projektu: Niirmata. Status: **H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL**.
Jest to mieszany dowód analityczny/kernellowy z dokładnymi certyfikatami;
pełnego root theorem ani C/compiler refinement nie skernelizowano.

## Kwantyfikatory i source model

Niech E będzie legalnym M0 environment, sk/pk finite bytes, a p=(f,g,F,G)
czterema decoded Int^1536 vectors tego SAMEGO sk. W fixed GCC14.2/C99/LP64,
portable FPEMU, legal buffer/lifetime/disjointness model:

```
forall E sk pk p,
 Emitted_C(E,sk,pk) -> SourceDecodeSameSTATIC(sk)=p -> P_key(p);
forall p, P_key(p) ->
 Defined(RootSlice_C(p)) and RootCertificate(RootSlice_C(p), exactEval(p)).
```

P_key zawiera caps f,g∈{-1,0,1}, |F_i|,|G_i|≤2047, exact fG−gF=q modPhi
oraz rzeczywisty mandatory Gate00_C. Wszystkie zostały wyprowadzone z
emitted support w EMITTED_BINDING. Nie przyjęto małego błędu, L, center,
Babai quotient lub dodatniego subtractive d11 jako przesłanki.

RootSlice: dokładne source of/FFT3, B=[[g,−f],[G,−F]], source Gram, a potem
oryginalne LDL_dim2_fft3(logn10,full1). L dzieli oba components bezpośrednio
przez real slot g00. D powstaje przez muladj, neg, add, nie reciprocal.
Bit model Python i source-normalized Lean zachowują zero/underflow branches.

## RootCertificate — wszystkie768 physical complex slots

Exact frequency r=1+6*rev8(j)+1536k w slot i=3j+k; ζ=exp(2πi/4608).
Real slot i, imag slot i+768; brak normalizacji1/N. Exact A,C,J,L,D jak w TASK,
z D=q²/A dopiero jako niezależnym punktem odniesienia.

| Wielkość | Jednostajny bound |
|---|---|
| FFT f/g component error | <2^-26 |
| FFT F/G component error | <2^-15 |
| FFT f/g component modulus | ≤1536+2^-26 |
| FFT F/G component modulus | ≤3144192+2^-15 |
| abs(g00_C−A) | <1/1024 |
| complex norm(g10_C−C) | <1 |
| abs(g11_C−J) | <1024 |
| g00_C real | [1/2,2^23), positive normal |
| g10_C complex modulus | <2^35 |
| g11_C real | (1/8,2^45), positive normal |
| g00_C/g11_C imag bits | dokładnie+0 |
| complex norm(L_C) | <2^25 |
| complex norm(L_C−C/A) | <2^14 |
| Re(D_C) | (32,2^31), positive normal |
| abs(Im(D_C)) | <32, finite |
| complex norm(D_C−q²/A) | <2^22 |

W tabeli complex modulus to norma euklidesowa, component error to max real/imag.
Wszystkie pośrednie instructions są zdefiniowane; FFT/Gram/L/D outputs finite.
L i imag D mają normal/zero classes; znak zera nie jest canonicalizowany.
Reciprocal1/g00_C jest zdefiniowane i positive normal w[2^-23,2]; kod L
nadal wykonuje bezpośredni div, a nie mnożenie przez ten reciprocal.

## Frame i dalsza granica

Rzeczywisty ffLDL wykonuje first subtree przed root dim2. Dla każdego defined
prefixu docierającego do root call udowodniono, że g00/g10/g11 są bitowo
niezmienione. RootSlice correctness nie nadaje earlier subtree statusu proved.
Najbliższy nowy typ jest w NEXT_INTERFACE, z osobnym split_top/LDL_dim3/error
certificate. Initial targets i ordered Reach pozostają oddzielne.

H3_range_proved=false, global_reachability_proved=false,
full_internal_tree_proved=false, sampler_law_proved=false,
security_reduction_proved=false. Baseline_source_integrated=true,
source_changed=false, new_source_patch_integrated=false,
protocol_wrapper_integrated=false, owner_accepted=false.
