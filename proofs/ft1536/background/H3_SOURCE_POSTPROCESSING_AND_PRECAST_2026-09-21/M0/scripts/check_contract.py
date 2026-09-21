"""Check the declared M0 invariants; this validator does not prove security hops."""
import copy,hashlib,json
from pathlib import Path
W=Path.cwd();P=json.loads((W/'PROFILE.json').read_text());L=json.loads((W/'HOP_LEDGER.json').read_text())
def validate(p,l):
    assert p['protocol']['sig_capacity']==4096 and p['protocol']['nonce_bytes']==40
    assert p['protocol']['nonce_separate'] and p['protocol']['variable_payload']
    assert p['protocol']['adversary_payload_cap'] is None
    assert p['protocol']['honest_compression']=='FALCON_COMP_STATIC' and p['protocol']['verify_compressions']==['NONE','STATIC']
    assert p['protocol']['source_KeyGen_attempt_cap']==3000000 and p['protocol']['source_Sign_attempt_cap']==16
    assert p['protocol']['inner_rejection_cap'] is None and p['protocol']['fresh_sign_context_per_query']
    assert not p['protocol']['external_seed_or_nonce_access']
    assert p['game']['key_count']==1 and p['game']['key_law'].startswith('K_seed[E]')
    assert p['game']['freshness'].startswith('message not among ALL') and not p['game']['time_observed']
    assert not p['game']['partial_buffer_observed'] and not p['game']['internal_failure_reason_observed']
    assert p['resources']['parameters']==['Q_s','Q_H','t','w','L'] and p['resources']['MT_targets']=='Q_H+1'
    assert not p['resources']['target_guessing_extra_factor'] and not p['resources']['concrete_security_level_selected']
    assert p['randomness']['parent_bytes_max']==40+16*56==936 and p['randomness']['chacha_key_bytes']==32
    assert p['randomness']['initialization_bytes']==32+16+8 and p['randomness']['produced_PRNG_bytes_cap'] is None
    assert p['core']['N']==1536 and p['core']['q']==18433 and p['core']['B']==2093922385 and p['core']['sigma']==768
    assert not p['status']['security_reduction_proved'] and not p['status']['H3_proved']
    assert not p['status']['source_integrated'] and not p['status']['protocol_wrapper_integrated']
    assert not p['historical_cli']['implements_M0'] and p['historical_cli']['sig_buffer']==2049
    im=l['image_contract'];assert im['divergence_numerator']=='S' and im['divergence_denominator']=='R'
    assert im['desired_probability']=='R(win)' and im['supplied_probability']=='S(win)' and im['shared_full_history_kernels_required']
    assert not l['security_reduction_proved'] and not l['H3_started'] and l['target']['status']=='TARGET_TYPE_NOT_PROVED'
    assert 'FINAL_COMPOSITION' not in l['target']['component_certificate_ids']
    assert set(l['target']['parameter_domains'])=={'gamma3','e','n','per_call_errors','event_errors','primitive_bounds','MT_bound','resource_translators'}
    required={'FRAMING','KEY_LAW','ENVIRONMENT','RNG_ROOT','RNG_PRNG56','ANALYTIC_BUDGET','H3_RANGE','PRECAST_BYTES','H3_LIKELIHOOD','H1R','FULL_GEOMETRY','CAPACITY','NORM_RETRY','ROM_FRESHNESS','IMAGE_R5T','IMAGE_KERNEL','PUBLIC_SAMPLER','ROM_PROGRAMMING','L_V_EXTRACTION','MT_ISIS','PUBLIC_XOF_H2P','FINAL_COMPOSITION'}
    assert {r['id'] for r in l['rows']}==required and len(l['rows'])==len(required)
    owners={}
    fields=['laws','direction','metric','key_law','history_quantifier','conditioning','per_call','transcript','observations','computational_cost','premises','inputs','status']
    for r in l['rows']:
        assert all(k in r and r[k] for k in fields)
        for event in r['abort_cost_owners']:
            assert event not in owners,(event,owners.get(event),r['id']);owners[event]=r['id']
        assert all(set(x)>={'id','status','requirement'} for x in r['premises'])
    rows={r['id']:r for r in l['rows']}
    assert rows['H3_RANGE']['status']=='OPEN_M1' and rows['IMAGE_KERNEL']['status']=='OPEN_M5'
    assert rows['MT_ISIS']['status']=='CRYPTO_ASSUMPTION' and rows['CAPACITY']['status']=='PROVED_M0_PINNED_COUNT_MODEL'
    assert 'TV' in rows['H1R']['metric'] and 'S_i(.|tau)||R_i' in rows['IMAGE_KERNEL']['direction']
    assert l['target']['compose_recurrence'][3].startswith('u7 = Phi_Delta(u8)')
    return owners
owners=validate(P,L)
for name,h in P['core']['source_files'].items():assert hashlib.sha256((W/'source'/name).read_bytes()).hexdigest()==h
for r in L['rows']:
    for item in r['inputs']:assert hashlib.sha256((W/item['path']).read_bytes()).hexdigest()==item['sha256'],item['path']
def expect_bad(name,mut):
    p,l=copy.deepcopy(P),copy.deepcopy(L);mut(p,l)
    try:validate(p,l)
    except AssertionError:return dict(name=name,detected=True)
    raise AssertionError('missed contract mutation '+name)
tests=[]
tests.append(expect_bad('old_capacity2049',lambda p,l:p['protocol'].update(sig_capacity=2049)))
tests.append(expect_bad('nonce39',lambda p,l:p['protocol'].update(nonce_bytes=39)))
tests.append(expect_bad('forger_cap4096',lambda p,l:p['protocol'].update(adversary_payload_cap=4096)))
tests.append(expect_bad('replace_key_law_iid',lambda p,l:p['game'].update(key_law='K_iid')))
tests.append(expect_bad('double_target_guess',lambda p,l:p['resources'].update(target_guessing_extra_factor=True)))
tests.append(expect_bad('reverse_chi_square',lambda p,l:l['image_contract'].update(divergence_numerator='R',divergence_denominator='S')))
tests.append(expect_bad('double_abort_charge',lambda p,l:next(r for r in l['rows'] if r['id']=='NORM_RETRY')['abort_cost_owners'].append('SOURCE_FAULT_OR_PRECAST_MISMATCH')))
tests.append(expect_bad('unproved_H3_as_closed',lambda p,l:next(r for r in l['rows'] if r['id']=='H3_RANGE').update(status='PROVED')))
p,l=copy.deepcopy(P),copy.deepcopy(L);p['description_noop']='whitespace/annotation only';assert validate(p,l)==owners
out=dict(status='PASS',contract_id=P['contract_id'],ledger_rows=len(L['rows']),abort_cost_owners=owners,
    mutations=tests,noop_pass=True,scope='Consistency of explicit definitions and ownership. This is NOT a proof of source-law comparisons or security reduction.')
(W/'artifacts/contract_checks.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
