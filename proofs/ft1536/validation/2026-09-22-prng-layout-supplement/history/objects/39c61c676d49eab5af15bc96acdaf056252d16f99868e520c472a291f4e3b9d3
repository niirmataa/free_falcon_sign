# PRNG_REAL_TO_IID_BUFFER — osobny otwarty obowiązek

**real_prng_to_iid_bridge_proved=false.** IID_BUFFER jest jawną idealizacją.
Exact scalar law w tej grze nie czyni realnego ChaCha/SHAKE uniform/IID,
nie zapewnia realnego a.s. termination ani nie daje security loss o wartości0.

## 1. Rzeczywisty state/output access game do porównania

Zachowaj M0 plan usług E, fresh Sign root seed32 na sukcesie entropy usługi,
rzeczywistą root SHAKE-256 expansion, nonce40 i kolejne per-attempt56 bytes.
type0 w frng282–324 wybiera PRNG_CHACHA20. Layout56: key32 offsets0..31,
IV16 offsets32..47, counter64 offsets48..55, little-endian. Source refill
ładuje CW do state0..3,12 words do state4..15; XOR counter w state14/15
odpowiada offsets40..47, ostatnim8 bytes IV. Następuje20 rounds/feed-forward,
64 output bytes little-endian, counter++ modulo2^64.64 takich blocks daje
jedno4096-byte refill, po nim ptr0. To nie standardowy448-bit key ani
automatyczna instancja dowolnej standardowej gry ChaCha z innym nonce/counter.

Real game prowadzi legalne contexts i source get_u64/get_u8 access schedule,
z drops i post-read u8 refill. Challenge observer/controller może adaptacyjnie
wybierać legalne getter requests z przeszłych odpowiedzi i wyliczać downstream
scalar/Sign outcomes. Nie dostaje seed/private state/unread buffer/future bytes.
To wewnętrzny hybrid proof interface; publiczny przeciwnik M0 nadal widzi
wyłącznie swój ustalony pk/H/Sign transcript, bez dodatkowych traces/counters.

Ideal game zmienia tylko dostawę refill buffers na fresh independent blocks
IID_BUFFER; source getter schedule i downstream algorithms są identyczne.
Obowiązek obejmuje mapę real source state/initialization do właściwej primitive
game oraz finite-resource distinguishing bound między tymi transcript games.
Jeśli root SHAKE zastępuje się pseudolosową inicjalizacją, wymaga to osobnego
hopu i księgowania zależności nonce/56-byte segments. Nie zakładamy ich IID
tylko dlatego, że wejściowe entropy miało32 uniform bytes.

## 2. Typ budżetu i computational loss

Dla fixed public resource envelope Q_ctx inicjalizacji, B dodatkowych refill
blocks, L getter bytes i czasu T kontrolera trzeba dowieść boundu
`Adv_PRNG_REAL_TO_IID_BUFFER(E,M0_initial_law,Q_ctx,B,L,T)` w powyższej
dokładnej source grze. Wartość tej funkcji/loss pozostaje **nieustalona**.
Nie jest dopisywana do niniejszego wyniku jako epsilon o arbitralnej wartości.

Inicjalizacja zużywa56*Q_ctx root-SHAKE bytes i obejmuje initial refill;
real generator wykonuje64*(Q_ctx+B) ChaCha blocks. Counter starting value jest
częścią state56, nie założonym0; collisions/reuse/multi-context/counter wrap
muszą być rozliczone w wybranej grze. Limit zasobów nie jest nowym source guardem.
M0 parent Sign budget40+16*56=936 bytes dotyczy fs.rng, nie ogranicza inner
getter draws lub SHAKE-sc/H2P (odrębnego obiektu).

BYTE_SCHEDULE/REJECTION_LAW dają dla legalnego scalar call ghost N≤m:
L=33m, R≤min(m,1+floor(33m/4087)),D≤9R i **IID** tail≤(255/256)^m.
Ten dokładny finite-prefix budget może zasilić hop. Usunięcie ghost truncation
w realnej grze wymaga dodatkowego event/tail comparison z jego computational
kosztem; sam IID tail nie dowodzi realnego tail. Source pozostaje uncapped.

## 3. Key law i zakres dalszej kompozycji

Jeden K_seed[E] warunkowany sukcesem całego source KeyGen i obu serializerów,
ten sam shared key w całej grze, p_K raz. Nie przechodzimy do K_iid ani nie
warunkujemy ponownie na loaderze, Sign success lub Safe16. Publiczne parametry
N1536,q18433,sigma768,B2093922385,STATIC4096/r40 i16 outer attempts bez zmian.

Po bridge nadal potrzebne są Gaussian comparison dokładnego K_C, actual ordered
joint law/H6P, joint WholeCallBad z POST, reference/Sign→Verify i dalsze
retry/ROM-QROM/reduction obligations. Nie wynikają z samego primitive PRNG hopu.
