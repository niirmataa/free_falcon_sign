# Guard we właściwej kolejności stores i public TV

Przestrzeń source outcome: ZERO, BYTES(exact returned prefix), NONRETURN.
Rozszerzamy ją o rozłączny proof-only PRECAST_EXIT. Counterfactual C_retry
korzysta z TEGO SAMEGO entry i globalnego idealnego tape co G_retry_IID,
z tymi samymi calculations/PC. Tuż przed każdym source int16 store1931,
a następnie1932 dla u=0..1535, obliczona już source int64 wartość jest
sprawdzana: poza[-32768,32767] → PRECAST_EXIT przed tym cast/store;
w zakresie → ten sam store i kontynuacja. Wcześniejsze good stores mogły
już nastąpić. Guard nie czeka na normę ani na koniec całego output loop.

Definicja matematycznych w1/w2 do BadPrecast może oznaczać wszystkie rint
wartości fixed post-iFFT arrays bez ich wykonywania w zmienionej kolejności.
POST dowodzi domain/totalności pure fpr_rint; arrays nie zmieniają się podczas
output loop, output destinations są disjoint. To uzasadnia equivalence
`first out-of-range guard exists iff joint BadPrecast` bez przestawiania
source stores. Native scripted controls tworzą public wide arrays; to
model observera, nie wykonanie pełnego do_sign lub wniosek o ich membership.

## Pathwise indukcja

Na wspólnym finite prefixie stany są identyczne do pierwszego bad store.
Każdy good cast zachowuje wartość (`narrow_preserves_iff`, RetryCoupling).
Stąd arrays, fault branch, exact stored norm i licznik są identyczne.
Jeśli norm odrzuca, oba wykonują ten sam fresh init i target overwrite,
więc indukcja dotyczy następnej próby. Przy acceptance source encoder
dostaje identyczne s2/cap/comp; length, body i header są identyczne z POST.
W checked ukończonej próbie wide/stored norm również się zgadzają, ale nie
podmieniamy przez to source norm na nie-safe histories.

Poza WholeRegionBad source/checked public outcomes są takie same. Jeśli
inner root nie zwraca, oba mają NONRETURN do tego samego punktu, chyba że
checked już wcześniej zakończył na Bad; taki przypadek jest w WholeRegionBad.
Null tapes nie zamieniamy w zero/timeout. Pierwszy checked guard jest przed
bad cast, a oryginalny source kontynuuje normalnie — nie dodano abortu C.

Dla dowolnego zdarzenia D w rozszerzonej public outcome przestrzeni:
`|Pr(O_source in D)-Pr(O_checked in D)| <= Pr(O_source != O_checked)
<=Pr(WholeRegionBad)`. Supremum daje TV bound. Dla każdej tej samej
deterministycznej projection obu obserwacji (np. mapowanie PRECAST_EXIT do
oddzielnego test-harness failure, lub do ZERO) data processing zachowuje
nierówność. Dodanie fixed nonce40 i przypiętego M0 framingu zachowuje equality
poza Bad. Nie twierdzimy coupling prywatnego allocation layout, timing,
pełnego trace, idealnej lattice Gaussian lub Sign→Verify.

Source nie zwraca PRECAST_EXIT. W szczególności TV nie jest automatycznie
loss realnego M0; dotyczy wyłącznie tej zdefiniowanej pary idealnych gier.
