# IID retry composition — zakres tezy

Autor projektu: Niirmata. Zachowano Falcon Project / Thomas Pornin attribution
i licencje przypiętych źródeł. TASK_ID=FT1536_IID_RETRY_COMPOSITION_RUN_001.

Dla każdego JEDNEGO `ReadyRetryEntry` z REGION_ENTRY, dowolnej legalnej entry
PAST i gry `G_retry_IID` z FILTRATION, region source `falcon-sign.c:3327–3421`:

1. Wyprowadza legalność każdej osiąganej root entry, także po bad/norm-rejected
   poprzedniku; nie zakłada legalności wszystkich przyszłych entries.
2. Kończy się prawie na pewno, wykonując od1 do16 init/root calls. Guard17
   poprzedza siedemnasty init. Pierwsza accepted STORED norm prowadzi do
   pojedynczego STATIC encode i exact positive bytes; inaczej return0.
3. Dla `B=WholeRegionBad` obejmującego obie pre-cast vectors we wszystkich
   reached/completed attempts, `Pr(B|entry PAST) <= p_outward E[J|entry PAST]
   <= 16 p_outward <= 2^-80`. Dokładne racjonale i dodatkowy, poprawnie
   uzasadniony conditional-hazard bound są w STOPPED_COMPOSITION.json.
4. Checked-precast counterfactual ma equal-until-bad coupling z source,
   tagged/public-result TV co najwyżej tym boundem, i zachowuje exact bytes
   poza B. PRECAST_EXIT jest dodatkowym proof-only tagiem.
5. Zasoby obejmują initial blocks, getter drops ORAZ porzucone tails.
   Wspólne budżety finite PRNG-hop z RESOURCE_BOUND mają failure <2^-1020.

To mixed universal source/analytical/kernel/exact-rational proof. Formalne
lematy i ich typy są w formal/, audyt w artifacts/formal_audit.json; konkretna
interpretacja C, filtration, conditional integrals, a.s. composition i TV
są dowodami analitycznymi w dokumentach. `fully_kernelized=false`,
`C_compiler_verified=false`. Skończone testy nie zastępują tych argumentów.

Przesłanki, piny i konsumowane upstream wyniki są w REUSED_RESULTS.
Wynik jest wyłącznie dla post-H2P regionu i idealnych refill outputs.
Real PRNG bridge, H2P-prefix termination, whole real Sign, universal Safe16,
reference integer recovery, Sign→Verify, security/CT są osobnymi obowiązkami.
Brak nowego warunku na K_seed[E], p_K, Gate00_C, success event lub Verify.
`new_M0_eta_pre=null`; źródła/parametry/produkcja nie zostały zmienione.
