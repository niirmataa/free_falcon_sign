# ERROR_LEDGER — rozliczenie defektów recovery (składnik B)

Exact rationals: checks/gap_composition.json; opis i dominanty: SOURCE_ERROR.md.
Rozdzielenie (każdy term z pinowanym discharge):

| Wielkość | Frame | Discharge | Wartość |
|---|---|---|---|
| challenge FFT words vs eval(c) | root-modulus | PROVED_UNIFORM (TARGETS 1/8192) | 0.000141 |
| εdet (rounded-basis det) × |Ĉ/q| | root-modulus | PROVED_UNIFORM (ROOT word errors) | 332.455 |
| target rounding layer × basis words | root | PROVED_UNIFORM (TARGETS) | 0.433 |
| word errors × target operands | root | PROVED_UNIFORM (ROOT×TARGETS) | 166.227 |
| Z(Y)·(B'words−B) | root→coeff (A2) | PROVED_UNIFORM (ROOT×caps) | 4489.916 |
| tree/L-reconstruction (δ+eroot) | triangular/energy | PROVED_UNIFORM (H6P pinned) | 1078.694 |
| terminal sub/half/last-sub × coeff box | convolution box | PROVED_UNIFORM (H6P Er/Eh/Elast) | 3.000 |
| defect × word errors | cross | PROVED_UNIFORM | 0.0000013 |
| suffix CM/add rounding | coeff | PROVED_UNIFORM (H6P post_CM_add) | 15.667 |
| source iFFT | coeff | PROVED_UNIFORM (POST 1/128) | 0.0078 |
| **suma (wymagane < 1/2)** | | **NIEDOMKNIĘTE** | **6086.401** |

Nie użyto: sample maxima jako bound; relative-only przy cancellation/−0;
idealnego L; rounded linearity; dokładnego det=q dla rounded basis;
Safe16/norm Q<B jako przesłanki. Read-time operands i correlated terms
zachowane (trójkątna trasa δ; εdet liczony z tych samych słów co suffix).
