# Literalny stopped scheduler i a.s. return

Source spans są odtwarzane byte-for-byte przez scripts/binding.py.
Wszystkie adresy linii odnoszą się do przypiętego source/falcon-sign.c.

1. Counter3328 ma uint32 value0. Guard3332 najpierw zwiększa go o1.
   Values1..16 przechodzą,17 zwraca0 PRZED deklarowanym init/root. Nie ma wrap.
2. W fixed ternary branch3355 source init3356 prosi o type0→ChaCha20.
   Następnie3357 zapisuje faultNONE,3358/3359 ustawia sampler_large/context.
   Init nie ma możliwego type-error w tym profilu; ignorowany return value
   nie staje się nową failure branch gry.
3. do_sign3372 wykonuje deterministyczny target prefix i root1897. Legalność
   każdego entry i brak fault są forward consequences z REENTRY_AND_FRAME.
   Root może nie wrócić na null tapes; nie jest wtedy liczony jako return0.
4. Defined suffix1902–1934 daje stored int16 arrays. Fault3374 jest sprawdzany
   przed norm3388. W required domain fault pozostaje NONE na każdym finite
   prefixie, z LEFT/IID/JOINT, a nie dlatego że późniejszy test go odrzucił.
5. Exact stored A2 norm Q z POST: `Q(narrow16(w1),narrow16(w2))<2093922385`.
   Równość z boundem odrzuca. Bez Safe16 nie podstawia się wide norm.
6. Rejection wraca do guard następnej próby. Pierwsze acceptance3402–3403
   kończy pętlę. Encoder3412 wykonuje się raz. Jego failure3414–3418 zwraca0,
   nie wraca do do_sign. Header3420 jest zapisywany dopiero przy sukcesie.

Nieosiągnięta próba nie ma source sample. J=sum_j 1_Rj należy do[1,16]
prawie na pewno. Rozkład J zależy od całej source historii; nie jest tutaj
geometryczny, nie podano acceptance-rate assumption. Norm może odrzucić16
razy. Koniec po16 rejections nie wymaga dodatniego prawdopodobieństwa norm
acceptance. W required STATIC4096 domain accepted norm zapewnia codec success
przez POST/M0 capacity3160; extended cap64/fault stubs służą tylko kontroli
rzeczywistych branch positions.

## Dowód zakończenia regionu

Init wykonuje skończone56-byte SHAKE squeeze. W shake.c582–637, przy legalnym
rate72 i dptr<=rate, ewentualna finite permutation zeruje dptr, po czym
clen=min(rate-dptr,len)>0. Len maleje, więc squeeze kończy się i zachowuje
legalny state. Refill ma64 finite iterations (state projection w FILTRATION).
Target/POST/norm/codec mają wcześniej odebrane deterministic defined domains
i finite bounds; nie zawierają nowego rejection loop.

Dla każdego osiągniętego legalnego entry JOINT daje conditional root
nonreturn probability0. Re-entry proof zapewnia ten kontrakt przed call
także po wcześniejszym Bad. Tower: `Pr(R_j AND root_j nonreturn)=0`.
Skończona unia j=1..16 ma measure0. Poza nią każdy reached root kończy się,
a source control graph wykonuje najwyżej16 takich calls i finite suffix/
codec. Stąd a.s. source region return. To nie all-tapes termination;
na exceptional inner-rejection tape obserwacją pozostaje NONRETURN.

Lean RetryState sprawdza integer counter/guard i invariant induction;
konkretne PC, finite SHAKE oraz measure-zero instantiation są source/
analytical częścią dowodu. Instrumented tests nie są dowodem totalności C.
