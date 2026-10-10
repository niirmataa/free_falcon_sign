#!/usr/bin/env python3
"""Produce bounded kernel-checked lexical pieces from live pinned Extra/c."""
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[4]
SOURCE_SHA = '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
REGIONS = [(7781,85),(7866,10),(7876,54),(7930,19),(7949,19),
           (7968,23),(7991,29),(8020,58),(8078,15),(8093,14),
           (8107,15),(8122,14),(8136,52)]
MACROS = {'TRUE_TERNARY_SECRET':1,'TRUE_TERNARY_SECRET_MODE':1,
          'TERNARY_KEYGEN_BOUND_SCALE_NUM':1250,'TERNARY_KEYGEN_BOUND_SCALE_DEN':100,
          'TERNARY_KEYGEN_MAX_ATTEMPTS':3000000}


def preprocess(lines):
    active = True
    stack = []
    output = []
    for line in lines:
        text = line.strip()
        if not text.startswith('#'):
            if active:
                output.append(line)
            continue
        directive, *arguments = text[1:].split()
        if directive in ('ifdef','ifndef','if'):
            if directive == 'ifdef':
                test = arguments[0] in MACROS
            elif directive == 'ifndef':
                test = arguments[0] not in MACROS
            elif len(arguments) == 1:
                test = bool(MACROS[arguments[0]])
            else:
                assert arguments[1] == '!='
                lhs = MACROS[arguments[0]]
                rhs = MACROS[arguments[2]] if arguments[2] in MACROS else int(arguments[2])
                test = lhs != rhs
            stack.append((active,test))
            active = active and test
        elif directive == 'else':
            outer,test = stack[-1]
            active = outer and not test
        elif directive == 'endif':
            active,_ = stack.pop()
        else:
            raise ValueError('Unsupported generator directive: '+directive)
    assert active and not stack
    return ''.join(output)


def main():
    source = REPO/'Extra/c/falcon-keygen.c'
    assert hashlib.sha256(source.read_bytes()).hexdigest() == SOURCE_SHA
    lines = source.read_text().splitlines(keepends=True)
    header = ('import Source3.KeygenMakeSyntax\n\n'
              'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
              'set_option Elab.async false\n\n'
              '/- Generated bounded lexical pieces; each literal is checked in the kernel\n'
              '   against the complete corresponding active source region. No lexer oracle. -/\n'
              'namespace FT1536.Source3.KeygenMakeTokens\nopen B20.C (Token)\n\n')
    pieces = []
    for index,(start,count) in enumerate(REGIONS):
        text = preprocess(lines[start-1:start-1+count])
        text = re.sub(r'/\*.*?\*/|//[^\n]*',' ',text,flags=re.S)
        tokens = re.findall(r'\w+|>>=|<<=|\+\+|>>|<<|&&|\|\||[+\-*^&|=!<>]=|[^\s\w]',text)
        assert all(re.fullmatch(r'\w+|[(){}\[\];,^&|\-+*~=!<>.?:/%]+',t) for t in tokens)
        tokens = [str(MACROS[t]) if t in MACROS else t for t in tokens]
        name = 'piece'+str(index).zfill(2)
        header += 'def '+name+' : List Token := [\n'
        for offset in range(0,len(tokens),12):
            header += '  '+','.join(json.dumps(t) for t in tokens[offset:offset+12])
            header += ',\n' if offset+12<len(tokens) else '].map String.toList\n'
        header += 'theorem '+name+'_source : KeygenMakeSyntax.tokens\n'
        header += '    ((KeygenMakePreprocess.visible '+str(index)+').flatMap String.toList)=some '+name+' := by decide\n\n'
        pieces.append(name)
    header += 'def all : List Token := '+'++'.join(pieces)+'\n'
    header += 'def pieces : List (List Token) := ['+','.join(pieces)+']\n'
    header += 'theorem all_pieces : all=pieces.flatten := by simp [all,pieces,List.append_assoc]\n'
    header += '\nend FT1536.Source3.KeygenMakeTokens\n'
    directory = (ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
    assert len(sys.argv) in (1,2) and directory.is_relative_to(ROOT)
    directory.mkdir(parents=True,exist_ok=True)
    target = directory/'KeygenMakeTokens.lean'
    assert not target.exists(), 'Never replace a previous token producer'
    target.write_text(header)
    print(json.dumps({'source':str(source),'source_sha256':SOURCE_SHA,'pieces':len(pieces),
        'target':str(target),'sha256':hashlib.sha256(target.read_bytes()).hexdigest()},indent=2))


if __name__ == '__main__':
    main()
