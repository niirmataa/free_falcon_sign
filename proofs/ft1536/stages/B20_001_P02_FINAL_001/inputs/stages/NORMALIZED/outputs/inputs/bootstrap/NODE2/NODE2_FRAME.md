# Lifetimes NODE3 → pierwszy binary inner

Po NODE3 dim3: three inputs at root scratch offsets0,512,1024; d11=1536,
d22=2048, lower t0=2560, lower t1=2816, t2/work=3072. NODE3 outputs są
certyfikowane w tym MOMENCIE. ffLDL_depth1651–701 następnie:

1. split_deep(g00_NODE3)→lower t0/t1, Adj, inner(logn8,tmp=t2);
2. split_deep(d11_NODE3)→te same lower t0/t1, Adj, inner;
3. split_deep(d22_NODE3)→te same lower t0/t1, Adj, inner.

Same splits zapisują wyłącznie2560..3071. Każdy niższy inner zapisuje tree
i scratch od3072 oraz dalsze suffixy, nie NODE3 diagonal blocks poniżej2560.
Dla każdego defined earlier prefix zachowane są więc g00,d11,d22 aż do ich
właściwego odczytu. Nie twierdzimy, że wszystkie wcześniejsze operations
są numerycznie poprawne lub zawsze docierają do następnego call.

Przed inner(logn8) bieżące s0/u1 mają po256 words: real f,imag f+128. API
wymaga disjoint outputs/scratch od tych const inputs; g00=g11=s0 jest
dozwolonym read-only alias. Source inner598–647 ustawia t0=tmp,t1=tmp+128,
t2=tmp+256, wykonuje własny split/Adj/inner(logn7) PRZED lokalnym dim2.
Te destinations są rozłączne od bieżących s0/u1. Jeśli defined prefix
dochodzi do dim2, jego inputs są bitowo te same, co w Node2Slice_C.

W lokalnym tagged-address model s0/u1 zajmują0..511, scratch512..1023,
root d11 zaczyna się w768. Wszystkie earlier scratch stores są≥512.
BinaryFrame.input_frame składa dowolną listę takich stores. Source destinations
i alias restrictions są odrębną analityczną translacją C do tego modelu.
Root L zajmuje pierwsze256 tree words; tree size inner8=9*256=2304,
scratch≤2*256. Nie ma wyjścia poza zadeklarowane C buffers.

Po local dim2 source robi drugi split z d11 w tmp+256, zapisując tmp prefix,
a następna lower recursion może ponownie użyć storage d11. Eksport dotyczy
właściwego momentu po dim2, nie niezmienności scratch do końca całego Sign.
NODE3 d11/d22 lifetimes, opisane wyżej, są innymi zakresami niż ten local d11.

Branch0 nadal zaczyna się przed root dim2. Jej g00/NODE3 facts pochodzą z
wcześniejszego FFT/Gram/Gate, nie z przyszłego wykonania branch1. Branch1
wiąże się z RootSlice tylko po stosownym defined prefix. Matematyczny
isolated slice każdej(b,k) jest badany niezależnie od total execution
całej tej wcześniejszej recursion.

Kontrole C: sześć isolated source pipelines z native NODE3 parent dumps,
unchanged parent i child inputs, repeated alias, canaries. Trzy dodatkowe
constant-array cases uruchamiają oryginalny inner8 i porównują jego root L
z isolated dim2, sprawdzając frame i2304-word extent. To publiczne synthetic
controls, bez private loadera/Sign/KeyGen i bez emitted membership claim.
