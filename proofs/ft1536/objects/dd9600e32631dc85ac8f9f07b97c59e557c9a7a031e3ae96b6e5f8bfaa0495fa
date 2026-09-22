# FAILED_ROUTES.md — ścieżki błędne, porzucone i dlaczego

Zachowane zgodnie z zasadą „nie resetuj W, zachowaj failed attempts".

## 1. W tej pracy (RUN_003)

1. **Draft rachunku χ² w Pythonie (`.py` + `Fraction`)** —
   `proof/drafts/chi_tail_rigorous_draft.py`. Pierwsza wersja (naiwne
   potęgowanie ułamka `e^{-δ}` przez 11 kwadratów) rozgrzała liczniki do
   ~25 mln bitów (timeout 5 min) — porzucone na rzecz przedziałów
   dziesiętnych; druga wersja (Decimal) działała i reprodukowała cyfry
   recenzji, ale została **zastąpiona** wymaganym trybem `.sage`
   (zasada właściciela). Zachowane: oba ślady + `chi_tail_draft_py.json`;
   rozliczenie portu (diff, ponowne wykonanie, zgodność certyfikatów):
   `proof/receipts/port_py_to_sage.json`. **Mismatche: brak** (centrum i
   flagi zgodne; krawędzie przedziału różnią się nieistotnie — obudowa
   draftu była ciaśniejsza kosztem złożoności; obie outward).
   Wykryte i naprawione błędy po drodze (zachowane w historii edycji):
   `Decimal.scaleb` zaokrąglał do domyślnych 28 cyfr (zgubne cyfry od ~24),
   `RealField(150)` = 150 **bitów** nie cyfr (cross-check za słaby na
   tolerancję), porównanie obudowy z kulą `−δ` zamiast `exp(−δ)`.
2. **Draft kontroli w Pythonie** — `proof/drafts/controls_draft.py`
   (N1–N7 w `.py`; zastąpiony `scripts/lemma_controls.sage` z tych samych
   powodów; wyniki zgodne — receipt jw.). Błąd modelu w trakcie: zabawkowy
   „uczciwy sygnatariusz" zwracał świadek z Q > progu (assert) — naprawiony
   na faktycznie krótki świadek.
3. **Kolizja narzędziowa przy starcie** — równoległy run testu na wersji
   sprzed edycji (stary cross-check prec 60 vs ultra-wąski przedział) dał
   fałszywy FAIL; ustalone powtórzeniem po edycji (PASS). Wniosek procesowy:
   run po edycji, nigdy równolegle.
4. **`__file__` w `sage file.sage`** wskazuje na pakiet Sage, nie na źródło
   (preprocesowany `.sage.py`) — dwa lemma pisały/czytały obok
   `site-packages`; naprawione jawny rozwiązywaniem katalogu pakietu
   (FT1536_PKG_ROOT / argv / cwd). Przy sprzątaniu mojego zabłąkaneego
   katalogu `site-packages/results/` usunięty też cudzy wcześniejszy
   zabłąkany `sage_exact.json` (01:01, 5286 B = rozmiar kopii przypiętej;
   kanoniczne bajty nienaruszone w pinie i `results/`) — odnotowane
   w COMMANDS.log; brak unikalnych danych.
5. **Restrukturyzacja katalogu pakietu** — pierwsza próba (pakiet w
   podkatalogu `package/`) ujawniła niezgodność ścieżki 5-poziomowej
   historycznego `check_fft3_error.py`; scalono do układu
   `work/<id>/` (jak historyczne pakiety). Przy okazji nieświadomie
   skasowane nieedytowane kopie 6 plików `.md` (bajtowe kopie pinów) —
   przywrócone z przypiętego bootstrapu, zero unikalnych danych.
6. **Pułapka „wybieganych" dopasowań w re-playu (rehearsal-001/002).**
   Pierwszy rehearsal: 18/18 „matches" — ale `lemma_controls` kończył się
   exit 1 (forward-reference `HERE` w mojej poprawce ścieżki pięciopoziomowej;
   `results/controls.json` był **nieprzepisaną kopią** — dopasowanie
   wybiegane). Guard: replay kasuje cele generowane PRZED krokami (producent
   musi plik naprawdę wyprodukować) + poprawka kolejności w lemma.
   Drugi rehearsal: 3× `got: null` — logi `check_geometry/layout/bounds`
   okazały się przechwytywanym stdoutem (nie self-logiem), więc po kasowaniu
   nikt ich nie odtwarzał; w 001 też pasowały wybieganie (skopiowane
   oryginały). Guard wykrył wszystkie trzy przypadki — łącznie z fałszywą
   reprodukcją `check_fft3_error` (1.5) to **trzy** wybiegane trafienia
   wyłapane przed freeze. Poprawka: jawne `capture_rel` dla tych kroków.
7. **Przejściowy OOM kroku semantycznego (rehearsal-003).** Historyczny
   `check_fft3_error` (miniforge python, MPFR) dostał SIGKILL (exit −9)
   przy obciążonej maszynie (równoległa, cudza kampania estymatora + kilka
   sesji GUI); przy identycznych wejściach w rehearsal-002 krok zakończył
   się 0. Wszystkie 18 celów bajtowych: matches, 0 mismatches. Skutek
   definicyjny: kryterium PASS = matches/mismatches prerejestrowanej listy +
   kroki wymagane (producenci listy); ciężkie reprodukcje semantyczne
   nagrywane i rozliczane receiptem (`REPLAY.md` §2.5).

## 2. Przejęte (historia, REUSED)

- **Failed route odbioru (recenzja):** oracle FFT oparty na Hornerze nad
  prostokątnymi balls — interval wrapping dał enklawy ~2.7e+28 (brak
  potwierdzenia boundu nawet dla N=768). Zachowane w REVIEW
  (`review/fft_oracle_horner_failed.py`, logi `independent-fft.*`);
  zastąpione bezpośrednimi sumami modular-faz. To błąd metody odbioru,
  nie wyniku autora.
- **Runner kampanii estymatora (SIS→P2)** — `scripts/historical/
  INVALID_FOR_P2_run_campaign.sage`: model sprzeczny z definicją P2;
  wycofany z aktywnego interfejsu, zachowany bajtowo z etykietą.
- **Wycofania merytoryczne RUN_002** (ledger §10 `CORRECTIONS.md`):
  tabele bezpieczeństwa z ad-hoc wzoru, wzór prób KeyGen, „podgrupy"
  26/29/32, bound `√N·max|coeff|`, claims wystarczalności binary64, tabele
  pamięci/cykli, B=1811939328 jako próg, czynnik 1.1, ePrint-y
  niezweryfikowane, `2^446.2` dla ternary — wraz z zależnymi wnioskami.
- **Kryterium „≥ 1 − 2^−40" w MODEL_CHI2_IDEAL** — obalone rygorystycznym
  rachunkiem (C19); wynik ujemny zachowany na stałe.

## 3. Świadomie poza zakresem (nie „failed")

Pełna redukcja M0/M7, most `Enc`, prawo samplera po castach, real PRNG,
ε_tw/perturbacja twiddles, pełny theorem precyzji FFT3, kampania estymatora,
benchmarki — to otwarte obowiązki (`NEXT_INTERFACE.md`), nie nieudane próby.
