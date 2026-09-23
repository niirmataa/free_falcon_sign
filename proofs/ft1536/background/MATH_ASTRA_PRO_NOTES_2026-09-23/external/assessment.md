# FT1536 — przegląd pakietu matematycznej redukcji EUF-CMA → MT-ISIS

Data przeglądu: 2026-09-23.
Przedmiot: `FT1536_MATH_EUFCMA_MTISIS_RUN_001.tar.xz`.

## Werdykt i zakres

**Wartościowy pakiet częściowy. Status PARTIAL_PROOF odpowiada zawartości. Nie jest to jeszcze pełne warunkowe twierdzenie redukcyjne ani dowód bezpieczeństwa instancji FT1536.**

Przeczytano wszystkie 15 własnych modułów matematycznych Lean, audyt, dokumenty specyfikacji, ledger mostów, następny interfejs, skrypt Sage i sterownik replayu. Niezależnie sprawdzono integralność, zgodność deklaracji z zapisanymi eksportami i logami oraz wskazane obliczenia wymierne. Nie wykonano nowej kompilacji Lean ani Sage. W środowisku przeglądu nie ma Lean, Lake, Sage ani bwrap; nie ma też zewnętrznego, przypiętego cache bibliotek wymaganego przez sterownik.

Rozróżnienia używane poniżej:
- **Pakiet:** treść dostarczonych definicji, dowodów i zapisów wykonania.
- **Sprawdzono tutaj:** nowa kontrola integralności, statyczna lub arytmetyczna wykonana podczas tego przeglądu.
- **Nowe wyprowadzenie:** argument analityczny autora przeglądu na podstawie definicji pakietu, jeszcze nie sformalizowany w Lean.

## 1. Co rzeczywiście zweryfikowano tutaj

| Kontrola | Wynik |
|---|---|
| REPORT względem pinu z wiadomości użytkownika | zgodny |
| OUTPUTS względem pinu z wiadomości użytkownika | zgodny |
| Członkowie OUTPUTS | 4461/4461, bez powtórzonych ścieżek |
| Członkowie INPUTS | 27/27 |
| Członkowie REPLAY_SEED | 3508/3508 |
| Dołączone źródła closure bibliotek | 3456/3456 zgodnych hashy |
| Własne moduły i deklaracje theorem | 15 modułów, 101 deklaracji |
| Eksporty względem źródeł, linii i logu audytu | 101/101 zgodnych |
| Zapisane zbiory aksjomatów | wyłącznie propext, Classical.choice, Quot.sound; część deklaracji ma podzbiór lub nie wymaga żadnego |
| Własne źródła po pominięciu komentarzy | nie znaleziono sorry, admit, native_decide, Lean.ofReduceBool, axiom ani unsafe |
| Zapisany replay autora | 19 zadań z exit0; zachowane stdout/stderr zgodne z hashami, bez warning/error w końcowych logach |
| Trzy produkty semantyczne | zapisane porównania zgodne z EXPECTED i dołączonymi treściami |
| Nowe wykonanie kernela/Sage | **nie wykonano** |

`19/19` oznacza tutaj zadania wykonania, a nie 19 plików źródłowych czy 19 dowodów. Trzy produkty to JSON certyfikatów, wygenerowany `Certificate.lean` oraz kompletny log audytu.

Piny:

```text
REPORT
fa6bbac7b379d80c256ceb2875a67106a1d7322d84e7ee0cc6b8bddecec7de9a
OUTPUTS
a9e3af2ebccc221035024fabc7631fa47a93b841c1611e3e79f28ccf5ee5c98f
archive
 e4434fa5632fef5437ff756811639d1aea7e25661626664a64c892dabeafeff1
```

Kontrola źródeł bibliotek nie jest nową weryfikacją 17280 zewnętrznych artefaktów cache. Pakiet podaje ich piny, lecz wymaga dostarczenia tych artefaktów w środowisku odbiorcy.

## 2. Najważniejsze ukończone składniki

### 2.1. Rachunek pełnego retry

`MathSign.lean` definiuje skończone, IID powtarzanie tego samego prawa próby przy stałym celu. `cap_none`, `cap_some` i `full_reply_law` wyprowadzają masy wyczerpania oraz pierwszego wyniku kończącego próby. `RetryDivergence.lean` dowodzi mieszaniny z abortem i kierunkowego drugiego momentu `1/p` dla **successOnly**, którego masa abortu jest zerowa.

To wynik ogólny, nie tylko numeryczne sprawdzenie cap16. Emit jest nakładany po cap; jego failure nie uruchamia kolejnej próby.

### 2.2. Kierunek chi² i pełne historie

`Divergence.AC j p` wymaga, by zerowa masa P implikowała zerową masę J. `chi2` zwraca nieskończoność przy niezgodności nośników. Funkcja pomocnicza `second` jest realną sumą ilorazów, z konwencją dzielenia przez zero Leana; dlatego **nie należy używać samego boundu second jako dowodu skończonej chi² bez AC**. Końcowe twierdzenia transferu rzeczywiście wymagają AC.

`Adaptive.lean` zachowuje cały prefiks przez `Hist (n+1)=Hist n × observation`; jądra mogą zależeć od historii. Dowód nie wymaga niezależności całych odpowiedzi. Wykładnik w abstrakcyjnym twierdzeniu jest liczbą przejść `n`; powiązanie go z Q_s nie zostało jeszcze dowiedzione.

### 2.3. Nierówność zdarzeniowa

`EventTransfer.event_quadratic` wyprowadza z density i ważonego Cauchy'ego–Schwarza:

\[
(a-b)^2\le\Delta a(1-a),
\]

przy a=P(E), b=J(E), kierunku J||P. Następne twierdzenia dowodzą górnego pierwiastka Phi, monotoniczności po b i przypadków brzegowych. To nie jest przypadek porównywania rozkładu z samym sobą.

### 2.4. Tabela ROM i ekstrakcja

`ROM.lean` odróżnia wpisy pochodzące z Sign od wpisów z konkretnym indeksem celu. Powtórzone wartości celów, w tym zero, nie są wykluczane. Przy świeżej wiadomości finalny wpis nie ma pochodzenia Sign; `indexed_extraction` wiąże wyciągnięty świadek z właściwym celem i zakresem indeksów Q_H+1.

`PublicCode.simSign` ma rzeczywisty kod względny wobec parametru `PublicSampler.run`: najpierw wpisanie wiadomości do SeenSign, rozróżnione aborty, sprawdzenie konfliktu nazwy, potem próbkowanie i programowanie. Sam parametr funkcji nie stanowi jednak certyfikatu jej efektywności ani realizowanego rozkładu.

## 3. Dlaczego finite_trace_bound nie jest jeszcze redukcją

Źródło: `formal/FT1536/TraceBound.lean`.

Twierdzenie przyjmuje m.in.:

```lean
(j p : (n : ℕ) → Hist α n → Law α)
(hac : ∀ n x, AC (j n x) (p n x))
(hchi : ∀ n x, second (j n x) (p n x) ≤ 1+e)
(extracts : ∀ x, Win x ∧ ¬ Bad x → MT x)
(hbad : (transcript p n).event Bad ≤ eps)
```

i dowodzi:

```text
P_transcript(Win) ≤ min(1, eps + Phi((1+e)^n−1, J_transcript(MT))).
```

To poprawnie opisany **ogólny silnik transferu prawdopodobieństw**. Nie ma jeszcze dowodu, że przekazane prawa są prawami realizacji konkretnego A w EUF-CMA i konkretnego B w MT-ISIS. Zmienna `MT` w tym twierdzeniu jest predykatem na transkryptach, nie gotowym eksperymentem MT-ISIS.

Brakuje skonstruowanego głównego wyniku `∀ A, ∃ B` ze zdefiniowanymi grami, identyfikacją ich praw i zasobami B. Nie wystarczy nadać abstrakcyjnym predykatom nazw EUF/MT.

**To są pozostałe obowiązki matematyczne, nie wyłącznie most do C/FPEMU.** Można je najpierw dowieść analitycznie, a później sformalizować; brak sformalizowanego interpretera sam w sobie nie unieważniałby kompletnego dowodu na papierze. W tej paczce jednak ten krok pozostaje otwarty również w deklarowanym argumencie.

## 4. Zakres zrealizowanej Sigma_math

Źródła: `MODEL.md`, `PublicSimulation.lean`, `Model.lean`, `BRIDGE_LEDGER.md`.

Jest to E0/coefficient-valued finite-box G16. Każdy współczynnik w box należy do przedziału −65535,…,65535. Próba jest ważonym rozkładem na włóknie A_h(z)=c w tym box, następnie podlega Q<B i cap16, a dopiero po akceptacji Emit sprawdza signed16 drugiej składowej.

Pakiet dowodzi, że cały support Q<B mieści się w box. To ważne, ale nie wystarcza do utożsamienia **pełnego prawa 16 prób** z gaussem nieograniczonym: obcięcie proposal zmienia normalizer włókna, a więc prawdopodobieństwo akceptacji i wyczerpania retry. Support już zaakceptowanych próbek może się zgadzać, podczas gdy częstość abortów się różni.

Rozkłady są specyfikacjami `noncomputable`. Efektywny publiczny sampler, jego prawo i koszt pozostają oddzielną przesłanką/instancjacją. Nie wybrano małych e_img/e_sign ani poziomu bezpieczeństwa.

## 5. Kontrprzykład centrowania

Źródło: `Geometry.centering_can_break_acceptance` oraz `Certificate.centering_values`.

Dwa niezerowe bloki:

\[
z_1=(9217,-5000),\qquad z_2=(32767,18000).
\]

Reszta współczynników jest zerowa. Niezależna arytmetyka całkowita daje:

\[
Q(z_1,z_2)=2051350378 < 2093922385,
\]
\[
\operatorname{center}_q(z_1)=(-9216,-5000),
\]
\[
Q(\operatorname{center}_q(z_1),z_2)=2143496945>2093922385.
\]

Zapas przed centrowaniem: 42572007. Przekroczenie po centrowaniu: 49574560. Druga składowa w pełni mieści się w signed16.

Wniosek pakietu jest poprawnie ograniczony: nie wolno przyjmować ogólnej implikacji krótki świadek → akceptowany podpis. Nie jest to fałszerstwo, odzyskanie klucza ani obalenie trudności MT-ISIS. Nie obala też przeciwnej implikacji akceptacja → krótki wyekstrahowany świadek.

### Nowe wyprowadzenie przeglądu: znaczenie dla zadeklarowanego modelu matematycznego

Dla dowolnego h wybierz c=A_h(z) dla powyższego z. Wektor leży w box, ma Q<B, jego waga exp(−Q/(2σ²)) jest dodatnia i Emit zwraca signed16 z2. Dlatego przy tym c modelowa pierwsza próba ma dodatnie prawdopodobieństwo zwrócenia tej próbki, a Verify następnie odrzuci wynik. Uniform c obejmuje ten cel z dodatnią masą.

Z samych definicji tej **konkretnej Sigma_math** wynika więc brak bezbłędnej poprawności Sign→Verify. To analityczny wniosek przeglądu, nie nowy eksport Lean. Nie określa rozmiaru prawdopodobieństwa błędu, nie dowodzi jego nienegligowalności i nie rozstrzyga osiągalności w rzeczywistym C/FPEMU.

W dalszej pracy należy osobno sformułować poprawność z dopuszczalnym prawdopodobieństwem błędu. EUF-CMA i poprawność uczciwych podpisów nie są tą samą własnością. Nie należy usuwać problemu przez niejawne dodanie Verify do Emit.

## 6. Nowe wyprowadzenie przeglądu: dokładny most cap16 + Emit

Poniższy argument nie jest już ukończonym twierdzeniem w paczce. Jest propozycją konkretnego następnego lematu na podstawie jej definicji.

Dla ustalonego h,c oznaczmy przez Z_c sumę dodatnich wag proposal w box na włóknie oraz przez S_c sumę wag na tym samym włóknie z Q<B. Dla S_c>0:

\[
a_c=S_c/Z_c,\qquad p_c=1-(1-a_c)^{16}>0.
\]

Niech L_c będzie prawem **po Emit**, gdy z wybrano z zaakceptowanego włókna z wagami w(z)/S_c. L_c może przypisywać dodatnią masę POST_ABORT z powodu signed16.

Dla pierwszej udanej próby geometryczna suma daje masę p_c w(z)/S_c. Po Emit całe prawo ma więc postać:

\[
K_c=p_cL_c+(1-p_c)\delta_\bot.
\]

Z kolei publiczne prawo pary ma postać J(c,o)=ν(c)L_c(o), gdzie ν(c)=S_c/Σ_d S_d.

Jeżeli b_c=L_c(⊥), dla p_c>0:

\[
1+\chi^2(L_c\|K_c)
=\frac{1-b_c}{p_c}
+\frac{b_c^2}{1-p_c+p_cb_c}
\le\frac1{p_c}.
\]

Przypadek p_c=1,b_c=0 rozliczamy osobno (K_c=L_c); składnik 0/0 nie jest niejawnie użytym dzieleniem analitycznym. Dla p_c<1 różnica między 1/p_c a wyrażeniem wynosi:

\[
\frac{b_c(1-p_c)}{p_c(1-p_c+p_cb_c)}\ge0.
\]

**Równość 1/p z successOnly nie przenosi się automatycznie na prawo po Emit, jeżeli jego masa abortu jest dodatnia.** Jako górna granica 1/p pozostaje poprawne. Pakiet nie twierdzi, że ten most został już zastosowany; jest to uwaga do dalszej kompozycji, nie zarzut fałszu istniejącego `success_vs_capped_second`.

Daje to również skończoność właściwego kierunku J||P w finite-box modelu: na support ν mamy p_c>0 i K_c(o)≥p_cL_c(o). Nie dowodzi małości e. Dokładną faktoryzację można następnie zapisać:

\[
1+\chi^2(J\|U K)=
\sum_{c:\nu(c)>0}\frac{\nu(c)^2}{U(c)}
\left(\frac{1-b_c}{p_c}+\frac{b_c^2}{1-p_c+p_cb_c}\right).
\]

Nowy checker sprawdził formułę po Emit w 16 dokładnych przykładach wymiernych. Argument ogólny stanowi powyższe wyprowadzenie; próby nie zastępują dowodu.

## 7. Kontrole arytmetyczne wykonane niezależnie

- Kierunkowe chi²: 1/8 oraz 1/9 przy zamianie argumentów.
- Nietrywialny przykład adaptacyjny: dokładnie 99/256, zgodna faktoryzacja, górna granica 7/9 przy e=1/3.
- Nierówność zdarzeniowa: wszystkie 16 zdarzeń małego modelu.
- Retry: 9 kombinacji a∈{0,1/3,1}, n∈{0,1,16}; dokładna zgodność z JSON pakietu.
- Suma konfliktów: 60 kombinacji Q_s,Q_H.
- Z niezależnie obliczonych liczb odtworzono dokładne bajty źródła `Certificate.lean`. **Nie skompilowano tego pliku.**

Nie wykonywano nowego RBF256; jego zapis pozostaje częścią sprawdzonych materiałów autora.

## 8. Następny cykl, bez ponownego budowania rachunku Phi

Rekomendowany cel to `INTERACTIVE_GAME_AND_RESOURCE_BINDING` dla tego samego zakresu matematycznego.

1. Zdefiniować przeciwnika z ograniczonymi zapytaniami, bajtami, czasem i monetami oraz interpreter gry. Zdefiniować skończoną listę Q_H+1 celów, nie bezkosztową nieskończoną funkcję.
2. Dowieść równoważności lazy ROM z celami ujawnianymi w kolejności użycia. Niewykorzystane cele pozostają jednostajne i niezależne względem potrzebnej historii; nie warunkować tego kroku na całej przyszłej liście celów.
3. Włączyć jednorazowe prawo klucza, tabelę ROM, SeenSign i pełne odpowiedzi. Wskazać dokładnie, co zawiera historia dowodowa, a co widzi publiczny sampler.
4. Udowodnić, że najwyżej Q_s przejść ponosi koszt 1+e, a pozostałe wspólne kroki i padding nie dodają nieuzasadnionych czynników. Samo podstawienie n=Q_s nie wystarczy.
5. Podłączyć konflikt nonce i ekstrakcję do praw wyników interpretera. Zbudować B jako kod, nie jako rekord zawierający oczekiwaną nierówność.
6. Przyjąć poprawnie określony certyfikat lokalnego samplera jako parametr **warunkowego** wyniku i wyprowadzić narzut redukcji. Do twierdzenia jakościowego można użyć jawnego wielomianowego narzutu; konkretny cel M0 wymaga następnie wskazanego modelu bit-cost. Nie potrzeba do tego zakończonego dowodu C/FPEMU.
7. Osobno uzupełnić most cap/Emit z §6, instancję efektywnego samplera i małe błędy dla właściwego modelu. Nie utożsamiać tych zadań z warunkowym metatwierdzeniem.

Kryterium odbioru następnego etapu: istnieje wynik `∀ A, ∃ B` odnoszący się do zdefiniowanych eksperymentów i zawierający udowodnione zasoby B, a nie jedynie bound dla dowolnych praw transkryptów.

## 9. Odtwarzalność na obcej maszynie

Pakiet jest przypięty i zawiera źródła importów, ale nie jest samowystarczalnym instalatorem środowiska. `tools/replay.py` wymaga konkretnych cached artifacts, Lean/Sage o podanych hashach i bwrap. `--library-map` relokuje biblioteki; ścieżki samych programów są nadal brane z TOOLCHAIN.json. Zewnętrzny odbiorca powinien mieć osobny, jawny bootstrap środowiska albo zatwierdzony sposób relokacji plików wykonywalnych przy zachowaniu ich tożsamości. To kwestia przenośności replayu, nie brak dowodu matematycznego.

## 10. Podsumowanie

Nie ma podstaw do nazwania pakietu pełną redukcją ani do ogłoszenia poziomu bitowego. Są natomiast nietrywialne, wielokrotnego użytku dowody prawdopodobieństwa oraz operacji reduktora. Następne zadanie jest konkretnie zidentyfikowane. Status PARTIAL_PROOF nie oznacza zerowego rezultatu; poprawnie oddziela ukończone składniki od niewykonanej jeszcze kompozycji gry i kosztów.

Przegląd nie zmienia źródeł ani statusów autora. Nie jest nowym kernelowym replayem ani formalnym owner acceptance.
