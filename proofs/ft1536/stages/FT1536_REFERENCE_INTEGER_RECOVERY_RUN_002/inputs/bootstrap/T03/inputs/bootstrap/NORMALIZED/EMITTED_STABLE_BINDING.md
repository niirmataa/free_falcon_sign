# Obowiązkowy certificate KeyGen → bitowy stable gate signera

## 1. Rzeczywisty success path

Legalny M0 E ma fixed ter1/logn10/N1536, STATIC private serialization i oba
successful serializers. Emitted dotyczy całego finite defined successful
capped KeyGen, nie dowolnego accepted decoder input. W source8110–8120
failure ft_keygen_leaf_certificate prowadzi do continue. Break8134, private
encode8145–8160, public encode8170–8181 i return1:8186 mogą należeć do finalnego
udanego attemptu tylko po certificate return1. Między testem i encoderami
nie zmienia się jego f/g/F/G; ten sam SourceDecodeSameSTATIC daje p.

Przebudowane ROOT/RAW emitted binding dostarcza caps, exact NTRU integer
lift, G-present roundtrip i Gate00. Tu konsumujemy dodatkowo RZECZYWISTY
mandatory stable scan, nie jego nazwę jako nową assumption. Nie zmieniamy
jednego K_seed[E]/p_K, success eventu ani retry/conditioning.

## 2. Moment root g00 i bitowe invariances

KeyGen source7690–7745 oblicza g00=selfadj(FFT(g))+selfadj(−FFT(f)). Przed
gate wykonał swój raw tree. Dla tego defined successful prefixu ROOT_FRAME
(transportowany przez RAW na ten sam candidate pin) zachowuje wszystkie
g00 words w offsets4N..5N: child writes mają inne destinations. Nie zakładamy
niezmienności późniejszego tmp signera.

Signer stable helper851–857 oblicza selfadj(FFT(f))+selfadj(FFT(g)). Obydwa
conversions mają te same signed coefficients i parametry; active FFT/table
bodies są te same, deterministyczne, z proved finite domain z ROOT. Pozostają
dwie NIEIDEALNE równości, zamykane następująco:

1. Source neg jest XOR bit63. Zmienia tylko sign; exponent/fraction zostają.
   Source mul limb25/normalizer/pack zależy od nich i XOR znaków. W square
   znaki XORują się do0 dla x oraz neg(x); zero/subnormal masks też są te same.
   StableBits.flip_fields/square_neg_bit_invariant dowodzą równości raw modeli,
   a literal source binding wiąże flip z tym XOR. W reached finite FFT domain
   source mul contract już daje definedness. Nie użyto idealnego (−x)^2=x²
   jako substytutu równości bits.
2. Każdy square jest sign0 normal albo +0; ROOT finite caps wykluczają exponent
   overflow i sign carry. Sumy norm też są sign0, a imag jest literal of(0).
   Dla source add sign0 inputs x,y<2^63, cs z449–473 jest dokładnie
   highbit((x−y) mod2^64): drugi sign-tie składnik jest0. Mask/XOR swap daje
   ten sam ordered(max,min) pair przy zamianie x/y; gdy x=y, pairs są identyczne.
   Cały remaining adder dostaje te same bits. signzero_source_swap,
   ordered_comm/nonnegative_add_bit_comm formalizują ten argument z dowolnym
   deterministycznym residual body. Source body jest opisany przez przypięty
   literal fp_literal.add. Uwzględniono ±0 przed square i +0 po square;
   nie założono complete IEEE lub globalnej commutativity poza tą domeną.

Stąd CAŁE root g00 jest bitowo równe. Gate00 scan także jest token-identical
po zmianie nazwy g00↔f i suffixów helperów. raw arrays/natywne signed-zero
controls sprawdzają tę translację, ale nie są jej uniwersalnym dowodem.

## 3. Pełny stable core i sticky bad

source_binding.json sprawdza siedem helpers po jawnej zamianie nazw oraz
active preprocessing. Stable top/binary bodies, reverse reciprocal i full
scan są token-identical. Top zachowuje exact e1=(a+b)+c, e2=(ab+ac)+bc,
abc=(ab)*c, div(e1,of3), div(e2,e1), div(mul(of3,abc),e2). Nie zastąpiono
dzielenia przez3 mnożeniem przez rounded1/3. Binary wykonuje sum/product,
half, double/product division, memcpy, left/right recursion. Reciprocal
jest w index1535-u, a nie768+u.

bad jest uint32, początkowo0. Każdy valid jest0/1, wszystkie updates są OR
z valid^1; nie ma resetu w środku tego invocation. W KeyGen przed Gate00
żaden helper raw tree nie dostał wskaźnika do bad. Przy accepted return bad=0
WSZYSTKIE wcześniejsze valid były1 (kernel scan_clear). Dlatego żaden
fallback1, także w intermediate stable_positive, nie zmienił danych.

Core coupling jest indukcją po source statements i malejącym n binary:
ten sam input word/initial bad i literal operation → ten sam output word/
updated bad; snapshots/lifetimes MEMORY_FRAME uzasadniają różne adresy.
Loops mają te same finite bounds. Dotyczy również ścieżek nieakceptowanych
w określonej computational domain; akceptacja emitted przenosi się bez
dodatkowego warunkowania.

## 4. Inclusive scan i signer stable_ok

MIN=4090000053700377, MAX=4114444d1a037d50, obie liczby<2^63. Po positive
check każdy w jest positive finite payload<2^63. Obie różnice względem
endpoints mają modulus<2^63, więc highbit unsigned subtraction sygnalizuje
dokładnie underflow. Ich source AND akceptuje MIN≤w≤MAX, włącznie z obu
końcami; kernel inclusive_gate. Full scan obejmuje1536 pozycji bez early exit.

Accepted KeyGen daje dla dokładnej stable sequence wszystkie positive/range
facts. Równość core na bitowo równym g00 daje tę samą sekwencję i bad0 w
signerze. Source pointer-out jest inicjalizowany, stable_ok=true. Statement
nie ma desired normalized conclusion w premise; sqrt/div/scaling zostają
domknięte dopiero przez SQRT_DIV_CONTRACT/NORMALIZATION.

Same broad P_key/raw positive leaf bounds nie dowodzą narrow scan. Silniejszy
all-P_key acceptance jest oznaczony OPEN. Legacy H4 dostarcza tylko danych
o historycznych endpoints/layout i RN premise; nie zastępuje tego bridge.
