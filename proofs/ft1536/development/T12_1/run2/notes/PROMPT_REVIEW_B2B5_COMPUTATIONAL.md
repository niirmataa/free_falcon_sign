# PROMPT — niezależny odbiór pakietu B2/B5 (szew obliczeniowy) — dla recenzenta wybranego przez właściciela

Zakres odbioru (READ-ONLY; nie modyfikuj niczego): commity `68cf5671`
(`formal/CompPrg.lean`, 986 linii), `79d289d2` (`formal/AssemblyComp.lean`,
328 linii), `e961ca9f` (`notes/B2B5_COMPUTATIONAL_WORK_STATE.md`) w
`proofs/ft1536/development/T12_1/run2/`. Kontekst: niezależna recenzja
z 2026-10-06 wykazała dwa szwy (predykat statystyczny zamiast
obliczeniowego; składnik PRG doklejony zamiast przejścia grami). Ten
pakiet jest na nie odpowiedzią. `Assembly.lean` i `AdvPrg.lean` mają
zostać nietknięte — potwierdź.

## Protokół weryfikacji mechanicznej (własne ręce)

1. Przebuduj oba pliki strzeżoną kompilacją (`tools/original/
   run_lean_guarded.sh`) — oczekiwanie 0/0 (logi puste), exit 0.
2. Audyt aksjomatów: `.build/audit/CompPrgAudit.log` (56 wpisów; spodziewaj
   się zbiorów będących podzbiorami `[propext, Classical.choice,
   Quot.sound]`) i `AssemblyCompAudit.log` (8/8 standard). Porównaj listę
   deklaracji plików z listą audytu — żadnej deklaracji bez audytu i żadnego
   wpisu-widma. Uwaga na zawijane linie logów.
3. Grep markerów niedokończonego dowodu (`sorry`/`admit`/`native_decide`)
   w obu plikach i ich imporcie w granicach run2.

## Cele merytoryczne (główna robota)

**A. Kształt założenia.** `CompPRGBound C tau deltaPRG` ma kwantyfikować
WYŁĄCZNIE po dopuszczonej klasie testów `C` (parametr; bez maszyn
Turinga). Sprawdź, czy żadna ścieżka nie wycieka do nieograniczonego
kwantyfikatora (stary `ChaCha20PRFBound` miał `forall E` = TV — wykaż,
że nowy predykat nie sprowadza się do niego). `CompWinCert` (wygrane
zdarzenie złożonego adwersarza należy do klasy + linia kosztu
`cost <= T(A) + q * blockCost`) — sprawdź typ i czy hop go realnie zużywa.

**B. Odchyłka hopa (flaga koordynatora 1).** Prompt zamawiał
`AdvEUF_stream <= Games.AdvEUF + delta`; autor zgłasza to za niewykonalne
(`Games.AdvEUF` nie ma taśmy; gra sampler-orakulum na taśmie równej !=
gra uczciwa — różnica = czynnik certyfikatu) i hopuje wprost do
`AdvMT(Reduction.build)` przez `concrete_lazy_game_binding` +
`streamGame_uniform_eq_advMT`. Rozstrzygnij: (1) czy ta identyfikacja
jest dokładna i na jakiej przestrzeni prawdopodobieństwa; (2) GDZIE
w tym łańcuchu wchodzi czynnik D = (1+(k^32-1))^beta.qs - 1 (budżet
e = k^32-1) — bez niego wiązanie zgubiłoby stratę drugiego momentu.

**C. Roszczenie „towarzysza" (flaga koordynatora 2, najostrzejsza).**
Work-state podaje, że w tym łańcuchu istnieje towarzysz
`Adv_MT >= epsilon_real - deltaPRG` (bez składnika sqrt(D*...)), który
liczbowo PRZEWYŻSZA odwróconą formę Phi. Jeśli to prawda, silniejsze
wiązanie dominuje i czynnik D znika z granicy — brzmi za dobrze.
Rozstrzygnij: jakie ilości pokrywają oba wiązania, skąd bierze się
różnica (faktor certyfikatu? inne zdarzenie? inny eksperyment?), i czy
obie postacie są formalnie spójne. Jeśli towarzysz jest słusznie silniejszy —
zapisz to jawnie jako główną postać; jeśli jest błędy — wskaż krok.

**D. Odwrócenie Phi (dokładność).** `f = max 0 (a - sqrt(D*a*(1-a)))`,
`a = epsilon_real - deltaPRG - epsColl`. Zweryfikuj, że to OSTRY odwrotnik
repozytoryjnego `Phi` (twierdzenie `phi_satisfies` — sprawdź, czy to
równość dla dziedziny użycia), brzeg `phiInv D (D/(1+D)) = 0` zgodny
z istniejącym `phi D 0 = D/(1+D)` oraz nieujemność/definiętność przy
wszystkich dopuszczalnych wartościach (sqrt domena!).

**E. Szczerość zakresu.** Raport twierdzi, że nowy łańcuch NIE zużywa
przesłanek starego (huc/hshape/hattempt) — sprawdź, czy nie ma ukrytych
nadmiarowych założeń (i czy brak ich zużycia jest SŁUSZNY, czy zgubiony).
Potwierdź, że TV-lematy i `route_a_closed` zachowane (nagroda śmierci
trasy statystycznej) i że `Assembly.lean`/`AdvPrg.lean` są bajtowo
nietknięte (`git log -- <ścieżki>`).

## Werdykt

`PASS_SCOPED` (z dokładnym zakresem) / `CHANGES_REQUIRED` (numerowane
poprawki E1..En z odwołaniem do linii) / `FAIL`. Bez pośpiechu: to
ostatni szew koncepcyjny przed realizacją B1 — błąd tu jest droższy niż
godzina więcej. Wynik zapisz w osobnym pliku recenzji we własnym W;
niczego nie commituj do W T12_1.
