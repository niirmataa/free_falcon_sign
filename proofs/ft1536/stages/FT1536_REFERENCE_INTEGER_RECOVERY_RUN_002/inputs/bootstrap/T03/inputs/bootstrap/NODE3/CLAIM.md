# H3_NODE3 — dokładna teza i jeden rekord c3

Autor projektu: Niirmata. Status: **H3_NODE3_PROVED_FOR_PINNED_MODEL**,
w jawnym mixed analytical/kernel zakresie. P_key jest dokładnie ROOT:
cztery Int^1536 vectors, ternary f/g, caps2047 F/G, exact NTRU, actual Gate00_C.
Nie dodano numerical premises. W źródłowo związanym GCC14.2/C99/LP64 FPEMU:

```
exists c3 : Node3Constants,
 ValidConstants(c3) and
 forall p : Key4, P_key(p) -> forall b : Fin2,
  let S := RootSlice_C(p);
  let v := if b=0 then S.g00 else S.d11;
  let (t0,t1,t2) := SplitTop_C(v,10);
  let u1 := Adj_C(t1,9,0); let u2 := Adj_C(t2,9,0);
  Defined(SplitTop_C;Adj_C;LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0)) and
  forall j : Fin256,
   Node3Certificate(c3,j,t0,u1,u2,LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0),
    ExactSplitAndSchur(if b=0 then A(p) else q²/A(p),j)).
```

Source operations/kolejność są literalne; reciprocal/pivot formulas nie
zastępują maszynowego programu. Legal buffers/lifetimes/disjoint outputs,
aktywne Makefile flags i fixed integer ABI należą do jawnego modelu C/API.
Pełny c3 z intermediate caps i korelacjami jest w NODE3_CERTIFICATE.json.

| Pole c3 | Branch0 | Branch1 |
|---|---|---|
| Re(t0) lower / upper | 1/4 / 2^24 | 16 / 2^33 |
| Re(d11), Re(d22) lower / upper | 1/8 / 2^25 | 8 / 2^34 |
| abs Im(t0) | 0, raw+0 | ≤32 |
| abs Im(d11) | ≤1/256 | ≤33 |
| abs Im(d22) | ≤1/256 | ≤34 |
| norms L10/L20 | <2 | <2 |
| norm L21 | <4 | <4 |
| split-only norm error | <1/8192 | <1/16 |
| split error do exact reference | <9/8192 | <2^22+1/16 |
| L10/L20 norm error do reference | <1/64 | <3 |
| L21 norm error do reference | <1/16 | <5 |
| d11 complex norm error do reference | <1/128 | <2^25 |
| d22 complex norm error do reference | <1/8 | <2^29 |

Lower bounds są STRICTLY positive; rzeczywiste wartości przekraczają je,
a upper bounds są ścisłe poza jawnie nieostrymi imaginary bounds. Reference
to niezależny exact split real spectrum A lub q²/A w prawidłowych fazach
i ze scaling1/3. W source użyto kappa=0x3fd5555555555555, nie idealnego1/3.
Complex norm to moduł euklidesowy; scalar component bound wynika z niego.

Dodatniość branch1 wynika z zachowanego root determinant envelope, nie
z absolute error2^22. Po split analizowany Hermitian H ma lambda≥1/4 lub16,
near-equality offdiagonal norms i exact-H L21<3. Source-to-H real errors
d11≤64U*T,d22≤65536U*T są dużo silniejsze od luźnych exact-reference errors.
Imaginary source words pozostają w programie; kernelowy dataflow lemat
wyjaśnia nieinterferencję samego diagonal imag po split z real slots/L.

Nowa primitive div domain[1/16,2^35] jest wyprowadzona ze źródła. All operands
≤2^100, U=2^-48,eta=2^-900, finite/normal-or-zero outputs. Dodatnie divisors
oraz real pivots są normal. ZERO E2^-20 nie jest globalnym FP boundem.

Full_node3_theorem_kernelized=false. Kernel sprawdza inverse3, dataflow,
rational-pair c3 validity i frame; spectral/error kompozycja jest analityczna
z exact QQ/RBF/number-field certificates. Nie ogłoszono zweryfikowanego GCC.
H3_range_proved, global_reachability_proved, full_internal_tree_proved,
sampler_law_proved i security_reduction_proved pozostają false.
