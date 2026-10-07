"""Generate staged source/token/initializer equalities for the RC table."""
import hashlib
import json
import os
from pathlib import Path
import re

source = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source/shake.c'
assert hashlib.sha256(source.read_bytes()).hexdigest() == 'c3e7864bf4139264f8c287053214bf869e242757bf555235da81454e40ea316a'
lines = source.read_text().splitlines(keepends=True)[int(39):int(51)]
parts = ['import Source3.ShakeExtractSource\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n\n'
         '/- Generated source/token/initializer bindings. Every equality is kernel checked. -/\n'
         'namespace FT1536.Source3.ShakeRcBinding\nopen ShakeExtractSource\n\n'
         'def rcPair (i : Fin 12) : Option (List (BitVec 64)) :=\n'
         '  (ShakeSource.sourceLines[39+i.val]?).bind (fun line =>\n'
         '    (C99ProcedureParser.tokens line.toList).bind rcInitializer)\n\n'
         'theorem bind_source (i : Fin 12) (line : String) (tokens : List B20.C.Token) (values : List (BitVec 64))\n'
         '    (hl : ShakeSource.sourceLines[39+i.val]?=some line)\n'
         '    (ht : C99ProcedureParser.tokens line.toList=some tokens)\n'
         '    (hv : rcInitializer tokens=some values) : rcPair i=some values :=\n'
         '  (congrArg (fun text : Option String => text.bind (fun s =>\n'
         '    (C99ProcedureParser.tokens s.toList).bind rcInitializer)) hl).trans\n'
         '    ((congrArg (fun ts : Option (List B20.C.Token) => ts.bind rcInitializer) ht).trans hv)\n\n']
for i,line in enumerate(lines):
    name = f'{i:02d}'
    tokens = re.findall(r'0x[0-9a-fA-F]+|,',line)
    nums = [tok for tok in tokens if tok!=',']
    assert len(nums) == int(2)
    leantokens = '['+','.join(json.dumps(t)+'.toList' for t in tokens)+']'
    values = '['+','.join(nums)+']'
    parts.append(f'theorem line{name} : ShakeSource.sourceLines[{i+int(39)}]?=some '+json.dumps(line)+' := by decide\n')
    parts.append(f'theorem tokens{name} : C99ProcedureParser.tokens '+json.dumps(line)+'.toList=\n    some '+leantokens+' := by decide\n')
    parts.append(f'theorem values{name} : rcInitializer '+leantokens+'=some '+values+' := rfl\n')
    parts.append(f'theorem list{name} : (rc.drop {int(2)*i}).take 2='+values+' := rfl\n')
    parts.append(f'theorem pair{name} : rcPair {i}=some ((rc.drop {int(2)*i}).take 2) :=\n'
        f'  (bind_source {i} _ _ _ line{name} tokens{name} values{name}).trans (congrArg some list{name}.symm)\n\n')
parts.append('theorem rc_pairs (i : Fin 12) : rcPair i=some ((rc.drop (2*i.val)).take 2) := by\n'
    '  fin_cases i\n'+''.join(f'  · exact pair{i:02d}\n' for i in range(int(12))))
parts.append('end FT1536.Source3.ShakeRcBinding\n')
target = Path('ShakeRcBinding.lean')
target.write_text(''.join(parts))
Path('SHAKE_RC_SOURCE.json').write_text(json.dumps({'input_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
    'pairs':int(len(lines)),'generated_sha256':hashlib.sha256(target.read_bytes()).hexdigest()},indent=2)+'\n')
