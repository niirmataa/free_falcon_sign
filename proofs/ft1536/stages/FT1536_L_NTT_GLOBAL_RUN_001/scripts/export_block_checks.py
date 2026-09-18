"""Generate kernel checks over the exact imported word rows; no new literals."""
from pathlib import Path
parts=['import BlockExpressions\nset_option maxRecDepth 16384\nset_option maxHeartbeats 50000000\nnamespace FT1536Global\nopen FT1536Tables\n']
for i in range(32):
    parts.append(f'theorem local_checked_{i} : units_{i}.all localCheck=true := by decide\n#print axioms local_checked_{i}\n')
parts.append('theorem local_checked : unitRows.all localCheck=true := by\n  simp only [unitRows,List.all_append,'+', '.join(f'local_checked_{i}' for i in range(32))+',Bool.and_true]\n#print axioms local_checked\nend FT1536Global\n')
with Path('formal/BlockChecks.lean').open('x') as f:
    f.write(''.join(parts))
print('formal/BlockChecks.lean: 32 batches, checked source expressions over all 1024 reused rows')
