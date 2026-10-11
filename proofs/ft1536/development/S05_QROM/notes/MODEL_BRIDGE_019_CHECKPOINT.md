# S05 / MODEL_BRIDGE019 — checkpoint granicy modeli

**PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED.** Zakres019 domknięty jako
podetap granicy kodu/praw; koszt maszyny018 i pełna gra nadal OPEN.
Commity źródeł: `35d8ebaf35bb1375cbdb98775674168e8b57165c` oraz
`67da1757dffad34c4b2d76d696e885eec7019f93`, lokalnie na main, bez push.
Baza: S05/018 `2b5afcf2`, wariant A ROM `35420d59`.

## Co rzeczywiście wykazano

1. Oddzielne interfejsy **PairCode** (publiczna wspólna para) i
   **ReplyCode** (odpowiedź dla challenge z ROM). Adapter nowego
   Run2.Sampler daje dokładne replyLaw/freshLaw i wspólny idealny cel P.
   Nie podstawia publicznego generatora pary pod sampler odpowiedzi.
2. **StandaloneRuntime019**:194 linie wykonywalnego rdzenia wydzielone
   z przypiętych deklaracji016/018. Te same tablice, taśmy, capy80/196,
   zero pary, świeży cube, zapamiętane wektory i scatter. Generator
   odtworzył identyczne bajty.21 równości kernelowych daje zgodność
   wyniku dla KAŻDEJ taśmy, a nie tylko zgodność skończonych testów.
3. **Rzeczywista instancja certyfikatu:** StandaloneCertificate019 daje
   J≪P dla każdego h, a pod dokładnym(M) moment≤1+2^-47, także dla tego
   samego pokrytego prawa kluczy. Wszystkie modelowane porażki nadal są
   w P. Nie zmieniono(M) ani nie założono jednostajności marginalnej J.
4. **Obserwacja:** ta sama skończona klasyczna funkcja na obu prawach
   zachowuje AC i nie zwiększa momentu. To nie jest lemat operatorowy
   ani kwantowa kompozycja z D.
5. **Nowy mianownik opłacamy jawnie:** jeżeli P≤kappa·R na nośniku J,
   kappa>0, to certyfikat przenosi się na R z e'=kappa(1+e)-1≥0.
   Zachowano ten sam rachunek pod obserwacją i tym samym prawem kluczy.
   Brak instancji źródłowego kappa; dolna granica to obowiązek, nie
   dodatkowe założenie kryptograficzne i nie domyślne kappa=1.
6. **Przeszkoda dokładnego adaptera:** finite fair-bit generator pary
   nad Rq nigdy nie ma dokładnie prawa nowego noise-only samplera z
   jednostajnym challenge zewnętrznym. Mechanizm dzielności z audytu
   F04 ponownie użyto w niezależnym module;18433^1536 nie dzieli2^b.
   To nie obala porównania momentem i nie kasuje wcześniejszego wyniku.

**84 różne eksporty w15 modułach;27 czystych buildów modułów/audytów.**
Audyty drukują74 eksporty legacy oraz51 variant A, z częścią wspólną.
Standardowe aksjomaty, bez sorryAx/native_decide i bez wyciszania ostrzeżeń.
33 moduły wspólnego rdzenia mają identyczne źródła w obu środowiskach;
nie importują Games/LawBinding/HacGlue/JointDecomp. Biblioteki starych
oraz nowych definicji Run2.Sampler są rozdzielone.

## Granica kernelowa, której nie ukrywamy

Dowód konkretnego momentu w StandaloneCertificate019 korzysta z zamrożonego
środowiska dowodu018. Identyczny rdzeń wykonywalny i wspólne definicje praw
są skompilowane również w środowisku wariantu A. Adapter nowego API i
konsumenci są tam kernelowi, ale **nowy konsument nadal przyjmuje certyfikat
bazowy i dolną granicę jako jawne wejścia**. Nie ogłoszono jednego scalonego
dowodu całej gry, nie podmieniono niezgodnych importów i nie dodano aksjomatu
zastępującego brakujący import. Źródłowe Sign/KeyGen/PRG, wykonalny sampler
odpowiedzi dla zadanego c oraz QROM nie wynikają z tego podetapu.

Formalnie wspólny target P nadal jest pełnym idealnym Gaussian/fiber/cap16
z signed16 emission, nie udowodnionym prawem źródłowego Sign. Źródłowe
powiązanie wymaga własnego dowodu porównania/prawa i kosztu. Rozdzielenie
publicznego generatora i rzeczywistego Sign jest potrzebne dla tej analizy.

## Kontrole i próby

Kontrola korelacji: te same dwa marginesy i ta sama masa porażki1/2, a AC
nie zachodzi, bo iloczyn marginesów nadaje1/4 atomowi poza nośnikiem celu.
Surowa suma drugiego momentu, przy real-div-zero, wynosi1/4, podczas gdy
chi2=∞. To kernelowy przykład konieczności oddzielnego warunku AC.
Druga kontrola pokazuje, że odwrócone R≤kappa·P nie daje żądanego boundu.

Sage10.9 ze standardowym preparserem: kontrola korelacji/abortów/nośnika,
kierunku mianownika,744 przypadki skończonej siatki obserwacji,7 kontrolnych
potęg modulo18433 i rachunek przykładowego e'. Przykładowe kappa nie jest
świadkiem źródłowym. Wynik [EXACT_RESULT](MODEL_BRIDGE_019_EXACT_RESULT.json).

Próby Sage exact001/002 zakończyły się timeoutem (60/120s) bez wyniku;
002 nie doszła do pierwszego znacznika źródła. exact003 z diagnostyką
pokazała oczekiwanie podczas importów sage/plot/plot3d, po czym przeszła
całość, exit0. Jej stderr zawiera jawny diagnostyczny zrzut stosu.
Zwykła exact004, bez diagnostyki, przeszła z pustym stderr i identycznymi
bajtami wyniku. Nie zmieniono rachunku ani środowiska Sage. Zachowano
wszystkie receipty, źródła i logi; czasu tych procesów nie nazywamy kosztem
samplera. Nieudane próby Lean dotyczą jawnych problemów elaboracji,
importu taktyki primality, kwalifikacji nazw oraz zbyt szerokiego rozwijania
reprezentacji; wszystkie mają osobne snapshoty i receipty.

**LaTeX:** [źródło dla czytelnika bez repo](MODEL_BRIDGE_019.tex) zachowane,
edytor zgłoszony do otwarcia. Natywny podgląd nie został potwierdzony:
próba1 przekroczyła czas z błędami zapisywalności cache Fontconfig;
po jawnym wskazaniu plików fontów próby2/3 zatrzymały się na
`LaTeX sandbox initialize timed out`. Nie instalowano pakietów ani nie
zmieniano systemu. To ograniczenie podglądu, nie błąd dowodów Lean.

## Mapa murów i następny duży TODO

| Obowiązek | Stan | Pozostała implikacja |
|---|---|---|
| Publiczny sampler i moment | Kernelowy niezależny rdzeń, zgodność z018 i certyfikat pod(M) | Źródłowe pokrycie(M) dla rzeczywistego prawa kluczy |
| Granica wariantu A | Kernelowe wspólne definicje i oba adaptery | Scalone powiązanie gier, źródłowe Sign/ReplyShape/PRG i właściwy hop prawa |
| Zmiana odniesienia | Kernelowy konstruktor z jawnym kappa | Rzeczywisty bound P≤kappa R na nośniku J; nie utożsamiać go ze świadkiem |
| Koszt018 | Nadal OPEN, właściwy odbiorca już ustalony | Maszyna, pełny program, pamięć/adresowanie i erasure do publicCode019 |
| QROM | Nadal OPEN | Q-HASH-LOG/Q-EMBED/Q-COLL/reprogramowanie/Q-COMPOSE, A-QMT i zasoby |

Następny konkretny pakiet: [TODO_PAIR_MACHINE_020](TODO_PAIR_MACHINE_020.md),
który kontynuuje otwarty Q-RESC018. Koszt dotyczy generatora CAŁEJ PARY;
nie wolno użyć reply-only boundu26113bitów. Wspólna para ma inny encoder
(logiczny stary bound50689 wymaga powiązania), a taśma nadal ma
24662538240 bitów. Przed streamerem potrzebny jest dowód prawa/świeżości;
przed deklaracją pamięci — rzeczywista semantyka jej użycia.

TrasaA (rozdzielenie i wspólny target) dostarczyła powyższy wynik. TrasaB
(dokładna równość praw przez adapter) jest wykluczona w podanym zakresie.
TrasaC (warunkowanie na c) pozostaje odroczona: nie ma algorytmu ani kosztu;
zastąpienie wspólnego prawa iloczynem marginesów odpada na kontrprzykładzie.
Nie nazwano tej trasy wyczerpaną ani niemożliwą w całości.

Piny: [INPUTS](MODEL_BRIDGE_019_INPUTS.json),
[CHECKS](MODEL_BRIDGE_019_CHECKS.json),
[COMMON_CLOSURE](MODEL_BRIDGE_019_COMMON_CLOSURE.json),
[klasy](CERTIFICATE_CLASSES_019.json), [kolejka](KERNEL_QUEUE_019.json).
Autor prowadził własne sprawdzenia; brak niezależnego odbioru i statusu REVIEWED.
