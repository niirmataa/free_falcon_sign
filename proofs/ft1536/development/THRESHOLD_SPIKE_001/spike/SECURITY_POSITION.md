# SECURITY_POSITION — bezpieczeństwo vs wydajność (szczere)

## Zasada
**Nigdy nie poświęcamy bezpieczeństwa dla wydajności w twierdzeniach.**
Stand-in XOF = **model kosztu/architektury**, NIE generator kluczy.
Realny klucz wymaga SHAKE256 (FIPS 202) lub równoważnego.

## Co realnie chronimy (własności w spiku)

| Własność | Mechanizm | Zakres |
|---|---|---|
| Sekret nie powstaje w jednym procesie | Shamir k-z-n, iso processes | **własność toru iso; harness= testowy**; do reconstruct („moment") |
| Fałszywy udział wykrywany | Pedersen `verify_exp_share`, spójność, MAC | n>k; semi-honest; **MAC = δ publiczne, nie SPDZ-MAC** |
| Fail-closed | `SpikeError`/abort, H3 reconstruct=FAIL | brak cichej kontynuacji |
| Accept-bit bez wycieku u | `cmp` P_w (d,e maski tylko) | prototyp; 255 Beaver/bit |

## Czego NIE chronimy (brak!)

| Luka | Skutek |
|---|---|
| **Stand-in XOF** (`xof_squeeze_blocks`) | **nie kryptograficzny** — nie używać do kluczy |
| Trusted dealer w keygenie | „moment": klucz istniał u dealera |
| Semi-honest | złośliwy gracz poza modelem |
| Brak SPDZ-MAC / UC | **Y6 łagodzi**: ukryte δ na otwieraniach; nadal brak UC/pełnego SPDZ |
| Rejection bias (P0.1) | wyciek informacji o kluczu |
| Brak pinów G(seed*)/packet | brak wierności formalnej |
| Klein 73-bit | sampler nie jest Falconowy |

## Wymagania do użycia w bezpieczeństwie (próg)

1. **XOF = prawdziwy SHAKE256** (lub inny z dowodem) w torze na udziałach.
   → **Y1/Y2/Y3 zrobione** (FIPS bit-exact na udziałach, multi-block, derive).
2. VSS/DKG bez dealera; SPDZ-MAC na otwieraniach.
   → **Y6–Y10: SPDZ-MAC z ukrytym δ** (δ shared; open = udziały zera;
   `iso mac-demo-hid` bez `delta.txt`; pipeline na ukrytym δ;
   **Y10 `dkg_delta_shares`** — δ = Σ r_i, bez dealera).
   Pedersen (H1) + tor iso; nie pełne malicious-secure.
3. Sampler z rozliczonym biasem (P0.1) i precyzją 73-bit.
   → **Y4 częściowo**: wagi Q73 + TV vs analityka. Pełny Klein MPC — otwarte.
4. Model złośliwy + audyt; świadectwo dołów (M7).
   → **Y13: mapa** (`Y13_MALICIOUS_MAP.md`) — co łapiemy / luki.
   Nadal **NIE** malicious-secure; otwarte: authenticated triples, UC.

## Werdykt na dziś
Pakiet = **badawczy** (architektura + koszty + testy). **Nie nadaje się**
do generowania kluczy ani progu FT. Bezpieczeństwa nie „oszczędzamy" —
**nie twierdzimy** o nim tam, gdzie go nie ma.
