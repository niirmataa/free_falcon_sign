# Dowód forward i iloczynu

## 1. Niezależna ewaluacja i skończone sumy

`sumN 0 f=0`, `sumN(n+1)f=sumN n f+f n`.
`peval n a z=(sumN n (fun k => a[k]*z^k))%18433`.
`blockEval n base s z=peval n (fun k => s[base+k]) z`.
To specyfikacja wielomianowa niezależna od niezmienionego forwardC.

Sums dowodzi sum_congr, linearity, split, zamiany dwóch skończonych sum,
redukcji modulo i dokładnej równości do List.ofFn/foldl. Evaluation dowodzi:

```
peval(n+m) f z = (peval n f z + z^n*peval m (fun k=>f[n+k]) z)%q.
z^n ≡ c ⇒ peval n (fun k=>(f[k]+c*f[n+k])%q) z = peval(2n) f z.
```

Modulo w KAŻDYM store jest uwzględnione przez eval_mod_coeff/eval_congr,
nie pominięte w idealizowanej macierzy. eval_mod_node rozlicza canonical węzeł.

## 2. Fizyczny blok i jeden source split

`blockBase h pos=(pos/h)*h`.
`rootLabel pos =14649` dla pos<768, w przeciwnym razie1−14649.
`splitLabel m h pos` to ordinary gm[m+pos/(2h)] ze znakiem minus dokładnie
gdy `h<=pos%(2h)` (górne dziecko).

split_layout dowodzi, dla h z rzeczywistego harmonogramu, pos<1536, k<h:
numer pary b=(pos/(2h))*h+k jest <768, b/h=pos/(2h), adresy rodzica to
base(2h)+k i base(2h)+h+k, a wybrane dziecko ma adres base(h)+k.
Ta geometria wiąże źródłowy indeks gm, znak i fizyczne położenie.

CRTStages konsumuje root_coefficients/binary_coefficients, które już wynikają
z KAŻDEGO prefiksu prawdziwych stores. Nowe twierdzenia:

```
z^768 ≡ rootLabel pos ⇒
 blockEval768(base768 pos)(sourceRoot s)z = peval1536 s z.

z^h ≡ splitLabel m h pos ⇒
 blockEval h(base h pos)(sourceBinaryStage(m,h)s)z
 = blockEval(2h)(base(2h)pos)s z.
```

Nie twierdzi się, że mieszany, częściowo zapisany bufor jest już całym
wielomianem dziecka. Jego dokładne komórki opisuje odziedziczony prefix invariant;
nowy inwariant ewaluacyjny stosuje się do ukończonych wybranych bloków.

## 3. Złożenie ośmiu rzeczywistych poziomów

StageChain t ps opisuje t rodzica, dokładne h=t/2 i końcowy stopień3.
actual_chain sprawdza listę produkowaną przez prawdziwy forwardSchedule9 2 768.
middle_eval jest INDUKCJĄ po tej liście, z rzeczywistym forwardMiddle ps s,
nie definicją transformacji przez ewaluację.

Dla wybranego pos i z spełniającego etykiety kolejnych przodków:

```
blockEval3(base3 pos)(forwardMiddle ps s)z = blockEval t(base t pos)s z.
```

Wywołania binary_block_eval konsumują po kolei osiem stanów C. Prefix/frame,
range i termination/index facts pozostają niezmienionymi wejściami z PREV.

## 4. Wszystkie1536 liści i cubic

`node b j=(ordinary(gmAt(512+b))*14648^j)%q`, b<512, j<3.
Nowy certyfikat wiąże konkretny wiersz tabeli z indeksem przez unitRow_id,
a następnie sprawdza dla każdego z1536 węzłów:

- root power768 i osiem power(h)=splitLabel w faktycznym harmonogramie;
- PhiZero;
- trzy współczynniki źródłowego cubic expression, równe1,z,z² moduloq.

Nie ma nowych literalnych tablic gm. Sprawdzane są istniejące units_i,
odczytywane przez to samo gmAt co w SourceModel. leaf_facts wyklucza
fallback i pominięcie wiersza (<512); pos=3*(rowID−512) redukuje się do3b.

powFuel to strukturalne modular repeated squaring. powFuel_correct wymaga
n<2^fuel, a powFast wybiera fuel=n, co rozlicza Nat.lt_two_pow_self.
powFast_correct jest uniwersalny. nodeCheck_sound nadaje znaczenie boolom;
by decide certyfikuje stałe kernelowo. Nie jest to native_decide ani test
danych v. Dodatkowy certyfikat domyka brakujące powiązanie przodków z każdym
fizycznym liściem, nie zakłada globalnego forward.

Konsumowane root_and_scale_facts zawiera omega²+omega+1=0 oraz omega!=1;
stąd omega³=1. W nowej instancji potrzebne konsekwencje są sprawdzone
bezpośrednio dla każdego j: na ostatnim h=3 node³=etykieta rodzica, zaś
source cubic weights są dokładnie1,node,node². Uwzględnia to alpha³=tau,
działanie omega i kolejność0,1,2 bez pozostawienia hipotezy o etykietach.

Expressions.eval_linear/cubeF_bind przenoszą te trzy stałe na WSZYSTKIE
canonical współczynniki bloku. cubic_eval, middle_eval i root_block_eval
dają FORWARD_GLOBAL w dokładnym porządku3b+j. node_zero jest osobnym eksportem.

## 5. Współczynnikowy iloczyn modulo Phi

Z PhiZero: z^1536 ≡ z^768−1 oraz z^2304 ≡ −1.
Monomials.remMonomial_eval dowodzi dla KAŻDEGO k<3071:

```
peval1536(remMonomial k)z = z^k%q.
```

Przypadki mają dokładnie historyczne granice1536 i2304. sum_delta,
linearność i równania potęg rozliczają znaki i stopnie.
Product.productCoefficient_eq wiąże proof abbreviation rawCoefficient
z niezmienionymi List.ofFn/foldl. eval_sum i sum_swap przenoszą ewaluację
przez obie sumy; eval_convolution używa z^(i+j)=z^i*z^j. Otrzymujemy:

```
PhiZero z ⇒ eval(product h r,z)=eval(h,z)*eval(r,z) modq
```

dla wszystkich całkowitych h,r. liftForward_eval usuwa canonicalizację
wejścia przez eval_mod_coeff. Każda współrzędna Fin1536 ma rozkład
3*(i/3)+(i%3), więc dowiedziono forward_product jako równości wektorów.

Nie ma koła zależności: product_eval → forward_product →
product_canonical_inputs. Ostatnia równość jest konsekwencją forward_product
i odziedziczonego inverse_forward, potrzebną do podstawienia L_RHO.

## 6. Zamknięta kompozycja

Complete.L_NTT to aplikacja istniejącego L_NTT_pending_forward do NOWEGO,
dowiedzionego forward_product. p,d, zakresy i rho-substitution są wyeksportowane
osobno. Pełne typy (`pp.all=true`) i proof terms końcowych tez nie zawierają
nierozliczonego parametru ewaluacji, inwariantu, iloczynu lub zgodności modeli.
Jedynymi aksjomatami są standardowe propext, Classical.choice, Quot.sound.
