"""Write final metadata from completed checks; do not predict post-freeze success."""
import json
from pathlib import Path
from replaylib import member, sha

W = Path.cwd()
def load(rel):
    return json.loads(member(W, rel).read_text())

a = load('artifacts/formal_audit.json')
c = load('artifacts/controls_normal.json')
p = load('artifacts/phase_controls.json')
r = load('artifacts/fresh_replay.json')
ledger = load('ERROR_LEDGER.json')
assert a['all_final_logs_clean'] and not a['B_fully_kernelized']
assert load('artifacts/controls_san.json') == c
assert r['status'] == 'FRESH_REPLAY_PASS' and r['mode'] == 'rehearsal'
assert len(r['matches']) == 95
for row in r['matches']:
    assert sha(member(W, row['path'])) == row['sha256']
flags = {k: ledger[k] for k in (
    'H3_range_proved', 'global_reachability_proved', 'sampler_law_proved',
    'baseline_source_integrated', 'source_changed', 'new_source_patch_integrated',
    'protocol_wrapper_integrated', 'owner_accepted', 'security_reduction_proved')}
out = dict(
    schema='FT1536_H3_ZERO_SCALAR_RESULT_V1',
    stage_id='FT1536_H3_ZERO_SCALAR_RUN_001',
    status=ledger['status'],
    local_A_B_C_proved=True,
    local_proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',
    source_add_error_fully_kernelized=False,
    consumer_analytic_premise_explicit=True,
    domain='All finite Word64 x with -2147483283 <= val(x) < 2147483282, including both zeros and subnormals; all integer z in [-365,366].',
    claims={
        'floor': 's_C(x) = floor(val(x)) - eps0(x), eps0 iff raw negative zero',
        'integer': 'long-to-int exact; s_C+z within signed32',
        'of': 'Exact for all signed32 inputs, integer zero maps to +0',
        'sub': 'r_C and res_C finite; exact-value absolute errors <= E_r and E_res',
        'r_delta': 'Both +0 or positive normal, values in [0,1]; endpoint1 not exclusive to -0',
        'residual': '|val(res_C)| <= 366 + 1/1048576; signed zero preserved',
        'ordered': 'Current NumericCenter precedes return/residual and next center; E_half/E_add explicit; no fault0 closeness'},
    errors=ledger['errors'],
    proof_layers=ledger['proof_layers'],
    pins={
        'base': 'cb99e67ae6f7cfa1c79be23d70c8fbfbe6874f13',
        'task_sha256': '0c039d00fdb229b909e6eee76b53ecb340a02c3c3b1b0cc3203bcf1332bf9fdd',
        'bootstrap_manifest_sha256': sha(W/'inputs/bootstrap/MANIFEST.sha256'),
        'candidate_manifest_sha256': sha(W/'inputs/bootstrap/CANDIDATE.sha256'),
        'report_sha256': sha(W/'REPORT.md'),
        'analytic_proof_sha256': sha(W/'ANALYTIC_PROOF.md')},
    checks={
        'lean_modules_including_audits': a['modules'],
        'checked_theorems': a['checked_theorems'],
        'new_theorems': a['new_theorems'],
        'all_final_lean_logs_clean': True,
        'word_patterns': c['word_patterns'],
        'inside_pairs': c['inside_pairs'],
        'outside_pairs_stopped_before_sum': c['outside_pairs_stopped_before_sum'],
        'native_normal_and_asan_ubsan': 'PASS',
        'lean_literal_native_raw_bits': 'PASS',
        'phase_transcripts': p['checked_add_transcripts'],
        'finite_checks_are_not_universal_proof': True},
    replay={
        'pre_freeze_status': r['status'],
        'semantic_matches': len(r['matches']),
        'semantic_manifest_sha256': r['semantic_manifest_sha256'],
        'protocol': 'python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256',
        'post_freeze_receipt': 'tmp/final_standard_001/REPLAY_RESULT.json',
        'post_freeze_receipt_in_outputs': False,
        'note': 'Post-freeze execution uses the final external pin. Its outcome is recorded in the fresh destination, without modifying this frozen metadata.'},
    local_A_B_C_open=[],
    open_obligations=['GLOBAL_REACHABILITY_OPEN', 'SAMPLER_LAW_CONSUMPTION_OPEN'],
    next_lemma='forall E,sk,pk,history,attempt,call,state,mu_bits,sigma_bits, Reach_call_C(E,sk,pk,history,attempt,call,state,mu_bits,sigma_bits) -> NumericCenter(mu_bits)',
    next_lemma_scope='Operational H3/M0 Reach, not a completed kernel interpreter; binder domains and complete source-prefix conditions are in REPORT section7 and the pinned H3/REACHABILITY.md.',
    **flags)
with (W/'RESULT.json').open('x') as f:
    json.dump(out, f, indent=2)
    f.write('\n')
print(json.dumps(dict(status=out['status'], report_sha256=out['pins']['report_sha256'],
                     new_theorems=a['new_theorems'], semantic_matches=len(r['matches'])), indent=2))
