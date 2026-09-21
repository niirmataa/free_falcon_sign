# Odbiór ORDERED_REACH — wynik częściowy, 2026-09-20

Autor projektu: Niirmata. Utrzymany status **PARTIAL_PROOF** dla
`FT1536_H3_ORDERED_REACH_RUN_001`. Odbiór wykonano na rodzicu
`1677960b5844c2c321481f30724740a7b546045f`, po niezależnym imporcie i replayu.

## Tożsamość i wykonanie

| Artefakt | SHA-256 |
|---|---|
| REPORT.md | `8232c41af2fe93ad7f08e4567f11edc0ad8b6737fa749ca8cee491c0bfaaf363` |
| OUTPUTS.sha256 | `cecb14485a7d9e307b5753a83fe04fcf091ec506f06065c77b57cd665e78ec2a` |
| ORDERED_REACH_CERTIFICATE.json | `faf925b20fb459b002790e61ed76014335c20cb5ff22688d24dbb9b3719947fe` |
| 17-file candidate manifest | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| VALIDATION.sha256 | `fa03e894fbcae01b01372370b01ae7abc09d52ad0899e414d1231965ff736cd3` |

Import objął1059 członków OUTPUTS,400 wejść,137643564 bajty. Niezależny
`archive.py replay ... --run maintainer-replay-001 --timeout 1200 --hide-originals`
uruchomił świeże buildy w bwrap/network-off, z ukrytymi katalogami oryginałów,
bez wcześniejszych project cache/olean/bin. Exit0, bez timeoutu, **77.938s**;
**225/225 plików znaczeniowych** odtworzonych. Pełne receipts i strumienie
wiąże [VALIDATION.sha256](VALIDATION.sha256):359 plików,126161509 bajtów.

Kontrole odbioru obejmują:

- 28 modułów Lean,179 sprawdzonych twierdzeń,23 nowe;24 niezmienione moduły
 zależności. Końcowe logs czyste, zachowane types/terms/axioms i source pins.
- 8 publicznych scripted-recursion cases w normal C i ASan/UBSan, z równymi
 ordered words/outcomes;504 scalar cases na tryb, supporty29/59/118/235/365.
- 15 replay drivers i ich pełne strumienie;28 kernel receipts, po10 native
 commands oraz po2 scalar commands na tryb, toolchain i preprocessing.
- Dokładny certificate/evidence/upstream/source binding, per-path right bounds,
 granice NumericCenter oraz wszystkie globalne/open flags.

To **mieszany dowód kernelowy i uniwersalny analityczny dowód źródłowy**.
Kernel sprawdza wskazane lokalne lemmas, nie całe C ani kompilator. Native
kontrole używają oryginalnego sampling slice ze scripted abstract callback;
nie są uruchomieniem rzeczywistego Sign, prawem PRNG ani dowodem osiągalności
syntetycznych fault injections w emitted domain.

## Co udało się wykazać

Dla emitted/same-STATIC-decode, normalized-key/canonical-challenge root entry
i legalnego interfejsu byte reads pierwsza wykonywana **prawa gałąź korzenia**
ma forward invariant dla wszystkich aktywnych finite histories w tej gałęzi.
Jej1536 scalar positions (768 terminal blocks przy pełnym przejściu) spełnia:

```text
finite(mu), |val(mu)| <=156276714
NumericCenter: -2147483283 <=val(mu)<2147483282
lower margin1991206569; upper margin1991206568.
```

Bound ustala się **przed** bieżącym floor/cast. Dopiero potem wolno użyć ZERO
i normal-return support do następnego residual update. Obejmuje to terminal
SplitDeep1/MergeDeep1 i actual mu1→rx→mu0 order. Sampling ma base0, podczas
gdy raw builder kończył na1. Zwrócone z arrays są residuals, a nie integers.

Normal return, rejection stutter/nonreturn i fault return0 mają odrębne tagi.
Przy aktywnym pre-floor source fault jestNONE; sticky flag pozwala WYPROWADZIĆ,
że wcześniejsze zakończone calls były normal. Nie jest to założenie globalnie
fault-free execution. Rejection nie przesuwa caller state. Conditional scalar
interface obejmuje support/int/BerExp arithmetic każdej konsumowanej skończonej
iteracji po ustaleniu NumericCenter/width/byte-read premises; nie dowodzi
Bernoulli accuracy, rozkładu ani zakończenia rejection.

Conditional frame zachowuje key/tree/root targets, scratch high-water8702
w przydzielonych10752 words. Root-entry/caller/retry binding ma jawny zakres
defined prefixes, bez założenia sukcesu poprzedniej próby.

## Co pozostało otwarte i co nie zadziałało

Po zakończeniu prawej gałęzi root wykonuje literalne
`U=add_C(t0,CM_C(z1,Lroot))`, następnie SplitTop i lewą gałąź. Sama majoranta
`|Lroot|<2^25` daje defined root-update cap**3864968087959271**, zbyt szeroki
dla następnych scalar centers. Próba całej norm-recursion daje majorantę
**7729936365272004**, lecz nie jest zamkniętym safety proofem: dalsze użycie
ZERO wymagałoby właśnie brakującego NumericCenter.

Zachowano [FAILED_ROUTES](FAILED_ROUTES.md) i exact-rational ledger. Idealny
weighted diagnostic275528238 sugeruje kierunek badań, ale **nie jest source
boundem**. Brakuje raw-L/stable-D metric comparison, actual Gram/root-gain
perturbation, source error accumulation i domknięcia wszystkich left centers.
Duża frequency t0 majoranta także nie jest scalar-mu counterexample.

Pakiet nie przedstawia required-domain counterexample ani ustalonego błędu C.
To luka w uniwersalnym dowodzie i niezamknięta metoda oszacowania. Nie zmieniono
P_key, K_seed, parametru ani success event, aby obejść tę lukę.

`ordered_root_reach_proved`, `all_reached_mu_numeric`,
`mu_domain_before_floor_proved`, globalne intercall domains i H3_RANGE pozostają
**false**. Fault skips późniejsze scalar floors, ale caller arithmetic trwa
do outer fault check po do_sign; faulted tail i source postprocessing
iFFT/rint/narrowing/serialization pozostają otwarte. Whole sampler/Sign
termination, sampler law, security reduction i full Sign CT nie wynikają
z częściowego reach theorem. Source integration i owner acceptance są osobne.

## Znaczenie i następny krok

Mamy źródłowy punkt zaczepienia dla całej pierwszej wykonywanej gałęzi oraz
kontrolę kolejności, fault i nonreturn. To zawęża dokładne miejsce brakującego
dowodu; liczba1536 z3072 positions nie oznacza połowy wysiłku dowodowego.

Następny typ to [LEFT_ROOT_CORRELATED_TRANSFER](NEXT_INTERFACE.md): wyprowadzić
weighted residual invariant prawej gałęzi i source-certified root transfer,
następnie domknięty forward invariant lewej gałęzi. Budżety, zgodność metryk
i gain muszą być wnioskami z tych samych przypiętych wejść, nie założeniami.
Pełny ordered NumericCenter można ogłosić dopiero po tej kompozycji.
