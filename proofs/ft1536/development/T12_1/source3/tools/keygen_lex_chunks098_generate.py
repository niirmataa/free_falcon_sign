#!/usr/bin/env python3
"""Emit candidate lexical-prefix proof sources; Lean checks every claim."""
from pathlib import Path
import hashlib
import json
import sys

root = Path(__file__).resolve().parents[1]
chunks_path = Path(sys.argv[1]).resolve()
tokens_path = Path(sys.argv[2]).resolve()
data = json.loads(chunks_path.read_text())
chunks = data['chunks']
tokens = json.loads(tokens_path.read_text())
assert len(chunks) == 41
outputs = []


def literal(values):
    return '[' + ', '.join(json.dumps(v, ensure_ascii=True) for v in values) + ']'


def write(name, imports, body):
    text = ''.join(f'import Source3.{m}\n' for m in imports) + '''
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

''' + f'namespace FT1536.Source3.{name}\n' + body + f'\nend FT1536.Source3.{name}\n'
    path = root / 'formal/Source3' / f'{name}.lean'
    if path.exists():
        assert path.read_text() == text, f'Different generated source: {name}'
    else:
        path.write_text(text)
    outputs.append({'path': str(path), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})


write('KeygenLexData098', ['KeygenBezoutText098'], '''
def raw : List B20.C.Token := (''' + literal(data['raw_tokens'] + ['}']) + ''' : List String).map String.toList
def tokens : List B20.C.Token := (''' + literal(tokens) + ''' : List String).map String.toList

theorem normalized : C99ArrayParser.normalizeTypes raw = tokens := by decide +kernel
''')

modules = []
refs = []
for group, start in enumerate(range(0, len(chunks), 9)):
    name = 'KeygenLexChunks098' + chr(ord('A') + group)
    modules.append(name)
    body = '''
open KeygenLexCompose098 (Prefix Chunk)
open KeygenZintCall (tokenize)
attribute [local cbv_opaque] KeygenZintCall.tokenize
'''
    for index in range(start, min(start + 9, len(chunks))):
        chunk = chunks[index]
        suffix = f'{index:02d}'
        body += f'''
def lines{suffix} : List String := (KeygenBezoutText098.lines.drop {chunk['start']}).take {chunk['count']}
def raw{suffix} : List B20.C.Token := ({literal(chunk['tokens'])} : List String).map String.toList

theorem equation{suffix} : Prefix (lines{suffix}.flatMap String.toList) raw{suffix} {chunk['steps']} := by
  intro fuel tail
'''
        if index == 0:
            body += '  exact KeygenLexPrefix098.compose fuel tail\n'
        elif not chunk['tokens']:
            body += f'''  have keep : tokenize [] (fuel + {chunk['steps']}) (lines{suffix}.flatMap String.toList ++ tail) = tokenize [] fuel tail := by cbv
  rw [keep]
  cases tokenize [] fuel tail <;> rfl
'''
        else:
            body += f'''  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [raw{suffix}]
'''
        body += f'''
theorem budget{suffix} : {chunk['steps']} ≤ (lines{suffix}.flatMap String.toList).length := by decide +kernel
def chunk{suffix} : Chunk := ⟨lines{suffix}, raw{suffix}, {chunk['steps']}, equation{suffix}, budget{suffix}⟩
'''
        refs.append(name + '.chunk' + suffix)
    write(name, ['KeygenLexCompose098'], body)

whole = 'KeygenLexCompose098.empty'
for ref in reversed(refs):
    whole = f'KeygenLexCompose098.append {ref} ({whole})'
write('KeygenLexAll098', modules + ['KeygenLexData098', 'KeygenLexFinish098'], f'''
def whole : KeygenLexCompose098.Chunk := {whole}

theorem lines_source : whole.lines = KeygenBezoutText098.lines := by decide +kernel
theorem raw_value : whole.raw ++ [['}}']] = KeygenLexData098.raw := by decide +kernel

theorem chars_value : KeygenBezoutText098.chars = KeygenLexFinish098.chars whole.lines :=
  congrArg KeygenLexFinish098.chars lines_source.symm

theorem tokens_source : KeygenZintCall.tokens KeygenBezoutText098.chars = some KeygenLexData098.tokens :=
  (congrArg KeygenZintCall.tokens chars_value).trans
    ((KeygenLexFinish098.normalized whole).trans
      (congrArg some ((congrArg C99ArrayParser.normalizeTypes raw_value).trans KeygenLexData098.normalized)))
''')

receipt = {'role': 'candidate proof-source generation; all statements require Lean acceptance',
           'inputs': [{'path': str(p), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in [chunks_path, tokens_path]],
           'outputs': outputs}
target = root / '.build/key_law088/LEX_CHUNKS_098_GENERATION_V2.json'
encoded = json.dumps(receipt, indent=2) + '\n'
if target.exists():
    assert target.read_text() == encoded
else:
    target.write_text(encoded)
print(json.dumps({'modules': len(outputs), 'prefixes': len(chunks), 'receipt': str(target)}))
