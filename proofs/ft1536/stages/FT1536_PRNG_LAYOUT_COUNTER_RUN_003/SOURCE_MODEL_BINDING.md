# SOURCE_MODEL_BINDING — uniwersalny argument źródłowy T02.1 (RUN_002, kernel)

Kontynuacja `../FT1536_PRNG_LAYOUT_COUNTER_RUN_001` (frozen, OUTPUTS
`34c49d61…`; tamten W nietknięty). Ten przebieg dobudowuje KERNEL Lean 4:
licznik/layout/zasoby/q-refill w `formal/CounterLayout.lean` (Lean 4.34,
core-only, 28 twierdzeń, czyste logi, aksjomaty [propext, Quot.sound]).
Rundy ChaCha Word32 pozostają w modelu Sage exact + wiązaniu C (jawna
nie-kernelizowana granica). Decyzja właściciela: forma kernelowa.

Autor projektu: Niirmata. Falcon Project / Thomas Pornin attribution i licencje
zachowane. Pinned model: GCC 14.2 / C99 driver (`c99 -W -Wall -O`), x86_64 LP64
little-endian (`FALCON_LE_U=1`), źródła `source/frng.c`
(`4b1289ad…9c5dfc644`) i `source/internal.h` (`512629d3…19131f1ba5`).
Autorytatywny rachunek: `model/prng_model.sage` + `model/prng_checker.sage`,
uruchamiane `sage <file>.sage` (SageMath 10.9, preparser; exact integers/ZZ;
Sage-semantyka: `^` to potęga, XOR to `^^` — patrz FAILED_ROUTES.md).

## Granica kernelowa (RUN_002)

W kernelu Lean (`formal/CounterLayout.lean`, 28 named theorems):
sekwencje licznika (`blockCounter`, brak powtórzeń dla N ≤ 2^64, kompozycja
refilli, post counter), flaga wrapu i jej równoważność z `cc_last < cc_start`
(w tym instancje F4/F5), dispatch typów (`typeOut`), offsets layoutu56
i arytmetykę granic ramki (sama niepisalność `state[56..255]` wynika ze
struktury zapisów C + kontroli poisonu — patrz A.4, nie z lematu kernela),
consumer zasobów (`r_max`, `25408`, `406528`, `896`, `936`) oraz `qrefill`. Czyste stdout/stderr, aksjomaty [propext, Quot.sound] (split
równoważności wrapu na dwie implikacje, by nie ciągnąć Classical.choice).

Poza kernelem (celowo): 20 rund ChaCha jako operacje Word32 — ich poprawność
wobec źródła dowodzą exact model Sage (literalny schedule) + byte-identical
wiązanie z oryginalnym C na 21 stages + KAT 5/5 + mutacje. Kernel nie
dowodzi ani nie zastępuje rund; dowodzi arytmetykę licznika/layoutu/zasobów,
którą Sage i C instancjonują na konkretnych modułach.

## Rola fixtures

7 publicznych syntetycznych init56 × 3 stages (21 stage-kontroli) to KONTROLE
WIĄŻĄCE (byte equality całego buf4096 + state256 + ptr/type/counter + canaries
+ liczniki stubu), nie kwantyfikator uniwersalny. Kwantyfikator dają poniższe
argumenty strukturalne ze źródła; fixtures pokrywają klasy behawioralne:
zero/asymetryczne IV lanes; counter 0, 2^32−1 (zmiana high word w refillu),
2^64−1 (wrap w 1. refillu), 2^64−64 (koniec dokładnie na wrapie), 2^64−65
(wrap w 2. refillu); typy 0, 1, 2, 3, −1, 99, 2^20; determinizm; type0==type1.

## A — init i layout (frng.c:281–324, internal.h:767–778)

1. Dispatch jest wyczerpujący nad `int type`: `type==0 → PRNG_CHACHA20 (1)`
   (frng.c:284–286); `case PRNG_CHACHA20` akceptuje też jawne 1 (kontrola
   type_equivalence: identyczne state/buf); `default: return 0` (frng.c:318–319)
   PRZED jakimkolwiek zapisem i PRZED 56-byte extract — struktura switcha, nie
   sample. Kontrole wiążące: typy {2,3,−1,99,1048576} → 0, zero extract calls,
   cały `prng` w poisonie, canaries całe.
2. Gałąź FALCON_LE_U=1 (ten build): `shake_extract(src, p->state.d, 56)`
   (frng.c:290), potem `p->type = type`, initial `falcon_prng_refill(p)`,
   `return type` (frng.c:321–323; ptr=0 ustawia refill, frng.c:338).
   Kolejność: extract → type → initial refill → ptr=0 → return.
3. Mapa 56 bajtów (LE): offsets 0..31 → state words 0..7 (key);
   32..47 → words 8..11 (IV); 48..55 → Word64 cc0 (counter). Gałąź =0 dekoduje
   te same wartości słów jawnym LE-składem (frng.c:296–316) i odbudowuje ten
   sam Word64 (`tl + (th<<32)`); na hoście LE obie gałęzie dają te same bajty
   (kontrola altbranch: różni się wyłącznie bajt tagu `falcon_le_u`).
   Przenośność BE jest analityczna (LE-host-only dla gałęzi 1 z projektu) —
   uruchomienie gałęzi 0 na hoście LE nie jest testem hardware BE (TASK §3).
4. Ramka: init pisze state.d[0..55]; refill pisze buf.d[0..4095],
   state.d[48..55], ptr=0; state.d[56..255] nigdy niepisane (kontrola poisonu
   w harnessie na każdym stage; model trzyma POISON=0xA5).
5. Alignment: unie buf/state mają `uint64_t dummy` (8-byte alignment,
   internal.h:767–778); casty u32/u64 w frng.c trafiają w offsets 4i/48/52 —
   wyrównane. Kontrole statyczne harnessu (`sizeof==4368`, offsets 0/4096/
   4104/4360, align 8) odrzucają build przy innym ABI; checker piny powtarza.

## B — exact block/refill i counter (frng.c:200–278)

1. Jeden blok: state[0..3]=CW (`61707865,3320646e,79622d32,6b206574`,
   frng.c:206–209,220); state[4..15]=12 stream words (frng.c:221);
   `state[14] ^= (u32)cc; state[15] ^= (u32)(cc>>32)` (frng.c:222–223) —
   offsets 40..47, OSTATNIE 8 bajtów pola IV 32..47. Komentarz frng.c:198
   („pierwsze 8 bajtów IV") jest niezgodny z instrukcjami — finding bez zmiany
   C (dół).
2. 10 double rounds w literalnym QROUND schedule (frng.c:224–252; adds mod 2^32,
   XOR, rotacje `(x<<s)|(x>>(32−s))` 16/12/8/7). Feed-forward: lanes 0..3 += CW;
   4..13 += saved[0..9]; 14 += saved[10]^cc_lo; 15 += saved[11]^cc_hi
   (frng.c:254–263). Serializacja LE (frng.c:266–275; memcpy na LE = LE bytes).
   Wszystkie operacje to funkcje całkowite (total) o jawnych domenach Word32.
3. Refill: `for (u = 0; u < 4096; u += 64)` — DOKŁADNIE 64 iteracje (struktura
   pętli, sizeof buf 4096 z ABI); blok k używa licznika cc0+k (lokalne `cc`,
   start z native u64 read state.d[48..55], frng.c:214); `cc++` na iterację;
   JEDEN zapis `state.d[48..55] = cc0+64 mod 2^64` na końcu (frng.c:277).
   Stąd uniwersalnie: 64 kolejne bloki, post counter +64 mod 2^64, pierwsze 48
   bajtów state nietknięte (pętla pisze tylko buf + końcowy u64), ptr=0.
4. Wrap vs repeat: dla fixed context licznik przyjmuje cc0..cc0+N−1 mod 2^64;
   przy N ≤ 2^64 brak powtórzeń także przez wrap (różnice 1..N−1); pełny stan
   powtarza się dopiero po cyklu 2^64 bloków. Wrap to przejście przez 2^64,
   nie repetycja (każdy wrapped fixture ma 192 różne counters). Cross-context:
   F0 i F2 dzielą cc0=0 z różnymi buforami — deterministyczny przykład
   ident-init56→ident-buf to ograniczenie przyszłej gry, nie atak/Emitted.
5. Rdzeń Word32 cross-checkowany KAT: 5 wektorów OpenSSL (niezależny oracle)
   + literały RFC 8439 §2.3.2 i classic all-zero — waliduje WSPÓLNĄ arytmetykę
   rund, nie layout Falcona (jawny zakres w modelu).

## C — consumer zasobów (bez re-dowodu T01)

Z odebranego eventu H (T_j ≤ 49152, r_j ≤ ⌊(33T_j−8)/4087⌋, J ≤ 16):
r_max = ⌊(33·49152−8)/4087⌋ = ⌊1622008/4087⌋ = 396 (exact ZZ);
64·(1+r) ≤ 25408 na reached context (r ≤ 396); 64·6352 = 406528 na region
(6352 = 16 + 16·396); 56·16 = 896 parent-SHAKE bytes (+40 nonce = 936 poza
cutem). Monotoniczność sprawdzona dla r = 0..396. Spójność z ghost budget T01
(786432/25952256/6336/16/6352/26017792/57024/15/61320/4088/896) exact ZZ.
Pr(H^c) < 2^−1020 pozostaje daną T01 (G_retry_IID); nie przenoszona na real PRNG.
Corollary q-refill: refills = ⌊q/4096⌋, ptr = q mod 4096 (exhaustive 0..20000 +
7 punktów, w tym 25408) — wniosek z ODEBRANYCH reguł getterów
(IID/BYTE_SCHEDULE, internal.h:856–866), nie nowy schedule; drops u64 kryje T01.

## Założenia jawne

SHAKE-stub zwraca DOWOLNE konkretne 56 bajtów (brak rozkładu/IID/448-bit key);
aligned `prng`; legalny extract-length 56 (stub liczy wywołania/długość);
pinned ABI/kompilator/host; brak OS entropy/sekretów/KeyGen/pełnego Sign.
Real→IID hop, SHAKE/ChaCha security i dystrybucje: OPEN (T02).
