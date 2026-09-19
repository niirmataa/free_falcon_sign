# Niezależny odbiór H3_ROOT_LDL — 2026-09-19

**PASS: H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL**, w zadanym zakresie korzenia,
z mieszaną warstwą dowodu kernelowego, analitycznego i dokładnych certyfikatów.

Baza odbioru: `ce5bba58354c3414a561f650b7e3df229dee4062`.
REPORT: `0d79129b04b192bca97a1aa3f6bbdce3153767b7673934335a1895509dc8f39c`.
OUTPUTS: `9894d5f10e11f65ff7da338881c71d8008456ef4c371d45bb2119f5cd66abc48`.
Import potwierdził 674 członków OUTPUTS i 110 publicznych records INPUTS.

## Niezależny replay

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_ROOT_LDL_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia, bez wcześniejszych olean/bin/cache, Dokumenty/H ukryte,
sieć odłączona, zapis tylko w kopii roboczej. Exit0, 38.899 s, **131/131
plików znaczeniowych zgodnych** z zamrożonym receipt.

- 17 modułów Lean4.34/Std, 99 twierdzeń (17 nowych), pełne czyste logi;
  11 odziedziczonych modułów identycznych z ZERO_SCALAR, przebudowanych.
- 1179648 symbolicznych wag FFT i 2359296 wag końcowego NTT checku KeyGen;
  pełne mapy N1536, nie wnioskowanie z wybranych wektorów.
- C normal/ASan/UBSan: 334 pary primitive, 768 root slots, dwa pełne
  polinomowe cases, trzy frame cases, alias/canary/mutation/no-op controls.
- Niezależny oracle RBF256: 6208 składowych; wartości Lean mul/div zgodne
  z literalnym modelem i C. Syntetyczne cases nie są emitted witnesses.

[Execution](execution.json), [review checks](review_checks.json),
[formal audit](artifacts/formal_audit.json), [replay result](REPLAY_RESULT.json).
Sprawdzono i zachowano wszystkie strumienie wskazane przez receipts/drivery,
także toolchain i wykonanie modelu Lean. [VALIDATION.sha256](VALIDATION.sha256)
obejmuje 145 plików, SHA-256:
`507562db7454e8db06d0d1e26eb81654d37bd73eeda28e1db3ec18934dcdc24d`.

## Zakres przeglądu matematycznego

Przejrzano [ANALYTIC_PROOF](../../stages/FT1536_H3_ROOT_LDL_RUN_001/ANALYTIC_PROOF.md),
[EMITTED_BINDING](../../stages/FT1536_H3_ROOT_LDL_RUN_001/EMITTED_BINDING.md),
[ROOT_FRAME](../../stages/FT1536_H3_ROOT_LDL_RUN_001/ROOT_FRAME.md), źródła,
modele i exact certificate. Ich piny są w review_checks.

1. Emitted membership daje coefficient caps, exact NTRU przez końcowy
   modularny check i integer lift `18883585 < 2147355649`, roundtrip tego
   samego STATIC sk oraz rzeczywisty mandatory Gate00_C.
2. Domeny primitive wyprowadzono przed ostrzejszymi bounds. Używa się
   u=2^-48, eta=2^-900 z własnym source proof; nie przenosi E2^-20 poza
   domenę ZERO ani nie zakłada complete IEEE backendu.
3. Dodatniość subtractive D_C pochodzi z exact Gram **obliczonej FFT macierzy**:
   `aj-|c|²=|det(Bhat)|²` i `|D_C-|det(Bhat)|²/a|<=256*2^-48*j`.
   Dokładne QQ sprawdzają margin >32 oraz imaginary envelope <32.
4. Osobny globalny error <2^22 względem q²/A jest luźniejszym wynikiem;
   nie stanowi uzasadnienia dodatniości. C wykonuje rzeczywiste per-component
   div, muladj, neg/add, a nie podstawione q²/g00.
5. Frame dotyczy każdego **zdefiniowanego prefiksu docierającego do root call**.
   Nie dowodzi numerycznej poprawności wcześniejszej rekurencji. Bindings
   uwzględniają source order, layout, scratch i moment odczytu root inputs.

| Eksport | Jednostajny bound |
|---|---|
| g00_C real | [1/2,2^23), positive normal; imag raw+0 |
| L_C modulus / error do C/A | <2^25 / <2^14 |
| Re(D_C) | 32<Re(D_C)<2^31, positive normal |
| abs(Im(D_C)) | <32 |
| complex error D_C do q²/A | <2^22 |

Pełny rekord jest w [ROOT_CERTIFICATE.json](ROOT_CERTIFICATE.json).
`full_root_theorem_kernelized=false`: source-domain/error composition jest
analityczna, wsparta Lean i exact QQ/RBF/symbolic certificates. Pełne typy
konsumentów mają jawne przesłanki; zgodność pliku dowodu podczas replayu
nie jest kernelowym dowodem jego całej treści ani weryfikacją kompilatora.

Następny cel to `split_top -> Adj -> LDL_dim3` dla obu root branches i
wszystkich 256 częstotliwości na branch, z nowymi domenami dzielników i
propagacją imaginary errors. Całe internal tree, initial targets, ordered
Reach i sampler law pozostają otwarte; wszystkie odpowiadające flagi oraz
security_reduction_proved są false. Odbiór nie nadaje owner acceptance.

Przypięte źródła/archiwa i historyczny whitespace zachowano bajtowo.
Nowa dokumentacja jest sprawdzana osobno od frozen kopii i surowych logów.
