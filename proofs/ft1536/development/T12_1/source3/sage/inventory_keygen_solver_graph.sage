"""Pinned GCC initial-callgraph census. Inventory, not a source-execution proof."""
from pathlib import Path
import hashlib
import json
import os
import re
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile_raw = (root/'PROFILE.json').read_bytes()
profile = json.loads(profile_raw)
pins = profile['core']['source_files']
def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for name, expected in pins.items():
    assert sha(root/name) == expected, name
assert pins['falcon-keygen.c'] == '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
flags = profile['core']['Makefile_flags']
units = ['falcon-keygen.c','falcon-fft.c','fpr-emulated.c','shake.c']
records, tables = [], {}
version = subprocess.run(['gcc','--version'],capture_output=True,check=True)
Path('GCC_VERSION.txt').write_bytes(version.stdout)
for unit in units:
    stem = unit[:-2]
    command = ['gcc','-std=c99']+flags+['-fdump-ipa-cgraph','-c',str(root/unit),'-o',stem+'.o']
    result = subprocess.run(command,capture_output=True)
    Path(stem+'.stdout').write_bytes(result.stdout)
    Path(stem+'.stderr').write_bytes(result.stderr)
    assert result.returncode == 0 and not result.stdout and not result.stderr, unit
    dumps = list(Path('.').glob(stem+'.c.*.cgraph'))
    assert len(dumps) == 1, (unit,dumps)
    dump = dumps[0]
    text = dump.read_text()
    assert text.startswith('Trivially needed symbols:') or 'Initial Symbol table:' in text
    initial = text.split('Initial Symbol table:\n',1)[1].split('Removing unused symbols:',1)[0]
    blocks = re.split(r'(?m)^(?=[A-Za-z_$][\w.$]*/\d+ \()',initial)
    table = {}
    for block in blocks:
        header = re.match(r'^([\w.$]+)/\d+ \(([^\n]+)\)',block)
        if not header:
            continue
        name = header.group(1)
        if not re.search(r'(?m)^  Type: function',block):
            continue
        calls = re.search(r'(?m)^  Calls:(.*)$',block)
        assert calls, (unit,name)
        callees = re.findall(r'([\w.$]+)/\d+',calls.group(1))
        indirect = [line for line in block.splitlines() if 'Indirect call' in line]
        table[name] = {'name':name,'unit':unit,'body':bool(re.search(r'(?m)^  Function flags:.*\bbody\b',block)),
            'calls':sorted(set(callees)),'indirect_calls':indirect,
            'compiler_record_sha256':hashlib.sha256(block.encode()).hexdigest()}
    assert table and any(v['body'] for v in table.values()), unit
    tables[unit] = table
    records.append({'unit':unit,'command':command,'dump':str(dump),'dump_sha256':sha(dump),
        'stdout_sha256':sha(stem+'.stdout'),'stderr_sha256':sha(stem+'.stderr'),
        'nodes':len(table),'body_nodes':sum(v['body'] for v in table.values())})

definitions = {}
for unit, table in tables.items():
    for name,node in table.items():
        if node['body']:
            definitions.setdefault(name,[]).append(unit)

def resolve(unit,name):
    if tables[unit].get(name,{}).get('body'):
        return unit,name
    choices = definitions.get(name,[])
    assert len(choices)<=1, (unit,name,choices)
    return (choices[0],name) if choices else ('EXTERNAL',name)

def closure(roots, root_filter=None):
    pending = [resolve(unit,name) for unit,name in roots]
    reached = {}
    while pending:
        unit,name = pending.pop()
        key = unit+'::'+name
        if key in reached:
            continue
        if unit == 'EXTERNAL':
            reached[key] = {'unit':unit,'name':name,'calls':[],'semantic_status':'EXTERNAL_BODY_OPEN'}
            continue
        node = dict(tables[unit][name])
        assert node['body'] and not node['indirect_calls'], key
        selected = node['calls']
        if root_filter is not None and (unit,name)==('falcon-keygen.c','solve_NTRU'):
            assert root_filter <= set(selected), sorted(set(root_filter)-set(selected))
            node['top_M0_excluded'] = sorted(set(selected)-root_filter)
            selected = sorted(root_filter)
        links = [resolve(unit,callee) for callee in selected]
        node['calls'] = [u+'::'+n for u,n in links]
        node['semantic_status'] = 'BODY_PINNED_EXECUTION_COVERAGE_NOT_INFERRED'
        reached[key] = node
        pending.extend(links)
    assert all(c in reached for n in reached.values() for c in n['calls'])
    return reached

top_m0 = {'solve_NTRU_deepest','solve_NTRU_intermediate','solve_NTRU_ternary_depth0',
    'poly_big_to_small','modp_ninv31','modp_mkgm3','modp_set','modp_NTT3_ext','modp_montymul','modp_sub'}
whole = closure([('falcon-keygen.c','solve_NTRU')])
m0 = closure([('falcon-keygen.c','solve_NTRU')],top_m0)
sampler = closure([('falcon-keygen.c','sample_true_ternary_secret')])
assert 'falcon-keygen.c::get_rng_u64' in sampler
assert 'shake.c::shake_extract' in sampler
assert not any('prng_get' in n or 'get_rng_u32_bounded' in n for n in sampler)
for graph in [whole,m0,sampler]:
    for node in graph.values():
        if node['unit'] != 'EXTERNAL':
            node['translation_unit_sha256'] = pins[node['unit']]

result = {'status':'PASS_PINNED_COMPILER_GRAPH_INVENTORY','profile_sha256':hashlib.sha256(profile_raw).hexdigest(),
    'source_files':pins,'compiler_version_sha256':sha('GCC_VERSION.txt'),'units':records,
    'unpruned_solver':whole,'top_M0_solver_overapproximation':m0,'sampler':sampler,
    'counts':{'unpruned_solver':len(whole),'top_M0_solver_overapproximation':len(m0),'sampler':len(sampler)},
    'scope':'Initial GCC graph with all referenced bodies, macro-expanded under the pinned M0 compile flags. Node unit identifies the compiled translation unit, not necessarily the definition file: inline fpr helpers come from the separately pinned fpr-emulated.h. Top-only M0 edge selection is recorded; deeper runtime branches remain conservatively included. No graph node is declared source-execution-proved by this census. This is inventory, not a kernel parser/callgraph theorem, semantic completeness premise, execution proof, or proof of the search algorithm. GCC dump addresses and their raw hashes are run-specific.',
    'M0_outer_depths':[int(i) for i in range(9,0,-1)],
    'M0_terminal_depth':int(0),
    'remaining':'Bind complete solve_NTRU and active search/callee execution, struct reads, post-decrement while and returns; bind real sampler refill via fk->rng/get_rng_u64/shake_extract/Keccak, then original-material frames.'}
Path('SOLVER_GRAPH.json').write_text(json.dumps(result,indent=2)+'\n')
