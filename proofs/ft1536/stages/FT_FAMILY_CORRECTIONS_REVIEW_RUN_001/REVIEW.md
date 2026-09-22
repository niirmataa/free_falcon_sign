# S01 — niezależny odbiór korekt Family RUN_003

REVIEW_ID=FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001,ROADMAP_ID=S01.
2026-09-22. Recenzent: **GPT-6 Astra (openai/gpt-6-astra)**,na wyraźne
polecenie właściciela,zmieniające wcześniejszy podział ról prowadzącego.
Autor badanego pakietu: MiMo2.6Pro. Autor projektu Niirmata; atrybucja
Falcon Project / Thomas Pornin zachowana.

## Werdykt

**CHANGES_REQUIRED**. Kierunki argumentu i zasadniczy rachunek zostały
znacznie poprawione. Potwierdzam ujemny wynik R5,naprawę domyślnego runnera
R4,rdzeń algebraiczny/layout oraz rzeczywiste odtworzenie wyników. Do
domknięcia korekty potrzebne są dwie konkretne poprawki spójności:

1. **R1: oddzielić udowodnioną ekstrakcję punktową od warunkowej nierówności
   przewag między grami.** Zapis „proved” przy Adv_rel≥Adv_cond wymaga
   doprecyzowania interfejsu oracle/symulacji. N3 nie jest kontrolą świeżego
   fałszerstwa w M0 ani wykonaniem tej redukcji.
2. **R5: poprawić reklamowaną dokładność certyfikatu.** Kod 256-bitowy nie
   wyprowadza przedziału o promieniu≈10^-305 opisanego w CLAIMS i PDF.
   Nierówności 2^-40<ogon<2^-28 są poprawne i niezależnie potwierdzone.

`publication_correction_gate_satisfied=false`, `push_authorized=false`,
`owner_accepted=false`. Nie stwierdzam błędu kodu podpisu lub ataku.
Minimalne zmiany opisuje REQUIRED_CORRECTIONS.md; nie wymagają dowiedzenia
całego M7 ani uruchomienia kampanii estymatora.

## 1. Integralność i izolacja

Zewnętrzne piny autora:
- REPORT: `7d2f17cc51126b6dbb03279d7c876c460aa9f48bb581f63b9f512f87adee485d`.
- OUTPUTS: `9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e`.

Sprawdzono100/100 outputs,197/197 bootstrap members,source17,TASK/POLICY
i complete read-only bundle323. INPUTS ma29 rekordów i3 komentarze; parser
kontrolny jawnie pomija komentarze,oryginału nie zmieniono. Zachowano pięć
receiptów autora i wcześniejsze failed routes. Wszystkie końcowe input pins
sprawdzono ponownie. Brak zapisów do W autora lub Extra/c.

Każdy mój wykonywany krok działał w bwrap: root RO,jedyny trwały zapis we
własnym W,inputs RO,network-off,stare W autora/estymatora ukryte. Fresh HOME,
TMPDIR/DOT_SAGE/XDG/cache,limit8GiB,jeden worker,Lean4.34-j1/-M2048.
Nie uruchamiałem estymatora,KeyGen,pełnego Sign,dudect ani innych modeli.

## 2. Mój świeży replay — wynik i rzeczywista granica

DEST: `replay/independent-001`,czas kontrolera **354.775s** (około5m55s).
Zastosowałem własny jawny kontroler transportu/wykonania,bez zmiany żadnego
skryptu matematycznego autora. Czyta16 komend z przypiętego entrypointu,
waliduje source przed DEST,usuwa skopiowane byte targets ORAZ semantic-only
wyniki/PDF/cache,zachowuje raw stdout/stderr i hashe kodu przed/po runie.
Źródło: review_tools/replay_controller.py; scope adaptera: REPLAY_ASSESSMENT.json.

- **18/18 byte-deterministic matches,0 mismatch.**
- **16/16 kroków exit0**,także obydwa ciężkie semantic steps.
- Sage exact SA1–SA6 rzeczywiście odtworzony,bajtowo identyczny JSON.
- FFT12 przypadków odtworzone. Jedyna różnica JSON to pole `source_header`:
  canonical Extra/c versus świeży DEST/Extra/c; treść nagłówka ma ten sam pin.
  Po jawnym porównaniu pozostałych pól wszystkie dane wynikowe są identyczne.
- PDF:cztery komendy build exit0,9 stron według pdfinfo,tekst identyczny
  z PDF autora. Każdą fazę wykonano po usunięciu starych produktów.
- 4 moduły Lean świeżo zbudowane,14 nazwanych twierdzeń w AxiomAudit;
  tylko propext/Quot.sound,czyste logi,bez forbidden escapes.

**Ujawniony failure mojego kontrolera:** jego końcowy exit=1 i zapis
REPLAY_FAIL są zachowane. Dodatkowo wymagał on surowej identyczności FFT JSON,
także pola ścieżki źródła. Ta jedna różnica transportowa wywołała failure;
nie było failure kroku obliczeniowego lub różnicy liczb. Nie przepisałem
receiptu na PASS. REPLAY_ASSESSMENT.json dokumentuje dokładny diff i odrębną
pozytywną ocenę kryterium18/18 oraz zgodności semantycznej. Nie powtarzano
całego runu tylko w celu uzyskania ładniejszej etykiety.

## 3. Niezależny rachunek — natywne SageMath

Własne checkery są właściwymi `.sage`,uruchomionymi launcherem SageMath10.9
z preparserem,bez trybu Python. Każdy run ma readonly snapshot źródła,
hash przed/po,argv/exit,raw streams i output hashes.

- `sage_checks/independent_math.sage`,finalny run `check_runs/math-002`,exit0:
  dokładna rekurencja QQ sumy Poissona i niezależny MPFI1024 exp interval;
  Newton sums z wielomianu (nie kopia autorskiego Ramanujan),prime/root checks,
  A2 Gram/eigenvalues,layout closed forms,negative controls R1/R2.
- `sage_checks/rounding_enclosure.sage`,`check_runs/rounding-001`,exit0:
  reverse recurrence sumy oraz exact kontrola błędu konwersji midpoint/radius.
- `review_tools/independent_r4.py`,`check_runs/r4-001`,exit0:13 kontroli
  organizacji/guardów z własnym mock backendem i2 negative freshness probes.
  Python służy tu kontroli programu/procesów; nie liczy kosztów estymatora.

Zachowany mój failed attempt `math-001`: wszystkie asercje rachunkowe doszły
do końca,ale serializer JSON nie obsłużył literalnego Sage Integer0 w liście.
Poprawiono wyłącznie konwersję `0→int(0)` i wykonano nowy run math-002.
Stara wersja,częściowy JSON i traceback pozostają; nie liczę jej jako PASS.

## 4. R1 — kierunek poprawiony,typ przewagi wymaga doprecyzowania

**Potwierdzone:** L_V daje accepted bytes→witness. Na danym wygrywającym
transkrypcie można wyekstrahować relacyjny witness. Odwrotne użycie solvera
do produkcji akceptowanych bajtów wymaga osobnego Enc. M0/M7 pozostaje otwarte.

**Problem średniego priorytetu:** ATTACK_PROBLEMS.md:32–49 definiuje Forge
z H/Sign,a Solve_rel przez h oraz wartości tabeli ROM,bez jawnego Sign oracle
lub symulatora. Linie73–89 oznaczają jako „proved” konstrukcję
`B=Extract∘Forge` i `Adv_rel(B)>=Adv_cond(G0[E],A)` oraz wniosek o trudności.
Linie97–102 odkładają symulację i ostatecznie mówią o warunkowości na
component certificates. Te dwa poziomy mają być oznaczone jednoznacznie.

Publiczne E z M0/GAME.md:9–19 to harmonogram usług,nie dostęp do sekretu
lub darmowy symulator Sign. Sam extractor nie implementuje oracle potrzebnego
do uruchomienia A. To brak doprecyzowanego typu/warunku w deklarowanym
wyniku,nie żądanie zamknięcia całego M7 w S01.

**N3 nie zamyka tego problemu:** lemma_controls.sage:138–159 wywołuje
sign_oracle na m*,a następnie oddaje podpis na tym samym m*. W M0 wiadomość
trafia do SeenSign,więc nie jest świeżym fałszerstwem. Niezależna kontrola
odtworzyła akceptowany witness(1,6),Q=43,ale EUF-CMA_win=false. Osobny
toy_solve_rel zwraca(0,2,2),podczas gdy extraction z indeksem daje(1,1,6).
Test sprawdza dwa postconditions,nie równość algorytmów/redukcję źródłowej gry.
Weryfikator naive_enc odrzuca brak ręcznej flagi roundtrip; to test tego
konkretnego toy encodingu,nie dowód nieistnienia Enc dla rzeczywistego kodeka.

**Naprawa:** oznaczyć proved wyłącznie punktową ekstrakcję; nierówność
game-level podać jako conditional-on-compatible-simulation z jawnym typem,
albo usunąć ją z proved claims. Poprawić opis N3 i C20 („Enc nieudowodniony”,
nie ogólne „nieistniejący”). To wystarczy do zakresowej korekty R1.

## 5. R2/R3/R4 — zakres potwierdzony

R2:naprawiono wybór wartości celu→wybór nazwy ROM,spójność powtórzeń i brak
darmowej niezależności. Moja enumeracja q7 daje1 versus1/7 dla zerowego
świadka; dla pełnego R_q byłoby q^-N. Powtórzony event ma unię1/2,a nie3/4.
Uwaga low do ATTACK_PROBLEMS:120–126:identyczne eventy mają identyczne
marginały; napisać „nie zakładamy IID”,nie „nie są identycznie rozłożone”.
Przy conditional p_i podać wspólne conditioning albo właściwe oczekiwanie;
bezwarunkowy union bound po jawnych eventach jest wystarczający.

R3:source falcon-vrfy.c:1551–1588 bierze f,g,F i oblicza NTT(gF)/NTT(f),
potem iNTT/centering G. Nie uzyskuje F z samej pary. Rozdzielenie P1a/P1b
i raw/emitted threshold jest poprawne; NTRU solve/length/cost nadal jawnie OPEN.

R4:wycofanie jest rzeczywiste w zadanym zakresie. Autorskie T1–T8 przeszły;
moje13 przypadków obejmują brak/niepoprawny commit,modeling points,cell,
mapping SHA,homogeneous SIS,alias SIS/SISParameters,wrong kind,brak allow
i poprawną ścieżkę WYŁĄCZNIE do mojego mocka. Stany blokowane nie importowały
backendu. Walidator sprawdza strukturę/deklaracje,nie prawdziwość matematycznych
premises lub zgodność załadowanego backendu z SHA; to interfejs NOT_RUN,
nie gotowy certyfikowany estymator. Kampania S06 jest odrębną pracą.

## 6. R5 — rdzeń liczbowy potwierdzony,claim dokładności do poprawy

Dla zadanego modelu χ²₃₀₇₂ i dokładnego
`x=2093922385/1179648` moje QQ+MPFI1024 daje
`2.9925420736032481972831458610874671101141569259…e-9`.
Dokładne endpointy zapisano w check_runs/math-002/outputs/independent_math.json.
Potwierdziłem **2^-40<ogon<2^-28** i containment w obu zapisanych autorskich
decimal endpoints. Stare kryterium akceptacji≥1−2^-40 jest obalone w modelu
idealnym. Nowy próg2^-28 pozostaje PROPOSED; nie jest security level.

**Problem średniego priorytetu:** paper/main.tex:188–192 i CLAIMS.md:48
deklarują promień≈10^-305 z autorskiego rachunku RIGOROUS_INTERVAL. Sealed
lemma_chi_tail.sage:99,130–137 używa Arb256 i daje promień około
**1.0595040179069145e-82**,a zapisane50-decimal endpoints mają szerokość
dokładnie **10^-50**. To nie certyfikat reklamowanej precyzji. Moja oddzielna
1024-bitowa kontrola osiąga węższy bound,lecz nie zmienia historycznej metody
ani bajtów certyfikatu autora.

Dodatkowo `QQ(mid)` i `QQ(rad)` w tej instalacji NIE są dokładnymi konwersjami
wartości binarnej,jak mówi opis. Sprawdziłem jednak exact sufficient condition
`abs(QQ(mid)-mid_exact)+rad_exact <= 2*QQ(rad)`; jest spełniony z zapasem
około0.999563 pierwotnego promienia. Zatem dla TEGO x outwardness i główne
nierówności pozostają prawidłowe. Prosty przejrzysty zapis to exact_rational()
albo dołączenie tej kontroli do uzasadnienia. Nie zgłaszam obalenia ogona.

Naprawić też RESEARCH_NOTES_PL.md:55:ogon Pr[Q≥B] to odrzucenie; akceptacja
Q<B ma prawdopodobieństwo1−ogon. Dalsza część tego dokumentu używa właściwego
kierunku. Poprawki mają objąć źródło,CLAIMS/RESULT i nowy spójny PDF.

## 7. R6/R7 i formalizacja

R6:status PROPOSED spójny w głównych deklaracjach,twiddle multiplier jawnie
placeholder,12 przypadków portu to finite diagnostics bez FPEMU theorem.
Moja świeża reprodukcja daje te same dane12 przypadków. Zachowano brak
c/domain/epsilon_tw i wycofanie binary64-sufficiency claims.

R7:poprawna tabela high-water4096/8192/16384,generator i jego --check,
niezależny consumer zamkniętych rekurencji oraz source shapes
falcon-keygen.c:7594–7681. Potwierdzone tree8448/18432/39936 i expanded
11520/24576/52224. Newton sums niezależnie dają trace support0/±N/2 i A2
Gram det3/4,eigenvalues1/2,3/2. Finite prime/root/cyclotomic checks poprawne.
Kernel14 nazwanych lemmas + closed examples jest lokalnym rdzeniem;
source layout/trace/embedding arguments są dodatkowe,nie pełna weryfikacja C.

## 8. Proweniencja i dalsze uwagi

- Stary hash lemma_controls w COMMANDS/port receipt różni się od finalnego
  źródła; moja świeża egzekucja wiąże finalne5a3466b9… z właściwymi wynikami.
  Oznaczyć historyczny receipt/erratę; nie przepisywać dawnego freeze.
- OUTPUTS zawiera niepotrzebny .pyc mimo deklaracji fresh cache. Zachowano
  pin jako evidence,usunięto cache wyłącznie w moim MIRROR przed wykonaniem.
  Do kolejnego pakietu usunąć z deklarowanego source bundle i zapieczętować
  nowy manifest. Oryginalnych bajtów nie poprawiałem.
- Literalny author replay PASS ignoruje semantic/PDF failure; moje wykonanie
  rozlicza je osobno. Dwa kontrolowane no-op/failure producers po usunięciu
  skopiowanego celu zostały prawidłowo odrzucone przez freshness check.
- S01 tekst „nigdzie nie policzono FT768/3072” w RESEARCH_NOTES:89–92 jest
  historyczny; właściciel potwierdził osobną kampanię S06. Zakres „nie w tym
  pakiecie/manuskrypcie” jest właściwy. Nie importowano nieodebranych kosztów.

## Ocena dla właściciela

Ta poprawka ma rzeczywistą wartość: rygorystyczny ujemny wynik modelu,
działający guard R4,odtwarzalne rachunki i spójny proposed status FFT. Nie
odrzucam tego rdzenia. Do publikacyjnego domknięcia S01 potrzebny jest
precyzyjny zapis R1 i zgodność claimu dokładności R5 z faktycznym certyfikatem.
Publikacja pozostaje wstrzymana. Dalsze pełne security/Sign/PRNG/H2P/recovery/
FT768/3072 obligations pozostają poza zakresem tego review.

Własne obliczenia S01 zakończone. S06 pozostaje następnym zleceniem; właściciel
zapowiedział przekazanie recenzji T03 i handoffu T02.1 po domknięciu tego odbioru.
