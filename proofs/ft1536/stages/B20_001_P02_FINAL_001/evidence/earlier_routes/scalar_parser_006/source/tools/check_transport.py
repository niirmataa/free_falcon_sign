#!/usr/bin/env python3
from pathlib import Path
import hashlib
import json
import os

root = Path(__file__).resolve().parents[1]
build = Path(os.environ['P02_DEST']) / 'build'
matches = {}
for generated, sealed in [('PinnedHeader.lean', 'Header.lean'), ('PinnedSlices.lean', 'Slices.lean')]:
    before = (root / 'B20/Pinned' / sealed).read_bytes()
    after = (build / generated).read_bytes()
    assert before == after, generated
    matches[generated] = hashlib.sha256(after).hexdigest()
(build / 'TRANSPORT_MATCH.json').write_text(json.dumps(matches, indent=2) + '\n')
print('TRANSPORT_MATCH_PASS', json.dumps(matches, sort_keys=True))
