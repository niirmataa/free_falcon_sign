"""Generate small kernel-checked parse chunks for the pinned Keccak body.

This parser produces syntax only. Each result is independently compared to
the Lean rejecting parser; no generated arithmetic result is trusted.
"""
import hashlib
import json
import os
from pathlib import Path
import re

source = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source/shake.c'
assert hashlib.sha256(source.read_bytes()).hexdigest() == 'c3e7864bf4139264f8c287053214bf869e242757bf555235da81454e40ea316a'
lines = source.read_text().splitlines(keepends=True)[int(123):int(511)]
ops = {'|':('bor',int(3)), '^':('xor',int(4)), '&':('band',int(5)),
       '<<':('shl',int(8)), '>>':('shr',int(8)), '+':('add',int(9)),
       '-':('sub',int(9)), '*':('mul',int(10))}

def expression(tokens, precedence=int(1)):
    token = tokens.pop(int(0))
    if token in ('~','-'):
        lhs = '(.'+('bitNot' if token=='~' else 'neg')+' '+expression(tokens,int(11))+')'
    elif token == '(':
        lhs = expression(tokens)
        assert tokens.pop(int(0)) == ')'
    elif token.isdecimal():
        lhs = '(.literal .i32 '+token+')'
    elif tokens and tokens[int(0)] == '[':
        tokens.pop(int(0))
        index = expression(tokens)
        assert tokens.pop(int(0)) == ']'
        assert token in ('A','RC')
        lhs = '(.call1 (readName '+json.dumps(token)+'.toList) '+index+')'
    else:
        assert re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*',token)
        lhs = '(.var '+json.dumps(token)+'.toList)'
    while tokens and tokens[int(0)] in ops and ops[tokens[int(0)]][int(1)] >= precedence:
        op, level = ops[tokens.pop(int(0))]
        rhs = expression(tokens,level+int(1))
        lhs = '(.bin .'+op+' '+lhs+' '+rhs+')'
    return lhs

def statement(line):
    if not line.strip():
        return '.skip'
    tokens = re.findall(r'\w+|<<|>>|\^=|\+=|[^\s]',line)
    name = tokens.pop(int(0))
    index = None
    if tokens[int(0)] == '[':
        tokens.pop(int(0))
        index = expression(tokens)
        assert tokens.pop(int(0)) == ']'
    op = tokens.pop(int(0))
    rhs = expression(tokens)
    assert tokens == [';']
    if index is not None:
        if op != '=':
            rhs = '(.bin .'+ops[op[:-int(1)]][int(0)]+' (.call1 (readName '+json.dumps(name)+'.toList) '+index+') '+rhs+')'
        return '.store '+json.dumps(name)+'.toList '+index+' '+rhs
    if op == '=':
        return '.scalar (.assign '+json.dumps(name)+'.toList '+rhs+')'
    return '.scalar (.update '+json.dumps(name)+'.toList .'+ops[op[:-int(1)]][int(0)]+' '+rhs+')'

parts = ['import Source3.ShakeBlock\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n\n'
         '/- Generated source syntax with kernel parse equalities; see sage/generate_shake_block.sage. -/\n'
         'namespace FT1536.Source3.ShakeBlockProgram\nopen ShakeBlock\n\n']
chunks = []
for start in range(int(0),len(lines),int(8)):
    name = f'{start//int(8):02d}'
    chunks.append(name)
    fragment = lines[start:start+int(8)]
    parts.append(f'def lines{name} : List String := (ShakeSource.sourceLines.drop {start+int(123)}).take {len(fragment)}\n')
    parts.append(f'def part{name} : List Stmt := [\n  '+',\n  '.join(statement(line) for line in fragment)+'\n]\n')
    parts.append(f'theorem bound{name} : parseLines lines{name}=some part{name} := by decide\n\n')
linechain = '++'.join('lines'+name for name in chunks)+'++[]'
partchain = '++'.join('part'+name for name in chunks)+'++[]'
parts.append('theorem partition : iterationLines='+linechain+' := by decide\n')
parts.append('def steps : List Stmt := '+partchain+'\n')
parts.append('theorem instructions_bound : instructions=some steps := by\n'
             '  unfold instructions\n  rw [partition]\n'
             '  have empty : parseLines []=some [] := rfl\n'
             '  simp only [steps,parse_append,'+','.join('bound'+name for name in chunks)+',empty,Option.bind_some,Option.map_some]\n\n')
parts.append('def code : Stmt := assemble steps\n'
             'theorem source_bound : instructions.map assemble=some code := by\n'
             '  rw [instructions_bound]; rfl\n'
             'theorem writes_only_A : writesOnly "A".toList code=true := by decide\n'
             'theorem source_frame (before after : C99ArrayReference.State) (root : C99MemoryReference.ArrayPointer)\n'
             '    (binding : before.arrays "A".toList=some root) (source : Exec code before after) :\n'
             '    Frame before.heap after.heap root := memory_frame code before after root source binding writes_only_A\n\n'
             'end FT1536.Source3.ShakeBlockProgram\n')
target = Path('ShakeBlockProgram.lean')
target.write_text(''.join(parts))
Path('SHAKE_BLOCK_SOURCE.json').write_text(json.dumps({'input_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
    'chunks':int(len(chunks)),'lines':int(len(lines)),'generated_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),
    'bytes':int(target.stat().st_size)},indent=2)+'\n')
