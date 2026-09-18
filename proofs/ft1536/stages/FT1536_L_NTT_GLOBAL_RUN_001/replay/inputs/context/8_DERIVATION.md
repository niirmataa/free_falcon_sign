# L_NTT — sprawdzone ogniwa i dokładna granica globalnego dowodu

Ten dokument rozdziela dowiedzione kontrakty lokalne, sprawdzone certyfikaty
stałych oraz globalny interfejs, którego instancjacja dla funkcji in-place C
nie została ukończona. Nie nadaje dodatniego werdyktu całemu L_NTT.

## D1. Arytmetyka słów i translacja C

W całym dokumencie q=18433, R_M=65536, Rt=10237, R2t=4564,
q0i=18431, Rinv=5184. Wersja źródła ma SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Kontrakty słów są sprawdzone w `formal/Words.lean`.

Dla canonical x,y, x+y należy do [0,36864]. Surowe x+y-q należy do
[-18433,18431], a x-y do [-18432,18432]. UInt32 przechowuje redukcję modulo
2^32. W tych przedziałach bit 31 wyniku jest ustawiony dokładnie w przypadku
ujemnego surowego wyniku. Przesunięcie jest unsigned, zatem `q & -(d>>31)`
jest odpowiednio q albo 0; końcowe dodanie może legalnie zawinąć uint32.
`fix_contract`, `add_contract`, `sub_contract` dowodzą zakresu i poprawnego
canonical modulo, a nie zakazu unsigned wrap.

`mq_rshift1` dodaje q dla nieparzystego x, a potem dzieli przez 2. Suma jest
nieujemna, mniejsza od 2^32 i parzysta; wynik jest canonical i reprezentuje
x/2 w R_q. Helper jest sprawdzony, lecz nie jest potrzebny aktywnej ścieżce
ternary/logn=10, która odracza skalowanie do końca inverse.

### Montgomery — rzeczywiste granice

Niech z=x*y i k=((uint32(z*q0i)) & 65535). Wtedy:

| Obiekt | Granica / znaczenie |
|---|---|
| z | 0..339738624; pierwsze mnożenie nie zawija uint32 |
| matematyczne z*q0i | może przekraczać 2^32; źródłowe mnożenie **zawija** |
| k | 0..65535; low16(u32(z*q0i)) = (z*q0i) mod65536 |
| w=k*q | 0..1208006655; bez wrap |
| z+w | 0..1547745279, poniżej 2^31; bez wrap |
| (z+w)/65536 | liczba całkowita w 0..23616, poniżej 2q |
| po odjęciu q | surowo -18433..5183; ujemne wartości zawijają uint32 |
| po masce/korekcie | canonical 0..18432 |

To poprawia uzasadnienie komentarza źródłowego: z nie musi być mniejsze od q,
a granica całej sumy nie jest 29-bitowa. Nie jest to kontrprzykład do kodu;
właściwa granica 31-bitowa nadal zapewnia poprawne wykonanie.

Kernel sprawdza `q*q0i+1=65536*5184`. Ponieważ k jest właściwymi niskimi
bitami, z+kq jest podzielne przez 65536. Ostateczny wynik m spełnia
`65536*m ≡ x*y modq`, a `65536*5184 ≡ 1 modq`, więc
`m=(x*y*5184) modq`. `mq_montymul_contract` obejmuje **wszystkie** canonical
operands, z osobnym dowodem ograniczenia ich iloczynu. `mq_montysqr_contract`
jest jego specjalizacją. Każdy późniejszy store do uint16 jest dokładny,
jeżeli konsumuje ten canonical wynik.

Model Lean jawnie zawiera u32/mod2^32, low16 oraz korektę wysokiego bitu.
Związek tych operacji z unsigned C wynika z reprezentacji binarnej: maska
2^16-1 zachowuje niskie bity, unsigned shift o 16 jest podłogą dzielenia przez
2^16. Mnożenia i dodawania źródła mają uint32 operands. Nie wykorzystuje się
signed overflow ani przesunięcia ujemnego signed słowa. Nie jest to
formalizacja kompilatora; model oraz te reguły translacji są jawne.

## D2. Pierwszość i źródłowy łańcuch dzielenia

`small_divisors` sprawdza brak dzielników 2..135. `prime_factorization`
jest uniwersalnym twierdzeniem: a*b=18433 dla liczb naturalnych implikuje
a=1 lub b=1. Dowód rozlicza także przypadek a,b>=136, niemożliwy, ponieważ
136^2>18433. To kompletny certyfikat pierwszości, nie sam wynik `is_prime`.

Parser certyfikatu odczytuje rzeczywiste przypisania y0..y18 w
mq_div_18433, nie komentarz. Ich wykładniki to:

```text
1,2,3,6,7,14,28,35,63,126,252,287,574,1148,2296,4592,9184,18368,18431.
```

y0 jest y w Montgomery. Każde źródłowe mnożenie/square pozostawia tę
reprezentację i dodaje wykładniki, zgodnie z kontraktem Montgomery. Ostatnie
mnożenie z ordinary x usuwa radix. Dla niezerowego y daje x*y^(q-2).
W aktywnej ścieżce potrzebne są tylko stałe dzielniki poniżej; ich kompletny
przebieg 19-elementowego łańcucha i końcowego mnożenia ma **60** rekordów
sprawdzanych przez kernel (`chain_*_checked`). Dodatkowe tożsamości jednostek
sprawdzają, że wynik jest właściwym ilorazem — nie zakładamy poprawności
dzielenia z nazwy funkcji.

- generator: `mq_div_18433(R2t,1874)` daje 7714;
- końcowy szczególny inverse root: `mq_div_18433(R2t,8479)` daje 3318;
- inverse scaling: `mq_div_18433(Rt,1536)` daje 6187.

Wszystkie mianowniki są niezerowe i canonical. Dla interpretacji:
1874 = R_M*625 modq, 7714 = R_M/625 modq;
8479 = R_M*(2*14649-1) modq; 3318/R_M = 2523 modq;
6187/R_M = 18421 = -12 modq = 1536^(-1).

Sprawdzono też C dla wszystkich 18432 niezerowych y przy liczniku 1,
niezależnie wymagając y*wynik=1 modq. To kontrola dodatkowa. Certyfikat
konkretnych trzech wywołań wystarcza do generatora i skalowania tej ścieżki.

## D3. Generator logn=10 — wartości, pamięć i kolejność

Warunek logn<=9 jest fałszywy. W obu transformacjach wywoływany jest
mq_mkgm3, a ni nie jest odczytem INVNQt[10].

W `while (k++ < 11)` przy początkowym k=10 wykonuje się jedno square;
końcowy fałszywy test również inkrementuje k do 12. K jest następnie
nadpisywane przez 11-10=1. Zatem ordinary root to g=25^2=625, a jego word
Montgomery to 1874. Stałe g2,g4,ig2,ig4 są odpowiednio
9971,10542,3463,14786; ich równania sprawdza kernel.

Dla u=0,2,...,510 zapisuje się indeksy
`512+rev10(2*u)` i `512+rev10(2*(u+1))`. Funkcja rev10 jest dokładnie
dziesięciokrokowym odwróceniem niskich bitów. Jej matematyczny model
`revAux` ma te same unsigned operacje (y*2 plus niski bit x, potem x/2).
Przez 10 kroków y<2^10, więc nie zawija się słowo 32-bitowe.
Kernel sprawdza zakres i inwolucję u↦rev10(2u) dla całego `Fin 512`.
Ta mapa jest bijekcją 0..511; dolny etap zapisuje dokładnie 512..1023.

Ordinary wartości tych liści można opisać niezależnie od pętli C:

```text
gm[512+rev9(u)] / R_M = 625^(3*u+1+(u mod2)) modq, 0<=u<512.
```

256 rekordów `sequence` sprawdza rzeczywisty postęp x→x*g4→x*g4*g2,
jego odwrotny odpowiednik oraz adresy zapisu. Powiązanie rekordów ze sobą,
wartościami C i indeksami kontroluje binding certyfikatu.

Następnie u=256..511 czyta 2u w 512..1022 i zapisuje cube do u.
Pętla u=255..1 czyta 2u>u, już zapisane wcześniej, i zapisuje square.
W końcu gm[0]=gm[1], a igm[0] otrzymuje specjalną odwrotność 2a-1.
Łącznie każdy indeks 0..1023 jest zapisany; nie czyta się niezainicjalizowanych
1024..2047. Nie eksportowano ani nie haszowano tej reszty buforów.
Wszystkie przesunięcia i inkrementacje są znacznie poniżej granic unsigned
i size_t; największy indeks tabeli to 1023, a alokacja ma 2048 elementów.

Kernel sprawdza 1024 pary zakresów/unit, 511 rekordów obliczeń rodziców,
510 relacji drzewa oraz odpowiednie stałe początkowe. Dla i>=1:
`gm[i]*igm[i] modq=R2t`; igm[0] ma osobną relację, nie jest mylone z odwrotnością gm[0].
Sage porównuje cały prefiks C z niezależnymi zamkniętymi formułami potęg.

## D4. Lokalne modele bloków

Przez tildę oznacz ordinary wartość słowa Montgomery, tj. mnożenie przez
5184 modulo q. a=tilde(gm[1])=14649, omega=a^2=14648,
omega^2=3784, deltaInv=tilde(igm[0])=2523.
Kernel sprawdza a^2-a+1=0, omega^2+omega+1=0, omega!=1 i
(2a-1)*deltaInv=1.

Pierwszy blok forward na parach współczynników ma macierz

```text
A = [[1,a],[1,1-a]].
```

Odpowiadający końcowy blok inverse ma macierz

```text
I = [[1-deltaInv,1+deltaInv],[2*deltaInv,-2*deltaInv]],  I*A=2*Id.
```

Blok binarny z ordinary s=tilde(gm[j]) ma

```text
F2 = [[1,s],[1,-s]],  I2 = [[1,1],[s^-1,-s^-1]],  I2*F2=2*Id.
```

Blok cubic z alpha=tilde(gm[512+i]) ma wiersze

```text
F3 = [[1,alpha,alpha^2],
      [1,alpha*omega,alpha^2*omega^2],
      [1,alpha*omega^2,alpha^2*omega]].
```

Inverse to odwrotny DFT3 z omega^-1, poprzedzony po stronie wyjścia
diag(1,alpha^-1,alpha^-2); jego iloczyn z F3 wynosi 3*Id.

Nie poprzestano na testach wartości danych: **1022** rekordy wierszy
macierzy stopnia 2 oraz **1536** rekordów stopnia 3 sprawdza kernel.
`formal/Linear.lean` dowodzi symbolicznie dla dowolnych wejść, że złożenie
wierszy odpowiada mnożeniu ich współczynników. `row2_sound`, `row3_sound`
i `all_sound` ujawniają znaczenie checkerów, więc sprawdzone tożsamości
współczynników dają lokalne tożsamości dla wszystkich wejść bloków.

## D5. Indeksy i kandydat globalnego inwariantu — luka pozostająca

Dokładny kontroler indeksów potwierdza następujące harmonogramy. Forward:

```text
(m,t)=(2,768),(4,384),(8,192),(16,96),(32,48),(64,24),(128,12),(256,6).
```

Przy każdym z nich m*t=1536, ht=t/2, blok i zaczyna się w i*t,
pary mają indeksy i*t+k i i*t+k+ht dla 0<=k<ht. Każdy element tablicy
występuje raz w rozłącznych parach. Odczyt gm ma zakres [m,2m-1].
Inverse używa tych samych par w odwrotnej kolejności poziomów:
(m,t)=(256,6),...,(2,768). Cubic dzieli 0..1535 na 512 kolejnych trójek,
u=3i, z indeksem tabeli 512+i. Końcowe skalowanie ma dokładnie 1536 zapisów.
Przy legalnych wejściowych buforach te granice wraz z kontraktami prymitywów
uzasadniają lokalne zakresy i bezpieczne stores uint16.

Pozostający globalny model powinien wiązać **każdy** prefiks faktycznych
pętli in-place z następującym inwariantem wielomianowym:

1. Po pierwszym bloku dwie połowy są współczynnikami reszt f modulo
   X^768-a i X^768-(1-a).
2. Blok stopnia t z etykietą tau rozszczepia się przez s^2=tau na
   reszty A+sB i A-sB modulo X^(t/2)-s i X^(t/2)+s.
3. Dla m=2 należy użyć dwóch osobnych równań gm[2]^2=a i gm[3]^2=1-a.
   Dla dalszych poziomów relacje dzieci parzystych/nieparzystych są
   s_even^2=parent, s_odd^2=-parent.
4. Po ostatnim poziomie binary blok i stopnia 3 ma etykietę
   (-1)^(i mod2)*tilde(gm[256+floor(i/2)]). Odpowiadający alpha ma cube
   równe tej etykiecie; trzy wyniki to ewaluacje w alpha, alpha*omega,
   alpha*omega^2, w fizycznych pozycjach 3i,3i+1,3i+2.

Równania stałych potrzebne w tych punktach są już sprawdzone. Jednak
**nie wyeksportowano jeszcze zamkniętej, globalnej instancjacji tego
inwariantu dla stanów buforów funkcji źródłowych**, wraz z analogicznym
powiązaniem reverse traversal inverse. Obecna kontrola adresów i lokalne
macierze nie są przedstawiane jako taka instancjacja.

Dokładne brakujące interfejsy dla źródłowych F i G to:

```text
FORWARD_GLOBAL:
forall canonical v, F(v)[3i+j] = sum_k v[k]*(alpha_i*omega^j)^k modq.

INVERSE_GLOBAL:
forall canonical v, G(F(v))=v,
z odwróceniem właśnie tych źródłowych poziomów i tymi samymi indeksami.
```

Oczekiwane skalowanie składa się z 3, ośmiu czynników 2 i końcowego 2,
czyli 1536. Ni=6187 oznacza ordinary czynnik 18421, odwrotność 1536.
Te fakty są sprawdzone; nie zastępują samego powiązania wszystkich stanów.

## D6. Dlaczego iloczyn potrzebuje więcej niż roundtrip

Po domknięciu FORWARD_GLOBAL wszystkie węzły są pierwiastkami Phi:
wynika to z powyższego drzewa czynników i alpha_i^3=tau_i. Dla
u=canonical_q(h*r modPhi) mielibyśmy F(u)=F(h) punktowo razy F(r).
Następnie INVERSE_GLOBAL dałoby G(F(u))=u. Sam G(F(v))=v, bez poprawnej
interpretacji węzłów dla Phi, nie wystarcza.

Przygotowanie H ma dodatkowy czynnik R_M. Kernel sprawdza ogólną
tożsamość usuwania tego czynnika przez Montgomery: multiplication ordinary
F(r) przez Montgomery F(h) daje ordinary iloczyn. Odejmowanie c ma już
uniwersalny kontrakt słowowy.

`formal/Composition.lean` definiuje coefficient product w R_q przez
redukcję monomianów stopnia do 3070:

```text
k<1536:           X^k
1536<=k<2304:     X^(k-768)-X^(k-1536)
2304<=k<=3070:   -X^(k-2304).
```

To wynika z X^1536=X^768-1 i X^2304=-1, nie redefinicja iloczynu przez NTT.
Końcowe twierdzenie `L_NTT_after_global_interfaces` ma jawne przesłanki
`forward_product` oraz `inverse_forward`. Są one nadal globalnymi
obowiązkami instancjacji dla C. Dlatego werdykt pozostaje **PARTIAL_PROOF**,
mimo poprawnie sprawdzonej warunkowej kompozycji.

Po domknięciu L_NTT podstawienie r_i=rho_Z(s_i) z L_RHO będzie dawało
r≡s i stąd d=canonical_q(h*s-c modPhi). Ta konsekwencja jest obecnie
warunkowa na globalne L_NTT; centrowanie do int16 i norma nie są częścią
bieżącego etapu.
