# Konsumowane wyniki i rzeczywiste zastosowania

PREV=`/home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001`, zamrożone PARTIAL_PROOF.
RHO=`/home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001`, zamrożone lokalne L_RHO.
Pełne piny38 wybranych wejść: `INPUTS.sha256`; mapping kopii: `inputs/provenance.json`.

| Wejście i oryginalny SHA-256 | Fakt / przesłanki | Nowe zastosowanie |
|---|---|---|
| PREV/REPORT.md `b89d618d7c1d3992fa1a9ea0ae8c84dcc348448f035905b87a03c37e20dfd650` | Częściowy zakres; nie globalny forward/inverse | Punkt odniesienia macierzy obowiązków |
| PREV/OUTPUTS.sha256 `f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f` | Manifest708 historycznych artefaktów | Pin pakietu; nie ponowiono całego audytu708 plików |
| PREV/formal/Words.lean `4630b8b49186ccbf49a074e7e684e8125bbf14e6aadfc5443be8e2cbedb7f52b` | `add_contract`, `sub_contract`, `mont_contract_z`, low16/wrap; canonical operands, C99/LP64 | `SourceModel.addQ_source/subQ_source/mmQ_source`, zakresy wszystkich etapów |
| PREV/formal/Linear.lean `60b843d305f264d47b9411f479d83f647e747b9e9bd7763fa43f27d198336dd5` | Symboliczne dot2/dot3, `final_scaling`, wszystkie zmienne wejścia | `Expressions` używa dot3; `Stages.scale_cancel` konsumuje final_scaling |
| PREV/formal/Tables.lean `ee668bf1b63a8cb9a3192b39fee68347ed67481d4c73e948372ffc1db203821e` | units1024, dynamiczne logn10, rev10, recurrence, root/scale, lokalne macierze; przypięte liczby | `Twiddles` bezpośrednio importuje units_i i ich dowody; `BlockExpressions/BlockChecks` wiążą te same słowa z konkretnymi source expressions |
| PREV/formal/Composition.lean `0ee19f21c9acdb4361d862905d7ab090ed3bb904066a22059cf7688948a34772` | Rzeczywisty iloczyn przez remMonomial, tomont_factor, prepared_product; końcowy lemat z dwiema przesłankami | `Pipeline`: sekwencyjne pętle pointwise i usunięcie przesłanki inverse_forward; forward_product nadal jawna |
| PREV/DERIVATION.md `f91c0052528f84f85b2379dfc9c9c1df3c34f352836d2535ca88c25e7a9ab367` | D1–D3: C→word model i generator; D4 lokalne bloki; D5–D6 plan CRT | Mapping C→SourceModel, schedules; plan CRT nie jest konsumowany jako ukończony dowód |
| PREV/artifacts/tables_C.json `176bafee8c1148104fca826fd4a607822ede947e19fdaf0e9e0c188ea15b2e60` | Zainicjalizowane dynamiczne gm/igm[0..1023] | `export_twiddles.py` wiąże indeksy i wartości z kernel_literals; Sage używa tego samego publicznego wejścia |
| PREV/artifacts/kernel_literals.json `8474c4585bef3cfc1e7e460e5388719b6db8ea49ee14453b2a629e5ba22cfc87` | Literalne rekordy certyfikatów | Kontrola bindingu units, bez nowych założeń o danych |
| Manifest źródeł L_RHO `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` | Dokładnie17 plików kandydata | Niezmieniona kopia `source/`, ponowny check hashy |
| RHO/REPORT.md `ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3` | Lokalna rho(s) canonical i kongruentna s dla int16 | Pochodzenie kandydata i późniejsze podstawienie; substytucja wyniku PRODUCT nadal warunkowa |

## Adaptacja formalnego wejścia

Nietknięty Words jest w `inputs/formal/Words.lean`. Roboczy
`formal/Deps/Words.lean` ma tylko zmianę aliasu
`Int.ofNat_nonneg` → `Int.natCast_nonneg`, bez zmiany tez.
Nowy hash: `7bd7ae52561875cc2e7859a6f95c3e662d85a74a8a705e5a8fe0c047b9749e26`.
Diff: `formal/Deps/Words.patch`; receipt: `artifacts/formal_adaptations.json`.
Pozostałe trzy Deps są bajtowo identyczne z oryginałami. Wszystkie cztery
ponownie sprawdzono kernelowo w czystym końcowym logu.

## Rozdzielenie rodzajów dowodu

1. Kernel: twierdzenia Lean wymienione w `artifacts/formal_audit.json`.
2. C→model: jawna translacja instrukcji, bitowych kontraktów i zmiennych pętli,
   `SOURCE_MODEL_BINDING.md`; nie jest to certyfikat zweryfikowanego kompilatora C.
3. Wykonanie: nowe ograniczone kontrole prefix C/Lean/Sage i mutanty.
   Historyczne ASan/UBSan i szerokie kampanie PREV są wcześniejszymi wynikami,
   nie nowymi uruchomieniami GLOBAL. Nowe kontrole nie zastępują FORWARD_GLOBAL.
