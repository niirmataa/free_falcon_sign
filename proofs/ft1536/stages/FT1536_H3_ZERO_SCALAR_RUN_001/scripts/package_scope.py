"""The explicit archive boundary, shared by the one-shot seal and read-only verifier."""
from replaylib import member

TOP = (
    'AGENTS.md', 'ANALYTIC_PROOF.md', 'REPORT.md', 'RESULT.json', 'CLAIM.md',
    'OBLIGATIONS.json', 'SOURCE_MODEL_BINDING.md', 'REUSED_RESULTS.md',
    'M0_COMPATIBILITY.md', 'ERROR_LEDGER.json', 'ERROR_LEDGER.md',
    'INPUTS.sha256', 'TOOLCHAIN.txt', 'OUTPUT_SCOPE.md', 'REPLAY.md')
FOLDERS = ('source', 'inputs', 'formal', 'scripts', 'checks', 'artifacts', 'logs')

def selected_files(root):
    paths = set(TOP)
    for rel in TOP:
        member(root, rel)
    for folder in FOLDERS:
        base = root/folder
        if base.is_symlink() or not base.is_dir():
            raise ValueError('invalid scope directory '+folder)
        for p in base.rglob('*'):
            if p.is_symlink():
                raise ValueError('symlink in scope '+str(p))
            if p.is_dir():
                continue
            if not p.is_file():
                raise ValueError('non-regular scope member '+str(p))
            if p.suffix in {'.olean', '.ilean', '.pyc'}:
                continue
            paths.add(p.relative_to(root).as_posix())
    return sorted(paths)
