# M0 — źródła, caller i historyczny CLI

Pełne piny i spans: artifacts/source_binding.json, PROFILE.json, INPUTS.sha256.
17 źródeł kandydata jest niezmienionych i read-only. Verifier3fe78f8d…
dziedziczy pełne L_V; pozostałe pliki, w tym Sign/KeyGen/FPEMU, są przypięte
do wskazanego zestawu. Robocze Extra/c nie było bazą tej pracy.

## Parametry kompilacji

Makefile:35: -W -Wall -O, FPR_IMPL=fpr-emulated.h, SAMPLER_CODF=0,
SAMPLER_CDF=0, CT_BEREXP=1, FT_TERNARY_ADAPTIVE_CDF=1,
FT1536_CANDIDATE_PROFILE=1, CLEANSE=1, TRUE_TERNARY_SECRET=1,
TRUE_TERNARY_SECRET_MODE=1, KEYGEN_BOUND_SCALE1250/100,
TERNARY_KEYGEN_MAX_ATTEMPTS3000000, SIGN_MAX_ATTEMPTS16.
Nowe native controls używają tych flag, a sanitizer dodaje swoją instrumentację.
Backend to FPEMU, nie ogólne przybliżenie „binary64”. Sigma768 to signing sigma,
nie keygen scale12.5 ani ostatnia proposal variance. B jest strict2093922385.

## KeyGen i Sign

KeyGen new/sizes5147–5245, rng_ready5270–5287, make7782–8187:
jeden kontekst FT, output buffers z API12289/2881, seed32, source cap3M,
cała sekwencja gates i obie końcowe serializacje. Warunkowanie obejmuje całe
wywołanie. sample_true_ternary_secret4754–4781 ma uncapped2-bit rejection;
nie zastępuje się rzeczywistego rozszerzenia seedu iid tape.

Sign3075–3146 inicjuje świeży root SHAKE i przy pierwszym start pobiera32 bytes.
Brak external seed oznacza, że gałąź reseed-when-flipped nie wykonuje dodatkowej
ekstrakcji32. Private loader3150–3277 używa tych samych wyemitowanych bajtów sk,
walidacji i przygotowania; jego failure pozostaje PRE_ABORT.
start3281–3288 pobiera40 bytes i hash-sc zaczyna odr40, update dodaje m.
generate3308–3422: guard, do16 prób, PRNG init, fault reset, do_sign, fault,
norm/retry; po normie jedno kodowanie4095, header, return bytes+1.
Casty s1/s2 przed normą:1917–1934. Wyższe fidelity samplera i pre-cast nie
wynikają z M0 capacity proof. Wszystkie actual source aborts pozostają w GAME.

## PRNG56 i dokładny parent budget

frng282–324 mapuje type0 na PRNG_CHACHA20 i pobiera56 bytes. Layout:
key32 (offset0..31), IV16 (32..47), counter8 (48..55). Source state[14]/[15]
XOR counter odpowiada offsetom40..47, czyli ostatnim8 bytes IV. Komentarz
o „first8 bytes IV” nie zastępuje instrukcji. Nie jest to standardowy448-bitowy
klucz ChaCha ani automatycznie dowiedziony hop do dowolnej standardowej gry.
Refill i get_u8/get_u64 (w tym odrzucane suffixy) są częścią exact PRNG game.

Jeden świeży Sign pobiera co najwyżej40+16*56=936 bytes z fs.rng. H2P ma
ODDZIELNY fs.sc. Wewnętrzne PRNG draws i H2P rejection nie mają z tego tytułu
capu. Capacity512 w shake_init oznacza SHAKE-256. Wszystkie primitive bridges
mają własne ledger rows i budżety.

## Caller kontra tool.c

4096/r40 jest wybraną normą protokołu/argumentami wywołań. Nie dopisano jej
do kodu. Historyczny tool.c262 ma sig[2049];351–360 generuje r40 albo przyjmuje
external nonce o dowolnym rlen;393–394 przekazuje sizeof sig. Biblioteka Verify
również ma argument rlen. Nowy kontrakt ma zatem gate dokładnie40 w wrapperze
lub jednoznaczny parser transportu. C nonce_gate jest tylko prototypem do testów.

## Pojemność i granice dowodu

CAPACITY.md wyprowadza length z enc289–379 oraz nagłówek z sign3411–3421.
EncoderCount modeluje actual byte counters/checks, nie zamienia Verify lub
całego Sign w idealną definicję. Native harness dołącza oryginalny encoder,
bez obserwatora i bez wywołania KeyGen/Sign. Jawne mutanty są w checks/variants/;
nie zmieniają source/. Query out=NULL, cap−1, padding, canaries i round-trip
sprawdzają nowe bindingi. Nie ponowiono kampanii NTT/L_V/samplera.

M0 zachowuje GCC/C99/LP64 oraz signed narrowing convention z L_V. Signed
overflow nie jest nazywany poprawnym wrapem. H3 pozostaje osobnym obowiązkiem
przed floor/conversion/s+z; dokładny interfejs jest w H3_INTERFACE.md.
