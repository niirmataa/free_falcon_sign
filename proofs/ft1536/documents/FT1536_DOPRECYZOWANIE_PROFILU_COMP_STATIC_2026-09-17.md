# FT1536 — ustalony profil COMP_STATIC

## Doprecyzowanie bieżącego zadania dowodowego

Dołącz ten plik do zadania:

```text
/home/footfalcon/Dokumenty/FT1536_PROMPT_CEL_DOWODU_BEZPIECZENSTWA_2026-09-17.md
```

Właściciel potwierdził, że FT1536 było budowane na **COMP_STATIC**.
Jest to ustalony profil konstrukcji i docelowego twierdzenia, a nie otwarta
decyzja, którą model ma rozstrzygać na podstawie starego REV5.

Formułuj główne twierdzenie dla **FT1536 full ternary secret z podpisywaniem
w FALCON_COMP_STATIC**, z dokładnymi algorytmami, prawem KeyGen, reprezentacją
podpisu i modelem bezpieczeństwa. Zachowaj cel wykraczający poza jeden h*.

## 1. Hierarchia wejść

1. Ustalony przez właściciela profil: FT1536 full ternary secret, COMP_STATIC.
2. Zamrożone źródła S17 i dokładne zachowanie ich funkcji.
3. Twierdzenia, certyfikaty i rzeczywiste zależności matematyczne.
4. REV5 i pozostałe manuskrypty jako materiały do uzgodnienia z powyższym.

Stary zapis paperu nie może sam zmienić profilu na COMP_NONE, narzucić starej
instancji ani ukryć rozbieżności z kodem. Nie wolno natomiast przypisać kodowi
żądanej własności, której on nie realizuje: taka różnica ma być jawnym
obowiązkiem zgodności specyfikacji i implementacji.

Korzeń źródeł tylko do odczytu:

```text
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
S17 = H/build
```

Manifest historycznych 17 źródeł ma SHA-256:

```text
03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
```

Jest dostępny w obiektach Git H, w commicie
`d641ab1037c2fa1dd4a22c258854d79d67b9b46b`, pod:

```text
evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256
```

Kandydat warning-clean z lokalnego `free_falcon_sign/Extra/c` nie jest
zamiennikiem tych źródeł w tym zadaniu.

## 2. Fakty źródłowe do uwzględnienia

- `S17/falcon.h` definiuje `FALCON_COMP_STATIC` jako kodowanie za pomocą
  stałych kodów, w przybliżeniu Huffmana. Długość zakodowanego podpisu zależy
  od danych. „Static” nie oznacza stałej długości ani constant-time.
- `S17/tool.c:393–394` wywołuje `falcon_sign_generate` z
  `FALCON_COMP_STATIC`; `tool.c:718` używa tego samego trybu w KeyGen.
- Nonce, nagłówek i zakodowany wektor trzeba opisać oddzielnie, zgodnie
  z rzeczywistym API i wybranym opakowaniem podpisu.
- Domena `uncompress_static` ma wynikać z programu. Nie przypisuj jej
  automatycznie centered-domain `[-9216,9216]` dekodera COMP_NONE.

Ważna granica: ogólna funkcja S17 `falcon_vrfy_verify` odczytuje z nagłówka
rodzaj kompresji, a `falcon_decode_small` obsługuje zarówno NONE, jak i STATIC.
Jest to właściwość bibliotecznego API, a nie cofnięcie wyboru COMP_STATIC
przez właściciela.

W twierdzeniu trzeba jawnie rozliczyć relację wybranego profilu do faktycznej
domeny akceptacji Verify. Nie zakładaj, że obecna funkcja automatycznie odrzuca
inny tryb. Nie ograniczaj adwersarza do STATIC, jeżeli modelowany verifier
akceptuje szerszy język. Potrzebna jest udowodniona relacja między tymi
językami albo osobno określony obowiązek zgodności implementacji z profilem.
Nie zmieniaj samodzielnie kodu ani profilu w celu usunięcia tej kwestii.

## 3. Wymagania dla celu dowodu

- Podaj dokładny typ podpisu COMP_STATIC i regułę Verify.
- Oddziel idealny wektor matematyczny od bajtów rzeczywistego podpisu.
- Rozlicz konwersje, zakresy, norm rejection, retry, fault i abort.
- Dla każdego wykorzystywanego wyniku ustal, czy jest niezależny od kodowania,
  czy wymaga konkretnego języka bajtowego lub domeny dekodera.
- Przeniesienie lematu sformułowanego dla COMP_NONE do COMP_STATIC wymaga
  sprawdzenia jego przesłanek i jawnego mostu, a nie zmiany nazwy w tekście.
- T2C3 i T5 zachowują swoje obronione zakresy. Ich automatyczne utożsamienie
  z prawem produkcyjnego podpisu COMP_STATIC nie jest dozwolonym krokiem.

Uwzględnij to w wyniku głównego zadania o celu dowodu i pierwszym brakującym
lemacie. Nie wracaj do pytania, który profil właściciel chce rozwijać:
**celem jest COMP_STATIC**. Nie podejmuj teraz redakcji całego REV5 ani
publikacji. Obowiązują dotychczasowe odczytowe granice i ten sam plik raportu
wskazany w głównym prompcie.
