# ZADANIE: niezależny review manuscriptu R2 (przed decyzją o ePrint)

Przegląd treści manuscriptu Free_FT_mathematical_R2 (edycja
redakcyjna druga, ~54 s.) — NIEZALEŻNY werdykt przed decyzją
właściciela o wysyłce na ePrint.

## Wejście (kolejność czytania)

1. /home/footfalcon/Pobrane/Free_FT_mathematical_R2_2026-10-16.pdf
   (manuscript R2; jeśli narzędzie nie czyta PDF — użyj ekstrakcji
   tekstu lub sprawdź, czy w paczcie jest źródło LaTeX);
2. proofs/ft1536/development/T12_1/run2/notes/B4_SYNTHESIS.md —
   żywy stan, granice twierdzeń, F01-F06, audyty A01-A06, decyzje;
3. proofs/ft1536/paper/SOURCES.md + notes/PAPER_WORK_STATE.md —
   mapa źródeł i stan paperu;
4. docs/onboarding/STATE.md — kronika decyzji i odbiorów.

## Co zweryfikować (review treści, nie składu)

(a) Zgodność statusów: każde zdanie statusowe manuscriptu musi
    zgadzać się ze stanem rzeczywistym — PARTIAL_PROOF; B1.07-09 =
    PASS_SCOPED warunkowo (zakres referencyjny C99/GCC LP64);
    prawo 134/KeygenModelBinding = p_K>0 OTWARTE (tor R1 w toku);
    S06 = CHANGES_REQUIRED; pomiar 2048/5907 jako POMIAR;
    brak jakichkolwiek twierdzeń QROM; D1 = obalone (acceptMass_
    positive_iff).
(b) Uczciwość założeń: Assumption 11.3 (kształty trial/reply) i 12.4
    (kontrakt source-to-experiment, w tym p_K>0) nazwane jako
    ZAŁOŻENIA, nie wyniki; Theoremy 10.3 i 12.5 warunkowe wprost;
    żadnego sformułowania szerszego niż dowód (lekcja F04!).
(c) Spójność liczb i wzorów: e = k^32-1 < 2^-32 (wariant A);
    k_cond = k/(1-rho), rho = 2^-24, < 2^-17; dlugosci kluczy
    7681-10369 i 2881; podpis 3160/3200; Phi((1+e)^q_s-1, b);
    eps_coll; stopy Tower/Machine/Wrap/Box (r=2^-46, v=2^-48,
    chi=2^-40, lambda=10^-1000); per-row budget 2^-58 dla 3072
    czynnikow; naglowki 170=0xaa, 138=0x8a.
(d) Bibliografia i przypisania: kompletnosc, rzeczywistosc pozycji,
    brak osirotkow i pozycji niecytowanych; Appendix B
    (statement-to-source) zgodny z prawda o repo.
(e) Reprodukcja: sprobuj zlozyc pakiet (make check + latexmk;
    SymPy 1.14.0) — odnotuj dokladnie co sie udalo i nie udalo.
(f) Czytelnik bez projektu: czy abstrakt i teza oddaja wynik bez
    nadmiaru; czy wyraznie widac, co jest dowiedzione, co zalozone,
    a co pomiarem.

## Zasady

NIE EDYTUJ manuscriptu ani repo; brak commitow i push; praca we
wlasnym katalogu proofs/ft1536/work/FT1536_R2_PAPER_REVIEW_001/.
Wszystkie ustalenia z odniesieniami (sekcja/rownanie/file:line).

## Wynik

R2_PAPER_REVIEW_001.md + R2_PAPER_REVIEW_001_RESULT.json:
werdykt PASS_SCOPED (gotowy do ePrint w dokladnie opisanym zakresie)
lub CHANGES_REQUIRED (lista poprawek). Trzy zdania na koncu
(co potwierdzone / najblizszy brak / czego nie implikuje).
