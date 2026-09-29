#!/usr/bin/env python3
"""Untrusted AST transport. Lean independently parses every emitted program."""
from pathlib import Path
import hashlib
import json
import os
import re

IN = Path(os.environ['P02_INPUTS']) / 'source17'
DEST = Path(os.environ['P02_DEST']) / 'build'
raw = (IN / 'fpr-emulated.h').read_bytes()
assert hashlib.sha256(raw).hexdigest() == '6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
lines = raw.decode().splitlines(keepends=True)
TYPES = {'uint64_t': 'u64', 'fpr': 'u64', 'int64_t': 'i64', 'long': 'i64', 'int': 'i32', 'uint32_t': 'u32', 'unsigned': 'u32'}
OPS = {'|': ('bor', 1), '^': ('xor', 2), '&': ('band', 3), '>>': ('shr', 4), '<<': ('shl', 4), '+': ('add', 5), '-': ('sub', 5), '*': ('mul', 6)}
lex = re.compile(r'[A-Za-z_][A-Za-z_0-9]*|0[xX][0-9A-Fa-f]+[uUlL]*|[0-9]+[uUlL]*|>>=|<<=|>>|<<|[+*\-^&|]=|[(){};,^&|=+*~\-]')


def name(s):
    return json.dumps(s) + '.toList'


class Parser:
    def __init__(self, tokens):
        self.tokens, self.pos = tokens, 0
        self.statement_entries = []

    def peek(self):
        return self.tokens[self.pos] if self.pos < len(self.tokens) else None

    def take(self, expected=None):
        token = self.peek()
        assert token is not None and (expected is None or expected == token), (expected, token, self.pos)
        self.pos += 1
        return token

    def expr(self, minimum=1):
        token = self.take()
        if token in ('-', '~'):
            left = f'.{"neg" if token == "-" else "bitNot"} ({self.expr(7)})'
        elif token == '(':
            if self.peek() in TYPES and self.tokens[self.pos + 1] == ')':
                ty = TYPES[self.take()]
                self.take(')')
                left = f'.cast .{ty} ({self.expr(7)})'
            else:
                left = self.expr()
                self.take(')')
        elif token[0].isdigit():
            m = re.fullmatch(r'(0[xX][0-9A-Fa-f]+|[0-9]+)([uUlL]*)', token)
            assert m
            digits, suffix = m.groups()
            value = int(digits, 16 if digits.lower().startswith('0x') else 10)
            if 'u' in suffix.lower():
                ty = 'u64' if 'l' in suffix.lower() or value >= 2**32 else 'u32'
            elif value < 2**31:
                ty = 'i32'
            elif digits.lower().startswith('0x') and value < 2**32:
                ty = 'u32'
            else:
                ty = 'i64' if value < 2**63 else 'u64'
            left = f'.literal .{ty} {value}'
        else:
            if self.peek() == '(':
                self.take('(')
                args = [self.expr()]
                while self.peek() == ',':
                    self.take(',')
                    args.append(self.expr())
                self.take(')')
                assert 1 <= len(args) <= 3
                left = f'.call{len(args)} {name(token)} ' + ' '.join('(' + x + ')' for x in args)
            else:
                left = f'.var {name(token)}'
        while self.peek() in OPS and OPS[self.peek()][1] >= minimum:
            operation, precedence = OPS[self.take()]
            right = self.expr(precedence + 1)
            left = f'.bin .{operation} ({left}) ({right})'
        return left

    def function(self):
        if self.peek() == 'static':
            self.take('static'); self.take('inline')
        result = TYPES[self.take()]
        function_name = self.take()
        self.take('(')
        params = []
        while self.peek() != ')':
            ty = TYPES[self.take()]
            params.append(f'(.{ty}, {name(self.take())})')
            if self.peek() != ',':
                break
            self.take(',')
        self.take(')'); self.take('{')
        self.header_tokens = self.tokens[:self.pos]
        statements = []
        while self.peek() != '}':
            statement_start = self.pos
            first = self.take()
            if first in TYPES:
                ns = [self.take()]
                while self.peek() == ',':
                    self.take(','); ns.append(self.take())
                statement = f'.declare .{TYPES[first]} [' + ', '.join(name(n) for n in ns) + ']'
            elif first == 'return':
                statement = '.ret (' + self.expr() + ')'
            else:
                op = self.take()
                expression = self.expr()
                statement = (f'.assign {name(first)} ({expression})' if op == '=' else
                             f'.update {name(first)} .{OPS[op[:-1]][0]} ({expression})')
            self.take(';')
            statements.append(statement)
            self.statement_entries.append((self.tokens[statement_start:self.pos], statement))
        self.take('}')
        assert self.peek() is None
        return '{\n  name := ' + name(function_name) + f'\n  result := .{result}\n  params := [' + ', '.join(params) + ']\n  body := [\n    ' + ',\n    '.join(statements) + '\n  ]\n}'


data = 'namespace B20.Pinned\n'
programs = 'import B20.C.Scalar\nnamespace B20.Fpr.Parsed\nopen B20.C.Scalar\n'
statement_proofs = 'import B20.C.ScalarParser\nset_option maxRecDepth 16384\nset_option maxHeartbeats 8000000\nnamespace B20.Fpr.Parsed\nopen B20.C B20.C.Scalar\n'
index = {}
for alias, start, count in [('pack', 38, 17), ('rint', 97, 18), ('floor', 116, 19), ('sub', 152, 6), ('neg', 159, 6), ('half', 166, 10), ('double', 177, 6)]:
    chosen = lines[start:start + count]
    text = ''.join(chosen)
    without_comments = re.sub(r'/\*.*?\*/|//[^\n]*', ' ', text, flags=re.S)
    matches = list(lex.finditer(without_comments))
    cursor = 0
    for m in matches:
        assert not without_comments[cursor:m.start()].strip(), without_comments[cursor:m.start()]
        cursor = m.end()
    assert not without_comments[cursor:].strip()
    tokens = [m.group() for m in matches]
    parser = Parser(tokens)
    ast = parser.function()
    for i, (chunk, stmt) in enumerate(parser.statement_entries):
        statement_proofs += f'def {alias}StmtTokens{i} : List Token := [' + ', '.join(json.dumps(t) for t in chunk) + '].map String.toList\n'
        statement_proofs += f'def {alias}Stmt{i} : Stmt := {stmt}\n'
        statement_proofs += f'theorem {alias}stmt{i} (tail : List Token) : statement ({alias}StmtTokens{i} ++ tail) = some ({alias}Stmt{i}, tail) := by rfl\n'
    data += f'def {alias}Lines : List String := [' + ', '.join(json.dumps(s) for s in chosen) + ']\n'
    data += f'def {alias}Chars : List Char := {alias}Lines.flatMap String.toList\n'
    data += f'def {alias}Tokens : List (List Char) := [' + ', '.join(json.dumps(t) for t in tokens) + '].map String.toList\n'
    programs += f'def {alias}Program : Function := ' + ast + '\n'
    index[alias] = {'start_zero_based': start, 'lines': count, 'tokens': len(tokens), 'fragment_sha256': hashlib.sha256(text.encode()).hexdigest()}
data += 'end B20.Pinned\n'
programs += 'end B20.Fpr.Parsed\n'
statement_proofs += 'end B20.Fpr.Parsed\n'
(DEST / 'ScalarSlices.lean').write_text(data)
(DEST / 'ScalarPrograms.lean').write_text(programs)
(DEST / 'ScalarStatements.lean').write_text(statement_proofs)
(DEST / 'SCALAR_TRANSPORT.json').write_text(json.dumps(index, indent=2) + '\n')
print('SCALAR_TRANSPORT', json.dumps(index, sort_keys=True))
