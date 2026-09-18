# Zachowany source/model binding i nowe połączenia

Badana wersja C i wszystkie16 formalnych modułów PREV są bajtowo identyczne.
Szczegółowy odziedziczony mapping: `inputs/PREV/SOURCE_MODEL_BINDING.md`, hash
`891596976f3b79afff55690a8568fde54786945c9caae73794c823ab1649a42a`.
Receipts i piny: `artifacts/input_audit.json`, `artifacts/source_model_binding.json`.

Nie redefiniowano forwardC, inverseC, pipelineC ani product/remMonomial.
Nowe funkcje peval/blockEval są niezależną specyfikacją i zostały połączone
z modelami pętli twierdzeniami, nie przez zmianę ich definicji.

| C falcon-vrfy.c | Nowe połączenie |
|---|---|
| 1001–1010, quadratic root | root_coefficients → root_block_eval; oba źródłowe stores |
| 1015–1037, binary stages | binary_coefficients + split_layout → binary_block_eval; indukcja middle_eval po forwardSchedule |
| 1042–1061, cubic | cubeF_bind + eval_linear + indeksowany certyfikat1,z,z² → cubic_eval, kolejność3b+j |
| 1185–1243, tomont/point multiply/sub | Odziedziczony Pipeline, teraz podstawiony dowód forward_product |
| 1377–1424, rho(s2) i wywołania pipeline | rho_contract z przesłanką InInt16; canonicalization invariance produktu → L_NTT_rho |

Dla binary h=t/2, b=u1*h+(v−v1), v1=u1*t. split_layout wyprowadza dokładnie
gm[m+u1], adresy v i v+h oraz znak dziecka. h>0 i wszystkie rozmiary wynikają
z przypiętego harmonogramu. Pos<1536, b<768, cubic b<512 i gm index512+b<1024
zachowują dotychczasowe initialization-before-read; nie czyta się ogona tabel.
Konsumowany GEN10 opisuje dynamiczne mq_mkgm3 logn10, nie gałąź statyczną.

Root i eight binary stages utrzymują canonical stany dzięki odziedziczonym
range proofs. Nowe cubic_eval używa tej przesłanki jawnie dla trzech danych.
Complete.pipeline_intermediate_ranges eksportuje canonical zakres H0,H,a0,a1,p,d,
a point_prefix_range/point_read_bound obejmują wszystkie prefiksy helperów
jednoelementowych. Word contracts rozliczają uint32 wrap/low16, uint16 casts
i helper arguments jak wcześniej; źródłowe reprezentacje pozostają te same.

Nowa kontrola C `checks/pipeline.c` bezpośrednio dołącza niezmieniony source
i wywołuje dokładny pipeline. Nie ma instrumentacji ani kopii zmienionego C.
Dwa syntetyczne przypadki obejmują canonical dane oraz int16 granice rho.
Oracle Sage używa niezależnego iloczynu wielomianów modulo Phi.

Kontrole node/reduction używają wykonywalnych formalnych definicji i nowych
checkerów. Oracle wyznacza alpha z zamkniętej formuły625^(3u+1+(u mod2)),
u=rev9(b), zamiast wywoływać badany NTT. Mutacje dotyczą rzeczywistych argumentów
nowego checkera (word/index/sign/cubic slot) i znaku wysokiego remMonomial.

Kernelowe tezy dotyczą przypiętych modeli i są konsumowane razem z jawną
translacją C99/GCC/LP64 i założeniami legalnych buforów. Nie deklaruje się
zweryfikowanego kompilatora C ani szerszego twierdzenia o parserze czy normie.
