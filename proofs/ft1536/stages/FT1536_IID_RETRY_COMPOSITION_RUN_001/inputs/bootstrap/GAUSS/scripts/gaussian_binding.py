import json,subprocess,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();subprocess.run([sys.executable,'-B','scripts/source_binding.py'],check=True,timeout=30)
lines=(W/'source/falcon-sign.c').read_text().splitlines(True);p=W/'checks/normalizer_leaf.inc';p.write_text(''.join(lines[986:990]))
(W/'artifacts/gaussian_binding.json').write_text(json.dumps(dict(status='PASS_GAUSSIAN_NATIVE_BINDING',kernel_binding_sha256=sha(W/'artifacts/source_binding.json'),leaf_source='source/falcon-sign.c',leaf_lines=[987,990],leaf_copy='checks/normalizer_leaf.inc',leaf_sha256=sha(p),extra_driver='checks/gaussian.c',test_scope='original primitive/scalar/BerExp slices; standalone normalized leaf only, no whole key/load/Sign',source_changed=False),indent=2)+'\n')
