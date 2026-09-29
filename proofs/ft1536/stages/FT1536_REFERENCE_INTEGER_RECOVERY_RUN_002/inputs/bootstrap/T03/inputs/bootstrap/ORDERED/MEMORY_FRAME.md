# Actual sampling memory, lifetime i conditional frames

Root entry ma normalized sk24576 words, tree=sk+6144, tmp10752:
t0=tmp0,t1=tmp1536,z0=tmp3072,z1=tmp4608,scratch=tmp6144.
Sk/hm/context/output allocations mają legalne types/alignment/lifetimes;
scratch/outputs są disjoint od live const targets/tree i context. Callback
source może zapisywać PRNG/fault, ale nie tree/targets. To jawny legal-state
interfejs, nie założenie probabilistyczne lub memory-unsafe oracle.

## Per-node source frame

Binary k>0: y0=tmp,y1=tmp+n/2. Split t1 używa z1 jako temporary input pair,
child writes y0/y1 i scratch od tmp+n. Child nie dotyka live t0/tree i kończy
się przed merge z1. Dopiero then CM(z1,L)+t0 tworzy updated target w tmp;
split do z0 pozwala ponownie użyć y0/y1. Z1 i L pozostają żywe i niezmienione
przez left child, więc repeated CM w1691–1693 ma BITOWO te same inputs
i output co w1674–1675. Final rounded subtraction wciąż wnosi własny error.

Cubic: z2 po child2 pozostaje niezmienione przez child1/child0. Z1 jest
odjętym residualem po1745 i taki zostaje konsumowany w1753/1774. Copy1765
przenosi current z0 target do tmp PRZED split, aby writable outputs nie
aliasowały live input. Powtórzone P21/P10/P20 mają te same bits przez frames.

Root: po first/right child i merge z1, source CM(z1,Lroot) jest kopiowany
do scratch i dodany do t0. Left output nie nadpisuje z1/Lroot; final
CM daje te same bytes. Model porównuje wszystkie takie pary, a full C trace
porównuje wszystkie polynomials; products.json zapisuje completed instances.

Base logn0 czyta sigma i oba targets do locals. Następnie right callback,
residual/half/new mu0, drugi callback, last subtraction i dwa stores.
Nie wymaga zachowania martwego tmp lub z0 target po legalnym reuse.
Nonreturn zatrzymuje prefix przed przyszłymi stores; nie wyciągamy z niego
initialized returned arrays. Fault return jest rzeczywistym return0, więc
te source arithmetic/stores nadal następują (z osobną numeric scope).

## Footprints i high-water

Inner scratch S(0)=0,S(k)=2^k+S(k−1)=2^(k+1)−2. Depth9 potrzebuje
512+S(8)=1022 słowa. Top potrzebuje1536+1022=2558 słów od6144,
więc peak=8702<10752. Formowane pointers pozostają w allocation; base
nie dereferencjuje tmp pointer z końca slice. Width/leaf map czyta tylko
sk tree i ma3072 structural uses, nie3072 aktywnych floors przy fault.

Dla dowolnego defined sampling prefixu writes są tylko tmp[3072,8702) oraz
legalny scalar context. Root targets[0,3072), całe sk, hm, zewnętrzne s1/s2
i tmp tail[8702,10752) są zachowane. Kernel ReachFrame instancjuje source
destination/range induction w tagged-address modelu; nie jest full C heap.
Numerical totality całej lewej gałęzi/fault tail nie wynika z samego frame.

Native harness samej oryginalnej recursion sprawdza tree/root inputs,
canaries, full10752-word state i initialized-read model. Syntetyczne markers
nie są premise source initialization; arbitrary legal old scratch może mieć
inne bytes. Model tworzy initialized ranges wyłącznie przy rzeczywistych writes.
