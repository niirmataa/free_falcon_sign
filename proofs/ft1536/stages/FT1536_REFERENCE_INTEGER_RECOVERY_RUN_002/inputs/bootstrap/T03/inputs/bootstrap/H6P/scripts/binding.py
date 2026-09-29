import json,subprocess,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();subprocess.run([sys.executable,'-B','scripts/post_binding.py'],check=True,timeout=30)
post=json.loads((W/'artifacts/source_binding.json').read_text());sign=(W/'source/falcon-sign.c').read_text().splitlines(True)
(W/'checks/sampling.inc').write_text(''.join(sign[1615:1839]));(W/'checks/prerequisites.inc').write_text(sign[147]+sign[1318])
out=dict(status='PASS_ORIGINAL_MAP_AND_POST_SLICES',sampling_lines=[1616,1839],sampling_sha256=sha(W/'checks/sampling.inc'),prerequisites_sha256=sha(W/'checks/prerequisites.inc'),map_driver_sha256=sha(W/'checks/map.c'),post_binding=post,scope='standalone original ffSampling with public source-supported scripted returns and separate original suffix/rint; no do_sign or Sign',source_changed=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS_H6P_SOURCE_BINDING')
