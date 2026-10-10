#!/usr/bin/env sage
# 051 scoped PUBLIC scripted controls for the six-gate certificate chronology.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or codec
# result, no private key, no probability/law claim. These finite checks detect
# mutated control/transport logic on synthetic public bytes; they supplement,
# never replace, the kernel-checked Lean proofs of batch 051.
import json
from datetime import datetime, timezone

CAP = ZZ(3000000)
WORKSPACE_BASE = ZZ(128)
WORKSPACE_BYTES = ZZ(286720)


def fresh_state():
    return {'counter': ZZ(0), 'heap': {}, 'h_ptr': ('block5', ZZ(0)), 'h_bytes': {},
            'scratch': ('block0', WORKSPACE_BASE), 'attempts': [], 'flow': None}


def gate_script(i, script):
    return script[min(i, len(script) - 1)]


def run_loop(script, cert_script, cap=CAP, counter_reset=False, cert_writes_h=False,
             skip_certificate=False, accept_without_call=False):
    st = fresh_state()
    st['called'] = True
    i = ZZ(0)
    while True:
        if i >= cap:  # cap failure BEFORE sampling of attempt cap+1
            st['flow'] = 'cap_return'
            break
        i += 1
        if counter_reset:
            st['counter'] = ZZ(12345)
        st['counter'] += 1
        gate = gate_script(i - 1, script)
        if gate != 'to_certificate':
            st['attempts'].append((i, gate))
            continue
        if skip_certificate:
            st['called'] = False
            st['attempts'].append((i, 'accepted_break'))
            st['flow'] = 'break'
            break
        accepted = bool(cert_script[min(i - 1, len(cert_script) - 1)])
        if cert_writes_h:  # mutation: certificate writes the caller h block
            for off in range(0, 8):
                st['h_bytes'][off] = ZZ(9)
        if accept_without_call:  # mutation: break although the call returned falsy
            st['called'] = False
            st['attempts'].append((i, 'accepted_break'))
            st['flow'] = 'break'
            break
        if accepted:
            st['attempts'].append((i, 'accepted_break'))
            st['flow'] = 'break'
            break
        st['attempts'].append((i, 'cert_rejected'))
    return st


def chronological_shape(st):
    if st['flow'] != 'break':
        return False
    rejected = [a for a in st['attempts'] if a[1] != 'accepted_break']
    final = [a for a in st['attempts'] if a[1] == 'accepted_break']
    if len(final) != 1 or len(st['attempts']) != len(rejected) + 1:
        return False
    if st['attempts'][-1][1] != 'accepted_break':
        return False
    numbers = [a[0] for a in st['attempts']]
    if numbers != list(range(1, len(numbers) + 1)):
        return False
    return st.get('called', True) and ZZ(len(st['attempts'])) <= CAP


def h_retained(st):
    return all(v == ZZ(0) for v in st['h_bytes'].values())


def counter_exact(st):
    return st['counter'] == ZZ(len(st['attempts']))


cases = [
    ('accepted_first', dict(script=['to_certificate'], cert_script=[True])),
    ('cert_retries_then_accept', dict(script=['to_certificate'] * 4,
                                      cert_script=[False, False, False, True])),
    ('early_gate_mix', dict(script=['resultant_reject', 'to_certificate', 'norm_reject',
                                    'to_certificate'], cert_script=[True, False, True, True])),
    ('long_reject_prefix', dict(script=['to_certificate'], cert_script=[False] * 9 + [True])),
    ('public_reject_then_accept', dict(script=['public_reject', 'to_certificate'],
                                       cert_script=[True])),
    ('solver_reject_then_accept', dict(script=['solver_reject', 'to_certificate'],
                                       cert_script=[True])),
]
mutations = {
    'reset_counter_after_sampling': dict(counter_reset=True),
    'certificate_writes_h': dict(cert_writes_h=True),
    'skip_certificate_gate': dict(skip_certificate=True),
    'accept_despite_falsy_return': dict(accept_without_call=True),
}

results = []
for name, params in cases:
    st = run_loop(**params)
    ok = chronological_shape(st) and h_retained(st) and counter_exact(st)
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, mparams in mutations.items():
        mutated = dict(params)
        mutated.update(mparams)
        stm = run_loop(**mutated)
        signature = lambda x: (x['attempts'], x['flow'], x['called'], sorted(x['h_bytes'].items()), x['counter'])
        detected = signature(stm) != signature(st)
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_CERT_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; synthetic public bytes; no real KeyGen/solver/'
                'certificate/codec result, no private key, no probability or law claim; '
                'supplements kernel proofs, never replaces them',
       'cases_per_run': len(cases), 'mutation_kinds': len(mutations),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
