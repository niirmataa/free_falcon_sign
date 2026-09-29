# Source/model binding pozostałego L_V

Dokładne zakresy linii, hashe wycinków i modele: artifacts/source_bindings.json.
C jest niezmienionym kandydatem: vrfy3fe78f8d…, enc0f7085fa…, internal512629d3….
Norma B jest makrem internal.h:163, nie historycznym progiem sigma776.

## Raw, centrowanie i Q

rawBefore przyjmuje prepared H; prepareKey h = toMontC(forwardC h).
raw_before_eq jest projekcją ukończonego L_NTT_rho i odpowiada vrfy:1406–1424.
Żadnej dodatkowej normalizacji s ani zmiany source pipeline nie dodano.

vrfy:1432–1434 jest odwzorowane przez centerBorrow/centerCorrection/
centerBeforeStore/centerC. Odejmowanie9216−d jest uint32 wrap; shift31 to
dzielenie canonical unsigned przez2^31; unsigned negacja i ANDq pozostają
operacjami słów. CENTER_C dowodzi, że int32 casts i różnica są dokładne,
a wynik przed int16 store leży w[-9216,9216]. centerBits zapisuje rzeczywiste
niskie16 bitów do widoku unsigned. centerLoop odczytuje je przez s16.
center_unread dowodzi, że następny nieprzetworzony odczyt nadal jest canonical.

W GCC/LP64 int16_t=short, uint16_t=unsigned short; mają równy rozmiar i
wyrównanie. Dostęp przez odpowiadający signed/unsigned typ jest dopuszczony
przez C99 6.5p7. Native harness ma compile-time assertions tych własności.
Prefix/frame oraz rozłączne indeksy0..1535 dotyczą tej samej tablicy3072 komórek.

enc:612–623 zapisano jako4608 kolejnych produktów:3072 naprzemiennych squares,
następnie1536 naprzemiennych cross terms, offset768. normAcc zachowuje
int32 product PRZED int64 addition. Proved bounds gwarantują tożsamość casts,
bez podpisanego overflow: każdy produkt w±2^30, każdy prefiks w
±4947802324992, znacznie wewnątrz int64. Nie konsumuje się binary saturation.
norm_sum wiąże kolejność pętli z dokładnym Q0+Q0; STRICT_B używa signed `<`.
SIGN_BRIDGE neguje CAŁY pierwszy wektor; Q0_neg obejmuje obydwa czynniki cross term.

## Dekodery i kodowanie słów

Bytes=List(Fin256) to widok dokładnie len bajtów legalnego obiektu.
Cursor(pos,db,bits) odpowiada v/db/db_len; db jest canonical unsigned32.
pull ma dokładny wrap shift8/add. byte_concat dowodzi równoważności
publicznego shift8/OR z tą samą operacją. logical_shift/low_mask/sign_mask/
byte_mask wiążą dzielenia i reszty z bitowymi instrukcjami C.

NONE (enc401–456): noneRaw jest big-endian shift8/OR, noneExtended wykonuje
`w |= -(w &0x8000)`, nonePost dodajeq z wrapem. noneFlag jest dokładnym
AND dwóch unsigned różnic i shift31. msb_and/none_flag_range dowodzą
9216<w<27650 po teście; zapisany long−q mieści się w[-9216,9216], więc cast16
jest dokładny. NONE zwraca3072; outer signature wymaga równości długości.
byteAt ma totalny fallback wyłącznie w modelu: none_read_bounds i kontrola
len>=3072 wykluczają go dla wszystkich rzeczywistych odczytów.

STATIC (enc462–544): fill2/need9 jest dokładnym, co najwyżej dwubajtowym
uzupełnieniem while(db_len<=8), dzięki invariant bits<=7 na wejściu.
ParserRefinement.static_fill_exact dowodzi równoważności z FillRun, a nie
arbitralnego limitu prób. sign i lo są odczytane z tych samych pozycji db.
UnaryRun/nextBit zachowują rzeczywiste uzupełnienie jednego bajtu i kolejność
test/decrement. Ghost remaining=8*(len−v)+db_len maleje o1 na bit. unary_source,
unary_unique i unary_terminates dowodzą zakończenia i zgodności fuel modelu
z rzeczywistą pętlą dla każdego skończonego wejścia. Fuel nie jest limitem2049
ani capem ne. zeroCount/unary_skip_zeros/unary_wrap wiążą k zer z k mod2^32.

Test ne>255 jest DOPIERO po terminatorze; readStatic nie stosuje wcześniejszego
capu. Po nim lo<256 i ne<=255 dają magnitude<=65535, więc shift8/suma są legalne.
staticValue zachowuje oba signed narrowings oraz promocję przy minusie.
Konwencja GCC to modulo2^16 z odczytem signed; negacja następuje w int32 i jest
bezpieczna także dla−32768. Nie deklaruje się przenośnej semantyki wszystkich C99.
Negative zero jest dopuszczone; magnitude32768 daje−32768 dla obu znaków.
Padding test obejmuje tylko pozostałe niskie db_len bitów. Return to v.

staticLoop/noneLoop budują listę w kolejności stores. Długość udanego wyniku
jest dokładnie1536. writeDecoded zapisuje ją sekwencyjnie i signature_initializes
dowodzi identycznego wyniku dla DOWOLNEJ starej zawartości bufora; nie przyjmuje
inicjalizacji lub prawidłowego wektora jako przesłanki akceptacji.
Read bounds, shifts i liczniki wynikają z cursor specs, output_store_bounds
i LegalBytes(length<2^64). Ghost bit measure może przekroczyć size_t i nie
jest dodanym licznikiem C. Nie materializowano setek MiB dla wrapu unary.

## Guards, lifecycle i loader

signature wykonuje len<=2, reserved bit, logn, ternary, dispatch obu kompresji,
decode i porównanie całej pozostałej długości. decoder_return_guard uzasadnia
Option failure→return0: po header guard payload ma dodatnią długość. Reserved
compression2/3 daje błąd. Nagłówki FT dopuszczone po tych testach to8A/AA.
Trailing signature bytes są odrzucane. verifyContext None modeluje logn=0/-2;
pozostałe błędy bajtowe dają−1, raw daje0/1.

PK decoder(enc216–250) grupuje te same jedno-/dwubajtowe iteracje przez
fill2/need15; pk_fill_exact rozlicza grupowanie. Shift counts są0..7 po
odjęciu15, acc_len chwilowo<=22. Test w<18433 zapewnia canonical h i dokładny
uint16 store; maska pozostałych bitów jest zachowana. PK_CONSUMED dowodzi
fizycznego przeczytania2880 bajtów, bits=0 i db=0. DECODE_PK zwraca jednak
pełne len, zgodnie z C. Końcowe nieczytane bajty PK mogą być dowolne.

loadFT obejmuje non-NULL branch, len>1, reserved bits i wybór FT logn10/ter1,
decode-return comparison, potem rzeczywiste NTT/tomonty. NULL jest wcześniejszą
odrzucającą gałęzią C; akceptacja wymusza non-NULL. loadFT jest WYBOREM profilu
FT do tego lematu, nie twierdzeniem, że C odrzuca inne poprawne profile.
Nieudany loader resetuje logn do0, co odpowiada pustemu kontekstowi.
PK_PREPARATION wyprowadza canonical polynomial i przygotowane H z sukcesu.

## Natywne kontrole i granica zaufania

checks/harness.c uruchamia rzeczywisty loader, dekodery, Verify/raw i is_short.
Wspólny hook explicit_point zastępuje tylko H2P jawnym canonical c, tak jak
w domenie zadania. Wariant plain nie ma obserwatora normy/centrowania.
Wariant observer dodaje wyłącznie obs_capture przed return; usunięcie linii
oznaczonej LV_OBSERVER odtwarza source enc byte-for-byte. Diffy i hashe są
w checks/variants oraz artifacts/native_binding.json. Mutanty są osobnymi kopiami.

Kernel dowodzi modeli i nowych refinement lemmas; jawna translacja C i
ABI jest przypiętym zakresem platformy, nie aksjomatem oczekiwanego wniosku
lub twierdzeniem o zweryfikowanym kompilatorze. Pełne końcowe typy nie mają
nierozliczonego parametru poprawności parsera, normy, centrowania lub bindingu.
