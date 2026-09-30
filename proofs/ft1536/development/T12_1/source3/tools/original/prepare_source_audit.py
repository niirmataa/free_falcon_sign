#!/usr/bin/env python3
"""Static name extraction and receipt/source/artifact binding, no mathematics."""
import hashlib
import json
from pathlib import Path
import re

W = Path(__file__).resolve().parent.parent
FORMAL = W / 'run/formal'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    audit = FORMAL / 'Source3/ProgressAudit.lean'
    if audit.exists():
        raise ValueError('audit already exists; preserve its version and receipt')
    sources = sorted((FORMAL / 'Source3').glob('*.lean'))
    receipts = []
    for rp in sorted((W / 'run').glob('*/RECEIPTS.json')):
        for rec in json.loads(rp.read_text()):
            if rec.get('accepted') and rec.get('olean_sha256'):
                receipts.append((rp, rec))
    bindings = []
    modules = []
    names = []
    for source in sources:
        rel = source.relative_to(FORMAL)
        module = '.'.join(rel.with_suffix('').parts)
        digest = sha(source)
        product = W / 'run/devlib' / rel.with_suffix('.olean')
        candidates = [(rp, rec) for rp, rec in receipts
                      if rec.get('name') == module.replace('.', '_')
                      and rec['source_sha256'] == digest
                      and product.is_file() and rec['olean_sha256'] == sha(product)]
        if not candidates:
            raise ValueError('no accepted source/artifact receipt: ' + module)
        rp, rec = sorted(candidates, key=lambda pair: pair[1]['stop'])[-1]
        for key in ['stdout', 'stderr']:
            if sha(rp.parent / rec[key]) != rec[key + '_sha256']:
                raise ValueError('raw log mismatch')
        bindings.append({'module': module, 'source': str(source.relative_to(W)),
            'source_sha256': digest, 'artifact': str(product.relative_to(W)),
            'artifact_sha256': rec['olean_sha256'], 'receipt': str(rp.relative_to(W)),
            'receipt_sha256': sha(rp), 'log': str((rp.parent / rec['stdout']).relative_to(W))})
        modules.append(module)
        namespace = None
        for lineno, line in enumerate(source.read_text().splitlines(), 1):
            ns = re.fullmatch(r'namespace (FT1536\.Source3\.[A-Za-z0-9_.]+)', line)
            if ns:
                namespace = ns.group(1)
            decl = re.match(r'(?:(?:noncomputable|private)\s+)?(theorem|def|abbrev)\s+([\w.]+)', line)
            if decl:
                if namespace is None:
                    raise ValueError('missing namespace')
                kind, name = decl.groups()
                names.append({'name': namespace + '.' + name, 'kind': kind, 'module': module, 'line': lineno})
    body = ''.join('import ' + module + '\n' for module in modules)
    body += '\nset_option pp.universes true\nset_option pp.proofs true\n\n'
    for item in names:
        name = item['name']
        body += '#check @' + name + '\n'
        # The two source arrays are already present literally in the pinned
        # generated module, so do not duplicate half a megabyte into the log.
        if item['module'] != 'Source3.KeygenSource':
            body += '#print ' + name + '\n'
        body += '#print axioms ' + name + '\n'
    audit.write_text(body)
    result = {'status': 'CURRENT_SOURCE_ARTIFACTS_BOUND_AUDIT_PENDING',
              'modules': bindings, 'exports': names, 'export_count': len(names),
              'theorem_count': sum(x['kind'] == 'theorem' for x in names),
              'audit_source_sha256': sha(audit),
              'scope': 'Source3 local source fragments; all-KeyGen/M6 still open'}
    target = W / 'run/SOURCE3_AUDIT_INPUTS.json'
    if target.exists():
        raise ValueError('existing audit inputs')
    target.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'modules': len(bindings), 'exports': len(names),
                      'theorems': result['theorem_count'], 'audit_sha256': sha(audit)}, indent=2))


if __name__ == '__main__':
    main()
