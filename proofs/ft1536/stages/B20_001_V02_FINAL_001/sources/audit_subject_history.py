"""V02 organizational audit of inherited history, not a replacement for replay."""
import hashlib
import json
from pathlib import Path

W = Path(__file__).resolve().parents[1]
O = W / 'inputs/subject'


def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def load(p):
    return json.loads(p.read_text())


rows = load(O / 'EXECUTION_RECEIPTS.json')['history']['runs']
assert len(rows) == 9
steps = 0
for run in rows:
    d = O / 'evidence/prior_run' / run['id']
    receipt = load(d / 'receipt.json')
    assert receipt['exit_code'] == 0 and len(receipt['steps']) == run['steps']
    assert receipt['source_before'] == receipt['source_after']
    for name, sha in receipt['source_before'].items():
        assert digest(d/'source'/name) == sha, (run['id'], name)
    for step in receipt['steps']:
        for key in ('stdout', 'stderr'):
            assert digest(d/step[key]) == step[key+'_sha256'], (run['id'], key)
        steps += 1
assert steps == 144

overwritten = load(O / 'OVERWRITTEN_LOGS.json')
assert overwritten['count'] == len(overwritten['rows']) == 6
for item in overwritten['rows']:
    assert digest(O/item['replacement_path']) == item['expected_hash']
    assert digest(O/item['byte_identical_origin']) == item['expected_hash']
    assert digest(O/item['overwritten_path']) == item['overwritten_hash']
    assert item['overwritten_hash'] != item['expected_hash']

original_term_print = (O/'evidence/prior_run/replay_001/041.stdout').read_text()
full_term_print = (O/'replay_evidence/fresh_003/logs/042.stdout').read_text()
assert original_term_print.count('⋯') == 51
assert '⋯' not in full_term_print and '\n...\n' not in full_term_print
source = (O/'formal/AuditTermsFull.lean').read_text()
assert source.count('#print ') == 20

record = {'status': 'PASS', 'historical_runs': len(rows), 'historical_steps': steps,
          'raw_step_logs': 2*steps, 'overwritten_child_paths': 6,
          'equivalent_bytes_not_original_path_provenance': True,
          'old_final_head': 'UNRECORDED', 'historical_truncation_glyphs': 51,
          'full_supplemental_prints': 20, 'full_print_truncations': 0,
          'scope': 'binding of preserved history; not reconstruction of overwritten provenance'}
(W/'run/history_audit.json').write_text(json.dumps(record, indent=2, sort_keys=True)+'\n')
print(json.dumps(record, sort_keys=True))
