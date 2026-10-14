#!/usr/bin/env python3
"""Audit new success results and the exact F04 types invoked by the owner."""
from pathlib import Path
import re
import keygen_whole088_audit as base

ROOT = base.ROOT
MODULES = ['KeygenSuccessMass112', 'KeygenFirstAttempt112', 'KeygenFirstMass112', 'KeygenCountTarget112']
EXTERNAL = ['FT1536.JointDecomp.samplerLaw_marginal_uniform', 'FT1536.Run2.samplerLaw', 'FT1536.Run2.replyLaw']


def names():
    return base.declarations(MODULES) + EXTERNAL


def main():
    template = (ROOT / 'formal/Source3/KeygenLaw087Audit.lean').read_text()
    template = re.sub(r'\A(?:import [^\n]+\n)+',
        ''.join('import Source3.' + module + '\n' for module in MODULES), template)
    template = re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
        lambda match: match[1] + '\n' + ',\n'.join('    ``' + name for name in names()) + match[2], template, flags=re.S)
    path = ROOT / 'formal/Source3/KeygenSuccess112Audit.lean'
    if path.exists():
        assert path.read_text() == template, 'audit source reproduction mismatch'
    else:
        with path.open('x') as stream:
            stream.write(template)
    print('KeygenSuccess112Audit:',len(names()),'declarations, including three exact F04 exports')


if __name__ == '__main__':
    main()
