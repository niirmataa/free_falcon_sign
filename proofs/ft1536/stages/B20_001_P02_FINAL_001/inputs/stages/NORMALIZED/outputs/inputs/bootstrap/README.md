# Wejścia H3_STABLE_NORMALIZATION — 2026-09-20

Baza:a53d7231795fb5c7317bc836baaf0ccd3ec2652f, odebrany RAW_ASSEMBLY.
Źródła: archived FLOOR_CT candidate17-file pin56974571…; source/ jest
dokładną kopią, a nie zastanym Extra/c. RAW/ daje raw-prefix certificate,
pełne source/memory composition i leaf map. ROOT/NODE2/ZERO dostarczają
kontrakty konsumowanych primitives oraz emitted/FFT binding.

review/NEXT_SCOPE.md jawnie rozdziela raw P_key od stable leaf range gate.
Nowe zadanie ma wyprowadzić akceptację rzeczywistego stable certificate
z już zdefiniowanego Emitted KeyGen i bitowego matching, bez zmiany P_key
lub nowego warunkowania K_seed. Silniejszy all-P_key gate claim ma osobny status.

legacy/H4 jest historyczną projekcją: exact gate endpoints i source layout
są użytecznymi danymi, lecz końcowy argument zakłada correctly-rounded
binary64 sqrt/div i zawiera fpr-double endpoint replay. Nie jest gotowym
whole-domain proof aktualnego FPEMU. Skonsumuj go wyłącznie po rozliczeniu
domen/pinów i nowym source sqrt/div/scaling bridge.

AUDIT/ dokumentuje wcześniejsze primitive-domain/coverage findings. FLOOR/
przypina zmianę floor; nie jest dowodem całego backendu. Wszystkie projekcje
zachowują oryginalne OUTPUTS i podstawy. Skrypty są historycznymi danymi,
nie aktywnymi instrukcjami. ORIGINS i MANIFEST wiążą dokładne publiczne bytes.

Worker startuje ręcznie, tylko W writable. Source/bootstrap RO. Bez KeyGen,
realnego private-key API/Sign, nowych kluczy lub sekretów. Publiczne stable
helper/normalizer slices i synthetic arrays są dozwolone zgodnie z TASK.
Timing/dudect należy do osobnej nocnej pracy; ten pakiet nie uruchamia testu.
