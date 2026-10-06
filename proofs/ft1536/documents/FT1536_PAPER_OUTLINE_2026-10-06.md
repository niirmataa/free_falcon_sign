# FT1536 — paper outline (skrobany 2026-10-06, przed domknięciem drogi)

Roboczy szkielet paperu o redukcji EUF-CMA→MT-ISIS dla realnej
implementacji FT1536. Statusy w nawiasach: [ZAMKNIĘTE] = materiał gotowy
z kernela, [W LOCIE] = domyka się w torze B1, [OTWARTE] = przed złożeniem.
Zasada nadrzędna: paper mówi DOKŁADNIE tyle, ile teza — księga
uczciwości (założenia, nie-argumenty, granice) wjeżdża do treści, nie do
przypisów.

## Tytuły kandydaci (decyzja właściciela)

1. "Breaking Is Hard: a Reduction from EUF-CMA to MT-ISIS for a Real
   Lattice Signature Implementation" (mocno, technicznie)
2. "The Whole Elephant: End-to-End Security Reduction Bound to Running
   Code" (misja, styl)
3. "Free FT: Ternary Lattice Signatures with a Code-Bound Security
   Reduction" (rodzina + misja)

## Abstrakt (szkic — jedno zdanie tezy)

Pod trzema standardowymi założeniami (ROM, PRF ChaCha20, brak wycieku
timingu/prób) żaden atakujący EUF-CMA nie podrobi podpisu realnej,
przypiętej implementacji FT1536, chyba że złamie MT-ISIS — z jawnie
policzonym budżetem błędu `e = k^32 - 1 < 2^-32` (chi-kwadrat samplera
WYLICZONY, nie założony) oraz jawnym składnikiem `Adv_PRG(ChaCha20)` przy
skonsumowanych `n = q_s * S.bits` bitach taśmy. Dowód związany jest z
konkretnymi bajtami kodu C (piny SHA-256), nie ze schematem idealizowanym.

## 1. Wprowadzenie i misja [ZAMKNIĘTE — narracja właściciela]

- rodzina FT [FT768, FT1536, FT3072] na sekretach ternarnych; misja
  "free falcon, bez NIST, bez smyczy"; dla kogo to jest (wolni ludzie).
- dlaczego redukcja dla REALNEGO kodu, nie dla idealizacji (argument
  z własnych znalezisk: patrz sekcja 7).
- wkład: (i) redukcja z policzonym e dla realnego samplera, (ii) metoda
  source-bindingu z kontrprzykładami kernelowymi, (iii) uczciwa deklaracja
  poziomu bezpieczeństwa (podwójna liczba + kapsel), (iv) wyniki negatywne
  jako twierdzenia (bulk-only niemożliwy, trasa statystyczna martwa).

## 2. Rodzina FT i parametry [W LOCIE — dane z pomiarów/recepisów]

- parametry 768/1536/3072, ternarne sekrety (TRUE_TERNARY_SECRET_MODE),
- pomiar p_accept = 0.34671 (6 bramek, FG_PROBE, receipty) — jawna
  statystyka akceptacji zamiast założeń,
- różnice vs Falcon (format, sekrety, padding — krytyka 666 oparta
  na dowodach B3 [ZAMKNIĘTE], ton: fakty, nie inwektywa).

## 3. Preliminaria i model zagrożeń [ZAMKNIĘTE]

- MT-ISIS (waga, relacja), gry EUF-CMA dla strumieni; model dwumianowy
  per-attempt (D1) z conditioning KeyGen (muH/muKey, 1/p_accept = 2.88),
- założenia świata, jawnie: ROM (UniformChallengeAt), PRF ChaCha20
  (CompPRGBound z dopuszczoną klasą testów + CompWinCert),
- granice modelu, jawnie: A1 (brak wycieku timingu/liczby prób),
  A2 (granica siewu SHAKE/entropia), brak roszczenia QROM (cytat z
  dokumentu 2026-09-17: nie podajemy fikcyjnego boundu QROM).

## 4. Teza główna [ZAMKNIĘTE — Assembly + AssemblyComp; finalne scalenie W LOCIE]

- mapa czterech strzałek (oficjalny kształt montażu):
  realny Sign ->(hybryda obliczeniowa CompPRGBound)-> Sign na uczciwej
  losowowci ->(wiązania praw + certyfikat drugiego momentu)-> symulacja
  publiczna ->(ekstrakcja Reduction.build)-> MT-ISIS.
- postać granicy: eps_stream <= eps_coll + Phi((1+e)^q_s - 1,
  Adv_MT(Reduction.build)) + Adv_PRG(ChaCha20), e = k^32-1 < 2^-32;
- odwrotnik Phi w postaci odcinkowej psi_D (suplement REVIEW_002):
  psi_D(a) = 0 dla a <= D/(1+D), a - sqrt(D*a*(1-a)) wpp. —
  kontrapozytywna forma dla reduktora,
- test zakresu k=1/D=0 jako metodologia (co eksport realnie konsumuje).

## 5. Redukcja [ZAMKNIĘTE — Reduction.build, stopped_euf_to_concrete_mt, concrete_lazy_game_binding]

- konstrukcja reduuktora, gra lazyGame, symulacja z podwójnym wyzwaniem
  (cap 16), punkt none; LocalJointCertificate S e,
- drugi moment zamiast odcinka pierwszego (Cramér -> wieża A2, ~2^-46);
  warunkowość prawa klucza (S3: e jest stałą chi-kwadrat samplera Sign).

## 6. Analiza samplera: e wyliczone [ZAMKNIĘTE — SignLayerSupport, AttemptWeights, T5Pointwise, AttemptPointwise]

- rozkład attemptFactor = machineMargin * towerMargin * wrapFactor *
  boxFactor (dokładna tożsamość) < 1 + 2^-38, wszystkie marże policzone;
- dwa kształty próby rozstrzygnięte liczbowo (niewarunkowany e2 < 2^-32;
  warunkowany na akceptację: delta dokł. 1/(1-rejB), e2 < 2^-17);
- WYNIKI NEGATYWNE JAKO TWIERDZENIA: bulkOnly_tail_uncontrolled /
  _normalized (kanapka na całym ogonie niezbywalna — kontrprzykłady
  kernelowe z świadkami), massSandwich_not_pointwise (suma całkowita nie
  daje kontroli punktowej), additiveError_no_machineStage (błąd addytywny
  bez podłogi masy), route_a_closed (trasa statystyczna martwa:
  delta >= 1 - 2^448/2^n).

## 7. Wiązanie z realną implementacją [W LOCIE — B1.02 zamknięte, B1.03 4/6, reszta w torze]

- metoda: parser C99 -> drzewo -> wykonanie; liczniki i pozycje
  Z WYKONANIA (first/triple/middle loops, wywołania motyli jako WNIOSKI —
  bez call-premise leakage, zero orakulum NTT); rząd generatora
  9216/4608 kernel-sprawdzony;
- **znaleziska dowodowe (sekcja-hook paperu!)**:
  * F-001: falcon_prng_get_bytes kopiuje od początku bufora — wada
    odziedziczona z upstreamowego Falcona (7 kopii, martwy przewód dziś,
    żywy dla przyszłych profili) — documents/FT1536_C_CODE_FINDINGS;
  * martwa warstwa REV10 parsera (pureExpr zjadał + REV10) — prawa
    wierszy dowodziłyby nieistniejącego modelu;
  * duplikowany xor w divSelect, fałszywy call na ((size_t)1<<k)-1;
  * zmierzona granica kernela (~8 linii parsowania na decide) jako
    inżynieria dowodu.
- motywacja: formalizacja NIE JAKO pieczątka, tylko jako proces, który
  znajduje bledy w kodzie i w modelu.

## 8. Deklaracja poziomubezpieczeństwa (uczciwa podwójna liczba) [ZAMKNIĘTE dane, certyfikat S06 OTWARTY]

- tabela: kratka cl/q (core-SVP 0.292/0.265 * beta) + kapsel symetryczny
  (SHAKE/ChaCha20: ~256 cl / ~128 q — Grover) => system = minimum;
- FT1536: ~314 cl / ~285 q na kratce; system = min(256/128, ...) z jawnym
  Adv_PRG; porównanie z Falcon-512/1024 (te same kapsle u wszystkich —
  my liczymy je jawnie);
- zasada: "nie sprzedajemy liczby z kratki jako poziomu systemu".

## 9. Szew obliczeniowy: metodologia [ZAMKNIĘTE — CompPrg, AssemblyComp, REVIEW_002 PASS_SCOPED]

- CompPRGBound z dopuszczoną klasą testów (bez maszyn Turinga),
  CompWinCert (członkostwo + linia kosztu q = chachaBlocksTotal),
- wspólna taśma całego przebiegu (windowOf/windowsOf/flattenWindows +
  simulateStream_uniform), testy probabilistyczne obejmujące resztę
  losowości eksperymentu,
- lekcje: komentarz nie jest kwantyfikatorem (case study: nasz własny
  szew statystyka-vs-obliczeniowość), test k=1/D=0 jako audyt znaczenia.

## 10. Powiązane praca [OTWARTE — przegląd literatury przed złożeniem]

- redukcje dla NTRU/BLISS/GPV/porównywalne dowody dla Falcona
  (Pornin; prace nad dowodem dla idealizowanego schematu Falcon),
- CompCert/seL4 (wiązanie dowód-kod jako tradycja), FaCT/CompCertSSA,
- lattice-estimator (Albrecht i in.) i konwencje bezpieczeństwa
  (SECURITY_CONVENTION.md Core-SVP classical/quantum),
- QROM-osobno: cytować stan z dokumentu 2026-09-17 (brak boundu QROM).

## 11. Granice i praca otwarta (księga uczciwości w treści) [ZAMKNIĘTE jako zapisy]

- most bajtowy A3/A4 (ryzyko chi^2 = top przy masie poza obrazem emit) —
  poza zakresem, nagrane; podłoga masy — warunkowo domknięta (machineFloor);
- A2 granica siewu; A1 granica modelu; conditioned-shape a e2 < 2^-17;
- QROM nie jest roszczony; rodzina 768/3072 = ALTERNATIVE_PROPOSAL do
  certyfikacji.

## Aneks A: łańcuch zaufania [ZAMKNIĘTE — cała infrastruktura]

- piny SHA-256, receipty jobów, checkpointy, audyty aksjomatów,
- proces recenzji: 3 niezależne recenzje + AUTHOR_RECHECK + replay 70/70
  + kontrprzykłady kernelowe jako standard weryfikacji,
- wszystko publiczne w repo (odtwarzalność od bajtu do tezy).

## Aneks B: pochodzenie projektu [OTWARTE — materiał z marcowego dysku]

- ORIGIN_TIMELINE.md: pierwsze pliki (połowa marca 2026), repo (29.04),
  kampania dowodowa; nagranie z drugiego dysku po stronie właściciela.

## Co można pisać TERAZ (zanim domknie się B1)

Sekcje 2–6, 8–9 i Aneks A w zasadzie 1:1 z gotowych modułów i notatek
(B4_SYNTHESIS, END_TO_END_SCOPE, B5_WORK_STATE, B2_ADVPRG_WORK_STATE,
B2B5_COMPUTATIONAL_WORK_STATE, REVIEW_001/002, F-001). Sekcja 7 rośnie
z checkpointów B1 (już teraz można pisać metodę i znaleziska). Do
ostatniego momentu czekają: finalne scalenie sekcji 4 (strzałki 1–2)
i certyfikat S06 w sekcji 8. Język: angielski (rejestr crypto);
decyzje tonalne i misja — właściciela.
