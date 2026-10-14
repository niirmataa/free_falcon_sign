#!/usr/bin/env python3
"""Generate a full DAG/type/axiom audit using the already checked serializer."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def declarations(modules):
    names = []
    for module in modules:
        text = (ROOT / 'formal/Source3' / f'{module}.lean').read_text()
        matches = re.findall(r'^(?:noncomputable )?(?:abbrev|def|theorem|structure|inductive|instance)\s+([A-Za-z_]\w*(?:\.\w+)*)', text, re.M)
        names += [f'FT1536.Source3.{module}.{name}' for name in matches]
        if module == 'KeygenWholeCall088':
            names.append(f'FT1536.Source3.{module}.instFintypeFailure')
    return names


def main():
    audit, *modules = sys.argv[1:]
    assert modules and all(re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*', m) for m in [audit, *modules])
    names = declarations(modules)
    assert len(names) == len(set(names))
    template = (ROOT / 'formal/Source3/KeygenLaw087Audit.lean').read_text()
    template = re.sub(r'\A(?:import [^\n]+\n)+',
        ''.join('import Source3.' + m + '\n' for m in modules), template)
    template = re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
        lambda m: m[1] + '\n' + ',\n'.join('    ``' + n for n in names) + m[2], template, flags=re.S)
    path = ROOT / 'formal/Source3' / f'{audit}.lean'
    if path.exists():
        assert path.read_text() == template, 'audit source reproduction mismatch'
    else:
        with path.open('x') as f:
            f.write(template)
    print(f'{audit}: {len(names)} named mathematical declarations')


if __name__ == '__main__':
    main()
