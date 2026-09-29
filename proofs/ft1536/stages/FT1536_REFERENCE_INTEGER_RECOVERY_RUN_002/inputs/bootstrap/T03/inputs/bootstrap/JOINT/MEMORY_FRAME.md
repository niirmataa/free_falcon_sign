# Source frame i read-time ownership

Konsumujemy ORDERED/MEMORY_FRAME i LEFT forward domains dla required root
allocations: normalized sk24576 words,tree=sk+6144,root tree18432 words;
tmp10752 z t0[0,1536),t1[1536,3072),z0[3072,4608),z1[4608,6144),scratch od6144.
Legal typed/aligned/lifetime interface gwarantuje disjoint context,immutable
basis/tree/targets i actual mutable scratch. Nie jest to theorem dla arbitrary
aliasing/malformed pointers lub hardware corruption.

Inner scratchS(0)=0,S(k)=2^k+S(k−1)=2^(k+1)−2. Cubic9 używa512+S(8)=1022,
root1536+1022=2558, więc high-water8702<10752. Pointers formed w allocation;
terminal nie dereferencjuje przyszłego scratch. Global caller writes podczas
sampling tylkotmp[3072,8702) i scalar context; readonlyinputs oraz tail zachowane.

Binary: right split inputs w z1,output y0/y1 w scratch; po merge z1 live aż do
final left subtraction. Left child nie zmieniaz1 lubL. Cubic zachowujez2 przez
child1/0; z1 po subtractP21 jest snapshotem dla child0. Copy1765 ratuje target
przed split overwrite. Root identycznie zachowujez1/Lroot przez left child.
Terminal snapshot sigma,old0,mu1 pobrany przed callbackiem; r0/r1 zapisane po
obu normal returns. Nie utożsamiamy sampled ints z residual words.

W scalar rejection loop zmieniają się locals oraz PRNGbuffer/ptr. Callback
nie ma pointer do tree/targets; typed alias exclusion jest premise. Faultflag
NONE wynika forward z aktualnych domains. Samo zwrócone0 nie byłoby proofem
normal return; tutaj source positive witness i guard exclusion określają tag.

Getters konsumują nowe distinct cells, little endian,discards zgodne z
internal.h. Stub test refill materializuje public blocks; stan opaque/state256
pozostaje canary, bez PRNGinit. Fullsc jest porównany po original sampler i jego
observer copy na KAŻDYM6148 kontrolnym callbacku. Neither execution calls real
seeded refill. To deterministic native binding, nie empiryczny IID proof.

POST overwrites/pointers/partial codec writes mają odebrane frames. Root
native arrays i POST sk/targets/buffer canaries są sprawdzone normal/ASan/UBSan.
LSan nie deklarowany. Wszystkie public native inputs mają exact transducer
preflight PRZED C; EXIT integers nigdy nie przechodzą przez source conversions.
