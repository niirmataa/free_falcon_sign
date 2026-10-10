# S05 — następny duży pakiet018: koszt i instancja dla źródłowych kluczy

Status: PLANNED, zależny od rzeczywistego zakończenia LOCAL_LEAVES017.
Nie jest nowym twierdzeniem QROM ani zleceniem dla aktywnego wykonawcy ROM.
Całość rozwija S05/TARGET_CONTRACT; mainline/paper/T12.1/B20 bez zmian.

1. **Q-RESC, obowiązek:** wybrać jawny model wykonania i kosztu publicznego
   samplera. Oddzielić generację/przechowanie publicznych tablic od kosztu
   jednego wywołania. Liczyć odczyty losowych bitów, operacje na słowach
   o udowodnionych szerokościach, wyszukiwania CDF, arytmetykę Q i syndromu,
   pamięć roboczą oraz koszt wyjścia. Same logiczne miejsca prób016 nie
   spełniają tego zadania.
2. **Q-SAMPLER/Q-RESC, obowiązek:** jeśli optymalizujemy referencję,
   najpierw dokładna równoważność prawa. Kandydat: wyszukiwanie binarne
   pierwszego CDF większego od reszty, z dowodem zgodności z liniowym
   wyborem i obsługą każdej gałęzi. Jawne przechowanie wygenerowanych
   współczynników ma zapobiec ponownemu obliczaniu całego samplera przez
   funkcyjny dostęp do współczynnika. Dotychczasowy kod pozostaje przypięty.
3. **Model i obowiązek, oddzielnie:** ustalona taśma uczciwych bitów jest
   modelem. Powiązanie strumieniowego wykonania z tą taśmą i niezależność
   świeżego fallbacku są obowiązkami. PRG nie staje się idealnym źródłem
   przez pominięcie jego hopu. Nie zmieniamy capów80/196 ani prawa porażek
   bez nowego dowodu momentu.
4. **Dokładne szerokości:** CDF ma268 bitów; moneta akceptacji256 bitów,
   lecz środkowy próg ma wartość2^256 i potrzebuje257 bitów albo jawnej,
   równoważnej reprezentacji „akceptuj każde słowo”. Nie wolno obciąć go
   do256 bitów. `TableWidths017` rejestruje odpowiednie fakty kernelowe;
   nie jest modelem kosztu całej maszyny.
5. **Q-KEY/Q-BIND, obowiązek:** śledzić poprawki źródłowe bez przejmowania
   drugiego wykonawcy. Przed konsumpcją pinu18a3ffe3 potrzebne są naprawy
   obu niemożliwych przesłanek: globalnego VirtualLegal i globalnego
   Dimensions. Następnie właściwe lokalne świadki, chronologia, codec/frame,
   to samo h oraz pełne prawo emisji z dodatnią masą. Sam konstruktor
   warunkowy nie wypełnia tych pozycji.
6. **Q-SAMPLER/Q-KEY, obowiązek:** dowieść pokrycia rzeczywistego prawa
   kluczy przez dokładny warunek(M). Ponownie użyć014 i dostępnej linii
   ROM/T5/H3; nie powtarzać geometrii. Zachować rozdzielenie wyniku dla
   nośnika KeyGen od silniejszego celu forall-h.
7. **Odbiór pakietu:** czyste logi, piny źródeł/generatorów/artefaktów,
   pełny receipt kosztu w dokładnie wybranym modelu, nieudane próby
   append-only, małe lokalne commity bez push, polski checkpoint z mapą
   murów. Żadnego statusu REVIEWED bez niezależnego odbioru.

Po018 nadal osobno: Q-HASH-LOG, Q-EMBED, Q-COLL/reprogramowanie,
Q-COMPOSE, A-QMT, Q-PRG i zasoby całej redukcji. D=(1+e)^q_s−1 wolno użyć
kwantowo tylko z pełnymi przesłankami odpowiedniego lematu. Nonce pozostaje
320-bitowy. Żadnych poziomów bezpieczeństwa ani przedwczesnej deklaracji.
