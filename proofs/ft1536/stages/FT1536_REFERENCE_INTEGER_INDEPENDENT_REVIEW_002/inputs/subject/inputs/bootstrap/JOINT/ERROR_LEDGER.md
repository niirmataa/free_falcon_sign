# Ledger — one root IID_BUFFER

| Etap / miara | Actual source instance / wynik |
|---|---|
|Source count / domain|M3072; current mu right≤156276714,left≤937866518; terminal DQ_A2≤849346588|
|Scalar acceptance|A_h≥1/8 (GAUSS); historyczne IID1/256 bez zmian|
|Scalar TV / forward chi2|epsilon2^-36,kappa2^-60,ta sama legalnaPAST i prefix words|
|Exact support-tail|tau z SUPPORT_EXIT.json; table tails,holes,cutoff ujęte raz|
|Local conditioning|(1+chi2(K||G_S))=(1-t)(1+chi2(K||G))|
|Joint forward chi2|(1+2^-60)^3072−1≤3/(2^50−3)<2^-48|
|Joint TV do Q_S/Q_stop|≤2^-25; alternatywa sequential3/2^26 luźniejsza|
|Q_S versus Q_stop|TV=Q_stop(EXIT)≤3072tau<2^-50,osobny export|
|Reverse Q_stop → P|∞ przez positive EXIT|
|Reverse Q_S → P|≤2^811008−1,wyprowadzony ale bardzo luźny|
|POST / common lift|data processing / exact preservation odpowiednio|
|BadPrecast|q pozostaje OPEN; p≤q+min(TV,sqrt(Delta*q*(1-q)))|
|Resources|E[T]≤24576;ghostT≤49152 z complement<2^-1024|
|Real PRNG / whole Sign|OPEN; żadnego computational lossu nie dopisano|

Pełne exact rationals,definitions,directions,scope i dependency hashes w JSON.
Nie dodajemy EXIT drugi raz do forward chi2/TV,nie stosujemy independent marginals,
nie podstawiamy nieudowodnionego Gaussian q i nie wpisujemy eta_pre do M0.
