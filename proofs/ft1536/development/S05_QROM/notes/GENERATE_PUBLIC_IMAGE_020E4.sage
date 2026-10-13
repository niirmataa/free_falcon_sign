# Public data generator. Invoke with Sage's standard preparser.
from pathlib import Path
import json, hashlib, sys
from sage.version import version as sage_version
S = Path.cwd() / 'proofs/ft1536/development/S05_QROM'
B = S / '.build/pair_machine_020/array_backend_001'
src = B / 'runs/image_export005/stdout.txt'
rows = json.loads(src.read_text())
assert len(rows) == 877
rows = [(ZZ(t),ZZ(w)) for t,w in rows]
assert all(0 <= t < 16 and 0 <= w < 2^512 for t,w in rows)
out = Path(sys.argv[1]) if len(sys.argv)>1 else S / 'formal/PublicImage020E4.lean'
assert not out.exists()
head = '''import ArenaProgram020E1

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicImage020E4
/-- Embedded public image; generation is not trusted by the equality below. -/
def cells : List SyntaxCells020E.Cell := [
'''
body = ',\n'.join('  (⟨%s,by decide +kernel⟩,BitVec.ofNat 512 %s)' % (t,w) for t,w in rows)
tail = ''']

def serial (c : SyntaxCells020E.Cell) : Nat × Nat := (c.1.val,c.2.toNat)

theorem serial_injective : Function.Injective serial := by
  intro a b h
  apply Prod.ext
  · exact Fin.ext (congrArg Prod.fst h)
  · exact BitVec.eq_of_toNat_eq (congrArg Prod.snd h)


theorem serial_binding : cells.map serial=(ArenaProgram020E1.image PairProgram020.program).map serial := by
  rfl


theorem binding : cells=ArenaProgram020E1.image PairProgram020.program :=
  (List.map_inj_right (fun _ _ h => serial_injective h)).mp serial_binding


theorem length : cells.length=877 := by rfl

end FT1536.S05.PublicImage020E4
'''
out.write_text(head+body+tail)
receipt = out.with_suffix('.generation.json')
assert not receipt.exists()
receipt.write_text(json.dumps({'status':'GENERATED_NOT_YET_KERNEL_CHECKED', 'rows':len(rows),
  'source':str(src),'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),
  'output':str(out),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
  'sage_version':str(sage_version)},indent=2)+'\n')
print('877 public cells generated; kernel equality pending')
