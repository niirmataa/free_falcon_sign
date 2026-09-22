# Parametry zasobów i naturalne MT-ISIS

## 1. Dziedzina, jednostki, model obserwacji

β=(Q_s,Q_H,t,w,L)∈Nat^5. Nie wybrano wartości tych parametrów ani λ.
Przeciwnik jest klasycznym losowym algorytmem w bit-cost modelu (np. jawnie
ustalona wielotaśmowa maszyna). t ogranicza jego własne kroki, w liczbę bitów
jego stanu roboczego, L niżej zdefiniowaną liczbę bajtów interfejsu. Odczyt,
kopiowanie i zapisywanie danych A kosztują pracę własną; zapytanie oracle nie
zamienia transmisji długiego ciągu w darmowy krok. Wybór równoważnego modelu
RAM wymaga jawnego przeliczenia kosztu słów, adresów i dużych liczb.

Praca orakli nie jest czasem własnym A. Nie ma oracle zegara; times/retry/fault
counts nie są obserwacjami w tej grze. Czas/memory rzeczywistego symulatora
wchodzą do t_B,w_B osobno. Niezakończony inner loop nie staje się zwróconym
timeout-bot. Wprowadzenie limitu pracy tworzy inną grę i osobny bad-event hop.

Klasa A(β) obejmuje algorytmy, których każdy ukończony przebieg przestrzega
limitów, także dla możliwych długości odpowiedzi. Przekroczenie przez A własnego
budżetu oznacza wyjście poza klasę, nie dopisanie capu do samplera. Można
zaimplementować model klasy przez kontroler portów A, który nie pozwala na
nadmiarowe query/wyjście; nie zmienia to algorytmu oracle.

## 2. Dokładne L

Wszystkie powtórzenia są liczone ponownie. Kanoniczna reprezentacja odpowiedzi
R_q dla rachunku kosztów ma3072 bajty (1536 big-endian uint16, każda wartość<q).
Nie oznacza to uniform rozkładu na wszystkich3072-byte strings.

```
L_used = |pk_bytes|
       + ΣSign (|m_i| + size(reply_i))
       + Σexplicit-H (|x_j| + 3072)
       + |m*| + |r*| + |b*|.
```

Konwencja kosztu typed reply: PRE_ABORT=1 bajt tagu, POST_ABORT=1+40,
success=1+40+8+|b| (tag, nonce, uint64 length, payload). To konwencja portu
oracle, nie nowe bajty hashowanego r||m ani zmiana transportu podpisu r||b.
Uczciwe replies mają size<=4145 z capacity, a po norm-bound<=3209.
Rozmiar wejściowego pk z successful source KeyGen to2881. Brak poprowadzonego
zapytania H po niepoprawnym finalnym nonce nie obciąża tabeli, ale finalne
bajty nadal obciążają L. Przebieg niespełniający L nie jest dozwolonym A(β).

Wiadomości można streamować; suma długości chunków to |m|. Chunk boundaries
nie są dodatkową treścią ani osobnymi Sign queries. Liczba operacji streamu
i zerowych chunków musi mieścić się w t; caller może używać stałego chunkingu.
Zbiór SeenSign obejmuje też aborts. Duplikaty można współdzielić w pamięci,
lecz nie odejmować ich z L_used.

Każdy obiekt API (PK,r,b lub pojedynczy chunk) musi mieć długość<size_t_limit=2^64.
Łączna długość streamowanej wiadomości, nazwy ROM i L wielu obiektów są
matematycznymi Nat; sumy chunków nie muszą mieścić się w size_t. Honest4096 nie jest
capem b*: |b*| może sięgać legalnego limitu w obrębie L.

## 3. Koszt orakli i symulatora

Wspólna tablica ROM ma najwyżej M=Q_H+Q_s+1 różnych wpisów, uwzględniając
wewnętrzne query Sign oraz końcowy niepytany punkt. Łączna długość nazw kluczy
jest ograniczona przez L_key<=L+40*(Q_s+1). Porównywanie byte strings jest
dokładne; nie zakłada się nieudowodnionego bezkolizyjnego haszowania tablicy.

Jawny wariant bazowy tablicy to lista rekordów z długością, bajtami i3072-byte
wartością, przeszukiwana sekwencyjnie. C_table(M,L_key), W_table(M,L_key)
oznaczają jej rzeczywiste koszty bitowe. Konserwatywne rzędy:

```
C_table = O(M*(L_key + M*log(2+L_key)) + M*N*16)
W_table = O(8*L_key + M*N*16 + M*log(2+L_key)).
```

Stałe/implementacja tego kosztu są wejściem przyszłego certyfikatu M6, nie
ukrytym sloganem „polynomial overhead”. Optymalizacja trie wymaga własnego
bindingu i nie jest założona w liczbowym scenariuszu.

Podstawowe funkcje kosztu przyszłego reduktora:

- C_pub/W_pub i epsilon_pub: publiczny sampler D^B z JAWNYM budżetem;
- C_A/W_A: dokładne publiczne mnożenie/mapa A_h, np. przypięta arytmetyka NTT
  lub udowodniony schoolbook; nie jest oraklem bez kosztu;
- C_enc/W_enc: wierna mapa bajtowa idealnej referencji i padding;
- C_ext(N,b_len)=O(b_len+N log N), W_ext=O(N) dla implementacji opartej na
  ukończonym NTT/L_V; prostsze schoolbook O(N²) też wymaga wskazania;
- C_verify(N,|m*|,|b*|): framing, H query, parser i pełny verifier;
- koszt wczytania challenge targets i zapisania witness.

STATIC unary zużywa co najwyżej O(8|b*|) odczytów bitowych. Dlatego C_ext NIE
jest stałą niezależną od L. Wyjście MT kodujemy signed32 dla2N współczynników
oraz indeksem: jest wystarczające dla Q<B (|z_i|<65536), bez sztucznego
ograniczenia naturalnej relacji do int16. Sam Ext0 ma węższy zakres.

Typ przyszłych zasobów:

```
t_B <= t + Q_s*(C_pub + C_A + C_enc)
          + C_ext(N,|b*|) + C_verify + C_table(M,L_key) + C_challenge_IO;
w_B <= w + W_table + W_pub + W_A + W_ext + W_challenge;
L_B <= L + 40*(Q_s+1) + 3072*(Q_H+1) + 8*N + index_bytes(Q_H+1)
       + explicit public-sampler interface data.
```

Są to obowiązki zasobowe do instancjacji, nie certyfikowane stałe czasu kodu.
Jeśli reduktor nie przechowuje całej listy targets, należy podać dokładny
streaming interface zamiast liczyć jednocześnie obie implementacje.

## 4. Randomness i budżety analityczne

Na świeże Sign jeden source root seed ma32 bajty; na sukcesie start pobiera40,
a co najwyżej16 initów pobiera po56. Parent SHAKE max=936. Kernel framing/budget
lemma i source spans to potwierdzają. Nie ogranicza to liczby PRNG refills,
wewnętrznych rejection draws, H2P słów ani publicznego samplera.

Budżety analityczne β_rng=(ell_j), β_pub, β_K są osobnymi argumentami
PRZYSZŁEGO certyfikatu. ell_j liczy wyprodukowane bytes/blocks exact PRNG,
łącznie z odrzuconymi końcówkami bufora get_u64, nie tylko użyte słowa.
PRNG init to key32+IV16+counter8, nie448-bitowy klucz. Counter uint64 i
source refill/get_u8/get_u64 są częścią exact PRNG56 game.

delta_budget dotyczy zamiany nieograniczonej gry source/ideal-coins na
budżetowaną. delta_pub obejmuje wskazany błąd/abort publicznego samplera;
delta_pub_time jest osobna TYLKO jeśli epsilon_pub nie obejmuje tego samego
zdarzenia. Te budżety nie są nowymi capami w źródłach. Conditional sampling
K_seed może kosztować1/p_K capped calls plus jego własny tail/cap; nigdzie
nie zakłada się za darmo efektywności tego warunkowania. Challenger MT może
definiować to prawo; redukcje prymitywów potrzebują rozliczonego auxiliary input.

## 5. MT-ISIS_seed,rel

Challenger losuje JEDNO h z publicznego pushforward K_seed[E], niezależnie
T=Q_H+1 canonical uniform targets c_1,…,c_T∈R_q (z powtórzeniami i zerem).
B dostaje h i indeksowaną listę. Wygrywa, zwracając legalny j i
z1,z2∈Z[X]/Phi z `z1+h*z2=c_j mod(q,Phi)` oraz `Q(z1,z2)<B`.
Nie wymaga się centered z2 ani tego, że para została wyemitowana przez Sign.

```
epsilon_MT[E](T;t_B,w_B,L_B)
  = sup_B Pr[MT-ISIS_seed,rel^E(1,T,B)=Win].
```

To funkcja naturalnego problemu trudności. Mała górna granica jest jawnym
założeniem kryptograficznym, nie wynikiem estymatora i nie restatementem Verify.
L_V dostarcza ekstrakcji i niczego nie mówi o trudności. Przy T=0 nie ma
wygranej; w głównym interfejsie T=Q_H+1>=1. Powtórzone/zerowe cele są legalne.

M6 ma pokazać, że nieprogramowane query A i ewentualny fresh final point
zużywają najwyżej Q_H+1 targets. Świeże m*, włączając abort queries do SeenSign,
i framing r40 wykluczają tożsamość finalnego punktu z punktem Sign. Nie daje
to jeszcze pełnego ROM programming proof. Nie ma dodatkowego mnożnika T ani
target guessing. Ewentualne późniejsze przejście do jednego celu jest osobną
redukcją z własnym kosztem, liczoną najwyżej raz.
