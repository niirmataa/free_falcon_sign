# M0 — ledger porównań i przyszły typ redukcji



Ten plik definiuje interfejsy. OPEN i CRYPTO_ASSUMPTION nie są dowodami; M0 nie instancjuje całej redukcji.

Wspólny klucz K_seed[E] losuje się raz. Pełne maszynowe pola, piny i przesłanki: HOP_LEDGER.json.



## FRAMING — DEFINED_WITH_PROVED_AUXILIARY



**Prawa:** M0 typed r40 protocol → r[40]||m / r[40]||b encoding.

**Kierunek/metryka:** equality within chosen protocol; NOT insecure variable-rlen CLI -> secure M0; injectivity, deterministic reject.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call zero; transcript zero.

**Abort ownership:** NONCE_LENGTH_REJECT.

**Obliczenia:** O(|r|+|b|) parsing, no nonce39 library call.

**Otwarte/dziedziczone przesłanki:** OWNER_R40 [DECIDED]: exact40 required; WRAPPER_IMPLEMENTATION [OPEN_INTEGRATION]: deploy/check nonce gate before library.

C prototype rejects repartition; not a proof of whole CLI security.



## KEY_LAW — DEFINED_ANALYTIC_IDENTITY



**Prawa:** one capped source KG_seed execution → K_seed[E]=Law(output | E_K).

**Kierunek/metryka:** Adv_uncond=p_K*Adv_cond; exact conditioning identity.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call one KeyGen; transcript one factor p_K.

**Abort ownership:** KEYGEN_FAILURE.

**Obliczenia:** C_K/E_K sampling costs explicit; never Q_s key samplings.

**Otwarte/dziedziczone przesłanki:** P_K_POSITIVE [PREMISE]: conditional law requires p_K>0; KEYGEN_ENV [DEFINED]: public E and uniform32 bytes on entropy success.

No K_seed=K_iid; no KeyGen run or p_K estimate in M0.



## ENVIRONMENT — DEFINED_OPEN_PLATFORM_BINDING



**Prawa:** API services under fixed E → same E in compared games.

**Kierunek/metryka:** identity only if service/observation schedules are actually shared; environment coupling/refinement.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call service return as E specifies; transcript no hidden deletion or extra epsilon for shared service failures.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** site/query-indexed services, legal stack and buffers.

**Otwarte/dziedziczone przesłanki:** E_SHARED [PREMISE]: same exogenous public schedule and uniform entropy law; OS_BINDING [OPEN]: real OS faults/entropy may need separate comparison.





## RNG_ROOT — CRYPTO_ASSUMPTION_AND_OPEN_REDUCTION



**Prawa:** G0: source private Sign root expander → Groot: root936 replaced by fresh uniform stream.

**Kierunek/metryka:** absolute difference of event probabilities; computational PRG advantage.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call epsilon_root(32,936;resources); transcript <=Q_s*epsilon_root with certified hybrid/resources.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** Q_s distinguishers; auxiliary K_seed secret/public pair distribution and its cost accounted.

**Otwarte/dziedziczone przesłanki:** ROOT_PRG [CRYPTO_ASSUMPTION]: exact private-seeded SHAKE-256 expander; ROOT_HYBRID [OPEN]: fresh contexts, aborts and shared-key auxiliary input.

Nonce uniform320 only after this hop; source seed has256 bits. Public H is a different oracle layer.



## RNG_PRNG56 — CRYPTO_ASSUMPTION_AND_OPEN_REDUCTION



**Prawa:** Groot with source Falcon PRNG consumers → G1: budgeted independent scalar random words.

**Kierunek/metryka:** absolute difference of event probabilities; computational exact-PRNG56 advantage.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call epsilon_PRNG56(ell_j;t_j,w_j,L_j); transcript sum over at most16*Q_s initializations.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** ell_j counts produced blocks including discarded buffer suffixes; source is uncapped.

**Otwarte/dziedziczone przesłanki:** PRNG56 [CRYPTO_ASSUMPTION]: uniform56-byte initialization of exact source algorithm, key32+IV16+counter8; JOINT_RANDOMNESS_HYBRID [OPEN]: not a448-bit-key standard ChaCha substitution.





## ANALYTIC_BUDGET — OPEN



**Prawa:** unbounded source / iid-coins execution → same algorithms with declared analysis work/read caps.

**Kierunek/metryka:** event change only on first budget exceedance; coupling/TV bad-event.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call declared per-instance tail bounds; transcript delta_budget (union/first-event partition certified).

**Abort ownership:** SOURCE_BUDGET_EXCEED.

**Obliczenia:** finite ell_j and simulator resource definitions required.

**Otwarte/dziedziczone przesłanki:** TAIL_BUDGET [OPEN]: prove read/time tail bounds or a.s. termination as needed.

No cap inserted into source. No time disclosure in the main game.



## H3_RANGE — OPEN_M1



**Prawa:** reachable active source scalar state → state satisfying H3 arithmetic domain.

**Kierunek/metryka:** source-state invariant / exact refinement; no numeric distance until proved.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call prove floor(mu) range and s+z; transcript no zero bad-event assigned yet.

**Abort ownership:** ARITHMETIC_STUCK.

**Obliczenia:** all reachable calls/retries, not a finite campaign.

**Otwarte/dziedziczone przesłanki:** H3_REACHABILITY [OPEN]: H3_INTERFACE.md exact type; EMITTED_KEY_SUPPORT [REUSED_CONDITIONAL]: correct source support, not arbitrary loader keys.





## PRECAST_BYTES — OPEN_M2_M3



**Prawa:** G1 source with iid coins → P: observed finite-production reference.

**Kierunek/metryka:** |Pr_G1(E)-Pr_P(E)|<=g(Q_s,epsilon_byte); history-uniform TV / coupling.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call epsilon_byte; transcript g(Q_s,epsilon_byte)=1-(1-epsilon_byte)^Q_s.

**Abort ownership:** SOURCE_FAULT_OR_PRECAST_MISMATCH.

**Obliczenia:** full FFT/LDL/residual/iFFT/casts + source stopping/serialization cost.

**Otwarte/dziedziczone przesłanki:** JOINT_PRECAST [OPEN]: actual joint W1,W2 law, not marginal summaries; BYTE_MAP [OPEN]: same observed outputs; never relabel emitted invalid b as source bot; FAULT_HANDLING [OPEN]: all causes represented once in complete response kernel.

H6P no-go for deriving eta_pre from scalar summaries retained; any alternative joint coupling replaces overlapping rows.



## H3_LIKELIHOOD — CONDITIONAL_HISTORICAL_INTERFACE



**Prawa:** P finite proposal + production acceptance → M finite proposal + exact acceptance.

**Kierunek/metryka:** Pr_P(E)<=exp(Q_s*gamma3)*Pr_M(E); directional D_infinity / likelihood domination.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call gamma3 nats per Sign query, already16*3072 scalar envelope; transcript exp(Q_s*gamma3).

**Abort ownership:** brak nowego składnika.

**Obliczenia:** bounded scalar transcript under separately certified RNG budget.

**Otwarte/dziedziczone przesłanki:** H3_RANGE [OPEN]: M1 premise; H4_DSS [CONDITIONAL]: exact computed dyadic dss, positive production atoms; SOURCE_INSTANTIATION [OPEN]: same retry/fault/byte histories.

Historical gamma3<4.704837e-9 is not installed as an unconditional M0 number.



## H1R — CONDITIONAL_HISTORICAL_INTERFACE



**Prawa:** M finite-exact transcript with bot → Q infinite-exact transcript with bot.

**Kierunek/metryka:** absolute event-probability difference; direct TV, not reverse Renyi.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call epsilon1 for entire at-most16 Sign query; transcript g(Q_s,epsilon1).

**Abort ownership:** brak nowego składnika.

**Obliczenia:** shared stopping and matched dataflow.

**Otwarte/dziedziczone przesłanki:** ACCEPTANCE_FLOOR [CONDITIONAL]: 9/20 where required; RARE_MISSING_ATOMS [CONDITIONAL]: retain finite/infinite support distinctions; FULL_SOURCE_LIFT [OPEN]: do not multiply16 twice.

Historical epsilon1<2^-104.3821 is conditional. Image chi-square lemma does not transfer to this pair of laws.



## FULL_GEOMETRY — OPEN_M2_M3



**Prawa:** Q infinite-exact with computed parameters → G16 ideal coset Gaussian at sigma768.

**Kierunek/metryka:** absolute event-probability difference; TV / joint coupling.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call xi_geom; transcript g(Q_s,xi_geom).

**Abort ownership:** brak nowego składnika.

**Obliczenia:** full vector law and all FPEMU errors, not just scalar outputs.

**Otwarte/dziedziczone przesłanki:** GEOMETRY [OPEN]: computed dss not automatically ideal geometry; SECRET_ERASURE [OPEN]: ideal response kernel depends only on h,c with stated byte map.





## CAPACITY — PROVED_M0_PINNED_COUNT_MODEL



**Prawa:** defined source norm-accepted signed16 pair → STATIC encoding with caller4096.

**Kierunek/metryka:** exact length/refinement; no capacity failure; deterministic equality on stated domain.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call payload<=3160; data<=3159; transcript encoding-space bad mass0 AFTER norm acceptance.

**Abort ownership:** ENCODING_SPACE.

**Obliczenia:** <=25267 encoder bits, variable output; no nonce included.

**Otwarte/dziedziczone przesłanki:** SIGNED16_NORM [PROVED_REUSED]: source is_short iff Q<B; COUNTER_BINDING [PROVED_M0_WITH_C_TRANSLATION]: EncoderCount mirrors byte writes and cap-1; LEGAL_BUFFER [DOMAIN]: 4096 allocated bytes, STATIC/profile fixed.

Does not close eta_pre, source Sign correctness or H6P. Synthetic3156 is not a sampled signature.



## NORM_RETRY — OPEN_M3



**Prawa:** G16 ideal16 attempts retaining norm exhaustion → Gacc ideal accepted kernel (empty-support bot retained).

**Kierunek/metryka:** event difference bounded by ideal terminal nonempty-coset exhaustion; TV/coupling.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call a_abort; transcript delta_retry<=Q_s*a_abort, or sharper certified lift.

**Abort ownership:** IDEAL_NORM_EXHAUSTION.

**Obliczenia:** up to16 ideal attempts vs conditional sampling cost.

**Otwarte/dziedziczone przesłanki:** IDEAL_ACCEPTANCE [OPEN]: uniform h,c/history premise, empty cosets explicit.

Source norm rejections already retained in earlier kernels. Historical2^-383.8 is conditional, not a free M0 constant.



## ROM_FRESHNESS — OPEN_M6



**Prawa:** Gacc with actual ideal-coin nonce/table interactions → R_fresh with explicit common collision/prequery gates.

**Kierunek/metryka:** absolute event-probability difference; TV/coupling bad-event.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call fresh r uniform only in post-RNG game; transcript delta_fresh: disjoint first nonce collision, else prequery event.

**Abort ownership:** NONCE_COLLISION_OR_PREQUERY.

**Obliczenia:** H table M<=Q_H+Q_s+1, all queried message bytes retained.

**Otwarte/dziedziczone przesłanki:** UNIFORM_NONCE [OPEN_RNG_HOP]: not implied statistically by32-byte source seed; FRAMING [PROVED_M0]: fixed40 injectivity; FRESHNESS_COUPLING [OPEN]: conditioning/gates shared and quantified.

For Q_s<2^320, candidate delta_nonce<=Q_s(Q_s-1)/2^321, delta_pre<=Q_H*sum_i 1/(2^320-i); clip1. These events are not charged again in programming.



## IMAGE_R5T — CONDITIONAL_RESULT_NEEDS_NEW_CONSISTENT_PACKAGE_M4



**Prawa:** accepted-image law P_h^B → uniform U_Rq.

**Kierunek/metryka:** chi2(P_h^B||U), not the reverse; chi-square image moment.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every h in public pushforward of successful K_seed; no fixed-key substitution.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call e uniform over successful h; transcript input e for M5, not itself a transcript theorem.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** no sampler implementation or resource bound follows from naming D^B.

**Otwarte/dziedziczone przesłanki:** R5T_INTERFACES [CONDITIONAL]: reported T_h<2^-138, E<2^-106 under universal premises; R5T_FREEZE [OPEN]: old OUTPUTS279dce... mismatches four files; create a new package; POPULATION [OPEN_BINDING]: fixed-h T2C3 not substituted for all-h accepted image.

T2C3 fixed h*: E<2^-89. T5 all successful: pure/untruncated theta<2^-40, theorem-specific delta_key0; neither is the missing accepted-image population theorem.



## IMAGE_KERNEL — OPEN_M5



**Prawa:** R_fresh: U(c) K_h,c with full observation wrapper → S_fresh: P_h^B(c) K_h,c reverse sampling.

**Kierunek/metryka:** chi2(S_i(.|tau)||R_i(.|tau))<=e; bound p=R(win) using r=S(win); chi-square in S||R; nonlinear success transfer.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** All relevant histories of the joint latent-key transcript; conditioning on successful signatures, no collisions or fresh points cannot be silently added.

**Koszt:** per call e per actual image step; transcript Delta=(1+e)^n-1, n<=Q_s; p<=Phi_Delta(r).

**Abort ownership:** brak nowego składnika.

**Obliczenia:** at mostQ_s changed kernels, other transitions common.

**Otwarte/dziedziczone przesłanki:** COMMON_INITIAL_LAW [REQUIRED]: same K_seed and E; ABSOLUTE_CONTINUITY [REQUIRED]: S_i<<R_i on all required histories; FULL_COMMON_KERNEL [OPEN]: same nonce, bot, serialization, fresh gates, hidden key and public postprocessing; M4_IMAGE [OPEN]: certified uniform e.

Phi_Delta(r)=[2r+Delta+sqrt(Delta^2+4Delta*r(1-r))]/[2(1+Delta)]. No reverse D2/Hölder shortcut; no transfer to H1R.



## PUBLIC_SAMPLER — OPEN_M6



**Prawa:** S_fresh ideal reverse signer → S_hat computational public sampler + same byte map.

**Kierunek/metryka:** absolute event-probability difference; TV including declared sampler abort.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call epsilon_pub with specified work/memory/output semantics; transcript delta_pub=g(Q_s,epsilon_pub) when history-uniform; time part included or disjoint.

**Abort ownership:** PUBLIC_SAMPLER_ERROR_OR_TIME.

**Obliczenia:** Q_s*C_pub, W_pub and explicit budget certificate.

**Otwarte/dziedziczone przesłanki:** PUBLIC_D_B [OPEN]: construct bounded sampler D^B without sk; ERROR_TIME_PARTITION [OPEN]: do not count same timeout both epsilon_pub and delta_time.





## ROM_PROGRAMMING — OPEN_M6



**Prawa:** S_hat public reverse oracle → challenge-based classical ROM simulator.

**Kierunek/metryka:** same transcript on certified fresh/budget-good paths; residual delta_sim; game coupling / exact lazy sampling.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call no free per-call equality; transcript delta_sim excludes freshness and public-sampler events already owned.

**Abort ownership:** SIMULATOR_RESIDUAL_FAILURE.

**Obliczenia:** C_table(M,L_key), W_table, Q_H+1 challenge target reads.

**Otwarte/dziedziczone przesłanki:** PROGRAMMING [OPEN]: full adaptive transcript with abort queries entered in SeenSign; TARGET_ASSIGNMENT [OPEN]: nonprogrammed queries + fresh final query use <=Q_H+1 independent targets.

Classical, no forking/extra target-guessing factor. QROM is separate.



## L_V_EXTRACTION — PROVED_REUSED_FOR_PINNED_CANDIDATE



**Prawa:** accepted M0 candidate forgery → witness for same indexed target c.

**Kierunek/metryka:** deterministic implication; zero extraction loss on valid frame/canonical challenge.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; All canonical h,c and legal accepted b; no Sign-distribution premise.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call 0; transcript 0.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** C_ext(N,|b*|), includes O(|b*|) decoder; no4096 adversary cap.

**Otwarte/dziedziczone przesłanki:** L_V [PROVED_REUSED]: full_L_V_source pinned3fe78f8d...; CHALLENGE_BINDING [OPEN_M6]: returned target index is the same H(r*||m*).





## MT_ISIS — CRYPTO_ASSUMPTION



**Prawa:** single-key indexed targets from K_seed[E] → epsilon_MT[E](Q_H+1;t_B,w_B,L_B).

**Kierunek/metryka:** upper bound on solver success; computational hardness function.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call not a signing-query bound; transcript one key, Q_H+1 targets, no additional guessing multiplier.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** RESOURCE_MODEL exact units and simulator overhead certificates.

**Otwarte/dziedziczone przesłanki:** MT_HARDNESS [CRYPTO_ASSUMPTION]: unconstrained integer witness relation Q<B, no centered restriction; RESOURCES [OPEN_M6]: actual reduction within declared t_B,w_B,L_B.

Estimator and zero-target floor are diagnostics, not proofs or owner security-level choices.



## PUBLIC_XOF_H2P — OPEN_OUTSIDE_FIRST_ROM_TARGET



**Prawa:** real public SHAKE-sc/H2P interface → direct-output ROM main game.

**Kierunek/metryka:** separate future computational/simulation relation; XOF indifferentiability/RO simulation with rejection transcript.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call source accepts16-bit words<55299 and reduces modq; transcript epsilon_XOF plus explicit time/read budget only after a proved hop.

**Abort ownership:** PUBLIC_H2P_BUDGET.

**Obliczenia:** uncapped rejection and bit-level queries including rejected words.

**Otwarte/dziedziczone przesłanki:** PUBLIC_XOF_MODEL [OPEN]: public bit-output adversary interface must be specified; DOMAIN_COUPLING [OPEN]: same SHAKE code also used privately; no free domain-separation theorem.





## FINAL_COMPOSITION — OPEN_M7



**Prawa:** G0 real-ROM conditional EUF-CMA → MT solver bound through certified ordered rows.

**Kierunek/metryka:** ordered monotone transforms, not flat epsilon sum; typed conditional composition target.

**Klucz/historia:** one common K_seed[E] draw, never per-Sign reconditioning; Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.

**Conditioning:** E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.

**Koszt:** per call none; transcript see target signature/recurrence; no achieved RHS.

**Abort ownership:** brak nowego składnika.

**Obliczenia:** resource translation and all premises must be certified.

**Otwarte/dziedziczone przesłanki:** HOP_CERTIFICATES [OPEN]: all pending source/game/kernel bindings; RESOURCE_TRANSLATION [OPEN]: bound solver and primitive distinguishers; NO_DOUBLE_COUNT [CONTRACT_INVARIANT]: abort ownership unique.





## Typ parametrycznego celu (nie gotowy bound schematu)



exists B in MT-ISIS_seed,rel^E(1,Q_H+1) with resources translated by C and Adv_cond(G0,A)<=ComposeOrdered(C,beta,epsilon_MT,primitive bounds); Adv_uncond=p_K*Adv_cond.



C ma dostarczyć wymienione component certificates M1-M6 dla par praw, kierunków, conditioning i zasobów. FINAL_COMPOSITION jest wnioskiem docelowym, nigdy wejściowym założeniem. Dopiero przy tych komponentach dopuszczalny jest poniższy ordered envelope:

```text

u10 = epsilon_MT[E](Q_H+1;t_B,w_B,L_B)

u9 = clip(u10 + delta_sim)

u8 = clip(u9 + delta_pub)

u7 = Phi_Delta(u8), Delta=(1+e)^n-1, n<=Q_s

u6 = clip(u7 + delta_fresh)

u5 = clip(u6 + delta_retry)

u4 = clip(u5 + g(Q_s,xi_geom))

u3 = clip(u4 + g(Q_s,epsilon1))

u2 = clip(exp(Q_s*gamma3)*u3)

u1 = clip(u2 + g(Q_s,epsilon_byte))

u0 = clip(u1 + epsilon_rng + delta_budget)

```



A prospective certificate interface ONLY. Current package does not prove that FT1536 laws satisfy these inequalities. Moving any cost across exp/Phi requires a new certified row/order.



Image row ma kierunek chi2(S||R), p=R(win), r=S(win). Prerequisite to wspólne pełne kernels po historii, także bot/bytes/fresh gates. Zwykły Hölder dla tego D2 ogranicza r przez p, a nie potrzebne p przez r.

Dla r=0 interfejs daje Phi_Delta(0)=Delta/(1+Delta). Budżet Delta ogranicza siłę tej TECHNIKI, nie dowodzi ataku lub bariery konstrukcji.

δ_pub jest wewnątrz Phi, δ_fresh i δ_retry poza nią, wszystkie za directional source multiplier. ε_byte i RNG/budget są przed tym mnożnikiem. To kolejność kandydackiej ścieżki certyfikacji, nie dowiedziony source bound.

Nie wolno mechanicznie dodawać alternatywnego H6P coupling do pokrywających się ε_byte/ξ_geom. Każdy abort ID ma jednego właściciela.

Nie instalowano wartości e=2^-106, ε1<2^-104.3821, γ3<4.704837e-9 lub δ_retry≈2^-383.8 jako obecnych liczb schematu.

Historyczny przykład52-bitowej poprawy i konservatywny TV ledger nie są granicą bezpieczeństwa konstrukcji ani wynikiem M0. QROM pozostaje osobnym etapem.

