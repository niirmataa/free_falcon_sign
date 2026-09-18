"""Kernel certificates over the existing indexed rows, without new table values."""
import hashlib,json
from pathlib import Path
W=Path.cwd();out=W/'formal/LeafData';out.mkdir(exist_ok=True)
def put(path,text):
    if path.exists():assert path.read_text()==text
    else:
        with path.open('x') as f:f.write(text)
for i in range(32):
    text=f'''import NodeArithmetic
set_option maxRecDepth 32768
set_option maxHeartbeats 30000000
namespace FT1536Forward
theorem leaf_checked_{i} : FT1536Tables.units_{i}.all leafCheck=true := by decide
#print axioms leaf_checked_{i}
end FT1536Forward
'''
    put(out/f'C{i:02}.lean',text)
text=''.join(f'import LeafData.C{i:02}\n' for i in range(32))
text+='namespace FT1536Forward\nopen FT1536Global FT1536Tables\n'
text+='theorem leaf_checked : unitRows.all leafCheck=true := by\n  simp only [unitRows,List.all_append,'+', '.join(f'leaf_checked_{i}' for i in range(32))+',Bool.and_true]\n#print axioms leaf_checked\nend FT1536Forward\n'
put(W/'formal/LeafChecks.lean',text)
data=dict(table_sha256=hashlib.sha256((W/'formal/Deps/Tables.lean').read_bytes()).hexdigest(),
          twiddles_sha256=hashlib.sha256((W/'formal/Twiddles.lean').read_bytes()).hexdigest(),
          node_arithmetic_sha256=hashlib.sha256((W/'formal/NodeArithmetic.lean').read_bytes()).hexdigest(),
          rows=1024,leaf_rows=512,nodes=1536,new_numerical_table_literals=False,
          checker='nodeCheck: root + eight actual ancestor labels + PhiZero + three actual source cubic coefficients',
          soundness='NodeArithmetic.powFast_correct/nodeCheck_sound; source lookup via inherited unitRow_id')
(W/'artifacts/leaf_binding.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps(data,indent=2))
