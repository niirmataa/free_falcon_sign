# L_NTT — deklarowana teza i plan domknięcia

Badany obiekt: niezmieniona kopia kandydata L_RHO, falcon-vrfy.c SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Model: GCC 14.2.0/C99/Linux x86_64 LP64; legalne i właściwie rozłączne bufory.
N=1536, q=18433, Phi=X^1536-X^768+1, radix Montgomery R_M=65536.

Dla każdych canonical h,r,c (każdy współczynnik w [0,18432]) wykonujemy
oryginalne funkcje na osobnych kopiach: H=NTT(h), H=tomonty(H), a=NTT(r),
a=montymul_ntt(a,H), a=iNTT(a), p=snapshot(a), a=sub(a,c), d=snapshot(a).
Cel: zdefiniowane, kończące się wykonanie z legalnym dostępem do buforów,
canonical zapisami oraz p=canonical_q(h*r mod Phi),
d=canonical_q(h*r-c mod Phi). H reprezentuje wartości transformacji h
w Montgomery; p,d są współczynnikami zwykłymi.

Pierwszeństwo mają dowody słów i zakresów, następnie stałe i dynamiczny
mq_mkgm3(logn=10), następnie etapy transformacji i kompozycja. Statyczna
gałąź logn<=9 nie jest badanym generatorem. Pełne L_V, loader bajtowy,
centrowanie, norma i EUF-CMA pozostają poza tezą.

Macierz obowiązków ma identyfikatory: W_ADD, W_SUB, W_HALF, W_MONT, DIV,
PRIME_ROOT, GEN10, INDEX_INIT, FORWARD, INVERSE, PRODUCT, SUBTRACT,
RHO_SUBSTITUTION, SOURCE_BINDING, IMPLEMENTATION_CHECKS. W czasie pracy
nie są domyślnie uznane za domknięte; stan końcowy poda OBLIGATIONS.json.

Plan obliczeń używa stałego drzewa CRT (jedno rozszczepienie stopnia 2,
osiem poziomów binarnych, 512 bloków stopnia 3), a nie enumeracji wektorów
lub gęstego tensora wszystkich iloczynów. Certyfikat stałych/tablic ma
rozmiar O(N), audyt indeksów i przebiegi kontrolne O(N log N). Budżety
poszczególnych komend są skończone i zapisywane w dzienniku. W razie
niedomknięcia któregoś koniecznego interfejsu wynik zostanie oznaczony
PARTIAL_PROOF, nie ukryty jako założenie poprawności NTT.
