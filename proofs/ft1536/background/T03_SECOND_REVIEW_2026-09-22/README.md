# T03 — przypięte wejścia ponownego odbioru przez inny model

Decyzja właściciela2026-09-22: ponowny pełny odbiór częściowego wyniku T03
przez inny model. REVIEW_ID=FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002.
Wykonawcę wybiera i uruchamia ręcznie właściciel; prowadzący przygotował
wyłącznie dane/piny/zlecenie. Bez wykonania matematyki lub replayu.

W: `proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002`.
Read-only bundle: `W/inputs`,o następującej strukturze:

- `subject/`:85 OUTPUTS autora,sam manifest oraz pełna closure wejść
  (bootstrap1276 plików,POLICY i TASK pod aliasem). Oryginalne hashe zachowane.
- `prior_validation/`:niezmienne archiwum poprzedniego odbioru Muse Spark1.3Free,
  jego zapisane wyniki oraz administracyjna kontrola różnic3 hashy.
  To materiał porównawczy,nie wynik nowego recenzenta.
- `context/`:pierwotne zlecenie autora,pierwotny prompt odbioru i zasada Sage.

`BUNDLE.sha256` dotyczy ścieżek względem W/inputs. Jego identyczna kopia
w W/inputs/MANIFEST.sha256 pozwala sprawdzić exact set bez cache/bin/olean.
`ORIGINS.json` wiąże każdy plik z wersjonowaną ścieżką repo i SHA-256.
`PREPARATION.json` podaje liczby,piny i granicę kontroli prowadzącego.
Tutejszy `MANIFEST.sha256` obejmuje tylko cztery pliki metadanych tego katalogu.

Nowy recenzent przygotowuje własny writable seed i świeży DEST. Własny
argument A–D,fresh replay i nowe checkery `.sage` mają samodzielnie uzasadnić
werdykt. Hash źródła w każdym nowym receipcie musi zgadzać się z wersją
zamrożoną w nowym REVIEW_OUTPUTS. Starych niezgodności nie usuwa się z historii.

Wcześniej przygotowany FT1536_T03_REVIEW_SAGE_BINDING_SUPPLEMENT_001 został
zastąpiony tą decyzją (przy sprawdzeniu miał tylko AGENTS,bez aktywnych jobów).
Bieżące zlecenie wskazuje `proofs/ft1536/CURRENT_REVIEW_TASK.md`.
