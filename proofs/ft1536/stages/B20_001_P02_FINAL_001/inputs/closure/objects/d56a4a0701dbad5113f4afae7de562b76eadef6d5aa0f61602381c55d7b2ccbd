"""Freeze an explicit protocol contract; this is not a source patch or security proof."""
import hashlib,json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
flags=json.loads((W/'artifacts/compiler_flags.json').read_text())
profile=dict(schema='FT1536_M0_PROFILE_V1',contract_id='FT1536-M0-r40-static4096-parametric-v1',author='Niirmata',
 core=dict(source_manifest_sha256=sha('inputs/source_hashes.sha256'),verifier_sha256=sha('source/falcon-vrfy.c'),
   source_files={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((W/'source').iterdir()) if p.is_file()},
   Makefile_flags=flags['argv'],backend='FPEMU / fpr-emulated.h',platform='GCC14.2.0/C99/Linux x86_64 LP64',
   word_bits=dict(char=8,int=32,unsigned=32,int16=16,uint16=16,long=64,size_t=64,int64=64),
   signed_narrowing='GCC two-complement low-bit convention; signed overflow is not declared wrapping',
   N=1536,q=18433,Phi='X^1536-X^768+1',sigma=768,B=2093922385,logn=10,ternary=1,
   Q0='sum(i=0..767,a_i^2+a_i*a_(i+768)+a_(i+768)^2)',Q='Q0(s1)+Q0(s2)',strict_norm=True),
 protocol=dict(honest_compression='FALCON_COMP_STATIC',verify_compressions=['NONE','STATIC'],
   sig_capacity=4096,includes_payload_header=True,nonce_bytes=40,nonce_separate=True,variable_payload=True,
   transport='r[40] || b, datagram/record boundary supplies total length; no padding to capacity',
   verify_nonce_gate='rlen==40 before library start/Verify',adversary_payload_cap=None,
   API_length_limit='each presented object length fits size_t64 and memory/lifecycle are legal',
   source_KeyGen_attempt_cap=3000000,source_Sign_attempt_cap=16,inner_rejection_cap=None,
   fresh_sign_context_per_query=True,external_seed_or_nonce_access=False),
 game=dict(kind='classical ordinary EUF-CMA',key_count=1,key_law='K_seed[E] = Law(one complete capped KG_seed call | E_K)',
   conditioning_event='E_K: finite successful allocation/entropy/KeyGen plus both byte encodings',p_K='Pr_E[E_K] > 0 for conditional game',
   entropy='fresh independent U({0,1}^256) conditional on successful32-byte entropy service; actual deterministic expansion',
   environment='E: fixed public site/query-indexed allocation/entropy failure schedule; E0=all services succeed; GAME.md',
   ROM='H:Bytes*->R_q, independent uniform canonical value per fresh byte input',hash_input='r||m',
   freshness='message not among ALL submitted Sign queries, including aborts',time_observed=False,
   outputs=['PRE_ABORT','(r,POST_ABORT)','(r,b)'],partial_buffer_observed=False,internal_failure_reason_observed=False),
 randomness=dict(root='SHAKE-256: capacity512',fresh_sign_seed_bytes=32,parent_bytes_max=936,
   parent_formula='40 + 16*56',attempt_initializations_max=16,prng='exact Falcon PRNG_CHACHA20, default type0->1',
   initialization_bytes=56,chacha_key_bytes=32,IV_bytes=16,counter_bytes=8,
   IV_counter_mapping='state[14],state[15] XOR64-bit counter; source IV offsets40..47 (last8 of16)',
   primitive_games='private-seeded root expander and exact PRNG56 initializer/consumer, not a448-bit ChaCha key',
   produced_PRNG_bytes_cap=None,logical_draws_per_attempt='up to3072 scalar invocations; rejection draws unbounded'),
 resources=dict(parameters=['Q_s','Q_H','t','w','L'],domains='nonnegative integers; bit-step work, bits memory, bytes data',
   concrete_security_level_selected=False,MT_keys=1,MT_targets='Q_H+1',target_guessing_extra_factor=False),
 capacity=dict(status='PROVED_BOUND_AND_PINNED_C_COUNT_MODEL',payload_bound=3160,data_bound=3159,witness_payload=3156,
   theorem='FT1536M0.STATIC_FITS_4096',scope='post-cast signed16 pair with actual source norm acceptance; excludes nonce; not optimality',
   space_abort_after_norm='zero under legal4096 buffer and fixed STATIC/profile; other aborts retained'),
 historical_cli=dict(source='source/tool.c',sig_buffer=2049,external_nonce_length='variable',implements_M0=False),
 status=dict(M0='DEFINED',security_reduction_proved=False,H3_proved=False,source_integrated=False,
   protocol_wrapper_integrated=False,owner_accepted=False,owner_decisions_preserved=True,
   full_L_V_reused=True,full_L_V_source_sha256=sha('source/falcon-vrfy.c')))
with (W/'PROFILE.json').open('x') as f:json.dump(profile,f,indent=2);f.write('\n')
spans=[('build','Makefile',30,40),('codec','falcon-enc.c',289,379),('norm','falcon-enc.c',597,666),('B','internal.h',158,163),
 ('kg_new_sizes','falcon-keygen.c',5147,5245),('kg_entropy','falcon-keygen.c',5248,5287),('kg_ternary','falcon-keygen.c',4753,4781),
 ('kg_call','falcon-keygen.c',7782,8187),('sign_context_entropy','falcon-sign.c',3073,3146),('sign_loader','falcon-sign.c',3150,3277),
 ('sign_casts','falcon-sign.c',1917,1934),('sign_call','falcon-sign.c',3281,3422),('H3_future_entry','falcon-sign.c',2841,2972),
 ('fpr_floor','fpr-emulated.h',98,133),('prng','frng.c',189,324),('prng_consumers','internal.h',810,865),
 ('verify','falcon-vrfy.c',1355,1517),('H2P','falcon-enc.c',562,593),('old_CLI','tool.c',255,411)]
rows=[]
for ident,name,a,b in spans:
    data=(W/'source'/name).read_bytes();sl=b''.join(data.splitlines(keepends=True)[a-1:b]);dest='inputs/slices/'+ident+'.txt'
    (W/dest).parent.mkdir(exist_ok=True);(W/dest).write_bytes(sl)
    rows.append(dict(id=ident,source='source/'+name,source_sha256=hashlib.sha256(data).hexdigest(),lines=[a,b],slice=dest,slice_sha256=hashlib.sha256(sl).hexdigest()))
(W/'artifacts/source_binding.json').write_text(json.dumps(dict(spans=rows,profile_sha256=sha('PROFILE.json'),no_source_modification=True,
    note='These are source facts and a new call/protocol contract. No KeyGen or Sign execution was performed.'),indent=2)+'\n')
print(json.dumps(dict(profile=profile['contract_id'],sig_capacity=4096,nonce_bytes=40,parent_bytes=936,binding_spans=len(rows)),indent=2))
