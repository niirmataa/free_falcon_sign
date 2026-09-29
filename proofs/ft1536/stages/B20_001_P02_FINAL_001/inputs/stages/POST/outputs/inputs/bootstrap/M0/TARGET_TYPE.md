# Dokładny typ przyszłego twierdzenia M7

To deklaracja celu, nie twierdzenie M0. W szczególności nie zakłada się
M7 ani żądanego globalnego wniosku jako części wejściowego certyfikatu.

```
M0ReductionTarget :
 forall E : LegalPublicServiceSchedule,
 forall beta=(Q_s,Q_H,t,w,L) : Nat^5,
 forall C : ComponentCertificates_M1_to_M6(E,PROFILE,beta),
 forall primitive_bounds : ResourceIndexedPrimitiveBounds,
 forall epsilon_MT : MT_ISIS_seed_rel_Bound(E),
 p_K(E)>0 -> PrimitiveAssumptions(primitive_bounds) -> MT_Assumption(epsilon_MT) ->
 forall A : ClassicalAdversary(beta),
 exists B : MT_Adversary(E,keys=1,targets=Q_H+1),
   Resources(B) <= (t_B,w_B,L_B)(beta,C)
   and Adv_cond(G0[E],A) <= ComposeOrdered(beta,C,primitive_bounds,epsilon_MT).
```

ComponentCertificates jest rekordem konkretnych źródłowych/rozkładowych
przesłanek o jawnych parach gier, NIE dowodem Adv(G0)<=żądany RHS:

- H3 reachability i defined arithmetic; exact source/iid randomness hybrids;
- source-to-P observed-byte coupling, directional P→M likelihood, M→Q H1R TV;
- pełny Q→ideal-G16 geometry/pre-cast byte interface i norm/retry comparison;
- spójny M4 image theorem pointwise po successful h;
- wspólne początkowe prawo i pełne warunkowe R/S kernels, S<<R i M5 transfer;
- bounded public sampler, classical ROM programming/freshness, challenge
  assignment i wszystkie rzeczywiste koszty/budżety;
- rozłączność event ownership oraz poprawna kolejność porównań.

Przesłanki extractor L_V, framing i pojemności są już wskazanymi wynikami,
a nie dodatkowym nieznanym source-correctness argumentem. Budżety analityczne
nie są capami implementacji. H3 w tej wersji komponentu ma zapewnić required
range/definedness; zastąpienie go nowym bad-event hopem wymaga jawnego rozszerzenia
rekordu i jego miejsca w recurrence, nie darmowego wyzerowania STUCK.

Dziedziny: gamma3>=0, e>=0, n∈Nat z n<=Q_s; epsilon_byte,epsilon1,xi_geom
oraz delta_budget/fresh/retry/pub/sim w[0,1]. Primitive/MT bounds to funkcje
zasobów o wartościach w[0,1]. Czas,pamięć,dane reduktora są Nat w jednostkach
RESOURCE_MODEL.md. Wartość n i wszystkie parametry mają wynikać z C,
nie z dowolnego wyboru małych liczb.

ComposeOrdered jest dokładnie ordered recurrence w HOP_LEDGER.json.target,
z clip/g/Phi podanymi tam jawnie. Public-sampler/simulator errors są wewnątrz
Phi; freshness/retry po zewnętrznej stronie Phi; H1R/geometry wewnątrz
directional exp multiplier; source-byte/RNG/budget przed tym mnożnikiem.
Zmiana kolejności wymaga innych certyfikatów porównań.

Nie stwierdzono, że aktualny FT1536 spełnia otwarte komponenty, ani że
ComposeOrdered ma dziś znany nietrywialny mały wynik. Brak komponentu oznacza
brak instancji M7, nie założenie jego małości. Dla eksperymentu z pojedynczym
nieudanym KeyGen przegrywającym: Adv_uncond=p_K*Adv_cond, raz dla wspólnego klucza.
Publiczny bit-XOF/H2P i QROM są osobnymi późniejszymi twierdzeniami.
