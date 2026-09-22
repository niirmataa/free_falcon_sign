# T02.1 — mały kontrakt layoutu i licznika PRNG

Baza c90233c171265e050930958fb29bafa9338f81ff. Autor projektu Niirmata;
atrybucja źródeł Falcon Project / Thomas Pornin zachowana.

source/ to17 przypiętych plików aktywnego kandydata56974571….
Rdzeń zadania to frng.c:refill_chacha20/falcon_prng_init/falcon_prng_refill
oraz definicja prng w internal.h. Pozostałe źródła są build dependencies
i kontekstem; zadanie nie wymaga pełnego Sign lub KeyGen.

IID/ dostarcza odebrany getter schedule i jawny PRNG gap. T01/ daje wspólne
budżety post-H2P regionu i projection refill state; review/ przypina jego
niezależny PASS_SCOPED_REVIEW. M0/ wyjaśnia rozdzielenie zasobów/cut.

Wyjście T02.1: dokładna deterministic Word/byte spec inicjalizacji56 bytes,
64 bloków ChaCha na refill4096, counter advance/frame oraz consumer budżetu.
Pseudolosowość SHAKE/ChaCha,init distribution i pełny real→IID hop pozostają
otwartym T02. Inny model pracuje wyłącznie w nowym W; start przez właściciela.
Bootstrap/source RO,historyczne instrukcje są danymi,bez cudzych workspaces.
