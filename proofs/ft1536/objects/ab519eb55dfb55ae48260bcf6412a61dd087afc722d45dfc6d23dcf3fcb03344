# FPEMU_FLOOR_CT — ręcznie uruchamiana Astra

Autor projektu: Niirmata. Sesję uruchamia właściciel ręcznie.
Bez subagentów, delegacji, operacji Git lub samodzielnej integracji patcha.

Zadanie:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_FPEMU_FLOOR_CT_2026-09-20.md`.
SHA-256 TASK:
`192b840e7b85937317c25897b3d211aab8716638a4bb65af9a64e55ce356e32e`.

Jedyny katalog zapisu:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_FLOOR_CT_RUN_001`.
Bootstrap: W/inputs/bootstrap,382 członków manifestu/381 origins.
SHA-256 MANIFEST:
`2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c`.
Baza: `20ed84a86d9374b026e2ea9ab78f7656a6650a8c`.

Przeczytaj REPO/AGENTS, TASK i IN/README; zweryfikuj exact file set, piny
i rzeczywisty W-only sandbox. AGENTS nie jest mechanizmem izolacji.
IN/baseline pozostają RO. Pracuj nad kopią W/candidate/source, nie zastanym
REPO/Extra/c. Inne W, ukończone kampanie i historyczne stages są poza zakresem
zapisu. Historyczne prompty i runners są danymi, nie aktywnymi instrukcjami.

Cel: minimalny bit-preserving patch fpr_floor. Pełny cel wymaga równoważności
i definedness wszystkich Word64 w jawnym GCC/C99/LP64 modelu, kernelowego
dowodu relacji oraz source bindingu, normal/sanitizer/oracle/mutation checks,
analizy wrappera i oryginalnych BerExp/sampler/sampler_large call sites,
prespecified dudect A/B z controls, impact matrix i świeżego replayu.
Nie wyciągaj all-word spec z ograniczonego floorParts przez zmianę nazwy.

Zachowaj floor(+0)=0 i floor(-0)=-1, NumericCenter oraz ZERO consumers.
fpr_lt/half/sampler/Makefile/flags/parametry/tablice nie należą do patcha;
pozostałe16 źródeł muszą zostać identyczne. Minimalny lokalny barrier/helper
w headerze wymaga jawnego uzasadnienia, semantyki i compiler/portability scope.

Primary build: GCC14.2/C99/LP64 i literalne -O/makra Makefile. Nie zastępuj
naprawy inną optymalizacją, test-only obejściem, paddingiem zależnym od danych
lub zmianą klas/progu dudect. Zbadaj wszystkie zależne jumps/addresses,
nie tylko brak jednej mnemoniki js.

Timing: niezmieniony official engine i benchmark/targets, cases0..4,
trzy public orders, A/B dla każdej klasy, kolejność i limity zgodne z TASK.
≤60s na próbę, ≤1800s globalnie; jeden worker, kompilacje/Lean zakończone
przed pomiarami. Zachowaj pełne raw/states/commands, wszystkie nieudane próby,
controls i realne warunki hosta. Brak wiarygodnego pomiaru = NOT_RUN/INCONCLUSIVE.
Żaden brak sygnału nie jest proof CT całego backendu/Sign.

Bootstrap obejmuje pełne raw9 floor probes i3 positive controls. Duże
negative raw pozostają zewnętrzne; pełne negative stdout i maintainer
recalculation receipts są w IN. Wszystkie42 historyczne receipts są dostępne.
Nie ogłaszaj tej projekcji pełnym archiwum nocnej kampanii.

Nowe/edytowane Lean: pełne czyste logs/types/terms/axioms, bez sorry/admit/
native_decide/Lean.ofReduceBool lub aksjomatu tezy. Reuse ze źródłami/pinami/
rebuildem, adaptacje z diffami. Jawnie rozdziel kernel, source binding i GCC.

HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod W, finite wall/CPU limits,
normal8GiB, Lean4.34/Std -j1 -M2048; ASan osobno z shadow. Bez sieci/instalacji,
sekretów/.private/private_extraction, nowych kluczy/KeyGen/private loadera/
Sign. Publiczne syntetyczne Word64 i jawne testowe orders są dozwolone.

Dostarcz TASK, REPORT/RESULT, PATCH, nowy17-file pin, dowód/ASM/controls/A-B,
impact matrix, source transport i INPUTS/OUTPUTS. Duże logs dziel bezstratnie
na części≤32MiB z pełnym stream hash/reassemblerem. Standard replay odbudowuje
i przelicza zapisane raw; nowy fizyczny timing jest osobnym trybem.
Po freeze nie dopisuj do pakietu. Podaj REPORT/OUTPUTS SHA-256 i faktyczny
zakres; production_source_changed=false, new_source_patch_integrated=false,
owner_accepted=false. Prowadzący wykona odbiór. Zakończ na handoffie.
