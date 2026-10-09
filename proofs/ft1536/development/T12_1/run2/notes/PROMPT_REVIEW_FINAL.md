# PROMPT — FINAL full-corpus review (przebieg przed importem stages)

Rola: INDEPENDENT REVIEWER (owner-designated). Świeży kontekst. Cel:
ostatni, kompletny przegląd CAŁOŚCI przed formalnym importem
(`archive.py` + tag). Własny replay mile widziany — to jest przegląd,
którego wynik ma pozwolić właścicielowi powiedzieć „importujemy".
Pisz raport we własnym W (`proofs/ft1536/work/FT1536_FINAL_REVIEW_001/`),
z `REVIEW.md`, `REVIEW_RESULT.json`, INPUTS/OUTPUTS sha256. Werdykt:
`PASS_SCOPED` (z dokładnym zakresem) / `CHANGES_REQUIRED` / `FAIL`.

Zakres: całość T12.1 + paper, na aktualnym `main` (zapisz SHA):

1. **Warstwa dowodowa run2/** — `Assembly`, `AssemblyComp`, `CompPrg`,
   `AdvPrg`, `SignLayerSupport`, `AttemptWeights`, `AttemptPointwise`,
   `T5Pointwise`, `HacGlue`, `JointDecomp`, `ONoneGeometry` + audyty
   aksjomatów (wszystkie podzbiory standardu) + zero markerów
   niedokończonego dowodu (surowo i po stripie komentarzy).
2. **Warstwa źródłowa source3/** — korpus `Source3/*` (53+ modułów,
   ~4-5k deklaracji): spójność pinów BATCH_001–033, czystość logów,
   nie-wakuatywność audytów (`map ... = some`), twierdzenia graniczne
   (`KeygenCallerSuccess.exact_integer_ntru`, `KeygenNttTransform.source_transform`,
   `KeygenMkgm3.source_contract` i wnioski BATCH_032) — wykaż, że
   wnioski mają dokładnie deklarowany zakres (NIE cały
   `falcon_keygen_make`, bez terminacji/akceptacji/rozkładu kluczy).
3. **Spójność paperu z tezą** — `paper/` vs aktualne moduły: każde
   zdanie z nagłówka w granicach twierdzeń; etykiety
   CLOSED/IN-FLIGHT/OPEN zgodne ze stanem; deklaracje bezpieczeństwa
   (liczby podwójne + kapsle) nie przekraczają estymatora (S06 =
   niecertyfikowane!) ani nie pomijają granic (ROM/PRF/A1/A2/A3-A4/brak QROM).
4. **Mapa „nie otwierać / nie powtarzać"** — `run2/notes/B4_SYNTHESIS.md`:
   sprawdź, czy raporty/wnioski projektu nie powtarzają zamkniętych
   diagnoz (E2/E3, B1.03 tablice, B1.04 transformacja, łańcuch solventa
   B1.05) i czy zamknięte rzeczy są faktycznie zamknięte (nie
   „przemianowane").
5. **Wykrywanie nadmiarowych założeń** — lista wszystkich przesłanek
   w ostatecznym zestawie twierdzeń: każda musi być albo dowiedziona,
   albo jawnym założeniem świata (ROM/PRF/A1) albo udokumentowanym
   interfejsem (keyIdent/KeyLawBinding, most uczciwy-Sign, most bajtowy).
   Żadnych cichych przesłanek.

## Wymagania wyjściowe (to wjeżdża na odbiór stages)

- werdykt + numerowana lista rozbieżności (jeśli są),
- **rekomendacja importu**: TAK/NIE do `archive.py import` + tag,
  z dokładnym zakresem do otagowania,
- polskie podsumowanie dla właściciela: co projekt ostatecznie twierdzi
  (jedno zdanie), jakie są granice (jedno zdanie) i co świat może z tym
  zrobić (jedno zdanie).
