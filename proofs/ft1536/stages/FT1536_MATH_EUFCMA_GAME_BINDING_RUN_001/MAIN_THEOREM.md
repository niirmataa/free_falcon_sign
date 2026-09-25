# MAIN_THEOREM — warunkowa redukcja ordinary EUF-CMA → MT-ISIS (E0)

Wersja robocza części matematycznej do późniejszego paperu. Przedmiot:
Sigma_math = E0 / coefficient-valued finite-box G16 / klasyczny direct-output
ROM (N=1536, q=18433, X^1536−X^768+1, B=2093922385, strict Q<B, cap16,
jednorazowy Emit, sól 320-bitowa). Oznaczenia wg MODEL poprzednika.

## 1. Twierdzenie (docelowy typ główny)

**Warunek.** Niech `beta = (Q_H, Q_s, ...)` będzie budżetem, `muKey` —
znormalizowanym jednorazowym prawem klucza (jawnym marginałem `muH`),
`A` — klasyczny przeciwnik mieszczący się w beta (`AdversaryResourceCertificate`),
`S` — publiczny kod samplera z **lokalnym certyfikatem pełnego prawa
wspólnego** dla każdego wywołania w świeżym punkcie

```
AC(J_S, P)  i  second(J_S, P) ≤ 1+e,   e ≥ 0,
J_S = S.run(h, pubState, m, r)∗(monety S),   P = U_Rq(c) × signBody(h,c)(o),
```

oraz z lokalnym certyfikatem kosztu `LocalPublicSamplerCostCertificate S`.
Niech `B := reduce(A, S)` będzie programem z §3.

**Teza.**

```
AdvEUF(Sigma_math, muKey, A)
  ≤ min(1, eps_coll(beta) + Phi((1+e)^Q_s − 1, AdvMT(muH muKey, Q_H+1, B))),
eps_coll(beta) = min(1, (Q_s·Q_H + Q_s·(Q_s−1)/2) / 2^320),
Phi(D,b) = (2b + D + sqrt(D² + 4Db(1−b))) / (2(1+D)).
```

`AdvMT(muH, T, B)` = prawdopodobieństwo, że program B, uruchomiony na
`h ∼ muH` i jednostajnej liście `targets : Fin (Q_H+1) → Rq`, zwraca parę
`(j, wit)` z `j < Q_H+1` i `Relation.ShortPreimage h (targets j) wit`
(możliwe powtórne/zerowe cele dozwolone). Strata konfliktów jest **poza Phi**;
kierunek porównań: `J_sim ‖ P_honest_stopped`.

## 2. Dowód na papierze

**(i) Front-end i jedna tabela.** Każda nazwa bajtowa jest dokładnie jednym
`NameKind` (`GameNames.nameKind_bijection`), ramka 40-bajtowa jest bijekcją
nonce (`GameByte.nonceBytes_*`), więc równość nazw bajtowych = równość par
(`tableAddr_injective`, `paint_tableAddr`). Sign query jest atomowy: m jest
ustalone przed solą, SeenSign aktualizuje się przed każdym rozgałęzieniem
(`GameMach.sign_atomic`, `step_sq_seen`).

**(ii) Maszyny różnią się tylko gałęzią konfliktu i jądrem Sign.**
Kroki H/submit/tabela/final są tym samym kodem w `real|stopped|sim`
(`GameMach.step`); zatem w modelu `Hist`-transkryptów ich kądry są **równe**,
więc `second = 1` dokładnie (`PaidSteps.second_self`, `second_of_eq`).
STOP jest wewnętrzny i absorbujący (`stopped_absorbing`).

**(iii) Kroki płatne = wywołania Sign (≤ Q_s).** Dla świeżych nazwy Sign
jądro porównawcze to `P = U(c) × signBody(h,c)` a jądro symulatora to `J_S`;
lokalny certyfikat daje AC i `second(J_S,P) ≤ 1+e`. Dla nazw nieświeżych
(konflikt) gry `stopped`/`sim` kończą się — obsługa niżej w (v). Liczba
kroków płatnych ≤ Q_s (budżet; maszyna liczy `sq`).
**Paid-step counter lemma** (`PaidSteps.paid_counter_chi2`,
`paid_counter_le`) — przez indukcję ze złożenia `Divergence.joint_bound`:
iloczyn drugich momentów ma ≤Q_s czynników `1+e`, czynniki wspólnych kroków
są dokładnie równe 1, niezależnie od liczby wszystkich kroków maszyny
(wcześniejsze zakończenie = padding stanem absorbującym):

```
second(Law_SIM_trace, Law_EUF_stopped_trace) ≤ (1+e)^Q_s.
```

To jest wymagana postać z zadania; nie podstawiamy n=Q_s do
`constant_adaptive_chi2`. Dla Q_s=0: brak straty, `(1+e)^0−1 = 0`,
`Phi 0 b = b` (`PaidSteps.zero_paid_boundary`, `EventTransfer.phi_zero_delta`).

**(iv) Transfer zdarzeń.** Kierunek `J_sim ‖ P_honest_stopped` + dziedziczony
`EventTransfer.event_quadratic/phi_bound/phi_mono` daje dla zdarzenia
`Win ∧ ¬Bad` (→ `extracts` implikuje MT):

```
Pr_stopped[Win] ≤ min(1, Pr_stopped[Bad] + Phi((1+e)^Q_s − 1, Pr_sim[MT]))
```

(`PaidSteps.paid_event_bound`, `paid_trace_bound` — kernelowo; to samo
rozwinięcie co dziedziczone `finite_trace_bound`, z wykładnikiem Q_s).

**(v) Konflikt nonce.** Przed i-tym Sign tabela ma ≤ Q_H+i nazw (≤Q_H wpisów
H + i wpisów Sign; `signStep_used`, `signStep_table`, `used_le_of_step`).
Świeży sól daje ryzyko ≤ (Q_H+i)/2^320: rama `r ↦ tableAddr (signName r msg)`
jest iniektywna (`sign_frame_injective`) i `fresh_nonce_conflict`
z realnym rozmiarem tabeli (`sign_conflict_risk`). Średnia po historii
(`adaptive_average`), unia (`event_union_bound`) i dokładna suma
(`collision_sum`) dają przez `accumulated_conflicts`:

```
Pr_stopped[Bad] ≤ eps_coll = min(1, (Q_s·Q_H + Q_s(Q_s−1)/2)/2^320).
```

Sprzężenie EUF_real ↔ EUF_stopped do pierwszego konfliktu: obie maszyny mają
identyczne przejścia przy braku konfliktu nazwy Sign, więc to samo prawo
transkryptów na `¬Bad`; przez `remove_bad_bound`
`AdvEUF_real ≤ eps_coll + Pr_stopped[Win]`.

**(vi) Ekstrakcja i MT.** W SIM końcowa świeża nazwa czyta `targets[used]`
z `used < Q_H+1` (≤Q_H odczytów H + 1 finalny). `Good`/`Unique` tabeli
(dziedziczone `ROM.reachable_invariants`) + `final_hash_index` +
`Reduction.indexed_extraction` dają dla przyjętego fałszerstwa z fresh m*
indeks `j < Q_H+1` i `ShortPreimage h (targets j) (extract h c s*)` —
dokładnie zdarzenie wyjścia B (§3), bez czynnika zgadywania indeksu.

**(vii) Koniec dowodu.** Wstaw (iii)–(vi) do (iv), zastosuj `hardness_substitution`
(monotoniczność Phi po b) z hipotezą trudności MT-ISIS
`AdvMT(muH, Q_H+1, B) ≤ ε_MT`. □

## 3. Program reduktora `B := reduce(A, S)`

B (maszyna `GameMach.step` w trybie `sim`) ma publiczne wejście
`h ∼ muH`, `targets : Fin (Q_H+1) → Rq`, taśmę monet A i S: prowadzi A,
odpowiada H z `targets[used]` (leniwie), na Sign woła `S.run(h, pubState,
m, r, coins)` i programuje `(r,m) ↦ c`; przy konflikcie nazwy Sign kończy
bez wygranej; na końcu waliduje `verdict` i zwraca `(j, wit)` z
`wit = Relation.extract h c (sigVec s*)` oraz `j` indeksu końcowego wpisu.
Sekret sk nie jest wywoływany; `signBody` jest semantyką wyroczni, nie kodem B.

## 4. Dokładny status kernelizacji tego twierdzenia

Kernelowo (pełne dowody, czysty log, bez sorry — audyt `#print axioms`):
(i) w całości; (ii) w całości; (iii) paid-step counter lemma dla abstrakcyjnych
kernelów `Hist`; (iv) transfer zdarzeń i postać `min 1 (eps + Phi(...))`;
(v) ryzyko per-call, postać `eps_coll` i sprzężenie przez `remove_bad_bound`;
(vi) świeżość (`verdict_fresh`) i dziedziczona ekstrakcja indeksowa.

## 4b. Stan kernelizacji po domknięciu typów wiążących (doprecyzowanie)

Trzy typy wiążące są **zamknięte kernelowo** (moduły `Mixture`, `Lazy`,
`GameLaw`; audyt 234 eksportów bez sorry/warningów):

1. **`one_key_lift`** — `Mixture.mixture_event_eq` (prawo jednorazowego
   eksperymentu = dokładna średnia `muKey`), `mixture_event_le` (jednolity
   bound per-klucz unosi się bez założeń o p_K; przypadek p_K=0 to literalna
   wartość `mixture_good_bound`), `latent_secret_event(_muH)` — latent sk nie
   wpływa na grę, mieszanina = `muH`-marginał (`SigmaMath.muH`).
2. **`lazy_sampling_refinement`** — `Lazy.seqTargets` (iterowane losowania =
   leniwa wyrocznia), `seqTargets_snoc` (rekursja mas), **`lazy_independence`**
   (wartość w następnym slocie jest jednostajna i niezależna od całego
   prefixu odczytanego — dokładne „względem przeszłości, od której zależy
   następna operacja"), `seqTargets_eq_uniform` (refinement do wejściowego
   wektora — te same prawa), `card_vec`/`extEquiv`.
3. **`game_kernel_identification`** — jądra kroków wyprowadzone z logiki
   `step`: `second_map_inj`/`ac_map` (iniektywny pushforward zachowuje
   second/AC), `sign_miss_reply_bound` (płatny krok = dokładnie certyfikowana
   para `(c,o)` — skąd jawne `c` w alfabecie odpowiedzi), `sign_hit_shared`
   (stopped/sim dzielą `pure .halt` przy konflikcie), `hKernel`/`finKernel`
   (kroki wspólne), `advance_correct` (publiczny reply odtwarza stan — tabela
   jest publiczna), oraz składanie `game_kernel_identification` /
   `conditional_shape` do `second ≤ (1+e)^Q_s` i `min 1 (eps + Phi(...))`.

**Pozostała luka wiążąca (PARTIAL_PROOF)**: `adversary_fold_paid_flag_binding` —
formalny fold `stateAt/opAt` dla konkretnego przeciwnika `A`, który
przypina flagę `paid` do zapytań Sign A i licznik ≤Q_s do certyfikatu budżetu
A (mechaniczna indukcja; wszystkie składniki: `advance_correct`, flagi,
`PaidSteps.countPaid`, są już kernelowe). Osobna oś: bit-cost (Etap E,
`RESOURCE_BOUND.md` — `OPEN_TYPED_MACHINE_BINDING`).

To nadal **nie jest bezpieczeństwo rzeczywistego FT1536** (brak bridge do
M0/C/PRNG/H2P, brak małych e, brak instancji samplera).
