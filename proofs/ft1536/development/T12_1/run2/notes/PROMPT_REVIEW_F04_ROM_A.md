# PROMPT — NIEZALEŻNY ODBIÓR pakietu F04 (wariant A) + F05

Rola: INDEPENDENT REVIEWER (wyznaczony przez właściciela). Świeży
kontekst. Cel: odbiór pakietu naprawy F04 (wariant A — wyzwanie ROM
spoza taśmy samplera) oraz F05 z toru run2. Wynik recenzji ma
pozwolić właścicielowi powiedzieć „przyjmujemy". Piszesz raport we
własnym W (`proofs/ft1536/work/FT1536_F04_ROM_A_REVIEW_001/`):
`REVIEW.md`, `REVIEW_RESULT.json`, INPUTS/OUTPUTS sha256. Werdykt:
`PASS_SCOPED` (z dokładnym zakresem) / `CHANGES_REQUIRED` / `FAIL`.

## Zakres (przypięte commity, tor run2 — 832a9953..35420d59)

Pakiet: `run2/notes/F04_ROM_VARIANT_A_001.json` (piny 17 źródeł,
12 konsumentów, F05, środowisko) + `F04_ROM_VARIANT_A_001_NOTES.md` +
`F04_ROM_VARIANT_A_CHECKPOINT.md` + audyt konsumentów
(`.build/f04_rom_a_001/audit/F04ConsumersAudit.log`) + próby
(`.build/f04_rom_a_001/attempts/`, run_001..run_011) + receipt
`final_clean_002`.

## Kontrole (numerowane wyniki)

1. **Replay**: świeży rebuild closure run2 (167 modułów) z przypiętych
   bajtów; czyste logi; aksjomaty wyłącznie standardowe (propext,
   Classical.choice, Quot.sound lub podzbiory); zero sorry/admit/
   native_decide/wyciszonych ostrzeżeń.
2. **Wierność modelu wariantowi A** (decyzja właściciela 2026-10-11):
   c = H(r‖m) losowane z ROM spoza taśmy; `Sampler.code` przyjmuje
   wyzwanie jako wejście; `Games.sample` losuje odpowiedź ROM, potem
   szum; `samplerLaw = Law.uniform × replyLaw`. Sprawdź, że margines
   wyzwania to DOWÓD (`JointDecomp.samplerLaw_marginal_uniform`,
   d1 = 0 bez luki), NIE etykieta; `RomChallengeAt` jest zrealizowane
   przez `romChallengeAt`, nie założone; most `UniformChallengeAt`
   usunięty w całości (brak resztek po nazwie w typach).
3. **Wszyscy 12 konsumentów** przepisanych bez huc (4× HacGlue.
   localJointCertificate_of_*, ONoneGeometry.
   localJointCertificate_of_attemptFactor, 5× Assembly, 2× AdvPrg) —
   porównaj sygnatury z audytem; żaden konsument nie zachował ukrytej
   resztki huc/UniformChallengeAt; żadnej nowej nazwy na starej
   fałszywej przesłance.
4. **Koszty/hprg = wariant A**: pole wyzwania na wejściu samplera,
   wyjście = sama odpowiedź (≤ 26113 bitów), `challengeCost`
   zafakturowany osobno, szew PRG/taśma obejmuje wyłącznie szum.
5. **F05**: floor tylko na właściwym supporsie (0 < target), zera poza
   włóknem osobno (hzero jako nazwana przesłanka źródłowa), estyma
   względna bez podłogi. Zweryfikuj pin spójności: warunkowa sprzeczność
   audytu znika na rzeczywistym TowerWhole — i że to NIE jest
   zamiecenie (porównaj faktyczne postaci twierdzeń).
6. **Nienaruszony**: `AssemblyComp.advMT_ge_of_public_sim_stream_win` —
   typ bez huc, cała closure się kompiluje; jego zakres poza zarzutem
   i poza naprawą.
7. **Historia i piny**: próby zachowane z przyczynami; pary JSON/NOTES
   zgodne z zawartością; receipt `final_clean_002` (167/167 z bajtów
   commitowanych) odtwarzalny.
8. **Uczciwość otwartych**: naprawa jest INTERFEJSOWA — nie wolno
   dopisać jej do niej: wiązania S.code z do_sign (B1/source3), mostu
   bajtowego, zastrzeżenia o błędzie addytywnym; F05 w wariancie
   podłogowym potrzebuje przesłanki hzero; F06 nietknięte. Trzy pliki
   historyczne-śladki i trzy FftBind zależne od Source3.* są świadomie
   poza zakresem — sprawdź, czy faktycznie nic ich nie importuje.

## Wymagania wyjściowe

- werdykt + numerowana lista rozbieżności (jeśli są),
- rekomendacja dla właściciela: przyjmować / zmiany wymagane —
  z dokładnym zakresem do otagowania,
- polskie podsumowanie: co naprawa realnie daje paperowi, co nadal
  ciąży (źródłowe: ReplyShape, most bajtowy, hzero), jedno zdanie
  zaufania do wyniku.
