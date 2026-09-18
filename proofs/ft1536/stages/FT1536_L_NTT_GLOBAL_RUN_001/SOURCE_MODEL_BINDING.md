# Powiązanie przypiętego C z konkretnym modelem

Pin falcon-vrfy.c: `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Model wykonania i założenia buforów jak w CLAIM. Źródło produkcyjne jest
montowane read-only. Numery linii dotyczą tego dokładnego pliku.

| C | Model / nowe dowody |
|---|---|
| 582–614 add/sub | Words + SourceModel.addQ_source/subQ_source |
| 631–671 Montgomery/square | Words.mont_contract_z + SourceModel.mmQ_source; mul ma jawny factor5184 |
| 743–885 division/generator | Konsumowane GEN10/DIV_USED; logn10, użyty prefiks1024. Twiddles importuje dokładnie te wartości, nie GMt_square statycznej gałęzi logn<=9 |
| 1001–1010 first quadratic | forwardRootOp, pairAddr768, pairStep, 768 kroków |
| 1015–1037 binary forward | forwardSchedule9 2 768; forwardMiddle; forwardBinaryOp; pairAddr(t/2) |
| 1042–1061 cubic forward | forwardCubicOp, tripleStep, tripleAddr b k=3b+k, 512 kroków |
| 1089–1108 cubic inverse | inverseCubicOp i te same adresy/snapshoty |
| 1113–1135 binary inverse | inverseSchedule9 256 6; schedules_reverse; inverseMiddle |
| 1140–1149 final quadratic | inverseRootOp, pairAddr768; special igm[0] |
| 1155–1158 scaling | scaleStep, point_prefix, scale_loop; ni6187 z DIV_USED; ordinary18421 |
| 1161–1179 dispatch | ustalone ternary1, logn10; powyższe dwa modele |
| 1185–1243 tomont/montPoint/sub | Pipeline.toMontC/montPointC/subtractC i point_prefix |

## Indeksy i kolejność

W pierwszym/ostatnim bloku b=u, h=768. Dla binary h=ht=t/2 i
`b=u1*h+(v-v1)`. Ponieważ `v1=u1*t`, `0<=v-v1<h`, otrzymujemy
`b/h=u1`, `b%h=v-v1`, `pairAddr h b false=v`, `pairAddr h b true=v+h`.
Zagnieżdżone pętle przebiegają dokładnie b=0..767, w tej kolejności.
Odczyt tablicy to `m+b/h`. `forward_params_ok`, `schedules_reverse` oraz
`initialized_binary_read` dowodzą poprawnych zakresów dla wszystkich etapów.
Cubic: b=u/3, v=512+b, b=0..511. `initialized_cubic_read` wyklucza ogon tablic.
Odczyty szczególne indeksów0/1 również należą do zainicjalizowanego prefiksu.
`gmAt/igmAt` mają totalny fallback0, ale żaden rzeczywisty odczyt go nie używa.

Forward `(m,t)`: (2,768),(4,384),(8,192),(16,96),(32,48),(64,24),(128,12),(256,6).
Inverse: lista odwrotna. Guardy pętli odtwarzają forwardSchedule/inverseSchedule;
fuel9 obejmuje osiem ciał i sprawdzenie końcowego guardu. Wewnętrzne varianty:
768-b, 512-b i1536-u. Ostatnie aktualizacje liczników to m512/t3 forward,
m1/t1536 inverse, u1536/v1024 cubic; nie są kolejnymi odczytami tablic.
Wszystkie te wartości mieszczą się w size_t64; ustalone przesunięcia9/8 są legalne.

## Odczyt starych wartości i stores

`pairStep` i `tripleStep` najpierw wiążą `saved` ze starym stanem, następnie
wykonują odpowiednio2/3 stores w kolejności C. SourceModel zachowuje kolejność
zagnieżdżonych helperów i Montgomery multiplications, również cubic fB0/fB1/fB2,
fC0/fC1/fC2 i inverse f11/f12/f21/f22. Definicyjne równości w BlockExpressions
wiążą source expressions z algebraicznym checkerem; nie zakładają poprawności NTT.

Buffer.prefix_invariant dowodzi niezmienności jeszcze nieprzetworzonych par/trójek
i równości przetworzonych ze starym snapshotem dla KAŻDEGO prefiksu. Injectivity
Layouts wyklucza alias między blokami. pair_first_store rozlicza pierwszy store;
tripleStep jest jawnym złożeniem trzech store, z odczytami z tego samego saved.

Canonical inputs, gm/igm oraz wynik każdego add/sub/mm są canonical. Indukcja
po pętlach (SourceModel.forward_canonical/inverse_canonical) i lokalne range
lemmas utrzymują przesłanki Words. Dotyczy to również temporaries zagnieżdżonych
helperów i stanów między stores: każdy store zapisuje wynik o zakresie0..18432,
pozostałe komórki zachowują zakres. Cast do uint16 jest dokładny. Nie zakłada się,
że z*Q0It nie zawija uint32; low16 tego wrap jest rozliczone w Words.

## Kontrole translacji

`prepare_controls.py` dodaje siedem rodzajów hooków do kopii obserwacyjnej.
Usunięcie oznaczonych linii przywraca dokładny pin źródła. `control_binding.json`
zapisuje wstawki i hashe. Baseline i plain mają identyczne endpoints.
TraceMain wykonuje IMPORTOWANE pairStep/tripleStep/scaleStep na materializowanym
stanie, zachowując komórki poza footprintem (pair_frame/triple_frame).
Materializacja służy wykonaniu testu; definicje dowodzonych forwardMem/inverseMem
pozostają niezmienione. Pierwsza wersja z łańcuchem funkcjonalnych closures
przekroczyła120s; pełna próba jest zachowana w artifacts/attempts/controls_interpreted.

Nowe source/model bindingi są jawną translacją i kontrolami, nie nowym założeniem
w typie inverse_forward. Przy ocenie przypiętego modelu trzeba konsumować tę
translację razem z odziedziczonym D1–D3. Nie dowiedziono ogólnego C semantics,
kompilatora ani globalnego forward→polynomial equivalence.
