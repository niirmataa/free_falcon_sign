#!/usr/bin/env python3
"""Copy historical P02 text sources/logs without cache, secrets, binaries, or unrelated upstream input copies."""
from pathlib import Path
import hashlib,json,shutil
W=Path(__file__).resolve().parents[1];P=W.parent/'B20_001/P02/run';O=W/'output/evidence/earlier_routes'
sealed={'replay_001','freeze_scan','full_domain_001','scalar_controls_006','scalar_asan_001','word_asan_002','le_asan_002','floor_exec_014','fpr_spec_110'}
allowed={'.stdout','.stderr','.py','.lean','.json','.txt','.sage','.c','.h','.md','.sha256','.log','.jsonl','.trace'}
rows=[];skipped=[]
for folder in sorted(P.iterdir()):
    if not folder.is_dir() or folder.name in sealed:continue
    copied=0
    for p in sorted(folder.rglob('*')):
        if not p.is_file():continue
        rel=p.relative_to(folder)
        if 'inputs_incomplete' in rel.parts:continue # older copied upstream stages, not P02 attempt logs
        if p.is_symlink():skipped.append((str(p.relative_to(P)),'symlink'));continue
        if p.suffix not in allowed:continue
        b=p.read_bytes()
        if b'\0' in b[:2048]:skipped.append((str(p.relative_to(P)),'binary contents'));continue
        dest=O/folder.name/rel
        dest.parent.mkdir(parents=True,exist_ok=True)
        assert not dest.exists()
        shutil.copyfile(p,dest);dest.chmod(0o444)
        assert hashlib.sha256(dest.read_bytes()).digest()==hashlib.sha256(b).digest()
        copied+=1
    rows.append({'run':folder.name,'text_members':copied,'receipt':(O/folder.name/'receipt.json').is_file(),
                 'raw_stdout_stderr':sum(x.is_file() for x in (O/folder.name).rglob('*.stdout'))+sum(x.is_file() for x in (O/folder.name).rglob('*.stderr'))})
assert len(rows)>200
result={'schema':'P02_EARLIER_ATTEMPTS_TEXT_V1','runs':rows,'excluded_explanation':'oleans/C executables/cache, public upstream stages duplicated by input_binding_001/inputs_incomplete, binary data and non-P02 materials excluded',
        'skipped_nontext':skipped,'text_members':sum(x['text_members'] for x in rows),
        'scope':'retains raw logs and source snapshots where present; absence of historical receipt is not fabricated'}
(W/'run/FAILED_HISTORY_INDEX.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print('EARLIER_HISTORY_COPIED',len(rows),result['text_members'],'text members',flush=True)
