# Decyzje M0

## Jawnie wybrane przez właściciela

1. Payload uczciwego Sign ma pojemność4096 bajtów **łącznie z nagłówkiem**.
   falcon_sign_generate otrzymuje4096, encoder otrzymuje4095 i wskaźnik+1.
2. Nonce to osobne40 bajtów. Transport poprawnego podpisu to r[40]||b,
   z faktyczną długością b; brak paddingu do4096.
3. Główny cel jest parametryczny w Q_s,Q_H,t,w,L. Nie wybrano liczbowego
   profilu zasobów ani poziomu128/256 bitów bezpieczeństwa.

Te decyzje nie są cofane przez owner_accepted=false: ta flaga dotyczy odbioru
pakietu wykonawcy, a nie powyższych uzgodnień.

## Dokładne konwencje kontraktu

- Jeden klucz z K_seed[E], ten sam we wszystkich zapytaniach. E jest jawnie
  zdefiniowanym publicznym środowiskiem API, nie nowym losowaniem klucza.
- Świeży kontekst Sign na zapytanie, ten sam wyemitowany sk; brak dostępu A
  do external seed/nonce. Sign ma16 outer attempts; scalar rejection nie ma capu.
- Klasyczny ordinary EUF-CMA w direct-output ROM. Abort query także zużywa
  zapytanie i wpisuje wiadomość do zbioru nieswieżych wiadomości.
- Obserwacje: PRE_ABORT, (r,POST_ABORT), (r,b). Wewnętrzny powód i częściowy
  bufor nie są ujawniane. Główna gra nie udostępnia zegara ani liczników prób.
- Przeciwnik ma pełny język Verify NONE/STATIC i payloady ograniczone jego
  budżetem L oraz legalnością API, nie capacity uczciwego oracle.
- Parametry otoczenia E i budżetów analitycznych są jawne w typie przyszłego
  twierdzenia; nie są ukrytymi pomiarami systemowego RNG lub czasów samplera.

## Rozdzielenie wersji

Rdzeń: niezmieniony kandydat L_RHO z ukończonym L_V. Caller/protokół M0:
nowe normative4096/r40. Historyczny tool.c nadal ma sig[2049] i zmienny rlen.
Prototyp nonce_gate w checks/ demonstruje framing, nie wdraża całego wrappera.
source_integrated=false; protocol_wrapper_integrated=false.

## Pojemność i zachowane luki

Nowy dowód: payload po norm acceptance<=3160, więc4096 wystarcza.
Świadek3156 pokazuje, że2049 i3073 nie są uniwersalnymi granicami STATIC dla
short vectors. Nie twierdzi się, że świadek pochodzi z Sign ani że3160 jest optimum.
Stary H6P nie jest przeniesiony zmianą liczby; joint pre-cast, relacja,
serializacja i stopping mają własne obowiązki. M0 nie uruchamia H3.
