import difflib,json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';rows=json.loads((W/'artifacts/reuse.json').read_text())
for old,new in [('backend','literal_backend'),('half_model','half_model'),('root_model','root_model'),('node_model','node_model'),('node2_model','node2_model'),('tower_model','tower_model')]:
 src=I/'TOWER/scripts'/(old+'.py');dst=W/'scripts'/(new+'.py');assert not dst.exists();shutil.copyfile(src,dst)
 rows.append(dict(input=src.relative_to(W).as_posix(),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=True))
src=I/'TOWER/scripts/certificate.py';text=src.read_text().replace('9bd79a0179910af92457ce6db5419aa859017499a79c575fb8256b5bfc92d7a1','5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4').replace("W/'artifacts/numeric_certificate.json'","W/'artifacts/tower_numeric_certificate.json'")
dst=W/'scripts/tower_certificate.py';assert not dst.exists();dst.write_text(text)
diff=''.join(difflib.unified_diff(src.read_text().splitlines(True),text.splitlines(True),fromfile='inputs/bootstrap/TOWER/scripts/certificate.py',tofile='scripts/tower_certificate.py'))
(W/'artifacts/diffs/tower_certificate.patch').write_text(diff)
rows.append(dict(input=src.relative_to(W).as_posix(),input_sha256=sha(src),copy=dst.relative_to(W).as_posix(),sha256=sha(dst),byte_identical=False,diff='artifacts/diffs/tower_certificate.patch'))
(W/'artifacts/reuse.json').write_text(json.dumps(rows,indent=2)+'\n');print(json.dumps(dict(reuse_records=len(rows))))
