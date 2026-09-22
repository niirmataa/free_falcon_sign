# S06 — niezależna ocena częściowej kampanii FT768/FT1536/FT3072

2026-09-22. Recenzent **GPT-6 Astra (openai/gpt-6-astra)**,na bezpośrednie
polecenie właściciela. Autor kampanii MiMo. Autor projektu Niirmata;
atrybucja Falcon Project / Thomas Pornin i lattice-estimator zachowana.

**Werdykt: CHANGES_REQUIRED dla częściowego checkpointu diagnostycznego.**
Run jest rzeczywisty i zawiera wartościowe odtwarzalne liczby. Wykryłem
jednak błąd wymiaru w analizie podpól,błąd jednostki i mieszanie modeli w
przyszłym agregatorze oraz niespójne statusy/opisy. Oryginalnej kampanii nie
wznawiałem ani nie zmieniałem. Nie udaję pełnego odbioru120 komórek.

## 1. Który stan oceniono

SOURCE_W: `proofs/ft1536/work/FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001`.
Właściciel potwierdził ten katalog jako właściwy. Autor nie oddał jeszcze
końcowego report.md/OUTPUTS.sha256; STATUS=DIAGNOSTIC_NOT_CANDIDATE_READY,
RESUME_STATE opisuje pauzę. Recenzent zebrał własny read-only snapshot122
plików (6.70MB),SHA manifestu:
`6a03a50a06167045b72a9aebfa3afa5269102a4e251f3d4e9f1de82d02349df4`.
To pin odczytanego częściowego stanu,nie domniemany finalny freeze autora.

NTRU grid:71 rekordów =1 metadata +70 komórek (FT76824,FT153624,FT307222).
Pozostaje50 planowanych komórek do120,nie licząc koniecznych napraw starych
rekordów. Wszystkie70 są oznaczone OK,ale5 ma pusty attacks,a13 ma wyłącznie
serializowane koszty nieskończone. Tych kategorii nie wolno liczyć jako70
skończonych oszacowań kosztu ataku. Błędy backendu mogą być przechwycone wewnątrz
NTRU.estimate zanim wrapper wpisze OK.

Zweryfikowałem17 źródeł i14 literalnych bindings parametrów;63 pliki vendora
zgodne z jego manifestem.25 modułów estimator/ porównałem bajtowo z lokalnymi
obiektami Git upstream commit `3e48ef421ec256afddb3e7d2249a77eab6e9ba12`.
Falcon parameters.py jest identycznym członkiem przypiętego falcon-round3.zip.
Bez sieci/instalacji; oryginalne source pins sprawdzone ponownie na końcu.

## 2. Co rzeczywiście przeliczyłem

Pięć własnych checkerów `.sage`,wykonanych jako **sage plik.sage** w Sage10.9,
z preflightem preparsera. Wszystkie joby bwrap/network-off,inputs RO,jedyny
zapis we własnym W,HOME/TMP/cache lokalne,single-worker8GiB. Raw receipts
wiążą readonly snapshot kodu przed/po z argv,exit,stdout/stderr i wynikami.

- `model_audit.sage`:12 wierszy eq.(2.3)/(2.4),minimalne całkowite β i d4f,
  progi B oraz koszty0.292β/0.265β; niezależne interval384 inequalities
  i exact QQ zamiast Decimal autora. Potwierdzone wszystkie12 wierszy.
- `field_audit.sage`:12 zestawów delta_Falcon/delta_estimator/CN12;
  zgodne z formułami i ich zapisaną precyzją40 cyfr po przecinku w notacji E.
- `model_audit.sage`:21 exact norm-down moments z Newton sums wielomianu,
  niezależnie od autorskiego Mobius/Ramanujan; zgodne. Osobno ujawniony zły n
  w użytej pętli ataku i kontrolne wartości po zmianie samego n.
- `backend_audit.sage`:144 wiersze cost surface (132 z wartościami +12
  odtworzonych KeyError ListDecoding),beta±2;3 rzeczywiste wywołania
  NTRU.estimate/usvp,ADPS16 classical,default GSA. To próba po jednym
  konkretnym ataku na profil,nie odtworzenie całej siatki70/120.
- `aggregation_audit.sage`:wykonawczy kontrprzykład jednostek/mieszania
  modeli na oryginalnym aggregate.py i syntetycznych danych. Oryginalny
  agregator nie był jeszcze uruchomiony w kampanii.
- `norm_mean_audit.sage`:exact mean/RMS/centered second moment norm względnych;
  pole sigma jest RMS-derived,nie ogólnie odchyleniem standardowym centrowanym.

## 3. Potwierdzone progi geometryczne — ściśle w podanym modelu

| Profil | β P1a,eq.(2.3),RAW ternary | β P2 relation proxy,stała szerokość | β P2 relation proxy,σ∝sqrt(N) |
|---|---:|---:|---:|
| FT768 | 462 | 455 | 499 |
| FT1536 | 1077 | 1082 (pinned B) | ten sam baseline |
| FT3072 | 2409 | 2445 | 2284 |

Kotwice Falcon1024:936/952 potwierdzone; Falcon512:458/411 w zadanej
konwencji radius floor. Warianty FT768/3072 pozostają ALTERNATIVE_PROPOSAL.
Są to liczby określonych modeli/inequalities,nie udowodnione poziomy
bezpieczeństwa implementacji. Emitted population,circulant→Phi3N,pełna
redukcja oraz byte Enc/Verify obligations pozostają otwarte.

Osobna próba **vendor NTRU usvp / ADPS16 classical / GSA** odtworzyła:
- FT768:β479,d1426,log2(rop)≈139.868;
- FT1536:β1103,d2749,log2(rop)≈322.076;
- FT3072:backend zwraca oo bez β — zgodne z zapisanym rekordem.
Te progi należą do innego modelu algorytmu niż pętla eq.(2.3); nie zamieniam
ich nazw lub jednostek. oo nie jest dowodem nieskończonego kosztu/hardness.

## 4. E1 — błędny wymiar analizy podpól (high)

`scripts/subfield_normdown.sage:18–20,115–130` deklaruje stopień podpola N/2
i wymiar kraty N,ale wywołuje `solve_key_recovery(N,...)`. Ta funkcja używa
argumentu jako stopnia pierścienia i przeszukuje β do2*n. Faktyczny model
ma więc ponownie wymiar2N,zamiast zadeklarowanego N.

Konkretnie FT768,u127:artefakt podaje subfield_dimension768 i β1311,
co przekracza cały zadeklarowany wymiar. Po poprawieniu WYŁĄCZNIE argumentu
n na384 w tym samym heuristic loop wynik wynosi637. Dla u2303:1519→758.
Dla FT1536 część poprawionych n-only wyników wynosi1518/1519; stare dane
zawierają3041 lub None. NEGATIVE_RESULTS.md:16–18 niesłusznie mówi też,że
wszystkie FT1536 wartości są None.

To diagnostyczny kontrtest błędu implementacji modelu,nie nowy atak ani
naprawiony kompletny model podpola. Same n-only wartości nadal są większe
niż full-model462/1077 w tych przykładach. Trzeba jednak ponownie wyprowadzić
parametry podpola/metrykę i wynik. Exact drugie momenty NIE dowodzą kosztu
ataku lub uniwersalnego „braku przewagi ABD”. Lift i modeling są otwarte.

Dodatkowo dla automorfizmu sprzężenia u=3N−1:
E[Norm(f)]=(2N/3)·1 jest niezerowe. `sqrt(2*E[Q(Norm(f))]/N)` jest RMS proxy,
nie centered std. Mój exact checker rozdziela obie wielkości. Użycie RMS
jako przybliżonej długości celu trzeba nazwać i uzasadnić; nie można z samych
momentów wnioskować o całej rozkładowej/geometrii ataku.

## 5. E2 — błąd jednostek i mieszanie modeli w agregatorze (high przed użyciem)

`scripts/aggregate.py:42–55,90–95`:wybiera minimum surowego rop,a do CSV
wpisuje `point=log2_rop,value=rop` bez logarytmu. Własny kontrolny run:
rop8 trafia do kolumny log2_rop jako8,choć poprawna wartość wynosi3.
To konkretny software counterexample; nie manipulowałem danymi autora.

Klucz minima `(scheme,attack)` pomija cost_model. Mój test także wykazał
wspólne minimum klasycznego i kwantowego modelu. SECURITY_CONVENTION§1–2
wymaga wspólnej linijki kosztowej i rozdzielenia cl/q. Jeśli ma to być
wyłącznie sensitivity envelope,trzeba tak je oznaczyć i zachować zakres;
nie używać jako głównej liczby profilu. Przed future aggregation poprawić
jednostki,klucze grupowania oraz statusy/duplikaty repair.

## 6. E3 — statusy i niespójny przepis MATZOV (medium)

`nn='ListDecoding'` jest niewłaściwym kluczem tego vendora; działa
`nn='classical'`→`list_decoding-classical`. Odtworzyłem12 błędów cost surface
i poprawne działanie wspieranego klucza na kontrolnej wartości.

Wrapper ntru_models wpisuje OK nawet dla attacks={}. Pięć takich komórek
pozostaje w snapshotcie; inne mogą zawierać wyłącznie oo. Aktualny skrypt
ntru_models już zmienił spelling/etykietę,a stare rekordy i a2_isis_embedding/
parameters_family nadal opisują stary wariant. Repair jest zaplanowany,nie
zakończony. Statusy EMPTY/ERROR/NO_FINITE_RESULT muszą zostać jawne.

Resume/dedup:liczyć kanoniczny klucz i wersję,potem jawnie zastępować dany
failed/repair record,bez liczenia ich jako nowych niezależnych komórek.
Nie mieszać finite overflow po float() z rzeczywistym oo; zachować tekst
kosztu lub log2/status. Samo70 wpisów OK nie oznacza70 udanych estimations.

## 7. E4 — konwencja podsumowania (medium)

SECURITY_CONVENTION.md:55–60 podaje P1 β1077,314.484 cl/285.405 q i P2
β1082,315.944 cl/286.730 q,a jako najsłabsze ogniwo wskazuje P2.
Na TEJ SAMEJ zadeklarowanej linijce minimum jest **P1**. Ten tekst powinien
być generowany z wyników,a nie wpisywany ręcznie.

Linia45:„koszt per-cel×liczba celów” nie wynika z union bound. Dla wygranej
na dowolnym celu można ignorować pozostałe; wzrost Q nie wymusza mnożenia
minimalnego kosztu przez Q. Union bound dotyczy prawdopodobieństw sukcesu
przy określonym algorytmie/zasobach. Pełny multi-target cost model pozostaje
osobnym obowiązkiem; wycofać bezwarunkową regułę kosztową.

P1a to short-pair recovery,z osobnym solve(F,G); P2 eq.(2.4) to heuristic
coset-vector target. Nazwa „produkcja akceptowanych bajtów” wymaga Enc i
właściwego Verify bridge. Dane diagnostyczne nie zamykają tych interfejsów.

## 8. Tryb historyczny i moje failed attempts

TOOLCHAIN kampanii jawnie podaje env-Python bez preparsera. Header „sage
script.sage (plain Python)” w kilku skryptach jest mylący. Moje nowe
rachunki rzeczywiście wykonano natywnie w Sage; historycznych komend nie
przepisałem na inny tryb. Kontynuacja wymaga respektowania obecnej zasady.

Moje retained failures:
- backend-001:założyłem istnienie β dla każdego wyniku; FT3072 usvp zwrócił
  oo bez β,co spowodowało KeyError. backend-002 jawnie obsługuje i porównuje
  ten wynik,bez wymyślania kosztu. Stara wersja/traceback zachowane.
- fields-001:porównanie RNDU endpoint z RIF powodowało błąd typów; użyto
  dokładnego rational endpointu.
- fields-002:stała absolutna tolerancja1e-38 była zbyt mała dla4-cyfrowych
  wartości zapisywanych `.40E`. fields-003 używa jednego rzeczywistego kroku
  zapisu wynikającego z exponent/liczby cyfr,przechowuje błędy i threshold.
  Wszystkie12 pól przeszło tę kontrolę. Nie zmieniano expected data.

## Wniosek i następny krok

Potwierdzam wartościowy rdzeń:12 model rows,21 exact moments,vendor/piny,
132 cost surface values +12 jawnych błędów oraz3 celowe NTRU samples.
Przed domknięciem raportu naprawić E1–E4,rozliczyć pozostałe/repair komórki
i spiąć source→execution→output w author freeze. Oryginalne wyniki negatywne
i historyczne błędy zachować. Zakres nadal DIAGNOSTIC_NOT_CANDIDATE_READY;
nie ma certyfikowanego poziomu bezpieczeństwa FT768/FT1536/FT3072.

Własne joby zakończone. source_changed=false,owner_accepted=false,
push_authorized=false. S01 ma osobne CHANGES_REQUIRED; żaden z tych dwóch
wyników nie otwiera publikacji. Gotowe handoffy T03/T02.1 czekają od właściciela.
