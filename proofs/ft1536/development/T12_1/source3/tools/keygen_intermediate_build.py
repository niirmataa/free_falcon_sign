#!/usr/bin/env python3
"""Build only new/stale modules of this intermediate closure, in dependency order."""
import json
from pathlib import Path
import re
import subprocess
import sys

import job
from keygen_intermediate_audit_source import MODULES


def main():
    assert len(sys.argv) == 2, 'Expected one unique guarded job label'
    cache = json.loads((job.BUILD / 'cache/CACHE_INDEX.json').read_text())
    selected = []
    for name in MODULES:
        module = 'Source3.' + name
        source = job.ROOT / 'formal/Source3' / (name + '.lean')
        imports = re.findall(r'^import\s+(\S+)', source.read_text(), re.M)
        current = cache.get(module)
        stale = not current or current['source_sha256'] != job.sha(source)
        stale = stale or any(dep in selected for dep in imports)
        if current:
            stale = stale or any(cache.get(dep, {}).get('artifact_sha256') != expected
                                 for dep, expected in current.get('imports', {}).items())
        if stale:
            selected.append(module)
    assert selected, 'This closure is already current; do not repeat it without a reason'
    print(json.dumps({'selected': selected}, indent=2), flush=True)
    return subprocess.run([sys.executable, '-B', str(job.ROOT / 'tools/job_when_available.py'),
                           'lean', sys.argv[1], *selected], cwd=job.ROOT).returncode


if __name__ == '__main__':
    sys.exit(main())
