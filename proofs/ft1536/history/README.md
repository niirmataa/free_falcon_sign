# Mapowanie lokalnej historii przed publikacją

Pierwsza próba publikacji ośmiu commitów dowodowych została odrzucona przez
ochronę prywatności adresu autora. Właściciel następnie wybrał adres GitHub
`245027293+niirmataa@users.noreply.github.com`.

Osiem niewysłanych commitów odtworzono na tym samym opublikowanym rodzicu
`1c0298fef46a0de399d2f6720b8658f7d7b58085`, z zatwierdzoną tożsamością
autora i committera. Zachowano wiadomości i daty autorstwa. **Dla każdego
starego/nowego commita sprawdzono identyczność całego drzewa Git.**

Pełna mapa i hashe drzew są w [2026-09-18-noreply-map.json](2026-09-18-noreply-map.json).

| Znaczenie | Dawny lokalny identyfikator | Identyfikator po zmianie e-maila |
|---|---|---|
| Workflow | `e054c2a` | `dc77d83` |
| L_V-STATIC | `791f092` | `0b7cc0d` |
| Odbiór Blue | `60f574e` | `bf4fb40` |
| L_RHO | `9333a08` | `5c2cdcc` |
| L_NTT częściowe | `e1ab6af` | `1d78645` |
| L_NTT_GLOBAL / inverse | `341d9f7` | `d67228d` |
| Zapis odtwarzania z Git | `a906460` | `3aaed5e` |
| Zadanie FORWARD_CRT | `7bd6ed4` | `9ab4b51` |

Historyczne raporty, zlecenia i receipts mogą nadal cytować pierwotne
identyfikatory lokalne. Mapa wskazuje odpowiadające im commity o identycznej
zawartości. Przykładowo replay opisany jako wykonany z `341d9f7` dotyczy
tego samego drzewa co `d67228d`; to powiązanie istniejącego wykonania,
nie deklaracja dodatkowego replayu po zmianie metadanych.

Piny SHA-256 plików, manifesty, źródła i werdykty matematyczne zachowują
dotychczasowe wartości. Zdalna historia istniejąca przed publikacją nie
była przepisywana; nowa linia commitów nadal jest jej rozszerzeniem.
