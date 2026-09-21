# Konsumowane wyniki

PREV=`stages/FT1536_L_NTT_FORWARD_RUN_001`, checkpoint71bbb358ec59f0e5912b6c324332c1253cfcc7a2.
RHO=`stages/FT1536_L_RHO_RUN_001`; OLD=`stages/FT1536_LV_STATIC_RUN_001`.
Piny124 wybranych wejść: INPUTS.sha256; mapping lokalnych kopii: inputs/provenance.json.

| Oryginalny plik i SHA-256 | Fakt/przesłanki | Nowe zastosowanie |
|---|---|---|
| PREV/REPORT `ff172360348004527b7ef2a68c3f70967463619f039145d856f1969d69b866eb` | Pełne L_NTT dla kandydata | Rdzeń arytmetyczny raw, bez ponownego projektowania NTT |
| PREV/OUTPUTS `32147f114b448a1e1c2659b45ed3e69bfac02c44164ac380001df39c98fb498e` | Zewnętrzny pin pakietu | Wszystkie konsumowane formalne/certyfikowane wejścia |
| PREV/Complete.lean `67b8fd4c52dfe47cd8ed91a87ff8d1e66fdf6cad0811a881ce643ba8849e2fc4` | L_NTT_rho: canonical h,c, signed int16 s | RawBridge.raw_before_eq; C otrzymuje prepared H |
| PREV/Product.lean `28d37d8cf99d2a09dbd18af3e0be3c5f7b99d4b40ea764d68e29a957176e4906` | Zachowany współczynnikowy product i canonicalization invariance | Definicja Ext0 i kongruencja, pośrednio L_NTT_rho |
| PREV/Rho.lean `3fc6f1106bde82d3c5657da11e2c2a781486163491adf5617e6d39db43f15fd2` | rho_contract, InInt16; center_antisymmetric dla q odd | SignedVec, znak pierwszego składnika Ext0 |
| PREV/SOURCE_MODEL_BINDING `2365680a7cf0a7c9efd3d0b116b39571bc98408fd20bca9815cd4e6704202535` | C→niezmienione modele NTT/pipeline | Zachowany zakres GCC/C99/LP64 i legalne bufory |
| RHO/CANDIDATE.sha256 `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |17 dokładnych źródeł | Niezmienione source/ |
| RHO/REPORT `ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3` | Normalizacja wszystkich int16 | Zakres raw s2; historyczna poprawka już w kandydacie |
| OLD/REPORT `c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd` | Kontrprzykład do oryginalnego S17 | Publiczny regression witness, nie dowód kandydata |
| OLD/OUTPUTS `0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87` | Pin publicznych fixtures | witness, h*/PK, rzeczywiste norm boundaries, decoder controls |

Do W przeniesiono transitive closure59 formalnych modułów od Complete.
Wszystkie są bajtowo identyczne i ponownie sprawdzone. Nie przeniesiono olean
jako substytutu dowodu. Nie zmieniono product, remMonomial, pipelineC ani rhoVec.
Rho jest już czystą adaptacją z PREV; w tym etapie nie potrzebował zmian aliasów.

W szczególności konsumowane są point_prefix/store_at/store_away (centrowanie
i inicjalizacja), sumN/sum_congr/sum_add/sum_split (dokładna norma),
center_antisymmetric, L_NTT_rho, CanonVec i oryginalne definicje prepared key.
Każda przesłanka jest rozliczona w nowych twierdzeniach; końcowy L_V nie
przyjmuje parser/norm correctness jako argumentu.

Dawne decoder_controls i norm_boundaries są wejściami kontrolnymi, nie
uniwersalnymi dowodami. Norm boundaries B−1/B/B+1 odtworzono z rzeczywistych
wektorów na kandydacie. Świadek OLD został odrzucony z Q43058711057.
Publiczne h*/PK mają zachowaną proweniencję, choć silniejszy dowód obejmuje
wszystkie canonical h i nie potrzebuje nowego argumentu o rozkładzie KeyGen.

Oddzielono kernel proof, jawny C/model binding oraz obserwacje normal/sanitizer.
Historyczny S17 pozostaje obalony dla ustalonego Ext0. Nowy dodatni wynik nie
przenosi się automatycznie na inne piny ani na pełne bezpieczeństwo podpisu.
