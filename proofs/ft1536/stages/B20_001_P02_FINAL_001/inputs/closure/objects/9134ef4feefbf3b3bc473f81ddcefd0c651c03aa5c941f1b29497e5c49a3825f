"""Machine-readable definition of pending law comparisons, never a security proof."""
import hashlib,json
from pathlib import Path
W=Path.cwd()
def inp(path):return dict(path=path,sha256=hashlib.sha256((W/path).read_bytes()).hexdigest())
src=lambda n:inp('source/'+n)
ctx=inp('inputs/context/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md')
mp=inp('inputs/context/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md')
rows=[]
def row(ident,law_from,law_to,direction,metric,status,per,trans,aborts,cost,premises,inputs,history=None,conditioning=None,notes=''):
    rows.append(dict(id=ident,laws=dict(from_law=law_from,to_law=law_to),direction=direction,metric=metric,status=status,
      key_law='one common K_seed[E] draw, never per-Sign reconditioning',
      history_quantifier=history or 'Every emitted (sk,pk), every reachable matching oracle history and required retry/scalar prefix; latent key may be retained in proof history.',
      conditioning=conditioning or 'E_K once at setup; no conditioning on Sign success, good key, distinct nonce or no-abort unless explicitly paid.',
      per_call=per,transcript=trans,abort_cost_owners=aborts,observations='PRE_ABORT / (r,POST_ABORT) / (r,b); no cause, partial buffer or timing',
      computational_cost=cost,premises=[dict(id=p[0],status=p[1],requirement=p[2]) for p in premises],inputs=inputs,notes=notes))
row('FRAMING','M0 typed r40 protocol','r[40]||m / r[40]||b encoding','equality within chosen protocol; NOT insecure variable-rlen CLI -> secure M0','injectivity, deterministic reject',
 'DEFINED_WITH_PROVED_AUXILIARY','zero','zero',['NONCE_LENGTH_REJECT'],'O(|r|+|b|) parsing, no nonce39 library call',
 [('OWNER_R40','DECIDED','exact40 required'),('WRAPPER_IMPLEMENTATION','OPEN_INTEGRATION','deploy/check nonce gate before library')],[inp('formal/Framing.lean'),src('tool.c'),src('falcon.h')],notes='C prototype rejects repartition; not a proof of whole CLI security.')
row('KEY_LAW','one capped source KG_seed execution','K_seed[E]=Law(output | E_K)','Adv_uncond=p_K*Adv_cond','exact conditioning identity',
 'DEFINED_ANALYTIC_IDENTITY','one KeyGen','one factor p_K',['KEYGEN_FAILURE'],'C_K/E_K sampling costs explicit; never Q_s key samplings',
 [('P_K_POSITIVE','PREMISE','conditional law requires p_K>0'),('KEYGEN_ENV','DEFINED','public E and uniform32 bytes on entropy success')],[src('falcon-keygen.c'),src('frng.c'),src('falcon.h'),ctx],notes='No K_seed=K_iid; no KeyGen run or p_K estimate in M0.')
row('ENVIRONMENT','API services under fixed E','same E in compared games','identity only if service/observation schedules are actually shared','environment coupling/refinement',
 'DEFINED_OPEN_PLATFORM_BINDING','service return as E specifies','no hidden deletion or extra epsilon for shared service failures',[],'site/query-indexed services, legal stack and buffers',
 [('E_SHARED','PREMISE','same exogenous public schedule and uniform entropy law'),('OS_BINDING','OPEN','real OS faults/entropy may need separate comparison')],[src('frng.c'),src('falcon-sign.c'),src('falcon-keygen.c')])
row('RNG_ROOT','G0: source private Sign root expander','Groot: root936 replaced by fresh uniform stream','absolute difference of event probabilities','computational PRG advantage',
 'CRYPTO_ASSUMPTION_AND_OPEN_REDUCTION','epsilon_root(32,936;resources)','<=Q_s*epsilon_root with certified hybrid/resources',[],'Q_s distinguishers; auxiliary K_seed secret/public pair distribution and its cost accounted',
 [('ROOT_PRG','CRYPTO_ASSUMPTION','exact private-seeded SHAKE-256 expander'),('ROOT_HYBRID','OPEN','fresh contexts, aborts and shared-key auxiliary input')],[src('falcon-sign.c'),src('shake.c'),inp('formal/Framing.lean')],notes='Nonce uniform320 only after this hop; source seed has256 bits. Public H is a different oracle layer.')
row('RNG_PRNG56','Groot with source Falcon PRNG consumers','G1: budgeted independent scalar random words','absolute difference of event probabilities','computational exact-PRNG56 advantage',
 'CRYPTO_ASSUMPTION_AND_OPEN_REDUCTION','epsilon_PRNG56(ell_j;t_j,w_j,L_j)','sum over at most16*Q_s initializations',[],'ell_j counts produced blocks including discarded buffer suffixes; source is uncapped',
 [('PRNG56','CRYPTO_ASSUMPTION','uniform56-byte initialization of exact source algorithm, key32+IV16+counter8'),('JOINT_RANDOMNESS_HYBRID','OPEN','not a448-bit-key standard ChaCha substitution')],[src('frng.c'),src('internal.h'),src('falcon-sign.c')])
row('ANALYTIC_BUDGET','unbounded source / iid-coins execution','same algorithms with declared analysis work/read caps','event change only on first budget exceedance','coupling/TV bad-event',
 'OPEN','declared per-instance tail bounds','delta_budget (union/first-event partition certified)',['SOURCE_BUDGET_EXCEED'],'finite ell_j and simulator resource definitions required',
 [('TAIL_BUDGET','OPEN','prove read/time tail bounds or a.s. termination as needed')],[src('falcon-sign.c'),src('falcon-keygen.c'),ctx],notes='No cap inserted into source. No time disclosure in the main game.')
row('H3_RANGE','reachable active source scalar state','state satisfying H3 arithmetic domain','source-state invariant / exact refinement','no numeric distance until proved',
 'OPEN_M1','prove floor(mu) range and s+z','no zero bad-event assigned yet',['ARITHMETIC_STUCK'],'all reachable calls/retries, not a finite campaign',
 [('H3_REACHABILITY','OPEN','H3_INTERFACE.md exact type'),('EMITTED_KEY_SUPPORT','REUSED_CONDITIONAL','correct source support, not arbitrary loader keys')],[inp('H3_INTERFACE.md'),src('falcon-sign.c'),src('fpr-emulated.h'),mp])
row('PRECAST_BYTES','G1 source with iid coins','P: observed finite-production reference','|Pr_G1(E)-Pr_P(E)|<=g(Q_s,epsilon_byte)','history-uniform TV / coupling',
 'OPEN_M2_M3','epsilon_byte','g(Q_s,epsilon_byte)=1-(1-epsilon_byte)^Q_s',['SOURCE_FAULT_OR_PRECAST_MISMATCH'],'full FFT/LDL/residual/iFFT/casts + source stopping/serialization cost',
 [('JOINT_PRECAST','OPEN','actual joint W1,W2 law, not marginal summaries'),('BYTE_MAP','OPEN','same observed outputs; never relabel emitted invalid b as source bot'),('FAULT_HANDLING','OPEN','all causes represented once in complete response kernel')],[src('falcon-sign.c'),ctx,mp],notes='H6P no-go for deriving eta_pre from scalar summaries retained; any alternative joint coupling replaces overlapping rows.')
row('H3_LIKELIHOOD','P finite proposal + production acceptance','M finite proposal + exact acceptance','Pr_P(E)<=exp(Q_s*gamma3)*Pr_M(E)','directional D_infinity / likelihood domination',
 'CONDITIONAL_HISTORICAL_INTERFACE','gamma3 nats per Sign query, already16*3072 scalar envelope','exp(Q_s*gamma3)',[],'bounded scalar transcript under separately certified RNG budget',
 [('H3_RANGE','OPEN','M1 premise'),('H4_DSS','CONDITIONAL','exact computed dyadic dss, positive production atoms'),('SOURCE_INSTANTIATION','OPEN','same retry/fault/byte histories')],[ctx,mp,src('falcon-sign.c')],notes='Historical gamma3<4.704837e-9 is not installed as an unconditional M0 number.')
row('H1R','M finite-exact transcript with bot','Q infinite-exact transcript with bot','absolute event-probability difference','direct TV, not reverse Renyi',
 'CONDITIONAL_HISTORICAL_INTERFACE','epsilon1 for entire at-most16 Sign query','g(Q_s,epsilon1)',[],'shared stopping and matched dataflow',
 [('ACCEPTANCE_FLOOR','CONDITIONAL','9/20 where required'),('RARE_MISSING_ATOMS','CONDITIONAL','retain finite/infinite support distinctions'),('FULL_SOURCE_LIFT','OPEN','do not multiply16 twice')],[ctx,mp],notes='Historical epsilon1<2^-104.3821 is conditional. Image chi-square lemma does not transfer to this pair of laws.')
row('FULL_GEOMETRY','Q infinite-exact with computed parameters','G16 ideal coset Gaussian at sigma768','absolute event-probability difference','TV / joint coupling',
 'OPEN_M2_M3','xi_geom','g(Q_s,xi_geom)',[],'full vector law and all FPEMU errors, not just scalar outputs',
 [('GEOMETRY','OPEN','computed dss not automatically ideal geometry'),('SECRET_ERASURE','OPEN','ideal response kernel depends only on h,c with stated byte map')],[ctx,mp,src('falcon-sign.c')])
row('CAPACITY','defined source norm-accepted signed16 pair','STATIC encoding with caller4096','exact length/refinement; no capacity failure','deterministic equality on stated domain',
 'PROVED_M0_PINNED_COUNT_MODEL','payload<=3160; data<=3159','encoding-space bad mass0 AFTER norm acceptance',['ENCODING_SPACE'],'<=25267 encoder bits, variable output; no nonce included',
 [('SIGNED16_NORM','PROVED_REUSED','source is_short iff Q<B'),('COUNTER_BINDING','PROVED_M0_WITH_C_TRANSLATION','EncoderCount mirrors byte writes and cap-1'),('LEGAL_BUFFER','DOMAIN','4096 allocated bytes, STATIC/profile fixed')],[inp('formal/CapacityMath.lean'),inp('formal/EncoderCount.lean'),src('falcon-enc.c'),src('falcon-sign.c')],notes='Does not close eta_pre, source Sign correctness or H6P. Synthetic3156 is not a sampled signature.')
row('NORM_RETRY','G16 ideal16 attempts retaining norm exhaustion','Gacc ideal accepted kernel (empty-support bot retained)','event difference bounded by ideal terminal nonempty-coset exhaustion','TV/coupling',
 'OPEN_M3','a_abort','delta_retry<=Q_s*a_abort, or sharper certified lift',['IDEAL_NORM_EXHAUSTION'],'up to16 ideal attempts vs conditional sampling cost',
 [('IDEAL_ACCEPTANCE','OPEN','uniform h,c/history premise, empty cosets explicit')],[ctx,mp],notes='Source norm rejections already retained in earlier kernels. Historical2^-383.8 is conditional, not a free M0 constant.')
row('ROM_FRESHNESS','Gacc with actual ideal-coin nonce/table interactions','R_fresh with explicit common collision/prequery gates','absolute event-probability difference','TV/coupling bad-event',
 'OPEN_M6','fresh r uniform only in post-RNG game','delta_fresh: disjoint first nonce collision, else prequery event',['NONCE_COLLISION_OR_PREQUERY'],'H table M<=Q_H+Q_s+1, all queried message bytes retained',
 [('UNIFORM_NONCE','OPEN_RNG_HOP','not implied statistically by32-byte source seed'),('FRAMING','PROVED_M0','fixed40 injectivity'),('FRESHNESS_COUPLING','OPEN','conditioning/gates shared and quantified')],[inp('formal/Framing.lean'),ctx,mp],notes='For Q_s<2^320, candidate delta_nonce<=Q_s(Q_s-1)/2^321, delta_pre<=Q_H*sum_i 1/(2^320-i); clip1. These events are not charged again in programming.')
row('IMAGE_R5T','accepted-image law P_h^B','uniform U_Rq','chi2(P_h^B||U), not the reverse','chi-square image moment',
 'CONDITIONAL_RESULT_NEEDS_NEW_CONSISTENT_PACKAGE_M4','e uniform over successful h','input e for M5, not itself a transcript theorem',[],'no sampler implementation or resource bound follows from naming D^B',
 [('R5T_INTERFACES','CONDITIONAL','reported T_h<2^-138, E<2^-106 under universal premises'),('R5T_FREEZE','OPEN','old OUTPUTS279dce... mismatches four files; create a new package'),('POPULATION','OPEN_BINDING','fixed-h T2C3 not substituted for all-h accepted image')],[mp,ctx],history='Every h in public pushforward of successful K_seed; no fixed-key substitution.',notes='T2C3 fixed h*: E<2^-89. T5 all successful: pure/untruncated theta<2^-40, theorem-specific delta_key0; neither is the missing accepted-image population theorem.')
row('IMAGE_KERNEL','R_fresh: U(c) K_h,c with full observation wrapper','S_fresh: P_h^B(c) K_h,c reverse sampling','chi2(S_i(.|tau)||R_i(.|tau))<=e; bound p=R(win) using r=S(win)','chi-square in S||R; nonlinear success transfer',
 'OPEN_M5','e per actual image step','Delta=(1+e)^n-1, n<=Q_s; p<=Phi_Delta(r)',[],'at mostQ_s changed kernels, other transitions common',
 [('COMMON_INITIAL_LAW','REQUIRED','same K_seed and E'),('ABSOLUTE_CONTINUITY','REQUIRED','S_i<<R_i on all required histories'),('FULL_COMMON_KERNEL','OPEN','same nonce, bot, serialization, fresh gates, hidden key and public postprocessing'),('M4_IMAGE','OPEN','certified uniform e')],[mp,ctx],
 conditioning='All relevant histories of the joint latent-key transcript; conditioning on successful signatures, no collisions or fresh points cannot be silently added.',
 notes='Phi_Delta(r)=[2r+Delta+sqrt(Delta^2+4Delta*r(1-r))]/[2(1+Delta)]. No reverse D2/Hölder shortcut; no transfer to H1R.')
row('PUBLIC_SAMPLER','S_fresh ideal reverse signer','S_hat computational public sampler + same byte map','absolute event-probability difference','TV including declared sampler abort',
 'OPEN_M6','epsilon_pub with specified work/memory/output semantics','delta_pub=g(Q_s,epsilon_pub) when history-uniform; time part included or disjoint',['PUBLIC_SAMPLER_ERROR_OR_TIME'],'Q_s*C_pub, W_pub and explicit budget certificate',
 [('PUBLIC_D_B','OPEN','construct bounded sampler D^B without sk'),('ERROR_TIME_PARTITION','OPEN','do not count same timeout both epsilon_pub and delta_time')],[mp,ctx])
row('ROM_PROGRAMMING','S_hat public reverse oracle','challenge-based classical ROM simulator','same transcript on certified fresh/budget-good paths; residual delta_sim','game coupling / exact lazy sampling',
 'OPEN_M6','no free per-call equality','delta_sim excludes freshness and public-sampler events already owned',['SIMULATOR_RESIDUAL_FAILURE'],'C_table(M,L_key), W_table, Q_H+1 challenge target reads',
 [('PROGRAMMING','OPEN','full adaptive transcript with abort queries entered in SeenSign'),('TARGET_ASSIGNMENT','OPEN','nonprogrammed queries + fresh final query use <=Q_H+1 independent targets')],[mp,ctx,inp('formal/Framing.lean')],notes='Classical, no forking/extra target-guessing factor. QROM is separate.')
row('L_V_EXTRACTION','accepted M0 candidate forgery','witness for same indexed target c','deterministic implication','zero extraction loss on valid frame/canonical challenge',
 'PROVED_REUSED_FOR_PINNED_CANDIDATE','0','0',[],'C_ext(N,|b*|), includes O(|b*|) decoder; no4096 adversary cap',
 [('L_V','PROVED_REUSED','full_L_V_source pinned3fe78f8d...'),('CHALLENGE_BINDING','OPEN_M6','returned target index is the same H(r*||m*)')],[inp('inputs/PREV/REPORT.md'),inp('inputs/PREV/CLAIM.md'),inp('inputs/PREV/VerifyBytes.lean')],history='All canonical h,c and legal accepted b; no Sign-distribution premise.')
row('MT_ISIS','single-key indexed targets from K_seed[E]','epsilon_MT[E](Q_H+1;t_B,w_B,L_B)','upper bound on solver success','computational hardness function',
 'CRYPTO_ASSUMPTION','not a signing-query bound','one key, Q_H+1 targets, no additional guessing multiplier',[],'RESOURCE_MODEL exact units and simulator overhead certificates',
 [('MT_HARDNESS','CRYPTO_ASSUMPTION','unconstrained integer witness relation Q<B, no centered restriction'),('RESOURCES','OPEN_M6','actual reduction within declared t_B,w_B,L_B')],[ctx,mp],notes='Estimator and zero-target floor are diagnostics, not proofs or owner security-level choices.')
row('PUBLIC_XOF_H2P','real public SHAKE-sc/H2P interface','direct-output ROM main game','separate future computational/simulation relation','XOF indifferentiability/RO simulation with rejection transcript',
 'OPEN_OUTSIDE_FIRST_ROM_TARGET','source accepts16-bit words<55299 and reduces modq','epsilon_XOF plus explicit time/read budget only after a proved hop',['PUBLIC_H2P_BUDGET'],'uncapped rejection and bit-level queries including rejected words',
 [('PUBLIC_XOF_MODEL','OPEN','public bit-output adversary interface must be specified'),('DOMAIN_COUPLING','OPEN','same SHAKE code also used privately; no free domain-separation theorem')],[src('falcon-enc.c'),src('shake.c'),ctx])
row('FINAL_COMPOSITION','G0 real-ROM conditional EUF-CMA','MT solver bound through certified ordered rows','ordered monotone transforms, not flat epsilon sum','typed conditional composition target',
 'OPEN_M7','none','see target signature/recurrence; no achieved RHS',[],'resource translation and all premises must be certified',
 [('HOP_CERTIFICATES','OPEN','all pending source/game/kernel bindings'),('RESOURCE_TRANSLATION','OPEN','bound solver and primitive distinguishers'),('NO_DOUBLE_COUNT','CONTRACT_INVARIANT','abort ownership unique')],[mp,ctx])
target=dict(name='M0ReductionTarget',status='TARGET_TYPE_NOT_PROVED',
 parameters=['E:declared legal public service schedule','beta=(Q_s,Q_H,t,w,L):Nat^5','A:classical adversary in A(beta)',
             'p_K>0','C:component certificates M1-M6 listed below; FINAL_COMPOSITION is the desired output, never a premise','primitive advantage functions with declared resources','epsilon_MT[E] with declared relation/resources'],
 component_certificate_ids=['H3_RANGE','PRECAST_BYTES','H3_LIKELIHOOD','H1R','FULL_GEOMETRY','NORM_RETRY','ROM_FRESHNESS','IMAGE_R5T','IMAGE_KERNEL','PUBLIC_SAMPLER','ROM_PROGRAMMING','ANALYTIC_BUDGET','RNG_ROOT','RNG_PRNG56'],
 parameter_domains=dict(gamma3='nonnegative real',e='nonnegative real',n='natural <=Q_s',
   per_call_errors='epsilon_byte,epsilon1,xi_geom in[0,1]',event_errors='delta_budget,delta_fresh,delta_retry,delta_pub,delta_sim in[0,1]',
   primitive_bounds='resource-indexed functions with values in[0,1]',MT_bound='epsilon_MT[E](T;t_B,w_B,L_B) in[0,1]',
   resource_translators='Nat^5 x component budgets -> (t_B,w_B,L_B) in Nat^3'),
 conclusion='exists B in MT-ISIS_seed,rel^E(1,Q_H+1) with resources translated by C and Adv_cond(G0,A)<=ComposeOrdered(C,beta,epsilon_MT,primitive bounds); Adv_uncond=p_K*Adv_cond.',
 compose_recurrence=[
   'u10 = epsilon_MT[E](Q_H+1;t_B,w_B,L_B)',
   'u9 = clip(u10 + delta_sim)',
   'u8 = clip(u9 + delta_pub)',
   'u7 = Phi_Delta(u8), Delta=(1+e)^n-1, n<=Q_s',
   'u6 = clip(u7 + delta_fresh)',
   'u5 = clip(u6 + delta_retry)',
   'u4 = clip(u5 + g(Q_s,xi_geom))',
   'u3 = clip(u4 + g(Q_s,epsilon1))',
   'u2 = clip(exp(Q_s*gamma3)*u3)',
   'u1 = clip(u2 + g(Q_s,epsilon_byte))',
   'u0 = clip(u1 + epsilon_rng + delta_budget)'],
 caveat='A prospective certificate interface ONLY. Current package does not prove that FT1536 laws satisfy these inequalities. Moving any cost across exp/Phi requires a new certified row/order.',
 definitions=dict(clip='min(1,max(0,x))',g='1-(1-x)^n for x in[0,1]',
   Phi_Delta='[2r+Delta+sqrt(Delta^2+4*Delta*r*(1-r))]/[2*(1+Delta)]',
   epsilon_rng='certified root plus exact-PRNG56 game hybrid, fixed key law',
   delta_fresh='first nonce collision, else prequery: event partition, not an extra post-image copy',
   delta_pub='includes sampler cap abort; separate delta_pub_time only for disjoint unowned event'))
ledger=dict(schema='FT1536_M0_HOP_LEDGER_V1',contract_id='FT1536-M0-r40-static4096-parametric-v1',rows=rows,target=target,
 statuses_are_distinct=True,security_reduction_proved=False,H3_started=False,
 image_contract=dict(reference='R_uniform',reverse='S_reverse',divergence_numerator='S',divergence_denominator='R',
   desired_probability='R(win)',supplied_probability='S(win)',shared_full_history_kernels_required=True,
   common_initial_key_law=True,Delta='(1+e)^n-1',n_upper_bound='Q_s',
   transform='[2r+Delta+sqrt(Delta^2+4*Delta*r*(1-r))]/[2*(1+Delta)]'),
 past_R5T=dict(status='CONDITIONAL_ANALYSIS_INCONSISTENT_OLD_FREEZE',old_OUTPUTS_sha256='279dce6690f9f2d9edbe2f2f625f44d8b783fc4311131ea5e41bca4fbad6d74d',action='new M4 package; do not repair history in place'))
with (W/'HOP_LEDGER.json').open('x') as f:json.dump(ledger,f,indent=2);f.write('\n')
md=['# M0 — ledger porównań i przyszły typ redukcji','',
'Ten plik definiuje interfejsy. OPEN i CRYPTO_ASSUMPTION nie są dowodami; M0 nie instancjuje całej redukcji.',
'Wspólny klucz K_seed[E] losuje się raz. Pełne maszynowe pola, piny i przesłanki: HOP_LEDGER.json.','']
for r in rows:
    md += ['## '+r['id']+' — '+r['status'],'',
      '**Prawa:** '+r['laws']['from_law']+' → '+r['laws']['to_law']+'.',
      '**Kierunek/metryka:** '+r['direction']+'; '+r['metric']+'.',
      '**Klucz/historia:** '+r['key_law']+'; '+r['history_quantifier'],
      '**Conditioning:** '+r['conditioning'],
      '**Koszt:** per call '+r['per_call']+'; transcript '+r['transcript']+'.',
      '**Abort ownership:** '+(', '.join(r['abort_cost_owners']) or 'brak nowego składnika')+'.',
      '**Obliczenia:** '+r['computational_cost']+'.',
      '**Otwarte/dziedziczone przesłanki:** '+ '; '.join(p['id']+' ['+p['status']+']: '+p['requirement'] for p in r['premises'])+'.',
      r['notes'],'']
md += ['## Typ parametrycznego celu (nie gotowy bound schematu)','',target['conclusion'],'',
 'C ma dostarczyć wymienione component certificates M1-M6 dla par praw, kierunków, conditioning i zasobów. FINAL_COMPOSITION jest wnioskiem docelowym, nigdy wejściowym założeniem. Dopiero przy tych komponentach dopuszczalny jest poniższy ordered envelope:',
 '```text']+target['compose_recurrence']+['```','',target['caveat'],'',
 'Image row ma kierunek chi2(S||R), p=R(win), r=S(win). Prerequisite to wspólne pełne kernels po historii, także bot/bytes/fresh gates. Zwykły Hölder dla tego D2 ogranicza r przez p, a nie potrzebne p przez r.',
 'Dla r=0 interfejs daje Phi_Delta(0)=Delta/(1+Delta). Budżet Delta ogranicza siłę tej TECHNIKI, nie dowodzi ataku lub bariery konstrukcji.',
 'δ_pub jest wewnątrz Phi, δ_fresh i δ_retry poza nią, wszystkie za directional source multiplier. ε_byte i RNG/budget są przed tym mnożnikiem. To kolejność kandydackiej ścieżki certyfikacji, nie dowiedziony source bound.',
 'Nie wolno mechanicznie dodawać alternatywnego H6P coupling do pokrywających się ε_byte/ξ_geom. Każdy abort ID ma jednego właściciela.',
 'Nie instalowano wartości e=2^-106, ε1<2^-104.3821, γ3<4.704837e-9 lub δ_retry≈2^-383.8 jako obecnych liczb schematu.',
 'Historyczny przykład52-bitowej poprawy i konservatywny TV ledger nie są granicą bezpieczeństwa konstrukcji ani wynikiem M0. QROM pozostaje osobnym etapem.','']
(W/'HOP_LEDGER.md').write_text('\n\n'.join(md))
print(json.dumps(dict(rows=len(rows),target_status=target['status'],security_reduction_proved=False),indent=2))
